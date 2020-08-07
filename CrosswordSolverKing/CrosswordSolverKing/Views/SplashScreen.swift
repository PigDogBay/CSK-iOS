//
//  SplashScreen.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 14/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject var coordinator : Coordinator
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
        .onAppear(perform: {self.coordinator.onAppear(screen: .Splash)})
        .onDisappear(perform: {self.coordinator.onDisappear(screen: .Splash)})
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
