//
//  URLSession+HTTPDataProvider.swift
//  PaperClipApp
//
//  Created by Grinch on 06/11/2022.
//

import Foundation
import RemoteStore
import Combine

extension URLSession: HTTPDataProvider {
    
    public func dataPublisher(for request: URLRequest) -> AnyPublisher<HTTPResponse, URLError> {
        dataTaskPublisher(for: request).eraseToAnyPublisher()
    }

}
