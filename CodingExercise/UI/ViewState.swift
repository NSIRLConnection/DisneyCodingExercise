//
//  ViewState.swift
//  CodingExercise
//
//  Created by Michael Yau on 10/19/23.
//

import Foundation

/// Enum describing states of a view
enum ViewState<State: Equatable, Failure: Error & Equatable> {
    
    /// Initial state
    case empty
    
    /// State when data is loading
    case loading
    
    /// State when data is readyfor the view
    case ready(State)
    
    /// State when an error has occurred and the view should reflect it
    case error(Failure)
}
