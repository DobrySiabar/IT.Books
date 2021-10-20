//
//  Book.swift
//  IT.Books
//
//  Created by Philip on 10.09.21.
//

import Foundation

struct File: Codable {
    let error, total, page: String
    let books: [Book]
}

struct Book: Codable {
    var title: String?
    var subtitle: String?
    var isbn13: String?
    var price: String?
    var image: String?
    var url: String?
}
