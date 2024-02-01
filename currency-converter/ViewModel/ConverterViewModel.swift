//
//  ConverterViewModel.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/27/24.
//

import Foundation
import CoreData
import Combine

/// Protocol for ConverterViewModel class
protocol ConverterViewModelProtocol: AnyObject {
    func getCurrencies(baseCurrency: String) async
    func fetchCurrenciesFromStorage() throws
}

/// Class for ViewModel layer
/// Used in ConverterViewController.swift
final class ConverterViewModel: ConverterViewModelProtocol {
    
    var cancellable: AnyCancellable?
    var cancellables = Set<AnyCancellable>()
    let currencyRates = PassthroughSubject<[CurrencyModel?], Error>()
    
    private var apiService: APIServiceProtocol
    private var persistentStorage: CoreDataStorage
    private let connectivity = ConnectivityManager.shared
    
    init(apiService: APIServiceProtocol, persistentStorage: CoreDataStorage) {
        self.apiService = apiService
        self.persistentStorage = persistentStorage
    }
    
    /**
    # Get Currencies Method
      - Get currencies from Service Layer
     - Method for fetching list of parsed <CurrencyModel>
     - Checks connectivity first before data fetching
     - If offline, access method for fetching entities from core data storage
     - Data fetch gets executed once every 30 minutes.
     - Gets executed immediately right after first call.
     - Requires:
        - Parameter <baseCurrency> : String type data use for base currency for the returned rates
     - Throws:
        - When service layer method cannot be reached
        - Sends failure case to <currencyRate> property
     - Returns:
        - Nothing, access <currencyRate> property  to send data
     **/
    func getCurrencies(baseCurrency: String = "USD") async {
        if connectivity.isConnected {
            cancellable = Timer.publish(every: 30 * 60, on: .main, in: .default)
                        .autoconnect()
                        .prepend(Date())
                        .sink { [weak self] _ in
                            guard let self = self else { return }
                            print("Timer Fires")
                            Task {
                                do {
                                    let currencies = try await self.apiService.getCurrencies(baseCurrency: baseCurrency)
                                    self.currencyRates.send(currencies)
                                } catch {
                                    self.currencyRates.send(completion: .failure(error))
                                }
                            }
                        }
//                    do {
//                        let currencies = try await apiService.getCurrencies(baseCurrency: "USD")
//                        currencyRates.send(currencies)
//                    } catch {
//                        currencyRates.send(completion: .failure(error))
//                    }
        } else {
            do {
                print("Offline")
                try fetchCurrenciesFromStorage()
                currencyRates.sink { _ in
                    // TODO: Handle Completion
                } receiveValue: { currencyList in
                    if currencyList.isEmpty {
                      // TODO: Show pop up need to connect, data empty
                    }
                }
                .store(in: &cancellables)
            } catch {
                // TODO: Show pop up
            }
        }
    }
    
    /**
    # Fetch Currencies From Storage Method
      - This method is only executed when offline
     - Get currencies from Local Stroage (Core Data)
     - Parse fetch <Currency> entities into <CurrencyModel> object
     - Requires:
        - Nothing
     - Throws:
        - When cant fetch entities
        - Sends failure case to <currencyRate> property
     - Returns:
        - Nothing, access <currencyRate> property  to assign data
     **/
    func fetchCurrenciesFromStorage() throws {
        persistentStorage.performBackgroundTask { [weak self] context in
           let fetchRequest = NSFetchRequest<Currency>(entityName: "Currency")
            
           do {
             let entities = try context.fetch(fetchRequest)
               print(entities.count)
               let currencyList = entities.map({ entity in
                   return CurrencyModel(name: entity.name ?? "N/A", rate: entity.rate)
               })
               
               self?.currencyRates.send(currencyList)
           } catch {
            // TODO: Handle error
               self?.currencyRates.send(completion: .failure(error))
           }
       }
    }
    
    /**
    # Convert Currency Method
      - This method calculate currency conversion
     - Requires:
        - Parameter <amount>: Inputted amount converted from data type String to Double
        - Parameter <inputCurrency>: selected input or initial currency rate before conversion with data type Double
        - Parameter <outputCurrency>: selected output or final currency rate before conversion with data type Double
     - Throws:
        - Nothing
     - Returns:
        - Converted amount with data type Double
     **/
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
