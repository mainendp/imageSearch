//
//  SearchAPIService.swift
//  imageSearch
//
//  Created by 장창순 on 2021/12/09.
//

import Foundation
import Alamofire


final class SearchAPIService {
    
    static let shared = SearchAPIService()
    
    func searchImages(request: SearchRequest, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        let url = "https://dapi.kakao.com/v2/search/image"
        let API_KEY = "741f95289bb1174a8327f870f179bcf7"
        
        var params: [String : Any] = [:]
        params["query"] = request.query
        params["page"] = request.page
        params["size"] = 30
        
        AF.request(
            url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: ["Authorization" : "KakaoAK \(API_KEY)"]
        )
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                do {
                    let data = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    completion(.success(searchResult))
                } catch(let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                let searchError = SearchError(with: error.responseCode)
                completion(.failure(searchError))
            }
        }
    }
}
