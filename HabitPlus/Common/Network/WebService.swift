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
        case login = "/auth/login" // Realiza Login.
        
    }
    
    // Possiveis Errors
    enum NetworkError {
        case badRequest
        case notFound
        case unauthorized
        case internalServerError
    }
    
    // Resultados Possiveis
    enum Result{
        case seccess(Data?)
        case failure(NetworkError, Data?)
    }
    
    // Tipos de dados aceitos
    enum ContentType: String {
        case json = "application/json"
        case formUrl = "application/x-www-form-urlencoded"
    }
    
    // Realiza a concatenação da url de chamada da api
    private static func completeUrl(path: EndPoint) -> URLRequest?{
        guard let url = URL(string: "\(EndPoint.base.rawValue)\(path.rawValue)") else { return nil}
        return URLRequest(url: url)
    }
    
    // Call generica que recebe o type de dado que está trabalhando
    static func call<T: Encodable>(path: EndPoint,
                                   body: T,
                                   completion: @escaping (Result) -> Void){
        
        guard let jsonData = try? JSONEncoder().encode(body) else { return }
        
        call(path: path, contentType: .json, data: jsonData , completion: completion)
    }
    
    // Funcao Generica para realizar chamadas API via JSON
    private static func call(path: EndPoint,
                     contentType: ContentType,
                     data: Data?,
                     completion: @escaping (Result) -> Void){
        
        guard var urlRequest = completeUrl(path: path) else {
            return //  Trata algum error
        }
        
        // Cria Requisição
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        
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
                    case 401:
                        completion(.failure(.unauthorized, data))
                        break
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
        
    } // End Funcao Generica para realizar chamadas da API via JSON
    
    // Funcao Generica para realizar chamadas API via FormData
    private static func call(path: EndPoint,
                             params: [URLQueryItem],
                             completion: @escaping (Result) -> Void){
        
        guard let urlRequest = completeUrl(path: path) else { return }
        
        guard let absoluteUrl = urlRequest.url?.absoluteString else { return }
        var components = URLComponents(string: absoluteUrl)
        components?.queryItems = params
        
        call(path: path, contentType: .formUrl, data: components?.query?.data(using: .utf8), completion: completion)
    }// End Funcao Generica para realizar chamadas da API via FormData
    
    
    static func login(request: SignInRequest,
                      completion: @escaping (SignInResponse?, SignInErrorResponse?) -> Void){
        
        call(path: .login, params: [URLQueryItem(name: "username", value: request.email),
                                    URLQueryItem(name: "password", value: request.password)]){ result in
            switch result {
            case .seccess(let data):
                
                if let data = data {
                    let decoder = JSONDecoder()
                    let response = try? decoder.decode(SignInResponse.self, from: data)
                    completion(response, nil)
                }
                break
                // End Success case
                
            case .failure(let error, let data):
                
                if let data = data {
                    if error == .unauthorized{
                        let decoder = JSONDecoder()
                        let response = try? decoder.decode(SignInErrorResponse.self, from: data)
                        completion(nil, response)
                    }
                }
                break
                // End Failuere Case
                
            }
        
        }
        
    }
    
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
