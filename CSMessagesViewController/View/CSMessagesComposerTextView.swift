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

/**
 *  An instance of `CSMessagesComposerTextView` is a subclass of `UITextView` that is styled and used for composing messages in a `CSMessagesViewController`. It is a subview of a `CSMessagesToolbarContentView`.
 */
public class CSMessagesComposerTextView: UITextView
{
	/**
	 *  The text to be displayed when the text view is empty. The default value is `nil`.
	 */
	private var priPlaceHolder: NSString! = nil
	public var placeHolder: NSString!
	{
		get { return self.priPlaceHolder }
		set
		{
			if newValue != nil
			{
				if (self.priPlaceHolder != nil && newValue == self.priPlaceHolder) { return }

				self.priPlaceHolder = newValue.copy() as! NSString
				self.setNeedsDisplay()
			}
		}
	}

	/**
	 *  The color of the place holder text. The default value is `UIColor.lightGray`.
	 */
	private var priPlaceHolderTextColor: UIColor! = nil
	public var placeHolderTextColor: UIColor!
	{
		get
		{
			if self.priPlaceHolderTextColor == nil
			{
				self.priPlaceHolderTextColor = UIColor()
			}

			return self.priPlaceHolderTextColor
		}
		set
		{
			if (newValue != nil && self.priPlaceHolderTextColor != nil && newValue.isEqual(self.priPlaceHolderTextColor))
			{
				return
			}

			self.priPlaceHolderTextColor = newValue
			self.setNeedsDisplay()
		}
	}

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization

	func cs_configureTextView()
	{
		self.translatesAutoresizingMaskIntoConstraints = false

		let cornerRadius: CGFloat = 6.0

		self.backgroundColor = UIColor.white
		self.layer.borderWidth = 0.5
		self.layer.borderColor = UIColor.lightGray.cgColor
		self.layer.cornerRadius = cornerRadius

		self.scrollIndicatorInsets = UIEdgeInsets(top: cornerRadius, left: 0.0, bottom: cornerRadius, right: 0.0)

		self.textContainerInset = UIEdgeInsets(top: 4.0, left: 2.0, bottom: 4.0, right: 2.0)
		self.contentInset = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 0.0)

		self.isScrollEnabled = true
		self.scrollsToTop = false
		self.isUserInteractionEnabled = true

		self.font = UIFont.systemFont(ofSize: 16.0)
		self.textColor = UIColor.black
		self.textAlignment = NSTextAlignment.left

		self.contentMode = UIViewContentMode.redraw
		self.dataDetectorTypes = UIDataDetectorTypes(rawValue: 0) // .none
		self.keyboardAppearance = UIKeyboardAppearance.default
		self.keyboardType = UIKeyboardType.default
		self.returnKeyType = UIReturnKeyType.default

		self.text = nil

		self.placeHolder = nil
		self.placeHolderTextColor = UIColor.lightGray

		self.cs_addTextViewNotificationObservers()
	}

	required public init(coder: NSCoder)
	{
		super.init(coder: coder)!
	}

	override public init(frame: CGRect, textContainer: NSTextContainer!)
	{
		super.init(frame: frame, textContainer: textContainer)

		self.cs_configureTextView()
	}

	override public func awakeFromNib()
	{
		super.awakeFromNib()

		// Initialization code

		self.cs_configureTextView()
	}

	deinit
	{
		self.cs_removeTextViewNotificationObservers()

		self.placeHolder = nil
		self.priPlaceHolderTextColor = nil
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Composer text view

	/**
	 *  Determines whether or not the text view contains text after trimming white space from the front and back of its string.
	 *
	 *  @return `true` if the text view contains text, `false` otherwise.
	 */
	override open var hasText: Bool
	{
		return !(self.text!.cs_stringByTrimingWhitespace().isEmpty)
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - UITextView overrides

	override public var text: String!
	{
		get { return super.text }
		set
		{
			if (newValue != nil && super.text != nil && super.text == newValue)
			{
				return
			}

			super.text = newValue
			self.setNeedsDisplay()
		}
	}

	override public var attributedText: NSAttributedString!
	{
		get { return super.attributedText }
		set
		{
			if (newValue != nil && super.attributedText != nil && super.attributedText == newValue)
			{
				return
			}

			super.attributedText = newValue
			self.setNeedsDisplay()
		}
	}

	override public var font: UIFont!
	{
		get { return super.font }
		set
		{
			if (newValue != nil && super.font != nil && super.font == newValue)
			{
				return
			}

			super.font = newValue
			self.setNeedsDisplay()
		}
	}

	override public var textAlignment: NSTextAlignment
	{
		get { return super.textAlignment }
		set
		{
			if (super.textAlignment == newValue) { return }

			super.textAlignment = newValue
			self.setNeedsDisplay()
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Drawing

	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override public func draw(_ rect: CGRect)
	{
		super.draw(rect)

		if (self.text.isEmpty && self.placeHolder.length > 0)
		{
			self.placeHolderTextColor.set()

			self.placeHolder.draw(in: rect.insetBy(dx: 7.0, dy: 5.0), withAttributes: self.cs_placeholderTextAttributes())
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Notifications

	private func cs_addTextViewNotificationObservers()
	{
		NotificationCenter.default.addObserver(self, selector: #selector(self.cs_didReceiveTextViewNotification(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: self)

		NotificationCenter.default.addObserver(self, selector: #selector(self.cs_didReceiveTextViewNotification(_:)), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)

		NotificationCenter.default.addObserver(self, selector: #selector(self.cs_didReceiveTextViewNotification(_:)), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
	}

	private func cs_removeTextViewNotificationObservers()
	{
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: self)

		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)

		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
	}

	func cs_didReceiveTextViewNotification(_ notification: Notification)
	{
		self.setNeedsDisplay()
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Utilities

	private func cs_placeholderTextAttributes() -> Dictionary<String, Any>
	{
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
		paragraphStyle.alignment = self.textAlignment

		return [NSFontAttributeName: self.font, NSForegroundColorAttributeName: self.placeHolderTextColor, NSParagraphStyleAttributeName: paragraphStyle]
	}

	//////////////////////////////////////////////////////////////////////////////
}
