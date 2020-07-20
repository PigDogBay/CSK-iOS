//
//  TipsData.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 20/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation

struct Tip : Identifiable{
    let id = UUID()
    
    let title : String
    let description : String
    
}


let TipData = [Tip(title: "Cr?sswords", description: "Press space for unknown letters"),
               Tip(title: "Anagrams", description: "Enter your letters"),
               Tip(title: "Blank Letters", description: "Use + for blank tiles")

]
