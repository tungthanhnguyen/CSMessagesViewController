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

class CSMessagesViewControllerTests: XCTestCase
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

	func testJSQMessagesViewControllerInit()
	{
		let nib: UINib = CSMessagesViewController.nib()
		XCTAssertNotNil(nib, "Nib should not be nil")

		let vc: CSMessagesViewController = CSMessagesViewController()
		XCTAssertNotNil(vc, "View controller should not be nil")

		XCTAssertNotNil(vc.view, "View should not be nil")
		XCTAssertNotNil(vc.collectionView, "Collection view should not be nil")
		XCTAssertNotNil(vc.inputToolbar, "Input toolbar should not be nil")

		XCTAssertEqual(vc.sender, "CSDefaultSender", "Property should be equal to default value")
		XCTAssertEqual(vc.automaticallyAdjustsScrollViewInsets, true, "Property should be equal to default value")
		XCTAssertEqual(vc.incomingCellIdentifier, CSMessagesCollectionViewCellIncoming.cellReuseIdentifier(), "Property should be equal to default value")
		XCTAssertEqual(vc.outgoingCellIdentifier, CSMessagesCollectionViewCellOutgoing.cellReuseIdentifier(), "Property should be equal to default value")
		XCTAssertEqual(vc.typingIndicatorColor, UIColor.cs_messageBubbleLightGrayColor(), "Property should be equal to default value")
		XCTAssertEqual(vc.isShowTypingIndicator, false, "Property should be equal to default value")
		XCTAssertEqual(vc.isShowLoadEarlierMessagesHeader, false, "Property should be equal to default value")
	}
}
