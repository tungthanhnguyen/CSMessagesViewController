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

class CSMessagesBubbleImageFactoryTests: XCTestCase
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

	func testOutgoingMessageBubbleImageView()
	{
		let bubble: UIImage = UIImage(named: "bubble_min")!
		XCTAssertNotNil(bubble, "Bubble image should not be nil")

		let center: CGPoint = CGPoint(x: bubble.size.width / 2.0, y: bubble.size.height / 2.0)
		let capInsets: UIEdgeInsets = UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)

		let imageView: UIImageView = CSMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(color: UIColor.lightGray)
		XCTAssertNotNil(imageView, "ImageView should not be nil")
		XCTAssertEqual(imageView.backgroundColor, UIColor.white, "ImageView should have white background color")
		XCTAssertTrue(imageView.frame.size.equalTo(bubble.size), "ImageView size should equal bubble size")

		XCTAssertNotNil(imageView.image, "Image should not be nil")
		XCTAssertEqual(imageView.image?.scale, bubble.scale, "Image scale should equal bubble image scale")
		XCTAssertEqual(imageView.image?.imageOrientation, bubble.imageOrientation, "Image orientation should equal bubble image orientation")
		XCTAssertTrue(imageView.image?.resizingMode == UIImageResizingMode.stretch, "Image should be stretchable")
		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets((imageView.image?.capInsets)!, capInsets), "Image capInsets should be equal to capInsets")

		XCTAssertNotNil(imageView.highlightedImage, "HighlightedImage should not be nil")
		XCTAssertEqual(imageView.highlightedImage?.scale, bubble.scale, "HighlightedImage scale should equal bubble image scale")
		XCTAssertEqual(imageView.highlightedImage?.imageOrientation, bubble.imageOrientation, "HighlightedImage orientation should equal bubble image orientation")
		XCTAssertTrue(imageView.highlightedImage?.resizingMode == UIImageResizingMode.stretch, "HighlightedImage should be stretchable")
		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets((imageView.highlightedImage?.capInsets)!, capInsets), "HighlightedImage capInsets should be equal to capInsets")
	}

	func testIncomingMessageBubbleImageView()
	{
		let bubble: UIImage = UIImage(named: "bubble_min")!
		XCTAssertNotNil(bubble, "Bubble image should not be nil")

		let center: CGPoint = CGPoint(x: bubble.size.width / 2.0, y: bubble.size.height / 2.0)
		let capInsets: UIEdgeInsets = UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)

		let imageView: UIImageView = CSMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(color: UIColor.lightGray)
		XCTAssertNotNil(imageView, "ImageView should not be nil")
		XCTAssertEqual(imageView.backgroundColor, UIColor.white, "ImageView should have white background color")
		XCTAssertTrue(imageView.frame.size.equalTo(bubble.size), "ImageView size should equal bubble size")

		XCTAssertNotNil(imageView.image, "Image should not be nil")
		XCTAssertEqual(imageView.image?.scale, bubble.scale, "Image scale should equal bubble image scale")
		XCTAssertNotEqual(imageView.image?.imageOrientation, bubble.imageOrientation, "Image orientation should not equal bubble image orientation")
		XCTAssertTrue(imageView.image?.resizingMode == UIImageResizingMode.stretch, "Image should be stretchable")
		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets((imageView.image?.capInsets)!, capInsets), "Image capInsets should be equal to capInsets")

		XCTAssertNotNil(imageView.highlightedImage, "HighlightedImage should not be nil")
		XCTAssertEqual(imageView.highlightedImage?.scale, bubble.scale, "HighlightedImage scale should equal bubble image scale")
		XCTAssertNotEqual(imageView.highlightedImage?.imageOrientation, bubble.imageOrientation, "HighlightedImage orientation should not equal bubble image orientation")
		XCTAssertTrue(imageView.highlightedImage?.resizingMode == UIImageResizingMode.stretch, "HighlightedImage should be stretchable")
		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets((imageView.highlightedImage?.capInsets)!, capInsets), "HighlightedImage capInsets should be equal to capInsets")
	}
}
