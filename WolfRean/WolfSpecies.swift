//
//  WolfModels.swift
//  WolfApp
//
//  Created by Claude
//

import Foundation
import SwiftUI

// MARK: - Wolf Species Model
struct WolfSpecies: Identifiable, Codable {
    let id: UUID
    let name: String
    let scientificName: String
    let description: String
    let habitat: String
    let weight: String
    let length: String
    let lifespan: String
    let diet: String
    let conservationStatus: ConservationStatus
    let imageName: String
    let facts: [String]
    let region: WolfRegion
    
    init(id: UUID = UUID(), name: String, scientificName: String, description: String, habitat: String, weight: String, length: String, lifespan: String, diet: String, conservationStatus: ConservationStatus, imageName: String, facts: [String], region: WolfRegion) {
        self.id = id
        self.name = name
        self.scientificName = scientificName
        self.description = description
        self.habitat = habitat
        self.weight = weight
        self.length = length
        self.lifespan = lifespan
        self.diet = diet
        self.conservationStatus = conservationStatus
        self.imageName = imageName
        self.facts = facts
        self.region = region
    }
}

// MARK: - Conservation Status
enum ConservationStatus: String, Codable {
    case extinct = "Extinct"
    case criticallyEndangered = "Critically Endangered"
    case endangered = "Endangered"
    case vulnerable = "Vulnerable"
    case nearThreatened = "Near Threatened"
    case leastConcern = "Least Concern"
    
    var color: Color {
        switch self {
        case .extinct:
            return .black
        case .criticallyEndangered:
            return .red
        case .endangered:
            return .orange
        case .vulnerable:
            return .yellow
        case .nearThreatened:
            return .green
        case .leastConcern:
            return .blue
        }
    }
}

// MARK: - Wolf Region
enum WolfRegion: String, Codable, CaseIterable {
    case northAmerica = "North America"
    case europe = "Europe"
    case asia = "Asia"
    case arctic = "Arctic"
    case middleEast = "Middle East"
    
    var emoji: String {
        switch self {
        case .northAmerica: return "🌎"
        case .europe: return "🇪🇺"
        case .asia: return "🌏"
        case .arctic: return "❄️"
        case .middleEast: return "🏜️"
        }
    }
}

// MARK: - Quiz Question
struct QuizQuestion: Identifiable {
    let id: UUID
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let difficulty: QuizDifficulty
    
    init(id: UUID = UUID(), question: String, options: [String], correctAnswer: Int, explanation: String, difficulty: QuizDifficulty) {
        self.id = id
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.difficulty = difficulty
    }
}

enum QuizDifficulty: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}

// MARK: - Gallery Item
struct GalleryItem: Identifiable {
    let id: UUID
    let imageName: String
    let title: String
    let fact: String
    let category: String
    
    init(id: UUID = UUID(), imageName: String, title: String, fact: String, category: String) {
        self.id = id
        self.imageName = imageName
        self.title = title
        self.fact = fact
        self.category = category
    }
}

// MARK: - User Achievement
struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    var isUnlocked: Bool
    let requiredScore: Int
    
    init(id: UUID = UUID(), title: String, description: String, icon: String, isUnlocked: Bool = false, requiredScore: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.isUnlocked = isUnlocked
        self.requiredScore = requiredScore
    }
}
