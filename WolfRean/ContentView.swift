//
//  ContentView.swift
//  WolfApp
//
//  Ultra Premium Redesign - Aurora & Floating Islands
//

import SwiftUI

// MARK: - Main Content View
struct ContentView: View {
    @StateObject private var viewModel = WolfViewModel()
    @State private var selectedTab = 0
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
           
            Group {
                switch selectedTab {
                case 0: HomeView(selectedTab: $selectedTab)
                case 1: EncyclopediaView()
                case 2: QuizView()
                case 3: GalleryView()
                case 4: ProfileView()
                default: HomeView(selectedTab: $selectedTab)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomFloatingTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 20)
        }
        .environmentObject(viewModel)
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Home View Redesigned
struct HomeView: View {
    @EnvironmentObject var viewModel: WolfViewModel
    @Binding var selectedTab: Int
    
    @State private var animateHeader = false
    @State private var animateHero = false
    @State private var animateNavigation = false
    @State private var animateStats = false
    @State private var particles: [FloatingParticle] = []
    
    var body: some View {
        ZStack {
            Image(.mainBg)
                .resizable()
                .ignoresSafeArea()
            
            FloatingParticlesView(particles: $particles)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 35) {
                    HomeHeaderSection()
                        .modifier(MaterializeModifier(isPresented: animateHeader, delay: 0))
                    
                    if let firstFavorite = viewModel.favoriteSpecies.first {
                        HeroWolfCard(species: firstFavorite)
                            .modifier(MaterializeModifier(isPresented: animateHero, delay: 0.1))
                            .onTapGesture {
                                selectedTab = 1
                            }
                    } else {
                        EmptyHeroCard(selectedTab: $selectedTab)
                            .modifier(MaterializeModifier(isPresented: animateHero, delay: 0.1))
                    }
                    
                    HStack(alignment: .top, spacing: 20) {
                        NavigationIslandCard(
                            title: "",
                            subtitle: "",
                            backgroundImageName: "encyclopedia_bg",
                            sfSymbolName: "",
                            gradient: LinearGradient(colors: [.blue.opacity(0.6), .cyan.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing),
                            height: 350,
                            scale: true
                        )
                        .frame(maxWidth: .infinity)
                        .onTapGesture { selectedTab = 1 }
                        
                        VStack(spacing: 20) {
                            NavigationIslandCard(
                                title: "",
                                subtitle: "",
                                backgroundImageName: "quiz_bg",
                                sfSymbolName: "",
                                gradient: LinearGradient(colors: [.purple.opacity(0.6), .indigo.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing),
                                height: 200,
                                scale: true
                            )
                            .frame(maxWidth: .infinity)
                            .onTapGesture { selectedTab = 2 }
                            
                            NavigationIslandCard(
                                title: "",
                                subtitle: "",
                                backgroundImageName: "gallery_bg",
                                sfSymbolName: "",
                                gradient: LinearGradient(colors: [.orange.opacity(0.6), .pink.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing),
                                height: 175,
                                compact: true,
                                scale: true
                            )
                            .frame(maxWidth: .infinity)
                            .onTapGesture { selectedTab = 3 }
                        }
                    }
                    .modifier(MaterializeModifier(isPresented: animateNavigation, delay: 0.2))
                    
                    // Stats Stream
                    VStack(alignment: .leading) {
                        AnimatedTitle(text: "Your Progress")
                            .font(.custom("Chewy-Regular", size: 22))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                SlantedStatCard(icon: "star.fill", value: "\(viewModel.quizScore)", label: "Experience Points", color: .yellow)
                                SlantedStatCard(icon: "trophy.fill", value: "\(viewModel.unlockedAchievements.count)", label: "Achievements", color: .orange)
                                SlantedStatCard(icon: "heart.fill", value: "\(viewModel.favoriteSpecies.count)", label: "Favorites", color: .red)
                                SlantedStatCard(icon: "books.vertical.fill", value: "\(viewModel.wolfSpecies.count)", label: "Species Studied", color: .blue)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 15)
                           
                        }
                    }
                    .modifier(MaterializeModifier(isPresented: animateStats, delay: 0.3))
                    
                    Spacer().frame(height: 100)
                }
                .padding(.top, 80)
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            startEntranceAnimation()
            startParticleSystem()
        }
    }
    
    // MARK: - Logic
    private func startEntranceAnimation() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) { animateHeader = true }
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.15)) { animateHero = true }
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3)) { animateNavigation = true }
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.45)) { animateStats = true }
    }
    
    private func startParticleSystem() {
        guard particles.isEmpty else { return }
        for _ in 0..<20 {
            particles.append(FloatingParticle.random())
        }
    }
}


// MARK: - 1. New Aurora Background
struct AuroraBackgroundView: View {
    @State private var animateAurora = false
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.12, blue: 0.25).ignoresSafeArea()
            
            GeometryReader { geo in
                BlurredBlob(color: Color.teal.opacity(0.5), width: geo.size.width * 1.5, height: geo.size.width * 1.2)
                    .offset(x: animateAurora ? -geo.size.width * 0.5 : geo.size.width * 0.2,
                            y: animateAurora ? -geo.size.height * 0.2 : geo.size.height * 0.1)
                    .animation(.easeInOut(duration: 25).repeatForever(autoreverses: true), value: animateAurora)
                
                BlurredBlob(color: Color.indigo.opacity(0.4), width: geo.size.width * 1.2, height: geo.size.width * 1.4)
                    .offset(x: animateAurora ? geo.size.width * 0.3 : -geo.size.width * 0.4,
                            y: animateAurora ? geo.size.height * 0.5 : -geo.size.height * 0.1)
                    .animation(.easeInOut(duration: 30).repeatForever(autoreverses: true), value: animateAurora)
                
                BlurredBlob(color: Color.cyan.opacity(0.3), width: geo.size.width * 1.8, height: geo.size.width * 0.8)
                    .offset(x: animateAurora ? -geo.size.width * 0.2 : geo.size.width * 0.4,
                            y: animateAurora ? geo.size.height * 0.3 : geo.size.height * 0.6)
                    .animation(.easeInOut(duration: 20).repeatForever(autoreverses: true), value: animateAurora)
            }
        }
        .ignoresSafeArea()
        .onAppear { animateAurora = true }
    }
}

struct BlurredBlob: View {
    let color: Color
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Ellipse()
            .fill(color)
            .frame(width: width, height: height)
            .blur(radius: 100)
    }
}

// MARK: - 2. Unique Entrance Animation Modifier ("Materialization")
struct MaterializeModifier: ViewModifier {
    var isPresented: Bool
    var delay: Double
    
    func body(content: Content) -> some View {
        content
            .blur(radius: isPresented ? 0 : 20)
            .scaleEffect(isPresented ? 1 : 0.8)
            .opacity(isPresented ? 1 : 0)
            .rotation3DEffect(
                .degrees(isPresented ? 0 : 10),
                axis: (x: 1, y: 0, z: 0),
                perspective: 0.5
            )
            .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(delay), value: isPresented)
    }
}


// MARK: - 3. New Components

struct HomeHeaderSection: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome to")
                    .font(.custom("Chewy-Regular", size: 17))
                    .foregroundColor(.white.opacity(0.7))
                HStack(spacing: 8) {
                    Image(systemName: "pawprint.fill")
                           .font(.custom("Chewy-Regular", size: 22))
                        .foregroundColor(.orange)
                    Text("Wolf World")
                        .font(.custom("Chewy-Regular", size: 34))
                        .foregroundStyle(LinearGradient(colors: [.white, .orange.opacity(0.8)], startPoint: .top, endPoint: .bottom))
                }
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 50, height: 50)
                Image(systemName: "person.crop.circle")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
}

struct HeroWolfCard: View {
    let species: WolfSpecies
    @State private var isBreathing = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        colors: [species.conservationStatus.color.opacity(0.6), species.conservationStatus.color.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
            
            Image(systemName: "pawprint.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
                .foregroundColor(.white.opacity(0.05))
                .offset(x: 100, y: -30)
                .scaleEffect(isBreathing ? 1.05 : 1.0)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label("Featured View", systemImage: "star.fill")
                        .font(.custom("Chewy-Regular", size: 15))
                        .padding(8)
                        .background(.ultraThinMaterial, in: Capsule())
                        .foregroundColor(.yellow)
                    Spacer()
                }
                
                Spacer()
                
                Text(species.name)
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                
                HStack {
                    Text(species.region.emoji)
                    Text(species.region.rawValue)
                }
                   .font(.custom("Chewy-Regular", size: 15))
                .foregroundColor(.white.opacity(0.9))
                .padding(10)
                .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: 12))
            }
            .padding(25)
        }
        .frame(height: 260)
        .shadow(color: species.conservationStatus.color.opacity(0.3), radius: 20, x: 0, y: 10)
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                isBreathing = true
            }
        }
    }
}

struct EmptyHeroCard: View {
    @Binding var selectedTab: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)

                        .stroke(Color.white.opacity(0.3), style: Style.dashedStroke)
                )
            
            VStack(spacing: 15) {
                Image(systemName: "plus.magnifyingglass")
                    .font(.system(size: 50))
                    .foregroundColor(.white.opacity(0.5))
                Text("Find your favorite wolf")
                      .font(.custom("Chewy-Regular", size: 17))
                    .foregroundColor(.white)
                
                Button(action: { selectedTab = 1 }) {
                    Text("Go to the Encyclopedia")
                        .font(.subheadline.bold())
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            .padding()
        }
        .frame(height: 260)
    }
    
    struct Style {

        static var dashedStroke: StrokeStyle {
            StrokeStyle(lineWidth: 2, dash: [10, 5])
        }
    }
}

 struct NavigationIslandCard: View {
    let title: String
    let subtitle: String
    let backgroundImageName: String
    let sfSymbolName: String
    let gradient: LinearGradient
    let height: CGFloat
    var compact: Bool = false
    var scale: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
        
            Image(backgroundImageName)
                .resizable()
                .aspectRatio(contentMode: scale ? .fill : .fit)
                .frame(maxHeight: height)
                .cornerRadius(compact ? 20 : 15)
                .clipped()

            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.4)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: height * 1.0)
            .cornerRadius(compact ? 20 : 15)
     
            

            VStack(alignment: .leading, spacing: compact ? 5 : 15) {
              
                if !compact {
                    Image(systemName: sfSymbolName)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
//                    Text(title)
//                        .font(.custom("Creepster-Regular", size: compact ? 17 : 24))
//                        .foregroundColor(.white)
//                        .shadow(radius: 3)
                    
                    if !compact {
                        Text(subtitle)
                            .font(.custom("Creepster-Regular", size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .shadow(radius: 2)
                    }
                }
            }
            .padding(compact ? 15 : 25)
        }
        .frame(height: height)
        .background(
            RoundedRectangle(cornerRadius: compact ? 25 : 30)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
        )
    }
}

struct SlantedStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    private let skewValue: CGFloat = -0.2
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .transformEffect(CGAffineTransform(a: 1, b: 0, c: skewValue, d: 1, tx: 0, ty: 0))
                .frame(width: 110, height: 90)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                        .transformEffect(CGAffineTransform(a: 1, b: 0, c: skewValue, d: 1, tx: 0, ty: 0))
                )
            
            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.caption.bold())
                        .foregroundColor(color)
                    Text(value)
                          .font(.custom("Chewy-Regular", size: 20))
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }
                Text(label)
                    .font(.caption2.bold())
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.trailing, 20)
            }
            .transformEffect(CGAffineTransform(a: 1, b: 0, c: -skewValue, d: 1, tx: 0, ty: 0))
        }
        .padding(.horizontal, 5)
    }
}

// MARK: - Custom Floating Tab Bar
struct CustomFloatingTabBar: View {
    @Binding var selectedTab: Int
    @Namespace private var animationNamespace
    
    let tabs = [
        (icon: "house.fill", title: ""),
        (icon: "book.closed.fill", title: ""),
        (icon: "brain.head.profile", title: ""),
        (icon: "photo.on.rectangle.angled", title: ""),
        (icon: "person.fill", title: "")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                } label: {
                    VStack(spacing: 6) {
                        ZStack {
                            if selectedTab == index {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 60, height: 60)
                                    .matchedGeometryEffect(id: "TabBubble", in: animationNamespace)
                                    .shadow(color: .orange.opacity(0.5), radius: 10)
                            }
                            
                            Image(tabs[index].icon)
                                .resizable()
                                .frame(width: 55, height: 55)
                                .foregroundColor(selectedTab == index ? .white : .white.opacity(0.5))
                                .rotationEffect(selectedTab == index && index == 0 ? .degrees(360) : .degrees(0))
                        }
                        .frame(height: 65)
                        
//                        if selectedTab != index {
//                            Text(tabs[index].title)
//                                .font(.caption2)
//                                .foregroundColor(.white.opacity(0.5))
//                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 5)
        .background(
            Capsule()
                .fill(.ultraThinMaterial.opacity(0.9))
                .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
        )
        .padding(.horizontal, 25)
    }
}


struct FloatingParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var color: Color
    var speed: CGFloat
    
    static func random() -> FloatingParticle {
        FloatingParticle(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
            size: CGFloat.random(in: 2...6),
            opacity: Double.random(in: 0.3...0.7),
            color: [Color.white, Color.cyan.opacity(0.5), Color.orange.opacity(0.3)].randomElement()!,
            speed: CGFloat.random(in: 0.2...1.5)
        )
    }
}

struct FloatingParticlesView: View {
    @Binding var particles: [FloatingParticle]
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .opacity(particle.opacity)
                    .position(x: particle.x, y: particle.y)
                    .blur(radius: 1)
            }
        }
        .onAppear {
            animateParticles()
        }
    }
    
    private func animateParticles() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            for i in particles.indices {
                particles[i].y -= particles[i].speed
                particles[i].x += sin(particles[i].y / 50) * 0.3 
                
                if particles[i].y < -10 {
                    particles[i].y = UIScreen.main.bounds.height + 10
                    particles[i].x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
                }
            }
        }
    }
}
