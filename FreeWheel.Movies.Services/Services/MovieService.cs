using Dapper;
using FreeWheel.Movies.Services.Interfaces;
using FreeWheel.Movies.Services.Model;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace FreeWheel.Movies.Services.Services
{
    public class MovieService : IMovieService
    {
        readonly IStoreService _storeService;

        public MovieService(IStoreService storeService)
        {
            _storeService = storeService;
        }

        public Task<IEnumerable<Movie>> GetMoviesByGenre(string genre)
        {
            return _storeService.QueryAsync<Movie>(@"SELECT M.MovieId as Id,M.Title,
	                                                   M.YearRelease, M.RunningTime,
	                                                   dbo.GetMovieGenres(M.MovieId) as 'Genres',
	                                                   dbo.GetMovieRating(M.MovieId) as 'AverageRating'
                                                    FROM 
	                                                    Movie M
	                                                    inner join MovieByGenre MG on MG.MovieId = M.MovieId
	                                                    inner join Genre G on MG.GenreId = G.GenreId
                                                    WHERE
	                                                    G.Description like @genre;", new { genre = new DbString { Value = string.Concat("%", genre, "%") } });
        }

        public Task<IEnumerable<Movie>> GetMoviesByTitle(string title)
        {
            return _storeService.QueryAsync<Movie>(@"SELECT M.MovieId as Id, M.Title, 
                                                       M.YearRelease,M.RunningTime,
                                                       dbo.GetMovieGenres(M.MovieId) as 'Genres', 
                                                       dbo.GetMovieRating(M.MovieId) as 'AverageRating'
                                                    FROM 
	                                                    Movie M
                                                    WHERE
	                                                    M.Title like @title;", new { title = new DbString { Value = string.Concat("%", title, "%") } });
        }

        public Task<IEnumerable<Movie>> GetMoviesByYearRelease(int year)
        {
            return _storeService.QueryAsync<Movie>(@"SELECT  M.MovieId as Id, M.Title,
	                                                    M.YearRelease, M.RunningTime,
	                                                    dbo.GetMovieGenres(M.MovieId) as 'Genres',
	                                                    dbo.GetMovieRating(M.MovieId) as 'AverageRating'
                                                    FROM 
	                                                    Movie M
                                                    WHERE
	                                                    M.YearRelease = @year", new { year = year});
        }

        public Task<IEnumerable<Movie>> GetTopMoviesByUser(int userId)
        {
            return _storeService.QueryAsync<Movie>(@"SELECT top 5
	                                                        M.MovieId as Id,
	                                                        M.Title,
	                                                        M.YearRelease,
	                                                        M.RunningTime,
	                                                        dbo.GetMovieGenres(M.MovieId) as 'Genre(s)',
	                                                        R.Value
                                                        FROM 
	                                                        Movie M
	                                                        inner join Rating R on M.MovieId = R.MovieId
	                                                        inner join [User] U on U.UserId = R.UserId
                                                        WHERE
	                                                        R.UserId = @userId
                                                        ORDER BY 
	                                                        R.Value desc", new { userId = userId});
        }

        public Task<IEnumerable<Movie>> GetTopRatingMovies()
        {
            return _storeService.QueryAsync<Movie>(@"select top 5
	                                                    M.MovieId as Id,
	                                                    M.Title,
	                                                    M.YearRelease,
	                                                    M.RunningTime,
	                                                    dbo.GetMovieGenres(M.MovieId) as 'Genre(s)',
	                                                    dbo.GetMovieRating(M.MovieId) as 'AverageRating'
                                                    from 
	                                                    Movie M
                                                    order by AverageRating desc;");
        }

        public async Task<int> RateMovie(Rating rating)
        {
            return await _storeService.Save<Rating>(rating);
        }

        private Task<Rating> FindRating(Rating rating)
        {
            return _storeService.QueryFirst<Rating>("select * from Rating where movieId = @movieId", 
                                new { movieId = rating.MovieId, userId = rating.UserId });
        }

        public Task<Movie> GetMovieById(int movieId)
        {
            return _storeService.QueryFirst<Movie>("select * from Movie where movieId = @movieId", 
                                new { movieId = movieId });
        }
        
    }
}
