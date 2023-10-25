//
//  CodingExerciseApp.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/17/23.
//

import SwiftUI

@main
struct CodingExerciseApp: App {
    var body: some Scene {
        WindowGroup {
            if !MarvelServiceProvider.sharedInstance.isInitialized {
                PleaseAddAPIKeysView()
            } else {
                CharacterListView()
            }
        }
    }
}

struct PleaseAddAPIKeysView: View {
    
    var body: some View {
        Text("Please add API keys to MarvelServiceProvider.swift!")
    }
}
