//
//  ContentView.swift
//  CatsVsDogs
//
//  Created by Drew Barnes on 20/10/2024.
//

import SwiftUI

struct ContentView: View {

    private let photos = Array(Photo.all)

    enum ViewState {
        case success(AnimalViewModel)
        case failure(Error)
        case loading
    }

    @State private var state: ViewState = .loading
    @State private var selectedClassifier: AnimalClassifier = AppleAnimalClassifier() {
        didSet {
            state = .loading
        }
    }

    var body: some View {
        VStack(spacing: 20) {

            TitleView(
                selectedClassifier: $selectedClassifier,
                onSelection: { state = .loading }
            )

            Text(selectedClassifier.name)
                .foregroundStyle(.white)
                .padding(5)
                .background(.brown)
                .clipShape(RoundedRectangle(cornerRadius: 5))

            switch state {
            case .success(let vm):
                AnimalView(vm: vm)
            case .failure(let error):
                NoAnimalView(label: error.localizedDescription)
            case .loading:
                NoAnimalView()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(photos, id: \.self) { photo in
                        ListItem(photo: photo)
                            .onTapGesture {
                                self.classifyAnimal(in: photo)
                            }
                    }
                }
            }
        }
        .padding()
    }

    private func classifyAnimal(in photo: Photo) {
        Task {
            let uiImage = UIImage(named: photo.name)!

            do  {
                let predictions = try await selectedClassifier.classify(image: uiImage)
                let vm = AnimalViewModel(photo: photo, predictions: predictions)
                state = .success(vm)
            } catch {
                if let classificationError = error as? AnimalClassifierError {
                    state = .failure(classificationError)
                } else {
                    state = .failure(error)
                }
            }
        }
    }
}

extension ContentView {

    struct TitleView: View {

        @Binding var selectedClassifier: AnimalClassifier
        @State private var isShowingClassifierSelection = false
        var onSelection: () -> ()

        var body: some View {
            HStack(spacing: 20) {
                Spacer()
                    .frame(width: 24, height: 24)
                Text("Cats vs Dogs")
                    .font(.largeTitle)
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                Button(action: {
                    isShowingClassifierSelection = true
                }) {
                    Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $isShowingClassifierSelection) {
                    ClassifierSelectionView(
                        selectedClassifier: $selectedClassifier,
                        onSelection: onSelection
                    )
                }
            }
        }
    }

    struct AnimalView: View {

        @ObservedObject var vm: AnimalViewModel

        var body: some View {
            Image(vm.image)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .overlay(alignment: .bottom) {
                  HStack {
                      VStack(alignment: .leading) {
                          ForEach(vm.photoPredictions, id: \.self) { prediction in
                              Text(prediction.label)
                                  .foregroundStyle(.white)
                              Text("\(prediction.confidence)% confidence")
                                  .foregroundStyle(.white.opacity(0.6))
                          }
                      }
                      .padding(5)
                      .background(.black.opacity(0.5))
                      .clipShape(RoundedRectangle(cornerRadius: 5))
                      Spacer()
                  }
                  .padding(.leading, 5)
                  .padding(.bottom, 5)
              }
              .frame(maxWidth: .infinity, maxHeight: 600)
              .background(.black)
              .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }

    struct NoAnimalView: View {
        var label: String = "No Animal Selected"

        var body: some View {
            Text(label)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 600)
                .foregroundStyle(.white)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }

    struct ListItem: View {
        let photo: Photo

        var body: some View {
            Image("\(photo.name)")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 3))
        }
    }

    struct ClassifierSelectionView: View {

        @Binding var selectedClassifier: AnimalClassifier
        @Environment(\.dismiss) var dismiss
        var onSelection: () -> ()

        var body: some View {
            NavigationView {
                List {
                    Button(action: {
                        selectedClassifier = AppleAnimalClassifier()
                        dismiss()
                        onSelection()
                    }) {
                        HStack {
                            Text("Apple Animal Classifier")
                            Spacer()
                            if selectedClassifier is AppleAnimalClassifier {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }

                    Button(action: {
                        selectedClassifier = KaggleAnimalClassifier()
                        dismiss()
                        onSelection()
                    }) {
                        HStack {
                            Text("Kaggle Animal Classifier")
                            Spacer()
                            if selectedClassifier is KaggleAnimalClassifier {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .navigationBarTitle("Select Classifier", displayMode: .inline)
            }
        }
    }
}

#Preview {
    ContentView()
}
