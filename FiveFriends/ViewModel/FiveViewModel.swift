import RxSwift
import RxCocoa

class FiveViewModel {
    
    // Picked BehaviorSubject over BehaviorRelay since BehaviorRelay cannot terminate with error
    public let friends: BehaviorSubject<[FriendDetail]>
   
    private let client: AppSheetClientProtocol
    private let disposeBag: DisposeBag
    
    var token: String?
    
    init(friends: BehaviorSubject<[FriendDetail]> = BehaviorSubject<[FriendDetail]>(value: []),
        client: AppSheetClientProtocol = AppSheetClient(),
        disposeBag: DisposeBag = DisposeBag()) {
        self.friends = friends
        self.client = client
        self.disposeBag = disposeBag
    }
    
    /**
     
     Filters and sorts a merged observable sequence based on business logic.
     
     Side effects
        * Values from merged observable are emitted to the subject.
     
    */
    func performRequest() {
        let mergedObservable = createMergedObservable()
        
        // Apply business logic to to our data
        mergedObservable
            .filter {
                self.hasValidPhoneNumber($0.phoneNumber)
            }
            
            // Convert to Observable<[FriendDetail]>
            .toArray()
            .asObservable()
            
            // Only keep unique elements
            .map { friendsArray in
                Array(Set(friendsArray))
            }
            .map { friendsArray in
                friendsArray.sorted { $0.age < $1.age }
            }
            .map { friendsArray in
                Array(friendsArray.prefix(5))
            }
            .map { friendsArray in
                friendsArray.sorted { $0.name < $1.name }
            }
            .subscribe(
                onNext: { [weak self] friendsArray in
                    self?.friends.onNext(friendsArray)
                },
                onError: { error in
                    self.friends.onError(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    
    /**
     
     Creates an observable sequence from current values in our subject and new values from client.
     
     Side effects
        * Updates token from call to client.
    */
    func createMergedObservable() -> Observable<FriendDetail> {
        let currentFriends = (try? self.friends.value()) ?? []
        let currentFriendsObserable = Observable.from(currentFriends)
        
        let newFriendsObservable = client
            .getFriendList(withToken: token)
            .flatMap { friendList -> Observable<FriendDetail> in
                
                // Side effect, cache token for future calls
                if let token = friendList.token {
                    self.token = token
                }
                
                // Create observable for details of friends from IDs in list
                // Ignore errors in retrieving details
                let listObservable = Observable.from(friendList.identifiers)
                let friendsObservable = listObservable
                    .flatMap {
                        self.client
                            .getFriendDetails(forId: $0)
                            .catchError { _ in return .empty() }
                }
                return friendsObservable
        }
        
        return Observable.merge(currentFriendsObserable, newFriendsObservable)
    }
    

    /**
     Check if the user has a valid 10 digit phone number.
     
     Regex taken from https://stackoverflow.com/questions/16699007
     
     See `FiveViewModelTests#testPhoneNumberValidator()` for examples.
    */
    func hasValidPhoneNumber(_ number: String) -> Bool {
        let PHONE_REGEX = "^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]\\d{3}[\\s.-]\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: number)
        return result
    }
}
