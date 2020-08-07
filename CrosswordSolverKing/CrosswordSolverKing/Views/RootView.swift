//
//  RootView.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 07/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct RootView: View {
    @EnvironmentObject var coordinator : Coordinator
    @ObservedObject private var euConsent = EUConsent()

    private func adSection(gadSize : GADAdSize) -> some View {
        HStack {
            Spacer()
            GADBannerViewController(gadSize: gadSize)
                .frame(width: gadSize.size.width, height: gadSize.size.height)
            Spacer()
        }
    }

    @ViewBuilder
    var body: some View {
        if coordinator.showSplash {
            SplashScreen()
        } else {
            GeometryReader { geo in
                VStack(){
                    NavigationView {
                        MainView(coordinator: self.coordinator)
                    }.navigationViewStyle(StackNavigationViewStyle())
                    if !self.euConsent.showEUConsent{
                        if self.coordinator.isPortrait {
                            self.adSection(gadSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(geo.size.width))
                        } else {
                            self.adSection(gadSize: GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth(geo.size.width))
                        }
                    }
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
