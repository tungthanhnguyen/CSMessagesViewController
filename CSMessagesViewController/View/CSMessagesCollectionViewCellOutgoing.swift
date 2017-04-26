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
 *  A `CSMessagesCollectionViewCellOutgoing` object is a concrete instance of `CSMessagesCollectionViewCell` that represents an outgoing message data item.
 */
public class CSMessagesCollectionViewCellOutgoing: CSMessagesCollectionViewCell
{
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Overrides

	override public class func nib() -> UINib
	{
		return UINib(nibName: String(describing: CSMessagesCollectionViewCellOutgoing.self), bundle: Bundle.cs_messagesBundle())
	}

	override public class func cellReuseIdentifier() -> String
	{
		return String(describing: CSMessagesCollectionViewCellOutgoing.self)
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Overrides

	override public func awakeFromNib()
	{
		super.awakeFromNib()

		// Initialization code

		self.messageBubbleTopLabel.textAlignment = NSTextAlignment.right
		self.cellBottomLabel.textAlignment = NSTextAlignment.right
	}

	//////////////////////////////////////////////////////////////////////////////
}
