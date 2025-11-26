//
//  GalleryView.swift
//  WolfApp
//
//  Created by Claude
//  Unique Redesign with Masonry Layout and Hero Animations
//

import SwiftUI

struct GalleryView: View {
    @EnvironmentObject var viewModel: WolfViewModel
    
    @State private var selectedItemId: UUID? = nil
    @State private var showDetailView = false
    @State private var startEntranceAnimation = false
    
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            BackgroundGradientView()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    AnimatedTitle(text: "Gallery")
                    
                    HStack(alignment: .top, spacing: 15) {
                        MasonryColumn(items: viewModel.galleryItems.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element },
                                      namespace: namespace,
                                      selectedItemId: $selectedItemId,
                                      showDetailView: $showDetailView,
                                      startAnimation: startEntranceAnimation,
                                      columnIndex: 0)
                        
                        MasonryColumn(items: viewModel.galleryItems.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element },
                                      namespace: namespace,
                                      selectedItemId: $selectedItemId,
                                      showDetailView: $showDetailView,
                                      startAnimation: startEntranceAnimation,
                                      columnIndex: 1)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 80)
            }
            .opacity(showDetailView ? 0 : 1)
 
            
            if let selectedId = selectedItemId, let item = viewModel.galleryItems.first(where: { $0.id == selectedId }) {
                HeroDetailView(item: item, namespace: namespace, showDetailView: $showDetailView, selectedItemId: $selectedItemId)
                    .zIndex(2)
            }
        }
        .onAppear {
            startEntranceAnimation = true
        }
    }
    

}

// MARK: - Subviews & Components

struct BackgroundGradientView: View {
    var body: some View {
        Image(.mainBg)
            .resizable()
            .ignoresSafeArea()
    }
}

struct MasonryColumn: View {
    let items: [GalleryItem]
    let namespace: Namespace.ID
    @Binding var selectedItemId: UUID?
    @Binding var showDetailView: Bool
    let startAnimation: Bool
    let columnIndex: Int
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                GalleryCardEnhanced(item: item)
                    .matchedGeometryEffect(id: item.id, in: namespace)
                    .opacity(selectedItemId == item.id ? 0 : 1)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            selectedItemId = item.id
                            showDetailView = true
                        }
                    }
                    .offset(y: startAnimation ? 0 : 100)
                    .opacity(startAnimation ? 1 : 0)
                    .animation(
                        .spring(response: 0.7, dampingFraction: 0.7)
                        .delay(Double(index) * 0.1 + Double(columnIndex) * 0.05),
                        value: startAnimation
                    )
            }
        }
    }
}

// MARK: - Enhanced Gallery Card
struct GalleryCardEnhanced: View {
    let item: GalleryItem
    let randomHeightAdjustment = CGFloat.random(in: -20...20)
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    Image(item.imageName)
                        .resizable()
                        .font(.system(size: 50))
                        .foregroundColor(.white.opacity(0.3))
                )
                .frame(height: 200 + randomHeightAdjustment)
            
            LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .frame(height: 100)
            
            VStack(alignment: .leading, spacing: 6) {
                CategoryTag(text: item.category)
                Text(item.title)
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .shadow(radius: 2)
            }
            .padding(12)
        }
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .rotation3DEffect(
            .degrees(Double.random(in: -2...2)),
            axis: (x: 0, y: 1, z: 0)
        )
    }
}

// MARK: - Hero Detail View (Overlay)
struct HeroDetailView: View {
    let item: GalleryItem
    let namespace: Namespace.ID
    @Binding var showDetailView: Bool
    @Binding var selectedItemId: UUID?
    @State private var showContent = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color(red: 0.1, green: 0.12, blue: 0.2).ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero Image Header
                    ZStack(alignment: .bottomLeading) {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                Image(item.imageName)
                                    .resizable()
                                    .font(.system(size: 100))
                                    .foregroundColor(.white.opacity(0.3))
                            )
                            .frame(height: 350)
                            .matchedGeometryEffect(id: item.id, in: namespace)
                        
                        LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                            .frame(height: 150)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            CategoryTag(text: item.category)
                            Text(item.title)
                                .font(.system(size: 32, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                        }
                        .padding(20)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 25) {
                        factBox
                        relatedStats
                        Spacer().frame(height: 50)
                    }
                    .padding(20)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 50)
                }
            }
            .ignoresSafeArea()
            
            Button {
                closeView()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
                    .shadow(radius: 5)
            }
            .opacity(showContent ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }
    
    private func closeView() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showContent = false
            showDetailView = false
            selectedItemId = nil
        }
    }
    
    // MARK: Detail Subviews
    private var factBox: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
                Text("Interesting fact")
                      .font(.custom("Chewy-Regular", size: 17))
                    .foregroundColor(.white)
            }
            
            Text(item.fact)
                   .font(.custom("Chewy-Regular", size: 16))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.1), lineWidth: 1))
        )
    }
    
    private var relatedStats: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Details")
                  .font(.custom("Chewy-Regular", size: 17))
                .foregroundColor(.white)
            
            HStack(spacing: 15) {
                DetailStatBadge(icon: "eye.fill", value: "\(Int.random(in: 500...2000))", label: "Views")
                DetailStatBadge(icon: "heart.fill", value: "\(Int.random(in: 100...900))", label: "Likes")
            }
        }
    }
}

struct CategoryTag: View {
    let text: String
    var body: some View {
        Text(text.uppercased())
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.ultraThinMaterial)
            .foregroundColor(.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}

struct DetailStatBadge: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.orange)
                Text(value)
                       .font(.custom("Chewy-Regular", size: 17))
                    .foregroundColor(.white)
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    GalleryView()
        .environmentObject(WolfViewModel())
}
