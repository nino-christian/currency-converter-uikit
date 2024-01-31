//
//  currency_converterUITests.swift
//  currency-converterUITests
//
//  Created by Nino-Christian on 2/1/24.
//

import XCTest

final class currency_converterUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTextFieldExistAndAcceptsFloatingNumberAsString() throws {
        let allowedCharacters = CharacterSet(charactersIn: "1234567890.")
        
        let inputTextField =  app.textFields["InputCurrencyTextField"]
        XCTAssertTrue(inputTextField.exists)
        inputTextField.tap()
        inputTextField.typeText("12345.23")
        
        let inputTextFieldValue = inputTextField.value as! String 
        XCTAssertFalse(inputTextFieldValue.isEmpty, "Cannot convert an empty value")
        let characters = CharacterSet(charactersIn: inputTextFieldValue)
        let containsNum = allowedCharacters.isSuperset(of: characters)
        XCTAssertFalse(!containsNum, "Numbers are only accepted in this textfield")
        
        let outputTextField = app.textFields["OutputCurrencyTextField"]
        XCTAssertTrue(outputTextField.exists)
        let outputTextFieldValue = outputTextField.value as! String
        XCTAssertEqual(inputTextFieldValue, outputTextFieldValue) // Given that there are no difference in currency.
        
    }
    
    func testTableViewExistAndContainsCells() {
        let tableView = app.tables["CurrenciesTableView"]
        
        XCTAssertTrue(tableView.exists, "No currencies table exists")
        
        let cellCount = tableView.cells.count
        
        XCTAssertTrue(cellCount > 0, "Table view does not contain any cell")
    }
    
    func testInputCurrencyButtonTapAndShowPopupViewController() {
        
        let inputButton = app.buttons["InputCurrencyButton"]
        XCTAssertTrue(inputButton.exists)
        inputButton.tap()
        
        let viewController = app.otherElements["PopupViewController"]
        XCTAssertTrue(viewController.exists)
        
        let tableView = app.tables["PopupTableView"]
        XCTAssertTrue(tableView.exists)
        
        let cellCount = tableView.cells.count
        
        XCTAssertTrue(cellCount > 0, "Table view does not contain any cell")
    }
    
    func testOutCurrencyButtonTapAndShowPopupViewController() {
        
        let outputButton = app.buttons["OutputCurrencyButton"]
        XCTAssertTrue(outputButton.exists)
        outputButton.tap()
        
        let viewController = app.otherElements["PopupViewController"]
        XCTAssertTrue(viewController.exists)
        
        let tableView = app.tables["PopupTableView"]
        XCTAssertTrue(tableView.exists)
        
        let cellCount = tableView.cells.count
        
        XCTAssertTrue(cellCount > 0, "Table view does not contain any cell")
    }
    
    
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
