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
 *  `CSMessagesAvatarFactory` is a factory that provides a means for creating and styling avatar images to be displayed in a `CSMessagesCollectionViewCell` of a `CSMessagesCollectionView`.
 */
public class CSMessagesAvatarFactory: NSObject
{
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Public
	
	/**
	 *  Returns a copy of the image object associated with the specified originalImage that is cropped to a circle with the given diameter.
	 *
	 *  @param originalImage  The origin image object from which an avatar is created. This value must not be `nil`.
	 *  @param diameter       An integer value specifying the diameter size of the avatar in points. This value must be greater than `0.0`.
	 *
	 *  @return A new avatar image object for the specified originalImage that is cropped to a circle with the given diameter, or `nil` if originalImage is not a valid, initialized image object.
	 */
	public class func avatarWithImage(_ originalImage: UIImage, diameter: Int) -> UIImage
	{
		assert(diameter > 0)
		return CSMessagesAvatarFactory.cs_circularImage(image: originalImage, withDiamter: diameter)
	}
	
	/**
 	 *  Returns an image object with a circular shape that displays the specified userInitials with the given backgroundColor, textColor, font, and diameter.
	 *
	 *  @param userInitials     The user initials to display in the avatar image. This value must not be `nil`.
	 *  @param backgroundColor  The background color of the avatar. This value must not be `nil`.
	 *  @param textColor        The color of the text of the userInitials. This value must not be `nil`.
	 *  @param font             The font applied to userInitials. This value must not be `nil`.
	 *  @param diameter         The diameter of the avatar image. This value must be greater than `0.0`.
	 *
	 *  @return A new avatar image object having the specified attributes if created successfully, otherwise `nil`.
	 *
	 *  @discussion This method does not attempt to detect or correct incompatible parameters.
	 *  That is to say, you are responsible for providing a font size and diameter that sense.
	 *  For example a font size of `14.0` and a diameter of `34.0` will result in an avatar similar to Messages in iOS 7.
	 *  However, a font size `30.0` and diameter of `10.0f` will not produce a desirable image.
	 *  Further, this method does not check the length of userInitials. It is recommended that you pass a string of length `2` or `3`.
	 */
	public class func avatarWithUserInitials(_ userInitials: String, backgroundColor: UIColor, textColor: UIColor, font: UIFont, diameter: Int) -> UIImage
	{
		assert(diameter > 0)

		let frame: CGRect = CGRect(x: 0, y: 0, width: diameter, height: diameter)

		let text: String = userInitials.uppercased(with: Locale.current)

		let attributes: Dictionary = [NSFontAttributeName: font, NSForegroundColorAttributeName: textColor]

		let textFrame: CGRect = text.boundingRect(with: frame.size, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: attributes, context: nil)

		let frameMidPoint: CGPoint = CGPoint(x: frame.midX, y: frame.midY)
		let textFrameMidPoint: CGPoint = CGPoint(x: textFrame.midX, y: textFrame.midY)

		let dx: CGFloat = frameMidPoint.x - textFrameMidPoint.x
		let dy: CGFloat = frameMidPoint.y - textFrameMidPoint.y
		let drawPoint: CGPoint = CGPoint(x: dx, y: dy)

		UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
		let context: CGContext! = UIGraphicsGetCurrentContext()
		context.saveGState()
		
		context.setFillColor(backgroundColor.cgColor)
		context.fill(frame)
		text.draw(at: drawPoint, withAttributes: attributes)

		let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()

		context.restoreGState()
		UIGraphicsEndImageContext();

		return cs_circularImage(image: image, withDiamter: diameter)
	}
	
	//////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Private
	
	private class func cs_circularImage(image: UIImage, withDiamter diameter: Int) -> UIImage
	{
		let frame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
		
		UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
		let context = UIGraphicsGetCurrentContext()!
		context.saveGState()
		
		let imgPath = UIBezierPath(ovalIn: frame)
		imgPath.addClip()
		image.draw(in: frame)
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()!
		
		context.restoreGState()
		UIGraphicsEndImageContext()
		return newImage
	}
	
	//////////////////////////////////////////////////////////////////////////////
}
