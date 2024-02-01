//
//  ConverterViewModel.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/27/24.
//

import Foundation
import CoreData
import Combine

protocol ConverterViewModelProtocol: AnyObject {
    func getCurrencies() async
    func fetchCurrenciesFromStorage() async throws -> [CurrencyModel?]
}

final class ConverterViewModel: ConverterViewModelProtocol {
    
    var cancellables = Set<AnyCancellable>()
    let currencyRates = PassthroughSubject<[CurrencyModel?], Error>()
    
    private var apiService: APIServiceProtocol
    private var persistentStorage: CoreDataStorage
    private let connectivity = ConnectivityManager.shared
    
    init(apiService: APIServiceProtocol, persistentStorage: CoreDataStorage) {
        self.apiService = apiService
        self.persistentStorage = persistentStorage
    }
    
    func getCurrencies() async {
        do {
            let currenciesFromStorage = try await fetchCurrenciesFromStorage()
            
            if currenciesFromStorage.isEmpty {
                if connectivity.isConnected {
                    do {
                        let currencies = try await apiService.getCurrencies(baseCurrency: "USD")
                        currencyRates.send(currencies)
                    } catch {
                        currencyRates.send(completion: .failure(error))
                    }
                }
            } else {
                currencyRates.send(currenciesFromStorage)
            }
        } catch {
            // TODO: Handle error
        }
    }
    
    func fetchCurrenciesFromStorage() async throws -> [CurrencyModel?] {
        return try await withCheckedThrowingContinuation { continuation in
            persistentStorage.performBackgroundTask { context in
               let fetchRequest = NSFetchRequest<Currency>(entityName: "Currency")
                
               do {
                 let entities = try context.fetch(fetchRequest)
                   let currencyList = entities.map({ entity in
                       return CurrencyModel(name: entity.name ?? "N/A", rate: entity.rate)
                   })
                   
                   continuation.resume(returning: currencyList)
               } catch {
                // TODO: Handle error
                   continuation.resume(throwing: error)
               }
           }
        }
    }
    
    func convertCurrency(amount: Double, from inputCurrency: Double, to outputCurrency: Double) -> Double{
        
        // Amount value to USD
        if amount > 0 {
            let convertFrom = amount / inputCurrency
            // USD to Selected output
            let result = convertFrom * outputCurrency
            return result
        } else {
            return 0
        }
    }
}
