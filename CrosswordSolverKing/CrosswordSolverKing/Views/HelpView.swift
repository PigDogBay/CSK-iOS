//
//  HelpView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 19/04/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    @ObservedObject var viewModel : HelpViewModel
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                Image(systemName: "lightbulb")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.yellow)
                    .padding(8)
                Text(viewModel.tip.title).font(.largeTitle)
                Spacer()
            }
            Text(viewModel.tip.description)
        }
        .onDisappear{
            self.viewModel.onDisappear()
        }
        .navigationBarTitle(Text("Help"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: viewModel.showMe){ Text("Show Me")})
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(viewModel: HelpViewModel(tip: tipsData[0], mainVM: MainViewModel(model: Model())))
    }
}
