//
//  UserRow.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 21/09/24.
//

import SwiftUI

struct SiteUserItem: View {
    let user: UserModel
    @StateObject var mainManager = MainManager()
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text((user.name ?? "Не указано") + " " + (user.lastName ?? ""))
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                if user.active == "Y" {
                    Text("Активен")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("Неактивен")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.gray)
                Text(user.login)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text("Зарегистрирован: \(user.dateRegister ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color("CardColor"))
        .cornerRadius(15)
        .shadow(color: Color("Accent"), radius: 1)

    }
}

struct MobileUserItem: View {
    let user: UserDataModel
    @StateObject var mainManager = MainManager()
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(fullName(user: user))
                    .font(.headline)
                    .foregroundColor(Color("Accent"))
                    .fontWeight(.bold)
                Spacer()
                if user.status == "Y" {
                    Text("Активен")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("Неактивен")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.gray)
                Text(user.phone)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text("Зарегистрирован: \(user.dateRegistered)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color("CardColor"))
        .cornerRadius(15)
        .shadow(color: Color("Accent"), radius: 1)

    }
    
    private func fullName(user: UserDataModel) -> String {
        let firstName = user.firstName
        let lastName = user.lastName
        if (firstName.isEmpty) && (lastName.isEmpty) {
            return "Не указано"
        }
        return "\(String(describing: firstName)) \(String(describing: lastName))".trimmingCharacters(in: .whitespaces)
    }
}
