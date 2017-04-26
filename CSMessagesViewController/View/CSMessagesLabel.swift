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
 *  `CSMessagesLabel` is a subclass of `UILabel` that adds support for a `textInsets` property, which is similar to the `textContainerInset` property of `UITextView`.
 */
public class CSMessagesLabel: UILabel
{
	/**
	 *  The inset of the text layout area within the label's content area. The default value is `UIEdgeInsetsZero`.
	 *
	 *  @discussion This property provides text margins for the text laid out in the label.
	 *  The inset values provided must be greater than or equal to `0.0f`.
	 */
	private var priTextInsets: UIEdgeInsets! = nil
	public var textInsets: UIEdgeInsets!
	{
		get
		{
			if self.priTextInsets == nil { self.priTextInsets = UIEdgeInsets.zero }

			return self.priTextInsets
		}
		set
		{
			if (newValue != nil && self.priTextInsets != nil && newValue == self.priTextInsets)
			{
				return
			}

			self.priTextInsets = newValue
			self.setNeedsDisplay()
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Initialization
	
	private func cs_configureLabel()
	{
		self.translatesAutoresizingMaskIntoConstraints = false
		self.textInsets = UIEdgeInsets.zero
	}
	
	override public init(frame: CGRect)
	{
		super.init(frame: frame)

		self.cs_configureLabel()
	
	}
	
	required public init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}
	
	public override func awakeFromNib()
	{
		super.awakeFromNib()

		self.cs_configureLabel()
	}
	//////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Drawing
	
	public override func drawText(in rect: CGRect)
	{
		super.drawText(in: CGRect(x: rect.minX + (self.textInsets?.left)!,
		                          y: rect.minY + (self.textInsets?.top)!,
		                          width: rect.width - (self.textInsets?.right)!,
		                          height: rect.height - (self.textInsets?.bottom)!))
	}
	
	//////////////////////////////////////////////////////////////////////////////
}
