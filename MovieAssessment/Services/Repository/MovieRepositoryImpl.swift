import Foundation
import CoreData

class MovieRepositoryImpl: MovieRepository {
    private let apiKey: String
    private let coreDataManager = CoreDataManager.shared

    init() {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let key = dict["OMDbAPIKey"] as? String {
            self.apiKey = key
        } else {
            fatalError("API key not found in Secrets.plist")
        }
    }

    func fetchMovies(searchTerm: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        if let cachedSearchTerm = coreDataManager.getMovieSearch(for: searchTerm) {
            let movies = cachedSearchTerm.movieitem?.allObjects as? [MovieCoreDataEntity] ?? []
            completion(.success(movies.map { $0.toMovie() }))
            return
        }

        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(searchTerm)&type=movie"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let response = try JSONDecoder().decode(OMDbResponse.self, from: data)
                if response.response == "False" {
                    completion(.success([]))
                } else {
                    self.coreDataManager.saveMovieSearch(term: searchTerm, movies: response.search)
                    completion(.success(response.search))
                }
            } catch {
                completion(.success([]))
            }
        }.resume()
    }

    func fetchMovieDetails(movieID: String, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&i=\(movieID)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }

            do {
                let movieDetails = try JSONDecoder().decode(MovieDetails.self, from: data)
                completion(.success(movieDetails))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension MovieCoreDataEntity {
    func toMovie() -> Movie {
        return Movie(
            imdbID: self.imdbID ?? "",
            title: self.title ?? "",
            poster: self.poster ?? "",
            type: self.type ?? "",
            year: self.year ?? ""
        )
    }
}
