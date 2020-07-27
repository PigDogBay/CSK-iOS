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
    @EnvironmentObject var viewModel : MainViewModel
    @ObservedObject private var euConsent = EUConsent()
    @ObservedObject private var aboutVM = AboutViewModel()
    
    init(){
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

    private var adSection : some View {
        return HStack {
            Spacer()
            GADBannerViewController(viewModel: aboutVM)
                .frame(width: kGADAdSizeBanner.size.width, height: kGADAdSizeBanner.size.height)
            Spacer()
        }
    }
    
    @ViewBuilder
    var body: some View {
        if viewModel.screen == .Splash {
            SplashScreen()
        } else {
            NavigationView {
                VStack(){
                    SearchBarView()
                    if viewModel.screen == .Tips {
                        TipsView(aboutVM: self.aboutVM)
                    } else {
                        statusSection
                        listSection
                    }
                    if !euConsent.showEUConsent{
                        adSection
                    }
                }
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
        MainView().environmentObject(MainViewModel())
    }
}
