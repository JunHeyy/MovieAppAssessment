import Foundation
import Combine

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

    private let repository: MovieRepository

    private var cancellables = Set<AnyCancellable>()

    init(repository: MovieRepository = MovieRepositoryImpl()
       ) {
        self.repository = repository
        
//        loadMoviesFromCoreData()
    }

    func fetchMovies(searchTerm: String) {
        isLoading = true
        errorMessage = nil // Reset the error message

        repository.fetchMovies(searchTerm: searchTerm) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let movies):
                    self?.movies = movies
                case .failure(let error):
                    print("Print Error reached: \(error.localizedDescription)") // Log the error
                    self?.errorMessage = error.localizedDescription // Set the error message
                }
            }
        }
    }



//    func loadMoviesFromCoreData() {
//        self.movies = persistenceController.loadMovies()
//    }
//
//    func saveMoviesToCoreData(movies: [Movie]) {
//        persistenceController.saveMovies(movies)
//    }
    
//    func getAllMovie(){
//        do{
//            let coreDataMovies = try context.fetch(MovieItem.fetchRequest())
//        }
//        catch{
//            // Error
//        }
//    }
}
