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
import UIKit

struct SoundConstants
{
	static let CSMessageReceivedSoundName = "Sounds/message_received"
	static let CSMessageSentSoundName = "Sounds/message_sent"
}

extension CSSystemSoundPlayer
{
	/**
	 *  Plays the default sound for received messages.
	 */
	public static func cs_playMessageReceivedSound()
	{
		CSSystemSoundPlayer.sharedPlayer.bundle = Bundle.cs_messagesAssetBundle()
		CSSystemSoundPlayer.sharedPlayer.playSoundWith(fileName: SoundConstants.CSMessageReceivedSoundName, extension: kCSSystemSoundTypeAIFF)
	}

	/**
	 *  Plays the default sound for received messages *as an alert*, invoking device vibration if available.
	 */
	public static func cs_playMessageReceivedAlert()
	{
		CSSystemSoundPlayer.sharedPlayer.bundle = Bundle.cs_messagesAssetBundle()
		CSSystemSoundPlayer.sharedPlayer.playAlertSoundWith(fileName: SoundConstants.CSMessageReceivedSoundName, extension: kCSSystemSoundTypeAIFF)
	}

	/**
	 *  Plays the default sound for sent messages.
	 */
	public static func cs_playMessageSentSound()
	{
		CSSystemSoundPlayer.sharedPlayer.bundle = Bundle.cs_messagesAssetBundle()
		CSSystemSoundPlayer.sharedPlayer.playSoundWith(fileName: SoundConstants.CSMessageSentSoundName, extension: kCSSystemSoundTypeAIFF)
	}

	/**
	 *  Plays the default sound for sent messages *as an alert*, invoking device vibration if available.
	 */
	public static func cs_playMessageSentAlert()
	{
		CSSystemSoundPlayer.sharedPlayer.playAlertSoundWith(fileName: SoundConstants.CSMessageSentSoundName, extension: kCSSystemSoundTypeAIFF)
	}
}
