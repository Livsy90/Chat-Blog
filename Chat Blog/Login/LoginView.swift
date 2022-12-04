//
//  LoginView.swift
//  Chat Blog
//
//  Created by Livsy on 29.11.2022.
//

import SwiftUI
import PhotosUI

struct LoginView: View {
    
    @State private var selectedItem: PhotosPickerItem?
    @ObservedObject private var vm = LoginViewModel()
    @Environment(\.presentationMode) var presentationMode
    let didFinishLogin: (() -> Void)?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Picker(selection: $vm.isLoginMode, label: Text("Picker"), content: {
                        Text("Login").tag(true)
                        Text("Create Account").tag(false)
                    }).pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical)
                    
                    if !vm.isLoginMode {
                        
                        PhotosPicker(selection: $selectedItem) {
                            ZStack {
                                if let image = vm.selectedImage {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    Image(systemName: "person.fill")
                                }
                            }
                            .frame(width: 160, height: 160)
                            .clipped()
                            .cornerRadius(80)
                            .font(.system(size: 80))
                            .overlay(RoundedRectangle(cornerRadius: 80).stroke(lineWidth: 3))
                            .shadow(radius: 5 )
                        }
                        .onChange(of: selectedItem) { newValue in
                            Task {
                                if let imageData = try? await newValue?.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                                    vm.imageData = imageData
                                    vm.selectedImage = Image(uiImage: image)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Group {
                        TextField("Email", text: $vm.email)
                            .keyboardType(.emailAddress)
                        SecureField("Password", text: $vm.password, onCommit: handleCreateAccount)
                    }.padding()
                        .background(Color.white)
                        .cornerRadius(5)
                    
                    Button(action: handleCreateAccount, label: {
                        HStack {
                            Spacer()
                            Text(vm.isLoginMode ? "Log in" : "Create Account")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }
                    })
                    .disabled(!vm.isButtonEnabled())
                    .padding()
                    .background(vm.isButtonEnabled() ? Color.blue : Color(.systemGray5))
                    .cornerRadius(5)
                    .padding(.top)
                    
                    Text(vm.errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }
                .padding()
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color(white: 0.92).ignoresSafeArea())
            .navigationTitle(vm.isLoginMode ? "Log in" : "Create Account")
        }
    }
    
    private func handleCreateAccount() {
        vm.createAccountOrSignIn {
            didFinishLogin?()
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didFinishLogin: nil)
    }
}
