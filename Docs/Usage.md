# Usage

## Sending Http GET Request
### Async/Await
```swift
let client = HttpClient()
            
let request = Request()
  .url(string: "https://httpbin.org/get")
  .addHeader(name: "Accept-Type", value: "application/json")
  .method(.get)
        
let response = try await client.send(request)

print(response)
```

### Callbacks
```swift
let client = HttpClient()
            
let request = Request()
  .url(string: "https://httpbin.org/get")
  .addHeader(name: "Accept-Type", value: "application/json")
  .method(.get)
        
let actualTask = client.send(request) { result in
  switch result {
  case .success(let response):
    print(response)
  case .failure(let error):
    print(error)
  }
}
```

### Publisher
```swift
var cancellable: AnyCancellable? 
let client = HttpClient()

let request = Request()
  .url("https://httpbin.org/get")
  .method(.get)
        
cancellable = client.send(request)
  .publisher()
  .map({ $0.body?.string() })
  .sink(receiveCompletion: { error in
    print(error)
  }, receiveValue: { body in
    print(body)
  })
```

## Sending Http POST Request
### Async/Await
```swift
let client = HttpClient()

let requestBody = BodyContent(string: "Jarvis, are you there?")
            
let request = Request()
  .url(string: "https://httpbin.org/post")
  .addHeader(name: "AcceptType", value: "application/json") 
  .method(.post)
  .body(requestBody)
        
let response = client.send(request)

print(response.body.string())
```

### Callbacks
```swift
let client = HttpClient()

let requestBody = BodyContent(string: "Jarvis, are you there?")
            
let request = Request()
  .url(string: "https://httpbin.org/post")
  .addHeader(name: "AcceptType", value: "application/json") 
  .method(.post)
  .body(requestBody)
        
let actualTask = client.send(request) { result in
  switch result {
  case .success(let response):
    print(response.body.string())
  case .failure(let error):
    print(error)
  }
}
```

## Working with JSON
### Async/Await
```swift
struct Credentials: Codable {}
 
struct LoginResponse: Codable {}
 
let client = HttpClient()
 
func login(_ userCredentials: Credentials) async throws -> LoginResponse? {
  let requestBody = try? BodyContent(json: userCredentials)
     
  let request = Request()
    .url(string: "https://api.someservice.com/login")
    .addHeader(name: "Accept-Type", value: "application/json")
    .method(.post)
    .body(requestBody)
     
  let response = try await client.send(request)
  return try resonse.body?.json()
}
```

### Callbacks
```swift
struct Credentials: Codable {}
 
struct LoginResponse: Codable {}
 
let client = HttpClient()
 
func login(_ userCredentials: Credentials, completion: @escaping (Result<LoginResponse?, Error>) -> Void) {
  let requestBody = try? BodyContent(json: userCredentials)
     
  let request = Request()
    .url(string: "https://api.someservice.com/login")
    .addHeader(name: "Accept-Type", value: "application/json")
    .method(.post)
    .body(requestBody)
     
  client.send(request) { result in
    let mappedResult: Result<LoginResponse?, Error> = result.map { try? $0.body?.json() }
    completion(mappedResult)
  }
}
```

## Downloading a file to temp folder
### Async/Await
```swift
let client = HttpClient()

func getImage(from url: String) async throws {
  let request = Request(url: url)

  let result = try await client.download(request)
  
  print(result.fileLocation)
}
```

### Callbacks
```swift
let client = HttpClient()

func getImage(from url: String) {
  let request = Request(url: url)

  client.download(request) { result in
    switch result {
    case .success(let response):
      print(response.fileLocation)
    case .failure(let error):
      print(error)
    }
  }
}
```

### Publisher
```swift
var cancellable: AnyCancellable? 
let client = HttpClient()

let request = Request(url: "file/url")

cancellable = client.download(request)
  .publisher()
  .sink(receiveCompletion: { error in
    print(error)
  }, receiveValue: { result in
    print(result)
  })
```

## Downloading a file to specific location
### Async/Await
```swift
let client = HttpClient()

func getImage(from url: String, saveAs fileName: String) async throws {
  let request = Request(url: url)

  let downloadLocation = DownloadLocation(
    locationUrl: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
    fileName: .renamed(fileName)
  )
     
  let result = try await client.download(request, downloadLocation: downloadLocation)

  print(result.fileLocation)
}
```

### Callbacks
```swift
let client = HttpClient()

func getImage(from url: String, saveAs fileName: String) {
  let request = Request(url: url)

  let downloadLocation = DownloadLocation(
    locationUrl: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
    fileName: .renamed(fileName)
  )
     
  client.download(request, downloadLocation: downloadLocation) { result in
    switch result {
    case .success(let response):
      print(response.fileLocation)
    case .failure(let error):
      print(error)
    }
  }
}
```

## Uploading a raw file
### Async/Await
```swift
let client = HttpClient()

func uploadImage(from url: URL) async throws {
  let requestBody = FileBody(fileUrl: url)

  let request = Request(url: url)
    .method(.post)
    .body(body)
     
  let response = try await client.upload(request)

  print(response)
}
```

### Callbacks
```swift
let client = HttpClient()

func uploadImage(from url: URL) {
  let requestBody = FileBody(fileUrl: url)

  let request = Request(url: url)
    .method(.post)
    .body(body)
     
  client.upload(request) { result in
    switch result {
    case .success(let response):
      print(response)
    case .failure(let error):
      print(error)
    }
  }
}
```

### Publisher
```swift
var cancellable: AnyCancellable? 
let client = HttpClient()

let request = Request(url: "https://httpbin.org/post")
  .method(.post)
  .body(BodyContent(string: "Hello world"))

cancellable = client.upload(request)
  .publisher()
  .sink(receiveCompletion: { error in
    print(error)
  }, receiveValue: { response in
    print(response)
  })
```

## Uploading a multipart content
### Async/Await
```swift
let client = HttpClient()

func uploadToImgur(fileUrl: URL, mediaType: String) async throws {
  let fileBody = FileBody(fileUrl: fileUrl, mediaType: mediaType)
     
  let requestBody = MultipartBody()
    .addDataPart(name: "type", value: "file")
    .addDataPart(name: "title", value: "Image uploaded to Imgur")
    .addDataPart(name: "image", body: fileBody)
     
  let request = Request(url: "https://api.imgur.com/3/image")
    .addHeader(name: "Authorization", value: "Bearer ...")
    .method(.post)
    .body(requestBody)

  let response = try await client.upload(request)

  print(response)
}
```

### Callbacks
```swift
let client = HttpClient()

func uploadToImgur(fileUrl: URL, mediaType: String) {
  let fileBody = FileBody(fileUrl: fileUrl, mediaType: mediaType)
     
  let requestBody = MultipartBody()
    .addDataPart(name: "type", value: "file")
    .addDataPart(name: "title", value: "Image uploaded to Imgur")
    .addDataPart(name: "image", body: fileBody)
     
  let request = Request(url: "https://api.imgur.com/3/image")
    .addHeader(name: "Authorization", value: "Bearer ...")
    .method(.post)
    .body(requestBody)
     
  client.upload(request) { result in
    switch result {
    case .success(let response):
      print(response)
    case .failure(let error):
      print(error)
    }
  }
}
```
