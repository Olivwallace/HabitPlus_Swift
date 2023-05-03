//
//  SingInView.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 13/04/23.
//

import SwiftUI

struct SingInView: View {
    
    @ObservedObject var viewModel : SingInViewModel
    
    @State var email : String = ""
    @State var password : String = ""
    
    @State var action: Int? = 0
    
    @State var navigationBarHidden = true
    
    var body: some View {
        ZStack{
            if case SingInUIState.goToHomeScreen = viewModel.uiState {
                viewModel.homeView()
            }else{
                NavigationView{
                    ScrollView(showsIndicators: false){
                        VStack (alignment: .center, spacing: 150){
                            Spacer(minLength: 50)
                            VStack (alignment: .center, spacing: 20) {
                            
                                //Exibe Imagem Logo
                                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.horizontal, 30)
                                    .background(Color.white)
                                
                                Text("Login")
                                    .foregroundColor(.cyan)
                                    .font(.title.bold())
                                    .padding(.horizontal, 8)
                                
                                emailView
                                
                                passView
                                
                                btnLoginView
                                
                                registerView
                                
                            }   //End VStack Interna
                        }       // End VStack Externa
                        
                        //---------------------- Alerta de Error ------------------//
                        if case SingInUIState.error(let value) = viewModel.uiState{
                            Text("")
                            .alert(isPresented: .constant(true)){
                                Alert(
                                    title: Text("HabitPlus"),
                                    message: Text(value),
                                    dismissButton: .default(Text("OK")){
                                        
                                    }
                                )
                            }
                        } // End Alert
                    
                    }// End ScroolView
                    
                    
                }   .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .navigationBarTitle("Login", displayMode: .inline)
                    .navigationBarHidden(navigationBarHidden)  //End Navigation VieW
            }       //End If case - Já logado
        }           //End ZStack
    }               //End Some View
}                   // End View


// --------- Componente de Input Email
extension SingInView {
    var emailView: some View {
        EditTextView(
            placeholder: "E-mail",
            text: $email,
            error: "E-mail Invalido",
            failure: !email.isEmail())
    }
}

// --------- Componente de Input Password
extension SingInView {
    var passView: some View {
        EditTextView(
            placeholder: "Password",
            text: $password,
            error: "Senha deve conter 8 caracteres",
            failure: password.count < 8,
            isSecure: true, keyboard: .emailAddress)
    }
}

// --------- Componente de Button Submit Login
extension SingInView {
    var btnLoginView : some View {
        Button("Entrar"){
            
            viewModel.login(email: email, password: password)
            
        }
        .border(.clear)
        .buttonStyle(.bordered)
        .foregroundColor(Color.cyan)
        .buttonBorderShape(.roundedRectangle(radius: 60))
    }
}

// --------- Componente Tela de Registro
extension SingInView {
    var registerView : some View {
        
        VStack {
            
            Text("Ainda não possui cadastro?")
                .foregroundColor(.gray)
                .padding(.top, 50)
            
            ZStack {
                
                NavigationLink(
                    destination: viewModel.singUpView(),
                    tag: 1,
                    selection: $action,
                    label: {EmptyView()}
                )
                Button("Cadastre-se"){
                    self.action = 1
                }
                
            }
        }
    
    }
}



struct SingInView_Previews: PreviewProvider {
    static var previews: some View {
        SingInView(viewModel: SingInViewModel())
    }
}
