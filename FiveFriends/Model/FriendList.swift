import Foundation

struct FriendList: Decodable {
    
    let identifiers: [Int]
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case identifiers = "result"
        case token
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifiers = try container.decode([Int].self, forKey: .identifiers)
        self.token = try container.decodeIfPresent(String.self, forKey: .token)
    }
}
