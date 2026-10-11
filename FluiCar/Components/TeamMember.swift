//
//  TeamMember.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 11/10/26.
//


import SwiftUI

struct TeamMember: Identifiable {
    let id = UUID()
    let role: String
    let name: String
    let imageName: String
}

struct TeamMemberCard: View {
    let member: TeamMember
    
    var body: some View {
        VStack(spacing: 8) {
            
            ZStack {
                Image(member.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: member.name.contains("Isabella") ? 125 : 100,
                        height: member.name.contains("Isabella") ? 125 : 100
                    )
                    .offset(y: member.name.contains("Isabella") ? 4 : 0)
            }
            .frame(width: 110, height: 110)
            .padding(.top, 16)
            
            VStack(spacing: 2) {
                Text(member.role)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(member.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 4)
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}
