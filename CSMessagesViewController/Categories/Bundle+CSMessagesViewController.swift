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

extension Bundle
{
	/**
	 *  @return The bundle for CSMessagesViewController.
	 */
	public class func cs_messagesBundle() -> Bundle
	{
		return Bundle(for: CSMessagesViewController.self)
	}

	/**
	 *  @return The bundle for assets in CSMessagesViewController.
	 */
	public class func cs_messagesAssetBundle() -> Bundle
	{
		let mainResourcePath: String = Bundle.main.resourcePath!
		//let bundleResourcePath: String = Bundle.cs_messagesBundle().privateFrameworksPath!
		let assetPath: URL = URL(fileURLWithPath: mainResourcePath).appendingPathComponent("Frameworks/CSMessagesViewController.framework/CSMessagesAssets.bundle")
		return Bundle(url: assetPath)!
	}

	/**
	 *  Returns a localized version of the string designated by the specified key and residing in the CSMessages table.
	 *
	 *  @param key  The key for a string in the CSMessages table.
	 *
	 *  @return A localized version of the string designated by key in the CSMessages table.
	 */
	public class func cs_localizedStringForKey(key: String) -> String
	{
		return NSLocalizedString(key, tableName: "CSMessages", bundle: Bundle.cs_messagesAssetBundle(), value: "", comment: "")
	}
}
