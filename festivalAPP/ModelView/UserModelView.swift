import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User? // Updated to hold a single user
    enum FetchUserResult {
        case success(User)
        case failure(Error)
    }
    // Function now accepts a completion handler
    func fetchUserById(iduser: Int,completion: @escaping (FetchUserResult) -> Void) {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/user/get-user-by-id/\(iduser)") else {
            print("URL is not valid.")
            return
        }

        let token = UserDefaults.standard.string(forKey: "token") ?? ""

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Erreur de récupération de l'utilisateur:", error?.localizedDescription ?? "Erreur inconnue")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonString = String(data: data, encoding: .utf8)
                
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    self.user = userResponse.user}
                    completion(.success(userResponse.user))
            } catch {
                print("Erreur lors de la décodification de l'utilisateur:", error.localizedDescription)
                completion(.failure(error))
               
            }
        }

        task.resume()
    }
}
