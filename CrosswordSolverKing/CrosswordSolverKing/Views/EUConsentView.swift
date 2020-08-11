//
//  EUConsentView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 06/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI


struct EUConsentView: View {
    @ObservedObject var euConsent : EUConsent

    @ViewBuilder
    var body: some View {
        if euConsent.showAdChoice {
            EUAdChoiceView(euConsent: euConsent)
        } else {
            EUAgreeView(euConsent: euConsent)
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
            Text(Strings.appName)
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
