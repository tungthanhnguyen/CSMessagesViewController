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

public var kCSMessagesKeyValueObservingContext = 0

/**
 *  The `CSMessagesViewController` class is an abstract class that represents a view controller whose content consists of a `CSMessagesCollectionView` and `CSMessagesInputToolbar` and is specialized to display a messaging interface.
 *
 *  @warning This class is intended to be subclassed. You should not use it directly.
 */
open class CSMessagesViewController: UIViewController
{
	/**
	 *  Returns the collection view object managed by this view controller.
	 *  This view controller is the collection view's data source and delegate.
	 */
	@IBOutlet public weak var collectionView: CSMessagesCollectionView!

	/**
	 *  Returns the input toolbar view object managed by this view controller.
	 *  This view controller is the toolbar's delegate.
	 */
	@IBOutlet public weak var inputToolbar: CSMessagesInputToolbar!

	@IBOutlet weak var toolbarHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var toolbarBottomLayoutGuide: NSLayoutConstraint!

	weak var snapshotView: UIView!

	var keyboardController: CSMessagesKeyboardController!

	var statusBarChangeInHeight: CGFloat = 0.0

	var cs_isObserving = false

	/**
	 *  The name of the user sending messages. This value must not be `nil`.
	 *  The default value is `"CSDefaultSender"`.
	 */
	private var priSender: String?
	public var sender: String?
	{
		get { return self.priSender }
		set
		{
			if (newValue == nil || newValue == self.priSender) { return }

			self.priSender = newValue
		}
	}

	/**
	 *  Specifies whether or not the view controller should automatically scroll to the most recent message when the view appears and when sending, receiving, and composing a new message.
	 *
	 *  @discussion The default value is `true`, which allows the view controller to scroll automatically to the most recent message.
	 *  Set to `false` if you want to manage scrolling yourself.
	 */
	var isAutomaticallyScrollsToMostRecentMessage = false

	/**
	 *  The collection view cell identifier to use for dequeuing outgoing message collection view cells in the collectionView.
	 *
	 *  @discussion The default value is the string returned by `[CSMessagesCollectionViewCellOutgoing cellReuseIdentifier]`.
	 *  This value must not be `nil`.
	 *
	 *  @see `CSMessagesCollectionViewCellOutgoing`.
	 *
	 *  @warning Overriding this property's default value is *not* recommended.
	 *  You should only override this property's default value if you are proividing your own cell prototypes.
	 *  These prototypes must be registered with the collectionView for reuse and you are then responsible for
	 *  completely overriding many delegate and data source methods for the collectionView,
	 *  including `collectionView:cellForItemAtIndexPath:`.
	 */
	public var outgoingCellIdentifier: String!

	/**
	 *  The collection view cell identifier to use for dequeuing incoming message collection view cells in the collectionView.
	 *
	 *  @discussion The default value is the string returned by `[CSMessagesCollectionViewCellIncoming cellReuseIdentifier]`.
	 *  This value must not be `nil`.
	 *
	 *  @see `CSMessagesCollectionViewCellIncoming`.
	 *
	 *  @warning Overriding this property's default value is *not* recommended.
	 *  You should only override this property's default value if you are proividing your own cell prototypes.
	 *  These prototypes must be registered with the collectionView for reuse and you are then responsible for
	 *  completely overriding many delegate and data source methods for the collectionView,
	 *  including `collectionView:cellForItemAtIndexPath:`.
	 */
	public var incomingCellIdentifier: String!

	/**
	 *  The color for the typing indicator for incoming messages.
	 *
	 *  @discussion The color specified is used for the typing indicator bubble image color.
	 *  This color is then slightly darkened and used to color the typing indicator ellipsis.
	 *  The default value is the light gray color value return by `[UIColor cs_messageBubbleLightGrayColor]`.
	 */
	public var typingIndicatorColor: UIColor!

	/**
	 *  Specifies whether or not the view controller should show the typing indicator for an incoming message.
	 *
	 *  @discussion Setting this property to `true` will animate showing the typing indicator immediately.
	 *  Setting this property to `false` will animate hiding the typing indicator immediately. You will need to scroll
	 *  to the bottom of the collection view in order to see the typing indicator. You may use `scrollToBottomAnimated:` for this.
	 */
	private var priIsShowTypingIndicator: Bool = false
	public var isShowTypingIndicator: Bool
	{
		get { return self.priIsShowTypingIndicator }
		set
		{
			if (self.priIsShowTypingIndicator == newValue) { return }

			self.priIsShowTypingIndicator = newValue
			self.collectionView.collectionViewLayout.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
			self.collectionView.collectionViewLayout.invalidateLayout()
		}
	}

	/**
	 *  Specifies whether or not the view controller should show the "load earlier messages" header view.
	 *
	 *  @discussion Setting this property to `true` will show the header view immediately.
	 *  Settings this property to `false` will hide the header view immediately. You will need to scroll to the top of the collection view in order to see the header.
	 */
	private var priIsShowLoadEarlierMessagesHeader: Bool = false
	public var isShowLoadEarlierMessagesHeader: Bool
	{
		get { return self.priIsShowLoadEarlierMessagesHeader }
		set
		{
			if (self.priIsShowLoadEarlierMessagesHeader == newValue) { return }

			self.priIsShowLoadEarlierMessagesHeader = newValue
			self.collectionView.collectionViewLayout.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
			self.collectionView.collectionViewLayout.invalidateLayout()
			self.collectionView.reloadData()
		}
	}

	/**
	 *  Specifies an additional inset amount to be added to the collectionView's contentInsets.top value.
	 *
	 *  @discussion Use this property to adjust the top content inset to account for a custom subview at the top of your view controller.
	 */
	var topContentAdditionalInset: CGFloat = 0.0

	/**
	 *  For spacing between the cells.
	 */
	fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: 0.0)

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Class methods

	/**
	 *  Returns the `UINib` object initialized for `CSMessagesViewController`.
	 *
	 *  @return The initialized `UINib` object or `nil` if there were errors during initialization or the nib file could not be located.
	 */
	public class func nib() -> UINib
	{
		return UINib(nibName: String(describing: CSMessagesViewController.self), bundle: Bundle.cs_messagesBundle())
	}

	/**
	 *  Creates and returns a new `CSMessagesViewController` object.
	 *
	 *  @discussion This is the designated initializer for programmatic instantiation.
	 *
	 *  @return The initialized messages view controller if successful, otherwise `nil`.
	 */
	public static let messagesViewController = CSMessagesViewController()

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization

	public convenience init()
	{
		self.init(nibName: String(describing: CSMessagesViewController.self), bundle: Bundle.cs_messagesBundle())
	}

	override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
	{
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required public init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}

	func cs_configureMessagesViewController()
	{
		self.view.backgroundColor = UIColor.white

		self.cs_isObserving = false;

		self.toolbarHeightConstraint.constant = kCSMessagesInputToolbarHeightDefault

		self.collectionView.dataSource = self
		self.collectionView.delegate = self

		self.inputToolbar.delegate = self
		self.inputToolbar.contentView.textView.placeHolder = NSLocalizedString("New Message", comment: "Placeholder text for the message input text view") as NSString!
		self.inputToolbar.contentView.textView.delegate = self

		if (self.sender == nil || (self.sender?.isEmpty)!)
		{
			self.sender = "CSDefaultSender"
		}

		self.isAutomaticallyScrollsToMostRecentMessage = true

		self.outgoingCellIdentifier = CSMessagesCollectionViewCellOutgoing.cellReuseIdentifier()
		self.incomingCellIdentifier = CSMessagesCollectionViewCellIncoming.cellReuseIdentifier()

		self.typingIndicatorColor = UIColor.cs_messageBubbleLightGrayColor()
		self.isShowTypingIndicator = false;

		self.isShowLoadEarlierMessagesHeader = false

		self.topContentAdditionalInset = 0.0

		self.cs_updateCollectionViewInsets()

		self.keyboardController = CSMessagesKeyboardController(withTextView: self.inputToolbar.contentView.textView, contextView: self.view, panGestureRecognizer: self.collectionView.panGestureRecognizer, delegate: self)

		NotificationCenter.default.addObserver(self, selector: #selector(self.cs_keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
	}

	deinit
	{
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)

		self.cs_registerForNotifications(false)
		self.cs_removeObservers()

		self.collectionView.dataSource = nil
		self.collectionView.delegate = nil
		self.collectionView = nil
		self.inputToolbar = nil

		self.toolbarHeightConstraint = nil
		self.toolbarBottomLayoutGuide = nil

		self.sender = nil
		self.outgoingCellIdentifier = nil
		self.incomingCellIdentifier = nil

		self.keyboardController.endListeningForKeyboard()
		self.keyboardController = nil
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - View lifecycle

	override open func viewDidLoad()
	{
		super.viewDidLoad()

		Bundle.cs_messagesBundle().loadNibNamed(String(describing: CSMessagesViewController.self), owner: self, options: nil)

		self.cs_configureMessagesViewController()
		self.cs_registerForNotifications(true)
	}

	override open func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)

		self.view.layoutIfNeeded()

		self.collectionView.collectionViewLayout.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())

		if self.isAutomaticallyScrollsToMostRecentMessage
		{
			let deadline: DispatchTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(1000)
			DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async
			{
				//DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
				DispatchQueue.main.asyncAfter(deadline: deadline,
					execute:
					{
						() -> Void in

						self.scrollToBottomAnimated(true)
					}
				)
			}
		}

		self.cs_updateKeyboardTriggerPoint()
	}

	override open func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)

		self.cs_addObservers()
		self.cs_addActionToInteractivePopGestureRecognizer(true)
		self.keyboardController.beginListeningForKeyboard()

		if (self.snapshotView != nil)
		{
			self.snapshotView.removeFromSuperview()
		}
	}

	override open func viewWillDisappear(_ animated: Bool)
	{
		super.viewWillDisappear(animated)

		self.cs_addActionToInteractivePopGestureRecognizer(false)
		(self.collectionView.collectionViewLayout as! CSMessagesCollectionViewFlowLayout).isSpringinessEnabled = false
	}

	override open func viewDidDisappear(_ animated: Bool)
	{
		super.viewDidDisappear(animated)

		self.cs_removeObservers()
		self.keyboardController.endListeningForKeyboard()
	}

	override open func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		NSLog("MEMORY WARNING: File: %@ | Line: %@ | Column: %@ | Function %@", #file, #line, #column, #function)
	}

//	open override func viewWillLayoutSubviews()
//	{
//		self.collectionView.collectionViewLayout.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
//		self.collectionView.collectionViewLayout.invalidateLayout()
//		self.collectionView.reloadData()
//
//		if self.isAutomaticallyScrollsToMostRecentMessage
//		{
//			self.scrollToBottomAnimated(true)
//		}
//	}

//	open override func viewDidLayoutSubviews()
//	{
//		self.collectionView.collectionViewLayout.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
//		self.collectionView.collectionViewLayout.invalidateLayout()
//		self.collectionView.reloadData()
//
//		if self.isAutomaticallyScrollsToMostRecentMessage
//		{
//			self.scrollToBottomAnimated(true)
//		}
//	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - View rotation

	override open var shouldAutorotate: Bool { return true }

	override open var supportedInterfaceOrientations: UIInterfaceOrientationMask
	{
		get
		{
			if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone)
			{
				return UIInterfaceOrientationMask.allButUpsideDown
			}

			return UIInterfaceOrientationMask.all
		}
	}

//	override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
//	{
//		super.viewWillTransition(to: size, with: coordinator)
//		self.collectionView.collectionViewLayout.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
//	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Messages view controller

	open func didPressSendButton(_ button: UIButton, withMessageText text: String, sender: String, date: Date) {}

	open func didPressAccessoryButton(sender: UIButton) {}

	public func finishSendingMessage()
	{
		let textView: UITextView = self.inputToolbar.contentView.textView
		textView.text = nil

		self.inputToolbar.toggleSendButtonEnabled()

		NotificationCenter.default.post(name: NSNotification.Name.UITextViewTextDidChange, object: textView)

		self.collectionView.collectionViewLayout.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
		self.collectionView.reloadData()

		if self.isAutomaticallyScrollsToMostRecentMessage
		{
			self.scrollToBottomAnimated(true)
		}
	}

	public func finishReceivingMessage()
	{
		self.isShowTypingIndicator = false

		self.collectionView.collectionViewLayout.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
		self.collectionView.reloadData()

		if self.isAutomaticallyScrollsToMostRecentMessage
		{
			self.scrollToBottomAnimated(true)
		}
	}

	public func scrollToBottomAnimated(_ animated: Bool)
	{
		if (self.collectionView.numberOfSections == 0) { return }

		let items: Int = self.collectionView.numberOfItems(inSection: 0)

		if (items > 0)
		{
			self.collectionView.scrollToItem(at: IndexPath(item: items - 1, section: 0), at: UICollectionViewScrollPosition.top, animated: animated)
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - CSMessages collection view data source

	open func collectionView(_ collectionView: CSMessagesCollectionView, messageDataForItemAtIndexPath indexPath: IndexPath) -> CSMessageData?
	{
		assert(false, "ERROR: required method not implemented: %@", file: #function)
		return nil
	}

	open func collectionView(_ collectionView: CSMessagesCollectionView, bubbleImageViewForItemAtIndexPath indexPath: IndexPath) -> UIImageView?
	{
		assert(false, "ERROR: required method not implemented: %@", file: #function)
		return nil
	}

	open func collectionView(_ collectionView: CSMessagesCollectionView, avatarImageViewForItemAtIndexPath indexPath: IndexPath) -> UIImageView?
	{
		assert(false, "ERROR: required method not implemented: %@", file: #function)
		return nil
	}

	open func collectionView(_ collectionView: CSMessagesCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: IndexPath) -> NSAttributedString?
	{
		return nil
	}

	open func collectionView(_ collectionView: CSMessagesCollectionView, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: IndexPath) -> NSAttributedString?
	{
		return nil
	}

	open func collectionView(_ collectionView: CSMessagesCollectionView, attributedTextForCellBottomLabelAtIndexPath indexPath: IndexPath) -> NSAttributedString?
	{
		return nil
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Collection view delegate

	public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool
	{
		return false
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Notifications

	internal func cs_handleDidChangeStatusBarFrameNotification(_ notification: Notification)
	{
		if (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation))
		{
			self.statusBarChangeInHeight = 0.0
		}
		else
		{
			let previousStatusBarFrame: CGRect = (((notification.userInfo! as NSDictionary).object(forKey: UIApplicationStatusBarFrameUserInfoKey)) as AnyObject).cgRectValue
			let currentStatusBarFrame: CGRect = UIApplication.shared.statusBarFrame
			let statusBarHeightDelta: CGFloat = currentStatusBarFrame.height - previousStatusBarFrame.height
			self.statusBarChangeInHeight = max(statusBarHeightDelta, 0.0)
		}
	}

	internal func cs_keyboardDidShow(_ notification: NSNotification)
	{
		DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async
		{
			DispatchQueue.main.async(
				execute:
				{
					() -> Void in

					if self.isAutomaticallyScrollsToMostRecentMessage
					{
						self.scrollToBottomAnimated(true)
					}
				}
			)
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Key-value observing

	override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
	{
		if (context == &kCSMessagesKeyValueObservingContext)
		{
			if ((object as! CSMessagesComposerTextView) == self.inputToolbar.contentView.textView && keyPath == NSStringFromSelector(#selector(getter: UIScrollView.contentSize)))
			{
				let oldContentSize: CGSize = ((change! as NSDictionary).object(forKey: NSKeyValueChangeKey.oldKey) as AnyObject).cgSizeValue
				let newContentSize: CGSize = ((change! as NSDictionary).object(forKey: NSKeyValueChangeKey.newKey) as AnyObject).cgSizeValue

				let dy: CGFloat = newContentSize.height - oldContentSize.height

				self.cs_adjustInputToolbarForComposerTextViewContentSizeChange(dy)
				self.cs_updateCollectionViewInsets()
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Gesture recognizers

	public func cs_handleInteractivePopGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer)
	{
		switch gestureRecognizer.state
		{
		case UIGestureRecognizerState.began:
			if (self.snapshotView != nil)
			{
				self.snapshotView.removeFromSuperview()
			}

			self.keyboardController.endListeningForKeyboard()
			self.inputToolbar.contentView.textView.resignFirstResponder()
			UIView.animate(withDuration: 0.0,
				animations:
				{
					self.cs_setToolbarBottomLayoutGuideConstant(0.0)
				}
			)

			let snapshot: UIView = self.view.snapshotView(afterScreenUpdates: true)!
			self.view.addSubview(snapshot)
			self.snapshotView = snapshot

		case UIGestureRecognizerState.changed:
			break

		case UIGestureRecognizerState.cancelled,
		     UIGestureRecognizerState.ended,
		     UIGestureRecognizerState.failed:
			self.keyboardController.beginListeningForKeyboard()
			self.snapshotView.removeFromSuperview()

		default:
			break
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Input toolbar utilities

	private func cs_inputToolbarHasReachedMaximumHeight() -> Bool
	{
		return (self.inputToolbar.frame.minY == self.topLayoutGuide.length)
	}

	private func cs_adjustInputToolbarForComposerTextViewContentSizeChange(_ dy: CGFloat)
	{
		var fDy: CGFloat = dy

		let contentSizeIsIncreasing: Bool = (fDy > 0)

		if (self.cs_inputToolbarHasReachedMaximumHeight())
		{
			let contentOffsetIsPositive: Bool = (self.inputToolbar.contentView.textView.contentOffset.y > 0)

			if (contentSizeIsIncreasing || contentOffsetIsPositive)
			{
				self.cs_scrollComposerTextViewToBottomAnimated(true)
				return
			}
		}

		let toolbarOriginY: CGFloat = self.inputToolbar.frame.minY
		let newToolbarOriginY: CGFloat = toolbarOriginY - fDy

		//  attempted to increase origin.Y above topLayoutGuide
		if (newToolbarOriginY <= self.topLayoutGuide.length)
		{
			fDy = toolbarOriginY - self.topLayoutGuide.length
			self.cs_scrollComposerTextViewToBottomAnimated(true)
		}

		self.cs_adjustInputToolbarHeightConstraintByDelta(fDy)

		self.cs_updateKeyboardTriggerPoint()

		if (fDy < 0)
		{
			self.cs_scrollComposerTextViewToBottomAnimated(false)
		}
	}

	private func cs_adjustInputToolbarHeightConstraintByDelta(_ dy: CGFloat)
	{
		self.toolbarHeightConstraint.constant += dy

		if (self.toolbarHeightConstraint.constant < kCSMessagesInputToolbarHeightDefault)
		{
			self.toolbarHeightConstraint.constant = kCSMessagesInputToolbarHeightDefault
		}

		self.view.setNeedsUpdateConstraints()
		self.view.layoutIfNeeded()
	}

	private func cs_scrollComposerTextViewToBottomAnimated(_ animated: Bool)
	{
		let textView: UITextView = self.inputToolbar.contentView.textView
		let contentOffsetToShowLastLine: CGPoint = CGPoint(x: 0.0, y: textView.contentSize.height - textView.bounds.height)

		if !animated
		{
			textView.contentOffset = contentOffsetToShowLastLine
			return
		}

		UIView.animate(withDuration: 0.01, delay: 0.01, options: UIViewAnimationOptions.curveLinear,
			animations:
			{
				textView.contentOffset = contentOffsetToShowLastLine
			},
			completion: nil)
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Collection view utilities

	internal func cs_updateCollectionViewInsets()
	{
		self.cs_setCollectionViewInsetsTopValue(top: self.topLayoutGuide.length + self.topContentAdditionalInset, bottomValue: self.collectionView.frame.height - self.inputToolbar.frame.minY)
	}

	private func cs_setCollectionViewInsetsTopValue(top: CGFloat, bottomValue bottom: CGFloat)
	{
		let insets: UIEdgeInsets = UIEdgeInsets(top: top, left: 0.0, bottom: bottom, right: 0.0)
		self.collectionView.contentInset = insets
		self.collectionView.scrollIndicatorInsets = insets
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Utilities

	private func cs_addObservers()
	{
		if self.cs_isObserving { return }

		self.inputToolbar.contentView.textView.addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: UIScrollView.contentSize)), options: [NSKeyValueObservingOptions.old, NSKeyValueObservingOptions.new], context: &kCSMessagesKeyValueObservingContext)

		self.cs_isObserving = true
	}

	private func cs_removeObservers()
	{
		if !self.cs_isObserving { return }

		self.inputToolbar.contentView.textView.removeObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: UIScrollView.contentSize)), context: &kCSMessagesKeyValueObservingContext)

		self.cs_isObserving = false
	}

	private func cs_registerForNotifications(_ registerForNotifications: Bool)
	{
		if registerForNotifications
		{
			NotificationCenter.default.addObserver(self, selector: #selector(self.cs_handleDidChangeStatusBarFrameNotification(_:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame, object: nil)
		}
		else
		{
			NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame, object: nil)
		}
	}

	private func cs_addActionToInteractivePopGestureRecognizer(_ addAction: Bool)
	{
		if (self.navigationController?.interactivePopGestureRecognizer != nil)
		{
			self.navigationController?.interactivePopGestureRecognizer?.removeTarget(nil, action: #selector(self.cs_handleInteractivePopGestureRecognizer(_:)))

			if addAction
			{
				self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(self.cs_handleInteractivePopGestureRecognizer(_:)))
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////
}

////////////////////////////////////////////////////////////////////////////////
// MARK: - Collection view delegate flow layout

extension CSMessagesViewController: CSMessagesCollectionViewDelegateFlowLayout
{
	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
	{
		let messageCollectionView = collectionView as! CSMessagesCollectionView
		let messageCollectionViewLayout = collectionViewLayout as! CSMessagesCollectionViewFlowLayout

		let bubbleSize: CGSize = messageCollectionViewLayout.messageBubbleSizeForItemAt(indexPath)

		var cellHeight: CGFloat = bubbleSize.height
		cellHeight = cellHeight + self.collectionView(messageCollectionView, layout: messageCollectionViewLayout, heightForCellTopLabelAtIndexPath: indexPath)
		cellHeight = cellHeight + self.collectionView(messageCollectionView, layout: messageCollectionViewLayout, heightForMessageBubbleTopLabelAtIndexPath: indexPath)
		cellHeight = cellHeight + self.collectionView(messageCollectionView, layout: messageCollectionViewLayout, heightForCellBottomLabelAtIndexPath: indexPath)

		return CGSize(width: messageCollectionViewLayout.itemWidth, height: cellHeight)
	}

	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
	{
		return sectionInsets
	}

	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
	{
		return sectionInsets.top + sectionInsets.bottom
	}

	open func collectionView(_ collectionView: CSMessagesCollectionView, layout collectionViewLayout: CSMessagesCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: IndexPath) -> CGFloat
	{
		return 0.0
	}

	open func collectionView(_ collectionView: CSMessagesCollectionView, layout collectionViewLayout: CSMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAtIndexPath indexPath: IndexPath) -> CGFloat
	{
		return 0.0
	}

	open func collectionView(_ collectionView: CSMessagesCollectionView, layout collectionViewLayout: CSMessagesCollectionViewFlowLayout, heightForCellBottomLabelAtIndexPath indexPath: IndexPath) -> CGFloat
	{
		return 0.0
	}

	open func collectionView(_ collectionView: CSMessagesCollectionView, didTapAvatarImageView avatarImageView: UIImageView, atIndexPath indexPath: IndexPath) {}

	open func collectionView(_ collectionView: CSMessagesCollectionView, didTapMessageBubbleAtIndexPath indexPath: IndexPath) {}

	open func collectionView(_ collectionView: CSMessagesCollectionView, didTapCellAtIndexPath indexPath: IndexPath, touchLocation: CGPoint) {}

	open func collectionView(_ collectionView: CSMessagesCollectionView, header headerView: CSMessagesLoadEarlierHeaderView, didTapLoadEarlierMessagesButton sender: UIButton) {}
}

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// MARK: - Collection view data source

extension CSMessagesViewController: CSMessagesCollectionViewDataSource
{
	open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return 0
	}

	open func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}

	open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let messageCollectionView = collectionView as! CSMessagesCollectionView
		let messageCollectionViewDataSource = messageCollectionView.dataSource as! CSMessagesCollectionViewDataSource

		let messageData: CSMessageData? = messageCollectionViewDataSource.collectionView(messageCollectionView, messageDataForItemAtIndexPath: indexPath)
		assert(messageData != nil)

		let messageSender: String? = messageData?.sender
		assert(messageSender != nil)

		let isOutgoingMessage: Bool = (messageSender == self.sender)

		let cellIdentifier: String = isOutgoingMessage ? self.outgoingCellIdentifier : self.incomingCellIdentifier
		let cell: CSMessagesCollectionViewCell = messageCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CSMessagesCollectionViewCell
		cell.delegate = self

		let messageText: String? = messageData?.text as String?
		assert(messageText != nil)

		cell.textView.text = messageText
		cell.messageBubbleImageView = messageCollectionViewDataSource.collectionView(messageCollectionView, bubbleImageViewForItemAtIndexPath: indexPath)
		cell.avatarImageView = messageCollectionViewDataSource.collectionView(messageCollectionView, avatarImageViewForItemAtIndexPath: indexPath)
		cell.cellTopLabel.attributedText = messageCollectionViewDataSource.collectionView(messageCollectionView, attributedTextForCellTopLabelAtIndexPath: indexPath)
		cell.messageBubbleTopLabel.attributedText = messageCollectionViewDataSource.collectionView(messageCollectionView, attributedTextForMessageBubbleTopLabelAtIndexPath: indexPath)
		cell.cellBottomLabel.attributedText = messageCollectionViewDataSource.collectionView(messageCollectionView, attributedTextForCellBottomLabelAtIndexPath: indexPath)

		let messageCollectionViewFlowLayout = messageCollectionView.collectionViewLayout as! CSMessagesCollectionViewFlowLayout

		if isOutgoingMessage
		{
			cell.avatarImageView?.bounds = CGRect(x: CGFloat((cell.avatarImageView?.bounds.minX)!), y: CGFloat((cell.avatarImageView?.bounds.minY)!), width: CGFloat(messageCollectionViewFlowLayout.outgoingAvatarViewSize.width), height: CGFloat(messageCollectionViewFlowLayout.outgoingAvatarViewSize.height))
		}
		else
		{
			cell.avatarImageView?.bounds = CGRect(x: CGFloat((cell.avatarImageView?.bounds.minX)!), y: CGFloat((cell.avatarImageView?.bounds.minY)!), width: CGFloat(messageCollectionViewFlowLayout.incomingAvatarViewSize.width), height: CGFloat(messageCollectionViewFlowLayout.incomingAvatarViewSize.height))
		}

		cell.backgroundColor = UIColor.clear

		let bubbleTopLabelInset: CGFloat = 60.0

		if isOutgoingMessage
		{
			cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, bubbleTopLabelInset)
		}
		else
		{
			cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0, bubbleTopLabelInset, 0.0, 0.0)
		}

		cell.textView.dataDetectorTypes = UIDataDetectorTypes.all

		return cell
	}

	open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
	{
		let messageCollectionView = collectionView as! CSMessagesCollectionView

		if (self.isShowTypingIndicator && kind == UICollectionElementKindSectionFooter)
		{
			return messageCollectionView.dequeueTypingIndicatorFooterViewIncoming(true, withIndicatorColor: self.typingIndicatorColor.cs_colorByDarkeningColorWithValue(0.3), bubbleColor: self.typingIndicatorColor, forIndexPath: indexPath)
		}
		else if (self.isShowLoadEarlierMessagesHeader && kind == UICollectionElementKindSectionHeader)
		{
			return messageCollectionView.dequeueLoadEarlierMessagesViewHeaderForIndexPath(indexPath)
		}

		return UICollectionReusableView()
	}

	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
	{
		let messageCollectionViewLayout = collectionViewLayout as! CSMessagesCollectionViewFlowLayout

		if !self.isShowTypingIndicator { return CGSize.zero }

		return CGSize(width: messageCollectionViewLayout.itemWidth, height: kCSMessagesTypingIndicatorFooterViewHeight)
	}

	open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
	{
		let messageCollectionViewLayout = collectionViewLayout as! CSMessagesCollectionViewFlowLayout

		if !self.isShowLoadEarlierMessagesHeader { return CGSize.zero }

		return CGSize(width: messageCollectionViewLayout.itemWidth, height: kCSMessagesLoadEarlierHeaderViewHeight)
	}
}

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// MARK: - Input toolbar delegate

extension CSMessagesViewController: CSMessagesInputToolbarDelegate
{
	public func messagesInputToolbar(_ toolbar: CSMessagesInputToolbar, didPressLeftBarButton sender: UIButton)
	{
		if toolbar.isSendButtonOnRight
		{
			self.didPressAccessoryButton(sender: sender)
		}
		else
		{
			self.didPressSendButton(sender, withMessageText: self.cs_currentlyComposedMessageText(), sender: self.sender!, date: Date())
		}
	}

	public func messagesInputToolbar(_ toolbar: CSMessagesInputToolbar, didPressRightBarButton sender: UIButton)
	{
		if toolbar.isSendButtonOnRight
		{
			self.didPressSendButton(sender, withMessageText: self.cs_currentlyComposedMessageText(), sender: self.sender!, date: Date())
		}
		else
		{
			self.didPressAccessoryButton(sender: sender)
		}
	}

	private func cs_currentlyComposedMessageText() -> String
	{
		//  add a space to accept any auto-correct suggestions
		let text: String = self.inputToolbar.contentView.textView.text
		self.inputToolbar.contentView.textView.text = text.appending(" ")

		return self.inputToolbar.contentView.textView.text.cs_stringByTrimingWhitespace()
	}
}

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// MARK: - Keyboard controller delegate

extension CSMessagesViewController: CSMessagesKeyboardControllerDelegate
{
	public func keyboardDidChangeFrame(_ keyboardFrame: CGRect)
	{
		var heightFromBottom: CGFloat = self.collectionView.frame.height - keyboardFrame.minY

		heightFromBottom = max(0.0, heightFromBottom + self.statusBarChangeInHeight)

		self.cs_setToolbarBottomLayoutGuideConstant(heightFromBottom)
	}

	internal func cs_setToolbarBottomLayoutGuideConstant(_ constant: CGFloat)
	{
		self.toolbarBottomLayoutGuide.constant = constant
		self.view.setNeedsUpdateConstraints()
		self.view.layoutIfNeeded()

		self.cs_updateCollectionViewInsets()
	}

	internal func cs_updateKeyboardTriggerPoint()
	{
		self.keyboardController.keyboardTriggerPoint = CGPoint(x: 0.0, y: self.inputToolbar.bounds.height)
	}
}

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// MARK: - Messages collection view cell delegate

extension CSMessagesViewController: CSMessagesCollectionViewCellDelegate
{
	public func messagesCollectionViewCellDidTapAvatar(_ cell: CSMessagesCollectionViewCell)
	{
		(self.collectionView.delegate as! CSMessagesCollectionViewDelegateFlowLayout).collectionView(self.collectionView, didTapAvatarImageView: cell.avatarImageView!, atIndexPath: self.collectionView.indexPath(for: cell)!)
	}

	public func messagesCollectionViewCellDidTapMessageBubble(_ cell: CSMessagesCollectionViewCell)
	{
		(self.collectionView.delegate as! CSMessagesCollectionViewDelegateFlowLayout).collectionView(self.collectionView, didTapMessageBubbleAtIndexPath: self.collectionView.indexPath(for: cell)!)
	}

	public func messagesCollectionViewCellDidTapCell(_ cell: CSMessagesCollectionViewCell, atPosition position: CGPoint)
	{
		(self.collectionView.delegate as! CSMessagesCollectionViewDelegateFlowLayout).collectionView(self.collectionView, didTapCellAtIndexPath: self.collectionView.indexPath(for: cell)!, touchLocation: position)
	}
}

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// MARK: - Text view delegate

extension CSMessagesViewController: UITextViewDelegate
{
	open func textViewDidBeginEditing(_ textView: UITextView)
	{
		if (textView != self.inputToolbar.contentView.textView) { return }

		textView.becomeFirstResponder()

		if self.isAutomaticallyScrollsToMostRecentMessage
		{
			self.scrollToBottomAnimated(true)
		}
	}

	open func textViewDidChange(_ textView: UITextView)
	{
		if (textView != self.inputToolbar.contentView.textView) { return }

		self.inputToolbar.toggleSendButtonEnabled()
	}

	open func textViewDidEndEditing(_ textView: UITextView)
	{
		if (textView != self.inputToolbar.contentView.textView) { return }

		textView.resignFirstResponder()
	}
}

////////////////////////////////////////////////////////////////////////////////
