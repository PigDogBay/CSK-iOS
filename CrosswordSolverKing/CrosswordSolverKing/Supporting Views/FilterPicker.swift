//
//  NumberFilterRow.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 16/06/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct FilterPicker : View {
    let label : String
    let values : [String]
    @Binding var selection : Int

    var body: some View {
        Picker(selection: $selection, label: Text(label)){
            ForEach(0 ..< values.count, id: \.self){
                Text(self.values[$0])
            }
        }
    }
}
