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
 *  A `CSMessagesCollectionViewFlowLayoutInvalidationContext` object specifies properties for determining whether to recompute the size of items or their position in the layout.
 *  The flow layout object creates instances of this class when it needs to invalidate its contents in response to changes. You can also create instances when invalidating the flow layout manually.
 *
 */
class CSMessagesCollectionViewFlowLayoutInvalidationContext: UICollectionViewFlowLayoutInvalidationContext
{
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization

	override init()
	{
		super.init()

		self.invalidateFlowLayoutDelegateMetrics = false
		self.invalidateFlowLayoutAttributes = false
	}

	/**
	 *  Creates and returns a new `CSMessagesCollectionViewFlowLayoutInvalidationContext` object.
	 *
	 *  @discussion When you need to invalidate the `CSMessagesCollectionViewFlowLayout` object for your `CSMessagesViewController` subclass, you should use this method to instantiate a new invalidation context and pass this object to `invalidateLayoutWithContext:`.
	 *
	 *  @return An initialized invalidation context object if successful, otherwise `nil`.
	 */
	class func context() -> Self
	{
		return instantiateCSMessagesCollectionViewFlowLayoutInvalidationContextHelper()
	}

	private class func instantiateCSMessagesCollectionViewFlowLayoutInvalidationContextHelper<T>() -> T
	{
		let context = CSMessagesCollectionViewFlowLayoutInvalidationContext.init()

		context.invalidateFlowLayoutDelegateMetrics = true
		context.invalidateFlowLayoutAttributes = true

		return context as! T
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - NSObject

	override var description: String
	{
		return "<\(self.self): invalidateFlowLayoutDelegateMetrics=\(self.invalidateFlowLayoutDelegateMetrics), invalidateFlowLayoutAttributes=\(self.invalidateFlowLayoutAttributes), invalidateDataSourceCounts=\(self.invalidateDataSourceCounts)>"
	}

	//////////////////////////////////////////////////////////////////////////////
}
