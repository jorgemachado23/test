USE [master]
GO
/****** Object:  Database [MoviesRatingDB]    Script Date: 06/11/2018 15:44:14 ******/
CREATE DATABASE [MoviesRatingDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Movies', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\Movies.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Movies_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\Movies_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [MoviesRatingDB] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MoviesRatingDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MoviesRatingDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MoviesRatingDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MoviesRatingDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MoviesRatingDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MoviesRatingDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MoviesRatingDB] SET  MULTI_USER 
GO
ALTER DATABASE [MoviesRatingDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MoviesRatingDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MoviesRatingDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MoviesRatingDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MoviesRatingDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MoviesRatingDB] SET QUERY_STORE = OFF
GO
USE [MoviesRatingDB]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [MoviesRatingDB]
GO
/****** Object:  UserDefinedFunction [dbo].[GetMovieGenres]    Script Date: 06/11/2018 15:44:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetMovieGenres]
(
	-- Add the parameters for the function here
	@MovieId INT
)
RETURNS VARCHAR(500)
AS
BEGIN
	DECLARE @Genres VARCHAR(500)

	SELECT 
		@Genres = COALESCE(@Genres + ', ', '') + G.Description
	FROM 
		Movie M 
		INNER JOIN MovieByGenre MG on MG.MovieId = M.MovieId
		INNER JOIN Genre G on MG.GenreId = G.GenreId
	where
		M.MovieId = @MovieId;

	RETURN @Genres

END
GO
/****** Object:  UserDefinedFunction [dbo].[GetMovieRating]    Script Date: 06/11/2018 15:44:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION	[dbo].[GetMovieRating]
(
	@MovieId INT
)
RETURNS DECIMAL(4,2)
AS
BEGIN
	DECLARE @Rating Decimal(4,2)

	SELECT 
		@Rating = ROUND(AVG(cast([Value] as decimal(4,2))) * 2,0)/2
	FROM 
		[MoviesRatingDB].[dbo].[Rating] 
	WHERE 
		MovieId = @MovieId

	RETURN @Rating

END
GO
/****** Object:  Table [dbo].[Genre]    Script Date: 06/11/2018 15:44:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genre](
	[GenreId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED 
(
	[GenreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Movie]    Script Date: 06/11/2018 15:44:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Movie](
	[MovieId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](100) NOT NULL,
	[YearRelease] [int] NOT NULL,
	[RunningTime] [int] NOT NULL,
 CONSTRAINT [PK_Movie] PRIMARY KEY CLUSTERED 
(
	[MovieId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovieByGenre]    Script Date: 06/11/2018 15:44:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovieByGenre](
	[MovieGenreId] [int] IDENTITY(1,1) NOT NULL,
	[MovieId] [int] NULL,
	[GenreId] [int] NULL,
 CONSTRAINT [PK_MovieByGenre] PRIMARY KEY CLUSTERED 
(
	[MovieGenreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rating]    Script Date: 06/11/2018 15:44:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rating](
	[RatingId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[MovieId] [int] NULL,
	[Value] [smallint] NULL,
 CONSTRAINT [PK_Rating] PRIMARY KEY CLUSTERED 
(
	[RatingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 06/11/2018 15:44:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Genre] ON 
GO
INSERT [dbo].[Genre] ([GenreId], [Description]) VALUES (1, N'SCIFI')
GO
INSERT [dbo].[Genre] ([GenreId], [Description]) VALUES (2, N'Horror')
GO
INSERT [dbo].[Genre] ([GenreId], [Description]) VALUES (3, N'Comedy')
GO
INSERT [dbo].[Genre] ([GenreId], [Description]) VALUES (4, N'Thriller')
GO
INSERT [dbo].[Genre] ([GenreId], [Description]) VALUES (5, N'Film adaptation')
GO
SET IDENTITY_INSERT [dbo].[Genre] OFF
GO
SET IDENTITY_INSERT [dbo].[Movie] ON 
GO
INSERT [dbo].[Movie] ([MovieId], [Title], [YearRelease], [RunningTime]) VALUES (1, N'Matrix', 1999, 150)
GO
INSERT [dbo].[Movie] ([MovieId], [Title], [YearRelease], [RunningTime]) VALUES (2, N'Matrix Revolutions', 2001, 129)
GO
INSERT [dbo].[Movie] ([MovieId], [Title], [YearRelease], [RunningTime]) VALUES (3, N'Scary Movie', 2000, 90)
GO
INSERT [dbo].[Movie] ([MovieId], [Title], [YearRelease], [RunningTime]) VALUES (4, N'Requiem for a Dream', 2001, 82)
GO
INSERT [dbo].[Movie] ([MovieId], [Title], [YearRelease], [RunningTime]) VALUES (6, N'Watchmen', 2009, 215)
GO
SET IDENTITY_INSERT [dbo].[Movie] OFF
GO
SET IDENTITY_INSERT [dbo].[MovieByGenre] ON 
GO
INSERT [dbo].[MovieByGenre] ([MovieGenreId], [MovieId], [GenreId]) VALUES (1, 1, 1)
GO
INSERT [dbo].[MovieByGenre] ([MovieGenreId], [MovieId], [GenreId]) VALUES (2, 2, 1)
GO
INSERT [dbo].[MovieByGenre] ([MovieGenreId], [MovieId], [GenreId]) VALUES (3, 3, 3)
GO
INSERT [dbo].[MovieByGenre] ([MovieGenreId], [MovieId], [GenreId]) VALUES (4, 1, 2)
GO
INSERT [dbo].[MovieByGenre] ([MovieGenreId], [MovieId], [GenreId]) VALUES (5, 6, 4)
GO
INSERT [dbo].[MovieByGenre] ([MovieGenreId], [MovieId], [GenreId]) VALUES (6, 6, 5)
GO
SET IDENTITY_INSERT [dbo].[MovieByGenre] OFF
GO
SET IDENTITY_INSERT [dbo].[Rating] ON 
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (1, 1, 1, 1)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (2, 2, 1, 2)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (3, 3, 1, 3)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (4, 4, 1, 1)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (5, 5, 1, 2)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (6, 6, 1, 3)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (7, 7, 1, 4)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (8, 8, 1, 5)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (9, 9, 2, 1)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (10, 10, 2, 1)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (11, 11, 2, 2)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (12, 1, 2, 2)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (13, 1, 6, 3)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (14, 1, 4, 4)
GO
INSERT [dbo].[Rating] ([RatingId], [UserId], [MovieId], [Value]) VALUES (15, 1, 3, 5)
GO
SET IDENTITY_INSERT [dbo].[Rating] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 
GO
INSERT [dbo].[User] ([UserId], [Name]) VALUES (1, N'Jorge')
GO
INSERT [dbo].[User] ([UserId], [Name]) VALUES (2, N'Test')
GO
INSERT [dbo].[User] ([UserId], [Name]) VALUES (3, N'Testing')
GO
INSERT [dbo].[User] ([UserId], [Name]) VALUES (4, N'Another one')
GO
INSERT [dbo].[User] ([UserId], [Name]) VALUES (5, N' Long fee')
GO
INSERT [dbo].[User] ([UserId], [Name]) VALUES (6, N'Blasting')
GO
INSERT [dbo].[User] ([UserId], [Name]) VALUES (7, N'123')
GO
INSERT [dbo].[User] ([UserId], [Name]) VALUES (8, N'WRTFG')
GO
INSERT [dbo].[User] ([UserId], [Name]) VALUES (9, N'SWRTG')
GO
INSERT [dbo].[User] ([UserId], [Name]) VALUES (10, N'123123')
GO
INSERT [dbo].[User] ([UserId], [Name]) VALUES (11, N'123123')
GO
SET IDENTITY_INSERT [dbo].[User] OFF
GO
ALTER TABLE [dbo].[MovieByGenre]  WITH CHECK ADD  CONSTRAINT [FK_MovieByGenre_Genre] FOREIGN KEY([GenreId])
REFERENCES [dbo].[Genre] ([GenreId])
GO
ALTER TABLE [dbo].[MovieByGenre] CHECK CONSTRAINT [FK_MovieByGenre_Genre]
GO
ALTER TABLE [dbo].[MovieByGenre]  WITH CHECK ADD  CONSTRAINT [FK_MovieByGenre_Movie] FOREIGN KEY([MovieId])
REFERENCES [dbo].[Movie] ([MovieId])
GO
ALTER TABLE [dbo].[MovieByGenre] CHECK CONSTRAINT [FK_MovieByGenre_Movie]
GO
ALTER TABLE [dbo].[Rating]  WITH CHECK ADD  CONSTRAINT [FK_Rating_Movie] FOREIGN KEY([MovieId])
REFERENCES [dbo].[Movie] ([MovieId])
GO
ALTER TABLE [dbo].[Rating] CHECK CONSTRAINT [FK_Rating_Movie]
GO
ALTER TABLE [dbo].[Rating]  WITH CHECK ADD  CONSTRAINT [FK_Rating_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[Rating] CHECK CONSTRAINT [FK_Rating_User]
GO
USE [master]
GO
ALTER DATABASE [MoviesRatingDB] SET  READ_WRITE 
GO
