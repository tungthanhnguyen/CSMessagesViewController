//
//  CSMessagesUIViewTests.swift
//  CSMessagesViewController
//
//  Created by Tung Thanh Nguyen on 12/10/16.
//  Copyright © 2016 Comtasoft. All rights reserved.
//

import XCTest

class CSMessagesUIViewTests: XCTestCase
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

	func testViewAutoLayoutPinEdges()
	{
		let superView: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
		let subView: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))

		superView.addSubview(subView)
		//XCTAssertThrowsError(superView.cs_pinAllEdgesOfSubview(subView))
		superView.cs_pinAllEdgesOfSubview(subView)

		XCTAssertEqual(superView.constraints.count, 4, "Superview should have 4 constraints")

		XCTAssertEqual(subView.constraints.count, 0, "Subview should have 0 constraints")

		for eachConstrant in superView.constraints
		{
			XCTAssert((eachConstrant.firstItem as! NSObject) == superView)
			XCTAssert((eachConstrant.secondItem as! NSObject) == subView)

			XCTAssertEqual(eachConstrant.relation, NSLayoutRelation.equal, "Constraint relation should be NSLayoutRelationEqual")

			XCTAssertEqual(eachConstrant.multiplier, 1.0, "Constraint multiplier should be 1.0")

			XCTAssertEqual(eachConstrant.constant, 0.0, "Constraint constant should be 0.0")
		}
	}
}
