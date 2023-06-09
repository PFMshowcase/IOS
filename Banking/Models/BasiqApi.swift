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
        BasiqApi.api = BasiqApi(basiq_data)
        
        return BasiqApi.api!
    }
    
    func getURL(url full_url: String) throws -> URL {
        let formatted_url = full_url
            .replacingOccurrences(of: "{id}", with: self.basiq_data.id)
            .replacingOccurrences(of: "{token}", with: self.basiq_data.token)
        
        guard let url = URL(string: formatted_url) else {
            throw BasiqError("input string not valid url")
        }
        
        return url
    }
    
//    Completion Handlers
    func req<ResType>(_ path: String, method: BasiqHTTPMethods.get = .get, completionHandler: @escaping apiCompletionHandler<ResType>) throws where ResType: Decodable {
        let req = AF.request(try self.createURL(path), method: .get, headers: self.headers)
        
        try getResponse(req: req, completionHandler: completionHandler)
    }
    
    func req<ResType>(_ path: String, method: BasiqHTTPMethods.post, parameters: Encodable, encoder: ParameterEncoder = JSONParameterEncoder.default, completionHandler: @escaping apiCompletionHandler<ResType>) throws where ResType: Decodable {
        let req = AF.request(try self.createURL(path), method: .post, parameters: parameters, encoder: encoder, headers: self.headers)
        
        try getResponse(req: req, completionHandler: completionHandler)
    }
    
//    TODO: Do I throw this error or a custom one?
    func req(_ path: String, method: BasiqHTTPMethods.delete) throws {
        let req = AF.request(try self.createURL(path), method:.delete, headers: self.headers).validate()
        
        if req.error != nil { throw req.error! }
    }
    
//    Async
    func req<ResType>(_ path: String, method: BasiqHTTPMethods.get = .get, type: ResType.Type) async throws -> ResType where ResType: Decodable {
        let req = AF.request(try self.createURL(path), method: .get, headers: self.headers)
        return try await getResponse(req, type)
    }
    
    @discardableResult func req<ResType>(_ path: String, method: BasiqHTTPMethods.post, parameters: Encodable, encoder: ParameterEncoder = JSONParameterEncoder.default, type: ResType.Type) async throws -> ResType where ResType: Decodable {
        let req = AF.request(try self.createURL(path), method: .post, parameters: parameters, encoder: encoder, headers: self.headers)
        
        return try await getResponse(req, type)
    }
    
    private func createURL(_ path:String) throws -> String {
        var formatted_path = path
        if formatted_path.first == "/" { formatted_path.removeFirst() }
        
        var url = path.contains("http") ? formatted_path : self.url + formatted_path
        url.replace("{id}", with: self.basiq_data.id)
        
        return url
    }
    
    private func getResponse<ResType>(req: DataRequest, completionHandler: @escaping apiCompletionHandler<ResType>) throws where ResType: Decodable {
        let req = req.validate()

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
            req.responseDecodable(of: ResType.self) { data in
                completionHandler(data.value, data.error) }
        }
    }
    
    private func getResponse<ResType>(_ req: DataRequest, _ type: ResType.Type) async throws -> ResType where ResType: Decodable {

        if type == String.self {
            return try await req.validate().serializingString().value as! ResType
        } else if type == Data.self {
            return try await req.validate().serializingData().value as! ResType
        } else {
            return try await req.validate().serializingDecodable(type).value
        }
    }
}
