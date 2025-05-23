//
//  ProjectButton.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 08.04.2025.
//

import SwiftUI

struct ProjectButton: View {
    @State var projectTitle: String
    @State var projectDescription: String
    @State var projectImage: String
    var body: some View {
            ZStack{
                RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color("CardColor"))
                    .shadow(color: Color("Primary"), radius: 2)
                HStack{
                    VStack(alignment: .leading,  spacing: 5){
                        Text(projectTitle)
                            .fontWeight(.medium)
                            .foregroundStyle(Color("Accent"))
                            .font(.system(size: 19))
                            .font(.headline)
                        Text(projectDescription)
                            .foregroundStyle(Color("Accent").opacity(0.5))
                            .font(.system(size: 16))
                            .font(.body)
                        
                    }.padding(.leading, 30)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Circle().fill(Color("Primary")).opacity(0.1)
                        .frame(width: 60, height: 60)
                        .overlay{
                            Image(systemName: projectImage)
                                .font(.system(size: 22.5))
                                .foregroundStyle(Color("Primary"))
                        }
                        .padding(.trailing, 20)
                }
                .frame(maxWidth: .infinity, minHeight: 95, maxHeight: 100)
                .cornerRadius(20)
                .padding(.vertical, 3)
            }
        }
}

