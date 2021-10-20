//
//  BookDetail.swift
//  IT.Books
//
//  Created by Philip on 10.09.21.
//

import Foundation

struct BookDetail: Codable {
    let error, title, subtitle, authors: String?
    let publisher, language, isbn10, isbn13: String?
    let pages, year, rating, desc: String?
    let price: String?
    let image: String?
    let url: String?
    let pdf: PDF?
}

struct PDF: Codable {
}
