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
                NavigationLink(destination: DefinitionView(viewModel: DefinitionViewModel(word: match))){
                    Text(self.viewModel.format(match: match))
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
