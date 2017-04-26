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
 *  An object that adopts the `CSMessagesCollectionViewDataSource` protocol is responsible for providing the data and views required by a `CSMessagesCollectionView`. The data source object represents your app’s messaging data model and vends information to the collection view as needed.
 */
public protocol CSMessagesCollectionViewDataSource: UICollectionViewDataSource
{
	/**
	 *  Asks the data source for the message sender, that is, the user who is sending messages.
	 *
	 *  @return An initialized string describing the sender. You must not return `nil` from this method.
	 */
	var sender: String? { get set }

	/**
	 *  Asks the data source for the message data that corresponds to the specified item at indexPath in the collectionView.
	 *
	 *  @param collectionView  The object representing the collection view requesting this information.
	 *  @param indexPath       The index path that specifies the location of the item.
	 *
	 *  @return A configured object that conforms to the `CSMessageData` protocol. You must not return `nil` from this method.
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, messageDataForItemAtIndexPath indexPath: IndexPath) -> CSMessageData?

	/**
	 *  Asks the data source for the bubble image view that corresponds to the specified message data item at indexPath in the collectionView.
	 *
	 *  @param collectionView  The object representing the collection view requesting this information.
	 *  @param indexPath       The index path that specifies the location of the item.
	 *
	 *  @return A configured imageView object. You may return `nil` from this method if you do not want the specified item to display a message bubble image.
	 *
	 *  @discussion It is recommended that you utilize `CSMessagesBubbleImageFactory` to return valid imageViews.
	 *  However, you may provide your own.
	 *  If providing your own bubble image view, please ensure the following:
	 *      1. The imageView object must contain valid values for its `image` and `highlightedImage` properties.
	 *      2. The images provided in the imageView must be stretchable images.
	 *  Note that providing your own bubble image views will require additional configuration of the collectionView layout object.
	 *
	 *  @see `CSMessagesBubbleImageFactory`.
	 *  @see `CSMessagesCollectionViewFlowLayout`.
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, bubbleImageViewForItemAtIndexPath indexPath: IndexPath) -> UIImageView?

	/**
	 *  Asks the data source for the avatar image view that corresponds to the specified message data item at indexPath in the collectionView.
	 *
	 *  @param collectionView  The object representing the collection view requesting this information.
	 *  @param indexPath       The index path that specifies the location of the item.
	 *
	 *  @return A configured imageView object. You may return `nil` from this method if you do not want the specified item to display an avatar.
	 *
	 *  @discussion It is recommended that you utilize `CSMessagesAvatarFactory` to return a styled avatar image.
	 *  However, you may provide your own.
	 *  Note that the size of the imageView is ignored. To specify avatar image view sizes, set the appropriate properties on the collectionView's layout object.
	 *
	 *  @see `CSMessagesAvatarFactory`.
	 *  @see `CSMessagesCollectionViewFlowLayout`.
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, avatarImageViewForItemAtIndexPath indexPath: IndexPath) -> UIImageView?

	/**
	 *  Asks the data source for the text to display in the `cellTopLabel` for the specified message data item at indexPath in the collectionView.
	 *
	 *  @param collectionView  The object representing the collection view requesting this information.
	 *  @param indexPath       The index path that specifies the location of the item.
	 *
	 *  @return A configured attributed string or `nil` if you do not want text displayed for the item at indexPath.
	 *  Return an attributed string with `nil` attributes to use the default attributes.
	 *
	 *  @see `CSMessagesCollectionViewCell`.
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: IndexPath) -> NSAttributedString?

	/**
	 *  Asks the data source for the text to display in the `messageBubbleTopLabel` for the specified message data item at indexPath in the collectionView.
	 *
	 *  @param collectionView  The object representing the collection view requesting this information.
	 *  @param indexPath       The index path that specifies the location of the item.
	 *
	 *  @return A configured attributed string or `nil` if you do not want text displayed for the item at indexPath.
	 *  Return an attributed string with `nil` attributes to use the default attributes.
	 *
	 *  @see `CSMessagesCollectionViewCell`.
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: IndexPath) -> NSAttributedString?

	/**
	 *  Asks the data source for the text to display in the `cellBottomLabel` for the the specified message data item at indexPath in the collectionView.
	 *
	 *  @param collectionView  The object representing the collection view requesting this information.
	 *  @param indexPath       The index path that specifies the location of the item.
	 *
	 *  @return A configured attributed string or `nil` if you do not want text displayed for the item at indexPath.
	 *  Return an attributed string with `nil` attributes to use the default attributes.
	 *
	 *  @see `CSMessagesCollectionViewCell`.
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, attributedTextForCellBottomLabelAtIndexPath indexPath: IndexPath) -> NSAttributedString?
}

/**
 *  The `CSMessagesCollectionViewDelegateFlowLayout` protocol defines methods that allow you to manage additional layout information for the collection view and respond to additional actions on its items.
 *  The methods of this protocol are all optional.
 */
public protocol CSMessagesCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout
{
	/**
	 *  Asks the delegate for the height of the `cellTopLabel` for the item at the specified indexPath.
	 *
	 *  @param collectionView        The collection view object displaying the flow layout.
	 *  @param collectionViewLayout  The layout object requesting the information.
	 *  @param indexPath             The index path of the item.
	 *
	 *  @return The height of the `cellTopLabel` for the item at indexPath.
	 *
	 *  @see `CSMessagesCollectionViewCell`.
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, layout collectionViewLayout: CSMessagesCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: IndexPath) -> CGFloat

	/**
	 *  Asks the delegate for the height of the `messageBubbleTopLabel` for the item at the specified indexPath.
	 *
	 *  @param collectionView        The collection view object displaying the flow layout.
	 *  @param collectionViewLayout  The layout object requesting the information.
	 *  @param indexPath             The index path of the item.
	 *
	 *  @return The height of the `messageBubbleTopLabel` for the item at indexPath.
	 *
	 *  @see `CSMessagesCollectionViewCell`.
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, layout collectionViewLayout: CSMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAtIndexPath indexPath: IndexPath) -> CGFloat

	/**
	 *  Asks the delegate for the height of the `cellBottomLabel` for the item at the specified indexPath.
	 *
	 *  @param collectionView        The collection view object displaying the flow layout.
	 *  @param collectionViewLayout  The layout object requesting the information.
	 *  @param indexPath             The index path of the item.
	 *
	 *  @return The height of the `cellBottomLabel` for the item at indexPath.
	 *
	 *  @see `CSMessagesCollectionViewCell`.
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, layout collectionViewLayout: CSMessagesCollectionViewFlowLayout, heightForCellBottomLabelAtIndexPath indexPath: IndexPath) -> CGFloat

	/**
	 *  Notifies the delegate that the avatar image view at the specified indexPath did receive a tap event.
	 *
	 *  @param collectionView   The collection view object that is notifying you of the tap event.
	 *  @param avatarImageView  The avatar image view that was tapped.
	 *  @param indexPath        The index path of the item for which the avatar was tapped.
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, didTapAvatarImageView avatarImageView: UIImageView, atIndexPath indexPath: IndexPath)

	/**
	 *  Notifies the delegate that the message bubble at the specified indexPath did receive a tap event.
	 *
	 *  @param collectionView  The collection view object that is notifying you of the tap event.
	 *  @param indexPath       The index path of the item for which the message bubble was tapped.
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, didTapMessageBubbleAtIndexPath indexPath: IndexPath)

	/**
	 *  Notifies the delegate that the cell at the specified indexPath did receive a tap event at the specified touchLocation.
	 *
	 *  @param collectionView  The collection view object that is notifying you of the tap event.
	 *  @param indexPath       The index path of the item for which the message bubble was tapped.
	 *  @param touchLocation   The location of the touch event in the cell's coordinate system.
	 *
	 *  @warning This method is *only* called if position is *not* within the bounds of the cell's avatar image view or message bubble image view. In other words, this method is *not* called when the cell's avatar or message bubble are tapped. There are separate delegate methods for these two cases.
	 *
	 *  @see `collectionView:didTapAvatarImageView:atIndexPath:`
	 *  @see `collectionView:didTapMessageBubbleAtIndexPath:atIndexPath:`
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, didTapCellAtIndexPath indexPath: IndexPath, touchLocation: CGPoint)

	/**
	 *  Notifies the delegate that the collection view's header did receive a tap event.
	 *
	 *  @param collectionView  The collection view object that is notifying you of the tap event.
	 *  @param headerView      The header view in the collection view.
	 *  @param sender          The button that was tapped.
	 */
	func collectionView(_ collectionView: CSMessagesCollectionView, header headerView: CSMessagesLoadEarlierHeaderView, didTapLoadEarlierMessagesButton sender: UIButton)
}


/**
 *  The `CSMessagesCollectionView` class manages an ordered collection of message data items and presents them using a specialized layout for messages.
 */
public class CSMessagesCollectionView: UICollectionView
{
	/**
	 *  The object that provides the data for the collection view.
	 *  The data source must adopt the `CSMessagesCollectionViewDataSource` protocol.
	 */
//	private weak var priDataSource: CSMessagesCollectionViewDataSource!
//	public override weak var dataSource: UICollectionViewDataSource?
//	{
//		get { return self.priDataSource }
//		set
//		{
//			self.priDataSource = newValue as! CSMessagesCollectionViewDataSource!
//		}
//	}

	/**
	 *  The object that acts as the delegate of the collection view.
	 *  The delegate must adpot the `CSMessagesCollectionViewDelegateFlowLayout` protocol.
	 */
//	private weak var priDelegate: CSMessagesCollectionViewDelegateFlowLayout!
//	public override weak var delegate: UICollectionViewDelegate?
//	{
//		get { return self.priDelegate }
//		set
//		{
//			self.priDelegate = newValue as! CSMessagesCollectionViewDelegateFlowLayout!
//		}
//	}

	/**
	 *  The layout used to organize the collection view’s items.
	 */
//	private var priCollectionViewLayout: CSMessagesCollectionViewFlowLayout!
//	public override var collectionViewLayout: UICollectionViewLayout
//	{
//		get
//		{
//			if self.priCollectionViewLayout == nil
//			{
//				self.priCollectionViewLayout = CSMessagesCollectionViewFlowLayout()
//			}
//
//			return self.priCollectionViewLayout
//		}
//		set
//		{
//			self.priCollectionViewLayout = newValue as! CSMessagesCollectionViewFlowLayout
//		}
//	}

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization

	func cs_configureCollectionView()
	{
		self.translatesAutoresizingMaskIntoConstraints = false

		self.backgroundColor = UIColor.white
		self.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
		self.alwaysBounceVertical = true
		self.bounces = true

		self.register(CSMessagesCollectionViewCellIncoming.nib(), forCellWithReuseIdentifier: CSMessagesCollectionViewCellIncoming.cellReuseIdentifier())
		self.register(CSMessagesCollectionViewCellOutgoing.nib(), forCellWithReuseIdentifier: CSMessagesCollectionViewCellOutgoing.cellReuseIdentifier())

		self.register(CSMessagesTypingIndicatorFooterView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CSMessagesTypingIndicatorFooterView.footerReuseIdentifier())
		self.register(CSMessagesLoadEarlierHeaderView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CSMessagesLoadEarlierHeaderView.headerReuseIdentifier())
	}

	override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout)
	{
		super.init(frame: frame, collectionViewLayout: layout)

		self.cs_configureCollectionView()
	}
	
	required public init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}

	override public func awakeFromNib()
	{
		super.awakeFromNib()

		self.cs_configureCollectionView()
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Typing indicator

	/**
	 *  Returns a `CSMessagesTypingIndicatorFooterView` object configured with the specified parameters.
	 *
	 *  @param isIncoming      Specifies whether the typing indicator should be displayed for an incoming message or outgoing message.
	 *  @param indicatorColor  The color of the typing indicator ellipsis. This value must not be `nil`.
	 *  @param bubbleColor     The color of the message bubble. This value must not be `nil`.
	 *  @param indexPath       The index path specifying the location of the supplementary view in the collection view. This value must not be `nil`.
	 *
	 *  @return A valid `CSMessagesTypingIndicatorFooterView` object.
	 */
	func dequeueTypingIndicatorFooterViewIncoming(_ isIncoming: Bool, withIndicatorColor indicatorColor: UIColor, bubbleColor: UIColor, forIndexPath indexPath: IndexPath) -> CSMessagesTypingIndicatorFooterView
	{
		let footerView: CSMessagesTypingIndicatorFooterView = super.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CSMessagesTypingIndicatorFooterView.footerReuseIdentifier(), for: indexPath) as! CSMessagesTypingIndicatorFooterView

		footerView.configureForIncoming(isIncoming, indicatorColor: indicatorColor, bubbleColor: bubbleColor, collectionView: self)

		return footerView
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Load earlier messages header

	/**
	 *  Returns a `CSMessagesLoadEarlierHeaderView` object for the specified index path.
	 *
	 *  @param indexPath  The index path specifying the location of the supplementary view in the collection view. This value must not be `nil`.
	 *
	 *  @return A valid `CSMessagesLoadEarlierHeaderView` object.
	 */
	func dequeueLoadEarlierMessagesViewHeaderForIndexPath(_ indexPath: IndexPath) -> CSMessagesLoadEarlierHeaderView
	{
		let headerView: CSMessagesLoadEarlierHeaderView = super.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CSMessagesLoadEarlierHeaderView.headerReuseIdentifier(), for: indexPath) as! CSMessagesLoadEarlierHeaderView

		headerView.delegate = self

		return headerView
	}

	//////////////////////////////////////////////////////////////////////////////
}

////////////////////////////////////////////////////////////////////////////////
// MARK: - Load earlier messages header delegate

extension CSMessagesCollectionView: CSMessagesLoadEarlierHeaderViewDelegate
{
	func headerView(_ headerView: CSMessagesLoadEarlierHeaderView, didPressLoadButton sender: UIButton)
	{
		if (self.delegate?.responds(to: #selector(CSMessagesViewController.collectionView(_:header:didTapLoadEarlierMessagesButton:))))!
		{
			(self.delegate as! CSMessagesCollectionViewDelegateFlowLayout).collectionView(self, header: headerView, didTapLoadEarlierMessagesButton: sender)
		}
	}
}

////////////////////////////////////////////////////////////////////////////////
