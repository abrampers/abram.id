import Foundation
import HighlightJSPublishPlugin
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
    var url = URL(string: "https://abram.id")!
    var name = "Abram Situmorang"
    var description = "Here's a bit of my presence on the internet."
    var language: Language { .english }
    var imagePath: Path? { nil }
    var socialMediaLinks = SocialMediaLink.links
}

extension AbramId: GoogleAnalyticsTrackable {
    var googleAnalyticsTrackingID: String { "UA-131242292-1" }
}

// This will generate your website using the built-in Foundation theme:
try AbramId().publish(
    withTheme: .abramId,
    additionalSteps: [
        .deploy(using: .gitHub("abrampers/abrampers.github.io"))
    ],
    plugins: [
        .highlightJS()
    ]
)
