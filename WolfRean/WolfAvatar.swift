import SwiftUI

// MARK: - Wolf Avatar System
struct WolfAvatar: Identifiable, Codable {
    let id = UUID()
    let name: String
    let iconName: String
    let description: String
    let color: String // Color name as string for Codable
    let rarity: AvatarRarity
    let unlockRequirement: Int // Quiz score needed
}

enum AvatarRarity: String, Codable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"

    var color: Color {
        switch self {
        case .common: return .gray
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }
}

// MARK: - Available Wolf Avatars
class WolfAvatarManager {
    static let shared = WolfAvatarManager()

    let availableAvatars: [WolfAvatar] = [
        // Common Avatars (Unlocked by default)
        WolfAvatar (
        name: "Timber Wolf",
        iconName: "pawprint.fill",
        description: "Classic Timber Wolf",
        color: "brown",
        rarity: .common,
        unlockRequirement: 0
        ),
        WolfAvatar (
        name: "Gray Hunter",
        iconName: "hare.fill",
        description: "Experienced Hunter",
        color: "gray",
        rarity: .common,
        unlockRequirement: 0
        ),
        WolfAvatar (
        name: "Fast Runner",
        iconName: "wind",
        description: "Fastest of the Pack",
        color: "cyan",
        rarity: .common,
        unlockRequirement: 0
        ),
        WolfAvatar (
        name: "Forest Guardian",
        iconName: "tree.fill",
        description: "Protector of Nature",
        color: "green",
        rarity: .common,
        unlockRequirement: 0
        ),

        // Rare Avatars (10+ points)
        WolfAvatar (
        name: "Moon Wolf",
        iconName: "moon.stars.fill",
        description: "Howls at the moon",
        color: "blue",
        rarity: .rare,
        unlockRequirement: 10
        ),
        WolfAvatar (
        name: "Fire Spirit",
        iconName: "flame.fill",
        description: "Furious Warrior",
        color: "orange",
        rarity: .rare,
        unlockRequirement: 10
        ),
        WolfAvatar (
        name: "Snow Guardian",
        iconName: "snow",
        description: "Lord of the North",
        color: "white",
        rarity: .rare,
        unlockRequirement: 20
        ),
        WolfAvatar (
        name: "Mountain Chieftain",
        iconName: "mountain.2.fill",
        description: "King of the Mountains",
        color: "gray",
        rarity: .rare,
        unlockRequirement: 20
        ),

        // Epic Avatars (50+ points)
        WolfAvatar (
        name: "Storm Wolf",
        iconName: "bolt.fill",
        description: "Lightning Lord",
        color: "yellow",
        rarity: .epic,
        unlockRequirement: 50
        ),
        WolfAvatar (
        name: "Alpha of the Pack",
        iconName: "crown.fill",
        description: "Leader of All Wolves",
        color: "gold",
        rarity: .epic,
        unlockRequirement: 50
        ),
        WolfAvatar (
        name: "Northern Lights",
        iconName: "sparkles",
        description: "Magical Wolf",
        color: "purple",
        rarity: .epic,
        unlockRequirement: 70
        ),
        WolfAvatar(
        name: "Taiga Spirit",
        iconName: "leaf.fill",
        description: "Ancient Guardian",
        color: "green",
        rarity: .epic,
        unlockRequirement: 70
        ),

        // Legendary Avatars (100+ points)
        WolfAvatar(
        name: "Space Wolf",
        iconName: "globe.americas.fill",
        description: "Guardian of the Worlds",
        color: "blue",
        rarity: .legendary,
        unlockRequirement: 100
        ),
        WolfAvatar(
        name: "Sun God",
        iconName: "sun.max.fill",
        description: "Divine Power",
        color: "yellow",
        rarity: .legendary,
        unlockRequirement: 150
        ),
        WolfAvatar(
        name: "Star Lord",
        iconName: "star.fill",
        description: "Legend of the Pack",
        color: "gold",
        rarity: .legendary,
        unlockRequirement: 200
        ),
        WolfAvatar(
        name: "Ancient Sage",
        iconName: "book.closed.fill",
        description: "Knowledge of the Ages",
        color: "purple",
        rarity: .legendary,
        unlockRequirement: 200
        )
    ]

    func getUnlockedAvatars(currentScore: Int) -> [WolfAvatar] {
        availableAvatars.filter { $0.unlockRequirement <= currentScore }
    }

    func getLockedAvatars(currentScore: Int) -> [WolfAvatar] {
        availableAvatars.filter { $0.unlockRequirement > currentScore }
    }
}

// MARK: - Color Extension for String Names
extension Color {
    init(name: String) {
        switch name.lowercased() {
        case "brown": self = .brown
        case "gray", "grey": self = .gray
        case "cyan": self = .cyan
        case "green": self = .green
        case "blue": self = .blue
        case "orange": self = .orange
        case "white": self = .white
        case "yellow": self = .yellow
        case "gold": self = .yellow
        case "purple": self = .purple
        default: self = .blue
        }
    }
}

// MARK: - Avatar Progress Extension
extension WolfViewModel {
    var avatarProgress: Double {
        let totalAvatars = WolfAvatarManager.shared.availableAvatars.count
        let unlockedAvatars = WolfAvatarManager.shared.getUnlockedAvatars(currentScore: quizScore).count
        return Double(unlockedAvatars) / Double(totalAvatars)
    }

    var nextAvatarUnlock: WolfAvatar? {
        WolfAvatarManager.shared.getLockedAvatars(currentScore: quizScore)
            .min(by: { $0.unlockRequirement < $1.unlockRequirement })
    }
}
