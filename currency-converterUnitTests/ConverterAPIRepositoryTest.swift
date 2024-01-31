//
//  ConverterAPIRepositoryTest.swift
//  currency-converterUnitTests
//
//  Created by Nino-Christian on 2/1/24.
//

import XCTest
@testable import currency_converter

final class ConverterAPIRepositoryTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchFromNetworkAPI() async throws {
        let sut = APIRepository()

        let (data, response) = try await sut.getCurrencies(baseCurrency: "USD")
        
        XCTAssertNotNil(data)
        XCTAssertNotNil(response)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
