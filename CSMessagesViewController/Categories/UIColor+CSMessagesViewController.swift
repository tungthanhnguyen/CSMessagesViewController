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

extension UIColor
{
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Message bubble colors

	/**
	 *  @return A color object containing HSB values similar to the iOS 7 messages app green bubble color.
	 */
	public class func cs_messageBubbleGreenColor() -> UIColor
	{
		return UIColor(hue: CGFloat(130.0 / 360.0), saturation: CGFloat(0.68),
		               brightness: CGFloat(0.80), alpha: CGFloat(1.0))
	}

	/**
	 *  @return A color object containing HSB values similar to the iOS 7 messages app blue bubble color.
	 */
	public class func cs_messageBubbleBlueColor() -> UIColor
	{
		return UIColor(hue: CGFloat(210.0 / 360.0), saturation: CGFloat(0.94), brightness: CGFloat(1.0), alpha: CGFloat(1.0))
	}

	/**
	 *  @return A color object containing HSB values similar to the iOS 7 messages app light gray bubble color.
	 */
	public class func cs_messageBubbleLightGrayColor() -> UIColor
	{
		return UIColor(hue: CGFloat(240.0 / 360.0), saturation: CGFloat(0.02), brightness: CGFloat(0.92), alpha: CGFloat(1.0))
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Utilities

	/**
	 *  Creates and returns a new color object whose brightness component is decreased by the given value, using the initial color values of the receiver.
	 *
	 *  @param value A floating point value describing the amount by which to decrease the brightness of the receiver.
	 *
	 *  @return A new color object whose brightness is decreased by the given values. The other color values remain the same as the receiver.
	 */
	public func cs_colorByDarkeningColorWithValue(_ value: CGFloat) -> UIColor
	{
		let totalComponents = self.cgColor.numberOfComponents
		let isGreyscale = (totalComponents == 2) ? true : false

		let oldComponents: [CGFloat] = self.cgColor.components!
		var newComponents = [CGFloat](repeating: 0.0, count: 4)

		if isGreyscale
		{
			newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
			newComponents[1] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
			newComponents[2] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
			newComponents[3] = oldComponents[1]
		}
		else
		{
			newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
			newComponents[1] = oldComponents[1] - value < 0.0 ? 0.0 : oldComponents[1] - value
			newComponents[2] = oldComponents[2] - value < 0.0 ? 0.0 : oldComponents[2] - value
			newComponents[3] = oldComponents[3]
		}

		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let newColor = CGColor(colorSpace: colorSpace, components: newComponents)!

		let retColor = UIColor(cgColor: newColor)

		return retColor
	}

	//////////////////////////////////////////////////////////////////////////////
}
