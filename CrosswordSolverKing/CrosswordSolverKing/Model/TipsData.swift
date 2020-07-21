//
//  TipsData.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 20/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation

let tipsData : [Tip] = load("tips.json")

struct Tip : Identifiable, Codable{
    var id : Int
    var title : String
    var subtitle : String
    var description : String
    var showMe : String
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
