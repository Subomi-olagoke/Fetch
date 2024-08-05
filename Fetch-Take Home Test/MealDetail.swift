//
//  MealDetail.swift
//  Fetch-Take Home Test
//
//  Created by Subomi Olagoke on 8/1/24.
//
import Foundation

struct MealDetail: Codable {
    let id: String
    let name: String
    let instructions: String
    let thumbnailURL: String
    let ingredients: [Ingredient]
    
    struct Ingredient: Codable, Hashable {
        let name: String
        let measure: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case thumbnailURL = "strMealThumb"
        case strIngredient1, strIngredient2, strIngredient3 // ... up to strIngredient20
        case strMeasure1, strMeasure2, strMeasure3 // ... up to strMeasure20
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        instructions = try container.decode(String.self, forKey: .instructions)
        thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
        
        ingredients = try MealDetail.decodeIngredients(from: container)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(thumbnailURL, forKey: .thumbnailURL)
        
        try MealDetail.encodeIngredients(ingredients, to: &container)
    }
    
    private static func decodeIngredients(from container: KeyedDecodingContainer<CodingKeys>) throws -> [Ingredient] {
        var ingredients: [Ingredient] = []
        
        for i in 1...20 {
            let ingredientKey = CodingKeys(stringValue: "strIngredient\(i)")!
            let measureKey = CodingKeys(stringValue: "strMeasure\(i)")!
            
            if let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey),
               let measure = try container.decodeIfPresent(String.self, forKey: measureKey),
               !ingredient.isEmpty, !measure.isEmpty {
                ingredients.append(Ingredient(name: ingredient, measure: measure))
            }
        }
        
        return ingredients
    }
    
    private static func encodeIngredients(_ ingredients: [Ingredient], to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        for (index, ingredient) in ingredients.enumerated() {
            let i = index + 1
            let ingredientKey = CodingKeys(stringValue: "strIngredient\(i)")!
            let measureKey = CodingKeys(stringValue: "strMeasure\(i)")!
            
            try container.encode(ingredient.name, forKey: ingredientKey)
            try container.encode(ingredient.measure, forKey: measureKey)
        }
    }
}
