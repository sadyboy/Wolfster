//
//  EncyclopediaView.swift
//  WolfApp
//
//  Created by Claude
//

import SwiftUI

struct EncyclopediaView: View {
    @EnvironmentObject var viewModel: WolfViewModel
    @State private var showFilters = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(.mainBg)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    searchBar
                    regionFilter
                    speciesList
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    AnimatedTitle(text: "Encyclopedia")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search for species...", text: $viewModel.searchText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding()
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    private var regionFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(
                    title: "All",
                    isSelected: viewModel.selectedRegion == nil,
                    action: { viewModel.selectedRegion = nil }
                )
                
                ForEach(WolfRegion.allCases, id: \.self) { region in
                    FilterChip(
                        title: "\(region.emoji) \(region.rawValue)",
                        isSelected: viewModel.selectedRegion == region,
                        action: {
                            viewModel.selectedRegion = viewModel.selectedRegion == region ? nil : region
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 10)
    }
    
    private var speciesList: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(viewModel.filteredSpecies) { species in
                    NavigationLink(destination: WolfDetailView(species: species)) {
                        WolfListCard(species: species)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}
struct AnimatedTitle: View {
    let text: String
    @State private var visibleCount = 0

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, char in
                Text(String(char))
                       .font(.custom("Chewy-Regular", size: 34))
                       .foregroundStyle(LinearGradient(colors: [.white, .orange.opacity(0.8)], startPoint: .top, endPoint: .bottom))
                    .opacity(index < visibleCount ? 1 : 0)
                    .offset(x: index < visibleCount ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.25)
                            .delay(Double(index) * 0.05),
                        value: visibleCount
                    )
            }
        }
        .onAppear {
            visibleCount = text.count
        }
    }
}


// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                   .font(.custom("Chewy-Regular", size: 15))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.white)
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 3)
        }
    }
}

// MARK: - Wolf List Card
struct WolfListCard: View {
    @EnvironmentObject var viewModel: WolfViewModel
    let species: WolfSpecies
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [species.conservationStatus.color.opacity(0.3), species.conservationStatus.color.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 80, height: 80)
                
                Image(species.imageName)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(species.name)
                          .font(.custom("Chewy-Regular", size: 17))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            viewModel.toggleFavorite(species)
                        }
                    }) {
                        Image(viewModel.isFavorite(species) ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isFavorite(species) ? .red : .gray)
                                .font(.custom("Chewy-Regular", size: 20))
                    }
                }
                
                Text(species.scientificName)
                       .font(.custom("Chewy-Regular", size: 15))
                    .italic()
                    .foregroundColor(.secondary)
                
                HStack {
                    Label(species.region.rawValue, systemImage: "location.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    StatusBadge(status: species.conservationStatus)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.08), radius: 8)
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let status: ConservationStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .cornerRadius(8)
    }
}

#Preview {
    EncyclopediaView()
        .environmentObject(WolfViewModel())
}
