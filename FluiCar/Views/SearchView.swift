//
//  SearchView.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 06/10/26.
//
import SwiftUI

struct SearchView: View {
    @State var viewModel = SearchViewModel(dataBase: DataService.shared)
    @Environment(CoordinatorCore.self) private var coordinator
    var body: some View {
        List{
            if !viewModel.filtredCars.isEmpty {
                Section(header: Text("Automóveis")){
                    ForEach(viewModel.filtredCars, id: \.id){  vehicle in
                        VehicleCardView(modelName: vehicle.model, vehicleName: vehicle.name)
                    }
                }
            }
            if !viewModel.filtredTasks.isEmpty {
                Section(header: Text("Tarefas")){
                    ForEach(viewModel.filtredTasks, id: \.id){  task in
                        TaskCard(title: task.title, vehicle: task.vehicleName, dueDate: task.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Sem data")
                    }
                }
            }
            if !viewModel.filtredTutorials.isEmpty {
                Section(header: Text("Tutorias")){
                    ForEach(viewModel.filtredTutorials, id: \.title){  tutorial in
                        TutorialCard(title: tutorial.title, duration: tutorial.duration, level: tutorial.level)
                    }
                }
            }
            if !viewModel.searchText.isEmpty &&
                viewModel.filtredCars.isEmpty &&
                viewModel.filtredTasks.isEmpty &&
                viewModel.filtredTutorials.isEmpty {
                Text("Nenhum resultado encontrado para '\(viewModel.searchText)'")
                    .foregroundColor(.gray)
            }
            
        }
        .navigationTitle("Pesquisa")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchText, prompt: "Pesquisar automóveis, tarefas, tutoriais...")
        .task {
            await viewModel.loadData()
        }
    }
}
