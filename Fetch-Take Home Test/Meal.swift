//
//  Meal Model.swift
//  Fetch-Take Home Test
//
//  Created by Subomi Olagoke on 8/1/24.
//

import Foundation

struct Meal: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var id: String { idMeal }
}

