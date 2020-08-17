//
//  Strings.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 28/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation
struct Strings {
    static let appName = "Crossword Solver King"
    static var version : String {Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String }
    static let appId = "id1503152101"
    static let privacyURL = "https://mpdbailey.blogspot.com/2020/08/privacy-policy.html"
    static let itunesAppURL = "https://itunes.apple.com/app/id1503152101"
    static let emailAddress = "mpdbailey@yahoo.co.uk"
    static let webAddress = "www.mpdbailey.co.uk"
    static let feedbackSubject = "CSK iOS v\(Strings.version)"
    static let tellFriends = "Take a look at Crossword Solver King "+Strings.itunesAppURL
}
