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

/**
 *  `CSMessagesToolbarButtonFactory` is a factory that provides a means for creating the default toolbar button items to be displayed in the content view of a `CSMessagesInputToolbar`.
 */
public class CSMessagesToolbarButtonFactory: NSObject
{
	/**
	 *  Creates and returns a new button that is styled as the default accessory button.
	 *  The button has a camera icon image and no text.
	 *
	 *  @return A newly created button.
	 */
	public class func defaultAccessoryButtonItem() -> UIButton
	{
		let cameraImage = UIImage.cs_bubbleImageFromBundleWithName("camera")
		let cameraNormal = cameraImage.cs_imageMaskedWithColor(UIColor.lightGray)
		let cameraHighlighted = cameraImage.cs_imageMaskedWithColor(UIColor.darkGray)

		let cameraButton = UIButton(frame: CGRect.zero)
		cameraButton.setImage(cameraNormal, for: UIControlState.normal)
		cameraButton.setImage(cameraHighlighted, for: UIControlState.highlighted)

		cameraButton.contentMode = UIViewContentMode.scaleAspectFit
		cameraButton.backgroundColor = UIColor.clear
		cameraButton.tintColor = UIColor.lightGray

		return cameraButton
	}

	/**
	 *  Creates and returns a new button that is styled as the default send button.
	 *  The button has title text `@"Send"` and no image.
	 *
	 *  @return A newly created button.
	 */
	public class func defaultSendButtonItem() -> UIButton
	{
		let sendTitle = NSLocalizedString("Send", comment: "Text for the send button on the messages view toolbar")

		let sendButton = UIButton(frame: CGRect.zero)
		sendButton.setTitle(sendTitle, for: UIControlState.normal)
		sendButton.setTitleColor(UIColor.cs_messageBubbleBlueColor(), for: UIControlState.normal)
		sendButton.setTitleColor(UIColor.cs_messageBubbleBlueColor().cs_colorByDarkeningColorWithValue(0.1), for: UIControlState.highlighted)
		sendButton.setTitleColor(UIColor.lightGray, for: UIControlState.disabled)

		sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
		sendButton.contentMode = UIViewContentMode.center
		sendButton.backgroundColor = UIColor.clear
		sendButton.tintColor = UIColor.cs_messageBubbleBlueColor()

		return sendButton
	}
}
