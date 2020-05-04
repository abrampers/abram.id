//
//  SocialMediaLink.swift
//  
//
//  Created by Abram Situmorang on 08/03/20.
//

import Foundation

struct SocialMediaLink {
    let title: String
    let url: String
    let icon: String
}

extension SocialMediaLink {
    static var links = [
        SocialMediaLink(
            title: "Twitter",
            url: "https://twitter.com/abrampers",
            icon: "fa fa-twitter"
        ),
        SocialMediaLink(
            title: "GitHub",
            url: "https://github.com/abrampers",
            icon: "fa fa-github"
        ),
        SocialMediaLink(
            title: "Email",
            url: "mailto:abram.perdanaputra@gmail.com",
            icon: "fa fa-envelope"
        ),
        SocialMediaLink(
            title: "LinkedIn",
            url: "https://www.linkedin.com/in/abrampers/",
            icon: "fa fa-linkedin"
        ),
        SocialMediaLink(
            title: "RSS Feed",
            url: "/feed.rss",
            icon: "fa fa-rss"
        )
    ]
}
