//
//  HelpView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 19/04/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    @EnvironmentObject var coordinator : Coordinator
    @ObservedObject var viewModel : HelpViewModel
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                Image(systemName: "lightbulb")
                    .font(Font.system(.largeTitle))
                    .foregroundColor(Color.yellow)
                    .padding(8)
                Text(viewModel.tip.title)
                    .font(.largeTitle)
                Spacer()
            }
            Text(viewModel.tip.description)
                .padding(8)
            VStack(alignment: .leading) {
                Text("Example")
                    .font(.headline)
                    .underline()
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                Text("Try ")+Text(viewModel.tip.showMe).foregroundColor(.blue) + Text(" to find:")
                Text(viewModel.tip.example)
                    .foregroundColor(.red)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                HStack {
                    Spacer()
                    Button(action: {self.viewModel.showMe(coordinator: self.coordinator)}){
                        Text("Show Me")
                    }
                }
            }
            .padding(8)
            
            VStack(alignment: .leading) {
                Text("More Info")
                    .font(.headline)
                    .underline()
                    .padding(.top, 8)
                    .padding(.bottom, 16)

                Text(viewModel.tip.advanced)
                    .font(.body)
            }
            .padding()
        }
        .onAppear{self.coordinator.onAppear(screen: .Help)}
        .onDisappear{
            self.coordinator.onDisappear(screen: .Help)
        }
        .navigationBarTitle(Text("Help"), displayMode: .inline)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(viewModel: HelpViewModel(tip: tipsData[0]))
    }
}
