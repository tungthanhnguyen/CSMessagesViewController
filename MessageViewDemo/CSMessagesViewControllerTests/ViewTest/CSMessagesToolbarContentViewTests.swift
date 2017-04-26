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
//@testable import MessageViewDemo

class CSMessagesToolbarContentViewTests: XCTestCase
{
	var contentView: CSMessagesToolbarContentView!

	override func setUp()
	{
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.

		let contentViewNib: UINib! = CSMessagesToolbarContentView.nib()
		XCTAssertNotNil(contentViewNib, "Nib should not be nil")

		let view: Array = contentViewNib.instantiate(withOwner: nil, options: nil) as Array
		self.contentView = view.first as! CSMessagesToolbarContentView
		XCTAssertNotNil(self.contentView, "Content view should not be nil")
	}

	override func tearDown()
	{
		self.contentView = nil

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

	func testToolbarContentViewInit()
	{
		XCTAssertTrue(self.contentView.frame.equalTo(CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(320.0), height: CGFloat(44.0))), "Frame should be equal to default value")

		XCTAssertNotNil(self.contentView.textView, "Text view should not be nil")
		XCTAssertNil(self.contentView.leftBarButtonItem, "Property should be equal to default value")
		XCTAssertNil(self.contentView.rightBarButtonItem, "Property should be equal to default value")
	}
}
