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
    @EnvironmentObject var model : Model
    @ObservedObject private var viewModel = MainViewModel()
    @ObservedObject private var euConsent = EUConsent()
    @ObservedObject private var aboutVM = AboutViewModel()

    
    init(){
        //Enable clear button on the text field
        //https://stackoverflow.com/questions/58200555/swiftui-add-clearbutton-to-textfield
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    private var listSection : some View {
        return List {
            ForEach(model.matches, id: \.self) {match in
                NavigationLink(destination: DefinitionView(match: match)){
                    Text(match)
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
    
    var body: some View {
        NavigationView {
            VStack(){
                SearchBarView()
                listSection
                if !euConsent.showEUConsent{
                    adSection
                }
                NavigationLink(destination: AboutView(viewModel: self.aboutVM),tag: MenuViewLinks.AboutLink, selection: $viewModel.menuLink){EmptyView()}
                NavigationLink(destination: HelpView(),tag: MenuViewLinks.HelpLink, selection: $viewModel.menuLink){EmptyView()}
            }
            .sheet(isPresented: self.$euConsent.showEUConsent){EUConsentView(euConsent: self.euConsent)}
            .navigationBarTitle(Text("CSK"), displayMode: .inline)
            .navigationBarHidden(false)
            .navigationBarItems(leading: MainMenuView(menuLink: $viewModel.menuLink) ,
                                trailing: NavigationLink(destination: FiltersView(filters: model.filters)){Text("Filters")})
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(Model())
    }
}
