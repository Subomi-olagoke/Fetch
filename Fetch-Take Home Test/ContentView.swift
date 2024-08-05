//
//  ContentView.swift
//  Fetch-Take Home Test
//
//  Created by Subomi Olagoke on 8/1/24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @State private var desserts: [Meal] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    List(desserts) { dessert in
                        NavigationLink(destination: MealDetailView(mealId: dessert.idMeal ?? "")) {
                            DessertListItemView(dessert: dessert)
                        }
                    }
                }
            }
            .navigationTitle("Desserts")
            .task {
                await loadDesserts()
            }
        }
    }

    private func loadDesserts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            desserts = try await NetworkManager.shared.fetchDesserts()
        } catch {
            errorMessage = "Failed to load desserts: \(error.localizedDescription)"
        }
    }
}

struct DessertListItemView: View {
    let dessert: Meal
    
    var body: some View {
        HStack {
            KFImage(URL(string: dessert.strMealThumb))
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(8)
            Text(dessert.strMeal ?? "Unknown Dessert")
        }
    }
}

#Preview {
    ContentView()
}
