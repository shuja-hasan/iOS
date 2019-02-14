// Copyright DApps Platform Inc. All rights reserved.

import Foundation

public struct Constants {
    
    public static let coinbaseWidgetCode = ""
    public static let shapeShiftPublicKey = ""
    public static let changellyRefferalID = ""
    //
    public static let keychainKeyPrefix = "ethowallet"
    public static let keychainTestsKeyPrefix = "ethowallet-test"
    
    // social
    public static let website = "https://ether1.org"
    public static let twitterUsername = "Ether1Official"
    public static let telegramUsername = "Ether_1"
    public static let facebookUsername = "ether1official"
    public static let discordServer = "https://discord.gg/RA4AZx9"
    public static let bitcoinTalkUrl = "https://bitcointalk.org/index.php?topic=3725742"
    public static let redditUrl = "https://www.reddit.com/r/ether1/"
    public static let githubUrl = "https://github.com/Ether1Project/Ether1"
    
    public static var localizedTelegramUsernames = ["ru": "Ether_1", "vi": "Ether_1", "es": "Ether_1", "zh": "Ether_1", "ja": "Ether_1", "de": "Ether_1", "fr": "Ether_1"]
    
    // support
    public static let supportEmail = "admin@ether1.org"
    public static let donationAddress = "0xdfdbe46a630fbde2da1cea59cd18960843268fb7"
    
    public static let dappsBrowserURL = "https://ether1.org"
    public static let dappsOpenSea = ""
    public static let images = "https://github.com/Ether1Project/Ether-1-Branding"
    
    public static let trustAPI = URL(string: "https://api1.etholabs.org")!
}

public struct UnitConfiguration {
    public static let gasPriceUnit: EthereumUnit = .gwei
    public static let gasFeeUnit: EthereumUnit = .ether
}

public struct URLSchemes {
    public static let trust = "ether-1://"
    public static let browser = trust + "browser"
}

