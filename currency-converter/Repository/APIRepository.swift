//
//  APIRepository.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/26/24.
//

import Foundation


/// Protocol for APIRepository class
protocol APIRepositoryProtocol: AnyObject {
    func getCurrencies(baseCurrency: String) async throws -> (Data?, URLResponse)
}


/// Class for App Repository Layer
/// Used in APIService.swift
final class APIRepository: APIRepositoryProtocol {
    
    private let urlSession = URLSession.shared
    
    /**
    # Fetch data from API
      - Method for fetching data from API
     - Use this method when fetching latest currencies from API
     - Requires:
        - Parameter <baseCurrency> : String type data use for base currency for the returned rates
     - Throws:
        - When URL does not exist
     - Returns:
        - <(Data, Reponse)> Tuple
     **/
    func getCurrencies(baseCurrency: String) async throws -> (Data?, URLResponse) {
        var data: Data
        var response: URLResponse
        
        let urlString: String = Endpoint.LatestCurrencies(environment).url
        
        var urlComponents = URLComponents(string: urlString)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "app_id", value: AppConstants.APP_ID),
            URLQueryItem(name: "base", value: baseCurrency)
        ] 
        
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL("URL does not exists")
        }
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        let headers = ["accept": "application/json"]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            (data, response) = try await urlSession.data(for: request as URLRequest)
            return (data, response)
        } catch {
            throw APIError.networkFailure(error)
        }
    }
}
