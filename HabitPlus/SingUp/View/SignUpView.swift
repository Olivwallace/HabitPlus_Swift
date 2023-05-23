//
//  SingUpView.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 25/04/23.
//

import SwiftUI

struct SingUpView: View {
    
    @ObservedObject var viewModel : SingUpViewModel

    @State var navigationBarHidden = true
    
    var body: some View {
        ZStack{
            if case SingUpUIState.success = viewModel.uiState {
                viewModel.homeView()
            }else{
                ScrollView(showsIndicators: false){
                    VStack(alignment: .center, spacing: 5){
                        Spacer(minLength: 40)
                        VStack(alignment: .center, spacing: 15){
                            
                            //Exibe Imagem Logo
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 10)
                                .background(Color.white)
                            
                            Text("Cadastro")
                                .foregroundColor(.cyan)
                                .font(.title.bold())
                                .padding(.vertical, 15)
                            
                            fullNameView
                            emailView
                            passView
                            documentView
                            phoneView
                            birthdayView
                            genderView
                            btnSingUpView
                            
                        }   // End VStack Interna
                    }       // End VStack Externa
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 32)
                .background(Color.white)
                 // End ScroolView
                
                //---------------------- Alerta de Error ------------------//
                if case SingUpUIState.error(let value) = viewModel.uiState{
                    Text("")
                    .alert(isPresented: .constant(true)){
                        Alert(
                            title: Text("HabitPlus"),
                            message: Text(value),
                            dismissButton: .default(Text("OK")){
                            
                            }
                        )
                    }
                }           // End Alert
            }               // End if-else
        }                   // End ZStack
    }                       // End Some View
}                           // End View

//-------------- Componente de Input Name
extension SingUpView {
    var fullNameView : some View {
        EditTextView(
            placeholder: "Digite seu Nome Completo",
            text: $viewModel.fullName,
            error: "Comprimento do nome inválido",
            failure: viewModel.fullName.count < 3)
    }
}

//-------------- Componente de Input Email
extension SingUpView {
    var emailView : some View {
        EditTextView(
            placeholder: "Digite seu Email",
            text: $viewModel.email,
            error: "Email inválido",
            failure: !viewModel.email.isEmail(),
            keyboard: .emailAddress)
    }
}

//-------------- Componente de Input Password
extension SingUpView {
    var passView : some View {
        EditTextView(
            placeholder: "Digite sua Senha",
            text: $viewModel.password,
            error: "Senha inválida",
            failure: viewModel.password.count < 8,
            isSecure: true,
            keyboard: .emailAddress)
    }
}

//-------------- Componente de Input Document
extension SingUpView {
    var documentView : some View {
        EditTextView(
            placeholder: "Digite seu CPF",
            text: $viewModel.document,
            error: "CPF inválido - Somente Números",
            failure: viewModel.document.count != 11,
            keyboard: .numberPad)
    }
}

//-------------- Componente de Input Contato
extension SingUpView {
    var phoneView : some View {
        EditTextView(
            placeholder: "Digite um Número de Contato",
            text: $viewModel.phone,
            error: "Telefone/Celular inválido - (99)99999-9999",
            failure: viewModel.phone.count < 10 && viewModel.phone.count > 11 ,
            keyboard: .numberPad)
    }
}

//-------------- Componente de Input Nascimento
extension SingUpView {
    var birthdayView : some View {
        EditTextView(
            placeholder: "Digite sua Data de Nascimento",
            text: $viewModel.birthday,
            error: "Data inválida - DD/MM/AAAA",
            failure: viewModel.birthday.count != 10,
            keyboard: .default
        )
    }
}

extension SingUpView {
    var genderView : some View {
        Picker("Genero", selection: $viewModel.gender){
            ForEach(Gender.allCases, id: \.self){
                value in
                Text(value.rawValue)
                    .tag(value)
            }
        }
        .pickerStyle(.segmented)
    }
}

// --------- Componente de Button Submit Login
extension SingUpView {
    var btnSingUpView : some View{
        LoadingButtonView(action:{
            viewModel.singUp()
        },
            text: "Concluir Cadastro",
                          disabled: !viewModel.email.isEmail() ||
                          viewModel.password.count < 8 || viewModel.fullName.count < 3 ||
                          viewModel.document.count != 11 || viewModel.phone.count < 10 ||
                          viewModel.phone.count > 11 || viewModel.birthday.count != 10,
            showProgress:  self.viewModel.uiState == SingUpUIState.loading
        )
    }
}


struct SingUpView_Previews: PreviewProvider {
    static var previews: some View {
        SingUpView(viewModel: SingUpViewModel())
    }
}
