//
//  CSMessagesUIImageTests.swift
//  CSMessagesViewController
//
//  Created by Tung Thanh Nguyen on 12/10/16.
//  Copyright © 2016 Comtasoft. All rights reserved.
//

import CSMessagesViewController
import XCTest

class MyBundle: NSObject {}

class CSMessagesUIImageTests: XCTestCase
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

	func testImageMasking()
	{
		//let img: UIImage = UIImage(named: "bubble_min", in: Bundle.allFrameworks[0], compatibleWith: nil)!

		let img: UIImage = UIImage(named: "CSMessagesViewControllerTests.xctest/bubble_min")!
		XCTAssertNotNil(img, "Image should not be nil")

		let imgMasked: UIImage = img.cs_imageMaskedWithColor(UIColor.white)
		XCTAssertNotNil(imgMasked, "Image should not be nil")
	}
}
