//
//  LoginManager.swift
//  Thursday
//
//  Created by Scott Begin on 11/21/22.
//

import Foundation

@MainActor class LoginManager  {
    
    let server = AppConstants.amazonEBUrl
    
    func doLogin (email: String, password: String) async throws {
        
        struct LoginResponse: Decodable {
            struct User: Decodable {
                var pk: Int
                var username, email, first_name, last_name: String }
            let key: String
            let user: User
        }
        
        print("in doLogin")
        let url = URL(string: server+"dj-rest-auth/login/")!
        var request = URLRequest(url: url)
        let body = ["email": email, "password": password]
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = bodyData
        print(request)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
//            print(String(data: data, encoding: String.Encoding.utf8) )
//            print(response)
            let loadData = try JSONDecoder().decode(LoginResponse.self, from: data)
            UserDefaults.standard.set(loadData.key, forKey: "userToken")
            UserDefaults.standard.set(loadData.user.pk, forKey: "userId")
            ThursdayApp.Authenticated.send(true)
//            print("out doLogin")
        } catch let error {
            print("doLogin - Error decoding: ", error)
            throw error
        }
    }
    
    func doRegister (username: String, email: String, password: String) async throws -> User{
        var dataResponse = ""
        struct RegisterResponse: Decodable {
            struct User: Decodable {
                var pk: Int
                var username, email, first_name, last_name: String }
            let key: String
            let user: User
        }
        
        let url = URL(string: server+"dj-rest-auth/registration/")!
        var request = URLRequest(url: url)
        let body = ["username": username, "email": email, "password1": password, "password2": password]
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print(String(data: data, encoding: String.Encoding.utf8)!)
            print(response)
            let loadData = try JSONDecoder().decode(RegisterResponse.self, from: data)
            UserDefaults.standard.set(loadData.key, forKey: "userToken")
            UserDefaults.standard.set(loadData.user.pk, forKey: "userId")
            
            print("Registration.....")
            print(loadData)
            
            return await getUserById(id: String(loadData.user.pk))// loadData.user
            
//            ThursdayApp.Authenticated.send(true)
        } catch {
            print("Error decoding: ", error)
            throw ThursError.registrationError(message: dataResponse)
        }
    }

    
    func doLogout () async {
        let url = URL(string: server+"dj-rest-auth/logout/")!
        var request = URLRequest(url: url)
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let (_, _) = try await URLSession.configSession.data(for: request)
            UserDefaults.standard.removeObject(forKey: "userToken")
            ThursdayApp.Authenticated.send(false)
        } catch let error {
            print("Error decoding: ", error)
        }
    }

    
    func getUserById(id: String) async -> User {
       
        guard let url = URL(string: server+"thursday/users/"+id) else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.configSession.data(for: urlRequest)
            return try JSONDecoder().decode(User.self, from: data)
        } catch let error {
            print("getUrserById - Error decoding: ", error)
            return AppConstants.defaultUser
        }
    }
    
    func deactivateUser(id: String) async {
        
        guard let url = URL(string: server+"thursday/users/"+id+"/") else { fatalError("Missing URL") }
        var request = URLRequest(url: url)
        let json: [String: Any] = ["is_active": "false"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.configSession.data(for: request)
            removeCookies()
            print(response)
            print(String(data: data, encoding: String.Encoding.utf8)!)
//            return try JSONDecoder().decode(User.self, from: data)
        } catch let error {
            print("getUrserById - Error decoding: ", error)
//            return AppConstants.defaultUser
        }
        
    }
    
    func removeCookies(){
        let cookieJar = HTTPCookieStorage.shared

        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
    
}
