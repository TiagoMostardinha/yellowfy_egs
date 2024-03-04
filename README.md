# yellowfy_egs
## Description
- The announcements API will be responsible to manage the annoucements stored in the database and how they will interact with other services.
- Based on a REST API model, it will only handle requests and responses with JSON content.
- **Diagram:** ![view diagram](readme/view_diagram.jpg)

## Documentation
- The REST API is in api/ directory, so any source code manipulation and operations must be in that same directory

## How to run
- Start and Run mongoDB container, by default mongoDB is on port 27017.
```bash
docker run --name mongo -d mongo:latest
```

- Building api and getting go dependencies.
```go

// after getting the dependcies of go it will reconstruct go.mod to be more readable
go mod vendor
go mod tidy

// compiles the project into an executable
go build
```

- Starting the api
```go
./api
```
