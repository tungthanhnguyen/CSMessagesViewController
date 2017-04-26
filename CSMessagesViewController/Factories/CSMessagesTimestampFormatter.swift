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
 *  An instance of `CSMessagesTimestampFormatter` is a singleton object that provides an efficient means for creating attributed and non-attributed string representations of `NSDate` objects.
 *  It is intended to be used as the method by which you display timestamps in a `CSMessagesCollectionView`.
 */
public class CSMessagesTimestampFormatter: NSObject
{
	public static let sharedFormatter = CSMessagesTimestampFormatter()

	/**
	 *  Returns the cached date formatter object used by the `CSMessagesTimestampFormatter` shared instance.
	 */
	public var dateFormatter: DateFormatter!

	/**
	 *  The text attributes to apply to the day, month, and year components of the string representation of a given date.
	 *  The default value is a dictionary containing attributes that specify centered, light gray text and the bold system font at size `12.0`.
	 */
	public var dateTextAttributes: Dictionary<String, Any>!

	/**
	 *  The text attributes to apply to the minute and hour componenents of the string representation of a given date.
	 *  The default value is a dictionary containing attributes that specify centered, light gray text and the system font at size `12.0`.
	 */
	public var timeTextAttributes: Dictionary<String, Any>!

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization

	override public init()
	{
		super.init()

		dateFormatter = DateFormatter()
		dateFormatter.locale = Locale.current
		dateFormatter.doesRelativeDateFormatting = true

		let color = UIColor.lightGray

		let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
		paragraphStyle.alignment = NSTextAlignment.center

		dateTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(12.0)), NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle]

		timeTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(12.0)), NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle]
	}

	deinit
	{
		dateFormatter = nil

		dateTextAttributes.removeAll()
		timeTextAttributes.removeAll()
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Formatter

	/**
	 *  Returns a string representation of the given date formatted in the current locale using `NSDateFormatterMediumStyle` for the date style and `NSDateFormatterShortStyle` for the time style. It uses relative date formatting where possible.
	 *
	 *  @param date  The date to format.
	 *
	 *  @return A formatted string representation of date.
	 */
	public func timestampForDate(date: Date) -> String
	{
		dateFormatter.dateStyle = DateFormatter.Style.medium
		dateFormatter.timeStyle = DateFormatter.Style.short

		return dateFormatter.string(from: date)
	}

	/**
	 *  Returns an attributed string representation of the given date formatted as described in `timestampForDate:`.
	 *  It applies the attributes in `dateTextAttributes` and `timeTextAttributes`, respectively.
	 *
	 *  @param date  The date to format.
	 *
	 *  @return A formatted, attributed string representation of date.
	 *
	 *  @see `timestampForDate:`.
	 *  @see `dateTextAttributes`.
	 *  @see `timeTextAttributes`.
	 */
	public func attributedTimestampForDate(date: Date) -> NSAttributedString
	{
		let relativeDate = relativeDateForDate(date: date)
		let time = timeForDate(date: date)

		let timestamp = NSMutableAttributedString(string: relativeDate, attributes: dateTextAttributes)
		timestamp.append(NSAttributedString(string: " "))
		timestamp.append(NSAttributedString(string: time, attributes: timeTextAttributes))

		return NSAttributedString.init(attributedString: timestamp)
	}

	/**
	 *  Returns a string representation of *only* the minute and hour components of the given date formatted in the current locale styled using `NSDateFormatterShortStyle`.
	 *
	 *  @param date  The date to format.
	 *
	 *  @return A formatted string representation of the minute and hour components of date.
	 */
	public func timeForDate(date: Date) -> String
	{
		dateFormatter.dateStyle = DateFormatter.Style.none
		dateFormatter.timeStyle = DateFormatter.Style.short

		return dateFormatter.string(from: date)
	}

	/**
	 *  Returns a string representation of *only* the day, month, and year components of the given date formatted in the current locale styled using `NSDateFormatterMediumStyle`.
	 *
	 *  @param date The date to format.
	 *
	 *  @return A formatted string representation of the day, month, and year components of date.
	 */
	public func relativeDateForDate(date: Date) -> String
	{
		dateFormatter.dateStyle = DateFormatter.Style.medium
		dateFormatter.timeStyle = DateFormatter.Style.none

		return dateFormatter.string(from: date)
	}

	//////////////////////////////////////////////////////////////////////////////
}
