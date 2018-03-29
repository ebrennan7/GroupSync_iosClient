//
//  GroupSync_iosClientUITests.swift
//  GroupSync_iosClientUITests
//
//  Created by Ember Brennan on 28/11/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import XCTest

class GroupSync_iosClientUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        
//        let app = XCUIApplication()
//        app.buttons["GroupsIcon"].tap()
//
//        let tabBarsQuery = app.tabBars
//        tabBarsQuery.buttons["Private"].tap()
//        tabBarsQuery.buttons["Public"].tap()
//        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Ember Brennan boy zone 4").element.tap()
//        app.buttons["Join Group"].tap()
//        app.alerts["You have joined the group!"].buttons["Ok"].tap()
//        app.buttons["Settings"].tap()
//
//        let element = app.otherElements.containing(.navigationBar, identifier:"GroupSync_iosClient.GroupSettingsView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
//        let collectionView = element.children(matching: .collectionView).element
//        collectionView.swipeUp()
//        collectionView.swipeDown()
//
//        let textField = element.children(matching: .textField).element
//        textField.tap()
//        textField.tap()
//        textField.typeText("ember.brennan@gmail.com")
//        app.typeText("\r")
//        app.alerts["User Invite Successful"].buttons["Ok"].tap()
//        collectionView.swipeUp()
//        collectionView.swipeDown()
//        app.buttons["Delete Group?"].tap()
//        app.alerts["Group Deletion Successul"].buttons["Ok"].tap()
//
//        ///Log out
//
//
//        let app2 = app
//        let app = app2
//        app.otherElements.containing(.navigationBar, identifier:"GroupSync_iosClient.ProfileView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).tap()
//        app.buttons["LOG OUT"].tap()
//        app.alerts["Are you sure you want to log out?"].buttons["Yes"].tap()
//        app.buttons["SIGN UP"].tap()
//
//        let scrollViewsQuery2 = app2/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"SignUp\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        let elementsQuery2 = scrollViewsQuery2.otherElements
//        _ textField = elementsQuery2.children(matching: .textField).element(boundBy: 0)
//        textField.tap()
//        textField.typeText("John")
//
//        let textField2 = elementsQuery2.children(matching: .textField).element(boundBy: 1)
//        textField2.tap()
//        textField2.typeText("Doe")
//
//        let textField3 = elementsQuery2.children(matching: .textField).element(boundBy: 2)
//        textField3.tap()
//        textField3.typeText("John@Gmail.com")
//
//        let secureTextField = elementsQuery2.children(matching: .secureTextField).element(boundBy: 0)
//        secureTextField.tap()
//        secureTextField.tap()
//        secureTextField.typeText("password1")
//
//        let secureTextField2 = elementsQuery2.children(matching: .secureTextField).element(boundBy: 1)
//        secureTextField2.tap()
//        secureTextField2.tap()
//        secureTextField2.typeText("password1")
//
//        let firstNameElement = scrollViewsQuery2.otherElements.containing(.staticText, identifier:"First Name:").element
//        firstNameElement.swipeUp()
//        firstNameElement.swipeUp()
//        elementsQuery2.buttons["SIGN UP"].tap()
//        app.alerts["Signup successful"].buttons["Login"].tap()
//
//        let window = app.children(matching: .window).element(boundBy: 0)
//        _ = window.children(matching: .other).element(boundBy: 2).children(matching: .other).element
//        let textField4 = element.children(matching: .textField).element
//        textField4.tap()
//        textField4.typeText("john@gmail.com")
//
//        let secureTextField3 = element.children(matching: .secureTextField).element
//        secureTextField3.tap()
//        secureTextField3.tap()
//        secureTextField3.typeText("password1")
//        app.buttons["LOG IN"].tap()
//        app.buttons["CreateGroupIcon"].tap()
//
//        let scrollViewsQuery = app.scrollViews
//        let createGroupElementsQuery = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Create Group")
//        let textField5 = createGroupElementsQuery.children(matching: .textField).element
//        textField5.tap()
//        textField5.typeText("New Group")
//        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Create Group").element.swipeUp()
//        createGroupElementsQuery.children(matching: .datePicker).element(boundBy: 1).pickerWheels["Today"].swipeUp()
//
//        let elementsQuery = scrollViewsQuery.otherElements
//        elementsQuery.datePickers.otherElements.containing(.pickerWheel, identifier:"Today").pickerWheels["PM"].swipeUp()
//        elementsQuery.buttons["Create Group"].tap()
//        app.alerts["Group Creation Successul"].buttons["Ok"].tap()
//        app.buttons["GroupsIcon"].tap()
//        app.tabBars.buttons["Private"].tap()
//        app.collectionViews.cells.otherElements.containing(.image, identifier:"Groups").element.tap()
//
//        let settingsButton = app.buttons["Settings"]
//        settingsButton.tap()
//
//        let textField6 = window.children(matching: .other).element(boundBy: 3).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
//        textField6.tap()
//        textField6.typeText("ember.brennan@gmail.com")
//        app.typeText("\r")
//        app.alerts["User Invite Successful"].buttons["Ok"].tap()
//
//        let johnDoeStaticText = app2.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["John Doe"]/*[[".cells.staticTexts[\"John Doe\"]",".staticTexts[\"John Doe\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        johnDoeStaticText/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeDown()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        app.navigationBars["GroupSync_iosClient.GroupSettingsView"].buttons["Back"].tap()
//        settingsButton.tap()
//        johnDoeStaticText.swipeUp()
        
        
        
        
        let app = XCUIApplication()
        app.buttons["SIGN UP"].tap()
        
        let scrollViewsQuery3 = app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"SignUp\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let elementsQuery3 = scrollViewsQuery3.otherElements
        let textField = elementsQuery3.children(matching: .textField).element(boundBy: 0)
        textField.tap()
        textField.typeText("Michael")
        
        let textField2 = elementsQuery3.children(matching: .textField).element(boundBy: 1)
        textField2.tap()
        textField2.tap()
        textField2.typeText("West")
        
        let textField3 = elementsQuery3.children(matching: .textField).element(boundBy: 2)
        textField3.tap()
        textField3.tap()
        
        let randomDigit = Int(arc4random_uniform(100)) //Each test should hve a different email

        textField3.typeText("Michael\(randomDigit)@Gmail.com")
        
        let secureTextField = elementsQuery3.children(matching: .secureTextField).element(boundBy: 0)
        secureTextField.tap()
        secureTextField.tap()
        secureTextField.typeText("password1")
        
        let scrollViewsQuery = scrollViewsQuery3
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"First Name:").element.tap()
        
        let elementsQuery = scrollViewsQuery.otherElements
        let secureTextField2 = elementsQuery.children(matching: .secureTextField).element(boundBy: 1)
        secureTextField2.tap()
        secureTextField2.tap()
        secureTextField2.typeText("password1")
        elementsQuery.staticTexts["Verify Password:"].tap()
        elementsQuery.buttons["SIGN UP"].tap()
        print(randomDigit)
        
        addUIInterruptionMonitor(withDescription: "alert description") { (alert) -> Bool in
            let alertButton = alert.buttons["OK"]
            if alertButton.exists {
                alertButton.tap()
                return true
            }
            return false
        }
        app.tap()
//        app.alerts["Signup successful"].buttons["Login"].tap()
        
        let window = app.children(matching: .window).element(boundBy: 0)
        let element2 = window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField4 = element2.children(matching: .textField).element
        textField4.tap()
        

        textField4.typeText("Michael\(randomDigit)@Gmail.com")
        
        let secureTextField3 = element2.children(matching: .secureTextField).element
        secureTextField3.tap()
        secureTextField3.tap()
        secureTextField3.typeText("password1")
        app.buttons["LOG IN"].tap()
        app.buttons["CreateGroupIcon"].tap()
        
        let scrollViewsQuery2 = app.scrollViews
        let createGroupElementsQuery = scrollViewsQuery2.otherElements.containing(.staticText, identifier:"Create Group")
        let textField5 = createGroupElementsQuery.children(matching: .textField).element
        textField5.tap()
        textField5.typeText("Group 1")
        
        let createGroupElement = scrollViewsQuery2.otherElements.containing(.staticText, identifier:"Create Group").element
        createGroupElement.swipeUp()
//        createGroupElementsQuery.children(matching: .datePicker).element(boundBy: 0).pickerWheels["10 o’clock"]/*@START_MENU_TOKEN@*/.press(forDuration: 1.4);/*[[".tap()",".press(forDuration: 1.4);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        createGroupElement.swipeUp()
//
        let elementsQuery2 = scrollViewsQuery2.otherElements
//        elementsQuery2.datePickers.otherElements.containing(.pickerWheel, identifier:"10 o’clock").pickerWheels["Today"]/*@START_MENU_TOKEN@*/.press(forDuration: 0.7);/*[[".tap()",".press(forDuration: 0.7);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        elementsQuery2.buttons["Create Group"].tap()
        app.alerts["Group Creation Successul"].buttons["Ok"].tap()
        app.buttons["GroupsIcon"].tap()
        app.tabBars.buttons["Private"].tap()
        app.collectionViews.cells.otherElements.containing(.image, identifier:"Groups").element.tap()
        
        let londonderryMap = app
        londonderryMap/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeUp()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        londonderryMap/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeUp()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.buttons["Settings"].tap()
        
        let element3 = window.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField6 = element3.children(matching: .textField).element
        textField6.tap()
        textField6.typeText("ember.brennan@gmail.com")
        app.typeText("\r")
        app.alerts["User Invite Successful"].buttons["Ok"].tap()
        app.buttons["Delete Group?"].tap()
        app.alerts["Group Deletion Successul"].buttons["Ok"].tap()
        
        let profileiconButton = app.buttons["ProfileIcon"]
        profileiconButton.tap()
        
        let button = element3.children(matching: .other).element(boundBy: 1).buttons["Button"]
        button.tap()
        
        let element = element3.children(matching: .other).element(boundBy: 3)
        element.children(matching: .button).matching(identifier: "Button").element(boundBy: 1).tap()
        
        let textField7 = element.children(matching: .textField).element(boundBy: 0)
        textField7.tap()
        textField7.typeText("Michael East")
        
        let textField8 = element.children(matching: .textField).element(boundBy: 1)
        textField8.tap()
        textField8.tap()
        let randomDigit2 = Int(arc4random_uniform(100)) //Each test should hve a different email

        
        textField8.typeText("Michael\(randomDigit2)@gmail.com")
        window.buttons["Done"].tap()
        button.tap()
        element.children(matching: .button).matching(identifier: "Button").element(boundBy: 0).tap()
        app.collectionViews["PhotosGridView"].cells["Photo, Landscape, August 08, 2012, 10:55 PM"].tap()
        app.navigationBars["GroupSync_iosClient.ProfileView"].buttons["Back"].tap()
        profileiconButton.tap()
        app.buttons["LOG OUT"].tap()
        app.alerts["Are you sure you want to log out?"].buttons["Yes"].tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testLogOutTest()
    {
        
    }
    
}
