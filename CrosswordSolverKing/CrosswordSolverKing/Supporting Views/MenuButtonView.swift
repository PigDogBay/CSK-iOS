//
//  MenuButtonView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 16/06/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

enum MenuViewLinks : Int{
    case AboutLink
    case HelpLink
}

struct MainMenuView : View {
    @State private var showingActionSheet = false
    @Binding var menuLink : MenuViewLinks?
    
    var body: some View {
        Button(action: menuPressed){
            Text("Menu")
        }.actionSheet(isPresented: $showingActionSheet){
            ActionSheet(title: Text("Main Menu"), message: nil, buttons: [
                .default(Text("Help")){self.menuLink = .HelpLink},
                .default(Text("About")){self.menuLink = .AboutLink},
                .cancel()
            ])
        }
    }

    func menuPressed(){
        showingActionSheet = true
    }
}
