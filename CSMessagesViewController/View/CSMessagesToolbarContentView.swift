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
 *  A constant value representing the default spacing to use for the left and right edges of the toolbar content view.
 */
public let kCSMessagesToolbarContentViewHorizontalSpacingDefault: CGFloat = 4.0

/**
 *  A `CSMessagesToolbarContentView` represents the content displayed in a `CSMessagesInputToolbar`.
 *  These subviews consist of a left button, a text view, and a right button. One button is used as the send button, and the other as the accessory button. The text view is used for composing messages.
 */
public class CSMessagesToolbarContentView: UIView
{
	@IBOutlet weak var leftBarButtonContainerView: UIView!
	@IBOutlet weak var leftBarButtonContainerViewWidthConstraint: NSLayoutConstraint!

	/**
	 *  A custom button item displayed on the left of the toolbar content view.
	 *
	 *  @discussion The frame of this button is ignored. When you set this property, the button is fitted within a pre-defined default content view, whose height is determined by the height of the toolbar. You may specify a new width using `leftBarButtonItemWidth`.
	 *  Set this value to `nil` to remove the button.
	 */
	private weak var priLeftBarButtonItem: UIButton! = nil
	public weak var leftBarButtonItem: UIButton!
	{
		get { return self.priLeftBarButtonItem }
		set
		{
			if self.priLeftBarButtonItem != nil
			{
				self.priLeftBarButtonItem.removeFromSuperview()
			}

			if newValue == nil
			{
				if self.leftHorizontalSpacingConstraint != nil
				{
					self.leftHorizontalSpacingConstraint.constant = 0.0
				}

				self.leftBarButtonItemWidth = 0.0
				self.priLeftBarButtonItem = nil

				if self.leftBarButtonContainerView != nil
				{
					self.leftBarButtonContainerView.isHidden = true
				}

				return
			}

			if (newValue.frame.equalTo(CGRect.zero))
			{
				newValue.frame = CGRect(x: 0.0, y: 0.0,
				                        width: (self.leftBarButtonContainerView != nil) ? self.leftBarButtonContainerView.frame.width : 0.0,
				                        height: (self.leftBarButtonContainerView != nil) ? self.leftBarButtonContainerView.frame.height : 0.0)
			}

			if self.leftBarButtonContainerView != nil
			{
				self.leftBarButtonContainerView.isHidden = false
				self.leftBarButtonContainerView.addSubview(newValue)
				self.leftBarButtonContainerView.cs_pinAllEdgesOfSubview(newValue)
			}

			if self.leftHorizontalSpacingConstraint != nil
			{
				self.leftHorizontalSpacingConstraint.constant = kCSMessagesToolbarContentViewHorizontalSpacingDefault
			}

			self.leftBarButtonItemWidth = newValue.frame.width

			self.setNeedsUpdateConstraints()

			self.priLeftBarButtonItem = newValue
		}
	}

	/**
	 *  Specifies the width of the leftBarButtonItem.
	 */
	var leftBarButtonItemWidth: CGFloat
	{
		get
		{
			return (self.leftBarButtonContainerViewWidthConstraint != nil) ? self.leftBarButtonContainerViewWidthConstraint.constant : 0.0
		}
		set
		{
			if self.leftBarButtonContainerViewWidthConstraint != nil
			{
				self.leftBarButtonContainerViewWidthConstraint.constant = newValue
			}

			self.setNeedsUpdateConstraints()
		}
	}

	/**
	 *  Returns the text view in which the user composes a message.
	 */
	@IBOutlet public weak var textView: CSMessagesComposerTextView!

	/**
	 *  A custom button item displayed on the right of the toolbar content view.
	 *
	 *  @discussion The frame of this button is ignored. When you set this property, the button is fitted within a pre-defined default content view, whose height is determined by the height of the toolbar. You may specify a new width using `rightBarButtonItemWidth`.
	 *  Set this value to `nil` to remove the button.
	 */
	private weak var priRightBarButtonItem: UIButton! = nil
	public weak var rightBarButtonItem: UIButton!
	{
		get { return self.priRightBarButtonItem }
		set
		{
			if (self.priRightBarButtonItem != nil)
			{
				self.priRightBarButtonItem.removeFromSuperview()
			}

			if (newValue == nil)
			{
				if self.rightHorizontalSpacingConstraint != nil
				{
					self.rightHorizontalSpacingConstraint.constant = 0.0
				}

				self.rightBarButtonItemWidth = 0.0
				self.priRightBarButtonItem = nil

				if self.rightBarButtonContainerView != nil
				{
					self.rightBarButtonContainerView.isHidden = true
				}

				return
			}

			if (newValue.frame.equalTo(CGRect.zero))
			{
				newValue.frame = CGRect(x: 0.0, y: 0.0,
				                        width: (self.rightBarButtonContainerView != nil) ? self.rightBarButtonContainerView.frame.width : 0.0,
				                        height: (self.rightBarButtonContainerView != nil) ? self.rightBarButtonContainerView.frame.height : 0.0)
			}

			if self.rightBarButtonContainerView != nil
			{
				self.rightBarButtonContainerView.isHidden = false
				self.rightBarButtonContainerView.addSubview(newValue)
				self.rightBarButtonContainerView.cs_pinAllEdgesOfSubview(newValue)
			}

			if self.rightHorizontalSpacingConstraint != nil
			{
				self.rightHorizontalSpacingConstraint.constant = kCSMessagesToolbarContentViewHorizontalSpacingDefault
			}

			self.rightBarButtonItemWidth = newValue.frame.width

			self.setNeedsUpdateConstraints()

			self.priRightBarButtonItem = newValue
		}
	}

	/**
	 *  Specifies the width of the rightBarButtonItem.
	 */
	var rightBarButtonItemWidth: CGFloat
	{
		get
		{
			return (self.rightBarButtonContainerViewWidthConstraint != nil) ? self.rightBarButtonContainerViewWidthConstraint.constant : 0.0
		}
		set
		{
			if self.rightBarButtonContainerViewWidthConstraint != nil
			{
				self.rightBarButtonContainerViewWidthConstraint.constant = newValue
			}

			self.setNeedsUpdateConstraints()
		}
	}

	@IBOutlet weak var rightBarButtonContainerView: UIView!
	@IBOutlet weak var rightBarButtonContainerViewWidthConstraint: NSLayoutConstraint!

	@IBOutlet weak var leftHorizontalSpacingConstraint: NSLayoutConstraint!
	@IBOutlet weak var rightHorizontalSpacingConstraint: NSLayoutConstraint!

	override public var backgroundColor: UIColor!
	{
		get { return super.backgroundColor }
		set
		{
			super.backgroundColor = newValue
			
			if (self.leftBarButtonContainerView != nil)
			{
				self.leftBarButtonContainerView.backgroundColor = newValue
			}

			if (self.rightBarButtonContainerView != nil)
			{
				self.rightBarButtonContainerView.backgroundColor = newValue
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Class methods

	/**
	 *  Returns the `UINib` object initialized for a `CSMessagesToolbarContentView`.
	 *
	 *  @return The initialized `UINib` object or `nil` if there were errors during initialization or the nib file could not be located.
	 */
	public class func nib() -> UINib
	{
		return UINib(nibName: String(describing: CSMessagesToolbarContentView.self), bundle: Bundle.cs_messagesBundle())
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization

	override public func awakeFromNib()
	{
		super.awakeFromNib()

		// Initialization code

		self.translatesAutoresizingMaskIntoConstraints = false

		if self.leftBarButtonContainerView != nil
		{
			self.leftBarButtonContainerView.translatesAutoresizingMaskIntoConstraints = false
		}

		if self.rightBarButtonContainerView != nil
		{
			self.rightBarButtonContainerView.translatesAutoresizingMaskIntoConstraints = false
		}

		if self.leftHorizontalSpacingConstraint != nil
		{
			self.leftHorizontalSpacingConstraint.constant = kCSMessagesToolbarContentViewHorizontalSpacingDefault
		}

		if self.rightHorizontalSpacingConstraint != nil
		{
			self.rightHorizontalSpacingConstraint.constant = kCSMessagesToolbarContentViewHorizontalSpacingDefault
		}

		self.leftBarButtonItem = nil
		self.rightBarButtonItem = nil

		self.backgroundColor = UIColor.clear
	}

	deinit
	{
		self.textView = nil
		self.leftBarButtonItem = nil
		self.rightBarButtonItem = nil
		self.leftBarButtonContainerView = nil
		self.rightBarButtonContainerView = nil
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - UIView overrides

	override public func setNeedsDisplay()
	{
		super.setNeedsDisplay()

		if self.textView != nil
		{
			self.textView.setNeedsDisplay()
		}
	}

	//////////////////////////////////////////////////////////////////////////////
}
