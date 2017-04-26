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

class CSMessagesCollectionViewFlowLayoutTests: XCTestCase
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

	func testFlowLayoutInit()
	{
		let layout: CSMessagesCollectionViewFlowLayout = CSMessagesCollectionViewFlowLayout.init()
		XCTAssertNotNil(layout, "Layout should not be nil")

		XCTAssertEqual(layout.scrollDirection, UICollectionViewScrollDirection.vertical, "Property should be equal to default value")
		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(layout.sectionInset, UIEdgeInsetsMake(10.0, 4.0, 10.0, 4.0)), "Property should be equal to default value")
		XCTAssertEqual(layout.minimumLineSpacing, 4.0, "Property should be equal to default value")

		XCTAssertEqual(layout.isSpringinessEnabled, false, "Property should be equal to default value")
		XCTAssertEqual(layout.springResistanceFactor, 1000, "Property should be equal to default value")
		XCTAssertEqual(layout.messageBubbleFont, UIFont.systemFont(ofSize: 15.0), "Property should be equal to default value")
		XCTAssertEqual(layout.messageBubbleLeftRightMargin, 40.0, "Property should be equal to default value")
		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(layout.messageBubbleTextViewFrameInsets, UIEdgeInsetsMake(0.0, 0.0, 0.0, 6.0)), "Property should be equal to default value")
		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(layout.messageBubbleTextViewTextContainerInsets!, UIEdgeInsetsMake(10.0, 8.0, 10.0, 8.0)), "Property should be equal to default value")
		XCTAssertTrue(layout.incomingAvatarViewSize.equalTo(CGSize(width: CGFloat(34.0), height: CGFloat(34.0))), "Property should be equal to default value")
		XCTAssertTrue(layout.outgoingAvatarViewSize.equalTo(CGSize(width: CGFloat(34.0), height: CGFloat(34.0))), "Property should be equal to default value")
	}
}
