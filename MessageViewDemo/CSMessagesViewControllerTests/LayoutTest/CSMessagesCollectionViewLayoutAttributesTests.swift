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

class CSMessagesCollectionViewLayoutAttributesTests: XCTestCase
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

	func testLayoutAttributesInitAndIsEqual()
	{
		let indexPath: IndexPath = IndexPath(item: 0, section: 0)
		let attrs: CSMessagesCollectionViewLayoutAttributes = CSMessagesCollectionViewLayoutAttributes(forCellWith: indexPath)
		XCTAssertNotNil(attrs, "Layout attributes should not be nil")

		attrs.messageBubbleFont = UIFont.systemFont(ofSize: 15.0)
		attrs.messageBubbleLeftRightMargin = 40.0
		attrs.textViewTextContainerInsets = UIEdgeInsets(top: 10.0, left: 8.0, bottom: 10.0, right: 8.0)
		attrs.textViewFrameInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 6.0)
		attrs.incomingAvatarViewSize = CGSize(width: 34.0, height: 34.0)
		attrs.outgoingAvatarViewSize = CGSize.zero
		attrs.cellTopLabelHeight = 20.0
		attrs.messageBubbleTopLabelHeight = 10.0
		attrs.cellBottomLabelHeight = 15.0

		let copy: CSMessagesCollectionViewLayoutAttributes = attrs.copy() as! CSMessagesCollectionViewLayoutAttributes
		XCTAssertEqual(attrs, copy, "Copied attributes should be equal")
		XCTAssertEqual(attrs.hashValue, copy.hashValue, "Copied attributes hashes should be equal")
	}
}
