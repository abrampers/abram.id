//
//  Theme-AbramId.swift
//  
//
//  Created by Abram Situmorang on 08/03/20.
//

import Foundation
import Plot
import Publish

extension Theme where Site == AbramId {
    /// The default "Foundation" theme that Publish ships with, a very
    /// basic theme mostly implemented for demonstration purposes.
    static var abramId: Self {
        Theme(
            htmlFactory: AbramIdHTMLFactory(),
            resourcePaths: ["Resources/AbramIdTheme-css/styles.css"]
        )
    }
}

private struct AbramIdHTMLFactory: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<AbramId>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                .header(for: context, selectedSection: .blog),
                .wrapper(
                    .h1(.text(index.title)),
                    .h2("Latest content"),
                    .itemList(
                        for: context.allItems(
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeSectionHTML(for section: Section<AbramId>,
                         context: PublishingContext<AbramId>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body(
                .header(for: context, selectedSection: section.id),
                .wrapper(
                    .h1(.text(section.title)),
                    .itemList(for: section.items, on: context.site)
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeItemHTML(for item: Item<AbramId>,
                      context: PublishingContext<AbramId>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .header(for: context, selectedSection: item.sectionID),
                .wrapper(
                    .article(
                        .div(
                            .class("content"),
                            .contentBody(item.body)
                        ),
                        .span("Tagged with: "),
                        .tagList(for: item, on: context.site)
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<AbramId>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .if(page.title == "About",
                    .header(for: context, selectedSection: .about),
                else:
                    .if(page.title == "Resume",
                        .header(for: context, selectedSection: .resume),
                    else:
                        .header(for: context, selectedSection: nil)
                    )
                ),
                .wrapper(
                    .div(
                        .class("content"),
                        .contentBody(page.body)
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<AbramId>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1("Browse by tag"),
                    .p("Explore my blog by topic or category"),
                    .ul(
                        .class("all-tags"),
                        .forEach(page.tags.sorted()) { tag in
                            .li(
                                .class("tag"),
                                .a(
                                    .href(context.site.path(for: tag)),
                                    .text(tag.string)
                                )
                            )
                        }
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<AbramId>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1(
                        "Tagged with ",
                        .span(.class("tag"), .text(page.tag.string))
                    ),
                    .a(
                        .class("browse-all"),
                        .text("Browse all tags"),
                        .href(context.site.tagListPath)
                    ),
                    .itemList(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .article(.class("page wrapper article"), .group(nodes))
    }
    
    static func headerList(context: PublishingContext<AbramId>, _ section: AbramId.SectionID, _ selectedSection: AbramId.SectionID) -> Node<HTML.ListContext> {
        if section == .tags {
            return .li(
                .a(
                    .href(context.sections[section].path),
                    .text(context.sections[section].title)
                ),
                .class(section == selectedSection ? "search selected" : "search")
            )
        } else {
            return .li(
                .a(
                    .href(context.sections[section].path),
                    .text(context.sections[section].title)
                ),
                .class(section == selectedSection ? "selected" : "")
            )
        }
    }

    static func header(
        for context: PublishingContext<AbramId>,
        selectedSection: AbramId.SectionID?
    ) -> Node {
        let sectionIDs = AbramId.SectionID.allCases

        return .header(
            .div(
                .class("wrapper"),
                .p(
                    .a(
                        .class("site-name"),
                        .href("/"),
                        .text(context.site.name)
                    )
                ),
                .p(
                    .class("description"),
                    .text(context.site.description)
                ),
                .if(sectionIDs.count > 1,
                    .nav(
                        .ul(.forEach(sectionIDs) { section in
                            return headerList(context: context, section, selectedSection ?? .tags)
                        })
                    )
                )
            )
        )
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                    )),
                    .div(
                        .class("metadata"),
                        .tagList(for: item, on: site),
                        .span(
                            .class("date"),
                            .text(DateFormatter.article.string(from: item.date))
                        )
                    ),
                    .p(.text(item.description))
                ))
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.a(
                .href(site.path(for: tag)),
                .text(tag.string)
            ))
        })
    }

    static func footer(for site: AbramId) -> Node {
        return .footer(
            .div(
                .forEach(site.socialMediaLinks, { link in
                    .a(
                        .href(link.url),
                        .class(link.icon)
                    )
                })
            ),
            .p(
                .text("Copyright © 2020 Abram Situmorang")
            ),
            .p(
                .text("Generated using "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                )
            )
        )
    }
}

private extension Node where Context == HTML.DocumentContext {
    static func head(
        for location: Location,
        on site: AbramId,
        titleSeparator: String = " | ",
        stylesheetPaths: [Path] = ["/styles.css", "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"],
        rssFeedPath: Path? = .defaultForRSSFeed,
        rssFeedTitle: String? = nil
    ) -> Node {
        var title = location.title

        if title.isEmpty {
            title = site.name
        } else {
            title.append(titleSeparator + site.name)
        }

        var description = location.description

        if description.isEmpty {
            description = site.description
        }

        return .head(
            .encoding(.utf8),
            .siteName(site.name),
            .url(site.url(for: location)),
            .title(title),
            .description(description),
            .twitterCardType(location.imagePath == nil ? .summary : .summaryLargeImage),
            .forEach(stylesheetPaths, { .stylesheet($0) }),
            .viewport(.accordingToDevice),
            .unwrap(site.favicon, { .favicon($0) }),
            .script(
                .src(GoogleAnalytics.shared.url(for: site)!)
            ),
            .script(
                .raw("""
                    window.dataLayer = window.dataLayer || [];
                    function gtag(){dataLayer.push(arguments);}
                    gtag('js', new Date());
                    
                    gtag('config', '\(site.googleAnalyticsTrackingID)');
                """)
            ),
            .unwrap(rssFeedPath, { path in
                let title = rssFeedTitle ?? "Subscribe to \(site.name)"
                return .rssFeedLink(path.absoluteString, title: title)
            }),
            .unwrap(location.imagePath ?? site.imagePath, { path in
                let url = site.url(for: path)
                return .socialImageLink(url)
            })
        )
    }
}

