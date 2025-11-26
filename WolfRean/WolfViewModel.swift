//
//  WolfViewModel.swift
//  WolfApp
//
//  Created by Claude
//

import Foundation
import SwiftUI

class WolfViewModel: ObservableObject {
    @Published var wolfSpecies: [WolfSpecies] = []
    @Published var favorites: Set<UUID> = []
    @Published var quizQuestions: [QuizQuestion] = []
    @Published var galleryItems: [GalleryItem] = []
    @Published var achievements: [Achievement] = []
    @Published var quizScore: Int = 0
    @Published var selectedRegion: WolfRegion?
    @Published var searchText: String = ""
    
    init() {
        loadWolfData()
        loadQuizQuestions()
        loadGalleryItems()
        loadAchievements()
        loadFavorites()
    }
    
    // MARK: - Filtered Species
    var filteredSpecies: [WolfSpecies] {
        var species = wolfSpecies
        
        if let region = selectedRegion {
            species = species.filter { $0.region == region }
        }
        
        if !searchText.isEmpty {
            species = species.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.scientificName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return species
    }
    
    // MARK: - Favorites Management
    func toggleFavorite(_ species: WolfSpecies) {
        if favorites.contains(species.id) {
            favorites.remove(species.id)
        } else {
            favorites.insert(species.id)
        }
        saveFavorites()
    }
    
    func isFavorite(_ species: WolfSpecies) -> Bool {
        favorites.contains(species.id)
    }
    
    var favoriteSpecies: [WolfSpecies] {
        wolfSpecies.filter { favorites.contains($0.id) }
    }
    
    // MARK: - Quiz Management
    func checkAnswer(questionId: UUID, selectedAnswer: Int) -> Bool {
        guard let question = quizQuestions.first(where: { $0.id == questionId }) else {
            return false
        }
        
        let isCorrect = selectedAnswer == question.correctAnswer
        if isCorrect {
            quizScore += 10
            checkAchievements()
        }
        return isCorrect
    }
    
    func resetQuiz() {
        quizScore = 0
    }
    
    // MARK: - Achievements
    private func checkAchievements() {
        for index in achievements.indices {
            if !achievements[index].isUnlocked && quizScore >= achievements[index].requiredScore {
                achievements[index].isUnlocked = true
                saveAchievements()
            }
        }
    }
    
    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isUnlocked }
    }
    
    // MARK: - Data Persistence
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(Array(favorites)) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode([UUID].self, from: data) {
            favorites = Set(decoded)
        }
    }
    
    private func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: "achievements")
        }
    }
    
    private func loadAchievementsFromStorage() {
        if let data = UserDefaults.standard.data(forKey: "achievements"),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        }
    }
    
    // MARK: - Sample Data Loading
    private func loadWolfData() {
        wolfSpecies = [
            WolfSpecies(
                name: "Gray Wolf",
                scientificName: "Canis lupus",
                description: "The gray wolf is the largest member of the canine family. It is a social animal that lives and hunts in packs. It has a high level of intelligence and a complex hierarchical pack structure.",
                habitat: "Forests, tundra, mountains, steppes",
                weight: "30-80 kg",
                length: "100-160 cm",
                lifespan: "6-8 years (wild), up to 16 years (in captivity)",
                diet: "Large ungulates, rodents, fish",
                conservationStatus: .leastConcern,
                imageName: "wolf.gray",
                facts: [
                    "They can reach speeds of up to 60 km/h",
                    "Their howl can be heard up to 10 km away",
                    "A pack usually consists of 5-10 individuals",
                    "They can smell up to 1000 m away 2 km"
                ],
                region: .europe
            ),
            WolfSpecies(
                name: "Arctic wolf",
                scientificName: "Canis lupus arctos",
                description: "A subspecies of gray wolf adapted to life in the extreme Arctic conditions. It has thick white fur and short ears to conserve heat.",
                habitat: "Arctic tundra",
                weight: "45-70 kg",
                length: "90-150 cm",
                lifespan: "7-10 years",
                diet: "Muskox, caribou, hares",
                conservationStatus: .leastConcern,
                imageName: "wolf.arctic",
                facts: [
                    "They can withstand temperatures down to -70°C",
                    "Their white fur helps camouflage them in the snow",
                    "They hunt in packs of up to 20 individuals",
                    "They can go without food for several weeks"
                ],
                region: .arctic
            ),
            WolfSpecies(
                name: "Red Wolf",
                scientificName: "Canis rufus",
                description: "A rare wolf species with reddish-brown fur. Smaller than the gray wolf, it is endangered.",
                habitat: "Forests, swamps",
                weight: "20-35 kg",
                length: "95-120 cm",
                lifespan: "6-7 years",
                diet: "Deer, raccoons, rabbits",
                conservationStatus: .criticallyEndangered,
                imageName: "wolf.red",
                facts: [
                    "Fewer than 20 individuals remain in the wild",
                    "Active captive breeding programs",
                    "Smaller and slimmer than the gray wolf",
                    "Hunt in small family groups"
                ],
                region: .northAmerica
            ),
            WolfSpecies(
                name: "Ethiopian wolf",
                scientificName: "Canis simensis",
                description: "The rarest canid, found only in the highlands of Ethiopia. It has long, red fur and a narrow muzzle.",
                habitat: "Afroalpine grasslands",
                weight: "11-20 kg",
                length: "84-100 cm",
                lifespan: "8-10 years",
                diet: "Rodents (90% of diet)",
                conservationStatus: .endangered,
                imageName: "wolf.ethiopian",
                facts: [
                    "About 500 individuals remain",
                    "Live at altitudes of 3,000-4,500 meters",
                    "Specialize in hunting rodents",
                    "Form large packs of up to 13 individuals"
                ],
                region: .middleEast
            ),
            WolfSpecies(
                name: "Tundra wolf",
                scientificName: "Canis lupus albus",
                description: "A large subspecies of gray wolf with light fur. Found in the northern regions of Russia and Scandinavia.",
                habitat: "Tundra, forest-tundra",
                weight: "40-85 kg",
                length: "110-160 cm",
                lifespan: "7-12 years",
                diet: "Reindeer, moose, hares",
                conservationStatus: .leastConcern,
                imageName: "wolf.tundra",
                facts: [
                    "One of the largest wolf subspecies",
                    "Thick fur protects from frost",
                    "Migrates following herds of reindeer",
                    "Can travel up to 100 km per day"
                ],
                region: .asia
            ),
            WolfSpecies(
                name: "Mexican Wolf",
                scientificName: "Canis lupus baileyi",
                description: "The smallest subspecies of gray wolf. It was completely exterminated in the wild, but has been restored through breeding programs.",
                habitat: "Mountain forests, deserts",
                weight: "25-45 kg",
                length: "130-150 cm",
                lifespan: "6-8 years",
                diet: "Deer, peccaries, rabbits",
                conservationStatus: .endangered,
                imageName: "wolf.mexican",
                facts: [
                    "Declared extinct in the wild in 1980",
                    "Reintroduction began in 1998",
                    "Currently there are about 200 individuals in the wild",
                    "The rarest subspecies of gray wolf in North America"
                ],
                region: .northAmerica
            )
        ]
    }
    
    private func loadQuizQuestions() {
        quizQuestions = [
            QuizQuestion(
                question: "What is the primary prey of gray wolves in most regions?",
                options: ["Deer", "Rabbits", "Fish", "Insects"],
                correctAnswer: 0,
                explanation: "Gray wolves primarily hunt large ungulates such as deer, elk, and moose.",
                difficulty: .easy
            ),
            QuizQuestion(
                question: "How far can a wolf travel in a single day while hunting?",
                options: ["5 km", "10 km", "30 km", "60 km"],
                correctAnswer: 3,
                explanation: "Wolves are endurance hunters and can travel up to 60 km in a single day.",
                difficulty: .medium
            ),
            QuizQuestion(
                question: "What is the strongest sense wolves rely on when hunting?",
                options: ["Sight", "Hearing", "Smell", "Touch"],
                correctAnswer: 2,
                explanation: "A wolf’s sense of smell is its most powerful sense and crucial for tracking prey.",
                difficulty: .easy
            ),
            QuizQuestion(
                question: "How long can a wolf’s howl travel under ideal conditions?",
                options: ["1 km", "5 km", "10 km", "15 km"],
                correctAnswer: 2,
                explanation: "A wolf’s howl can travel up to 10 km depending on terrain and air density.",
                difficulty: .medium
            ),
            QuizQuestion(
                question: "Which continent has no wild wolf populations?",
                options: ["Asia", "Europe", "Africa", "Australia"],
                correctAnswer: 3,
                explanation: "Australia has no native wolf species; wolves evolved in the Northern Hemisphere.",
                difficulty: .easy
            ),
            QuizQuestion(
                question: "What is the average gestation period of a wolf?",
                options: ["30 days", "45 days", "63 days", "90 days"],
                correctAnswer: 2,
                explanation: "Wolf gestation lasts about 63 days, similar to domestic dogs.",
                difficulty: .medium
            ),
            QuizQuestion(
                question: "How many pups are usually born in a wolf litter?",
                options: ["1-2", "3-4", "4-6", "7-10"],
                correctAnswer: 2,
                explanation: "Most wolf litters consist of 4–6 pups, depending on food availability.",
                difficulty: .easy
            ),
            QuizQuestion(
                question: "What is the leading cause of death for wild wolves?",
                options: ["Disease", "Starvation", "Predation", "Old age"],
                correctAnswer: 1,
                explanation: "Starvation and food scarcity are the most common causes of mortality among wolves.",
                difficulty: .hard
            ),
            QuizQuestion(
                question: "What unique communication method do wolves use besides howling?",
                options: ["Tail signals", "Color change", "Vocal mimicry", "Ultrasound"],
                correctAnswer: 0,
                explanation: "Wolves use detailed tail positions and body posture to communicate hierarchy and mood.",
                difficulty: .medium
            ),
            QuizQuestion(
                question: "How strong is a wolf’s bite force?",
                options: ["150 PSI", "300 PSI", "400 PSI", "600 PSI"],
                correctAnswer: 3,
                explanation: "A wolf’s bite force reaches around 600 PSI, strong enough to break large bones.",
                difficulty: .hard
            ),
            QuizQuestion(
                question: "What time of day are wolves most active?",
                options: ["Daytime", "Nighttime", "Dawn and dusk", "Midday"],
                correctAnswer: 2,
                explanation: "Wolves are crepuscular, meaning they are most active during dawn and dusk.",
                difficulty: .easy
            ),
            QuizQuestion(
                question: "Which of these is NOT a typical wolf behavior?",
                options: ["Cooperative hunting", "Caching food", "Living alone permanently", "Howling to regroup"],
                correctAnswer: 2,
                explanation: "Wolves are highly social animals and rarely live alone for long periods.",
                difficulty: .medium
            ),
            QuizQuestion(
                question: "Which organ in wolves is especially adapted for endurance running?",
                options: ["Heart", "Liver", "Lungs", "Kidneys"],
                correctAnswer: 2,
                explanation: "Wolves have large and powerful lungs allowing long-distance pursuit of prey.",
                difficulty: .hard
            ),
            QuizQuestion(
                question: "What is the typical territory size of a wolf pack?",
                options: ["10–20 km²", "50–100 km²", "200–500 km²", "800–1500 km²"],
                correctAnswer: 2,
                explanation: "A wolf pack’s territory can span 200–500 km² depending on prey density.",
                difficulty: .medium
            ),
            QuizQuestion(
                question: "What role does the omega wolf play in the pack?",
                options: ["Leader", "Primary hunter", "Peacemaker", "Pup protector"],
                correctAnswer: 2,
                explanation: "The omega wolf helps reduce tension within the pack and absorbs aggression.",
                difficulty: .hard
            )
]
    }
    
    private func loadGalleryItems() {
        galleryItems = [
            GalleryItem(
            imageName: "wolf.howling",
            title: "Wolf Howl",
            fact: "A wolf's howl can be heard up to 10 kilometers away and serves as a means of communication between pack members.",
            category: "Behavior"
            ),
            GalleryItem(
            imageName: "wolf.pack",
            title: "Wolf Pack",
            fact: "A wolf pack has a strict hierarchy, led by an alpha pair, which is the only breeding pair.",
            category: "Social Structure"
            ),
            GalleryItem(
            imageName: "wolf.pup",
            title: "Wolf Cubs",
            fact: "Wolf Cubs are born blind and deaf, opening their eyes only 12-15 days after birth.",
            category: "Reproduction"
            ),
            GalleryItem(
            imageName: "wolf.hunting",
            title: "Hunting",
            fact: "Wolves use complex hunting strategies, including coordinated attacks and ambush.",
            category: "Hunting"
            ),
            GalleryItem(
            imageName: "wolf.territory",
            title: "Territory",
            fact: "A pack's territory can cover anywhere from 50 to 1,000 square kilometers, depending on prey availability.",
            category: "Behavior"
            ),
            GalleryItem(
            imageName: "wolf.eyes",
            title: "Wolf's gaze",
            fact: "Wolves' eyes can reflect light in the dark, which helps them hunt at night. Eye color ranges from gold to amber.",
            category: "Anatomy"
            )
        ]
    }
    
    private func loadAchievements() {
        let baseAchievements = [
            Achievement(
            title: "First Steps",
            description: "Score 10 points on the quiz",
            icon: "star.fill",
            requiredScore: 10
            ),
            Achievement(
            title: "Wolf Expert",
            description: "Score 50 points on the quiz",
            icon: "star.circle.fill",
            requiredScore: 50
            ),
            Achievement(
            title: "Expert",
            description: "Score 100 points on the quiz",
            icon: "crown.fill",
            requiredScore: 100
            ),
            Achievement(
            title: "Pack Legend",
            description: "Score 200 points on the quiz",
            icon: "flame.fill",
            requiredScore: 200
            )
        ]
        
        loadAchievementsFromStorage()
        
        if achievements.isEmpty {
            achievements = baseAchievements
        }
    }
}
