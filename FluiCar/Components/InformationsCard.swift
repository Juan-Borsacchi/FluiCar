//
//  InformationsCard.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 30/09/26.
//
import SwiftUI

struct InformationsCard: View {
    var logo: String
    var name: String
    var information: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Image(systemName: logo)
                .font(.footnote)
                .foregroundStyle(Color.accent)
                .frame(minWidth: 29, idealWidth: 29, maxWidth: 29,minHeight: 29, idealHeight: 29, maxHeight: .infinity)
                
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(name)
                .font(.caption)
                .fontWeight(.regular)
                .foregroundStyle(.gray)
            Text(information)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                
            
        }
        .padding()
        .frame(minWidth: 180, idealWidth: 180, maxWidth: .infinity, minHeight: 102, idealHeight: 102,  maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 17.5))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 17.5)
//                        .stroke(Color.black, lineWidth: 1)
//                )
        

    }
}
#Preview {
    ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea()
            InformationsCard(logo: "car.fill", name: "Modelo", information: "XC60 Ultimate")
        }
}
