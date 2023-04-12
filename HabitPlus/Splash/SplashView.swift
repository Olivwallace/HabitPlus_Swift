//
//  SplashView.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 11/04/23.
//

import SwiftUI

// Definicão de View Loading - SplashView
struct SplashView: View {
    
    @State var state : SplashUIState = .error("Erro ao Iniciar") //Define estado inicial para loading
    @State var error : Bool = false
    
    var body: some View {
        switch state {
            case .loading:
                loadingView()
            
            case .goToSingInScreen :
                Text("Loading SingIn Screen")
            
            case .goToHomeScreen :
                Text("Loading Home Screen")
            
            case .error(let errMsg) :
                loadingView(error: errMsg)
        }
    }
} // Fim SplashView


// Extension de SplashView que define funcão de componente loading.
extension SplashView {
    func loadingView(error: String? = nil) -> some View {
        ZStack{
            
            //Exibe Imagem Logo
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(20)
                .background(Color.white)
                .ignoresSafeArea()
            
            // Se error -> Exibe alert com mensagem
            if let error = error {
                Text("")
                    .alert(isPresented: .constant(true)){
                        Alert(title: Text("HabitPlus"),
                            message: Text(error),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            } // Fim Error
        
        }
    }
} //Fim Extension SplashView

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

