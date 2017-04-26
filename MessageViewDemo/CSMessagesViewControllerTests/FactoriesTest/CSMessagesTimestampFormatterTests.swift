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

class CSMessagesTimestampFormatterTests: XCTestCase
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

	func testTimestampFormatterInit()
	{
		let formatter: CSMessagesTimestampFormatter = CSMessagesTimestampFormatter.sharedFormatter
		XCTAssertNotNil(formatter, "Formatter should not be nil")
		XCTAssertEqual(formatter, CSMessagesTimestampFormatter.sharedFormatter, "Shared formatter should return the same instance")

		let color: UIColor = UIColor.lightGray

		let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
		paragraphStyle.alignment = NSTextAlignment.center

		let dateAttrs: Dictionary<String, Any>! = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(12.0)), NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle]

		let timeAttrs: Dictionary<String, Any>! = [NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(12.0)), NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle]

		XCTAssertEqual(formatter.dateTextAttributes as NSObject, dateAttrs as NSObject, "Date attributes should be equal to default values")
		XCTAssertEqual(formatter.timeTextAttributes as NSObject, timeAttrs as NSObject, "Time attributes should be equal to default values")

		XCTAssertNotNil(formatter.dateFormatter, "Property should not be nil")
	}

	func testTimestampForDate()
	{
		var components: DateComponents = DateComponents()
		components.calendar = Calendar.current
		components.year = 2013
		components.month = 6
		components.day = 6
		components.hour = 19
		components.minute = 6
		components.second = 0

		let date: Date = components.date!

		let timestampString: String = CSMessagesTimestampFormatter.sharedFormatter.timestampForDate(date: date)
		XCTAssertEqual(timestampString, "Jun 6, 2013, 7:06 PM", "Timestamp string should return expected value")

		let timestampAttributedString: NSAttributedString = CSMessagesTimestampFormatter.sharedFormatter.attributedTimestampForDate(date: date)
		XCTAssertEqual(timestampAttributedString.string, "Jun 6, 2013 7:06 PM", "Attributed timestamp string should return expected value")
	}

	func testTimeForDate()
	{
		var components: DateComponents = DateComponents()
		components.calendar = Calendar.current
		components.hour = 7
		components.minute = 6
		components.second = 0

		let date: Date = components.date!

		let timeForDateString: String = CSMessagesTimestampFormatter.sharedFormatter.timeForDate(date: date)
		XCTAssertEqual(timeForDateString, "7:06 AM", "Time string should return expected value")
	}

	func testRelativeDataForDate()
	{
		let date: Date = Date()

		let relativeDateString: String = CSMessagesTimestampFormatter.sharedFormatter.relativeDateForDate(date: date)
		XCTAssertEqual(relativeDateString, "Today", "Relative date string shoudl return expected value")
	}
}
