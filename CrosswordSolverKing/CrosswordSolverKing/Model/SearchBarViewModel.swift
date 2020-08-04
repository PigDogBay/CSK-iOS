//
//  SearchBarViewModel.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 04/08/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Combine

class SearchBarViewModel : ObservableObject {
    let model : Model
    
    init(model : Model){
        self.model = model
    }

    func setQueryFrom(typed : String) {
        model.query = typed.replacingOccurrences(of: " ", with: "?").replacingOccurrences(of: ".", with: "?")
        //Notify view that the query has changed
        self.objectWillChange.send()
    }
}
