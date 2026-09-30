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
    @State private var viewModel: AddVehicleViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Variáveis de controle para a Foto
    @State private var showActionSheet = false
    @State private var showCamera = false
    @State private var showGallery = false
    @State private var uiImage: UIImage? = nil
    @State private var showRemovePhotoAlert = false
    @State private var showSuccessAlert = false
    
    init(carToEdit: Car? = nil) {
        _viewModel = State(wrappedValue: AddVehicleViewModel(car: carToEdit))
        if let photoData = carToEdit?.photo, let loadedImage = UIImage(data: photoData) {
            _uiImage = State(initialValue: loadedImage)
        } else {
            _uiImage = State(initialValue: nil)
        }
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Button(action: { showActionSheet = true }) {
                        if let uiImage = uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 155, idealWidth: 166, maxWidth: 370, minHeight: 155, idealHeight: 166, maxHeight: 166)
                                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                                .contextMenu {
                                    Button(role: .destructive) {
                                        showRemovePhotoAlert = true
                                    } label: {
                                        Label("Remover Foto", systemImage: "trash")
                                    }
                                }
                                .alert("Remover Foto", isPresented: $showRemovePhotoAlert) {
                                    Button("Remover", role: .destructive) {
                                        withAnimation {
                                            self.uiImage = nil
                                        }
                                    }
                                    Button("Cancelar", role: .cancel) { }
                                } message: {
                                    Text("Tem certeza que deseja remover essa foto?")
                                }
                        } else {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 40))
                                .foregroundStyle(Color.accentColor.opacity(0.7))
                                .frame(minWidth: 120, idealWidth: 166, maxWidth: 166, minHeight: 120, idealHeight: 166, maxHeight: 166)
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 30))
                        }
                    }
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
            .padding(.bottom)
            
            Section {
                if let car = viewModel.carToEdit, !viewModel.isChangingFipe {
                    Picker("Selecione uma marca", selection: $viewModel.selectedBrandCode) {
                        Text("\(car.brand)").tag("")
                        ForEach(viewModel.brands, id: \.code) { brand in
                            Text(brand.name).tag(String(brand.code))
                        }
                    }
                    
                    Picker("Selecione um modelo", selection: $viewModel.selectedModelCode) {
                        Text("\(car.model)").tag("")
                        ForEach(viewModel.carModels, id: \.code) { model in
                            Text(model.name).tag(String(model.code))
                        }
                    }
                    .disabled(viewModel.carModels.isEmpty)
                    
                    Picker("Selecione o ano", selection: $viewModel.selectedYearCode) {
                        Text("\(car.year.description)").tag("")
                        ForEach(viewModel.years, id: \.code) { year in
                            Text(year.name).tag(String(year.code))
                        }
                    }
                    .disabled(viewModel.years.isEmpty)
                    
                } else {
                    Picker("Selecione uma marca", selection: $viewModel.selectedBrandCode) {
                        Text("Marca").tag("")
                        ForEach(viewModel.brands, id: \.code) { brand in
                            Text(brand.name).tag(String(brand.code))
                        }
                    }
                    
                    Picker("Selecione um modelo", selection: $viewModel.selectedModelCode) {
                        Text("Modelo").tag("")
                        ForEach(viewModel.carModels, id: \.code) { model in
                            Text(model.name).tag(String(model.code))
                        }
                    }
                    .disabled(viewModel.carModels.isEmpty)
                    
                    Picker("Selecione o ano", selection: $viewModel.selectedYearCode) {
                        Text("Ano").tag("")
                        ForEach(viewModel.years, id: \.code) { year in
                            Text(year.name).tag(String(year.code))
                        }
                    }
                    .disabled(viewModel.years.isEmpty)
                    
                }
            } footer: {
                Text("• Voce consegue acessar o modelo e o ano do seu veiculo na parte traseira dele ou no manual do carro.")
            }
            
            Section(header: Text("Nome do Carro").textCase(.none).font(.subheadline).bold()){
                TextField("Digite aqui um nome para o seu carro", text: $viewModel.carName)
            }
            
            Section(header: Text("Quilometragem").textCase(.none).font(.subheadline).bold()) {
                TextField("Ex: 15.000 km", text: $viewModel.carKilometers)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.carKilometers) { oldValue, newValue in
                        viewModel.formatKilometers(oldValue: oldValue, newValue: newValue)
                    }
            }
            
            Section(header: Text("Seguro").textCase(.none).font(.subheadline).bold()) {
                Toggle("Possui Seguro?", isOn: $viewModel.insurance)
                    .tint(.green)
                if viewModel.insurance {
                    DatePicker("Alarme", selection: $viewModel.alarm, displayedComponents: .date)
                    Picker("Frequencia", selection: $viewModel.frequency){
                        Text("Mensal").tag(FrequencyType.monthly)
                        Text("Semestral").tag(FrequencyType.semiannual)
                        Text("Anual").tag(FrequencyType.annual)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        
        .navigationTitle(viewModel.carToEdit != nil ? "Editar Veículo" : "Novo Veículo")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            CustomSheetHeader(
                onDismiss: { dismiss() },
                onSave: {
                    if let image = uiImage {
                        viewModel.carPhoto = image.jpegData(compressionQuality: 0.8)
                    }
                    Task {
                        await viewModel.save()
                        showSuccessAlert = true
                    }
                },
                isSaveDisabled: (viewModel.carToEdit == nil || viewModel.isChangingFipe) ? viewModel.selectedYearCode.isEmpty : false            )
        }
        
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .task {
            if viewModel.brands.isEmpty {
                viewModel.fetchBrands()
            }
        }
        .onChange(of: viewModel.selectedBrandCode) { oldValue, newValue in
            viewModel.selectedModelCode = ""
            viewModel.carModels = []
            viewModel.years = []
            
            if !newValue.isEmpty {
                viewModel.fetchModels(brandCode: newValue)
            }
        }
        .onChange(of: viewModel.selectedModelCode) { oldValue, newValue in
            viewModel.selectedYearCode = ""
            viewModel.years = []
            
            if !newValue.isEmpty {
                viewModel.fetchYears(brandCode: viewModel.selectedBrandCode, modelCode: newValue)
            }
        }
        .confirmationDialog("Escolha uma opção", isPresented: $showActionSheet, titleVisibility: .visible) {
            Button("Tirar Foto") { showCamera = true }
            Button("Escolher da Galeria") { showGallery = true }
            Button("Cancelar", role: .cancel) { }
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(selectedImage: $uiImage, sourceType: .camera)
        }
        .sheet(isPresented: $showGallery) {
            GalleryPicker(selectedImage: $uiImage)
        }
        .alert(viewModel.carToEdit != nil ? "Veículo Atualizado" : "Veículo Salvo", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text(viewModel.carToEdit != nil ? "As informações do seu veículo foram atualizadas." : "O veículo foi cadastrado com sucesso!")
        }
    }
}

#Preview("Modo Criação") {
    NavigationStack {
        AddVehicleView()
    }
}

#Preview("Modo Edição") {
    let mockCar = Car(
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
        AddVehicleView(carToEdit: mockCar)
    }
}
