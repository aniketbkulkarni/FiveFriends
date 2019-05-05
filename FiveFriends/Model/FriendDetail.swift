import Foundation

struct FriendDetail: Decodable {
    
    let userId: Int
    let name: String
    let age: Int
    let phoneNumber: String
    let photoEndpoint: String
    let biography: String
    
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
        self.photoEndpoint = try container.decode(String.self, forKey: .photoEndpoint)
        self.biography = try container.decode(String.self, forKey: .biography)
    }
}
