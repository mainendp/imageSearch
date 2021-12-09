//
//  SearchResult.swift
//  imageSearch
//
//  Created by 장창순 on 2021/12/09.
//

import Foundation


struct SearchResult: Decodable {
    let meta: Meta
    let documents: [Documents]
}

struct Meta: Decodable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

struct Documents: Decodable {
    let collection: String
    let thumbnailURL: String
    let imageURL: String
    let width: Int
    let height: Int
    let displaySitename: String
    let docURL: String
    let datetime: String
    
    enum CodingKeys: String, CodingKey {
        case collection
        case thumbnailURL = "thumbnail_url"
        case imageURL = "image_url"
        case width
        case height
        case displaySitename = "display_sitename"
        case docURL = "doc_url"
        case datetime
    }
}

struct SearchRequest {
    var query: String = ""
    var page: Int = 1
    var isEnd: Bool = false
}
