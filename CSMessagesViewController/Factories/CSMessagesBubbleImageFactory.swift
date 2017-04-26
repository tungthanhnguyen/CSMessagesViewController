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

import Foundation
import UIKit

public class CSMessagesBubbleImageFactory: NSObject
{
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Public

	/**
	 *  Creates an returns an image view object with the specified color for outgoing messages.
	 *  The `image` property of the image view is configured with a flat bubble image, masked to the given color.
	 *  The `highlightedImage` property is configured similarly, but with a darkened version of the given color.
	 *
	 *  @param color The color of the bubble image in the image view. This value must not be `nil`.
	 *
	 *  @return An initialized image view object if created successfully, `nil` otherwise.
	 */
	public class func outgoingMessageBubbleImageViewWithColor(color: UIColor) -> UIImageView
	{
		return CSMessagesBubbleImageFactory.bubbleImageViewWithColor(color: color, flippedForIncoming: false)
	}

	/**
	 *  Creates an returns an image view object with the specified color for incoming messages.
	 *  The `image` property of the image view is configured with a flat bubble image, masked to the given color.
	 *  The `highlightedImage` property is configured similarly, but with a darkened version of the given color.
	 *
	 *  @param color The color of the bubble image in the image view. This value must not be `nil`.
	 *
	 *  @return An initialized image view object if created successfully, `nil` otherwise.
	 */
	public class func incomingMessageBubbleImageViewWithColor(color: UIColor) -> UIImageView
	{
		return CSMessagesBubbleImageFactory.bubbleImageViewWithColor(color: color, flippedForIncoming: true)
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Private

	private class func bubbleImageViewWithColor(color: UIColor, flippedForIncoming: Bool) -> UIImageView
	{
		let bubble = UIImage.cs_bubbleImageFromBundleWithName("bubble_min")

		var normalBubble: UIImage = bubble.cs_imageMaskedWithColor(color)
		var highlightedBubble: UIImage = bubble.cs_imageMaskedWithColor(color.cs_colorByDarkeningColorWithValue(0.12))

		if (flippedForIncoming)
		{
			normalBubble = cs_horizontallyFlippedImageFromImage(image: normalBubble)
			highlightedBubble = cs_horizontallyFlippedImageFromImage(image: highlightedBubble)
		}

		// make image stretchable from center point
		let center = CGPoint(x: CGFloat(bubble.size.width / 2.0), y: CGFloat(bubble.size.height / 2.0))
		//let capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x)
		let capInsets: UIEdgeInsets = UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)

		normalBubble = cs_stretchableImageFromImage(image: normalBubble, withCapInsets: capInsets)
		highlightedBubble = cs_stretchableImageFromImage(image: highlightedBubble, withCapInsets: capInsets)

		let imageView = UIImageView(image: normalBubble, highlightedImage: highlightedBubble)
		imageView.backgroundColor = UIColor.white
		return imageView;
	}

	private class func cs_horizontallyFlippedImageFromImage(image: UIImage) -> UIImage
	{
		return UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: UIImageOrientation.upMirrored)
	}

	private class func cs_stretchableImageFromImage(image: UIImage, withCapInsets capInsets: UIEdgeInsets) -> UIImage
	{
		return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
	}

	//////////////////////////////////////////////////////////////////////////////
}
