//
//  MealDetailView.swift
//  Fetch-Take Home Test
//
//  Created by Subomi Olagoke on 8/1/24.
//

import SwiftUI
import Kingfisher

struct MealDetailView: View {
    let mealId: String
    @StateObject private var viewModel: MealDetailViewModel
    
    init(mealId: String) {
        self.mealId = mealId
        _viewModel = StateObject(wrappedValue: MealDetailViewModel(mealId: mealId))
    }

    var body: some View {
        content
            .navigationTitle("Meal Details")
            .task { await viewModel.loadMealDetails() }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .loaded(let meal):
            MealDetailContent(meal: meal)
        case .error(let message):
            ErrorView(message: message)
        case .idle:
            Text("No meal details available.")
        }
    }
}

class MealDetailViewModel: ObservableObject {
    @Published private(set) var state: ViewState = .idle
    private let mealId: String
    private let networkManager: NetworkManager
    
    init(mealId: String, networkManager: NetworkManager = .shared) {
        self.mealId = mealId
        self.networkManager = networkManager
    }
    
    @MainActor
    func loadMealDetails() async {
        state = .loading
        do {
            let mealDetail = try await networkManager.fetchMealDetails(id: mealId)
            state = .loaded(mealDetail)
        } catch {
            state = .error("Failed to load meal details: \(error.localizedDescription)")
        }
    }
    
    enum ViewState {
        case idle
        case loading
        case loaded(MealDetail)
        case error(String)
    }
}

struct MealDetailContent: View {
    let meal: MealDetail

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                mealImage
                mealTitle
                instructionsSection
                ingredientsSection
            }
            .padding()
        }
    }
    
    private var mealImage: some View {
        KFImage(URL(string: meal.thumbnailURL))
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .cornerRadius(8)
    }
    
    private var mealTitle: some View {
        Text(meal.name)
            .font(.title)
    }
    
    private var instructionsSection: some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "Instructions")
            Text(meal.instructions)
        }
    }
    
    private var ingredientsSection: some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "Ingredients")
            ForEach(meal.ingredients.indices, id: \.self) { index in
                Text("\(index + 1). \(meal.ingredients[index].name): \(meal.ingredients[index].measure)")
            }
        }
    }
}

struct ErrorView: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.top)
    }
}

#Preview {
    MealDetailView(mealId: "testing")
}
