//
//  PickupUITests.swift
//  PickupUITests
//
//  Created by Ben Koska on 3/18/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import XCTest

class PickupUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTeacherLogin() {
        
        let app = XCUIApplication()
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("ben@koska.at")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("1234")
        
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        XCTAssert(app.staticTexts["Title"].exists)
    }
    
    func testParentLogin() {
        
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("sedat@koska.at")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("1234")
        
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        XCTAssert(app.buttons["Arriving"].exists)
    }
    
    func testIncorrectEmail() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("sedat@koska.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("1234")
        
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        XCTAssert(app.staticTexts["Incorrect Email/Password"].exists)
    }
    
    func testIncorrectPassword() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("sedat@koska.at")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123")
        
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        XCTAssert(app.staticTexts["Incorrect Email/Password"].exists)
    }
    
    func testLogoout() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("sedat@koska.at")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("1234")
        
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        app.buttons["ic exit to app"].tap()
        
        XCTAssert(!app.buttons["Arriving"].exists)
    }

    
}
