//
//  AddVehicleView.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 20/09/26.
//

import SwiftUI
import PhotosUI

@MainActor
struct AddVehicleView: View {
    @State var viewModel: AddVehicleViewModel
    @Environment(CoordinatorCore.self) private var coordinator
    
    @State private var showActionSheet = false
    @State private var showCamera = false
    @State private var showGallery = false
    @State private var showRemovePhotoAlert = false
    @State private var showSuccessAlert = false
    @State private var searchText: String = ""
    
    @State private var savedCarResult: CarModel? = nil
    
    private func closeView() {
        if coordinator.sheet != nil {
            coordinator.dismissSheet()
        } else {
            coordinator.pop()
        }
    }
    
    // MARK: - Body Principal
    var body: some View {
        Form {
            photoSection
            pickersSection
            nameSection
            kilometersSection
            insuranceSection
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(viewModel.carToEdit != nil ? "Editar Automóvel" : "Novo Automóvel")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .overlay { loadingOverlay }
        .task { await viewModel.onAppear() }
        .onChange(of: viewModel.selectedBrandCode) { oldValue, newValue in handleBrandChange(oldValue: oldValue, newValue: newValue) }
        .onChange(of: viewModel.selectedModelCode) { oldValue, newValue in handleModelChange(oldValue: oldValue, newValue: newValue) }
        .confirmationDialog("Escolha uma opção", isPresented: $showActionSheet, titleVisibility: .visible) { actionSheetButtons }
        .sheet(isPresented: $showCamera) { ImagePicker(selectedImage: $viewModel.carUIImage, sourceType: .camera) }
        .sheet(isPresented: $showGallery) { GalleryPicker(selectedImage: $viewModel.carUIImage) }
        .alert(viewModel.carToEdit != nil ? "Automóvel Atualizado" : "Automóvel Salvo", isPresented: $showSuccessAlert) { successAlertButtons } message: { successAlertMessage }
    }
    
    // MARK: - Secções do Formulário
    
    private var photoSection: some View {
        Section {
            HStack {
                Spacer()
                Button(action: { showActionSheet = true }) {
                    if let uiImage = viewModel.carUIImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 155, idealWidth: 166, maxWidth: 370, minHeight: 155, idealHeight: 166, maxHeight: 166)
                            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                            .contextMenu {
                                Button(role: .destructive) { showRemovePhotoAlert = true } label: { Label("Remover Foto", systemImage: "trash") }
                            }
                            .alert("Remover Foto", isPresented: $showRemovePhotoAlert) {
                                Button("Remover", role: .destructive) {
                                    withAnimation {
                                        viewModel.carUIImage = nil
                                        viewModel.didRemovePhoto = true
                                    }
                                }
                                Button("Cancelar", role: .cancel) { }
                            } message: { Text("Tem certeza que deseja remover essa foto?") }
                    } else {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.accentColor)
                            .frame(minWidth: 120, idealWidth: 166, maxWidth: 166, minHeight: 120, idealHeight: 166, maxHeight: 166)
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
                    }
                }
                Spacer()
            }
        }
        .listRowBackground(Color.clear)
        .padding(.bottom)
    }
    
    private var pickersSection: some View {
            Section {
                SearchablePicker(
                    title: "Marca",
                    selection: $viewModel.selectedBrandCode,
                    items: viewModel.brands.map { (String($0.code), $0.name) },
                    fallbackName: viewModel.carToEdit?.brand
                )
                
                SearchablePicker(
                    title: "Modelo",
                    selection: $viewModel.selectedModelCode,
                    items: viewModel.carModels.map { (String($0.code), $0.name) },
                    fallbackName: viewModel.selectedModelCode.isEmpty ? nil : viewModel.carToEdit?.model
                )
                .disabled(viewModel.carModels.isEmpty)
                
                SearchablePicker(
                    title: "Ano",
                    selection: $viewModel.selectedYearCode,
                    items: viewModel.years.map { (String($0.code), viewModel.formatPickerYear($0.name)) },
                    fallbackName: viewModel.selectedYearCode.isEmpty ? nil : (viewModel.carToEdit != nil ? viewModel.formatPickerYear(viewModel.carToEdit!.year.description) : nil)
                )
                .disabled(viewModel.years.isEmpty)
                
            } footer: {
                Text("• Você consegue acessar o modelo e o ano do seu automóvel na parte traseira dele ou no manual do carro.")
                    .padding(.bottom)
            }
        }
    
    private var nameSection: some View {
        Section(header: Text("Nome do Automóvel").textCase(.none).font(.subheadline).bold()) {
            TextField("Digite o nome do seu Automóvel", text: $viewModel.carName)
                .onChange(of: viewModel.carName) { _, newValue in
                    viewModel.carName = viewModel.textLimit(text: newValue, limit: 35)
                }
                
        }
    }
    
    private var kilometersSection: some View {
        Section(header: Text("Quilometragem").textCase(.none).font(.subheadline).bold()) {
            TextField("Ex: 15.000 km", text: $viewModel.carKilometers)
                .disabled(viewModel.selectedYearCode.contains("32000"))
                .keyboardType(.numberPad)
                .onChange(of: viewModel.carKilometers) { oldValue, newValue in
                    viewModel.formatKilometers(oldValue: oldValue, newValue: newValue)
                }
        }
    }
    
    private var insuranceSection: some View {
            Section {
                Toggle("Possui Seguro?", isOn: $viewModel.insurance)
                    .tint(.green)
                
                if viewModel.insurance {
                    DatePicker("Alarme", selection: $viewModel.alarm, displayedComponents: .date)
                    Picker("Frequencia", selection: $viewModel.frequency) {
                        Text("Mensal").tag(FrequencyType.monthly)
                        Text("Semestral").tag(FrequencyType.semiannual)
                        Text("Anual").tag(FrequencyType.annual)
                    }
                }
            } header: {
                Text("Seguro")
                    .textCase(.none)
                    .font(.subheadline)
                    .bold()
            } footer: {
                Text("• Adicione um alarme para não esquecer de pagar seu seguro.")
                    .padding(.bottom)
            }
        }
    
    // MARK: - Modifiers Separados
    
    private var toolbarContent: some ToolbarContent {
            CustomSheetHeader(
                onDismiss: { closeView() },
                onSave: {
                    Task {
                        if let savedCar = await viewModel.save() {
                            self.savedCarResult = savedCar
                            showSuccessAlert = true
                        }
                    }
                },
                isSaveDisabled: viewModel.selectedYearCode.isEmpty
            )
        }
    
    @ViewBuilder
    private var loadingOverlay: some View {
        if viewModel.isLoading {
            ProgressView()
                .scaleEffect(1.5)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    @ViewBuilder
    private var actionSheetButtons: some View {
        Button("Tirar Foto") { showCamera = true }
        Button("Escolher da Galeria") { showGallery = true }
        Button("Cancelar", role: .cancel) { }
    }
    
    @ViewBuilder
    private var successAlertButtons: some View {
        Button("OK") {
            let savedCar = savedCarResult
            let isCreating = viewModel.carToEdit == nil
            
            closeView()
            
            if isCreating, let car = savedCar {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    coordinator.push(.vehicle(car))
                }
            }
        }
    }
    
    private var successAlertMessage: some View {
        Text(viewModel.carToEdit != nil ? "As informações do seu Automóvel foram atualizadas." : "O Automóvel foi cadastrado com sucesso!")
    }
    
    // MARK: - Handlers
    
    private func handleBrandChange(oldValue: String, newValue: String) {
            guard oldValue != newValue, !newValue.isEmpty else { return }
            
            if viewModel.isInitialLoading { return }
            
            viewModel.carModels = []
            viewModel.years = []
            viewModel.selectedModelCode = ""
            viewModel.selectedYearCode = ""
            viewModel.fetchModels(brandCode: newValue)
        }
        
        private func handleModelChange(oldValue: String, newValue: String) {
            guard oldValue != newValue, !newValue.isEmpty else { return }
            
            if viewModel.isInitialLoading { return }
            
            // Limpa apenas o Ano quando o Modelo muda
            viewModel.years = []
            viewModel.selectedYearCode = ""
            viewModel.fetchYears(brandCode: viewModel.selectedBrandCode, modelCode: newValue)
        }
}

// MARK: - Previews

#Preview("Modo Criação") {
    NavigationStack {
        AddVehicleView(viewModel: AddVehicleViewModel())
    }
    .environment(CoordinatorCore())
}

#Preview("Modo Edição") {
    let mockCar = CarModel(
        id: UUID(),
        photo: Data(),
        name: "Batmóvel",
        brand: "Ford",
        model: "Mustang",
        year: 1969,
        fuel: "Gasolina",
        kilometers: "15000",
        fipeValue: "350000.00",
        insurance: true,
        alarm: Date(),
        frequency: .annual
    )
    
    NavigationStack {
        AddVehicleView(viewModel: AddVehicleViewModel(car: mockCar))
    }
    .environment(CoordinatorCore())
}
