//
//  MainView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 22/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct MainView: View {
    @ObservedObject private var viewModel : MainViewModel
    @ObservedObject private var euConsent = EUConsent()
    @ObservedObject private var aboutVM = AboutViewModel()
    
    init(viewModel : MainViewModel){
        self.viewModel = viewModel
        //Enable clear button on the text field
        //https://stackoverflow.com/questions/58200555/swiftui-add-clearbutton-to-textfield
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    private var statusSection : some View {
        return Text(viewModel.getStatusText())
    }
    
    private var listSection : some View {
        return List {
            ForEach(viewModel.model.matches, id: \.self) {match in
                NavigationLink(destination: DefinitionView(model: DefaultDefintion(word: match))){
                    MatchRow(match: match, formatter: self.viewModel.model.wordFormatter)
                        .contextMenu{
                            Button(action: {self.viewModel.contextMenu(word: match, provider: .Collins) }){Text("Collins")}
                            Button(action: {self.viewModel.contextMenu(word: match, provider: .Dictionary) }){Text("Dictionary.com")}
                            Button(action: {self.viewModel.contextMenu(word: match, provider: .GoogleDefinition) }){Text("Google Definition")}
                            Button(action: {self.viewModel.contextMenu(word: match, provider: .Lexico) }){Text("Lexico")}
                            Button(action: {self.viewModel.contextMenu(word: match, provider: .MerriamWebster) }){Text("Merriam-Webster")}
                            Button(action: {self.viewModel.contextMenu(word: match, provider: .MWThesaurus) }){Text("M-W Thesaurus")}
                            Button(action: {self.viewModel.contextMenu(word: match, provider: .Thesaurus) }){Text("Thesaurus.com")}
                            Button(action: {self.viewModel.contextMenu(word: match, provider: .Wikipedia) }){Text("Wikipedia")}
                            Button(action: {self.viewModel.contextMenu(word: match, provider: .Wiktionary) }){Text("Wiktionary")}
                            Button(action: {self.viewModel.contextMenu(word: match, provider: .WordGameDictionary) }){Text("Word Game Dictionary")}
                        }
                }
            }
        }
        .gesture(DragGesture().onChanged { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        })
    }

    private func adSection(gadSize : GADAdSize) -> some View {
        HStack {
            Spacer()
            GADBannerViewController(viewModel: aboutVM, gadSize: gadSize)
                .frame(width: gadSize.size.width, height: gadSize.size.height)
            Spacer()
        }
    }
    
    @ViewBuilder
    var body: some View {
        if viewModel.screen == .Splash {
            SplashScreen()
                .onAppear(perform: viewModel.splashScreenAppeared)
        } else {
            NavigationView {
                GeometryReader { geo in
                    VStack(){
                        SearchBarView(model: self.viewModel.model)
                        if self.viewModel.screen == .Tips {
                            TipsView(aboutVM: self.aboutVM)
                        } else {
                            self.statusSection
                            self.listSection
                            //Triggered from the context menu on a match
                            NavigationLink(destination: DefinitionView(model: self.viewModel.createDefinitionViewModel()), isActive: self.$viewModel.isDefinitionViewActive){EmptyView()}
                        }
                        if !self.euConsent.showEUConsent{
                            if self.viewModel.isPortrait {
                                self.adSection(gadSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(geo.size.width))
                            } else {
                                self.adSection(gadSize: GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth(geo.size.width))
                            }
                        }
                    }
                }
                .onAppear(perform: viewModel.onAppear)
                .onDisappear(perform: viewModel.onDisappear)
                .sheet(isPresented: self.$euConsent.showEUConsent){EUConsentView(euConsent: self.euConsent)}
                .navigationBarTitle(Text("CSK"), displayMode: .inline)
                .navigationBarHidden(false)
                .navigationBarItems(leading: Button(action: viewModel.model.reset){Text(viewModel.topLeftButton)},
                                    trailing: NavigationLink(destination: FiltersView(filters: viewModel.model.filters)){Text("Filters")})
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = MainViewModel()
        return MainView(viewModel: vm).environmentObject(vm.model)
    }
}
