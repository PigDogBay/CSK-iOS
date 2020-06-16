//
//  DefinitionView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 22/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct DefinitionView: View {
    var match : String
    @EnvironmentObject var model : Model
    var body: some View {
        SimpleWebView(urlRequest: model.lookupUrl(match: match))
        .navigationBarTitle(Text(match), displayMode: .inline)
    }
}

struct DefinitionView_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionView(match: "preview").environmentObject(Model())
    }
}
