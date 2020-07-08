//
//  HelpView.swift
//  CSKPrototype
//
//  Created by Mark Bailey on 24/03/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    
    @State private var showMeRelevantAds = true

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("INFO")
                .font(.headline)
            Text("Version v1.00")
                .font(.body)
            Text("www.mpdbailey.co.uk")
                .font(.body)
            Text("©MPD Bailey Technology 2020")
                .font(.body)

            HStack {
                Spacer()
                Button(action: showLegal){
                    Text("LEGAL")
                        .modifier(AboutButtonMod())
                }
            }
        }
    }
    
    private var privatePolicySection : some View {
        VStack(alignment: .leading, spacing: 16){
            Text("PRIVACY POLICY")
                .font(.headline)
            Text("For information about how this app uses your data press the button below to review the Privacy Policy in full.")
                .font(.body)

            HStack {
                Spacer()
                Button(action: showPrivacyPolicy){
                    Text("PRIVACY POLICY")
                        .modifier(AboutButtonMod())
                }
            }
        }
    }
    
    private var adsSection : some View {
        VStack(alignment: .leading, spacing: 16){
            Text("ADVERTISEMENTS")
                .font(.headline)
            Text("We care about your privacy and data security. We keep this app free by showing ads. Our ads are provided by Google Admob, click the link below for more information.")
                .font(.body)

            HStack {
                Spacer()
                Button(action: showGooglePrivacyPolicy){
                    Text("FIND OUT MORE")
                        .modifier(AboutButtonMod())
                }
            }
            Text("This app will use your data to tailor ads to you. Our partners will collect data and use an unique identifier on your device to show you ads. You select here if we can continue to use your data to tailor ads for you.")
                .font(.body)
            Toggle(isOn: $showMeRelevantAds) {
                if showMeRelevantAds {
                    Text("Show me relevant ads")
                } else {
                    Text("Show me ads that are less relevant")
                }
            }
        }
    }
    private var helpOutSection : some View {
        VStack(alignment: .leading, spacing: 16){
            Text("HELP OUT")
                .font(.headline)
            Text("Keep updates coming by rating the app, your feedback is most welcome.")
                .font(.body)
            HStack {
                Spacer()
                Button(action: recommend){
                    Text("RECOMMEND")
                        .modifier(AboutButtonMod())
                }
                Button(action: feedback){
                    Text("FEEDBACK")
                        .modifier(AboutButtonMod())
                }.padding(.leading, 16)
                Button(action: rate){
                    Text("RATE")
                        .modifier(AboutButtonMod())
                }.padding(.leading, 16)
            }
        }
    }

    
    var body: some View {
        Form(){
            Group {
                infoSection
                privatePolicySection
                adsSection
                helpOutSection
            }.padding(.top, 16)
        }.navigationBarTitle(Text("About"), displayMode: .inline)
    }

    private func showLegal(){
    }
    private func showPrivacyPolicy(){
        UIApplication.shared.open(URL(string: Model.privacyURL)!, options: [:])
    }
    private func showGooglePrivacyPolicy(){
        UIApplication.shared.open(URL(string: "https://www.google.com/policies/technologies/partner-sites/")!, options: [:])
    }
    private func recommend(){
    }
    private func feedback() {
    }
    private func rate(){
    }
}

struct AboutButtonMod : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundColor(.accentColor)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
