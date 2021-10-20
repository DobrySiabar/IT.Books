//
//  Network.swift
//  IT.Books
//
//  Created by Philip on 10.09.21.
//

import Foundation

class Network {
    
    
    class func fetchFile(url: URL, completion: @escaping (File) -> Void) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) {
            data, response, error in
            if let error = error as NSError?, error.code == -999 {
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                let derivedData = try! decoder.decode(File.self, from: data)
                
                completion(derivedData)
            }
        }
        dataTask.resume()
    }
    
    class func fetchDetail(url: URL, completion: @escaping (BookDetail) -> Void) {
        print("URL:\(url)")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) {
            data, response, error in
            if let error = error as NSError?, error.code == -999 {
                return
            }
            
            if let data = data {
                print("DATA: \(String(decoding: data, as: UTF8.self))")
                let decoder = JSONDecoder()
                let derivedData = try! decoder.decode(BookDetail.self, from: data)
                
                completion(derivedData)
            }
        }
        dataTask.resume()
    }
}
