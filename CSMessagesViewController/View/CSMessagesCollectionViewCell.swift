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
 *  The `CSMessagesCollectionViewCellDelegate` protocol defines methods that allow you to manage additional interactions within the collection view cell.
 */
protocol CSMessagesCollectionViewCellDelegate: NSObjectProtocol
{
	/**
	 *  Tells the delegate that the avatarImageView of the cell has been tapped.
	 *
	 *  @param cell The cell that received the tap touch event.
	 */
	func messagesCollectionViewCellDidTapAvatar(_ cell: CSMessagesCollectionViewCell)

	/**
	 *  Tells the delegate that the message bubble of the cell has been tapped.
	 *
	 *  @param cell The cell that received the tap touch event.
	 */
	func messagesCollectionViewCellDidTapMessageBubble(_ cell: CSMessagesCollectionViewCell)

	/**
	 *  Tells the delegate that the cell has been tapped at the point specified by position.
	 *
	 *  @param cell      The cell that received the tap touch event.
	 *  @param position  The location of the received touch in the cell's coordinate system.
	 *
	 *  @discussion This method is *only* called if position is *not* within the bounds of the cell's avatar image view or message bubble image view. In other words, this method is *not* called when the cell's avatar or message bubble are tapped.
	 *
	 *  @see `messagesCollectionViewCellDidTapAvatar:`
	 *  @see `messagesCollectionViewCellDidTapMessageBubble:`
	 */
	func messagesCollectionViewCellDidTapCell(_ cell: CSMessagesCollectionViewCell, atPosition position: CGPoint)
}


/**
 *  The `CSMessagesCollectionViewCell` is an abstract class that presents the content for a single message data item when that item is within the collection view’s visible bounds. The layout and presentation of cells is managed by the collection view and its corresponding layout object.
 *
 *  @warning This class is intended to be subclassed. You should not use it directly.
 */
public class CSMessagesCollectionViewCell: UICollectionViewCell
{
	/**
	 *  The object that acts as the delegate for the cell.
	 */
	weak var delegate: CSMessagesCollectionViewCellDelegate!

	/**
	 *  Returns the label that is pinned to the top of the cell.
	 *  This label is most commonly used to display message timestamps.
	 */
	@IBOutlet weak var cellTopLabel: CSMessagesLabel!

	/**
	 *  Returns the label that is pinned just above the messageBubbleImageView, and below the cellTopLabel.
	 *  This label is most commonly used to display the message sender.
	 */
	@IBOutlet weak var messageBubbleTopLabel: CSMessagesLabel!

	/**
	 *  Returns the label that is pinned to the bottom of the cell.
	 *  This label is most commonly used to display message delivery status.
	 */
	@IBOutlet weak var cellBottomLabel: CSMessagesLabel!

	/**
	 *  Returns the text view of the cell. This text view contains the message body text.
	 */
	@IBOutlet public weak var textView: UITextView!

	/**
	 *  The bubble image view of the cell that is responsible for displaying bubble images.
	 *  The default value is `nil`.
	 */
	private weak var priMessageBubbleImageView: UIImageView? = nil
	public weak var messageBubbleImageView: UIImageView?
	{
		get
		{
			if self.priMessageBubbleImageView == nil
			{
				self.priMessageBubbleImageView = UIImageView()
			}

			return self.priMessageBubbleImageView
		}
		set
		{
			if (self.priMessageBubbleImageView != nil) { self.priMessageBubbleImageView?.removeFromSuperview() }

			if (newValue == nil)
			{
				self.priMessageBubbleImageView = nil
				return
			}

			newValue?.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(self.messageBubbleContainerView.bounds.width), height: CGFloat(self.messageBubbleContainerView.bounds.height))

			newValue?.translatesAutoresizingMaskIntoConstraints = false
			self.messageBubbleContainerView.insertSubview(newValue!, belowSubview: self.textView)
			self.messageBubbleContainerView.cs_pinAllEdgesOfSubview(newValue!)
			self.setNeedsUpdateConstraints()

			self.priMessageBubbleImageView = newValue
		}
	}

	/**
	 *  The avatar image view of the cell that is responsible for displaying avatar images.
	 *  The default value is `nil`.
	 */
	private weak var priAvatarImageView: UIImageView? = nil
	public weak var avatarImageView: UIImageView?
	{
		get
		{
			if self.priAvatarImageView == nil
			{
				self.priAvatarImageView = UIImageView()
			}

			return self.priAvatarImageView
		}
		set
		{
			if (self.priAvatarImageView != nil) { self.priAvatarImageView?.removeFromSuperview() }

			if (newValue == nil)
			{
				self.avatarViewSize = CGSize.zero
				self.priAvatarImageView = nil
				self.avatarContainerView.isHidden = true
				return
			}

			self.avatarContainerView.isHidden = false
			self.avatarViewSize = CGSize(width: CGFloat((newValue?.bounds.width)!), height: CGFloat((newValue?.bounds.height)!))

			newValue?.translatesAutoresizingMaskIntoConstraints = false
			self.avatarContainerView.addSubview(newValue!)
			self.avatarContainerView.cs_pinAllEdgesOfSubview(newValue!)
			self.setNeedsUpdateConstraints()

			self.priAvatarImageView = newValue
		}
	}

	/**
	 *  Returns the underlying gesture recognizer for long press gestures in the cell.
	 *  This gesture handles the copy action for the cell.
	 *  Access this property when you need to override or more precisely control the long press gesture.
	 */
	weak var longPressGestureRecognizer: UILongPressGestureRecognizer!

	/**
	 *  Returns the underlying gesture recognizer for tap gestures in the avatarImageView of the cell.
	 *  This gesture handles the tap event for the avatarImageView and notifies the cell's delegate.
	 */
	weak var tapGestureRecognizer: UITapGestureRecognizer!

	@IBOutlet weak var messageBubbleContainerView: UIView!
	@IBOutlet weak var avatarContainerView: UIView!

	@IBOutlet weak var textViewTopVerticalSpaceConstraint: NSLayoutConstraint!
	@IBOutlet weak var textViewBottomVerticalSpaceConstraint: NSLayoutConstraint!
	@IBOutlet weak var textViewAvatarHorizontalSpaceConstraint: NSLayoutConstraint!
	@IBOutlet weak var textViewMarginHorizontalSpaceConstraint: NSLayoutConstraint!

	@IBOutlet weak var cellTopLabelHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var messageBubbleTopLabelHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var cellBottomLabelHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var avatarContainerViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var avatarContainerViewHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var messageBubbleLeftRightMarginConstraint: NSLayoutConstraint!

	var textViewFrameInsets: UIEdgeInsets!
	{
		get
		{
			return UIEdgeInsets(top: self.textViewTopVerticalSpaceConstraint.constant, left: self.textViewMarginHorizontalSpaceConstraint.constant, bottom: self.textViewBottomVerticalSpaceConstraint.constant, right: self.textViewAvatarHorizontalSpaceConstraint.constant)
		}
		set
		{
			if UIEdgeInsetsEqualToEdgeInsets(newValue, self.textViewFrameInsets) { return }

			self.cs_updateConstraint(constraint: self.textViewTopVerticalSpaceConstraint, withConstant: newValue.top)
			self.cs_updateConstraint(constraint: self.textViewBottomVerticalSpaceConstraint, withConstant: newValue.bottom)
			self.cs_updateConstraint(constraint: self.textViewAvatarHorizontalSpaceConstraint, withConstant: newValue.right)
			self.cs_updateConstraint(constraint: self.textViewMarginHorizontalSpaceConstraint, withConstant: newValue.left)
		}
	}

	var avatarViewSize: CGSize
	{
		get
		{
			return CGSize(width: CGFloat(self.avatarContainerViewWidthConstraint.constant), height: CGFloat(self.avatarContainerViewHeightConstraint.constant))
		}
		set
		{
			if newValue.equalTo(self.avatarViewSize) { return }

			self.cs_updateConstraint(constraint: self.avatarContainerViewWidthConstraint, withConstant: newValue.width)
			self.cs_updateConstraint(constraint: self.avatarContainerViewHeightConstraint, withConstant: newValue.height)
		}
	}

	override public var backgroundColor: UIColor!
	{
		get { return super.backgroundColor }
		set
		{
			super.backgroundColor = newValue

			self.cellTopLabel.backgroundColor = newValue
			self.messageBubbleTopLabel.backgroundColor = newValue
			self.cellBottomLabel.backgroundColor = newValue

			self.messageBubbleImageView?.backgroundColor = newValue
			self.avatarImageView?.backgroundColor = newValue

			self.messageBubbleContainerView.backgroundColor = newValue
			self.avatarContainerView.backgroundColor = newValue
		}
	}

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Class methods

	/**
	 *  Returns the `UINib` object initialized for the cell.
	 *
	 *  @return The initialized `UINib` object or `nil` if there were errors during initialization or the nib file could not be located.
	 */
	class func nib() -> UINib
	{
		// This method must be overridden in subclasses.
		let ret: UINib! = nil
		return ret
	}

	/**
	 *  Returns the default string used to identify a reusable cell.
	 *
	 *  @return The string used to identify a reusable cell.
	 */
	class func cellReuseIdentifier() -> String
	{
		// This method must be overridden in subclasses.
		let ret: String! = nil
		return ret
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization

	override public func awakeFromNib()
	{
		super.awakeFromNib()

		// Initialization code

		self.translatesAutoresizingMaskIntoConstraints = false
		self.backgroundColor = UIColor.white

		self.cellTopLabelHeightConstraint.constant = 0.0
		self.messageBubbleTopLabelHeightConstraint.constant = 0.0
		self.cellBottomLabelHeightConstraint.constant = 0.0

		self.avatarViewSize = CGSize.zero

		self.cellTopLabel.textAlignment = NSTextAlignment.center
		self.cellTopLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
		self.cellTopLabel.textColor = UIColor.lightGray

		self.messageBubbleTopLabel.font = UIFont.systemFont(ofSize: 12.0)
		self.messageBubbleTopLabel.textColor = UIColor.lightGray

		self.cellBottomLabel.font = UIFont.systemFont(ofSize: 11.0)
		self.cellBottomLabel.textColor = UIColor.lightGray

		self.textView.textColor = UIColor.white
		self.textView.isEditable = false
		self.textView.isSelectable = true
		self.textView.isUserInteractionEnabled = true
		self.textView.dataDetectorTypes = UIDataDetectorTypes(rawValue: 0) // .none
		self.textView.showsHorizontalScrollIndicator = false
		self.textView.showsVerticalScrollIndicator = false
		self.textView.isScrollEnabled = false
		self.textView.backgroundColor = UIColor.clear
		self.textView.contentInset = UIEdgeInsets.zero
		self.textView.scrollIndicatorInsets = UIEdgeInsets.zero
		self.textView.contentOffset = CGPoint.zero
		self.textView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSUnderlineStyleAttributeName: (NSUnderlineStyle.styleSingle.rawValue ^ NSUnderlineStyle.patternSolid.rawValue)]

		let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.cs_handleLongPressGesture(_:)))
		longPress.minimumPressDuration = 0.4
		self.addGestureRecognizer(longPress)
		self.longPressGestureRecognizer = longPress

		let tap = UITapGestureRecognizer(target: self, action: #selector(self.cs_handleTapGesture(_:)))
		self.addGestureRecognizer(tap)
		self.tapGestureRecognizer = tap
	}

	deinit
	{
		self.delegate = nil

		self.cellTopLabel = nil
		self.messageBubbleTopLabel = nil
		self.cellBottomLabel = nil
		self.textView = nil
		self.priMessageBubbleImageView = nil
		self.priAvatarImageView = nil

		if self.longPressGestureRecognizer != nil
		{
			self.longPressGestureRecognizer.removeTarget(nil, action: nil)
			self.longPressGestureRecognizer = nil;
		}

		if self.tapGestureRecognizer != nil
		{
			self.tapGestureRecognizer.removeTarget(nil, action: nil)
			self.tapGestureRecognizer = nil;
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Collection view cell

	override public func prepareForReuse()
	{
		super.prepareForReuse()

		self.cellTopLabel.text = nil
		self.messageBubbleTopLabel.text = nil
		self.cellBottomLabel.text = nil
	}

	override public func apply(_ layoutAttributes: UICollectionViewLayoutAttributes)
	{
		super.apply(layoutAttributes)

		let customAttributes = layoutAttributes as! CSMessagesCollectionViewLayoutAttributes

		if (self.textView.font != customAttributes.messageBubbleFont)
		{
			self.textView.font = customAttributes.messageBubbleFont
		}

		if !UIEdgeInsetsEqualToEdgeInsets(self.textView.textContainerInset, customAttributes.textViewTextContainerInsets)
		{
			self.textView.textContainerInset = customAttributes.textViewTextContainerInsets
		}

		self.textViewFrameInsets = customAttributes.textViewFrameInsets

		self.cs_updateConstraint(constraint: self.messageBubbleLeftRightMarginConstraint, withConstant: customAttributes.messageBubbleLeftRightMargin)
		self.cs_updateConstraint(constraint: self.cellTopLabelHeightConstraint, withConstant: customAttributes.cellTopLabelHeight)
		self.cs_updateConstraint(constraint: self.messageBubbleTopLabelHeightConstraint, withConstant: customAttributes.messageBubbleTopLabelHeight)
		self.cs_updateConstraint(constraint: self.cellBottomLabelHeightConstraint, withConstant: customAttributes.cellBottomLabelHeight)

		if (self is CSMessagesCollectionViewCellIncoming)
		{
			self.avatarViewSize = customAttributes.incomingAvatarViewSize!
		}
		else if (self is CSMessagesCollectionViewCellOutgoing)
		{
			self.avatarViewSize = customAttributes.outgoingAvatarViewSize!
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Utilities

	private func cs_updateConstraint(constraint: NSLayoutConstraint, withConstant constant: CGFloat)
	{
		if (constraint.constant == constant) { return  }

		constraint.constant = constant
		self.setNeedsUpdateConstraints()
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - UIResponder

	override public var canBecomeFirstResponder: Bool
	{
		return true
	}

	override public func becomeFirstResponder() -> Bool
	{
		return super.becomeFirstResponder()
	}

	override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
	{
		return (action == #selector(copy(_:)))
	}

	override public func copy(_ sender: Any?)
	{
		UIPasteboard.general.string = self.textView.text
		self.resignFirstResponder()
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Gesture recognizers

	func cs_handleLongPressGesture(_ longPress: UILongPressGestureRecognizer)
	{
		if (longPress.state != UIGestureRecognizerState.began || !self.becomeFirstResponder())
		{
			return
		}

		let menu: UIMenuController = UIMenuController.shared
		let targetRect: CGRect = self.convert(self.messageBubbleImageView!.bounds, from: self.messageBubbleImageView)

		menu.setTargetRect(targetRect.insetBy(dx: CGFloat(0.0), dy: CGFloat(4.0)), in: self)

		self.messageBubbleImageView?.isHighlighted = true

		NotificationCenter.default.addObserver(self, selector: #selector(self.cs_didReceiveMenuWillShowNotification(_:)), name: NSNotification.Name.UIMenuControllerWillShowMenu, object: menu)

		menu.setMenuVisible(true, animated: true)
	}

	func cs_handleTapGesture(_ tap: UITapGestureRecognizer)
	{
		let touchPt: CGPoint = tap.location(in: self)

		if self.avatarContainerView.frame.contains(touchPt)
		{
			self.delegate.messagesCollectionViewCellDidTapAvatar(self)
		}
		else if self.messageBubbleContainerView.frame.contains(touchPt)
		{
			self.delegate.messagesCollectionViewCellDidTapMessageBubble(self)
		}
		else
		{
			self.delegate.messagesCollectionViewCellDidTapCell(self, atPosition: touchPt)
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Notifications

	func cs_didReceiveMenuWillHideNotification(_ notification: Notification)
	{
		self.messageBubbleImageView?.isHighlighted = false

		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIMenuControllerWillHideMenu, object: nil)
	}

	func cs_didReceiveMenuWillShowNotification(_ notification: Notification)
	{
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIMenuControllerWillShowMenu, object: nil)

		NotificationCenter.default.addObserver(self, selector: #selector(self.cs_didReceiveMenuWillHideNotification(_:)), name: NSNotification.Name.UIMenuControllerWillHideMenu, object: notification.object!)
	}

	//////////////////////////////////////////////////////////////////////////////
}
