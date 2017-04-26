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

class CSMessagesCollectionViewTests: XCTestCase
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

	func testCollectionViewInit()
	{
		let layout: CSMessagesCollectionViewFlowLayout = CSMessagesCollectionViewFlowLayout()
		let view: CSMessagesCollectionView = CSMessagesCollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
		XCTAssertNotNil(view, "Collection view should not be nil")

		XCTAssertEqual(view.backgroundColor, UIColor.white, "Property should be equal to default value")
		XCTAssertEqual(view.keyboardDismissMode, UIScrollViewKeyboardDismissMode.interactive, "Property should be equal to default value")
		XCTAssertEqual(view.alwaysBounceVertical, true, "Property should be equal to default value")
		XCTAssertEqual(view.bounces, true, "Property should be equal to default value")
	}
}
