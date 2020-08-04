//
//  SplashScreen.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 14/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            Spacer()
            EUConsentTitle()
                .padding()
            Spacer()
            Text("Copyright © MPD Bailey Technology 2020.\nAll rights reserved.")
                .multilineTextAlignment(.center)
                .font(.footnote)
            .padding(32)
            
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
