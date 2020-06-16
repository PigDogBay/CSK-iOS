//
//  HelpView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 19/04/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        Text("Hints and Tips")
        .navigationBarTitle(Text("Help"), displayMode: .inline)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
