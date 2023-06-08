//
//  CreateFlowView.swift
//  Banking
//
//  Created by Toby Clark on 15/5/2023.
//

import Foundation
import SwiftUI


struct CreateFlowView: View {
    var auth: Auth
    @State var username: String = ""
    @State var password: String = ""
    @State var screen = ""
    @State var pin: String = ""
    @State var enable_biometrics: Bool = false
    @StateObject var name: UsersName = UsersName(fName: "", lName: "")
    
    init (_ auth: Auth, _ switch_method: () -> Void) {
        self.auth = auth
    }
    
    func userPassComplete () {
        screen = "info"
    }

    func pinBioComplete () {
        Task {
            do {
                try await auth.createUser(username: username, password: password, name: name, pin: pin, biometrics: .biometrics)
            } catch let error as AuthError {
                print(type(of: error))
                print(error.kind, error.error, error.message as Any)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func infoComplete () {
        screen = "alternatives"
    }
    
    var body: some View {
        VStack {
            Text("SimpliFunds")
                .font(.h1)
                .bAlignment(.center)
            switch screen {
                case "info": CreateUserInfo(finish: infoComplete, name: name)
            case "alternatives": CreatePinAndBio(finish: pinBioComplete, pin:$pin, bio:$enable_biometrics)
                default: CreateUserPass(finish: userPassComplete, username: $username, password: $password)
            }
        }
        .font(.normal)
    }
}


struct CreateUserPass: View {
    let finish: () -> Void
    @Binding var username: String
    @Binding var password: String
    
    
    var body: some View {
            VStack {
                TextField("Email", text: $username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textFieldStyles()
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $password)
                    .textFieldStyles()
                Button("Next", action: {() in finish()})
                    .buttonStyles(.secondary.light)
            }
            .vAlignment(.top)
            .hAlignment(.center)
            .textFieldStyle(.roundedBorder)
    }
}

struct CreatePinAndBio: View {
    let finish: () -> Void
    @Binding var pin: String
    @Binding var bio: Bool
    
    var body: some View {
        SecureField("Pin", text: $pin)
            .keyboardType(.numberPad)
            .textFieldStyles()
        Toggle("Enable biometrics", isOn: $bio)
            .buttonStyles(.secondary.light)
        Button("Skip", action: {() in finish()})
            .buttonStyles(.secondary.light)
        Button("Submit", action: {() in finish()})
            .buttonStyles(.secondary.light)
    }
}


struct CreateUserInfo: View {
    let finish: () -> Void
    @ObservedObject var name: UsersName
    
    var body: some View {
        VStack {
            TextField("Name", text:$name.fName)
                .textFieldStyles()
            Button("Next", action: {() in finish()})
                .buttonStyles(.secondary.light)
        }
        .vAlignment(.top)
        .hAlignment(.center)
        .textFieldStyle(.roundedBorder)
    }
}
