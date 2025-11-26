//
//  QuizView.swift
//  WolfApp
//
//  Premium Redesign by Senior Designer
//

import SwiftUI

struct QuizView: View {
    @EnvironmentObject var viewModel: WolfViewModel
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int?
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var showExplanation = false
    @State private var answeredQuestions: Set<UUID> = []
    @State private var quizCompleted = false
    @State private var animateScore = false
    @State private var particles: [ParticleEffect] = []
    @State private var cardOffset: CGFloat = 0
    @State private var cardRotation: Double = 0
    @State private var showCard: Bool = false
    @State private var selectedButtonScale: [Int: CGFloat] = [:]
    @State private var pulseAnimation = false
    @State private var confettiTrigger = false
    
    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < viewModel.quizQuestions.count else { return nil }
        return viewModel.quizQuestions[currentQuestionIndex]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Advanced Animated Background
                animatedBackground
                
                // Particle System Overlay (Confetti)
                ParticleSystemView(particles: $particles)
                
                if quizCompleted {
                    completionView
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity
                        ))
                } else if let question = currentQuestion {
                    mainQuizContent(question: question)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                } else {
                    emptyStateView
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
                    Button(action: { withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) { resetQuiz() }}) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
    
    // MARK: - Animated Background
    private var animatedBackground: some View {
        ZStack {
            // Base gradient
            Image(.mainBg)
                .resizable()
                .ignoresSafeArea()
            
            // Animated orbs
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.purple.opacity(0.6), Color.purple.opacity(0)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 200
                            )
                        )
                        .frame(width: 400, height: 400)
                        .offset(x: pulseAnimation ? -50 : 50, y: pulseAnimation ? -100 : -50)
                        .blur(radius: 60)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.pink.opacity(0.5), Color.pink.opacity(0)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)
                        .offset(x: geometry.size.width - 150, y: geometry.size.height - 200)
                        .offset(x: pulseAnimation ? 30 : -30, y: pulseAnimation ? 50 : -50)
                        .blur(radius: 50)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.blue.opacity(0.4), Color.blue.opacity(0)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 180
                            )
                        )
                        .frame(width: 350, height: 350)
                        .offset(x: geometry.size.width / 2, y: geometry.size.height / 3)
                        .offset(x: pulseAnimation ? -40 : 40, y: pulseAnimation ? -60 : 60)
                        .blur(radius: 70)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
        }
    }
    
    // MARK: - Main Quiz Content
    private func mainQuizContent(question: QuizQuestion) -> some View {
        VStack(spacing: 0) {
            // Premium Score Header
            premiumScoreHeader
                .padding(.horizontal, 20)
                .padding(.top, 10)
            
            // Advanced Progress Indicator
            advancedProgressBar
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Question Card with 3D effect
                    questionCard(question: question)
                        .padding(.horizontal, 20)
                        .rotation3DEffect(
                            .degrees(cardRotation),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .offset(x: cardOffset)
                        .opacity(showCard ? 1 : 0)
                        .scaleEffect(showCard ? 1 : 0.8)
                    
                    // Answer Options with staggered animation
                    answerOptionsGrid(question: question)
                        .padding(.horizontal, 20)
                    
                    if showResult {
                        resultCard(question: question)
                            .padding(.horizontal, 20)
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .opacity
                            ))
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showCard = true
            }
        }
    }
    
    // MARK: - Premium Score Header
    private var premiumScoreHeader: some View {
        HStack(spacing: 20) {
            // Score Display
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.yellow, Color.orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: .orange.opacity(0.5), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.white)
                            .font(.custom("Chewy-Regular", size: 20))
                        .rotationEffect(.degrees(animateScore ? 360 : 0))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Glasses")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    Text("\(viewModel.quizScore)")
                          .font(.custom("Chewy-Regular", size: 22))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            // Question Counter
            HStack(spacing: 8) {
                Text("\(currentQuestionIndex + 1)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Text("/")
                        .font(.custom("Chewy-Regular", size: 20))
                    .foregroundColor(.white.opacity(0.6))
                
                Text("\(viewModel.quizQuestions.count)")
                        .font(.custom("Chewy-Regular", size: 20))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Advanced Progress Bar
    private var advancedProgressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
                    .frame(height: 12)
                
                // Progress fill with gradient
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple, Color.pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: geometry.size.width * CGFloat(currentQuestionIndex + 1) / CGFloat(viewModel.quizQuestions.count),
                        height: 12
                    )
                    .shadow(color: .purple.opacity(0.5), radius: 8, x: 0, y: 2)
                
                // Animated shimmer effect
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0), Color.white.opacity(0.3), Color.white.opacity(0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 100, height: 12)
                    .offset(x: pulseAnimation ? geometry.size.width : -100)
            }
        }
        .frame(height: 12)
    }
    
    // MARK: - Question Card
    private func questionCard(question: QuizQuestion) -> some View {
        VStack(spacing: 20) {
            // Difficulty Badge with glow
            HStack {
                Spacer()
                DifficultyBadgeEnhanced(difficulty: question.difficulty)
                Spacer()
            }
            
            // Question Text
            Text(question.question)
                .font(.custom("Chewy-Regular", size: 24))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 30)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.5), Color.white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            }
        )
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
    
    // MARK: - Answer Options Grid
    private func answerOptionsGrid(question: QuizQuestion) -> some View {
        VStack(spacing: 16) {
            ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                AnswerButtonEnhanced(
                    text: option,
                    index: index,
                    isSelected: selectedAnswer == index,
                    isCorrect: showResult ? index == question.correctAnswer : nil,
                    isWrong: showResult && selectedAnswer == index && index != question.correctAnswer,
                    scale: selectedButtonScale[index] ?? 1.0
                ) {
                    selectAnswer(index, for: question)
                }
                .disabled(showResult)
                .opacity(showCard ? 1 : 0)
                .offset(y: showCard ? 0 : 50)
                .animation(.spring(response: 0.4, dampingFraction: 0.6).delay(showCard ? Double(index) * 0.1 : 0), value: showCard)
            }
        }
    }
    
    // MARK: - Result Card
    private func resultCard(question: QuizQuestion) -> some View {
        VStack(spacing: 20) {
            // Result Status
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isCorrect ? Color.green : Color.red)
                        .frame(width: 60, height: 60)
                        .shadow(color: (isCorrect ? Color.green : Color.red).opacity(0.5), radius: 12, x: 0, y: 6)
                    
                    Image(systemName: isCorrect ? "checkmark" : "xmark")
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(isCorrect ? "Excellent!" : "Not quite")
                          .font(.custom("Chewy-Regular", size: 20))
                        .foregroundColor(.white)
                    
                    Text(isCorrect ? "Correct answer" : "Try again")
                           .font(.custom("Chewy-Regular", size: 15))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
            }
            
            // Explanation
            if showExplanation {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                                .font(.custom("Chewy-Regular", size: 20))
                        Text("Explanation")
                              .font(.custom("Chewy-Regular", size: 17))
                            .foregroundColor(.white)
                    }
                    
                    Text(question.explanation)
                           .font(.custom("Chewy-Regular", size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.2))
                )
            }
            
            // Next Button
            Button(action: nextQuestion) {
                HStack(spacing: 12) {
                    Text(currentQuestionIndex < viewModel.quizQuestions.count - 1 ? "Next Question": "Complete")
                          .font(.custom("Chewy-Regular", size: 17))
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right")
                          .font(.custom("Chewy-Regular", size: 17))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .blue.opacity(0.5), radius: 12, x: 0, y: 6)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Completion View
    private var completionView: some View {
        VStack(spacing: 32) {
            // Trophy Animation
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(animateScore ? 1.2 : 0.8)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.yellow, Color.orange],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .orange.opacity(0.5), radius: 20, x: 0, y: 10)
                    .rotationEffect(.degrees(animateScore ? 0 : -10))
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    animateScore = true
                }
            }
            
            VStack(spacing: 12) {
                Text("Quiz Completed!")
               .font(.custom("Chewy-Regular", size: 32))
                .foregroundColor(.white)

                Text("Your Result")
                .font(.custom("Chewy-Regular", size: 20))
                .foregroundColor(.white.opacity(0.8))
            }
            
            // Score Display
            Text("\(viewModel.quizScore)")
                .font(.system(size: 80, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.yellow, Color.orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .orange.opacity(0.5), radius: 20, x: 0, y: 10)
            
            // Stats Card
            VStack(spacing: 16) {
                StatRowEnhanced(
                    icon: "checkmark.circle.fill",
                    label: "Correct answers",
                    value: "\(answeredQuestions.count)",
                    color: .green
                    )

                    Divider()
                    .background(Color.white.opacity(0.3))

                    StatRowEnhanced(
                    icon: "star.fill",
                    label: "Total questions",
                    value: "\(viewModel.quizQuestions.count)",
                    color: .yellow
                )
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
            )
            .padding(.horizontal, 20)
            
            // Restart Button
            Button(action: resetQuiz) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.clockwise")
                          .font(.custom("Chewy-Regular", size: 17))
                    Text("Replay")
                          .font(.custom("Chewy-Regular", size: 17))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [Color.purple, Color.pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .purple.opacity(0.5), radius: 12, x: 0, y: 6)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 40)
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "questionmark.circle.fill")
            .font(.system(size: 80))
            .foregroundColor(.white.opacity(0.8))

            Text("No questions available")
            .font(.custom("Chewy-Regular", size: 22))
            .foregroundColor(.white)

            Text("Try later")
            .font(.custom("Chewy-Regular", size: 16))
            .foregroundColor(.white.opacity(0.7))
        }
    }
    
    // MARK: - Actions
    private func selectAnswer(_ index: Int, for question: QuizQuestion) {
        guard selectedAnswer == nil else { return }
        
        // Button press animation
        selectedButtonScale[index] = 0.95
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            selectedButtonScale[index] = 1.0
        }
        
        selectedAnswer = index
        isCorrect = viewModel.checkAnswer(questionId: question.id, selectedAnswer: index)
        
        if isCorrect {
            answeredQuestions.insert(question.id)
            
            // Trigger confetti
            triggerConfetti()
            
            // Score animation
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                animateScore = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    animateScore = false
                }
            }
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            showResult = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation {
                showExplanation = true
            }
        }
    }
    
    private func nextQuestion() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            cardOffset = -400
            cardRotation = -15
            showCard = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if currentQuestionIndex < viewModel.quizQuestions.count - 1 {
                currentQuestionIndex += 1
                selectedAnswer = nil
                showResult = false
                showExplanation = false
                
                cardOffset = 400
                cardRotation = 15
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    cardOffset = 0
                    cardRotation = 0
                    showCard = true
                }
            } else {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    quizCompleted = true
                }
            }
        }
    }
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        selectedAnswer = nil
        showResult = false
        showExplanation = false
        answeredQuestions.removeAll()
        quizCompleted = false
        animateScore = false
        showCard = false
        cardOffset = 0
        cardRotation = 0
        viewModel.resetQuiz()
        
        // Ensure particles are removed upon reset
        particles.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showCard = true
            }
        }
    }
    
    private func triggerConfetti() {
        // Clear existing particles to prevent accumulation if triggered rapidly
        particles.removeAll()
        
        for _ in 0..<30 {
            let particle = ParticleEffect(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: -50, // Start above the screen
                color: [.yellow, .orange, .pink, .purple, .blue].randomElement()!,
                size: CGFloat.random(in: 8...16),
                velocity: CGFloat.random(in: 2...5),
                rotationSpeed: Double.random(in: -0.2...0.2), // Random rotation speed
                gravity: CGFloat.random(in: 0.05...0.15) // Apply some gravity
            )
            particles.append(particle)
        }
        
        // Remove particles after some time
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            particles.removeAll()
        }
    }
}

// MARK: - Enhanced Difficulty Badge
struct DifficultyBadgeEnhanced: View {
    let difficulty: QuizDifficulty
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .font(.caption)
            Text(difficulty.rawValue)
                .font(.caption.weight(.bold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(difficulty.color.opacity(0.3))
                .overlay(
                    Capsule()
                        .stroke(difficulty.color, lineWidth: 2)
                )
        )
        .foregroundColor(difficulty.color)
        .shadow(color: difficulty.color.opacity(0.5), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Enhanced Answer Button
struct AnswerButtonEnhanced: View {
    let text: String
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool?
    let isWrong: Bool
    let scale: CGFloat
    let action: () -> Void
    
    private let letters = ["A", "B", "C", "D"]
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Letter Badge
                ZStack {
                    Circle()
                        .fill(badgeGradient)
                        .frame(width: 44, height: 44)
                        .shadow(color: badgeColor.opacity(0.5), radius: 8, x: 0, y: 4)
                    
                    Text(letters[index])
                           .font(.custom("Chewy-Regular", size: 17))
                        .foregroundColor(.white)
                }
                
                Text(text)
                        .font(.custom("Chewy-Regular", size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if let icon = statusIcon {
                    Image(systemName: icon)
                          .font(.custom("Chewy-Regular", size: 20))
                        .foregroundColor(iconColor)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(backgroundMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(borderGradient, lineWidth: 2)
                    )
            )
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
        }
        .scaleEffect(scale)
        .buttonStyle(PlainButtonStyle())
    }
    
    private var badgeGradient: LinearGradient {
        if let isCorrect = isCorrect, isCorrect {
            return LinearGradient(colors: [.green, .green.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        if isWrong {
            return LinearGradient(colors: [.red, .red.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        return LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    private var badgeColor: Color {
        if let isCorrect = isCorrect, isCorrect { return .green }
        if isWrong { return .red }
        return .blue
    }
    
    private var backgroundMaterial: Material {
        if let isCorrect = isCorrect, isCorrect { return .ultraThinMaterial }
        if isWrong { return .ultraThinMaterial }
        return .ultraThinMaterial
    }
    
    private var borderGradient: LinearGradient {
        if let isCorrect = isCorrect, isCorrect {
            return LinearGradient(colors: [.green, .green.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        if isWrong {
            return LinearGradient(colors: [.red, .red.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        if isSelected {
            return LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        return LinearGradient(colors: [.white.opacity(0.3), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    private var shadowColor: Color {
        if let isCorrect = isCorrect, isCorrect { return .green.opacity(0.5) }
        if isWrong { return .red.opacity(0.5) }
        return .black.opacity(0.2)
    }
    
    private var shadowRadius: CGFloat {
        if isCorrect == true || isWrong { return 15 }
        return 10
    }
    
    private var shadowY: CGFloat {
        if isCorrect == true || isWrong { return 8 }
        return 6
    }
    
    private var statusIcon: String? {
        if let isCorrect = isCorrect, isCorrect { return "checkmark.circle.fill" }
        if isWrong { return "xmark.circle.fill" }
        return nil
    }
    
    private var iconColor: Color {
        if isCorrect == true { return .green }
        if isWrong { return .red }
        return .clear
    }
}

// MARK: - Enhanced Stat Row
struct StatRowEnhanced: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                        .font(.custom("Chewy-Regular", size: 20))
                    .foregroundColor(color)
            }
            
            Text(label)
                   .font(.custom("Chewy-Regular", size: 16))
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
            
            Text(value)
                  .font(.custom("Chewy-Regular", size: 20))
                .foregroundColor(color)
        }
    }
}

// MARK: - Particle Effect
struct ParticleEffect: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let color: Color
    let size: CGFloat
    var velocity: CGFloat
    var rotation: Double = 0
        var rotationSpeed: Double // Added rotation speed
        var gravity: CGFloat // Added gravity
    }

    struct ParticleSystemView: View {
        @Binding var particles: [ParticleEffect]
        
        var body: some View {
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(x: particle.x, y: particle.y)
                        .rotationEffect(.degrees(particle.rotation))
                }
            }
            .onAppear {
                startAnimation()
            }
        }
        
        private func startAnimation() {
            Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
                guard !particles.isEmpty else {
                    timer.invalidate()
                    return
                }
                
                for i in particles.indices {
                    particles[i].y += particles[i].velocity
                    particles[i].velocity += particles[i].gravity
                    
                    particles[i].rotation += particles[i].rotationSpeed
                }
                particles = particles.filter { $0.y <= UIScreen.main.bounds.height + $0.size }
            }
        }
    }

    #Preview {
        QuizView()
            .environmentObject(WolfViewModel())
    }
