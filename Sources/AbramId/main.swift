import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct AbramId: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case blog
        case about
        case resume
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://your-website-url.com")!
    var name = "Abram Situmorang"
    var description = "Here's a bit of my presence on the internet."
    var language: Language { .english }
    var imagePath: Path? { nil }
    var socialMediaLinks = SocialMediaLink.links
}

struct SocialMediaLink {
    let title: String
    let url: String
    let icon: String
}

extension SocialMediaLink {
    static var links = [
        SocialMediaLink(
            title: "LinkedIn",
            url: "https://www.linkedin.com/in/abrampers/",
            icon: "fa fa-linkedin"
        ),
        SocialMediaLink(
            title: "Email",
            url: "mailto:abram.perdanaputra@gmail.com",
            icon: "fa fa-envelope"
        ),
        SocialMediaLink(
            title: "GitHub",
            url: "https://github.com/abrampers",
            icon: "fa fa-github"
        ),
        SocialMediaLink(
            title: "Twitter",
            url: "https://twitter.com/abrampers",
            icon: "fa fa-twitter"
        )
    ]
}

public protocol GoogleAnalyticsTrackable {
    var googleAnalyticsTrackingID: String { get }
}

public class GoogleAnalytics {
    static let shared = GoogleAnalytics()
    
    public func url(for site: GoogleAnalyticsTrackable) -> URL? {
        return URL(string: "https://www.googletagmanager.com/gtag/js?id=\(site.googleAnalyticsTrackingID)")
    }
}

extension AbramId: GoogleAnalyticsTrackable {
    var googleAnalyticsTrackingID: String { "UA-131242292-1" }
}

// This will generate your website using the built-in Foundation theme:
try AbramId().publish(withTheme: .abramId)
