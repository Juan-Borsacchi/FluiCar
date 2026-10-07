//
//  AutomobileHomeView.swift
//  FluiCar
//
//  Created by Isabella Avelina on 02/10/26.
//

import SwiftUI
import UIKit

struct AutomobileHomeView: View {
    @State private var viewModel = AutomobileHomeViewModel()
    @Environment(CoordinatorCore.self) private var coordinator

    var body: some View {
        ZStack(alignment: .bottom) {
            Color("Background")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    vehiclesSection
                    tutorialsSection

                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadCars()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Automóveis")
                    .font(.system(size: 24, weight: .semibold))
                    .fixedSize(horizontal: true, vertical: false)
            }
            .sharedBackgroundVisibility(.hidden)

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    coordinator.presentSheet(.addVehicle)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private var vehiclesSection: some View {
        Group {
            if viewModel.hasLoaded {
                if viewModel.cars.isEmpty {
                    EmptyVehiclesCardView {
                        coordinator.presentSheet(.addVehicle)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.cars) { car in
                                NavigationLink(
                                    value: AppRoute.vehicle(car)
                                ) {
                                    AutomobileCardView(
                                        photo: car.photo,
                                        modelName: car.brand,
                                        carName: car.name,
                                        fuelType: car.fuel,
                                        nextTask: viewModel.nextTaskText(for: car)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 8)
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
            }
        }
    }

    private var tutorialsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tutoriais de manutenção")
                .font(.system(size: 24, weight: .semibold))
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    //isabella chamando um foreach pra executar a funcao 
                    ForEach(TaskType.allCases) { taskType in
                        NavigationLink(
                            value: AppRoute.tutorial(taskType)
                        ) {
                            CardTutorials(
                                type: taskType,
                                width: 200,
                                imageHeight: 150
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct EmptyVehiclesCardView: View {
    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "car.fill")
                .font(.system(size: 44))
                .foregroundColor(.gray)

            Text("Ainda não há veículo cadastrado")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(
                "Cadastre seu primeiro automóvel para acompanhar as manutenções e os prazos."
            )
            .font(.subheadline)
            .foregroundColor(.white.opacity(0.7))
            .multilineTextAlignment(.center)

            Button("Adicionar veículo") {
                onAdd()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .metallicBackground()
        .cornerRadius(24)
    }
}

struct AutomobileCardView: View {
    let photo: Data
    let modelName: String
    let carName: String
    let fuelType: String
    let nextTask: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Group {
                if let uiImage = UIImage(data: photo) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    ZStack {
                        Color.gray.opacity(0.3)

                        Image(systemName: "car.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(width: 300, height: 180)
            .clipped()
            .cornerRadius(16)

            HStack(spacing: 10) {
                HStack {
                    Image(systemName: "car.fill")
                        .foregroundColor(.red)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Modelo: \(modelName)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .lineLimit(1)

                        Text(carName)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color(.systemBackground))
                .cornerRadius(12)

                HStack {
                    Image(systemName: "drop.circle.fill")
                        .foregroundColor(.red)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Combustível")
                            .font(.caption2)
                            .foregroundColor(.gray)

                        Text(fuelType)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }

            HStack(spacing: 6) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)

                Text(nextTask)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .frame(width: 335)
        .metallicBackground()
        .cornerRadius(24)
    }
}

#Preview {
    NavigationStack {
        AutomobileHomeView()
            .environment(CoordinatorCore())
    }
}
