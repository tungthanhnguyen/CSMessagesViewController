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

class CSMessageTests: XCTestCase
{
	var text: NSString?
	var sender: String?
	var date: Date?

	override func setUp()
	{
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.

		self.text = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo."
		self.sender = "Jesse Squires"
		self.date = Date()
	}

	override func tearDown()
	{
		self.text = nil
		self.sender = nil
		self.date = nil

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

	func testMessageInit()
	{
		let msg0: CSMessage = CSMessage(initWithText: self.text!, sender: self.sender!, date: self.date!)
		XCTAssertNotNil(msg0, "Message should not be nil")

		let msg1: CSMessage = CSMessage(messageWithText: self.text!, sender: self.sender!)
		XCTAssertNotNil(msg1, "Message should not be nil")
	}

	func testMessageIsEqual()
	{
		let msg: CSMessage = CSMessage(messageWithText: self.text!, sender: self.sender!)
		let copy: CSMessage = msg.copy() as! CSMessage

		XCTAssertEqual(msg, copy, "Copied messages should be equal")
		XCTAssertNotEqual(msg.hashValue, copy.hashValue, "Copied messages hashes not should be equal")

		XCTAssertTrue(msg.isEqual(copy), "Copied messages should be equal")
		XCTAssertTrue(msg.isEqual(msg), "Messages should be equal to itself")
		XCTAssertFalse(msg.isEqual(nil), "Initialized message should not be equal to nil")
	}

	func testMessageArchiving()
	{
		let msg: CSMessage = CSMessage(messageWithText: self.text!, sender: self.sender!)
		let msgData: Data = NSKeyedArchiver.archivedData(withRootObject: msg)

		let unarchivedMsg: CSMessage = NSKeyedUnarchiver.unarchiveObject(with: msgData) as! CSMessage

		XCTAssertTrue(msg.isEqualToMessage(aMessage: unarchivedMsg), "Message should be equal")
	}
}
