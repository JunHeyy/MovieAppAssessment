import SwiftUI

struct MovieDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = MovieDetailsViewModel()
    var imdbID: String

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let movieDetails = viewModel.movieDetails {
                    
                    // Movie Poster
                    AsyncImage(url: URL(string: movieDetails.posterURL)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    } placeholder: {
                        ProgressView()
                    }

                    // IMDB Rating with Stars and Votes
                    HStack {
                        StarRatingView(rating: movieDetails.imdbRating)
                        Text("\(movieDetails.imdbRating) (\(movieDetails.imdbVotes) votes)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Title and Year
                    Text("\(movieDetails.title) (\(movieDetails.year))")
                        .font(.title)
                        .bold()
                    
                    // Genre
                    Text(movieDetails.genre)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Plot Summary
                    Text("Plot Summary")
                        .font(.headline)
                        .padding(.top, 8)
                    Text(movieDetails.plot)
                        .font(.body)
                    
                    Text("Other Ratings")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            if let rottenTomatoRating = movieDetails.rottenTomatoRating {
                                RatingBoxView(source: RatingSource.rottenTomatoes.rawValue, value: rottenTomatoRating)
                            }
                            if let metaCriticRating = movieDetails.metaCritricRating {
                                RatingBoxView(source: RatingSource.metacritic.rawValue, value: metaCriticRating)
                            }
                            if let otherIMDBRating = movieDetails.otherIMDBRating   {
                                RatingBoxView(source: "Internet Movie Database", value: otherIMDBRating)
                            }
                        }
                    }
                    
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
            }
            .padding()

            .onAppear {
                viewModel.fetchMovieDetails(movieID: imdbID)
            }
            .navigationBarBackButtonHidden(true) // Hide the back button here

        }
    }
}
