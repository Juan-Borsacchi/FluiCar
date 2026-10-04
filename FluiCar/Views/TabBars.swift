//
//  TabBars.swift
//  FluiCar
//
//  Created by Isabella Avelina on 29/09/26.
//

import SwiftUI

enum Tabs: Hashable {
    case carHome
    case maintenance
    case search
}

struct TabBarsView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = true
    @State private var mostrarOnboarding: Bool = true

    @State private var selectedTab: Tabs = .carHome
    @State private var searchString = ""
    @Environment(\.colorScheme) private var colorScheme

    @Environment(CoordinatorCore.self) private var coordinator

    var body: some View {
        @Bindable var bindableCoordinator = coordinator

        TabView(selection: $selectedTab) {
            Tab("Automóvel", systemImage: "car.side.fill", value: .carHome) {
                NavigationStack(path: $bindableCoordinator.carPath) {
                    coordinator.build(.home)
                        .navigationDestination(for: AppRoute.self) { route in
                            coordinator.build(route)
                        }
                }
            }

            Tab("Tarefas", systemImage: "list.bullet.clipboard.fill", value: .maintenance) {
                NavigationStack(path: $bindableCoordinator.maintenancePath) {
                    coordinator.build(.task)
                        .navigationDestination(for: AppRoute.self) { route in
                            coordinator.build(route)
                        }
                }
            }

            Tab("Buscar", systemImage: "magnifyingglass", value: .search, role: .prominent) {
                NavigationStack(path: $bindableCoordinator.searchPath) {
                    Text("Tela de Busca")
                        .navigationTitle("Buscar")
                        .searchable(text: $searchString)
                        .navigationDestination(for: AppRoute.self) { route in
                            coordinator.build(route)
                        }
                }
            }
        }
        .sheet(item: $bindableCoordinator.sheet) { route in
            NavigationStack {
                coordinator.build(route)
            }
        }
        .tabViewStyle(.automatic)
        .onChange(of: selectedTab) { _, newValue in
            coordinator.currentTab = newValue
        }
        .onAppear {
            coordinator.currentTab = selectedTab

            if !hasSeenOnboarding {
                mostrarOnboarding = true
            }
        }
        .sheet(isPresented: $mostrarOnboarding) {
            onboardingView
                .presentationBackground(Color(.systemBackground))
                .interactiveDismissDisabled()
        }
    }

    private var onboardingView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Image("LogoFluiCar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 124, height: 124)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(
                        color: colorScheme == .dark ? .white.opacity(0.12) : .black.opacity(0.10),
                        radius: 15, x: 5, y: 10
                    )
                Spacer()
            }
            .padding(.top, 55)
            .padding(.bottom, 24)

            VStack(alignment: .leading, spacing: 14) {
                Text("Conheça o")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)

                Text("FluiCar")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 54)
            .padding(.bottom, 32)

            VStack(alignment: .leading, spacing: 24) {
                onboardingItem(
                    icon: "car.fill",
                    title: "Cuide dos seus veículos",
                    description: "Tenha as informações essenciais do seu automóvel sempre à mão."
                )

                onboardingItem(
                    icon: "wrench.and.screwdriver.fill",
                    title: "Controle suas manutenções",
                    description: "Receba lembretes automáticos de prazos e manutenções."
                )

                onboardingItem(
                    icon: "inset.filled.topthird.middlethird.bottomthird.rectangle",
                    title: "Veja soluções de problema",
                    description: "Tutoriais para garantir mais autonomia."
                )
            }
            .padding(.horizontal, 52)

            Spacer()

            Button {
                hasSeenOnboarding = true
                mostrarOnboarding = false
            } label: {
                Text("Continuar")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .metallicBackground()
                    .clipShape(.rect(cornerRadius: 55, style: .continuous))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

    private func onboardingItem(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 1) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.primary)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                Text(description)
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    TabBarsView()
        .environment(CoordinatorCore())
}
