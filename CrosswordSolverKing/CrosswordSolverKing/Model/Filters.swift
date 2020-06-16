//
//  Filters.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 16/06/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Combine
import Foundation

class Filters : ObservableObject {
    @Published var contains = ""
    @Published var excludes = ""
    @Published var containsWord = ""
    @Published var excludesWord = ""
    @Published var prefix = ""
    @Published var suffix = ""
    @Published var pattern = ""
    @Published var regExp = ""
    @Published var distinctSelection = 0
    @Published var lessThan = 0
    @Published var moreThan = 0
    @Published var equalTo = 0
}
