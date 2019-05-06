import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import FiveFriends

class FiveViewModelTests: XCTestCase {
    
    var viewModel: FiveViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var client: MockAppSheetClient!
    
    override func setUp() {
        super.setUp()
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.client = MockAppSheetClient()
        self.viewModel = FiveViewModel(client: client)
    }
    
    func testPhoneNumberValidator() {
        let subject = FiveViewModel()
        
        XCTAssertTrue(subject.hasValidPhoneNumber("555-555-5555"))
        XCTAssertTrue(subject.hasValidPhoneNumber("(555) 555-5555"))
        XCTAssertTrue(subject.hasValidPhoneNumber("555 555-5555"))
        
        XCTAssertFalse(subject.hasValidPhoneNumber("(555)555-5555"))
        XCTAssertFalse(subject.hasValidPhoneNumber("567"))
        XCTAssertFalse(subject.hasValidPhoneNumber(""))
        XCTAssertFalse(subject.hasValidPhoneNumber("555-5555"))
    }
    
    func testMockClient() {
        viewModel.performRequest()
        XCTAssertEqual(try! viewModel.friends.value().count, 1)
        XCTAssertNotNil(viewModel.token)
    }
}
