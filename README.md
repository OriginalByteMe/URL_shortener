# URL Shortener

A Ruby on Rails application for shortening URLs, with geolocation tracking.

## Getting Started

### Using Docker Compose

To run the full stack including the PostgreSQL database:

1. Ensure you have Docker and Docker Compose installed.
2. Clone this repository.
3. Navigate to the project directory.
4. Run:
   ```
   docker-compose up
   ```
5. The application will be available at `http://localhost:3000`.

To stop the containers:
```
docker-compose down
```

### Alternative Setup (without Docker)

1. Ensure you have Ruby, Rails, and PostgreSQL installed.
2. Clone this repository.
3. Navigate to the project directory.
4. Run:
   ```
   bin/setup
   ```
   This will set up the database, install all gem dependencies, and Yarn packages.

5. To start the development server with Foreman, run:
   ```
   bin/dev
   ```

## Deployment

This application is hosted on Fly.io!

The link for my application can be found at: https://noah-rijkaard-url-shortner.fly.dev/

### Fly.io Configuration

The `fly.toml` file in the root directory contains the main configuration for the Fly.io deployment. Key aspects include:

- App name and primary region
- HTTP service configuration
- Environment variable management
- Volume mounts for persistent storage

To deploy updates:
1. Ensure you have the Fly CLI installed and are logged in.
2. Run:
   ```
   fly deploy
   ```

If you want to launch the app for the first time
1. Run:
  ```
  fly login
  ```
2. Complete the login steps on the site
3. Run:
  ```
  fly launch
  ```
4. And copy over the config to your project


For more details on Fly.io deployment, refer to their [documentation](https://fly.io/docs/rails/).