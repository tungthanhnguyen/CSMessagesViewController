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
 *  A constant defining the default height of a `CSMessagesLoadEarlierHeaderView`.
 */
public let kCSMessagesLoadEarlierHeaderViewHeight: CGFloat = 32.0

/**
 *  The `CSMessagesLoadEarlierHeaderViewDelegate` defines methods that allow you to respond to interactions within the header view.
 */
protocol CSMessagesLoadEarlierHeaderViewDelegate: NSObjectProtocol
{
	/**
	 *  Tells the delegate that the loadButton has received a touch event.
	 *
	 *  @param headerView  The header view that contains the sender.
	 *  @param sender      The button that received the touch.
	 */
	func headerView(_ headerView: CSMessagesLoadEarlierHeaderView, didPressLoadButton sender: UIButton)
}


/**
 *  The `CSMessagesLoadEarlierHeaderView` class implements a reusable view that can be placed at the top of a `CSMessagesCollectionView`. This view contains a "load earlier messages" button and can be used as a way for the user to load previously sent messages.
 */
public class CSMessagesLoadEarlierHeaderView: UICollectionReusableView
{
	/**
	 *  The object that acts as the delegate of the header view.
	 */
	weak var delegate: CSMessagesLoadEarlierHeaderViewDelegate!

	/**
	 *  Returns the load button of the header view.
	 */
	@IBOutlet weak var loadButton: UIButton!

	override public var backgroundColor: UIColor!
	{
		get { return super.backgroundColor }
		set
		{
			super.backgroundColor = newValue
			self.loadButton?.backgroundColor = newValue
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
		return UINib(nibName: String(describing: CSMessagesLoadEarlierHeaderView.self), bundle: Bundle.cs_messagesBundle())
	}

	/**
	 *  Returns the default string used to identify the reusable header view.
	 *
	 *  @return The string used to identify the reusable header view.
	 */
	public class func headerReuseIdentifier() -> String
	{
		return String(describing: CSMessagesLoadEarlierHeaderView.self)
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
		self.loadButton?.setTitle(NSLocalizedString("Load Earlier Messages", comment: "Text for button to load previously sent messages"), for: UIControlState.normal)
	}

	deinit
	{
		self.loadButton = nil
		self.delegate = nil
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Actions

	@IBAction func loadButtonPressed(_ sender: UIButton)
	{
		self.delegate?.headerView(self, didPressLoadButton: sender)
	}

	//////////////////////////////////////////////////////////////////////////////
}
