import XCTest

class FiveFriendsUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
    }

    func testFiveCellsExist() {
        app.launch()
        sleep(10)
        XCTAssertEqual(app.tables.cells.count, 5)
    }
}
