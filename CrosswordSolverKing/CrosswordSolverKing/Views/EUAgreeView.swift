//
//  EUAgreeView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 03/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct EUAgreeView: View {
    @ObservedObject var euConsent : EUConsent

    var body: some View {
        VStack {
            EUConsentTitle().padding(16)
            
            Text("We’ll partner with Google and use a unique identifier on your device to respect your data usage choice. You can change your choice anytime for in the About & Privacy section.")
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))

            Button(action: euConsent.showPrivacyPolicy){
                    Text("How Crossword Solver King uses your data")
                        .padding(EdgeInsets(top: 16, leading: 8, bottom: 24, trailing: 8))
                        .multilineTextAlignment(.center)
                }
    
            HStack {
                Spacer()
                Button(action: euConsent.back){
                        Text("< Back")
                            .font(.headline)
                            .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.accentColor, lineWidth: 1))
                    
                }
                Spacer()
                Button(action: euConsent.agree){
                        Text("Agree")
                            .font(.headline)
                            .padding(EdgeInsets(top: 16, leading: 28, bottom: 16, trailing: 28))
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                    .cornerRadius(8)
                }

                Spacer()
            }
        }
    }
}

struct EUAgreeView_Previews: PreviewProvider {
    static var previews: some View {
        EUAgreeView(euConsent: EUConsent())
    }
}
