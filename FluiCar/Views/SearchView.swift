//
//  SearchView.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 06/10/26.
//
import SwiftUI

struct SearchView: View {
    @State var viewModel = SearchViewModel()
    @Environment(CoordinatorCore.self) private var coordinator
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            List{
                if !viewModel.filtredCars.isEmpty {
                    Section(header: Text("Automóveis")) {
                        ForEach(viewModel.filtredCars, id: \.id) { vehicle in
                            Button {
                                coordinator.push(.vehicle(vehicle))
                            } label: {
                                VehicleCardView(brand: vehicle.brand, modelName: vehicle.model, vehicleName: vehicle.name)
                            }
                            .buttonStyle(.plain)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                    }
                }
                if !viewModel.filtredTasks.isEmpty {
                    Section(header: Text("Tarefas")) {
                        ForEach(viewModel.filtredTasks, id: \.id) { row in
                            Button {
                                coordinator.push(.maintenanceDetail(row.ref))
                            } label: {
                                SearchTaskCard(title: row.title, vehicle: row.vehicleName)
                            }
                            .buttonStyle(.plain)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                    }
                }
                if !viewModel.filtredTutorials.isEmpty {
                    Section(header: Text("Tutoriais")) {
                        ForEach(viewModel.filtredTutorials, id: \.self) { tutorial in
                            Button {
                                coordinator.push(.tutorial(tutorial))
                            } label: {
                                TutorialCard(
                                    title: tutorial.tutorialShortcutTitle,
                                    duration: tutorial.duration,
                                    level: tutorial.level
                                )
                            }
                            .buttonStyle(.plain)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                    }
                }
                if !viewModel.searchText.isEmpty &&
                    viewModel.filtredCars.isEmpty &&
                    viewModel.filtredTasks.isEmpty &&
                    viewModel.filtredTutorials.isEmpty
                {
                    Text("Nenhum resultado encontrado para '\(viewModel.searchText)'")
                        .foregroundColor(.gray)
                        .listRowBackground(Color.clear)
                }
                
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationTitle("Pesquisa")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, prompt: "Pesquisar automóveis, tarefas, tutoriais...")
            .task {
                await viewModel.loadData()
            }
        }
    }
}
