import RxSwift
import RxCocoa

class FiveViewModel {
    
    let friends = BehaviorSubject<[FriendDetail]>(value: [])
    let client = AppSheetClient()
    let disposeBag = DisposeBag()
    
    var token: String?
    
    func doRequest() {
        client
            .getUserList(withToken: token)
            .flatMap { (list: FriendList) -> Observable<[FriendDetail]> in
                if let token = list.token {
                    self.token = token
                }
                let lo = Observable.from(list.identifiers)
                let details = lo.flatMap {
                    self.client
                        .getUserDetails(forId: $0)
                        .catchError({_ in return .empty() })
                    }
                    .toArray()
                
                return details.asObservable()
            }
            .subscribe(
                // Clean this up, duplicate values
                // Not very testable
                onNext: { details in
                    let values: [FriendDetail]
                    do {
                        values = try self.friends.value()
                    } catch {
                        values = []
                    }
                    
                    let anotherValue = try? self.friends.value() ?? []
                    var allFriends = values + details
                    allFriends.sort(by: {$0.age < $1.age })
                    let fiveFriends = Array(allFriends.prefix(5))
                    self.friends.onNext(fiveFriends)
                },
                onError: { error in
                    self.friends.onError(error)
                    print("Failed on subscribe: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    func hasValidPhoneNumber() -> Bool {
        return true
    }
}
