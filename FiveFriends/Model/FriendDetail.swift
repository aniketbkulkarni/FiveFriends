import Foundation

struct FriendDetail: Decodable, Hashable {
    
    let userId: Int
    let name: String
    let age: Int
    let phoneNumber: String
    let biography: String
    let photoUrl: URL?

    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case name
        case age
        case phoneNumber = "number"
        case photoEndpoint = "photo"
        case biography = "bio"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.name = try container.decode(String.self, forKey: .name).firstUppercased
        self.age = try container.decode(Int.self, forKey: .age)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.biography = try container.decode(String.self, forKey: .biography)
        
        let endpoint = try container.decode(String.self, forKey: .photoEndpoint)
        if let url = URL(string: endpoint) {
            self.photoUrl = url
        } else {
            photoUrl = nil
        }
    }
}
