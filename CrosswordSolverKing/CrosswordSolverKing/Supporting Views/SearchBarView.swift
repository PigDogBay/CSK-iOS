//
//  SearchBar.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 18/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct SearchBarView : View {
    @ObservedObject var viewModel : SearchBarViewModel
    
    init(model : Model){
        self.viewModel = SearchBarViewModel(model: model)
    }
    
    var body: some View {
        let binding = Binding(
            get: {self.viewModel.model.query},
            set: {self.viewModel.setQueryFrom(typed: $0)})
        
        return TextField("Enter letters", text: binding)
            .padding()
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
        SearchBarView(model: Model())
    }
}
