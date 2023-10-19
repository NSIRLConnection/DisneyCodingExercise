//
//  InspectableView.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import SwiftUI

/// Type erasing view which allows access to the inner view, useful for debugging and unit tests
struct InspectableView: View {
    
    let innerView: any View
    
    var body: some View {
        AnyView(innerView)
    }

}
