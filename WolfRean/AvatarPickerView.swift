import Foundation
import SwiftUI

// MARK: - Avatar Picker View
struct AvatarPickerView: View {
    @Binding var isPresented: Bool
    @Binding var selectedAvatar: String
    @State private var appear = false
    @State private var selectedIndex: Int? = nil
    
    // Wolf-themed SF Symbols
    let wolfAvatars = [
        "pawprint.fill",
        "hare.fill",
        "tortoise.fill",
        "bird.fill",
        "leaf.fill",
        "flame.fill",
        "bolt.fill",
        "moon.stars.fill",
        "sun.max.fill",
        "cloud.snow.fill",
        "wind.snow",
        "mountain.2.fill",
        "tree.fill",
        "globe.americas.fill",
        "star.fill",
        "sparkles"
    ]
    
    let avatarColors: [Color] = [
        .blue, .purple, .pink, .orange, .green,
        .red, .cyan, .indigo, .mint, .teal,
        .yellow, .brown, .gray, .primary, .secondary, .accentColor
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated Background
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.4),
                        Color.blue.opacity(0.3),
                        Color.pink.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        // Preview Section
                        VStack(spacing: 16) {
                            Text("Preview")
                                  .font(.custom("Chewy-Regular", size: 17))
                                .foregroundColor(.white)
                            
                            ZStack {
                                // Animated rings
                                ForEach(0..<2) { index in
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.white.opacity(0.4), Color.white.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2
                                        )
                                        .frame(width: 120 + CGFloat(index * 20), height: 120 + CGFloat(index * 20))
                                        .scaleEffect(appear ? 1.1 : 1.0)
                                        .animation(
                                            .easeInOut(duration: 2)
                                            .repeatForever(autoreverses: true)
                                            .delay(Double(index) * 0.3),
                                            value: appear
                                        )
                                }
                                
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .purple, .pink],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                    .shadow(color: .purple.opacity(0.6), radius: 20, x: 0, y: 10)
                                
                                Image(systemName: selectedAvatar)
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                            }
                            .padding(.vertical, 20)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.ultraThinMaterial)
                        )
                        .padding(.horizontal)
                        
                        // Avatar Grid
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Select an avatar")
                                  .font(.custom("Chewy-Regular", size: 20))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(Array(wolfAvatars.enumerated()), id: \.offset) { index, avatar in
                                    AvatarOptionButton(
                                        icon: avatar,
                                        isSelected: selectedAvatar == avatar,
                                        color: avatarColors[index % avatarColors.count],
                                        index: index
                                    ) {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                            selectedAvatar = avatar
                                            selectedIndex = index
                                        }
                                        
                                        // Haptic feedback
                                        let impact = UIImpactFeedbackGenerator(style: .medium)
                                        impact.impactOccurred()
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Confirm Button
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                isPresented = false
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                        .font(.custom("Chewy-Regular", size: 20))
                                Text("Save")
                                      .font(.custom("Chewy-Regular", size: 17))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [.green, .teal],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .green.opacity(0.5), radius: 15, x: 0, y: 8)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Avatar Selection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            isPresented = false
                        }
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                appear = true
            }
        }
    }
}

// MARK: - Avatar Option Button
struct AvatarOptionButton: View {
    let icon: String
    let isSelected: Bool
    let color: Color
    let index: Int
    let action: () -> Void
    
    @State private var appear = false
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isSelected ?
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [Color.white.opacity(0.2), Color.white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isSelected ? color : Color.white.opacity(0.3),
                                lineWidth: isSelected ? 3 : 1
                            )
                    )
                    .frame(height: 80)
                    .shadow(
                        color: isSelected ? color.opacity(0.6) : .clear,
                        radius: isSelected ? 15 : 0,
                        x: 0,
                        y: isSelected ? 8 : 0
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                
                if isSelected {
                    VStack {
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 24, height: 24)
                                
                                Image(systemName: "checkmark")
                                    .font(.caption.bold())
                                    .foregroundColor(.white)
                            }
                            .offset(x: -8, y: 8)
                        }
                        Spacer()
                    }
                }
            }
        }
        .scaleEffect(isPressed ? 0.9 : (appear ? 1.0 : 0.5))
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.03)) {
                appear = true
            }
        }
    }
}
