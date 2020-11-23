//
//  CurrencyCalculatorUITests.swift
//  CurrencyCalculatorUITests
//
//  Created by Vijay Patel on 19/11/20.
//

import XCTest

class CurrencyCalculatorUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testValidCurrencySelectionView_expenseRatesIsChanged() {
        
        let currencyText = "50"
        let app = XCUIApplication()
        app.launch()
        
        let currencyTextField = app.textFields["1"]
        XCTAssertTrue(currencyTextField.exists)
        
        currencyTextField.tap()
        
        currencyTextField.typeText(currencyText)
        
        let dropDownButton = app.buttons["USD"]
        XCTAssertTrue(dropDownButton.exists)
        
        dropDownButton.tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["ANG, Netherlands Antillean Guilder"]/*[[".cells[\"ANG, Netherlands Antillean Guilder\"].buttons[\"ANG, Netherlands Antillean Guilder\"]",".buttons[\"ANG, Netherlands Antillean Guilder\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let expenseRateANGView = app.buttons["269.27"]
        
//        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: expenseRateANGView, handler: nil)
//        waitForExpectations(timeout: 3, handler: nil)
        
        sleep(3)
        XCTAssertTrue(expenseRateANGView.exists)
        
        app.buttons["ANG"].tap()
        app.tables/*@START_MENU_TOKEN@*/.buttons["AFN, Afghan Afghani"]/*[[".cells[\"AFN, Afghan Afghani\"].buttons[\"AFN, Afghan Afghani\"]",".buttons[\"AFN, Afghan Afghani\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let expenseRateAfganView = app.buttons["11,557.56"]
        
//        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: expenseRateANGView, handler: nil)
//
//        waitForExpectations(timeout: 3, handler: nil)
        sleep(3)
        XCTAssertTrue(expenseRateAfganView.exists)
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
