//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//
//
//  Converted to Swift by Tung Thanh Nguyen
//  Copyright © 2016 Tung Thanh Nguyen.
//  Released under an MIT license: http://opensource.org/licenses/MIT
//
//  GitHub
//  https://github.com/tungthanhnguyen/CSMessagesViewController
//

import CSMessagesViewController
import XCTest

class CSMessagesToolbarButtonFactoryTests: XCTestCase
{
	override func setUp()
	{
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown()
	{
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testExample()
	{
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}

	func testPerformanceExample()
	{
		// This is an example of a performance test case.
		self.measure
		{
			// Put the code you want to measure the time of here.
		}
	}

	func testDefaultSendButtonItem()
	{
		let button: UIButton = CSMessagesToolbarButtonFactory.defaultSendButtonItem()
		XCTAssertNotNil(button, "Button should not be nil")

		XCTAssertTrue(button.frame.equalTo(CGRect.zero), "Button initial frame should equal CGRect.zero")

		let title: String = "Send"
		XCTAssertEqual(button.title(for: UIControlState.normal), title, "Button title should equal \(title)")
		XCTAssertNil(button.imageView?.image, "Button image should be nil")

		XCTAssertEqual(button.titleColor(for: UIControlState.normal), UIColor.cs_messageBubbleBlueColor(), "Button normal title color should be set")
		XCTAssertEqual(button.titleColor(for: UIControlState.highlighted), UIColor.cs_messageBubbleBlueColor().cs_colorByDarkeningColorWithValue(0.1), "Button highlighted title color should be set")
		XCTAssertEqual(button.titleColor(for: UIControlState.disabled), UIColor.lightGray, "Button disabled title color should be set")

		XCTAssertEqual(button.titleLabel?.font, UIFont.boldSystemFont(ofSize: 17.0), "Button font should be set")
		XCTAssertEqual(button.contentMode, UIViewContentMode.center, "Button content mode should be set")
		XCTAssertEqual(button.backgroundColor, UIColor.clear, "Button background color should be set")
		XCTAssertEqual(button.tintColor, UIColor.cs_messageBubbleBlueColor(), "Button tint color should be set")
	}

	func testDefaultAccessoryButtonItem()
	{
		let button: UIButton = CSMessagesToolbarButtonFactory.defaultAccessoryButtonItem()
		XCTAssertNotNil(button, "Button should not be nil")

		XCTAssertTrue(button.frame.equalTo(CGRect.zero), "Button frame should equal CGRect.zero")

		XCTAssertNil(button.titleLabel?.text, "Button title should be nil")
		XCTAssertNotNil(button.image(for: UIControlState.normal), "Button normal image should not be nil")
		XCTAssertNotNil(button.image(for: UIControlState.highlighted), "Button highlighted image should not be nil")

		XCTAssertEqual(button.contentMode, UIViewContentMode.scaleAspectFit, "Button content mode should be set")
		XCTAssertEqual(button.backgroundColor, UIColor.clear, "Button background color should be set")
		XCTAssertEqual(button.tintColor, UIColor.lightGray, "Button tint color should be set")
	}
}
