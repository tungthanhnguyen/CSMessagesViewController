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
 *  A `CSMessage` model object represents a single user message.
 *  This is a concrete class that implements the `CSMessageData` protocol.
 *  It contains the message text, its sender, and the date that the message was sent.
 */
public class CSMessage: NSObject, CSMessageData, NSCoding, NSCopying
{
	/**
	 *  The body text of the message. This value must not be `nil`.
	 */
	private var priText: NSString? = nil
	public var text: NSString?
	{
		get { return self.priText }
		set
		{
			if (newValue != nil && newValue == self.priText) { return }

			self.priText = newValue
		}
	}
	
	/**
	 *  The name of user who sent the message. This value must not be `nil`.
	 */
	private var priSender: String? = nil
	public var sender: String?
	{
		get { return self.priSender }
		set
		{
			if (newValue != nil && newValue == self.priSender) { return }

			self.priSender = newValue
		}
	}
	
	/**
	 *  The date that the message was sent. This value must not be `nil`.
	 */
	private var priDate: Date? = nil
	public var date: Date?
	{
		get { return self.priDate }
		set
		{
			if (newValue != nil && newValue == self.priDate) { return }

			self.priDate = newValue
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization
	
	override init()
	{
		super.init()
		
		self.text = ""
		self.sender = ""
		self.date = Date()
	}
	
	deinit
	{
		self.text = nil
		self.sender = nil
		self.date = nil
	}
	
	/**
	 *  Initializes and returns a message object having the given text, sender, and current system date.
	 *
	 *  @param text    The body text of the message.
	 *  @param sender  The name of the user who sent the message.
	 *
	 *  @return An initialized `CSMessage` object or `nil` if the object could not be successfully initialized.
	 */
	public convenience init(messageWithText text: NSString?, sender: String?)
	{
		self.init(initWithText: text, sender: sender, date: Date.init())
	}
	
	/**
	 *  Initializes and returns a message object having the given text, sender, and date.
	 *
	 *  @param text    The body text of the message.
	 *  @param sender  The name of the user who sent the message.
	 *  @param date    The date that the message was sent.
	 *
	 *  @return An initialized `CSMessage` object or `nil` if the object could not be successfully initialized.
	 */
	public convenience init(initWithText text: NSString?, sender: String?, date: Date?)
	{
		assert(text != nil, "text must not be nil")
		assert(sender != nil, "sender must not be nil")
		assert(date != nil, "date must not be nil")

		self.init()

		self.text = text
		self.sender = sender
		self.date = date
	}
	
	//////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - CSMessage
	
	/**
	 *  Returns a boolean value that indicates whether a given message is equal to the receiver.
	 *
	 *  @param aMessage  The message with which to compare the receiver.
	 *
	 *  @return `true` if aMessage is equivalent to the receiver, otherwise `false`.
	 */
	public func isEqualToMessage(aMessage: CSMessage) -> Bool
	{
		return (self.text == aMessage.text) && (self.sender == aMessage.sender) && (self.date!.compare(aMessage.date!) == ComparisonResult.orderedSame)
	}
	
	//////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - NSObject
	
	override public func isEqual(_ to: Any?) -> Bool
	{
		if (to != nil)
		{
			if !(to is CSMessage) { return false }

			if ((to as? CSMessage) != nil)
			{
				return isEqualToMessage(aMessage: to as! CSMessage)
			}
			return false
		}
	
		return false
	}
	
	private func hash() -> Int
	{
		return (self.text!.hash) ^ (self.sender!.hash) ^ (self.date!.hashValue)
	}
	
	private func description() -> String
	{
		return String.init("<\(self.self)>[ \(String(describing: self.sender)), \(String(describing: self.date)), \(String(describing: self.text)) ]")
	}
	
	//////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - NSCoding
	
	required convenience public init?(coder aDecoder: NSCoder)
	{
		self.init()

		self.text = aDecoder.decodeObject(forKey: NSStringFromSelector(#selector(getter: text))) as? NSString
		self.sender = (aDecoder.decodeObject(forKey: NSStringFromSelector(#selector(getter: sender))) as! String)
		self.date = (aDecoder.decodeObject(forKey: NSStringFromSelector(#selector(getter: date))) as! Date)
	}
	
	public func encode(with aCoder: NSCoder)
	{
		aCoder.encode(self.text, forKey: NSStringFromSelector(#selector(getter: text)))
		aCoder.encode(self.sender, forKey: NSStringFromSelector(#selector(getter: sender)))
		aCoder.encode(self.date, forKey: NSStringFromSelector(#selector(getter: date)))
	}
	
	//////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - NSCopying

	public func copy(with zone: NSZone? = nil) -> Any
	{
		return CSMessage(initWithText: self.text!, sender: self.sender!, date: self.date!)
	}

	//////////////////////////////////////////////////////////////////////////////
}
