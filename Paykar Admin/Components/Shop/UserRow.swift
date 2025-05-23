//
//  UserRow.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 02/09/24.
//

import SwiftUI

struct UserRow: View {
    let user: UserModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(fullName(user: user))
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                if user.active == "Y" {
                    Text("Активен")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("Не Активен")
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
                Text("Зарегистрирован: \(formattedDateToString(user.dateRegister))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // Helper function to create full name
    private func fullName(user: UserModel) -> String {
        let firstName = user.name ?? ""
        let lastName = user.lastName ?? ""
        if firstName.isEmpty && lastName.isEmpty {
            return "Не указано"
        }
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
