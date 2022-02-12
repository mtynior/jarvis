<div align="center">
    <h1>Jarvis</h1>
    <h3>Simple Http Client written in Swift</h3>
</div>
<p align="center">
  <img src="https://img.shields.io/badge/language-Swift-orange" />
  <a href="https://github.com/mtynior/jarvis/actions/workflows/test_package_prod_env.yml">
    <img src="https://github.com/mtynior/jarvis/actions/workflows/test_package_prod_env.yml/badge.svg?branch=main"/>
  </a>
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" />
</p>

## Usage

### Sending Http GET Request

```swift
let client = HttpClient()
            
let request = Request()
  .url(string: "https://httpbin.org/get")
  .addHeader(name: "Accept-Type", value: "application/json")
  .method(.get)
        
let response = try await client.send(request)

print(response)
```

### Sending Http POST Request

```swift
let client = HttpClient()

let requestBody = BodyContent(string: "Jarvis, are you there?")
            
let request = Request()
  .url(string: "https://httpbin.org/post")
  .addHeader(name: "AcceptType", value: "application/json") 
  .method(.post)
  .body(requestBody)
        
let response = try await client.send(request)

print(response.body.string())
```

### Working with JSON
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

### Downloading a file to temp folder
```swift
let client = HttpClient()

func getImage(from url: String) async throws {
  let request = Request(url: url)

  let result = try await client.download(request)
  
  print(result.fileLocation)
}
```

### Downloading a file to specific location
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

### Uploading a raw file
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

### Uploading a multipart content
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

### Instead of Swift's new concurency system, you can also use calbacks and Combine publishers. More information is available in the [documentation](Docs/Usage.md).

## TODO
- [ ] Certifiacate pining
- [ ] Add Request Intercepter
- [ ] Add Response Intercepter
- [ ] Add UploadStrategy
