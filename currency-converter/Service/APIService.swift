//
//  APIService.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/26/24.
//

import Foundation
import CoreData

protocol APIServiceProtocol: AnyObject {
    func getCurrencies(baseCurrency: String) async throws -> [CurrencyModel?]
}

final class APIService: APIServiceProtocol {

    private var persistentStorage: CoreDataStorage
    private var apiRepository: APIRepositoryProtocol
    
    init(apiRepository: APIRepositoryProtocol, persistentStorage: CoreDataStorage) {
        self.apiRepository = apiRepository
        self.persistentStorage = persistentStorage
    }
    
    func getCurrencies(baseCurrency: String = "USD") async throws -> [CurrencyModel?]{
        do {
            let (data, response) = try await apiRepository.getCurrencies(baseCurrency: baseCurrency)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            // TODO: Try Parse to Data Model
                            let decoder = JSONDecoder()
                            let responseData: ResponseModel = try decoder.decode(ResponseModel.self, from: data)
                            let currencyList: [CurrencyModel] = responseData.rates.compactMap { (name, rate) in
                                return CurrencyModel(name: name, rate: rate)
                            }.sorted { currency1, currency2 in
                                return currency1.name < currency2.name
                            }
                            
                            saveToPersistentStorage(currencies: currencyList)
                            
                            return currencyList

                        } catch {
                            // TODO: Handle decoding error
                        }
                    }
                }
            }
        } catch {
            // TODO: Handle error
           
        }
        return []
    }
    
    private func saveToPersistentStorage(currencies: [CurrencyModel]) {
        persistentStorage.performBackgroundTask { [weak self] context in
            
            let fetchRequest = NSFetchRequest<Currency>(entityName: "Currency")
            
            do {
                // Get existing entities
                let existingEntities = try context.fetch(fetchRequest)
                
                currencies.forEach { currency in
                    // Check if it already exist
                    let entityExists = existingEntities.contains { entity in
                        return entity.name == currency.name
                    }
                    
                    if !entityExists {
                        let entity = Currency(context: context)
                        entity.name = currency.name
                        entity.rate = currency.rate
                        
                        self?.persistentStorage.saveContext()
                    } else {
                        // do nothing
                    }
                }
            } catch {
                // TODO: Handle fetching entities error
            }
        }
    }
}
