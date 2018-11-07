using FreeWheel.Movies.Services.Interfaces;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using FreeWheel.Movies.Services.Model;
using System.Threading.Tasks;

namespace FreeWheel.Movies.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MoviesController : ControllerBase
    {
        private readonly IMovieService _movieService;

        public MoviesController(IMovieService movieService)
        {
            _movieService = movieService;
        }

        [HttpGet]
        [Route("title/{title}")]
        public async Task<IActionResult> GetByTitle(string title)
        {
            var movies = await _movieService.GetMoviesByTitle(title);
            return HasResult(movies);
        }

        [HttpGet]
        [Route("genre/{genre}")]
        public async Task<IActionResult> GetByGenre(string genre)
        {
            var movies = await _movieService.GetMoviesByGenre(genre);
            return HasResult(movies);
        }

        [HttpGet]
        [Route("year/{year:int}")]
        public async Task<IActionResult> GetByYearOfRelease(int year)
        {
            var movies = await _movieService.GetMoviesByYearRelease(year);
            return HasResult(movies);
        }

        [HttpGet]
        [Route("user/{userId:int}")]
        public async Task<IActionResult> GetTopMoviesByUserId(int userId)
        {
            var movies = await _movieService.GetTopMoviesByUser(userId);
            return HasResult(movies);
        }

        [HttpGet]
        [Route("ratings/top")]
        public async Task<IActionResult> GetTopRatingMovies()
        {
            var movies = await _movieService.GetTopRatingMovies();
            return HasResult(movies);
        }

        [HttpPost]
        [Route("ratings/rate")]
        public async Task<IActionResult> Post([FromBody] Rating rating)
        {
            if (_movieService.GetMovieById(rating.MovieId) == null)
                return NotFound();

            await _movieService.RateMovie(rating);
            return CreatedAtAction("Movie", "Get", new { movieId = rating.MovieId });
        }

        private IActionResult HasResult(IEnumerable<Movie> movies)
        {
            if (!movies.Any() || movies == null)
            {
                return NotFound();
            }

            return Ok(movies);
        }
    }
}
