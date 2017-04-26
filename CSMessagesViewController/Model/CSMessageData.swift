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

/**
 *  The `CSMessageData` protocol defines the common interface through which `CSMessagesViewController` and `CSMessagesCollectionView` interacts with message model objects.
 *
 *  It declares the required and optional methods that a class must implement so that instances of that class can be displayed properly with a `CSMessagesCollectionViewCell`.
 */
public protocol CSMessageData: NSObjectProtocol
{
	/**
	 *  @return The body text of the message.
	 *  @warning You must not return `nil` from this method.
	 */
	var text: NSString? { get }
	
	/**
	 *  @return The name of the user who sent the message.
	 *  @warning You must not return `nil` from this method.
	 */
	var sender: String? { get }
	
	/**
	 *  @return The date that the message was sent.
	 *  @warning You must not return `nil` from this method.
	 */
	var date: Date? { get }
}
