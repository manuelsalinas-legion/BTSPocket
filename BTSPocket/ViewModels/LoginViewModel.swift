//
//  LoginViewModel.swift
//  BTSPocket
//
//

import Foundation

struct LoginViewModel {
    
    // Dummy function
    #warning("Hey Cristian Look at me and analyze. Then Adapt your own functions according UI needs")
    func nameOfYourMethodWithArguments(_ username: String, _ password: String, _ completion: @escaping((_ error: NSError?) -> Void)) {
        
        let wsParams = ["username" : username, "password" : password]
        BTSApi.shared.platformEP.getMethod(Constants.Endpoints.authentication, wsParams) { (response: DummyResponse) in
            print(response.message)
            completion(nil)
        } onError: { error in
            print(error.localizedDescription)
            completion(error)
        }

    }
}
