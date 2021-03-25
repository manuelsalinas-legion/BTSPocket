//
//  BTSPlatformEndpoints.swift
//  BTSPocket
//
//

import Foundation

class BTSPlatformEndpoints: WSAPI {

    // MARK: GET METHOD
    func getMethod<T: Codable>(_ url: String, _ headers: [String : String]? = nil , _ params: Any? = nil, onSuccess: @escaping (T) -> Void, onError: @escaping (_ error: NSError) -> Void) {
            self.request(url,
                         method: .get,
                         parameters: params,
                         headers: headers,
                         onSuccess: { data in
                            do {
                                let object = try JSONDecoder().decode(T.self, from: data)
                                onSuccess(object)
                            } catch let jsonError {
                                let error = jsonError as NSError
                                let debug = error.userInfo["NSDebugDescription"] as? String

                                // Parsing Error
                                print("Failed to decode JSON:", debug ?? "null")
                                onError(jsonError as NSError)
                            }
            }, onError: { error in
                print(error.description)
                onError(error)
            })
    }
    
    // MARK: POST METHOD
    func postMethod<T: Codable>(_ url: String, _ headers: [String : String]? = nil , _ params: Any? = nil, onSuccess: @escaping (T) -> Void, onError: @escaping (_ error: NSError) -> Void) {
            self.request(url,
                         method: .post,
                         parameters: params,
                         headers: headers,
                         onSuccess: { data in
                            do {
                                let object = try JSONDecoder().decode(T.self, from: data)
                                onSuccess(object)
                            } catch let jsonError {
                                let error = jsonError as NSError
                                let debug = error.userInfo["NSDebugDescription"] as? String

                                // Parsing Error
                                print("Failed to decode JSON:", debug ?? "null")
                                onError(jsonError as NSError)
                            }
            }, onError: { error in
                print(error.description)
                onError(error)
            })
    }
}
