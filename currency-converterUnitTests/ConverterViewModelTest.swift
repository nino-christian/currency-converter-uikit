//
//  ConverterViewModelTest.swift
//  currency-converterUnitTests
//
//  Created by Nino-Christian on 2/1/24.
//

import XCTest
import CoreData
@testable import currency_converter


final class ConverterViewModelTest: XCTestCase {

    let mockService = MockService()
    let coreData = CoreDataStorage()
    var sut: ConverterViewModel!
    
    override func setUpWithError() throws {
        sut = ConverterViewModel(apiService: mockService, 
                                 persistentStorage: coreData)
    }

    override func tearDownWithError() throws {
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testFetchDataFromService() async throws {
        
        let expectation = XCTestExpectation(description: "Data fetch. Data should be fetched")
        
        var resultData: [CurrencyModel?] = []
        let sampleData = [ CurrencyModel(name: "AED", rate: 3.6729),
                           CurrencyModel(name: "AFN", rate: 72.5),
                           CurrencyModel(name: "ALL", rate: 95.6),
                           CurrencyModel(name: "AMD", rate: 405.332115),
                           CurrencyModel(name: "ANG", rate: 1.801358),
                           CurrencyModel(name: "AOA", rate: 832.5)
                  ]
        
        await sut.getCurrencies()
        
        sut.currencyRates.sink { _ in
        } receiveValue: { currencies in
            XCTAssertEqual(currencies, sampleData)
            resultData = currencies
            expectation.fulfill()
        }
        .store(in: &sut.cancellables)
        
        await fulfillment(of: [expectation], timeout: 5, enforceOrder: true)
        
        XCTAssertEqual(resultData, sampleData, "Property should have data")
    }
    
    func testConversionOfCurrencies() {
        // amount
        let amount: Double = 50
        // selected input currency rate to USD is 2
        let inputRate: Double = 2
        // selected output currency rate to USD is 2
        let outputRate: Double = 2
        
        let result = sut.convertCurrency(amount: amount, from: inputRate, to: outputRate)
        
        XCTAssertEqual(result, 50)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockService: APIServiceProtocol {
    func getCurrencies(baseCurrency: String) async throws -> [currency_converter.CurrencyModel?] {
        let currencies: [CurrencyModel?] = [ CurrencyModel(name: "AED", rate: 3.6729),
                                             CurrencyModel(name: "AFN", rate: 72.5),
                                             CurrencyModel(name: "ALL", rate: 95.6),
                                             CurrencyModel(name: "AMD", rate: 405.332115),
                                             CurrencyModel(name: "ANG", rate: 1.801358),
                                             CurrencyModel(name: "AOA", rate: 832.5)
                                        ]
        return currencies
    }
}

