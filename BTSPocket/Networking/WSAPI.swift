//
//  WSAPI.swift

import Alamofire
import Foundation

class WSAPI {
    private var AlamofireManager: Alamofire.Session?

    class var requestHeaders: [String: String] {
        var headers = [String: String]()
        headers += [
            "Content-Type": "application/json"
        ]

        return headers
    }

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Constants.kTimeout
        AlamofireManager = Alamofire.Session(configuration: config)
    }

    // MARK: REQUEST WEB SERVICES
    /// This request is property of WSAPI
    func request(_ url: String, method: Alamofire.HTTPMethod, parameters: Any?, headers: [String: String]?, onSuccess: @escaping (_ data: Data) -> Void, onError: @escaping (NSError) -> Void) {
        self.requestWebService(url: url, method: method, parameters: parameters, headers: headers, onSuccess: onSuccess, onError: onError)
    }

    private func requestWebService(url: String, method: Alamofire.HTTPMethod, parameters: Any?, headers: [String: String]?, onSuccess: @escaping (_ data: Data) -> Void, onError: @escaping (NSError) -> Void) {
        
        // Construct the request URL
        guard let URL = URL(string: url) else {
            onError(NSError(domain: "WSAPI", code: -1, userInfo: ["description": "Url is invalid"]))
            return
        }

        // Headers
        var headersRequest = WSAPI.requestHeaders
        if let additionalHeaders = headers {
            headersRequest += additionalHeaders
        }

        // Encode Parameters
        let parametersEncodedAndDictionary = paramsEncoding(method, parameters)
        let pEncoding: ParameterEncoding? = parametersEncodedAndDictionary.0
        let pDictionary: [String: Any]? = parametersEncodedAndDictionary.1

        // Log
        print("\n══════════════════════════════════════════════════════════════════════════════════════════")
        print("✣ Request: \(URL)\n✣ Headers:\n\(headersRequest.prettyJSON ?? "null")\n✣ Method: \(method.rawValue)\n✣ Parameters:\n\(pDictionary?.prettyJSON ?? "null")")

        let headers = HTTPHeaders(headersRequest)

        AlamofireManager?.request(URL, method: method, parameters: pDictionary, encoding: pEncoding!, headers: headers)
        .responseData { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case let .success(responseData):

                // Tracking Log
                print("\n✣ Response endpoint: (\(URL))")
                print("✣ Response code: \(statusCode ?? -1)")
                print("✣ Response headers:\n\(response.response?.allHeaderFields.prettyJSON ?? "null")")

                // Pretty JSON from Data
                if let json = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers), let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                    let prettyResponse = String(decoding: jsonData, as: UTF8.self)
                    print("✣ Response body:\n", prettyResponse, "\n")
                } else {
                    let fail = "✖︎ WSAPI: Response pretty representation FAILED ✖︎"
                    print(fail)
                }
                
                // Valid status code?
                guard statusCode == HttpStatusCode.ok.rawValue || statusCode == HttpStatusCode.created.rawValue else {
                    onError(NSError(domain: URL.absoluteString, code: statusCode ?? -1, userInfo: ["Description": "Error \(statusCode ?? -1)"]))
                    
                    return
                }

                // Success completion
                onSuccess(responseData)

            case let .failure(responseError):

                let error = responseError as NSError?

                if let error = error {
                    // Error from Server
                    onError(error)
                } else {
                    let code = statusCode ?? -2

                    let unauthorizedCode = HttpStatusCode.unauthorized.rawValue
                    let unauthorizedMsg = "Access not authorized".localized

                    let forbiddenCode = HttpStatusCode.forbidden.rawValue
                    let forbiddenMsg = "Trying to access forbidden data".localized

                    let notFoundCode = HttpStatusCode.notFound.rawValue
                    let notFoundCodeMsg = "Data not found".localized

                    let desc = "Description"
                    let errorDesc = responseError.localizedDescription

                    let userInfo = [desc: statusCode == unauthorizedCode ? unauthorizedMsg : statusCode == forbiddenCode ? forbiddenMsg : statusCode == notFoundCode ? notFoundCodeMsg : errorDesc ]

                    // Error custom based on status code
                    onError(NSError(domain: "WSAPI", code: code, userInfo: userInfo))
                }
            }
        }
    }

    // MARK: ENCODING
    private func paramsEncoding(_ method: Alamofire.HTTPMethod, _ parameters: Any?) -> (ParameterEncoding?, [String: Any]?) {
        var parameterEncoding: ParameterEncoding?
        var parametersDict: [String: Any]?

        // Check if the parameters are made of a dictionary
        if let existingParameters = parameters as? [String: Any] {
            parameterEncoding = method == Alamofire.HTTPMethod.get ? URLEncoding.default : JSONEncoding.default
            parametersDict = existingParameters
        }
            // Check if the parameters are made of a String
        else if let _ /*plainText*/ = parameters as? String {
            parameterEncoding = URLEncoding.httpBody
            parametersDict = [:]
        } else {
            // If the parameter is not a dictionary or string encode a Json default
            print("*** Parameters is not a Dictionary or String ***")
            parametersDict = nil
            parameterEncoding = JSONEncoding.default
        }

        return (parameterEncoding, parametersDict)
    }

    /// Returns directory path, filename and extension file
    private func splitFilename(_ url: URL) -> (directory: String, filename: String, ext: String) {
        return (url.deletingLastPathComponent().path, url.deletingPathExtension().lastPathComponent, url.pathExtension)
    }
}
