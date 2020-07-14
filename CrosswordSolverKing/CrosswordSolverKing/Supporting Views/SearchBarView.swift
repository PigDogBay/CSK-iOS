//
//  SearchBar.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 18/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct SearchBarView : View {
    @EnvironmentObject var model : Model

    var body: some View {
        TextField("Enter letters", text: $model.query, onCommit: {self.searchPressed()})
            .padding(EdgeInsets(top: 24, leading: 12, bottom: 8, trailing: 12))
            .font(.system(.title, design: .monospaced))
            .frame(height: 60)
            .keyboardType(.emailAddress)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    func searchPressed(){
        //This code should be in MainVM
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
//        model.search()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView().environmentObject(Model())
    }
}
