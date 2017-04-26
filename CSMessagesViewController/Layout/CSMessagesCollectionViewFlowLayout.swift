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
//  Ideas for springy collection view layout taken from Ash Furrow
//  ASHSpringyCollectionView
//  https://github.com/AshFurrow/ASHSpringyCollectionView
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
 *  A constant that describes the default height for all label subviews in a `CSMessagesCollectionViewCell`.
 *
 *  @see `CSMessagesCollectionViewCell`.
 */
public let kCSMessagesCollectionViewCellLabelHeightDefault: CGFloat = 20.0


/**
 *  The `CSMessagesCollectionViewFlowLayout` is a concrete layout object that inherits from `UICollectionViewFlowLayout` and organizes message items in a vertical list.
 *  Each `CSMessagesCollectionViewCell` in the layout can display messages of arbitrary sizes and avatar images, as well as metadata such as a timestamp and sender.
 *  You can easily customize the layout via its properties or its delegate methods defined in `CSMessagesCollectionViewDelegateFlowLayout`.
 *
 *  @see `CSMessagesCollectionViewDelegateFlowLayout`
 *  @see `CSMessagesCollectionViewCell`
 */
public class CSMessagesCollectionViewFlowLayout: UICollectionViewFlowLayout
{
	/**
	 *  The collection view object currently using this layout object.
	 */
//	private var priCollectionView: CSMessagesCollectionView? = nil
//	public override var collectionView: CSMessagesCollectionView?
//	{
//		get { return self.priCollectionView }
//		set { self.priCollectionView = newValue }
//	}

	/**
	 *  Specifies whether or not the layout should enable spring behavior dynamics for its items using `UIDynamics`.
	 *
	 *  @discussion The default value is `false`, which disables "springy" or "bouncy" items in the layout.
	 *  Set to `true` if you want items to have spring behavior dynamics. You *must* set this property from `viewDidAppear:` in your `CSMessagesViewController` subclass.
	 *
	 *  @warning Though this feature is mostly stable, it is still considered an experimental feature.
	 */
	private var priIsSpringinessEnabled: Bool = false
	public var isSpringinessEnabled: Bool
	{
		get { return self.priIsSpringinessEnabled }
		set
		{
			if (newValue == self.priIsSpringinessEnabled) { return }

			self.priIsSpringinessEnabled = newValue

			if !newValue
			{
				self.dynamicAnimator?.removeAllBehaviors()
				self.visibleIndexPaths?.removeAllObjects()
			}

			self.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
		}
	}

	/**
	 *  Specifies the degree of resistence for the "springiness" of items in the layout.
	 *  This property has no effect if `springinessEnabled` is set to `false`.
	 *
	 *  @discussion The default value is `1000`. Increasing this value increases the resistance, that is, items become less "bouncy".
	 *  Decrease this value in order to make items more "bouncy".
	 */
	public var springResistanceFactor = 0

	/**
	 *  Returns the width of items in the layout.
	 */
	public var itemWidth: CGFloat
	{
		get
		{
			return (self.collectionView as! CSMessagesCollectionView).frame.width - self.sectionInset.left - self.sectionInset.right
		}
	}

	/**
	 *  The font used to display the body a text message in the message bubble of each `CSMessagesCollectionViewCell` in the collectionView.
	 *
	 *  @discussion The default value is the system font at size `15.0`. This value must not be `nil`.
	 */
	private var priMessageBubbleFont: UIFont? = UIFont()
	public var messageBubbleFont: UIFont?
	{
		get { return self.priMessageBubbleFont }
		set
		{
			if newValue != nil
			{
				if (newValue?.isEqual(self.priMessageBubbleFont))! { return }

				self.priMessageBubbleFont = newValue
				self.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
			}
		}
	}

	/**
	 *  The horizontal spacing used to lay out the text view frame within each `CSMessagesCollectionViewCell`.
	 *  This value specifies the horizontal spacing between the message bubble and the edge of the collection view cell in which it is displayed.
	 *
	 *  @discussion The default value is `40.0`. This value must be positive.
	 *  For *outgoing* messages, this value specifies the amount of spacing from the left most edge of the collectionView to the left most edge of a message bubble within a cell.
	 *
	 *  For *incoming* messages, this value specifies the amount of spacing from the right most edge of the collectionView to the right most edge of a message bubble within a cell.
	 *
	 *  @warning This value may not be exact when the layout object finishes laying out its items, due to the constraints it must satisfy.
	 *  This value should be considered more of a recommendation or suggestion to the layout, not an exact value.
	 *
	 *  @see `CSMessagesCollectionViewCellIncoming`.
	 *  @see `CSMessagesCollectionViewCellOutgoing`.
	 */
	private var priMessageBubbleLeftRightMargin: CGFloat = 0.0
	public var messageBubbleLeftRightMargin: CGFloat
	{
		get { return self.priMessageBubbleLeftRightMargin }
		set
		{
			if (newValue < 0 || newValue == self.priMessageBubbleLeftRightMargin) { return }

			self.priMessageBubbleLeftRightMargin = newValue
			self.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
		}
	}

	/**
	 *  The inset of the frame of the text view within each `CSMessagesCollectionViewCell`.
	 *  The inset values should be positive and are applied in the following ways:
	 *
	 *  1. The right value insets the text view frame on the side adjacent to the avatar image (or where the avatar would normally appear). For outgoing messages this is the right side, for incoming messages this is the left side.
	 *
	 *  2. The left value insets the text view frame on the side opposite the avatar image (or where the avatar would normally appear). For outgoing messages this is the left side, for incoming messages this is the right side.
	 *
	 *  3. The top value insets the top of the frame.
	 *
	 *  4. The bottom value insets the bottom of the frame.
	 *
	 *  @discussion The default value is `(0.0, 0.0, 0.0, 6.0)`.
	 *
	 *  @warning Adjusting this value is an advanced endeavour and not recommended.
	 *  You will only need to adjust this value should you choose to provide your own bubble image assets.
	 *  Changing this value may also require you to manually calculate the itemSize for each cell in the layout by overriding the delegate method `collectionView:layout:sizeForItemAtIndexPath:`
	 */
	public var messageBubbleTextViewFrameInsets = UIEdgeInsets()

	/**
	 *  The inset of the text container's layout area within the text view's content area in each `CSMessagesCollectionViewCell`.
	 *  The specified inset values should be positive.
	 *
	 *  @discussion The default value is `(10.0, 8.0, 10.0, 8.0)`.
	 *
	 *  @warning Adjusting this value is an advanced endeavour and not recommended.
	 *  You will only need to adjust this value should you choose to provide your own bubble image assets.
	 *  Changing this value may also require you to manually calculate the itemSize for each cell in the layout by overriding the delegate method `collectionView:layout:sizeForItemAtIndexPath:`
	 */
	private var priMessageBubbleTextViewTextContainerInsets: UIEdgeInsets? = UIEdgeInsets()
	public var messageBubbleTextViewTextContainerInsets: UIEdgeInsets?
	{
		get { return self.priMessageBubbleTextViewTextContainerInsets }
		set
		{
			if newValue != nil
			{
				if newValue == self.priMessageBubbleTextViewTextContainerInsets { return }

				self.priMessageBubbleTextViewTextContainerInsets = newValue
				self.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
			}
		}
	}

	/**
	 *  The size of the avatar image view for incoming messages.
	 *
	 *  @discussion The default value is `(34.0, 34.0)`. Set to `CGSizeZero` to remove incoming avatars.
	 */
	private var priIncomingAvatarViewSize: CGSize! = CGSize.zero
	public var incomingAvatarViewSize: CGSize!
	{
		get { return self.priIncomingAvatarViewSize }
		set
		{
			if (newValue != nil && (newValue.width < 0 || newValue.height < 0 || newValue == self.priIncomingAvatarViewSize))
			{
				return
			}

			self.priIncomingAvatarViewSize = newValue
			self.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
		}
	}

	/**
	 *  The size of the avatar image view for outgoing messages.
	 *
	 *  @discussion The default value is `(34.0, 34.0)`. Set to `CGSizeZero` to remove outgoing avatars.
	 */
	private var priOutgoingAvatarViewSize: CGSize! = CGSize.zero
	public var outgoingAvatarViewSize: CGSize!
	{
		get { return self.priOutgoingAvatarViewSize }
		set
		{
			if (newValue != nil && (newValue.width < 0 || newValue.height < 0 || newValue == self.priOutgoingAvatarViewSize))
			{
				return
			}

			self.priOutgoingAvatarViewSize = newValue
			self.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
		}
	}

	public var messageBubbleSizes: NSMutableDictionary? = NSMutableDictionary()

	private var priDynamicAnimator: UIDynamicAnimator? = nil
	public var dynamicAnimator: UIDynamicAnimator?
	{
		get
		{
			if (self.priDynamicAnimator == nil)
			{
				self.priDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
			}

			return self.priDynamicAnimator
		}
		set
		{
			if (self.priDynamicAnimator != nil)
			{
				self.priDynamicAnimator?.removeAllBehaviors()
			}

			self.priDynamicAnimator = newValue
		}
	}

	private var priVisibleIndexPaths: NSMutableSet? = nil
	public var visibleIndexPaths: NSMutableSet?
	{
		get
		{
			if self.priVisibleIndexPaths == nil
			{
				self.priVisibleIndexPaths = NSMutableSet()
			}
			return self.priVisibleIndexPaths
		}
		set
		{
			if (self.priVisibleIndexPaths != nil)
			{
				self.priVisibleIndexPaths?.removeAllObjects()
			}

			self.priVisibleIndexPaths = newValue
		}
	}

	public var latestDelta: CGFloat = 0.0

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization

	func cs_configureFlowLayout()
	{
		self.scrollDirection = UICollectionViewScrollDirection.vertical
		self.sectionInset = UIEdgeInsets(top: 10.0, left: 4.0, bottom: 10.0, right: 4.0)
		self.minimumLineSpacing = 4.0

		self.messageBubbleSizes = NSMutableDictionary()

		self.messageBubbleFont = UIFont.systemFont(ofSize: 15.0)
		self.messageBubbleLeftRightMargin = 40.0
		self.messageBubbleTextViewFrameInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 6.0)
		self.messageBubbleTextViewTextContainerInsets = UIEdgeInsets(top: 10.0, left: 8.0, bottom: 10.0, right: 8.0)

		let defaultAvatarSize = CGSize(width: 34.0, height: 34.0)
		self.incomingAvatarViewSize = defaultAvatarSize
		self.outgoingAvatarViewSize = defaultAvatarSize

		self.isSpringinessEnabled = false
		self.springResistanceFactor = 1000

		NotificationCenter.default.addObserver(self, selector: #selector(self.cs_didReceiveApplicationMemoryWarningNotification(_:)), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.cs_didReceiveDeviceOrientationDidChangeNotification(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
	}

	public override init()
	{
		super.init()

		self.cs_configureFlowLayout()
	}

	required public init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}

	override public func awakeFromNib()
	{
		super.awakeFromNib()

		self.cs_configureFlowLayout()
	}

	override public class var layoutAttributesClass: AnyClass
	{
		return CSMessagesCollectionViewLayoutAttributes.self
	}

	override public class var invalidationContextClass: AnyClass
	{
		return CSMessagesCollectionViewFlowLayoutInvalidationContext.self
	}

	deinit
	{
		NotificationCenter.default.removeObserver(self)

		self.priMessageBubbleFont = nil

		if self.messageBubbleSizes != nil
		{
			self.messageBubbleSizes?.removeAllObjects()
			self.messageBubbleSizes = nil
		}

		if self.priDynamicAnimator != nil
		{
			self.priDynamicAnimator?.removeAllBehaviors()
			self.priDynamicAnimator = nil
		}

		if self.priVisibleIndexPaths != nil
		{
			self.priVisibleIndexPaths?.removeAllObjects()
			self.priVisibleIndexPaths = nil
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Notifications

	internal func cs_didReceiveApplicationMemoryWarningNotification(_ notification: NSNotification)
	{
		self.messageBubbleSizes?.removeAllObjects()
		self.dynamicAnimator?.removeAllBehaviors()
		self.visibleIndexPaths?.removeAllObjects()
	}

	internal func cs_didReceiveDeviceOrientationDidChangeNotification(_ notification: NSNotification)
	{
		self.dynamicAnimator?.removeAllBehaviors()
		self.visibleIndexPaths?.removeAllObjects()
		self.invalidateLayout(with: CSMessagesCollectionViewFlowLayoutInvalidationContext.context())
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Collection view flow layout

	public override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext)
	{
		let messageContext = context as! CSMessagesCollectionViewFlowLayoutInvalidationContext

		if (messageContext.invalidateDataSourceCounts || messageContext.invalidateFlowLayoutAttributes || messageContext.invalidateFlowLayoutDelegateMetrics)
		{
			self.messageBubbleSizes?.removeAllObjects()
		}

		super.invalidateLayout(with: messageContext)
	}

	override public func prepare()
	{
		super.prepare()

		if self.isSpringinessEnabled
		{
			//  pad rect to avoid flickering
			let padding: CGFloat = -100.0
			let visibleRect: CGRect = (self.collectionView as! CSMessagesCollectionView).bounds.insetBy(dx: padding, dy: padding)

			let visibleItems = super.layoutAttributesForElements(in: visibleRect)!
			let visibleItemsIndexPaths = NSSet(array: visibleItems.map({$0.value(forKey: NSStringFromSelector(#selector(getter: UICollectionViewLayoutAttributes.indexPath)))!}))

			self.cs_removeNoLongerVisibleBehaviorsFromVisibleItemsIndexPaths(visibleItemsIndexPaths: visibleItemsIndexPaths)

			self.cs_addNewlyVisibleBehaviorsFromVisibleItems(visibleItems: visibleItems as NSArray)
		}
	}

	public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
	{
		var attributesInRect = super.layoutAttributesForElements(in: rect)!

		if self.isSpringinessEnabled
		{
			var attributesInRectCopy = attributesInRect
			let dynamicAttributes = self.dynamicAnimator!.items(in: rect) as! [UICollectionViewLayoutAttributes]

			// avoid duplicate attributes
			// use dynamic animator attribute item instead of regular item, if it exists
			for eachItem: UICollectionViewLayoutAttributes in attributesInRect
			{
				for eachDynamicItem: UICollectionViewLayoutAttributes in dynamicAttributes
				{
					if ((eachItem.indexPath == eachDynamicItem.indexPath) && (eachItem.representedElementCategory == eachDynamicItem.representedElementCategory))
					{
						attributesInRectCopy.remove(at: attributesInRectCopy.index(of: eachItem)!)
						attributesInRectCopy.append(eachDynamicItem)
						continue
					}
				}
			}

			attributesInRect = attributesInRectCopy
		}

		(attributesInRect as NSArray).enumerateObjects(
			{
				(ai, idx, stop) in

				let attributesItem = ai as! CSMessagesCollectionViewLayoutAttributes

				if attributesItem.representedElementCategory == UICollectionElementCategory.cell
				{
					self.cs_configureMessageCellLayoutAttributes(layoutAttributes: attributesItem)
				}
				else
				{
					attributesItem.zIndex = -1
				}
			}
		)

		return attributesInRect
	}

	public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
	{
		let customAttributes = (super.layoutAttributesForItem(at: indexPath) as! CSMessagesCollectionViewLayoutAttributes)

		if customAttributes.representedElementCategory == UICollectionElementCategory.cell
		{
			self.cs_configureMessageCellLayoutAttributes(layoutAttributes: customAttributes)
		}

		return customAttributes
	}

	public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool
	{
		let cs_collectionView = self.collectionView as! CSMessagesCollectionView

		if self.isSpringinessEnabled
		{
			let scrollView: UIScrollView = cs_collectionView
			let delta: CGFloat = newBounds.origin.y - scrollView.bounds.origin.y

			self.latestDelta = delta

			let touchLocation: CGPoint = cs_collectionView.panGestureRecognizer.location(in: cs_collectionView)

			(self.dynamicAnimator!.behaviors as NSArray).enumerateObjects(
				{
					(sb, idx, stop) in

					let springBehaviour = sb as! UIAttachmentBehavior

					self.cs_adjustSpringBehavior(springBehavior: springBehaviour, forTouchLocation: touchLocation)
					self.dynamicAnimator?.updateItem(usingCurrentState: springBehaviour.items.first!)
				}
			)
		}

//		let oldBounds: CGRect = cs_collectionView.bounds
//		if (newBounds.width != oldBounds.width || newBounds.height != oldBounds.height)
//		{
//			return true
//		}
//		return false

		return true
	}

	override public func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem])
	{
		super.prepare(forCollectionViewUpdates: updateItems)

		if self.isSpringinessEnabled
		{
			(updateItems as NSArray).enumerateObjects(
				{
					(ui, index, stop) in

					let updateItem = ui as! UICollectionViewUpdateItem

					if updateItem.updateAction == UICollectionUpdateAction.insert
					{
						if (self.dynamicAnimator?.layoutAttributesForCell(at: updateItem.indexPathAfterUpdate!) != nil)
						{
							let shouldStop: ObjCBool = true
							stop.initialize(to: shouldStop)
						}

						let size: CGSize = (self.collectionView as! CSMessagesCollectionView).bounds.size
						let attributes = CSMessagesCollectionViewLayoutAttributes(forCellWith: updateItem.indexPathAfterUpdate!)

						if (attributes.representedElementCategory == UICollectionElementCategory.cell)
						{
							self.cs_configureMessageCellLayoutAttributes(layoutAttributes: attributes)
						}

						attributes.frame = CGRect(x: 0.0, y: size.height - size.width,
						                          width: size.width, height: size.width)

						let springBehaviour: UIAttachmentBehavior = self.cs_springBehaviorWithLayoutAttributesItem(item: attributes)
						self.dynamicAnimator?.addBehavior(springBehaviour)
					}
				}
			)
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Message cell layout utilities

	/**
	 *  Computes and returns the size of the `messageBubbleImageView` property of a `CSMessagesCollectionViewCell` to display its entire message contents. Note, this is *not* the entire cell, but only its message bubble.
	 *
	 *  @param indexPath  The index path of the item to be displayed.
	 *
	 *  @return The size of the message bubble for the item displayed at indexPath.
	 */
	public func messageBubbleSizeForItemAt(_ indexPath: IndexPath) -> CGSize
	{
		let cachedSize = self.messageBubbleSizes?[indexPath]
		if (cachedSize != nil) { return cachedSize as! CGSize }

		let cs_collectionView = self.collectionView as! CSMessagesCollectionView
		let cs_dataSource = cs_collectionView.dataSource as! CSMessagesCollectionViewDataSource

		let messageData: CSMessageData = cs_dataSource.collectionView(cs_collectionView, messageDataForItemAtIndexPath: indexPath)!

		let avatarSize: CGSize = self.cs_avatarSizeForIndexPath(indexPath: indexPath)

		let maximumTextWidth: CGFloat = self.itemWidth - avatarSize.width - self.messageBubbleLeftRightMargin

		let textInsetsTotal: CGFloat = self.cs_messageBubbleTextContainerInsetsTotal()

		let stringRect: CGRect = messageData.text!.boundingRect(with: CGSize(width: maximumTextWidth - textInsetsTotal, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: [NSFontAttributeName: self.messageBubbleFont!], context: nil)

		let stringSize: CGSize = stringRect.integral.size

		let verticalInsets: CGFloat = self.messageBubbleTextViewTextContainerInsets!.top + self.messageBubbleTextViewTextContainerInsets!.bottom

		let finalSize: CGSize = CGSize(width: stringSize.width, height: stringSize.height + verticalInsets)

		self.messageBubbleSizes?[indexPath] = NSValue(cgSize: finalSize)

		return finalSize
	}

	private func cs_configureMessageCellLayoutAttributes(layoutAttributes: CSMessagesCollectionViewLayoutAttributes)
	{
		let indexPath: IndexPath = layoutAttributes.indexPath

		let messageBubbleSize: CGSize = self.messageBubbleSizeForItemAt(indexPath)
		let remainingItemWidthForBubble: CGFloat = self.itemWidth - self.cs_avatarSizeForIndexPath(indexPath: indexPath).width
		let textPadding: CGFloat = self.cs_messageBubbleTextContainerInsetsTotal()
		let messageBubblePadding: CGFloat = remainingItemWidthForBubble - messageBubbleSize.width - textPadding

		layoutAttributes.messageBubbleLeftRightMargin = messageBubblePadding
		layoutAttributes.textViewFrameInsets = self.messageBubbleTextViewFrameInsets
		layoutAttributes.textViewTextContainerInsets = self.messageBubbleTextViewTextContainerInsets!
		layoutAttributes.messageBubbleFont = self.messageBubbleFont
		layoutAttributes.incomingAvatarViewSize = self.incomingAvatarViewSize
		layoutAttributes.outgoingAvatarViewSize = self.outgoingAvatarViewSize

		let cs_collectionView = self.collectionView as! CSMessagesCollectionView
		let cs_delegate = cs_collectionView.delegate as! CSMessagesCollectionViewDelegateFlowLayout

		layoutAttributes.cellTopLabelHeight = cs_delegate.collectionView(cs_collectionView, layout: self, heightForCellTopLabelAtIndexPath: indexPath)
		layoutAttributes.messageBubbleTopLabelHeight = cs_delegate.collectionView(cs_collectionView, layout: self, heightForMessageBubbleTopLabelAtIndexPath: indexPath)
		layoutAttributes.cellBottomLabelHeight = cs_delegate.collectionView(cs_collectionView, layout: self, heightForCellBottomLabelAtIndexPath: indexPath)
	}

	private func cs_messageBubbleTextContainerInsetsTotal() -> CGFloat
	{
		let insets: UIEdgeInsets = self.messageBubbleTextViewTextContainerInsets!
		return insets.left + insets.right + insets.bottom + insets.top
	}

	private func cs_avatarSizeForIndexPath(indexPath: IndexPath) -> CGSize
	{
		let cs_collectionView = self.collectionView as! CSMessagesCollectionView
		let cs_dataSource = cs_collectionView.dataSource as! CSMessagesCollectionViewDataSource

		let messageData: CSMessageData = cs_dataSource.collectionView(cs_collectionView, messageDataForItemAtIndexPath: indexPath)!
		let messageSender: String = messageData.sender!

		if (messageSender == cs_dataSource.sender)
		{
			return self.outgoingAvatarViewSize
		}
		return self.incomingAvatarViewSize
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Spring behavior utilities

	private func cs_springBehaviorWithLayoutAttributesItem(item: UICollectionViewLayoutAttributes) -> UIAttachmentBehavior
	{
		let springBehavior: UIAttachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)

		springBehavior.length = 1.0
		springBehavior.damping = 1.0
		springBehavior.frequency = 1.0

		return springBehavior
	}

	private func cs_addNewlyVisibleBehaviorsFromVisibleItems(visibleItems: NSArray)
	{
		//  a "newly visible" item is in `visibleItems` but not in `self.visibleIndexPaths`
		let indexSet: IndexSet = visibleItems.indexesOfObjects(passingTest:)
		{
			(item, index, stop) in

			return !self.visibleIndexPaths!.contains((item as! UICollectionViewLayoutAttributes).indexPath)
		}

		let newlyVisibleItems: NSArray = visibleItems.objects(at: indexSet) as NSArray

		let cs_collectionView = self.collectionView as! CSMessagesCollectionView

		let touchLocation: CGPoint = cs_collectionView.panGestureRecognizer.location(in: cs_collectionView)

		newlyVisibleItems.enumerateObjects(
			{
				(it, index, stop) in

				let item = it as! UICollectionViewLayoutAttributes

				let springBehaviour = self.cs_springBehaviorWithLayoutAttributesItem(item: item)
				self.cs_adjustSpringBehavior(springBehavior: springBehaviour, forTouchLocation: touchLocation)
				self.dynamicAnimator!.addBehavior(springBehaviour)
				self.visibleIndexPaths?.add(item.indexPath)
			}
		)
	}

	private func cs_removeNoLongerVisibleBehaviorsFromVisibleItemsIndexPaths(visibleItemsIndexPaths: NSSet)
	{
		let behaviors: NSArray = self.dynamicAnimator!.behaviors as NSArray

		let indexSet: IndexSet = behaviors.indexesOfObjects(passingTest:)
		{
			(sb, idnex, stop) in

			let springBehaviour = sb as! UIAttachmentBehavior

			let layoutAttributes: UICollectionViewLayoutAttributes = springBehaviour.items.first as! UICollectionViewLayoutAttributes

			return !visibleItemsIndexPaths.contains(layoutAttributes.indexPath)
		}

		let behaviorsToRemove: NSArray = behaviors.objects(at: indexSet) as NSArray

		behaviorsToRemove.enumerateObjects(
			{
				(sb, index, stop) in

				let springBehaviour = sb as! UIAttachmentBehavior

				let layoutAttributes: UICollectionViewLayoutAttributes = springBehaviour.items.first as! UICollectionViewLayoutAttributes

				self.dynamicAnimator?.removeBehavior(springBehaviour)
				self.visibleIndexPaths?.remove(layoutAttributes.indexPath)
			}
		)
	}

	private func cs_adjustSpringBehavior(springBehavior: UIAttachmentBehavior, forTouchLocation touchLocation: CGPoint)
	{
		let item: UICollectionViewLayoutAttributes = springBehavior.items.first as! UICollectionViewLayoutAttributes
		var center: CGPoint = item.center

		//  if touch is not (0,0) -- adjust item center "in flight"
		if !CGPoint.zero.equalTo(touchLocation)
		{
			let distanceFromTouch: CGFloat = CGFloat(fabsf(Float(touchLocation.y - springBehavior.anchorPoint.y)))
			let scrollResistance: CGFloat = CGFloat(Float(distanceFromTouch) / Float(self.springResistanceFactor))

			if (self.latestDelta < 0.0)
			{
				center.y = center.y + max(self.latestDelta, self.latestDelta * scrollResistance)
			}
			else
			{
				center.y = center.y + min(self.latestDelta, self.latestDelta * scrollResistance)
			}

			item.center = center
		}
	}

	//////////////////////////////////////////////////////////////////////////////
}
