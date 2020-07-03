//
//  EUConsentView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 02/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct EUConsentView: View {
    @Binding var isPresented : Bool

    var body: some View {
        Form {
            HStack {
                Spacer()
                Image("EUConsentIcon")
                    .clipShape(Circle())
                    .shadow(radius: 10)
                Text("Crossword Solver King")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }.padding(16)
            VStack {
                Text("We care about your privacy and data security. We keep this app free by showing ads.")
                    .multilineTextAlignment(.center)
                    .padding(8)
                Text("Can we continue to use your data to tailor ads for you?")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(8)
                Text("You can change your choice anytime for in the About & Privacy section. Our partners will collect data and use a unique identifier on your device to show you ads.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(8)
            }
            Button(action: pressYes){
                HStack(){
                    Spacer()
                    Text("Yes, continue to see relevant ads")
                        .font(.body)
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
            Button(action: pressNo){
                HStack(){
                    Spacer()
                    Text("No, see ads that are less relevant")
                        .font(.body)
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
        }
    }
    
    private func pressYes() {
        self.isPresented = false
    }
    private func pressNo() {
        self.isPresented = false
    }

}

struct EUConsentView_Previews: PreviewProvider {
    static var previews: some View {
        EUConsentView(isPresented: .constant(true))
    }
}
