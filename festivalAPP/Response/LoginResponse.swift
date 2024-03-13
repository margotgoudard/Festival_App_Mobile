struct LoginResponse: Codable {
    let auth: Bool
    let token: String
    let user: User?
}
