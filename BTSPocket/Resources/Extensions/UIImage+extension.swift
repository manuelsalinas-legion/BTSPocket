//
//  UIImage+extension.swift
//  BTSPocket
//
//  Created by bts on 06/04/21.
//

import Foundation
import UIKit
import Alamofire

extension UIImageView {
    
    public func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    public func loadProfileImage(urlString: String) {
        let url = URL(string: urlString)
        guard let requestURL = url else { fatalError("URl not valid") }
        var request: URLRequest = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue(Constants.serverAddress, forHTTPHeaderField: "Referer")
        let task = URLSession.shared.dataTask(with: request) { (DataResponse, URLResponse, Error) in
            if let dataR = DataResponse {
                DispatchQueue.main.async {
                    self.image = UIImage(data: dataR, scale: 1)
                }
            }
        }
        task.resume()
    }
    
    
    
}
