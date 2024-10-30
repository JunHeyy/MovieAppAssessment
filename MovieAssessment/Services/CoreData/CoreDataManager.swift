import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MovieCoreData")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Get Request for MoviesList Search Term
    func getMovieSearch(for term: String) -> SearchTerm? {
        print("Searching cache for search term")
        let fetchRequest: NSFetchRequest<SearchTerm> = SearchTerm.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "term == %@", term)
        
        do {
            print("Trying to fetch")
            let results = try context.fetch(fetchRequest)
            print("This is the results \(results.first)")
            return results.first // Return the first matching SearchTerm
        } catch {
            print("Failed to fetch search term: \(error)")
            return nil
        }
    }
    
    // MARK: - Update Request for MoviesList Search Term
    func saveMovieSearch(term: String, movies: [Movie]) {
        let searchTermEntity = SearchTerm(context: context)
        searchTermEntity.term = term
        searchTermEntity.createdAt = Date()
        
        for movie in movies {
            let movieEntity = MovieCoreDataEntity(context: context)
            movieEntity.imdbID = movie.imdbID
            movieEntity.title = movie.title
            movieEntity.poster = movie.poster
            movieEntity.type = movie.type
            movieEntity.year = movie.year
            
            
            if let posterURL = URL(string: movie.poster) {
                downloadImage(from: posterURL) { imageData in
                    movieEntity.imageData = imageData
                    self.saveContext()
                }
            }
            
            searchTermEntity.addToMovieitem(movieEntity)
        }

        // Attempt to save the context
        do {
            print("Saving the movie data")
            try context.save() // Save the context with the new data
            print("Saved")
        } catch {
            print("Failed to save search term: \(error)")
        }
    }
    
    // MARK: - Download Image
    private func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to download image: \(error)")
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }
    
    // MARK: - Delete Request for MoviesList Search Term
    func deleteMovieSearch(for term: String) {
        if let searchTerm = getMovieSearch(for: term) {
            context.delete(searchTerm)
            
            do {
                try context.save()
                print("Successfully deleted search term: \(term) and associated movies")
            } catch {
                print("Failed to delete search term: \(error)")
            }
        } else {
            print("Search term '\(term)' not found in cache")
        }
    }

    // MARK: - Save Context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
