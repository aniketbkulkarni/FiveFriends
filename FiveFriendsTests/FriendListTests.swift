import XCTest
@testable import FiveFriends

class FriendListTests: XCTestCase {

    func testDecodeWithToken() {
        let data = Data("""
        {
            "result":[1,2,3,4,5,6,7,8,9,10],
            "token":"a35b4"}
        """.utf8)
        
        let response: FriendList
        do {
            response = try JSONDecoder().decode(FriendList.self, from: data)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        
        XCTAssertEqual(response.identifiers.count, 10)
        XCTAssertNotNil(response.token)
    }
        
    func testDecodeNoToken() {
        let data = Data("""
        {
            "result":[21,22,23,24,25,26,27]
        }
        """.utf8)
        
        let response: FriendList
        do {
            response = try JSONDecoder().decode(FriendList.self, from: data)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        
        XCTAssertTrue(response.identifiers.count < 10)
        XCTAssertNil(response.token)
    }
}
