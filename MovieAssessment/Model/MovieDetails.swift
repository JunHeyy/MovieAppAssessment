import Foundation

struct Rating: Codable {
    let source: String
    let value: String
    
    private enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

struct MovieDetails: Codable {
    let id: String
    let title: String
    let year: String
    let genre: String
    let director: String
    let plot: String
    let actors: String
    let imdbRating: String
    let posterURL: String
    let imdbVotes: String
    let ratings: [Rating]
    
    // Computed properties to store specific rating values
    var rottenTomatoRating: String?
    var metaCritricRating: String?
    var otherIMDBRating: String?

    // CodingKeys to map JSON keys to struct properties
    private enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case genre = "Genre"
        case director = "Director"
        case plot = "Plot"
        case actors = "Actors"
        case imdbVotes = "imdbVotes"
        case imdbRating = "imdbRating"
        case posterURL = "Poster"
        case ratings = "Ratings"
    }
    
    // Custom initializer to assign specific ratings
    init(from decoder: Decoder) throws {
        // Decode properties using CodingKeys
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(String.self, forKey: .year)
        genre = try container.decode(String.self, forKey: .genre)
        director = try container.decode(String.self, forKey: .director)
        plot = try container.decode(String.self, forKey: .plot)
        actors = try container.decode(String.self, forKey: .actors)
        imdbVotes = try container.decode(String.self, forKey: .imdbVotes)
        imdbRating = try container.decode(String.self, forKey: .imdbRating)
        posterURL = try container.decode(String.self, forKey: .posterURL)
        ratings = try container.decode([Rating].self, forKey: .ratings)
        
        // Not sure if there are more cases
        for rating in ratings {
            switch rating.source {
            case "Rotten Tomatoes":
                rottenTomatoRating = rating.value
            case "Metacritic":
                metaCritricRating = rating.value
            case "Internet Movie Database":
                otherIMDBRating = rating.value
            default:
                break
            }
        }
    }
}
