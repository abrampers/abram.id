//
//  GoogleAnalytics.swift
//  
//
//  Created by Abram Situmorang on 08/03/20.
//

import Foundation

public protocol GoogleAnalyticsTrackable {
    var googleAnalyticsTrackingID: String { get }
}

public class GoogleAnalytics {
    static let shared = GoogleAnalytics()

    public func url(for site: GoogleAnalyticsTrackable) -> URL? {
        return URL(string: "https://www.googletagmanager.com/gtag/js?id=\(site.googleAnalyticsTrackingID)")
    }
}
