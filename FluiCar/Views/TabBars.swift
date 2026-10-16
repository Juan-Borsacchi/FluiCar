//
//  TabBars.swift
//  FluiCar
//
//  Created by Isabella Avelina on 29/09/26.
//

import SwiftUI
import UIKit

enum Tabs: Hashable {
    case carHome
    case maintenance
    case search
}

enum LegalDocumentType: String, Identifiable {
    case term
    case privacy
    var id: String { rawValue }
}

struct TabBarsView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var mostrarOnboarding: Bool = false

    @State private var selectedTab: Tabs = .carHome
    @State private var searchString = ""
    
    @State private var documentToPresent: LegalDocumentType?
    
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
                    coordinator.build(.search)
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
                .fullScreenCover(item: $documentToPresent) { docType in
                    NavigationStack {
                        Group {
                            if docType == .term {
                                LegalDocumentView(viewModel: LegalDocumentViewModel(documentType: .termsOfUse))
                            } else {
                                LegalDocumentView(viewModel: LegalDocumentViewModel(documentType: .privacyPolicy))
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    documentToPresent = nil
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "chevron.left")
                                            .fontWeight(.semibold)
                                        Text("Voltar")
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }

    private var onboardingView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                if let appIcon = Bundle.main.appIcon {
                    Image(uiImage: appIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 124, height: 124)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .shadow(
                            color: colorScheme == .dark ? .white.opacity(0.12) : .black.opacity(0.10),
                            radius: 15, x: 5, y: 10
                        )
                }
                Spacer()
            }
            .padding(.top, 40)
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
                    title: "Cuide dos seus automóveis",
                    description: "Tenha as informações essenciais do seu automóvel sempre à mão."
                )

                onboardingItem(
                    icon: "wrench.and.screwdriver.fill",
                    title: "Controle suas manutenções",
                    description: "Receba lembretes automáticos de prazos e manutenções."
                )

                onboardingItem(
                    icon: "inset.filled.topthird.middlethird.bottomthird.rectangle",
                    title: "Veja soluções de problemas",
                    description: "Tutoriais para garantir mais autonomia."
                )
            }
            .padding(.horizontal, 48)

            Spacer()
            
            Text("Tocar em **continuar** implica que você leu e aceitou \n nossos [Termos de Uso](fluicar://term) e a nossa [Política de Privacidade](fluicar://privacy)")
                .font(.footnote)
                .foregroundColor(.secondary)
                .tint(.blue)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 32)
                .environment(\.openURL, OpenURLAction { url in
                    if url.absoluteString == "fluicar://term" {
                        documentToPresent = .term
                        return .handled
                    } else if url.absoluteString == "fluicar://privacy" {
                        documentToPresent = .privacy
                        return .handled
                    }
                    return .discarded
                })
            
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
            .padding(.horizontal, 20)
        }
    }
}

extension Bundle {
    var appIcon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}


#Preview {
    TabBarsView()
        .environment(CoordinatorCore())
}

