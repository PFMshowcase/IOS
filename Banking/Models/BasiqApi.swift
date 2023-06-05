//
//  BasiqApi.swift
//  Banking
//
//  Created by Toby Clark on 3/6/2023.
//

import Foundation
import Alamofire


class BasiqApi {
    private (set) static var api: BasiqApi?
    private (set) var basiq_data: BasiqUser
    private var headers: HTTPHeaders = [
            "accept": "application/json"
        ]
    private let url: String = "https://au-api.basiq.io/"
    
    private init(_ basiq_data: BasiqUser) {
        self.basiq_data = basiq_data
        self.headers["authorization"] = "Bearer \(basiq_data.token)"
    }
    
    @discardableResult static func initialize(_ basiq_data: BasiqUser) throws -> BasiqApi {
        guard BasiqApi.api == nil else {
            throw BasiqError.alreadyInitialized()
        }
        BasiqApi.api = BasiqApi(basiq_data)
        
        return BasiqApi.api!
    }
    
    func req<ResType>(_ path: String, method: BasiqHTTPMethods.get = .get, completionHandler: @escaping apiCompletionHandler<ResType>) throws where ResType: Decodable {
        let req = AF.request(self.createURL(path), method: .get, headers: self.headers).validate()
        
        getResponse(req: req, completionHandler: completionHandler)
    }
    
    func req<ResType>(_ path: String, method: BasiqHTTPMethods.post, parameters: Encodable, encoder: ParameterEncoder = JSONParameterEncoder.default, completionHandler: @escaping apiCompletionHandler<ResType>) throws where ResType: Decodable {
        let req = AF.request(self.createURL(path), method: .post, parameters: parameters, encoder: encoder, headers: self.headers)
        
        getResponse(req: req, completionHandler: completionHandler)
    }
    
//    TODO: Do I throw this error or a custom one?
    func req(_ path: String, method: BasiqHTTPMethods.delete) throws {
        let req = AF.request(self.createURL(path), method:.delete, headers: self.headers)
        
        if req.error != nil { throw req.error! }
    }
    
    private func createURL(_ path:String) -> String {
        var url = self.url + path
        
        url.replace("{id}", with: self.basiq_data.id)
        
        print(url)
        return url
    }
    
    private func getResponse<ResType>(req: DataRequest, completionHandler: @escaping apiCompletionHandler<ResType>) where ResType: Decodable {
        if ResType.self == String.self {
            req.responseString() { data in
                let value: ResType? = data.value as? ResType
                completionHandler(value, data.error)
            }
        } else if ResType.self == Data.self {
            req.responseData() { data in
                let value: ResType? = data.value as? ResType
                completionHandler(value, data.error)
            }
        } else {
            req.responseDecodable(of: ResType.self) { data in completionHandler(data.value, data.error) }
        }
    }
}
