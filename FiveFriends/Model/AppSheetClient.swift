import RxSwift

protocol AppSheetClientProtocol {
    func getFriendList(withToken token: String?) -> Observable<FriendList>
    func getFriendDetails(forId id: Int) -> Observable<FriendDetail>
}

class AppSheetClient: AppSheetClientProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    /**
     Creates an observable wrapping a list of user id's and optionally a token.
     
     - Parameter token: A cached token to get a new list of users.
     - Returns: Observable `FriendList`.
    */
    func getFriendList(withToken token: String?) -> Observable<FriendList> {
        return Observable<FriendList>.create { observer in
            let request = self.createFriendListRequest(withToken: token)
            let task = self.session.dataTask(with: request) { (data, response, error) in
                do {
                    let response = try JSONDecoder().decode(FriendList.self, from: data ?? Data())
                    observer.onNext(response)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /**
     Creates an observable containing information for a particular user.
     
     - Parameter id: Identifier for a given user.
     - Returns: Observable `FriendDetail`.
     */
    func getFriendDetails(forId id: Int) -> Observable<FriendDetail> {
        return Observable<FriendDetail>.create { observer in
            let request = self.createFriendDetailsRequest(forId: id)
            let task = self.session.dataTask(with: request) { (data, response, error) in
                do {
                    let response = try JSONDecoder().decode(FriendDetail.self, from: data ?? Data())
                    observer.onNext(response)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func createFriendListRequest(withToken token: String?) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "appsheettest1.azurewebsites.net"
        components.path = "/sample/list"
        
        if let queryToken = token {
            components.queryItems = [
                URLQueryItem(name: "token", value: queryToken)
            ]
        }

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
    }
    
    private func createFriendDetailsRequest(forId id: Int) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "appsheettest1.azurewebsites.net"
        components.path = "/sample/detail/" + String(id)
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
    }
}

