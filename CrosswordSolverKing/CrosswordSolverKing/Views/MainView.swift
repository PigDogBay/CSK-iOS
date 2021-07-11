//
//  MainView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 22/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var coordinator : Coordinator
    @ObservedObject private var viewModel : MainViewModel
    
    init(model : Model){
        self.viewModel = MainViewModel(model: model)
        //Enable clear button on the text field
        //https://stackoverflow.com/questions/58200555/swiftui-add-clearbutton-to-textfield
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    private var listSection : some View {
        return List {
            ForEach(viewModel.model.matches, id: \.self) {match in
                MatchRow(match: match, formatter: self.viewModel.model.wordFormatter)
                    .contextMenu{
                        Button(action: {self.coordinator.contextMenu(word: match, provider: .Collins) }){Text("Collins")}
                        Button(action: {self.coordinator.contextMenu(word: match, provider: .Dictionary) }){Text("Dictionary.com")}
                        Button(action: {self.coordinator.contextMenu(word: match, provider: .GoogleDefinition) }){Text("Google Definition")}
                        Button(action: {self.coordinator.contextMenu(word: match, provider: .Lexico) }){Text("Lexico")}
                        Button(action: {self.coordinator.contextMenu(word: match, provider: .MerriamWebster) }){Text("Merriam-Webster")}
                        Button(action: {self.coordinator.contextMenu(word: match, provider: .MWThesaurus) }){Text("M-W Thesaurus")}
                        Button(action: {self.coordinator.contextMenu(word: match, provider: .Thesaurus) }){Text("Thesaurus.com")}
                        Button(action: {self.coordinator.contextMenu(word: match, provider: .Wikipedia) }){Text("Wikipedia")}
                        Button(action: {self.coordinator.contextMenu(word: match, provider: .Wiktionary) }){Text("Wiktionary")}
                        Button(action: {self.coordinator.contextMenu(word: match, provider: .WordGameDictionary) }){Text("Word Game Dictionary")}
                    }
                    .contentShape(Rectangle()) //Ensure row white space is tappable
                    .onTapGesture {self.coordinator.lookUpWord(word: match)}
                }
        }
        .gesture(DragGesture().onChanged { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        })
    }

    @ViewBuilder
    var body: some View {
        VStack(){
            SearchBarView(model: self.viewModel.model)
            if self.viewModel.showTips {
                TipsView(filters: coordinator.model.filters).animation(.linear).transition(.slide)
            } else {
                Text(viewModel.status)
                self.listSection
            }
        }
        .navigationBarTitle(Text("CSK"), displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarItems(leading: Button(action: viewModel.model.reset){Text(viewModel.topLeftButton)},
                            trailing: NavigationLink(destination: FiltersView(filters: viewModel.model.filters)){Text("Filters")})
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        return MainView(model : Model())
    }
}
