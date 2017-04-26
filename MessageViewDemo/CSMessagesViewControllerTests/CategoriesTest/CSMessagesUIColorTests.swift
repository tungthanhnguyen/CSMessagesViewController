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

class CSMessagesUIColorTests: XCTestCase
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

	func testGreenColor()
	{
		var h: CGFloat = 0.0, s: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

		let green: UIColor = UIColor.cs_messageBubbleGreenColor()
		XCTAssertNotNil(green, "Color should not be nil")

		green.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		let copyGreen: UIColor = UIColor(hue: h, saturation: s, brightness: b, alpha: a)
		XCTAssertEqual(green, copyGreen, "Colors should be equal")
	}

	func testBlueColor()
	{
		var h: CGFloat = 0.0, s: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

		let blue: UIColor = UIColor.cs_messageBubbleBlueColor()
		XCTAssertNotNil(blue, "Color should not be nil")

		blue.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		let copyBlue: UIColor = UIColor(hue: h, saturation: s, brightness: b, alpha: a)
		XCTAssertEqual(blue, copyBlue, "Colors should be equal")
	}

	func testGrayColor()
	{
		var h: CGFloat = 0.0, s: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

		let gray: UIColor = UIColor.cs_messageBubbleLightGrayColor()
		XCTAssertNotNil(gray, "Color should not be nil")

		gray.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		let copyGray: UIColor = UIColor(hue: h, saturation: s, brightness: b, alpha: a)
		XCTAssertEqual(gray, copyGray, "Colors should be equal")
	}

	func testDarkeningColors()
	{
		let r: CGFloat = 0.89, g: CGFloat = 0.34, b: CGFloat = 0.67, a: CGFloat = 1.0

		let darkeningValue: CGFloat = 0.12

		let color: UIColor = UIColor(red: r, green: g, blue: b, alpha: a)
		let darkColor: UIColor = color.cs_colorByDarkeningColorWithValue(darkeningValue)

		var dr: CGFloat = 0.0, dg: CGFloat = 0.0, db: CGFloat = 0.0, da: CGFloat = 0.0
		darkColor.getRed(&dr, green: &dg, blue: &db, alpha: &da)
		XCTAssertEqual(dr, r - darkeningValue, "Red values should be equal")
		XCTAssertEqual(dg, g - darkeningValue, "Green values should be equal")
		XCTAssertEqual(db, b - darkeningValue, "Blue values should be equal")
		XCTAssertEqual(da, a, "Alpha values should be equal")
	}

	func testDarkeningColorsFloorToZero()
	{
		let r: CGFloat = 0.89, g: CGFloat = 0.24, b: CGFloat = 0.67, a: CGFloat = 1.0

		let darkeningValue: CGFloat = 0.5

		let color: UIColor = UIColor(red: r, green: g, blue: b, alpha: a)
		let darkColor: UIColor = color.cs_colorByDarkeningColorWithValue(darkeningValue)

		var dr: CGFloat = 0.0, dg: CGFloat = 0.0, db: CGFloat = 0.0, da: CGFloat = 0.0
		darkColor.getRed(&dr, green: &dg, blue: &db, alpha: &da)
		XCTAssertEqual(dr, r - darkeningValue, "Red values should be equal")
		XCTAssertEqual(dg, 0.0, "Green values should be floored to zero")
		XCTAssertEqual(db, b - darkeningValue, "Blue values should be equal")
		XCTAssertEqual(da, a, "Alpha values should be equal")
	}
}
