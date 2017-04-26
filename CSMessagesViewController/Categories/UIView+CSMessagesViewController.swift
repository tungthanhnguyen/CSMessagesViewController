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

extension UIView
{
	/**
	 *  Pins the subview of the receiver to the edge of its frame, as specified by the given attribute, by adding a layout constraint.
	 *
	 *  @param subview   The subview to which the receiver will be pinned.
	 *  @param attribute The layout constraint attribute specifying one of `NSLayoutAttributeBottom`, `NSLayoutAttributeTop`, `NSLayoutAttributeLeading`, `NSLayoutAttributeTrailing`.
	 */
	func cs_pinSubview(_ subview: UIView, toEdge attribute: NSLayoutAttribute)
	{
		self.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: subview, attribute: attribute, multiplier: 1.0, constant: 0.0))
	}

	/**
	 *  Pins all edges of the specified subview to the receiver.
	 *
	 *  @param subview The subview to which the receiver will be pinned.
	 */
	public func cs_pinAllEdgesOfSubview(_ subview: UIView)
	{
		self.cs_pinSubview(subview, toEdge: .bottom)
		self.cs_pinSubview(subview, toEdge: .top)
		self.cs_pinSubview(subview, toEdge: .leading)
		self.cs_pinSubview(subview, toEdge: .trailing)
	}
}
