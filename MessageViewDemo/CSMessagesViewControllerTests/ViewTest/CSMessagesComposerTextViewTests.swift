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

class CSMessagesComposerTextViewTests: XCTestCase
{
	var textView: CSMessagesComposerTextView!

	override func setUp()
	{
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.

		self.textView = CSMessagesComposerTextView(frame: CGRect(x: 0.0, y: 0.0, width: 300.0, height: 50.0), textContainer: NSTextContainer())
	}

	override func tearDown()
	{
		self.textView = nil

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

	func testComposerTextViewInit()
	{
		XCTAssertNotNil(self.textView, "Text view should not be nil")

		XCTAssertNil(self.textView.text, "Property should be equal to default value")
		XCTAssertNil(self.textView.placeHolder, "Property should be equal to default value")
		XCTAssertEqual(self.textView.placeHolderTextColor, UIColor.lightGray, "Property should be equal to default value")

		XCTAssertEqual(self.textView.backgroundColor, UIColor.white, "Property should be equal to default value")

		XCTAssertEqual(self.textView.layer.borderWidth, 0.5, "Property should be equal to default value")
		XCTAssertEqual(self.textView.layer.borderColor, UIColor.lightGray.cgColor, "Property should be equal to default value")
		XCTAssertEqual(self.textView.layer.cornerRadius, 6.0, "Property should be equal to default value")

		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(self.textView.scrollIndicatorInsets, UIEdgeInsets(top: 6.0, left: 0.0, bottom: 6.0, right: 0.0)), "Property should be equal to default value")

		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(self.textView.textContainerInset, UIEdgeInsets(top: 4.0, left: 2.0, bottom: 4.0, right: 2.0)), "Property should be equal to default value")
		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(self.textView.contentInset, UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 0.0)), "Property should be equal to default value")

		XCTAssertEqual(self.textView.isScrollEnabled, true, "Property should be equal to default value")
		XCTAssertEqual(self.textView.scrollsToTop, false, "Property should be equal to default value")
		XCTAssertEqual(self.textView.isUserInteractionEnabled, true, "Property should be equal to default value")

		XCTAssertEqual(self.textView.contentMode, UIViewContentMode.redraw, "Property should be equal to default value")
		XCTAssertEqual(self.textView.dataDetectorTypes, UIDataDetectorTypes(rawValue: 0), "Property should be equal to default value")
		XCTAssertEqual(self.textView.keyboardAppearance, UIKeyboardAppearance.default, "Property should be equal to default value")
		XCTAssertEqual(self.textView.keyboardType, UIKeyboardType.default, "Property should be equal to default value")
		XCTAssertEqual(self.textView.returnKeyType, UIReturnKeyType.default, "Property should be equal to default value")
	}
}
