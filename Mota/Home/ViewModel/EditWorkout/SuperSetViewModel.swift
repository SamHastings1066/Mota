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
    var sets: [collapsedSetRepresentation]
    
    init(superset: SuperSet) {
        self.superset = superset
        // get the unique names of all of the exercises in the superset. if each round of the supset has all of those unique exercise names, and if each round has the same number of sets and weights for each exercise, then set the name, weight and reps for each collapsedSetRepresentation in the sets array, otherwise just set the name for each of the unique exercise names in the superset. the view should be given an array of collapsedSetRepresentations. for each element in that array it should show the name and optionally the weight and reps if they exist, or else blank
        //let uniqueExcerises = superset.sets[0][0].exercise.name
        let uniqueExcerises = superset.sets[0].round[0].exercise.name
        sets = [collapsedSetRepresentation(name: uniqueExcerises)]
    }
}
