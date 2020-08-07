//
//  EUConsentView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 06/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI


struct EUConsentView: View {
    @EnvironmentObject var coordinator : Coordinator
    @ObservedObject var euConsent : EUConsent

    @ViewBuilder
    var body: some View {
        if euConsent.showAdChoice {
            EUAdChoiceView(euConsent: euConsent)
                .onAppear(perform: {self.coordinator.onAppear(screen: .EUConsent)})
                .onDisappear(perform: {self.coordinator.onDisappear(screen: .EUConsent)})
        } else {
            EUAgreeView(euConsent: euConsent)
                .onAppear(perform: {self.coordinator.onAppear(screen: .EUConsent)})
                .onDisappear(perform: {self.coordinator.onDisappear(screen: .EUConsent)})
        }
    }
}

struct EUConsentTitle : View {
    var body : some View {
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
    }
}



struct EUConsentView_Previews: PreviewProvider {
    static var previews: some View {
        EUConsentView(euConsent: EUConsent())
    }
}
