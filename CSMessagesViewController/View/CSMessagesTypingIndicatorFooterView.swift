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
 *  A constant defining the default height of a `CSMessagesTypingIndicatorFooterView`.
 */
public let kCSMessagesTypingIndicatorFooterViewHeight: CGFloat = 46.0

/**
 *  The `CSMessagesTypingIndicatorFooterView` class implements a reusable view that can be placed at the bottom of a `CSMessagesCollectionView`. This view represents a typing indicator for incoming messages.
 */
public class CSMessagesTypingIndicatorFooterView: UICollectionReusableView
{
	@IBOutlet weak var bubbleImageView: UIImageView!
	@IBOutlet weak var bubbleImageViewLeftHorizontalConstraint: NSLayoutConstraint!
	@IBOutlet weak var bubbleImageViewRightHorizontalConstraint: NSLayoutConstraint!

	@IBOutlet weak var typingIndicatorImageView: UIImageView!
	@IBOutlet weak var typingIndicatorImageViewLeftHorizontalConstraint: NSLayoutConstraint!
	@IBOutlet weak var typingIndicatorImageViewRightHorizontalConstraint: NSLayoutConstraint!


	override public var backgroundColor: UIColor!
	{
		get { return super.backgroundColor }
		set
		{
			super.backgroundColor = newValue
			self.bubbleImageView.backgroundColor = newValue
		}
	}

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Class methods

	/**
	 *  Returns the `UINib` object initialized for the collection reusable view.
	 *
	 *  @return The initialized `UINib` object or `nil` if there were errors during initialization or the nib file could not be located.
	 */
	public class func nib() -> UINib
	{
		return UINib(nibName: String(describing: CSMessagesTypingIndicatorFooterView.self), bundle: Bundle.cs_messagesBundle())
	}

	/**
	*  Returns the default string used to identify the reusable footer view.
	*
	*  @return The string used to identify the reusable footer view.
	*/
	public class func footerReuseIdentifier() -> String
	{
		return String(describing: CSMessagesTypingIndicatorFooterView.self)
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization

	override public func awakeFromNib()
	{
		super.awakeFromNib()

		// Initialization code

		self.translatesAutoresizingMaskIntoConstraints = false
		self.backgroundColor = UIColor.clear
	}

	deinit
	{
		self.bubbleImageView = nil
		self.typingIndicatorImageView = nil
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Typing indicator

	public func configureForIncoming(_ isIncoming: Bool, indicatorColor: UIColor!, bubbleColor: UIColor!, collectionView: UICollectionView!)
	{
		assert(indicatorColor != nil)
		assert(bubbleColor != nil)
		assert(collectionView != nil)

		let collectionViewWidth = collectionView.frame.width
		let bubbleWidth = self.bubbleImageView.frame.width
		let indicatorWidth = self.typingIndicatorImageView.frame.width

		let bubbleMarginMinimumSpacing: CGFloat = 6.0
		let indicatorMarginMinimumSpacing: CGFloat = 24.0

		let bubbleMarginMaximumSpacing: CGFloat = collectionViewWidth - bubbleWidth - bubbleMarginMinimumSpacing
		let indicatorMarginMaximumSpacing: CGFloat = collectionViewWidth - indicatorWidth - indicatorMarginMinimumSpacing

		if isIncoming
		{
			self.bubbleImageView.image = CSMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(color: bubbleColor).image

			self.bubbleImageViewLeftHorizontalConstraint.constant = bubbleMarginMinimumSpacing
			self.bubbleImageViewRightHorizontalConstraint.constant = bubbleMarginMaximumSpacing

			self.typingIndicatorImageViewLeftHorizontalConstraint.constant = indicatorMarginMinimumSpacing
			self.typingIndicatorImageViewRightHorizontalConstraint.constant = indicatorMarginMaximumSpacing
		}
		else
		{
			self.bubbleImageView.image = CSMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(color: bubbleColor).image

			self.bubbleImageViewLeftHorizontalConstraint.constant = bubbleMarginMaximumSpacing
			self.bubbleImageViewRightHorizontalConstraint.constant = bubbleMarginMinimumSpacing

			self.typingIndicatorImageViewLeftHorizontalConstraint.constant = indicatorMarginMaximumSpacing
			self.typingIndicatorImageViewRightHorizontalConstraint.constant = indicatorMarginMinimumSpacing
		}

		self.needsUpdateConstraints()

		self.typingIndicatorImageView.image = UIImage.cs_bubbleImageFromBundleWithName("typing").cs_imageMaskedWithColor(indicatorColor)
		self.typingIndicatorImageView.contentMode = UIViewContentMode.scaleAspectFit
	}

	//////////////////////////////////////////////////////////////////////////////
}
