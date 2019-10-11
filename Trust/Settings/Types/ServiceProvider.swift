// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import Rswift
import UIKit

enum URLServiceProvider {
    case twitter
    case telegram
    case facebook
    case discord
    case bitcointalk
    case reddit
    case github
    case sourceCode
    case upstreamSourceCode
    case privacyPolicy
    case termsOfService
    case upstreamPrivacyPolicy
    case upstreamTermsOfService
    var title: String {
        switch self {
        case .twitter: return "Twitter"
        case .telegram: return "Telegram"
        case .facebook: return "Facebook"
        case .discord: return "Discord"
        case .reddit: return "Reddit"
        case .bitcointalk: return "Bitcoin Talk"
        case .github: return "GitHub"
        case .sourceCode: return R.string.localizable.settingsSourceCodeButtonTitle()
        case .upstreamSourceCode: return R.string.localizable.settingsUpstreamSourceCodeButtonTitle()
        case .privacyPolicy: return R.string.localizable.settingsPrivacyPolicyButtonTitle()
        case .termsOfService: return R.string.localizable.settingsTermsOfServiceButtonTitle()
        case .upstreamPrivacyPolicy: return R.string.localizable.settingsUpstreamPrivacyPolicyButtonTitle()
        case .upstreamTermsOfService: return R.string.localizable.settingsUpstreamTermsOfServiceButtonTitle()
        }
    }

    var localURL: URL? {
        switch self {
        case .twitter:
            return URL(string: "twitter://user?screen_name=\(Constants.twitterUsername)")!
        case .telegram:
            return URL(string: "tg://resolve?domain=\(preferredTelegramUsername())")
        case .facebook:
            return URL(string: "fb://profile?id=\(Constants.facebookUsername)")
        case .discord:
            return URL(string: Constants.discordServer)
        case .bitcointalk:
            return URL(string: Constants.bitcoinTalkUrl)
        case .reddit:
            return URL(string: Constants.redditUrl)
        case .github:
            return URL(string: Constants.githubUrl)
        case .sourceCode: return nil
        case .upstreamSourceCode: return nil
        case .privacyPolicy: return nil
        case .termsOfService: return nil
        case .upstreamPrivacyPolicy: return nil
        case .upstreamTermsOfService: return nil
        }
    }

    var remoteURL: URL {
        return URL(string: remoteURLString)!
    }

    private var remoteURLString: String {
        switch self {
        case .twitter:
            return "https://twitter.com/\(Constants.twitterUsername)"
        case .telegram:
            return "https://telegram.me/\(preferredTelegramUsername())"
        case .facebook:
            return "https://www.facebook.com/\(Constants.facebookUsername)"
        case .discord:
            return Constants.discordServer
        case .reddit:
            return Constants.redditUrl
        case .github:
            return Constants.githubUrl
        case .bitcointalk:
            return Constants.bitcoinTalkUrl
        case .sourceCode:
            return "https://github.com/itsmylife44/trust-wallet-ios"
        case .upstreamSourceCode:
            return "https://github.com/TrustWallet/trust-wallet-ios"
        case .privacyPolicy:
            return "https://www.ether1.org/privacy.html"
        case .termsOfService:
            return "https://www.www.ether1/termsofuse.html"
        case .upstreamPrivacyPolicy:
            return "https://trustwalletapp.com/privacy-policy.html"
        case .upstreamTermsOfService:
            return "https://trustwalletapp.com/terms.html"
        }
    }

    var image: UIImage? {
        switch self {
        case .twitter: return R.image.settings_colorful_twitter()
        case .telegram: return R.image.settings_colorful_telegram()
        case .facebook: return R.image.settings_colorful_facebook()
        case .discord: return R.image.settings_colorful_discord()
        case .bitcointalk: return R.image.settings_colorful_bitcointalk()
        case .reddit: return R.image.settings_colorful_reddit()
        case .github: return R.image.settings_colorful_github()
        case .sourceCode: return nil
        case .upstreamSourceCode: return nil
        case .privacyPolicy: return nil
        case .termsOfService: return nil
        case .upstreamPrivacyPolicy: return nil
        case .upstreamTermsOfService: return nil
        }
    }

    private func preferredTelegramUsername() -> String {
        let languageCode = NSLocale.preferredLanguageCode ?? ""
        return Constants.localizedTelegramUsernames[languageCode] ?? Constants.telegramUsername
    }
}
