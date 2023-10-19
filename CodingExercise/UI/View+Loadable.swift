//
//  View+Loadable.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import SwiftUI

protocol Loadable {
    func load()
}

extension View where Self: Loadable {
    
    var emptyOrLoadingBody: LoadingView {
        LoadingView()
    }
    
    func errorBody(_ error: NSError) -> some View {
        ErrorView(load: load, error: error)
    }

}
