//
//  WebService.swift
//  HabitPlus
//
//  Created by coltec on 18/05/23.
//

import Foundation
enum WebService{
    
    // -------------------- Define EndPoints
    enum EndPoint: String{
        // ------------- Dominio API
        case base = "https://habitplus-api.tiagoaguiar.co/"
        
        // ------------- Rotas API
        case postUser = "/users" // Cadastra novo usuario.
    }
    
    enum NetworkError {
        case badRequest
        case notFound
        case unauthorized
        case internalServerError
    }
    
    enum Result{
        case seccess(Data?)
        case failure(NetworkError, Data?)
    }
    
    private static func completeUrl(path: EndPoint) -> URLRequest?{
        guard let url = URL(string: "\(EndPoint.base.rawValue)\(path.rawValue)") else { return nil}
        return URLRequest(url: url)
    }
    
    // Funcao Generica para realizar chamadas
    static func call<T: Encodable>(path: EndPoint,
                                   body: T,
                                   completion: @escaping (Result) -> Void){
        
        guard let jsonData = try? JSONEncoder().encode(body) else { return }
        
        guard var urlRequest = completeUrl(path: path) else {
            return //  Trata algum error
        }
        
        // Cria Requisição
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        // Realiza chamada assincrona
        let task = URLSession.shared.dataTask(with: urlRequest){
            data, response, error in
            
            // Se der erro nil e imprime erro
            guard let data = data, error == nil else{
                completion(.failure(.internalServerError, nil))
                return
            }
            
            // Abre a resposta da API
            if let r = response as? HTTPURLResponse{
                switch r.statusCode {
                    case 400:
                        completion(.failure(.badRequest, data))
                        break
                    case 200:
                        completion(.seccess(data))
                        break
                    default:
                        break
                }
            }
            
        }// Finalização da montagem de chamada para API.
        
        task.resume() // Realiza a chamada
        
    } // End Funcao Generica para realizar chamadas da API

    
    static func postUser(request: SingUpRequest,
                         completion: @escaping (Bool?, ErrorResponse?) -> Void){
        
        call(path: .postUser, body: request){ result in
            
            switch result {
            case .seccess(let data):
                
                if let data = data {
                    completion(true, nil)
                }
                break
                // End Success
                
            case .failure(let error, let data):
                
                if let data = data {
                    if error == .badRequest {
                        let decoder = JSONDecoder()
                        let response = try? decoder.decode(ErrorResponse.self, from: data)
                        completion(nil, response)
                    }
                }
                break
                // End Failure
                
            } // End Switch
            
        } // End Call
        
    } // End postUser
}
