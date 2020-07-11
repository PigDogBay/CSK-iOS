//
//  DefinitionView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 22/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct DefinitionView: View {
    let viewModel : DefinitionViewModel
    var body: some View {
        SimpleWebView(urlRequest: viewModel.lookupUrl())
            .navigationBarTitle(Text(viewModel.word), displayMode: .inline)
    }
}

struct DefinitionView_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionView(viewModel: DefinitionViewModel(word: "preview"))
    }
}
