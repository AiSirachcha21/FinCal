//
//  StatefulViewModel.swift
//  FinCal
//
//  Created by Ryan Kuruppu on 4/4/22.
//

import Foundation
class StatefulViewModel<T> {
    var state: T
    
    init(state: T){
        self.state = state
    }
}
