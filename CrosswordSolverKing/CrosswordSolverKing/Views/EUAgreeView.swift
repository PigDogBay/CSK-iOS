//
//  EUAgreeView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 03/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct EUAgreeView: View {
    @Binding var isPresented : Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("EUConsentIcon")
                    .clipShape(Circle())
                    .shadow(radius: 10)
                Text("Crossword Solver King")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Spacer()
            }
                Text("We’ll partner with Google and use a unique identifier on your device to respect your data usage choice. You can change your choice anytime for in the About & Privacy section.")
                    .multilineTextAlignment(.center)
                    .padding(24)
                Button(action: pressPrivacyPolicy){
                    Text("How Crossword Solver King uses your data")
                        .padding(.top,0)
                        .padding(.bottom,16)
                        .padding(.leading,24)
                        .padding(.trailing,24)
                        .multilineTextAlignment(.center)
                }
    
            HStack {
                Spacer()
                Button(action: pressYes){
                        Text("< Back")
                            .font(.headline)
                            .padding(.top,16)
                            .padding(.bottom,16)
                            .padding(.leading,24)
                            .padding(.trailing,24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.accentColor, lineWidth: 1))
                    
                }
                Spacer()
                Button(action: pressNo){
                        Text("Agree")
                            .font(.headline)
                            .padding(.top,16)
                            .padding(.bottom,16)
                            .padding(.leading,24)
                            .padding(.trailing,24)
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                    .cornerRadius(8)
                }

                Spacer()
            }
        }
    }
    
    private func pressYes() {
        self.isPresented = false
    }
    private func pressNo() {
        self.isPresented = false
    }
    private func pressPrivacyPolicy(){
        self.isPresented = false
    }

}

struct EUAgreeView_Previews: PreviewProvider {
    static var previews: some View {
        EUAgreeView(isPresented: .constant(true))
    }
}
