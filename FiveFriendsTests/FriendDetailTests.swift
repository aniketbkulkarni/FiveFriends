import XCTest
@testable import FiveFriends

class FriendDetailTests: XCTestCase {
    
    func testDecode() {
        let data = Data("""
        {
            "id":21,
            "name":"paul",
            "age":48,
            "number":"555-555-5555",
            "photo":"https://appsheettest1.azurewebsites.net/male-11.jpg",
            "bio":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ex sapien, interdum sit amet tempor sit amet, pretium id neque. Nam ultricies ac felis ut lobortis. Praesent ac purus vitae est dignissim sollicitudin. Duis iaculis tristique euismod. Nulla tellus libero, gravida sit amet nisi vitae, ultrices venenatis turpis. Morbi ut dui nunc."
        }
        """.utf8)
        
        let response: FriendDetail
        do {
            response = try JSONDecoder().decode(FriendDetail.self, from: data)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        
        XCTAssertNotNil(response.phoneNumber)
    }
}
