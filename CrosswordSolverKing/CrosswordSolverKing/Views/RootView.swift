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

    private func adSection(gadSize : GADAdSize) -> some View {
        HStack {
            Spacer()
            GADBannerViewController(gadSize: gadSize)
                .frame(width: gadSize.size.width, height: gadSize.size.height)
            Spacer()
        }
    }
    private var contentSection : some View {
        GeometryReader { geo in
            VStack(){
                NavigationView {
                    MainView(model: self.coordinator.model)
                        .onDisappear(perform: self.coordinator.mainExited)
                        .onAppear(perform: self.coordinator.mainEntered)
                }.navigationViewStyle(StackNavigationViewStyle())
                if self.coordinator.isPortrait {
                    self.adSection(gadSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(geo.size.width))
                } else {
                    self.adSection(gadSize: GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth(geo.size.width))
                }
            }
        }
    }
    
    @ViewBuilder
    var body: some View {
        if coordinator.showSplash {
            SplashScreen()
                .onAppear(perform: coordinator.splashEntered)
        } else {
            contentSection
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
