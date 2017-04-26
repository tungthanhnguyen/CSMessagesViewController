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
//  Ideas for keyboard controller taken from Daniel Amitay
//  DAKeyboardControl
//  https://github.com/danielamitay/DAKeyboardControl
//
//
//  Converted to Swift by Tung Thanh Nguyen
//  Copyright © 2016 Tung Thanh Nguyen.
//  Released under an MIT license: http://opensource.org/licenses/MIT
//
//  GitHub
//  https://github.com/tungthanhnguyen/CSMessagesViewController
//

import CoreGraphics
import Foundation
import UIKit

/**
 *  Posted when the system keyboard frame changes.
 *  The object of the notification is the `CSMessagesKeyboardController` object.
 *  The `userInfo` dictionary contains the new keyboard frame for key `CSMessagesKeyboardControllerUserInfoKeyKeyboardDidChangeFrame`.
 */
public let CSMessagesKeyboardControllerNotificationKeyboardDidChangeFrame: String = "CSMessagesKeyboardControllerNotificationKeyboardDidChangeFrame"

/**
 *  Contains the new keyboard frame wrapped in an `NSValue` object.
 */
public let CSMessagesKeyboardControllerUserInfoKeyKeyboardDidChangeFrame: String = "CSMessagesKeyboardControllerUserInfoKeyKeyboardDidChangeFrame"

public var kCSMessagesKeyboardControllerKeyValueObservingContext = 0

typealias CSAnimationCompletionBlock = (_ finished: Bool) -> Void


/**
 *  The `CSMessagesKeyboardControllerDelegate` protocol defines methods that allow you to respond to the frame change events of the system keyboard.
 *
 *  A `CSMessagesKeyboardController` object also posts the `CSMessagesKeyboardControllerNotificationKeyboardDidChangeFrame` in response to frame change events of the system keyboard.
 */
public protocol CSMessagesKeyboardControllerDelegate: NSObjectProtocol
{
	/**
	 *  Tells the delegate that the keyboard frame has changed.
	 *
	 *  @param keyboardFrame The new frame of the keyboard in the coordinate system of the `contextView`.
	 */
	func keyboardDidChangeFrame(_ keyboardFrame: CGRect)

}

public class CSMessagesKeyboardController: NSObject, UIGestureRecognizerDelegate
{
	public var cs_isObserving: Bool?

	private weak var priKeyboardView: UIView!
	public weak var keyboardView: UIView!
	{
		get { return self.priKeyboardView }
		set
		{
			if (self.priKeyboardView != nil)
			{
				cs_removeKeyboardFrameObserver()
			}

			self.priKeyboardView = newValue;

			if (newValue != nil && !self.cs_isObserving!)
			{
				self.priKeyboardView.addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: UIView.frame)), options: [NSKeyValueObservingOptions.old, NSKeyValueObservingOptions.new], context: &kCSMessagesKeyboardControllerKeyValueObservingContext)
				
				self.cs_isObserving = true
			}
		}
	}
	
	/**
	 *  The object that acts as the delegate of the keyboard controller.
	 */
	public weak var delegate: CSMessagesKeyboardControllerDelegate?
	
	/**
	 *  The text view in which the user is editing with the system keyboard.
	 */
	public weak var textView: CSMessagesComposerTextView!
	
	/**
	 *  The view in which the keyboard will be shown. This should be the parent or a sibling of `textView`.
	 */
	public weak var contextView: UIView!
	
	/**
	 *  The pan gesture recognizer responsible for handling user interaction with the system keyboard.
	 */
	public weak var panGestureRecognizer: UIPanGestureRecognizer!
	
	/**
	 *  Specifies the distance from the keyboard at which the `panGestureRecognizer` should trigger user interaction with the keyboard by panning.
	 *
	 *  @discussion The x value of the point is not used.
	 */
	var keyboardTriggerPoint = CGPoint.zero
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization

	override init()
	{
		super.init()

		self.textView = nil
		self.contextView = nil
		self.panGestureRecognizer = nil
		self.delegate = nil
		self.keyboardView = nil
	}
	
	/**
	 *  Creates a new keyboard controller object with the specified textView, contextView, panGestureRecognizer, and delegate.
	 *
	 *  @param textView              The text view in which the user is editing with the system keyboard. This value must not be `nil`.
	 *  @param contextView           The view in which the keyboard will be shown. This should be the parent or a sibling of `textView`. This value must not be `nil`.
	 *  @param panGestureRecognizer  The pan gesture recognizer responsible for handling user interaction with the system keyboard. This value must not be `nil`.
	 *  @param delegate              The object that acts as the delegate of the keyboard controller.
	 *
	 *  @return An initialized `CSMessagesKeyboardController` if created successfully, `nil` otherwise.
	 */
	convenience public init(withTextView textView: CSMessagesComposerTextView?, contextView: UIView?, panGestureRecognizer: UIPanGestureRecognizer?, delegate: CSMessagesKeyboardControllerDelegate?)
	{
		assert(textView != nil)
		assert(contextView != nil)
		assert(panGestureRecognizer != nil)

		self.init()
		
		self.textView = textView
		self.contextView = contextView
		self.panGestureRecognizer = panGestureRecognizer
		self.delegate = delegate
		self.cs_isObserving = false
	}
	
	deinit
	{
		cs_removeKeyboardFrameObserver()
		cs_unregisterForNotifications()
		
		self.textView = nil
		self.contextView = nil
		self.panGestureRecognizer = nil
		self.delegate = nil
		self.keyboardView = nil
	}
	
	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Keyboard controller

	/**
	 *  Tells the keyboard controller that it should begin listening for system keyboard notifications.
	 */
	func beginListeningForKeyboard()
	{
		self.textView.inputAccessoryView = UIView()
		self.cs_registerForNotifications()
	}

	/**
	 *  Tells the keyboard controller that it should end listening for system keyboard notifications.
	 */
	func endListeningForKeyboard()
	{
		self.textView.inputAccessoryView = nil

		self.cs_unregisterForNotifications()

		self.cs_setKeyboardViewHidden(false)
		self.keyboardView = nil
	}

	//////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Notifications
	
	private func cs_registerForNotifications()
	{
		cs_unregisterForNotifications()
		
		NotificationCenter.default.addObserver(self, selector: #selector(cs_didReceiveKeyboardDidShowNotification(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(cs_didReceiveKeyboardWillChangeFrameNotification(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(cs_didReceiveKeyboardDidChangeFrameNotification(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(cs_didReceiveKeyboardDidHideNotification(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
	}
	
	private func cs_unregisterForNotifications()
	{
		NotificationCenter.default.removeObserver(self)
	}
	
	internal func cs_didReceiveKeyboardDidShowNotification(_ notification: Notification)
	{
		self.keyboardView = self.textView?.inputAccessoryView?.superview
		cs_setKeyboardViewHidden(false)
		
		cs_handleKeyboardNotification(notification,
			completion:
			{
				CSAnimationCompletionBlock in
				
				self.panGestureRecognizer?.addTarget(self, action: #selector(self.cs_handlePanGestureRecognizer(_:)))
			}
		)
	}
	
	internal func cs_didReceiveKeyboardWillChangeFrameNotification(_ notification: Notification)
	{
		cs_handleKeyboardNotification(notification, completion: nil)
	}
	
	internal func cs_didReceiveKeyboardDidChangeFrameNotification(_ notification: Notification)
	{
		cs_setKeyboardViewHidden(false)
	
		cs_handleKeyboardNotification(notification, completion: nil)
	}
	
	internal func cs_didReceiveKeyboardDidHideNotification(_ notification: Notification)
	{
		self.keyboardView = nil
		
		cs_handleKeyboardNotification(notification,
			completion:
			{
				//CSAnimationCompletionBlock in
				finished in
				
				self.panGestureRecognizer?.removeTarget(self, action: nil)
			}
		)
	}
	
	private func cs_handleKeyboardNotification(_ notification: Notification, completion: CSAnimationCompletionBlock?)
	{
		let userInfo: Dictionary<String, Any> = notification.userInfo as! Dictionary<String, Any>

		let keyboardEndFrame: CGRect = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect

		if keyboardEndFrame.isNull { return }

		let animationCurve: UIViewAnimationCurve = UIViewAnimationCurve(rawValue: userInfo[UIKeyboardAnimationCurveUserInfoKey] as! Int)!
		let animationCurveOption: Int = (animationCurve.rawValue << 16)

		let aimationDuration: Double = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double

		let keyboardEndFrameConverted: CGRect = self.contextView!.convert(keyboardEndFrame, from: nil)

		UIView.animate(withDuration: aimationDuration, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(animationCurveOption)),
			animations:
			{
				self.delegate?.keyboardDidChangeFrame(keyboardEndFrameConverted)
				self.cs_postKeyboardFrameNotificationForFrame(keyboardEndFrameConverted)
			},
			completion:
			{
				finished in
				
				if (completion != nil)
				{
					completion!(finished)
				}
			}
		)
	}
	
	//////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Utilities
	
	private func cs_setKeyboardViewHidden(_ hidden: Bool)
	{
		self.keyboardView?.isHidden = hidden
		self.keyboardView?.isUserInteractionEnabled = !hidden
	}
	
	private func cs_postKeyboardFrameNotificationForFrame(_ frame: CGRect)
	{
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: CSMessagesKeyboardControllerNotificationKeyboardDidChangeFrame), object: self, userInfo: [CSMessagesKeyboardControllerUserInfoKeyKeyboardDidChangeFrame: NSValue(cgRect: frame)])
	}
	
	//////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Key-value observing

	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
	{
		if (context == &kCSMessagesKeyboardControllerKeyValueObservingContext)
		{
			if (((object as! UIView) == self.keyboardView) && (keyPath == NSStringFromSelector(#selector(getter: UIView.frame))))
			{
				let oldKeyboardFrame = change?[NSKeyValueChangeKey.oldKey] as! CGRect
				let newKeyboardFrame = change?[NSKeyValueChangeKey.newKey] as! CGRect

				if (newKeyboardFrame.equalTo(oldKeyboardFrame) || newKeyboardFrame.isNull)
				{
					return
				}

				//  do not convert frame to contextView coordinates here
				//  KVO is triggered during panning (see below)
				//  panning occurs in contextView coordinates already
				self.delegate?.keyboardDidChangeFrame(newKeyboardFrame)
				self.cs_postKeyboardFrameNotificationForFrame(newKeyboardFrame)
			}
		}
	}

	private func cs_removeKeyboardFrameObserver()
	{
		if (!cs_isObserving!) { return }
		
		keyboardView?.removeObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: UIView.frame)), context: &kCSMessagesKeyboardControllerKeyValueObservingContext)
		
		cs_isObserving = false
	}
	
	//////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Pan gesture recognizer
	
	internal func cs_handlePanGestureRecognizer(_ pan: UIPanGestureRecognizer)
	{
		let touch: CGPoint = pan.location(in: self.contextView)
		
		//  system keyboard is added to a new UIWindow, need to operate in window coordinates
		//  also, keyboard always slides from bottom of screen, not the bottom of a view
		var contextViewWindowHeight: CGFloat = (self.contextView?.window?.frame.height)!
		if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
		{
			contextViewWindowHeight = (self.contextView?.window?.frame.width)!
		}
		
		let keyboardViewHeight: CGFloat = (self.keyboardView?.frame.height)!

		let dragThresholdY: CGFloat = (contextViewWindowHeight - keyboardViewHeight - self.keyboardTriggerPoint.y)

		var newKeyboardViewFrame: CGRect = (self.keyboardView?.frame)!

		let userIsDraggingNearThresholdForDismissing: Bool = (touch.y > dragThresholdY)

		self.keyboardView?.isUserInteractionEnabled = !userIsDraggingNearThresholdForDismissing
		
		switch pan.state
		{
		case UIGestureRecognizerState.changed:
			newKeyboardViewFrame.origin.y = touch.y + self.keyboardTriggerPoint.y

			//  bound frame between bottom of view and height of keyboard
			newKeyboardViewFrame.origin.y = min(newKeyboardViewFrame.origin.y, contextViewWindowHeight)
			newKeyboardViewFrame.origin.y = max(newKeyboardViewFrame.origin.y, contextViewWindowHeight - keyboardViewHeight)

			if (newKeyboardViewFrame.minY == self.keyboardView?.frame.minY)
			{
				return
			}
			
			UIView.animate(withDuration: 0.0, delay: 0.0,
				options: [UIViewAnimationOptions.beginFromCurrentState],
				animations:
				{
					self.keyboardView?.frame = newKeyboardViewFrame
				},
				completion: nil)
			
		case UIGestureRecognizerState.ended,
		     UIGestureRecognizerState.cancelled,
		     UIGestureRecognizerState.failed:
			let keyboardViewIsHidden: Bool = (self.keyboardView!.frame.minY >= contextViewWindowHeight)
			if (keyboardViewIsHidden) { return }

			let velocity: CGPoint = pan.velocity(in: self.contextView)
			let userIsScrollingDown: Bool = (velocity.y > 0.0)
			let shouldHide: Bool = (userIsScrollingDown && userIsDraggingNearThresholdForDismissing)

			newKeyboardViewFrame.origin.y = shouldHide ? contextViewWindowHeight : (contextViewWindowHeight - keyboardViewHeight)

			UIView.animate(withDuration: 0.25, delay: 0.0,
				options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut],
				animations:
				{
					self.keyboardView?.frame = newKeyboardViewFrame
				},
				completion:
				{
					finished in
					
					self.keyboardView?.isUserInteractionEnabled = !shouldHide
					
					if shouldHide
					{
						self.cs_setKeyboardViewHidden(true)
						self.cs_removeKeyboardFrameObserver()
						self.textView?.resignFirstResponder()
					}
				}
			)

		default:
			break
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////
}
