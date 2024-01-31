//
//  APIRepository.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/26/24.
//

import Foundation


protocol APIRepositoryProtocol: AnyObject {
    func getCurrencies(baseCurrency: String) async throws -> (Data?, URLResponse)
}

final class APIRepository: APIRepositoryProtocol {
    
    private let urlSession = URLSession.shared
    
    func getCurrencies(baseCurrency: String) async throws -> (Data?, URLResponse) {
        let httpResponse: HTTPURLResponse
        
        let urlString: String = Endpoint.LatestCurrencies(environment).url
        
        var urlComponents = URLComponents(string: urlString)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "app_id", value: AppConstants.APP_ID),
            URLQueryItem(name: "base", value: baseCurrency)
        ] 
        
        guard let url = urlComponents?.url else {
            // TODO: Throw Error
            throw APIError.invalidURL("URL does not exists")
        }
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        let headers = ["accept": "application/json"]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await urlSession.data(for: request as URLRequest)
        print(data)
        print(response)
        return (data, response)
    }
}
