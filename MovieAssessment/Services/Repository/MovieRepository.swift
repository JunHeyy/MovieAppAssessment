protocol MovieRepository {
    func fetchMovies(searchTerm: String, completion: @escaping (Result<[Movie], Error>) -> Void)
    func fetchMovieDetails(movieID: String, completion: @escaping (Result<MovieDetails, Error>) -> Void)
}
