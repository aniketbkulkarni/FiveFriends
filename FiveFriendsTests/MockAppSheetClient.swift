import RxSwift
@testable import FiveFriends

class MockAppSheetClient: AppSheetClientProtocol {
    
    var friendListObservable = Observable.of(FriendList(identifiers: [1], token: "test"))
    var friendDetailObservable = Observable.of(FriendDetail(userId: 1, name: "test", age: 1, phoneNumber: "555-555-5555"))
    
    func getFriendList(withToken token: String?) -> Observable<FriendList> {
        return friendListObservable
    }
    
    func getFriendDetails(forId id: Int) -> Observable<FriendDetail> {
        return friendDetailObservable
    }
}
