# API Manager for Swift

API Manager is a Swift package designed to simplify network requests in Swift applications. It provides a clean and straightforward interface for making GET and POST requests, handling JSON encoding and decoding, and managing API tokens securely.

## Features

- Easy-to-use interface for GET and POST requests
- Automatic JSON encoding and decoding
- Secure token management using Keychain
- Support for custom headers and query parameters

## Installation

### Swift Package Manager

To integrate API Manager into your project using Swift Package Manager, add the following as a dependency to your `Package.swift`:
dependencies: [ .package(url: "https://github.com/betulcalik/APIManager.git", from: "1.0.0") ]

Alternatively, you can navigate to your Xcode project, select Swift Packages, and click the "+" icon to search for `APIManager`.

## Usage

### Initialization

First, initialize the `APIManager` with your base URL and service name for token storage:
```
let apiManager = APIManager(baseURL: "https://your-api-url.com", serviceName: "YourServiceName")

// Set the token manually (e.g., after successful login)
apiManager.setToken("your_access_token")

// Get the token
apiManager.getToken()
```

### Making GET Requests

To make a GET request, use the `get` method:
```
apiManager.get(path: "/your-endpoint")
  .sink(receiveCompletion: { completion in
  // Handle completion
  }, 
  receiveValue: { response in 
  // Handle response
  })
  .store(in: &cancellables)
``` 

### Making POST Requests

To make a POST request, use the `post` method:
```
let requestBody = YourEncodableModel() 
apiManager.post(path: "/your-endpoint", body: requestBody)
  .sink(receiveCompletion: { completion in
  // Handle completion },
  receiveValue: { response in
  // Handle response })
  .store(in: &cancellables)
``` 

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
