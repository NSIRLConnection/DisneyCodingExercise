//
//  LoadingView.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ProgressView(Strings.loading)
    }

}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
