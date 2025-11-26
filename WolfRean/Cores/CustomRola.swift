import Foundation
import SwiftUI

struct CustomRola: View {
    @State private var currentImageIndex = 0
    @State private var fadeIn = false
    private let images = ["wolf2", "wolf1"]
    
    var body: some View {
        ZStack {
            Image(.mainBg)
                .resizable()
                .ignoresSafeArea()
            
            if !images.isEmpty {
                VStack(spacing: 100) {
                    Image(images[currentImageIndex])
                        .resizable()
                        .frame(width: 380, height: 380)
                        .opacity(fadeIn ? 1 : 0)
                        .animation(.easeInOut(duration: 1), value: fadeIn)
                        .onAppear {
                            fadeIn = true
                            wolfReloadt()
                        }

                }
            }
        }
    }
    
    // MARK: - Animation Logic
    private func wolfReloadt() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                fadeIn = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                currentImageIndex = (currentImageIndex + 1) % images.count
                withAnimation(.easeInOut(duration: 1)) {
                    fadeIn = true
                }
            }
        }
    }
}

#Preview {
    CustomRola()
}
