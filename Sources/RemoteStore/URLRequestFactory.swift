import Foundation

struct URLRequestFactory {

    enum EndPoint {
        case ads
        case category
        
        var url: URL {
            switch self {
            case .ads:
                return URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json")!
            case .category:
                return URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json")!
            }
        }
    }
    
    func makeUrlRequest(for endPoint: EndPoint) -> URLRequest {
        var urlRequest = URLRequest(url: endPoint.url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
