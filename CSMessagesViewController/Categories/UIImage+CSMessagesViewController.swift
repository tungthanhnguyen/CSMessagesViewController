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

import UIKit

extension UIImage
{
	/**
	*  Creates and returns a new image object that is masked with the specified mask color.
	*
	*  @param maskColor The color value for the mask. This value must not be `nil`.
	*
	*  @return A new image object masked with the specified color.
	*/
	public func cs_imageMaskedWithColor(_ maskColor: UIColor) -> UIImage
	{
		let imageRect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(self.size.width), height: CGFloat(self.size.height))

		UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
		let context = UIGraphicsGetCurrentContext()!

		context.scaleBy(x: 1.0, y: -1.0)
		context.translateBy(x: 0.0, y: -(imageRect.size.height))

		context.clip(to: imageRect, mask: self.cgImage!)
		context.setFillColor(maskColor.cgColor)
		context.fill(imageRect)

		let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		return newImage;
	}

	public class func cs_bubbleImageFromBundleWithName(_ name: String) -> UIImage
	{
		let bundle: Bundle = Bundle.cs_messagesAssetBundle()
		return UIImage(named: "Images/" + name, in: bundle, compatibleWith: UITraitCollection(displayScale: UIScreen.main.scale))!
	}
}
