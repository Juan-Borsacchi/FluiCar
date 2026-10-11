//
//  AppFeaturesView.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 11/10/26.
//


import SwiftUI

struct AppFeaturesView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    let features: [String] = [
        "O FluiCar é o seu assistente automotivo pessoal. Com ele, você cadastra seu veículo e tem sempre à mão as informações mais importantes, como modelo, ano, quilometragem, tipo de câmbio e muito mais.",
        "O app acompanha a rotina do seu carro de perto, mapeando, de forma automática, as manutenções essenciais e emitindo alertas de vencimento (como o seguro do automóvel) para que você esteja sempre seguro e com tudo em dia.",
        "Além disso, o FluiCar planeja automaticamente a frequência de tarefas preventivas — como a troca de óleo — com base nas especificações do seu modelo. Você recebe um aviso quando a data se aproximar e, ao concluir a tarefa, o aplicativo recalcula o próximo ciclo de forma 100% automática.",
        "Para garantir total autonomia, o FluiCar também oferece tutoriais práticos e diretos que ensinam você a realizar pequenas manutenções com segurança. Nós não apenas ajudamos a gerenciar os cuidados com o seu veículo, mas também ensinamos você a cuidar dele."
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(features, id: \.self) { feature in
                    Text(feature)
                        .font(.body)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(
                                    colorScheme == .light
                                    ? Color.white
                                    : Color(UIColor.systemGray6)
                                )
                        .glassEffect(.regular .interactive(),  in: .rect(cornerRadius: 16))
                        .cornerRadius(16)
                }
            }
            .padding()
        }
        .background(Color.background)
        .navigationTitle("Funcionalidades")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }
}
