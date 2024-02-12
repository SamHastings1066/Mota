//
//  SuperSetViewModel.swift
//  Mota
//
//  Created by sam hastings on 06/02/2024.
//

import Foundation

struct collapsedSetRepresentation {
    var name: String
    var weight: Int?
    var reps: Int?
}

class SuperSetViewModel{
    var superset: SuperSet
    //var sets: [collapsedSetRepresentation]
    var collapsedSuperset: CollapsedSuperset
    
    init(superset: SuperSet) {
        self.superset = superset
        collapsedSuperset = CollapsedSuperset(superset)
    }
}
