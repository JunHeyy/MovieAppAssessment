struct Movie: Codable, Identifiable {
    var id: String { imdbID } // Used for looping
    let imdbID: String
    let title: String
    let poster: String
    let type: String
    let year: String
    
    

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

struct OMDbResponse: Codable {
    let search: [Movie]
    let totalResults: String
    let response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}



