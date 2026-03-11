//
//  RootView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 10/03/2026.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        LanguageSelectView()
            .environmentObject(appState)
    }
}
