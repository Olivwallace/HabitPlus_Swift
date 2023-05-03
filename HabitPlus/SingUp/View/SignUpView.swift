//
//  SingUpView.swift
//  HabitPlus
//
//  Created by coltec on 25/04/23.
//

import SwiftUI

struct SingUpView: View {
    
    @ObservedObject var viewModel : SingUpViewModel
    
    @State var fullName = ""
    @State var email = ""
    @State var password = ""
    @State var document = ""
    @State var phone = ""
    @State var birthday = ""
    @State var gender = Gender.female
    
    @State var navigationBarHidden = true
    
    var body: some View {
        ZStack{
            if case SingUpUIState.success = viewModel.uiState {
                viewModel.homeView()
            }else{
                ScrollView(showsIndicators: false){
                    VStack(alignment: .center, spacing: 30){
                        Spacer(minLength: 50)
                        VStack(alignment: .center, spacing: 10){
                            
                            //Exibe Imagem Logo
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 20)
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
        TextField("Nome Completo", text: $fullName)
            .border(.clear)
            .textFieldStyle(.roundedBorder)
    }
}

//-------------- Componente de Input Email
extension SingUpView {
    var emailView : some View {
        TextField("Email", text: $email)
            .border(.clear)
            .textFieldStyle(.roundedBorder)
    }
}

//-------------- Componente de Input Password
extension SingUpView {
    var passView : some View {
        SecureField("Password", text: $password)
            .border(.clear)
            .textFieldStyle(.roundedBorder)
    }
}

//-------------- Componente de Input Document
extension SingUpView {
    var documentView : some View {
        TextField("CPF", text: $document)
            .border(.clear)
            .textFieldStyle(.roundedBorder)
    }
}

//-------------- Componente de Input Contato
extension SingUpView {
    var phoneView : some View {
        TextField("Telefone", text: $phone)
            .border(.clear)
            .textFieldStyle(.roundedBorder)
    }
}

//-------------- Componente de Input Nascimento
extension SingUpView {
    var birthdayView : some View {
        TextField("Data Nascimento", text: $birthday)
            .border(.clear)
            .textFieldStyle(.roundedBorder)
    }
}

extension SingUpView {
    var genderView : some View {
        Picker("Genero", selection: $gender){
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
        Button("Concluir Cadastro"){
            viewModel.singUp()
        }
        .border(.clear)
        .buttonStyle(.bordered)
        .foregroundColor(Color.cyan)
        .buttonBorderShape(.roundedRectangle(radius: 15))
        .padding(.vertical, 15)
    }
}


struct SingUpView_Previews: PreviewProvider {
    static var previews: some View {
        SingUpView(viewModel: SingUpViewModel())
    }
}
