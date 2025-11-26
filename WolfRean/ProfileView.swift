//
//  ProfileView.swift
//  WolfApp
//
//  Premium Redesign with Working Features
//

import SwiftUI
import StoreKit

struct ProfileView: View {
    @EnvironmentObject var viewModel: WolfViewModel
    @State private var showSettings = false
    @State private var userName = "Wolf Explorer"
    @State private var showAchievements = false
    @State private var profileScale: CGFloat = 0.8
    @State private var profileOpacity: Double = 0
    @State private var showShareSheet = false
    @State private var animateStats = false
    @State private var pulseAnimation = false
    @State private var rotateAvatar = false
    @State private var selectedStat: Int? = nil
    @State private var showAvatarPicker = false
    @State private var selectedAvatar = "wolf.1" // Default avatar, ensure it exists in Assets or is an SF Symbol
    @State private var avatarScale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium Animated Background
                premiumBackground
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        profileHeader
                            .scaleEffect(profileScale)
                            .opacity(profileOpacity)
                            .onAppear {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                    profileScale = 1.0
                                    profileOpacity = 1.0
                                }
                            }
                        
                        statsSection
                            .opacity(animateStats ? 1 : 0)
                            .offset(y: animateStats ? 0 : 20)
                            .onAppear {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                                    animateStats = true
                                }
                            }
                        
                        achievementsSection
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        
                        favoritesSection
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        
                        actionsSection
                    }
                    .padding()
                    .padding(.bottom, 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    AnimatedTitle(text: "Profile")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            showSettings = true
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .rotationEffect(.degrees(rotateAvatar ? 180 : 0))
                        }
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(isPresented: $showSettings, userName: $userName)
            }
            .sheet(isPresented: $showAchievements) {
                AchievementsView(isPresented: $showAchievements)
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(items: [generateShareText()])
            }
            .sheet(isPresented: $showAvatarPicker) {
                AvatarPickerView(isPresented: $showAvatarPicker, selectedAvatar: $selectedAvatar)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                rotateAvatar = true
            }
            // Load saved avatar
            if let savedAvatar = UserDefaults.standard.string(forKey: "selectedAvatar") {
                selectedAvatar = savedAvatar
            }
            // Load saved username
            if let savedName = UserDefaults.standard.string(forKey: "userName") {
                userName = savedName
            }
        }
        .onChange(of: selectedAvatar) { newValue in
            // Save avatar selection
            UserDefaults.standard.set(newValue, forKey: "selectedAvatar")
        }
        .onChange(of: userName) { newValue in
            // Save username
            UserDefaults.standard.set(newValue, forKey: "userName")
        }
    }
    
    // MARK: - Premium Background
    private var premiumBackground: some View {
        ZStack {
            Image(.mainBg)
                .resizable()
            .ignoresSafeArea()

            
            // Animated orbs
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.cyan.opacity(0.5), Color.cyan.opacity(0)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 180
                            )
                        )
                        .frame(width: 350, height: 350)
                        .offset(x: pulseAnimation ? -30 : 30, y: pulseAnimation ? -80 : -40)
                        .blur(radius: 60)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.purple.opacity(0.4), Color.purple.opacity(0)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)
                        .offset(x: geometry.size.width - 100, y: geometry.size.height - 150)
                        .offset(x: pulseAnimation ? 20 : -20, y: pulseAnimation ? 40 : -40)
                        .blur(radius: 50)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 20) {
            // Avatar with glow effect
            ZStack {
                // Outer glow rings
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 140 + CGFloat(index * 15), height: 140 + CGFloat(index * 15))
                        .opacity(pulseAnimation ? 0.2 : 0.6)
                        .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                        .animation(
                            .easeInOut(duration: 2)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                            value: pulseAnimation
                        )
                }
                
                // Main avatar circle with wolf image
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        avatarScale = 0.9
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            avatarScale = 1.0
                            showAvatarPicker = true
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 140, height: 140)
                            .shadow(color: .purple.opacity(0.6), radius: 20, x: 0, y: 10)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 3)
                            )
                        
                        // Wolf avatar image
                        Image(systemName: selectedAvatar)
                            .font(.system(size: 65))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                        
                        // Edit badge
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.orange, .pink],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 36, height: 36)
                                        .shadow(color: .orange.opacity(0.5), radius: 8, x: 0, y: 4)
                                    
                                    Image(systemName: "pencil")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                }
                                .offset(x: 5, y: 5)
                            }
                        }
                        .frame(width: 140, height: 140)
                    }
                }
                .scaleEffect(avatarScale)
            }
            .padding(.top, 10)
            
            // User info
            VStack(spacing: 8) {
                Text(userName)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                           .font(.custom("Chewy-Regular", size: 15))
                    
                    Text("Level: Explorer")
                           .font(.custom("Chewy-Regular", size: 15))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )
            }
            
            // Stats badges
            HStack(spacing: 16) {
                AnimatedLevelBadge(
                value: "\(viewModel.quizScore)",
                label: "Glasses",
                icon: "star.fill",
                color: .orange,
                index: 0,
                isSelected: selectedStat == 0
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        selectedStat = selectedStat == 0 ? nil : 0
                    }
                }
                
                AnimatedLevelBadge(
                value: "\(viewModel.unlockedAchievements.count)",
                label: "Awards",
                icon: "trophy.fill",
                color: .yellow,
                index: 1,
                isSelected: selectedStat == 1
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        selectedStat = selectedStat == 1 ? nil : 1
                    }
                }
                
                AnimatedLevelBadge(
                value: "\(viewModel.favoriteSpecies.count)",
                label: "Favorites",
                icon: "heart.fill",
                color: .pink,
                index: 2,
                isSelected: selectedStat == 2
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        selectedStat = selectedStat == 2 ? nil : 2
                    }
                }
            }
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.white)
                AnimatedTitle(text: "Your Progress")
                      .font(.custom("Chewy-Regular", size: 22))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 5)
            
            VStack(spacing: 16) {
                AnimatedStatisticRow(
                    icon: "book.fill",
                    title: "Species studied",
                    value: "\(viewModel.wolfSpecies.count)",
                    color: .blue,
                    delay: 0
                    )
                
                AnimatedStatisticRow(
                    icon: "checkmark.circle.fill",
                    title: "Questions Completed",
                    value: "\(viewModel.quizQuestions.count)",
                    color: .green,
                    delay: 0.1
                    )
                AnimatedStatisticRow(
                    icon: "photo.fill",
                    title: "Viewed photo",
                    value: "\(viewModel.galleryItems.count)",
                    color: .purple,
                    delay: 0.2
                    )
                
                AnimatedStatisticRow(
                    icon: "clock.fill",
                    title: "Time in app",
                    value: "12h 34m", // This should probably be dynamic as well
                    color: .orange,
                    delay: 0.3
                    )
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
            )
            .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
        }
    }
    
    // MARK: - Achievements Section
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.yellow)
                    AnimatedTitle(text: "Achievements")
                 
                          .font(.custom("Chewy-Regular", size: 22))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        showAchievements = true
                    }
                }) {
                    HStack(spacing: 4) {
                        Text("All")
                               .font(.custom("Chewy-Regular", size: 16))
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                    )
                }
            }
            .padding(.horizontal, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(viewModel.achievements.prefix(5).enumerated()), id: \.element.id) { index, achievement in
                        AnimatedAchievementCard(achievement: achievement, index: index)
                    }
                }
                .padding(.horizontal, 5)
            }
        }
    }
    
    // MARK: - Favorites Section
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.pink)
                    AnimatedTitle(text: "Selected Views")
                          .font(.custom("Chewy-Regular", size: 22))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("\(viewModel.favoriteSpecies.count)")
                      .font(.custom("Chewy-Regular", size: 17))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                    )
            }
            .padding(.horizontal, 5)
            
            if viewModel.favoriteSpecies.isEmpty {
                emptyFavoritesView
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(viewModel.favoriteSpecies.enumerated()), id: \.element.id) { index, species in
                            AnimatedFavoriteSpeciesCard(species: species, index: index)
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
        }
    }
    
    // MARK: - Empty Favorites View
    private var emptyFavoritesView: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.pink.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "heart.slash")
                    .font(.system(size: 36))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            VStack(spacing: 8) {
            Text("No favorite views")
              .font(.custom("Chewy-Regular", size: 17))
            .foregroundColor(.white)

            Text("Add views to favorites from the catalog")
               .font(.custom("Chewy-Regular", size: 15))
            .foregroundColor(.white.opacity(0.7))
            .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
        )
        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
    }
    
    // MARK: - Actions Section
    private var actionsSection: some View {
        VStack(spacing: 14) {
            AnimatedActionButton(
                icon: "square.and.arrow.up",
                title: "Share app",
                color: .blue,
                index: 0
            ) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    showShareSheet = true
                }
            }
            
            AnimatedActionButton(
            icon: "star.fill",
            title: "Rate the app",
            color: .orange,
            index: 1
            ) {
            rateApp()
            }

            AnimatedActionButton(
            icon: "info.circle",
            title: "About the app",
            color: .purple,
            index: 2
            ) {
                showAboutApp()
            }
        }
    }
    
    // MARK: - Helper Functions
    private func generateShareText() -> String {
        """
        🐺 WolfApp - Wolf Encyclopedia

        I've earned (viewModel.quizScore) points and unlocked (viewModel.unlockedAchievements.count) achievements!

        Join us and explore the amazing world of wolves! 🌟
        """
    }
    
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func showAboutApp() {
        // Show about alert
        let alert = UIAlertController(
            title: "About the app",
            message: "WolfApp v1.0.0\n\nA wolf encyclopedia with interactive quizzes and a gallery.\n\nCreated with ❤️",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
}

// MARK: - Animated Level Badge
struct AnimatedLevelBadge: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    let index: Int
    let isSelected: Bool
    
    @State private var appear = false
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 56, height: 56)
                
                Circle()
                    .stroke(color, lineWidth: 3)
                    .frame(width: 56, height: 56)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Image(systemName: icon)
                        .font(.custom("Chewy-Regular", size: 20))
                    .foregroundColor(color)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
            }
            .shadow(color: color.opacity(0.5), radius: isSelected ? 12 : 6, x: 0, y: isSelected ? 6 : 3)
            
            Text(value)
                  .font(.custom("Chewy-Regular", size: 20))
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.1)) {
                appear = true
            }
        }
    }
}

// MARK: - Animated Statistic Row
struct AnimatedStatisticRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let delay: Double
    
    @State private var appear = false
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Circle()
                    .stroke(color.opacity(0.5), lineWidth: 2)
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .foregroundColor(color)
                        .font(.custom("Chewy-Regular", size: 20))
            }
            .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
            
            Text(title)
                    .font(.custom("Chewy-Regular", size: 16))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                  .font(.custom("Chewy-Regular", size: 20))
                .foregroundColor(color)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.05))
        )
        .scaleEffect(isPressed ? 0.95 : (appear ? 1.0 : 0.8))
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay)) {
                appear = true
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Animated Achievement Card
struct AnimatedAchievementCard: View {
    let achievement: Achievement
    let index: Int
    
    @State private var appear = false
    
    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        achievement.isUnlocked ?
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [.gray.opacity(0.3), .gray.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                    .shadow(
                        color: achievement.isUnlocked ? .orange.opacity(0.6) : .clear,
                        radius: 12,
                        x: 0,
                        y: 6
                    )
                
                Image(systemName: achievement.icon)
                       .font(.custom("Chewy-Regular", size: 22))
                    .foregroundColor(achievement.isUnlocked ? .white : .gray)
            }
            
            Text(achievement.title)
                    .font(.custom("Chewy-Regular", size: 15))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 32)
        }
        .frame(width: 110)
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 6)
        .opacity(achievement.isUnlocked ? 1 : 0.7)
        .scaleEffect(appear ? 1 : 0.8)
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.1)) {
                appear = true
            }
        }
    }
}

// MARK: - Animated Favorite Species Card
struct AnimatedFavoriteSpeciesCard: View {
    let species: WolfSpecies
    let index: Int
    
    @State private var appear = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [species.conservationStatus.color.opacity(0.4), species.conservationStatus.color.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 130, height: 110)
                
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(species.name)
                       .font(.custom("Chewy-Regular", size: 16))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text(species.region.emoji)
                        .font(.caption)
                    Text(species.region.rawValue)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .frame(width: 130)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 6)
        .scaleEffect(appear ? 1 : 0.8)
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.1)) {
                appear = true
            }
        }
    }
}

// MARK: - Animated Action Button
struct AnimatedActionButton: View {
    let icon: String
    let title: String
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
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                            .font(.custom("Chewy-Regular", size: 20))
                        .foregroundColor(color)
                }
                
                Text(title)
                        .font(.custom("Chewy-Regular", size: 16))
                    .foregroundColor(.white) // Ensure the text color is set
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.05))
            )
            .scaleEffect(isPressed ? 0.95 : (appear ? 1.0 : 0.8))
            .opacity(appear ? 1 : 0)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.1)) {
                    appear = true
                }
            }
        }
    }
}

// MARK: - ShareSheet
// This is a standard UIActivityViewController wrapper for SwiftUI
struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct SettingsView: View {
    @Binding var isPresented: Bool
    @Binding var userName: String
    @State private var notificationsEnabled = true
    @State private var soundEnabled = true
    @State private var darkModeEnabled = false
    @State private var appear = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Profile").foregroundColor(.white)) {
                    HStack {
                    Text("Name")
                    Spacer()
                    TextField("Your Name", text: $userName)
                    .multilineTextAlignment(.trailing)
                    }
                    }
                    .listRowBackground(Color.white.opacity(0.1))
                    
                    Section(header: Text("Settings").foregroundColor(.white)) {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                    Toggle("Sound", isOn: $soundEnabled)
                    Toggle("Dark Theme", isOn: $darkModeEnabled)
                    }
                    .listRowBackground(Color.white.opacity(0.1))

                    Section(header: Text("Information").foregroundColor(.white)) {
                    HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                    .foregroundColor(.secondary)
                    }
                    }
                    .listRowBackground(Color.white.opacity(0.1))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done") {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isPresented = false
            }
            }
                    .foregroundColor(.white)
                }
            }
        }
        .opacity(appear ? 1 : 0)
        .scaleEffect(appear ? 1 : 0.9)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                appear = true
            }
        }
    }
}

// MARK: - Achievements View (Enhanced)
struct AchievementsView: View {
    @EnvironmentObject var viewModel: WolfViewModel
    @Binding var isPresented: Bool
    @State private var appear = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(viewModel.achievements.enumerated()), id: \.element.id) { index, achievement in
                            AchievementDetailCardEnhanced(achievement: achievement, index: index)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
            Button("Close") {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isPresented = false
            }
            }
                    .foregroundColor(.white)
                }
            }
        }
        .opacity(appear ? 1 : 0)
        .scaleEffect(appear ? 1 : 0.9)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                appear = true
            }
        }
    }
}

// MARK: - Achievement Detail Card Enhanced
struct AchievementDetailCardEnhanced: View {
    let achievement: Achievement
    let index: Int
    
    @State private var appear = false
    
    var body: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(
                        achievement.isUnlocked ?
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [.gray.opacity(0.3), .gray.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(
                        color: achievement.isUnlocked ? .orange.opacity(0.6) : .clear,
                        radius: 15,
                        x: 0,
                        y: 8
                    )
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 36))
                    .foregroundColor(achievement.isUnlocked ? .white : .gray)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(achievement.title)
                      .font(.custom("Chewy-Regular", size: 17))
                    .foregroundColor(.white)
                
                Text(achievement.description)
                       .font(.custom("Chewy-Regular", size: 15))
                    .foregroundColor(.white.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text("\(achievement.requiredScore) points")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.yellow)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.yellow.opacity(0.2))
                )
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.seal.fill")
                       .font(.custom("Chewy-Regular", size: 22))
                    .foregroundColor(.green)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
        .opacity(achievement.isUnlocked ? 1 : 0.8)
        .scaleEffect(appear ? 1 : 0.8)
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.1)) {
                appear = true
            }
        }
    }
}



#Preview {
    ProfileView()
        .environmentObject(WolfViewModel())
}
