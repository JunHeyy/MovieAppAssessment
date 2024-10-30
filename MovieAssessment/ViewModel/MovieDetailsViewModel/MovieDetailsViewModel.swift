import Foundation
import Combine

class MovieDetailsViewModel: ObservableObject {
    @Published var movieDetails: MovieDetails?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository: MovieRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: MovieRepository = MovieRepositoryImpl()) {
        self.repository = repository
    }

    
    func fetchMovieDetails(movieID: String) {
        isLoading = true
        errorMessage = nil
        repository.fetchMovieDetails(movieID: movieID) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let details):
                    self?.movieDetails = details
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
