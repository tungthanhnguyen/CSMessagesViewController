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
 *  A constant the specifies the default height for a `CSMessagesInputToolbar`.
 */
public let kCSMessagesInputToolbarHeightDefault: CGFloat = 44.0

public var kCSMessagesInputToolbarKeyValueObservingContext = 0

/**
 *  The `CSMessagesInputToolbarDelegate` protocol defines methods for interacting with a `CSMessagesInputToolbar` object.
 */
protocol CSMessagesInputToolbarDelegate: UIToolbarDelegate
{
	/**
	 *  Tells the delegate that the toolbar's `rightBarButtonItem` has been pressed.
	 *
	 *  @param toolbar  The object representing the toolbar sending this information.
	 *  @param sender   The button that received the touch event.
	 */
	func messagesInputToolbar(_ toolbar: CSMessagesInputToolbar, didPressRightBarButton sender: UIButton)

	/**
	 *  Tells the delegate that the toolbar's `leftBarButtonItem` has been pressed.
	 *
	 *  @param toolbar  The object representing the toolbar sending this information.
	 *  @param sender   The button that received the touch event.
	 */
	func messagesInputToolbar(_ toolbar: CSMessagesInputToolbar, didPressLeftBarButton sender: UIButton)
}


/**
 *  An instance of `CSMessagesInputToolbar` defines the input toolbar for composing a new message. It is displayed above and follow the movement of the system keyboard.
 */
public class CSMessagesInputToolbar: UIToolbar
{
	/**
	 *  The object that acts as the delegate of the toolbar.
	 */
//	weak var mitDelegate: CSMessagesInputToolbarDelegate!
//	{
//		get { return self.delegate as! CSMessagesInputToolbarDelegate }
//		set { self.delegate = newValue }
//	}

	/**
	 *  Returns the content view of the toolbar. This view contains all subviews of the toolbar.
	 */
	public weak var contentView: CSMessagesToolbarContentView!

	/**
	 *  A boolean value indicating whether the send button is on the right side of the toolbar or not.
	 *
	 *  @discussion The default value is `true`, which indicates that the send button is the right-most subview of the toolbar's `contentView`. Set to `false` to specify that the send button is on the left. This property is used to determine which touch events correspond to which actions.
	 *
	 *  @warning Note, this property *does not* change the positions of buttons in the toolbar's content view.
	 *  It only specifies whether the `rightBarButtonItem `or the `leftBarButtonItem` is the send button.
	 *  The other button then acts as the accessory button.
	 */
	public var isSendButtonOnRight = false

	public var cs_isObserving = false

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization

	override public func awakeFromNib()
	{
		super.awakeFromNib()

		// Initialization code
		self.translatesAutoresizingMaskIntoConstraints = false

		self.cs_isObserving = false
		self.isSendButtonOnRight = true

		let nibViews: Array! = Bundle.cs_messagesBundle().loadNibNamed(String(describing: CSMessagesToolbarContentView.self), owner: nil, options: nil)
		let toolbarContentView: CSMessagesToolbarContentView = nibViews.first as! CSMessagesToolbarContentView
		toolbarContentView.frame = self.frame
		self.addSubview(toolbarContentView)
		self.cs_pinAllEdgesOfSubview(toolbarContentView)
		self.setNeedsUpdateConstraints()
		self.contentView = toolbarContentView

		self.contentView.leftBarButtonItem = CSMessagesToolbarButtonFactory.defaultAccessoryButtonItem()
		self.contentView.rightBarButtonItem = CSMessagesToolbarButtonFactory.defaultSendButtonItem()

		self.cs_addObservers()
		self.toggleSendButtonEnabled()
	}

	deinit
	{
		self.cs_removeObservers()
		self.contentView = nil
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Actions

	public func cs_leftBarButtonPressed(_ sender: UIButton)
	{
		(self.delegate as! CSMessagesInputToolbarDelegate).messagesInputToolbar(self, didPressLeftBarButton: sender)
	}

	public func cs_rightBarButtonPressed(_ sender: UIButton)
	{
		(self.delegate as! CSMessagesInputToolbarDelegate).messagesInputToolbar(self, didPressRightBarButton: sender)
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Actions

	/**
	 *  Enables or disables the send button based on whether or not its `textView` has text.
	 *  That is, the send button will be enabled if there is text in the `textView`, and disabled otherwise.
	 */
	public func toggleSendButtonEnabled()
	{
		let hasText: Bool = self.contentView.textView.hasText

		if self.isSendButtonOnRight
		{
			self.contentView.rightBarButtonItem.isEnabled = hasText
		}
		else
		{
			self.contentView.leftBarButtonItem.isEnabled = hasText
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Key-value observing

	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
	{
		if (context == &kCSMessagesInputToolbarKeyValueObservingContext)
		{
			if ((object as! CSMessagesToolbarContentView) == self.contentView)
			{
				if (keyPath == NSStringFromSelector(#selector(getter: self.contentView.leftBarButtonItem)))
				{
					if self.contentView.leftBarButtonItem != nil
					{
						self.contentView.leftBarButtonItem.removeTarget(self, action: nil, for: UIControlEvents.touchUpInside)
						self.contentView.leftBarButtonItem.addTarget(self, action: #selector(cs_leftBarButtonPressed(_:)), for: UIControlEvents.touchUpInside)
					}
				}
				else if (keyPath == NSStringFromSelector(#selector(getter: self.contentView.rightBarButtonItem)))
				{
					if self.contentView.rightBarButtonItem != nil
					{
						self.contentView.rightBarButtonItem.removeTarget(self, action: nil, for: UIControlEvents.touchUpInside)
						self.contentView.rightBarButtonItem.addTarget(self, action: #selector(cs_rightBarButtonPressed(_:)), for: UIControlEvents.touchUpInside)
					}
				}
			}
		}
	}

	private func cs_addObservers()
	{
		if self.cs_isObserving { return }

		self.contentView.addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: self.contentView.leftBarButtonItem)), options: [NSKeyValueObservingOptions.initial], context: &kCSMessagesInputToolbarKeyValueObservingContext)

		self.contentView.addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: self.contentView.rightBarButtonItem)), options: [NSKeyValueObservingOptions.initial], context: &kCSMessagesInputToolbarKeyValueObservingContext)

		self.cs_isObserving = true
	}

	private func cs_removeObservers()
	{
		if !self.cs_isObserving { return }

		self.contentView.removeObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: self.contentView.leftBarButtonItem)), context: &kCSMessagesInputToolbarKeyValueObservingContext)
		self.contentView.removeObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: self.contentView.rightBarButtonItem)), context: &kCSMessagesInputToolbarKeyValueObservingContext)

		self.cs_isObserving = false
	}

	//////////////////////////////////////////////////////////////////////////////
}
