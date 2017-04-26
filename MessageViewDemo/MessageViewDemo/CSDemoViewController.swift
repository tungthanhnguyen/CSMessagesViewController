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

import CSSystemSoundPlayer
import CSMessagesViewController
import Foundation
import UIKit

let CSDemoAvatarNameCook = "Tim Cook"
let CSDemoAvatarNameJobs = "Jobs"
let CSDemoAvatarNameWoz = "Steve Wozniak"

protocol CSDemoViewControllerDelegate: NSObjectProtocol
{
	func didDismissCSDemoViewController(_ vc: CSDemoViewController)
}

public class CSDemoViewController: CSMessagesViewController
{
	weak var delegateModal: CSDemoViewControllerDelegate?

	var messages: NSMutableArray!
	var avatas: NSDictionary!

	var outgoingBubbleImageView: UIImageView!
	var incomingBubbleImageView: UIImageView!

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Demo setup

	func setupTestModel()
	{
		/**
		 *  Load some fake messages for demo.
		 *
		 *  You should have a mutable array or orderedSet, or something.
		 */
		self.messages = [CSMessage(initWithText: "Welcome to CSMessages: A messaging UI framework for iOS.", sender: self.sender!, date: Date.distantPast), CSMessage(initWithText: "It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy.", sender: CSDemoAvatarNameWoz, date: Date.distantPast), CSMessage(initWithText: "It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com.", sender: self.sender!, date: Date.distantPast), CSMessage(initWithText: "CSMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better.", sender: CSDemoAvatarNameJobs, date: Date()), CSMessage(initWithText: "It is unit-tested, free, and open-source.", sender: CSDemoAvatarNameCook, date: Date()), CSMessage(initWithText: "Oh, and there's sweet documentation.", sender: self.sender!, date: Date())]

		/**
		 *  Create avatar images once.
		 *
		 *  Be sure to create your avatars one time and reuse them for good performance.
		 *
		 *  If you are not using avatars, ignore this.
		 */
		let outgoingDiameter: CGFloat = (self.collectionView.collectionViewLayout as! CSMessagesCollectionViewFlowLayout).outgoingAvatarViewSize.width

		let csImage: UIImage = CSMessagesAvatarFactory.avatarWithUserInitials("TN", backgroundColor: UIColor(white: CGFloat(0.85), alpha: CGFloat(1.0)), textColor: UIColor(white: CGFloat(0.60), alpha: CGFloat(1.0)), font: UIFont.systemFont(ofSize: 14.0), diameter: Int(outgoingDiameter))

		let incomingDiameter: CGFloat = (self.collectionView.collectionViewLayout as! CSMessagesCollectionViewFlowLayout).incomingAvatarViewSize.width

		let cookImage: UIImage = CSMessagesAvatarFactory.avatarWithImage(UIImage(named: "demo_avatar_cook")!, diameter: Int(incomingDiameter))
		let jobsImage: UIImage = CSMessagesAvatarFactory.avatarWithImage(UIImage(named: "demo_avatar_jobs")!, diameter: Int(incomingDiameter))
		let wozImage: UIImage = CSMessagesAvatarFactory.avatarWithImage(UIImage(named: "demo_avatar_woz")!, diameter: Int(incomingDiameter))

		self.avatas = [self.sender!: csImage, CSDemoAvatarNameCook: cookImage, CSDemoAvatarNameJobs: jobsImage, CSDemoAvatarNameWoz: wozImage]

		/**
		 *  Change to add more messages for testing
		 */
		let messagesToAdd: UInt = 0
		let copyOfMessages: NSArray = self.messages.copy() as! NSArray
		for _ in 0..<messagesToAdd
		{
			self.messages.addObjects(from: copyOfMessages as! [Any])
		}

		/**
		 *  Change to `true` to add a super long message for testing
		 *  You should see "END" twice
		 */
		let isAddREALLYLongMessage: Bool = false
		if isAddREALLYLongMessage
		{
			let reallyLongMessage = CSMessage(messageWithText: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END", sender: self.sender!)
			self.messages.add(reallyLongMessage)
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - View lifecycle

	/**
	 *  Override point for customization.
	 *
	 *  Customize your view.
	 *  Look at the properties on `CSMessagesViewController` to see what is possible.
	 *
	 *  Customize your layout.
	 *  Look at the properties on `CSMessagesCollectionViewFlowLayout` to see what is possible.
	 */
	override public func viewDidLoad()
	{
		super.viewDidLoad()

		self.title = "MessageView Demo"

		self.sender = "TN"

		self.setupTestModel()

		/**
		 *  Remove camera button since media messages are not yet implemented
		 *
		 *   self.inputToolbar.contentView.leftBarButtonItem = nil
		 *
		 *  Or, you can set a custom `leftBarButtonItem` and a custom `rightBarButtonItem`
		 */

		/**
		 *  Create bubble images.
		 *
		 *  Be sure to create your avatars one time and reuse them for good performance.
		 *
		 */
		self.outgoingBubbleImageView = CSMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(color: UIColor.cs_messageBubbleLightGrayColor())

		self.incomingBubbleImageView = CSMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(color: UIColor.cs_messageBubbleGreenColor())

		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.cs_bubbleImageFromBundleWithName("typing"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(receiveMessagePressed(_:)))
	}

	public override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)

		if (self.delegateModal != nil)
		{
			self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(closePressed(_:)))
		}
	}

	override public func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)

		/**
		 *  Enable/disable springy bubbles, default is `false`.
		 *  You must set this from `viewDidAppear:`
		 *  Note: this feature is mostly stable, but still experimental
		 */
		(self.collectionView.collectionViewLayout as! CSMessagesCollectionViewFlowLayout).isSpringinessEnabled = true
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Actions

	func receiveMessagePressed(_ sender: UIBarButtonItem)
	{
		/**
		 *  The following is simply to simulate received messages for the demo.
		 *  Do not actually do this.
		 */

		/**
		 *  Set the typing indicator to be shown
		 */
		self.isShowTypingIndicator = !self.isShowTypingIndicator

		/**
		 *  Scroll to actually view the indicator
		 */
		self.scrollToBottomAnimated(true)

		var copyMessage: CSMessage? = (self.messages.lastObject as! CSMessage?)?.copy() as? CSMessage

		if (copyMessage == nil)
		{
			copyMessage = CSMessage(messageWithText: "First received!", sender: CSDemoAvatarNameJobs)
		}

		let deadline: DispatchTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(1000)
		DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async
		{
			//DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
			DispatchQueue.main.asyncAfter(deadline: deadline,
				execute:
				{
					() -> Void in

					var copyAvatars: [String] = self.avatas.allKeys as! [String]
					copyAvatars.remove(at: copyAvatars.index(of: self.sender!)!)
					copyMessage?.sender = copyAvatars[Int(arc4random_uniform(UInt32(copyAvatars.count)))]
					/**
					 *  This you should do upon receiving a message:
					 *
					 *  1. Play sound (optional)
					 *  2. Add new <CSMessageData> object to your data source
					 *  3. Call `finishReceivingMessage`
					 */
					CSSystemSoundPlayer.cs_playMessageReceivedSound()
					self.messages.addObjects(from: [copyMessage!])
					self.finishReceivingMessage()
				}
			)
		}
	}

	func closePressed(_ sender: UIBarButtonItem)
	{
		self.delegateModal?.didDismissCSDemoViewController(self)
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - CSMessagesViewController method overrides

	override public func didPressSendButton(_ button: UIButton, withMessageText text: String, sender: String, date: Date)
	{
		/**
		 *  Sending a message. Your implementation of this method should do *at least* the following:
		 *
		 *  1. Play sound (optional)
		 *  2. Add new <CSMessageData> object to your data source
		 *  3. Call `finishSendingMessage`
		 */
		CSSystemSoundPlayer.cs_playMessageSentSound()

		let message: CSMessage = CSMessage(initWithText: text as NSString, sender: sender, date: date)
		self.messages.addObjects(from: [message])
		self.finishSendingMessage()
	}

	override public func didPressAccessoryButton(sender: UIButton)
	{
		NSLog("Camera pressed!")

		/**
		 *  Accessory button has no default functionality, yet.
		 */
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - CSMessages CollectionView DataSource

	override public func collectionView(_ collectionView: CSMessagesCollectionView, messageDataForItemAtIndexPath indexPath: IndexPath) -> CSMessageData?
	{
		return (self.messages[indexPath.item] as! CSMessageData)
	}

	override public func collectionView(_ collectionView: CSMessagesCollectionView, bubbleImageViewForItemAtIndexPath indexPath: IndexPath) -> UIImageView?
	{
		/**
		 *  You may return nil here if you do not want bubbles.
		 *  In this case, you should set the background color of your collection view cell's textView.
		 */

		/**
		 *  Reuse created bubble images, but create new imageView to add to each cell
		 *  Otherwise, each cell would be referencing the same imageView and bubbles would disappear from cells
		 */

		let message: CSMessage = self.messages[indexPath.item] as! CSMessage

		if (message.sender == self.sender)
		{
			return UIImageView(image: self.outgoingBubbleImageView.image, highlightedImage: self.outgoingBubbleImageView.highlightedImage)
		}

		return UIImageView(image: self.incomingBubbleImageView.image, highlightedImage: self.incomingBubbleImageView.highlightedImage)
	}

	override public func collectionView(_ collectionView: CSMessagesCollectionView, avatarImageViewForItemAtIndexPath indexPath: IndexPath) -> UIImageView?
	{
		/**
		 *  Return `nil` here if you do not want avatars.
		 *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
		 *
		 *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
		 *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
		 *
		 *  It is possible to have only outgoing avatars or only incoming avatars, too.
		 */

		/**
		 *  Reuse created avatar images, but create new imageView to add to each cell
		 *  Otherwise, each cell would be referencing the same imageView and avatars would disappear from cells
		 *
		 *  Note: these images will be sized according to these values:
		 *
		 *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
		 *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
		 *
		 *  Override the defaults in `viewDidLoad`
		 */
		let message: CSMessage = self.messages[indexPath.item] as! CSMessage

		let avatarImage: UIImage = self.avatas[message.sender!] as! UIImage
		return UIImageView(image: avatarImage)
	}

	override public func collectionView(_ collectionView: CSMessagesCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: IndexPath) -> NSAttributedString?
	{
		/**
		 *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
		 *  The other label text delegate methods should follow a similar pattern.
		 *
		 *  Show a timestamp for every 3rd message
		 */
		if (indexPath.item % 3 == 0)
		{
			let message: CSMessage = self.messages[indexPath.item] as! CSMessage
			return CSMessagesTimestampFormatter.sharedFormatter.attributedTimestampForDate(date: message.date!)
		}

		return nil
	}

	override public func collectionView(_ collectionView: CSMessagesCollectionView, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: IndexPath) -> NSAttributedString?
	{
		let message: CSMessage = self.messages[indexPath.item] as! CSMessage

		/**
		 *  iOS7-style sender name labels
		 */
		if (message.sender == self.sender) { return nil }

		if (indexPath.item - 1 > 0)
		{
			let previousMessage: CSMessage = self.messages[indexPath.item - 1] as! CSMessage
			if (previousMessage.sender == message.sender) { return nil }
		}

		/**
		 *  Don't specify attributes to use the defaults.
		 */
		return NSAttributedString(string: message.sender!)
	}

	override public func collectionView(_ collectionView: CSMessagesCollectionView, attributedTextForCellBottomLabelAtIndexPath indexPath: IndexPath) -> NSAttributedString?
	{
		return nil
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - UICollectionView DataSource

	override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return self.messages.count
	}

	override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		/**
		 *  Override point for customizing cells
		 */
		let cell: CSMessagesCollectionViewCell = super.collectionView(collectionView, cellForItemAt: indexPath) as! CSMessagesCollectionViewCell

		/**
		 *  Configure almost *anything* on the cell
		 *
		 *  Text colors, label text, label colors, etc.
		 *
		 *
		 *  DO NOT set `cell.textView.font`!
		 *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
		 *
		 *
		 *  DO NOT manipulate cell layout information!
		 *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
		 */

		let message: CSMessage = self.messages[indexPath.item] as! CSMessage

		if (message.sender == self.sender)
		{
			cell.textView.textColor = UIColor.black
		}
		else
		{
			cell.textView.textColor = UIColor.white
		}

		cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor!, NSUnderlineStyleAttributeName: (NSUnderlineStyle.styleSingle.rawValue ^ NSUnderlineStyle.patternSolid.rawValue)]

		return cell
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - CSMessages collection view flow layout delegate

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Adjusting cell label heights

	override public func collectionView(_ collectionView: CSMessagesCollectionView, layout collectionViewLayout: CSMessagesCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: IndexPath) -> CGFloat
	{
		/**
		 *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
		 */

		/**
		 *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
		 *  The other label height delegate methods should follow similarly
		 *
		 *  Show a timestamp for every 3rd message
		 */
		if (indexPath.item % 3 == 0)
		{
			return kCSMessagesCollectionViewCellLabelHeightDefault
		}

		return 0.0
	}

	override public func collectionView(_ collectionView: CSMessagesCollectionView, layout collectionViewLayout: CSMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAtIndexPath indexPath: IndexPath) -> CGFloat
	{
		/**
		 *  iOS7-style sender name labels
		 */
		let currentMessage: CSMessage = self.messages[indexPath.item] as! CSMessage
		if (currentMessage.sender == self.sender) { return 0.0 }

		if (indexPath.item - 1 > 0)
		{
			let previousMessage: CSMessage = self.messages[indexPath.item - 1] as! CSMessage
			if (previousMessage.sender == currentMessage.sender) { return 0.0 }
		}

		return kCSMessagesCollectionViewCellLabelHeightDefault
	}

	override public func collectionView(_ collectionView: CSMessagesCollectionView, layout collectionViewLayout: CSMessagesCollectionViewFlowLayout, heightForCellBottomLabelAtIndexPath indexPath: IndexPath) -> CGFloat
	{
		return 0.0
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Responding to collection view tap events

	override public func collectionView(_ collectionView: CSMessagesCollectionView, header headerView: CSMessagesLoadEarlierHeaderView, didTapLoadEarlierMessagesButton sender: UIButton)
	{
		NSLog("Load earlier messages!")
	}

	override public func collectionView(_ collectionView: CSMessagesCollectionView, didTapAvatarImageView avatarImageView: UIImageView, atIndexPath indexPath: IndexPath)
	{
		NSLog("Tapped avatar!")
	}

	override public func collectionView(_ collectionView: CSMessagesCollectionView, didTapMessageBubbleAtIndexPath indexPath: IndexPath)
	{
		NSLog("Tapped message bubble!")
	}

	override public func collectionView(_ collectionView: CSMessagesCollectionView, didTapCellAtIndexPath indexPath: IndexPath, touchLocation: CGPoint)
	{
		NSLog("Tapped cell at %@!", NSStringFromCGPoint(touchLocation))
	}

	//////////////////////////////////////////////////////////////////////////////
}
