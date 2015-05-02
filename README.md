# ModestProposal

An HTTP Toolbox (Requires Swift 1.2)

#### Features
* URL building
* Request building
* Response validation
* JSON formatting
* JSON parsing
* Entity translation
* Asynchronous transforms

#### URL Building

    let baseURL = NSURL(string: "http://test.com")!
	let loginURL = baseURL.buildURL(path: "/login") // http://test.com/login
	let dataURL = baseURL.buildURL(path: "/data", parameters: ["id": "100", "page": "3"]) // http://test.com/data?id=100&page=3

#### Request building

    let baseRequest = NSURLRequest(URL: baseURL)
	let loginRequest = baseRequest.POST("/login", parameters: ["id": "100", "page": "3"]) // HTTPBody will be set to parameters
	loginRequest["Custom-Header"] = "Custom value"


#### Response validation

    let response = // NSURLResponse from a request
    let builder = ValidatorBuilder()
	
	// Add rules that are executed in order
	builder.valid(when: response.isHTTP, otherwise: NSError(domain, "MyDomain", code: kErrorCode, userInfo: nil))
	builder.valid(when: response.matchesStatuses([HTTPStatusSuccessful], otherwise: NSError(domain, "MyDomain", code: kErrorCode, userInfo: nil))
	builder.valid(when: response["Custom-Header"] == "Custom value", otherwise: NSError(domain, "MyDomain", code: kErrorCode, userInfo: nil))
	
	let validator = builder.build()
	
	if let error = validator.validate() {
		println(error)
	} else {
		println("Valid!")
	}

#### JSON Formatting

    let object = JSON.object()
	object["key1"] = "value1".json // JSONConvertible protocol
	let JSONData = object.format()
	
#### JSON Parsing

    var error: NSError?
	
	if let json = JSON.parse(JSONData, options: nil, error: &error) {
		println(json["key1"])
	} else {
		println(error!)
	}

#### Entity Translation

    let escaped = "Test1 &amp; Test2"
	let unescaped = escaped.unescapeEntities() // "Test1 & Test2"

#### Asynchronous transforms

    func imageTransformer(imageData: NSData) -> Outcome<UIImage, NSError> {
		if let image = UIImage(data: imageData) {
            return Outcome(image)
        } else {
            return Outcome(NSError(domain, "MyDomain", code: kErrorCode, userInfo: nil))
        }
	}
    
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
	
    transform(on: queue, input: imageData, transformer: imageTransformer) { (outcome) in
		outcome.onSuccess { (image) in
			// Use image
		}
		outcome.onFailure { (error) in
			// Use error
		}
	}

#### Build your own HTTP client

See Example.swift for a simple example that makes use of NSURLSession dataTaskWithRequest.
