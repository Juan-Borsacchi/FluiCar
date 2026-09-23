import SwiftUI

@MainActor
struct AddVehicleView: View {
    @State private var viewModel = AddVehicleViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Selecione o Veículo")) {
                    
                    // 1. Picker de Marca
                    Picker("Marca", selection: $viewModel.selectedBrandCode) {
                        Text("Selecione uma marca").tag("")
                        ForEach(viewModel.brands, id: \.code) { brand in
                            Text(brand.name).tag(String(brand.code))
                        }
                    }
                    
                    // 2. Picker de Modelo
                    Picker("Modelo", selection: $viewModel.selectedModelCode) {
                        Text("Selecione um modelo").tag("")
                        ForEach(viewModel.carModels, id: \.code) { model in
                            Text(model.name).tag(String(model.code))
                        }
                    }
                    .disabled(viewModel.carModels.isEmpty)
                    
                    // 3. Picker de Ano
                    Picker("Ano", selection: $viewModel.selectedYearCode) {
                        Text("Selecione o ano").tag("")
                        ForEach(viewModel.years, id: \.code) { year in
                            Text(year.name).tag(String(year.code))
                        }
                    }
                    .disabled(viewModel.years.isEmpty)
                }
                
                Section {
                    Button(action: {
                        // Chama APENAS a função passando as variáveis já selecionadas
                        viewModel.fetchFipeInformation(
                            brandCode: viewModel.selectedBrandCode,
                            modelCode: viewModel.selectedModelCode,
                            yearCode: viewModel.selectedYearCode
                        )
                    }) {
                        HStack {
                            Spacer()
                            Text("Consultar Preço")
                                .bold()
                            Spacer()
                        }
                    }
                    .disabled(viewModel.selectedYearCode.isEmpty)
                }
            }
            .navigationTitle("Novo Veículo")
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
                // CORREÇÃO: Limpa o MODELO (não a marca)
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
            // NOVO: Alerta nativo do iOS para mostrar o valor
            .alert("Valor da FIPE", isPresented: $viewModel.showPriceAlert, presenting: viewModel.fipeInfo) { info in
                Button("OK", role: .cancel) { }
            } message: { info in
                Text("\(info.model)\nAno: \(info.modelYear)\nPreço: \(info.price)")
            }
        }
    }
}
