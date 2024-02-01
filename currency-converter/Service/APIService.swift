//
//  APIService.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/26/24.
//

import Foundation
import CoreData


/// Procotol for APIService class
protocol APIServiceProtocol: AnyObject {
    func getCurrencies(baseCurrency: String) async throws -> [CurrencyModel?]
}

/// Class for App Service layer
/// Used in ConverterViewModel.swift
final class APIService: APIServiceProtocol {

    private var persistentStorage: CoreDataStorage
    private var apiRepository: APIRepositoryProtocol
    
    init(apiRepository: APIRepositoryProtocol, persistentStorage: CoreDataStorage) {
        self.apiRepository = apiRepository
        self.persistentStorage = persistentStorage
    }
    
    /**
    # Get Currencies Method API Service
      - Fetch Currecies from repository layer
     - Method for parsing Data, Response objects from repository
     - Check http status code and then parse data
     - Saving parsed object to local storage is called in this method
     - Requires:
        - Parameter <baseCurrency> : String type data use for base currency for the returned rates
     - Throws:
        - When cannot reach repositroy
        - When cannot parse Data into <ResponseModel> Data Model
     - Returns:
        - List of <CurrencyModel> objects
     **/
    func getCurrencies(baseCurrency: String) async throws -> [CurrencyModel?]{
        do {
            let (data, response) = try await apiRepository.getCurrencies(baseCurrency: baseCurrency)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let responseData: ResponseModel = try decoder.decode(ResponseModel.self, from: data)
                            let currencyList: [CurrencyModel] = responseData.rates.compactMap { (name, rate) in
                                return CurrencyModel(name: name, rate: rate)
                            }.sorted { currency1, currency2 in
                                return currency1.name < currency2.name
                            }
                            
                            // call save to local storage
                            try saveToPersistentStorage(currencies: currencyList)
                            
                            return currencyList

                        } catch {
                            print(error)
                            throw APIError.decodingError(error)
                        }
                    }
                }
            }
        } catch {
            print(error)
            throw APIError.requestFailed(error)
        }
        return []
    }
    
    /**
    # Save To Persistent Storage Method
      - Save parsed currency rates to local storage (Core Data)
     - Method for parsing object models into entitites
     - Saving object to entities happens in this method
     - Requires:
        - Parameter <currencies> : List of CurrencyModel objects to be parsed as entities
     - Throws:
        - When cant fetch entities
     - Returns:
        - Nothing
     **/
    private func saveToPersistentStorage(currencies: [CurrencyModel]) throws {
        persistentStorage.performBackgroundTask { context in
            
            let fetchRequest = NSFetchRequest<Currency>(entityName: "Currency")
            
            do {
                // Get existing entities
                let existingEntities = try context.fetch(fetchRequest)
                
                try currencies.forEach { currency in
                    // Check if it already exist
                    let entityExists = existingEntities.contains { entity in
                        return entity.name == currency.name
                    }
                    
                    if !entityExists {
                        let entity = Currency(context: context)
                        entity.name = currency.name
                        entity.rate = currency.rate
                        
                        //self?.persistentStorage.saveContext()
                        do {
                            try context.save()
                        } catch {
                            print(error)
                            throw CoreDataError.saveContextFailed(error)
                        }
                    } else {
                        // do nothing
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
