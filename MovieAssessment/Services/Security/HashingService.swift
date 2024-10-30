import CryptoKit

class HashingService{
    
    func hashPassword(password: String) -> String {
        let data = password.data(using: .utf8)!
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
}

