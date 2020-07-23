//
//  SearchBar.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 18/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct SearchBarView : View {
    @ObservedObject var viewModel : MainViewModel

    var body: some View {
        let binding = Binding(
            get: {self.viewModel.model.query},
            set: {self.viewModel.setQueryFrom(typed: $0)})
        
        return TextField("Enter letters", text: binding)
            .padding(EdgeInsets(top: 24, leading: 12, bottom: 8, trailing: 12))
            .font(.system(.title, design: .monospaced))
            .frame(height: 60)
            .keyboardType(.emailAddress)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(viewModel: MainViewModel())
    }
}
