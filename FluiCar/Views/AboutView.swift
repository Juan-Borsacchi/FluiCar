//
//  AboutView.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 11/10/26.
//

import SwiftUI

struct AboutView: View {
    @Environment(CoordinatorCore.self) private var coordinator
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    
    let team: [TeamMember] = [
        TeamMember(role: "Designer", name: "Vinicius de Brito", imageName: "vinicius"),
        TeamMember(role: "Desenvolvedora", name: "Isabella Avelina", imageName: "isabella"),
        TeamMember(role: "Desenvolvedor", name: "Leonardo Gonçalves", imageName: "leonardo"),
        TeamMember(role: "Desenvolvedor", name: "Juan Gabriel", imageName: "juan")
    ]
    
    var body: some View {
        List {
            Section {
                Button("Funcionalidades do Aplicativo") {
                    coordinator.push(.appFeatures)
                }
                .foregroundColor(.primary)
                
                Button("Termos de Uso") {
                    coordinator.push(.terms)
                }
                .foregroundColor(.primary)
                
                Button("Política de Privacidade") {
                    coordinator.push(.privacy)
                }
                .foregroundColor(.primary)
            } header: {
                Text("Segurança")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .textCase(nil)
            }
            
            Section {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(team) { member in
                        TeamMemberCard(member: member)
                    }
                }
                .padding(.vertical, 8)
            } header: {
                Text("Equipe Desenvolvedora")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .textCase(nil)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            
            Section {
                Link("fluicarstaff@gmail.com", destination: URL(string: "mailto:fluicarstaff@gmail.com")!)
                    .tint(.blue)
            } header: {
                Text("Dúvidas e melhorias")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .textCase(nil)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.background)
        .navigationTitle("FluiCar")
        .navigationBarTitleDisplayMode(.inline)
    }
}
