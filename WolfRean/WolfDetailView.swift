//
//  WolfDetailView.swift
//  WolfApp
//
//  Created by Claude
//

import SwiftUI

struct WolfDetailView: View {
    @EnvironmentObject var viewModel: WolfViewModel
    @Environment(\.dismiss) var dismiss
    let species: WolfSpecies
    @State private var selectedTab = 0
    @State private var showingFactSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerImage
                contentSection
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.toggleFavorite(species)
                    }
                }) {
                    Image(systemName: viewModel.isFavorite(species) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite(species) ? .red : .white)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
            }
        }
    }
    
    private var headerImage: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [species.conservationStatus.color.opacity(0.6), species.conservationStatus.color.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 300)
            
            Image(species.imageName)
                .resizable()
                .scaledToFit()
                .font(.system(size: 150))
                .foregroundColor(.white.opacity(0.3))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(species.name)
                        .font(.custom("Chewy-Regular", size: 32))
                    .foregroundColor(.white)
                
                Text(species.scientificName)
                        .font(.custom("Chewy-Regular", size: 20))
                    .italic()
                    .foregroundColor(.white.opacity(0.9))
                
                HStack {
                    Text(species.region.emoji)
                    Text(species.region.rawValue)
                           .font(.custom("Chewy-Regular", size: 15))
                }
                .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
    }
    
    private var contentSection: some View {
        VStack(spacing: 25) {
            tabSelector
            
            Group {
                if selectedTab == 0 {
                    aboutSection
                } else if selectedTab == 1 {
                    characteristicsSection
                } else {
                    factsSection
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            TabButton(title: "About view", isSelected: selectedTab == 0) {
                withAnimation { selectedTab = 0 }
            }
            TabButton(title: "Characteristics", isSelected: selectedTab == 1) {
                withAnimation { selectedTab = 1 }
            }
            TabButton(title: "Facts", isSelected: selectedTab == 2) {
                withAnimation { selectedTab = 2 }
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
        .padding(.top, 20)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            InfoCard(
            title: "Description",
            content: species.description,
            icon: "text.alignleft",
            color: .blue
            )

            InfoCard(
            title: "Habitat",
            content: species.habitat,
            icon: "tree.fill",
            color: .green
            )

            InfoCard(
            title: "Nutrition",
            content: species.diet,
            icon: "leaf.fill",
            color: .orange
            )
            
            ConservationCard(status: species.conservationStatus)
        }
    }
    
    private var characteristicsSection: some View {
        VStack(spacing: 15) {
            CharacteristicRow(
            icon: "scalemass.fill",
            label: "Weight",
            value: species.weight,
            color: .purple
            )

            CharacteristicRow(
            icon: "ruler.fill",
            label: "Body length",
            value: species.length,
            color: .blue
            )

            CharacteristicRow(
            icon: "clock.fill",
            label: "Lifespan",
            value: species.lifespan,
            color: .green
            )

            CharacteristicRow(
            icon: "location.fill",
            label: "Region",
            value: species.region.rawValue,
            color: .orange
            )
        }
    }
    
    private var factsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text ("Interesting facts")
                  .font(.custom("Chewy-Regular", size: 22))
                .padding(.bottom, 5)
            
            ForEach(Array(species.facts.enumerated()), id: \.offset) { index, fact in
                FactCard(fact: fact, number: index + 1)
            }
        }
    }
}

// MARK: - Tab Button
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                   .font(.custom("Chewy-Regular", size: 16))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color.blue : Color.clear)
                .cornerRadius(12)
        }
    }
}

// MARK: - Info Card
struct InfoCard: View {
    let title: String
    let content: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                        .font(.custom("Chewy-Regular", size: 20))
                
                Text(title)
                      .font(.custom("Chewy-Regular", size: 17))
                
                Spacer()
            }
            
            Text(content)
                   .font(.custom("Chewy-Regular", size: 16))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

// MARK: - Conservation Card
struct ConservationCard: View {
    let status: ConservationStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.shield.fill")
                    .foregroundColor(status.color)
                        .font(.custom("Chewy-Regular", size: 20))
                
                Text("Safety Status")
                      .font(.custom("Chewy-Regular", size: 17))
                
                Spacer()
            }
            
            HStack {
                Text(status.rawValue)
                    .font(.title3.weight(.bold))
                    .foregroundColor(status.color)
                
                Spacer()
                
                Circle()
                    .fill(status.color)
                    .frame(width: 12, height: 12)
            }
            
            Text(conservationDescription(for: status))
                   .font(.custom("Chewy-Regular", size: 15))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(status.color.opacity(0.1))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(status.color.opacity(0.3), lineWidth: 2)
        )
    }
    
    private func conservationDescription(for status: ConservationStatus) -> String {
        switch status {
            case .extinct:
            return "Species is completely extinct"
            case .criticallyEndangered:
            return "Critically Endangered"
            case .endangered:
            return "Endangered"
            case .vulnerable:
            return "Vulnerable"
            case .nearThreatened:
            return "Near Threatened"
            case .leastConcern:
            return "Least Concern"
        }
    }
}

// MARK: - Characteristic Row
struct CharacteristicRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                    .font(.custom("Chewy-Regular", size: 20))
                .frame(width: 30)
            
            Text(label)
                   .font(.custom("Chewy-Regular", size: 16))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body.weight(.semibold))
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

// MARK: - Fact Card
struct FactCard: View {
    let fact: String
    let number: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 40, height: 40)
                
                Text("\(number)")
                       .font(.custom("Chewy-Regular", size: 17))
                    .foregroundColor(.white)
            }
            
            Text(fact)
                   .font(.custom("Chewy-Regular", size: 16))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    NavigationView {
        WolfDetailView(species: WolfSpecies(
            name: "Gray Wolf",
            scientificName: "Canis lupus",
            description: "The gray wolf is the largest member of the canine family.",
            habitat: "Forests, tundra, mountains",
            weight: "30-80 kg",
            length: "100-160 cm",
            lifespan: "6-8 years",
            diet: "Large ungulates",
            conservationStatus: .leastConcern,
            imageName: "wolf.gray",
            facts: ["Fact 1", "Fact 2"],
            region: .europe
        ))
    }
    .environmentObject(WolfViewModel())
}
