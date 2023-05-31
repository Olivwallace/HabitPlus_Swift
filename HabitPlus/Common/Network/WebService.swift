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
        case refreshToken = "/auth/refresh-token" // Recuperar Token
        
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
        case success(Data?)
        case failure(NetworkError, Data?)
    }
    
    // Tipos de dados aceitos
    enum ContentType: String {
        case json = "application/json"
        case formUrl = "application/x-www-form-urlencoded"
    }
    
    // Define Metodo de Chamada
    enum Method: String{
        case get
        case post
        case put
        case delete
    }
    
    // Realiza a concatenação da url de chamada da api
    private static func completeUrl(path: EndPoint) -> URLRequest?{
        guard let url = URL(string: "\(EndPoint.base.rawValue)\(path.rawValue)") else { return nil}
        return URLRequest(url: url)
    }
    
    // Call generica que recebe o type de dado que está trabalhando
    static func call<T: Encodable>(path: EndPoint,
                                   method: Method = .get,
                                   body: T,
                                   completion: @escaping (Result) -> Void){
        
        guard let jsonData = try? JSONEncoder().encode(body) else { return }
        
        call(path: path, method: method, contentType: .json, data: jsonData , completion: completion)
    }
    
    // Funcao Generica para realizar chamadas API via JSON
    public static func call(path: EndPoint,
                            method: Method,
                            contentType: ContentType,
                            data: Data?,
                            completion: @escaping (Result) -> Void){
                
        guard var urlRequest = completeUrl(path: path) else {
            return //  Trata algum error
        }
        
        _ = LocalDataSource.shared.getUserAuth()
            .sink{ userAuth in
                if let userAuth = userAuth{
                    urlRequest.setValue("\(userAuth.tokenType)", forHTTPHeaderField: "Authorization")
                }
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
                            completion(.success(data))
                            break
                        default:
                            break
                    }
                }
            }// Finalização da montagem de chamada para API.
        
            task.resume() // Realiza a chamada
        
    } // End Funcao Generica para realizar chamadas da API via JSON
    
    // Funcao Generica para realizar chamadas API via FormData
    public static func call(path: EndPoint,
                            method: Method = .post,
                            params: [URLQueryItem],
                            completion: @escaping (Result) -> Void){
        
        guard let urlRequest = completeUrl(path: path) else { return }
        
        guard let absoluteUrl = urlRequest.url?.absoluteString else { return }
        var components = URLComponents(string: absoluteUrl)
        components?.queryItems = params
        
        call(path: path, method: method, contentType: .formUrl, data: components?.query?.data(using: .utf8), completion: completion)
    }// End Funcao Generica para realizar chamadas da API via FormData
    
}
