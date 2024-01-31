//
//  ConverterAPIServiceTest.swift
//  currency-converterUnitTests
//
//  Created by Nino-Christian on 2/1/24.
//

import XCTest
@testable import currency_converter

final class ConverterAPIServiceTest: XCTestCase {

    let coreData = CoreDataStorage()
    let mockRepository = MockRepository()
    var sut: APIServiceProtocol!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = APIService(apiRepository: mockRepository, persistentStorage: coreData)
    }

    override func tearDownWithError() throws {
    }

    func testFetchCurrencyModelsFromService() async throws {
        let sampleData: [CurrencyModel?] = [ CurrencyModel(name: "AED", rate: 3.6729),
                           CurrencyModel(name: "AFN", rate: 72.5),
                           CurrencyModel(name: "ALL", rate: 95.6),
                           CurrencyModel(name: "AMD", rate: 405.332115),
                           CurrencyModel(name: "ANG", rate: 1.801358),
                           CurrencyModel(name: "AOA", rate: 832.5)
                  ]
        
        let fetchData: [CurrencyModel?] = try await sut.getCurrencies(baseCurrency: "USD")
        
        XCTAssertEqual(sampleData, fetchData)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}




class MockRepository: APIRepositoryProtocol {
    func getCurrencies(baseCurrency: String) async throws -> (Data?, URLResponse) {
        let data = """
        {
            "disclaimer": "Usage subject to terms: https://openexchangerates.org/terms",
            "license": "https://openexchangerates.org/license",
            "timestamp": 1706562000,
            "base": "USD",
            "rates": {
                "AED": 3.6729,
                "AFN": 72.5,
                "ALL": 95.6,
                "AMD": 405.332115,
                "ANG": 1.801358,
                "AOA": 832.5,
            }
        }
        """.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        return (data, response)
    }
    
    
}
