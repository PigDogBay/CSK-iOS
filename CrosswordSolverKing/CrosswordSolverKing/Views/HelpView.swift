//
//  HelpView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 19/04/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    let tip : Tip
    var body: some View {
        Form {
            HStack {
                Spacer()
                Image(systemName: "lightbulb")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.yellow)
                    .padding(8)
                Text(tip.title).font(.largeTitle)
                Spacer()
            }
            Text(tip.description)
        }
        .navigationBarTitle(Text("Help"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: showMe){ Text("Show Me")})
    }
    
    func showMe(){
        
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(tip: tipsData[0])
    }
}
