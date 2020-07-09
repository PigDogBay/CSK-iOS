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
    case SettingsLink
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
                .default(Text("About & Privacy")){self.menuLink = .AboutLink},
                .default(Text("Settings")){self.menuLink = .SettingsLink},
                .cancel()
            ])
        }
    }

    func menuPressed(){
        showingActionSheet = true
    }
}
