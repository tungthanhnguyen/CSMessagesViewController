//
//  CSMessagesAvatarFactoryTests.swift
//  CSMessagesViewController
//
//  Created by Tung Thanh Nguyen on 12/10/16.
//  Copyright © 2016 Comtasoft. All rights reserved.
//

import CSMessagesViewController
import XCTest

class CSMessagesAvatarFactoryTests: XCTestCase
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

	func testAvatarImage()
	{
		let image: UIImage = UIImage(named: "demo_avatar_jobs")!
		XCTAssertNotNil(image, "Image should not be nil")
	}

	func testAvatarInitialsImage()
	{
		let diameter: CGFloat = 50.0
		let avatar: UIImage = CSMessagesAvatarFactory.avatarWithUserInitials("CS", backgroundColor: UIColor.lightGray, textColor: UIColor.darkGray, font: UIFont.systemFont(ofSize: 13.0), diameter: Int(diameter))

		XCTAssertNotNil(avatar, "Avatar should not be nil")
		XCTAssertTrue(avatar.size.equalTo(CGSize(width: CGFloat(diameter), height: CGFloat(diameter))), "Avatar size should be equal to diameter")
		XCTAssertEqual(avatar.scale, UIScreen.main.scale, "Avatar scale should be equal to screen scale")
	}
}
