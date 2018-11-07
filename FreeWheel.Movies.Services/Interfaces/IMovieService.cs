using FreeWheel.Movies.Services.Model;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace FreeWheel.Movies.Services.Interfaces
{
    public interface IMovieService
    {
        Task<IEnumerable<Movie>> GetMoviesByTitle(string title);

        Task<IEnumerable<Movie>> GetMoviesByGenre(string title);

        Task<IEnumerable<Movie>> GetMoviesByYearRelease(int year);

        Task<IEnumerable<Movie>> GetTopMoviesByUser(int userId);

        Task<IEnumerable<Movie>> GetTopRatingMovies();

        Task<int> RateMovie(Rating rating);

        Task<Movie> GetMovieById(int movieId);
    }
}
