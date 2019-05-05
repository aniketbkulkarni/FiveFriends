import RxSwift

protocol AppSheetClientProtocol {
    func getUserList(withToken token: String?) -> Observable<FriendList>
    func getUserDetails(forId id: Int) -> Observable<FriendDetail>
}

class AppSheetClient: AppSheetClientProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getUserList(withToken token: String?) -> Observable<FriendList> {
        return Observable<FriendList>.create { observer in
            let request = self.createUserListRequest(withToken: token)
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
    
    func getUserDetails(forId id: Int) -> Observable<FriendDetail> {
        return Observable<FriendDetail>.create { observer in
            let request = self.createUserDetailsRequest(forId: id)
            print(request.debugDescription)
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
    
    private func createUserListRequest(withToken token: String?) -> URLRequest {
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
    
    private func createUserDetailsRequest(forId id: Int) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "appsheettest1.azurewebsites.net"
        components.path = "/sample/detail/" + String(id)
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
    }
}

