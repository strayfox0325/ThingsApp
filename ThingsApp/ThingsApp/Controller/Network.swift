//
//  Network.swift
//
//

import Foundation
import Alamofire
import UIKit

public enum CustomError: Error {
    case badResponse
    case statusCode(Int)
    case application
    case searchTextMissing
    case timeout
    case unknown
}

final class Network {
    
    // MARK: - Types
    
    public struct Completion {
        public typealias ThrowableDataResponse = (() throws -> (Data?)) -> Void
    }
    
    // MARK: - Singleton
    
    static let shared = Network()
    
    // MARK: - Properties
    
    var backgroundSessionManager: Alamofire.SessionManager
    
    // MARK: - Init
    
    init() {
        let sessionConfiguration = URLSessionConfiguration.background(withIdentifier:"com.lava.app.backgroundtransfer")
        backgroundSessionManager = Alamofire.SessionManager(configuration: sessionConfiguration)
    }
    
    // MARK: - API
    
    func sendRequest(to url: String, parameters: Parameters?=nil, encoding: ParameterEncoding=URLEncoding.default, headers: HTTPHeaders?=nil, completion: @escaping Completion.ThrowableDataResponse) {
        Alamofire.request(url, method: .get, parameters: parameters, encoding: encoding, headers: headers).response { [weak self] response in
            self?.handle(defaultDataResponse: response, completion: completion)
        }
    }
    
    func sendPostRequest(to url: String, parameters: Parameters?=nil, encoding: ParameterEncoding=JSONEncoding.default, headers: HTTPHeaders?=nil, completion: @escaping Completion.ThrowableDataResponse) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: encoding, headers: headers).response { [weak self] response in
            self?.handle(defaultDataResponse: response, completion: completion)
        }
    }
    
    func sendMultipartFormData(to url: String, parameters: Parameters?=nil, photos: [Data]?=nil, encoding: ParameterEncoding=URLEncoding.default, headers: HTTPHeaders?=nil, completion: @escaping Completion.ThrowableDataResponse) {
        Alamofire.upload( multipartFormData: { multipartFormData in
            
            if let params  = parameters {
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            
            if photos != nil {
            }
        }, to: url, method: .post, headers: headers, encodingCompletion: { [weak self] encodingResult in
            self?.handle(multipartResponse: encodingResult, completion: completion)
        }
        )
    }
    
    func sendMultipartFormData(to url: String, parameters: Parameters?=nil, photo: Data?=nil, video: Data?=nil, encoding: ParameterEncoding=URLEncoding.default, headers: HTTPHeaders?=nil, completion: @escaping Completion.ThrowableDataResponse) {
        Alamofire.upload( multipartFormData: { multipartFormData in
            
            if let params  = parameters {
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            
            if let photo = photo {
                let fileName = "\(Date().timeIntervalSince1970)"+".jpeg"
                multipartFormData.append(photo, withName: "image", fileName: fileName, mimeType: "image/jpeg")
            }
            
            if let video = video {
                let fileName = "\(Date().timeIntervalSince1970)"+".mp4"
                multipartFormData.append(video, withName: "video", fileName: fileName, mimeType: "video/*")
            }
            
        }, to: url, method: .post, headers: headers, encodingCompletion: { [weak self] encodingResult in
            self?.handle(multipartResponse: encodingResult, completion: completion)
        }
        )
    }
    
    //    func sendMultipartFormDataForOrders(to url: String, parameters: Parameters?=nil, itemsForSending: [CartItem]?=nil, encoding: ParameterEncoding=URLEncoding.default, headers: HTTPHeaders?=nil, completion: @escaping Completion.ThrowableDataResponse) {
    //        Alamofire.upload( multipartFormData: { multipartFormData in
    //
    //            if let params  = parameters {
    //                for (key, value) in params {
    //                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
    //                }
    //            }
    //
    //            if let itemsForSending = itemsForSending {
    //                var productsArray = [[String : Any]]()
    //                for (cartIndex, cartItem) in itemsForSending.enumerated() {
    //                    if let productID = cartItem.selectedTheme?.productID {
    //                        let item = ["product_id" : productID, "quantity" : cartItem.quantity, "index" : cartIndex]
    //                        productsArray.append(item)
    //                    }
    //                }
    //
    //                if let productsData = try? JSONSerialization.data(withJSONObject: productsArray, options: .prettyPrinted) {
    //                    multipartFormData.append(productsData, withName: "products")
    //                }
    //            }
    //
    //            if let itemsForSending = itemsForSending {
    //                for (cartIndex, cartItem) in itemsForSending.enumerated() {
    //                    if let photos = cartItem.photos {
    //                        for (imageIndex, abImage) in photos.enumerated() {
    //                            let fileName = String(format: "image_%03d.jpg",imageIndex)
    //                            if let imageData = abImage.imageData {
    //                                multipartFormData.append(imageData, withName: "images[\(cartIndex)][]", fileName: fileName, mimeType: "image/jpeg")
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }, to: url, method: .post, headers: headers, encodingCompletion: { [weak self] encodingResult in
    //            self?.handle(multipartResponse: encodingResult, completion: completion)
    //        }
    //        )
    //    }
    
    //    func sendMultipartFormDataForOrdersInBackground(to url: String, parameters: Parameters?=nil, itemsForSending: [CartItem]?=nil, encoding: ParameterEncoding=URLEncoding.default, headers: HTTPHeaders?=nil, completion: @escaping Completion.ThrowableDataResponse) {
    //
    //        backgroundSessionManager.upload( multipartFormData: { multipartFormData in
    //
    //            if let params  = parameters {
    //                for (key, value) in params {
    //                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
    //                }
    //            }
    //
    //            if let itemsForSending = itemsForSending {
    //                var productsArray = [[String : Any]]()
    //                for (cartIndex, cartItem) in itemsForSending.enumerated() {
    //                    if let productID = cartItem.selectedTheme?.productID {
    //                        let item = ["product_id" : productID, "quantity" : cartItem.quantity, "index" : cartIndex]
    //                        productsArray.append(item)
    //                    }
    //                }
    //
    //                if let productsData = try? JSONSerialization.data(withJSONObject: productsArray, options: .prettyPrinted) {
    //                    multipartFormData.append(productsData, withName: "products")
    //                }
    //            }
    //
    //            if let itemsForSending = itemsForSending {
    //                for (cartIndex, cartItem) in itemsForSending.enumerated() {
    //                    if let photos = cartItem.photos {
    //                        for (imageIndex, abImage) in photos.enumerated() {
    //                            let fileName = String(format: "image_%03d.jpg",imageIndex)
    //                            if let imageData = abImage.imageData {
    //                                multipartFormData.append(imageData, withName: "images[\(cartIndex)][]", fileName: fileName, mimeType: "image/jpeg")
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }, usingThreshold: UInt64(0),
    //        to: url, method: .post, headers: headers, encodingCompletion: { [weak self] encodingResult in
    //            self?.handle(multipartResponse: encodingResult, completion: completion)
    //        }
    //        )
    //    }
    
    // MARK: - Helpers
    
    private func handle(defaultDataResponse response: DefaultDataResponse, completion: @escaping Completion.ThrowableDataResponse) {
        if response.error != nil {
            if
                let data = response.data,
                let responseString = String(data: data, encoding: .utf8)
            {
                let httpResponse = response.response
                print("Returned error from BE: \(responseString)")
                handle(error: response.error, from: response.request, httpResponse: httpResponse, completion: completion)
            }
        } else {
            if
                let httpResponse = response.response,
                let request = response.request,
                let data = response.data
            {
                handle(httpResponse: httpResponse, for: request, with: data, completion: completion)
            }
        }
    }
    
    private func handle(multipartResponse: SessionManager.MultipartFormDataEncodingResult, completion: @escaping Completion.ThrowableDataResponse) {
        switch multipartResponse {
        case .success(let upload, _, _):
            upload.uploadProgress { progress in
                // let completedFraction = ["fractionCompleted" : progress.fractionCompleted]
                // NotificationCenter.default.post(name: Notification.Name.Progress.didUpdate, object: nil, userInfo: completedFraction)
                print(progress.fractionCompleted)
            }
            handle(uploadRequest: upload, completion: completion)
        case .failure( let error ):
            print("Multipart error: \(error)")
            completion {
                throw CustomError.timeout
            }
        }
    }
    
    private func handle(uploadRequest: UploadRequest, completion: @escaping Completion.ThrowableDataResponse) {
        uploadRequest.responseData(completionHandler: { [weak self] (responseData) in
            if
                let httpResponse = uploadRequest.response,
                let request = uploadRequest.request,
                let data = responseData.data
            {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Returned String from BE @handleUpload request --->:\n\n\(responseString)")
                }
                self?.handle(httpResponse: httpResponse, for: request, with: data, completion: completion)
            }
        })
    }
    
    private func handle(httpResponse: HTTPURLResponse, for request: URLRequest, with data: Data, completion: Completion.ThrowableDataResponse) {
        switch httpResponse.statusCode {
        case 200..<300:
            completion {
                return data
            }
        default:
            completion {
                throw CustomError.statusCode(httpResponse.statusCode)
            }
        }
    }
    
    private func handle(error: Error?, from request: URLRequest?, httpResponse: HTTPURLResponse?, completion: Completion.ThrowableDataResponse) {
        let statusCode = httpResponse?.statusCode ?? 666
        completion {
            throw CustomError.statusCode(statusCode)
        }
    }
}
