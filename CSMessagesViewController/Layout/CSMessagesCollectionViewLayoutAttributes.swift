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
 *  A `CSMessagesCollectionViewLayoutAttributes` is an object that manages the layout-related attributes for a given `CSMessagesCollectionViewCell` in a `CSMessagesCollectionView`.
 */
public class CSMessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes
{
	/**
	 *  The font used to display the body of a text message in a message bubble within a `CSMessagesCollectionViewCell`.
	 *  This value must not be `nil`.
	 */
	private var priMessageBubbleFont: UIFont? = nil
	public var messageBubbleFont: UIFont?
	{
		get
		{
			if self.priMessageBubbleFont == nil
			{
				self.priMessageBubbleFont = UIFont()
			}

			return self.priMessageBubbleFont
		}
		set
		{
			if (newValue != nil)
			{
				if (newValue?.isEqual(self.priMessageBubbleFont))! { return }

				self.priMessageBubbleFont = newValue
			}
		}
	}

	/**
	 *  The horizontal spacing between the message bubble and the edge of the collection view cell in which it is displayed. This value should be greater than or equal to `0.0`.
	 *
	 *  @discussion For *outgoing* messages, this value specifies the amount of spacing from the left most edge of the collection view cell to the left most edge of a message bubble with in the cell.
	 *
	 *  For *incoming* messages, this value specifies the amount of spacing from the right most edge of the collection view cell to the right most edge of a message bubble with in the cell.
	 */
	private var priMessageBubbleLeftRightMargin: CGFloat! = 0.0
	public var messageBubbleLeftRightMargin: CGFloat!
	{
		get { return self.priMessageBubbleLeftRightMargin }
		set
		{
			if (newValue < 0.0) { return }

			self.priMessageBubbleLeftRightMargin = CGFloat(ceilf(Float(newValue)))
		}
	}

	/**
	 *  The inset of the text container's layout area within the text view's content area in a `CSMessagesCollectionViewCell`.
	 *  The specified inset values should be greater than or equal to `0.0`.
	 */
	public var textViewTextContainerInsets = UIEdgeInsets()

	/**
	 *  The inset of the frame of the text view within a `CSMessagesCollectionViewCell`.
	 *
	 *  @discussion The inset values should be greater than or equal to `0.0` and are applied in the following ways:
	 *
	 *  1. The right value insets the text view frame on the side adjacent to the avatar image (or where the avatar would normally appear). For outgoing messages this is the right side, for incoming messages this is the left side.
	 *
	 *  2. The left value insets the text view frame on the side opposite the avatar image (or where the avatar would normally appear). For outgoing messages this is the left side, for incoming messages this is the right side.
	 *
	 *  3. The top value insets the top of the frame.
	 *
	 *  4. The bottom value insets the bottom of the frame.
	 */
	public var textViewFrameInsets = UIEdgeInsets()

	/**
	 *  The size of the `avatarImageView` of a `CSMessagesCollectionViewCellIncoming`.
	 *  The size values should be greater than or equal to `0.0`.
	 *
	 *  @see `CSMessagesCollectionViewCellIncoming`.
	 */
	private var priIncomingAvatarViewSize: CGSize? = nil
	public var incomingAvatarViewSize: CGSize?
	{
		get
		{
			if self.priIncomingAvatarViewSize == nil
			{
				self.priIncomingAvatarViewSize = CGSize()
			}
			return self.priIncomingAvatarViewSize
		}
		set
		{
			if ((newValue?.width)! < 0.0 || (newValue?.height)! < 0.0) { return }

			self.priIncomingAvatarViewSize = CGSize(width: CGFloat(ceilf(Float((newValue?.width)!))),
			                                        height: CGFloat(ceilf(Float((newValue?.height)!))))
		}
	}

	/**
	 *  The size of the `avatarImageView` of a `CSMessagesCollectionViewCellOutgoing`.
	 *  The size values should be greater than or equal to `0.0`.
	 *
	 *  @see `CSMessagesCollectionViewCellOutgoing`.
	 */
	private var priOutgoingAvatarViewSize: CGSize? = nil
	public var outgoingAvatarViewSize: CGSize?
	{
		get
		{
			if self.priOutgoingAvatarViewSize == nil
			{
				self.priOutgoingAvatarViewSize = CGSize()
			}

			return self.priOutgoingAvatarViewSize
		}
		set
		{
			if ((newValue?.width)! < 0.0 || (newValue?.height)! < 0.0) { return }

			self.priOutgoingAvatarViewSize = CGSize(width: CGFloat(ceilf(Float((newValue?.width)!))),
			                                        height: CGFloat(ceilf(Float((newValue?.height)!))))
		}
	}

	/**
	 *  The height of the `cellTopLabel` of a `CSMessagesCollectionViewCell`.
	 *  This value should be greater than or equal to `0.0`.
	 *
	 *  @see `CSMessagesCollectionViewCell`.
	 */
	private var priCellTopLabelHeight: CGFloat! = 0.0
	public var cellTopLabelHeight: CGFloat!
	{
		get { return self.priCellTopLabelHeight }
		set
		{
			if (newValue < 0.0) { return }

			self.priCellTopLabelHeight = CGFloat(floorf(Float(newValue)))
		}
	}

	/**
	 *  The height of the `messageBubbleTopLabel` of a `CSMessagesCollectionViewCell`.
	 *  This value should be greater than or equal to `0.0`.
	 *
	 *  @see `CSMessagesCollectionViewCell`.
	 */
	private var priMessageBubbleTopLabelHeight: CGFloat! = 0.0
	public var messageBubbleTopLabelHeight: CGFloat!
	{
		get { return self.priMessageBubbleTopLabelHeight }
		set
		{
			if (newValue < 0.0) { return }

			self.priMessageBubbleTopLabelHeight = CGFloat(floorf(Float(newValue)))
		}
	}

	/**
	 *  The height of the `cellBottomLabel` of a `CSMessagesCollectionViewCell`.
	 *  This value should be greater than or equal to `0.0`.
	 *
	 *  @see `CSMessagesCollectionViewCell`.
	 */
	private var priCellBottomLabelHeight: CGFloat! = 0.0
	public var cellBottomLabelHeight: CGFloat!
	{
		get { return self.priCellBottomLabelHeight }
		set
		{
			if (newValue < 0.0) { return }

			self.priCellBottomLabelHeight = CGFloat(floorf(Float(newValue)))
		}
	}

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Lifecycle

	deinit
	{
		self.priMessageBubbleFont = nil
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - NSObject

	override public func isEqual(_ object: Any?) -> Bool
	{
		if !(object is CSMessagesCollectionViewLayoutAttributes)
		{
			return false
		}

		if (self.representedElementCategory == UICollectionElementCategory.cell)
		{
			let layoutAttributes: CSMessagesCollectionViewLayoutAttributes = object as! CSMessagesCollectionViewLayoutAttributes

			if (!(layoutAttributes.messageBubbleFont?.isEqual(self.messageBubbleFont))!
				|| !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewFrameInsets, self.textViewFrameInsets)
				|| !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewTextContainerInsets, self.textViewTextContainerInsets)
				|| !(layoutAttributes.incomingAvatarViewSize?.equalTo(self.incomingAvatarViewSize!))!
				|| !(layoutAttributes.outgoingAvatarViewSize?.equalTo(self.outgoingAvatarViewSize!))!
				|| layoutAttributes.messageBubbleLeftRightMargin != self.messageBubbleLeftRightMargin
				|| layoutAttributes.cellTopLabelHeight != self.cellTopLabelHeight
				|| layoutAttributes.messageBubbleTopLabelHeight != self.messageBubbleTopLabelHeight
				|| layoutAttributes.cellBottomLabelHeight != self.cellBottomLabelHeight)
			{
				return false
			}
		}

		return super.isEqual(object)
	}

	public override var hash: Int
	{
		return self.indexPath.hashValue
	}

	override public var hashValue: Int
	{
		return self.indexPath.hashValue
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - NSCopying

	override public func copy(with zone: NSZone? = nil) -> Any
	{
		let copy = super.copy(with: zone) as! CSMessagesCollectionViewLayoutAttributes

		if (copy.representedElementCategory != UICollectionElementCategory.cell) { return copy }

		copy.messageBubbleFont = self.messageBubbleFont
		copy.messageBubbleLeftRightMargin = self.messageBubbleLeftRightMargin
		copy.textViewFrameInsets = self.textViewFrameInsets
		copy.textViewTextContainerInsets = self.textViewTextContainerInsets
		copy.incomingAvatarViewSize = self.incomingAvatarViewSize
		copy.outgoingAvatarViewSize = self.outgoingAvatarViewSize
		copy.cellTopLabelHeight = self.cellTopLabelHeight
		copy.messageBubbleTopLabelHeight = self.messageBubbleTopLabelHeight
		copy.cellBottomLabelHeight = self.cellBottomLabelHeight

		return copy
	}

	//////////////////////////////////////////////////////////////////////////////
}
