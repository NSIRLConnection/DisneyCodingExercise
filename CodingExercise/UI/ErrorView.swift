//
//  ErrorView.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import SwiftUI

struct ErrorView: View {
    let load: (() -> ())
    let error: NSError
    
    var body: some View {
        VStack {
            Text(Strings.errorWithErrorCode)
                .font(.title3)
            Text("\(error.localizedDescription)")
            Button(Strings.tryAgain) {
                load()
            }
        }
    }
}

struct Error_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(load: {}, error: NSError(domain: "test", code: 409))
    }
}
