//import CoreData
//import Foundation
//import UIKit // Import UIKit for UIApplication
//
//struct PersistenceController {
//    static let shared = PersistenceController()
//
//    let container: NSPersistentContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "MovieEntity")
//        if inMemory {
//            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores { (description, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            } 
//        }
//    }
//    
//    // Load movies from Core Data
//    func loadMovies() -> [Movie] {
//        let context = container.viewContext
//        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
//
//        do {
//            print("Attempting to load movies from coredata")
//            let movieEntities = try context.fetch(fetchRequest)
//            print("Success loading from core data")
//            return movieEntities.compactMap { movieEntity in
//                // Create a Movie object, handling optional values appropriately
//                guard let title = movieEntity.title,
//                      let year = movieEntity.year,
//                      let imdbID = movieEntity.imdbID,
//                      let type = movieEntity.type,
//                      let poster = movieEntity.poster else {
//                    print("MovieEntity has missing properties.")
//                    return nil
//                }
//          
//                return Movie(title: title, year: year, imdbID: imdbID, type: type, poster: poster)
//            }
//        } catch {
//            print("Failed to fetch movies from Core Data: \(error.localizedDescription)")
//            return []
//        }
//    }
//    
//    // Save movies to Core Data
//    func saveMovies(_ movies: [Movie]) {
//        let context = container.viewContext
//
//        // Create a fetch request for MovieEntity
//        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
//        
//        // Create an asynchronous fetch request
//        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { result in
//            if let existingMovies = result.finalResult {
//                for movieEntity in existingMovies {
//                    context.delete(movieEntity)
//                }
//            }
//            for movie in movies {
//                let movieEntity = MovieEntity(context: context)
//                movieEntity.imdbID = movie.imdbID
//                movieEntity.title = movie.title
//                movieEntity.year = movie.year
//                movieEntity.type = movie.type
//                movieEntity.poster = movie.poster
//            }
//
//            do {
//                print("Attempting to save movies to coredata")
//                try context.save()
//                print("Successfully saved movies to Core Data.")
//            } catch {
//                print("Failed to save movies to Core Data: \(error.localizedDescription)")
//            }
//        }
//        do {
//            try context.execute(asyncFetchRequest)
//        } catch {
//            print("Failed to execute asynchronous fetch request: \(error.localizedDescription)")
//        }
//    }
//
//    // Add multiple movies to Core Data
//    func addMovies(_ movies: [Movie]) {
//        let context = container.viewContext
//        for movie in movies {
//            let movieEntity = MovieEntity(context: context)
//            movieEntity.imdbID = movie.imdbID
//            movieEntity.title = movie.title
//            movieEntity.year = movie.year
//            movieEntity.type = movie.type
//            movieEntity.poster = movie.poster
//        }
//        
//        do {
//            try context.save()
//            print("Successfully added movies to Core Data.")
//        } catch {
//            print("Error saving movies: \(error.localizedDescription)")
//        }
//    }
//
//    // Update multiple movies in Core Data
//    func updateMovies(with updatedMovies: [Movie]) {
//        let context = container.viewContext
//        
//        for updatedMovie in updatedMovies {
//            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "imdbID == %@", updatedMovie.imdbID)
//
//            do {
//                let movieEntities = try context.fetch(fetchRequest)
//                if let movieEntity = movieEntities.first {
//                    movieEntity.title = updatedMovie.title
//                    movieEntity.year = updatedMovie.year
//                    movieEntity.type = updatedMovie.type
//                    movieEntity.poster = updatedMovie.poster
//                } else {
//                    print("Movie with IMDB ID \(updatedMovie.imdbID) not found for update.")
//                }
//            } catch {
//                print("Error updating movie: \(error.localizedDescription)")
//            }
//        }
//
//        do {
//            try context.save()
//            print("Successfully updated movies in Core Data.")
//        } catch {
//            print("Error saving updated movies: \(error.localizedDescription)")
//        }
//    }
//
//    // Delete multiple movies from Core Data by IMDB IDs
//    func deleteMovies(imdbIDs: [String]) {
//        let context = container.viewContext
//        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "imdbID IN %@", imdbIDs)
//
//        do {
//            let movieEntities = try context.fetch(fetchRequest)
//            for movieEntity in movieEntities {
//                context.delete(movieEntity)
//            }
//            try context.save()
//            print("Successfully deleted movies from Core Data.")
//        } catch {
//            print("Error deleting movies: \(error.localizedDescription)")
//        }
//    }
//}
