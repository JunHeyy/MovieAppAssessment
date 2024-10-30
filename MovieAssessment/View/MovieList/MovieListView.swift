import SwiftUI
import Lottie

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @State private var selectedMovieID: String?
    @State private var searchTerm: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading movies...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    if searchTerm.isEmpty {
                        // Initial empty state with instructions
                        VStack {
                            LottieView(animation: .named("popcorn"))
                                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                                .frame(width: 200, height: 200)
                            
                            Text("Tap Search To Find Your Movies")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding()
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    } else if viewModel.movies.isEmpty {
                        // Display "No Movies Found" when search term has no matches
                        VStack {
                            LottieView(animation: .named("popcorn"))
                                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                                .frame(width: 200, height: 200)
                            
                            Text("No Movies Found")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding()
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    } else {
                        // Display list of movies if there are results
                        List {
                            let movieIndices = Array(stride(from: 0, to: viewModel.movies.count, by: 2))
                            ForEach(movieIndices, id: \.self) { index in
                                HStack {
                                    if index < viewModel.movies.count {
                                        let movie1 = viewModel.movies[index]
                                        NavigationLink(
                                            destination: MovieDetailsView(imdbID: movie1.id),
                                            tag: movie1.id,
                                            selection: $selectedMovieID
                                        ) {
                                            MovieCell(movie: movie1)
                                        }
                                        .simultaneousGesture(TapGesture().onEnded {
                                            selectedMovieID = movie1.id
                                        })
                                    }
                                    
                                    if index + 1 < viewModel.movies.count {
                                        let movie2 = viewModel.movies[index + 1]
                                        NavigationLink(
                                            destination: MovieDetailsView(imdbID: movie2.id),
                                            tag: movie2.id,
                                            selection: $selectedMovieID
                                        ) {
                                            MovieCell(movie: movie2)
                                        }
                                        .simultaneousGesture(TapGesture().onEnded {
                                            selectedMovieID = movie2.id
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Movies")
            .searchable(text: $searchTerm, prompt: "Search movies")
            .onSubmit(of: .search) {
                viewModel.fetchMovies(searchTerm: searchTerm)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
