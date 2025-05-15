# README

Create a comprehensive README.md file:

# Weather Forecast Application

A Ruby on Rails application that provides weather forecasts for a given address.

## Features

- Address input with geocoding
- Current weather conditions display
- 30-minute caching by zip code
- Cache indicator for cached results

## Architecture

This application follows standard Rails MVC architecture with additional service objects for better separation of concerns:

- **Models**: Address model for storing geocoded locations
- **Views**: Simple, responsive UI using Tailwind CSS
- **Controllers**: Forecasts controller for handling user input
- **Services**:
  - GeocodingService: Handles address geocoding
  - WeatherService: Interacts with the OpenWeather API and manages caching

### Design Patterns

- **Service Objects**: Encapsulates business logic outside controllers
- **Repository Pattern**: Abstracts data access (via WeatherService)
- **Caching Strategy**: Implements time-based caching with cache indicators

## Setup

### Prerequisites

- Ruby 3.2.2
- Rails 7.0.8
- PostgreSQL

### Installation

1. Clone the repository
   git clone https://github.com/ajayraveendran94/weather_data.git cd weather_forecast

2. Install dependencies
   bundle install

3. Setup the database
   rails db:create db:migrate

4. Configure environment variables
   Copy the `.env.example` file to `.env` and add your OpenWeather API key:
   OPENWEATHER_API_KEY=your_api_key_here

5. Start the server
   rails server

6. Visit http://localhost:3000 in your browser

## Testing

Run the test suite:
bundle exec rspec

## Scalability Considerations

- **API Rate Limiting**: The application implements caching to reduce API calls
- **Database Indexing**: Key fields are indexed for faster lookups
- **Caching Strategy**: Cache invalidation is time-based for simplicity
