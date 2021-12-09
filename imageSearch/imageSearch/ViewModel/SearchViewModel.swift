//
//  SearchViewModel.swift
//  imageSearch
//
//  Created by 장창순 on 2021/12/09.
//

import Foundation
import RxSwift
import RxRelay


final class SearchViewModel {
    
    let imageURL = BehaviorRelay<String>(value: "")
    let additionalInfo = BehaviorRelay<String>(value: "")
    let onNextPage = PublishRelay<Void>()
    
    var items = BehaviorRelay<[ImageItem]>(value: [])
    var requestData = SearchRequest()
    var disposeBag = DisposeBag()
    
    init() {
        self.onNextPage
            .bind { [weak self] in
                guard let self = self,
                !self.requestData.isEnd else {
                    return
                }
                
                self.requestData.page += 1
                self.searchImages(isPaginated: true)
            }
            .disposed(by: self.disposeBag)
    }
}


extension SearchViewModel {
    
    func searchImages(isPaginated: Bool = false) {
        guard !self.requestData.isEnd,
              !self.requestData.query.isEmpty else {
                  self.items.accept([])
                  self.additionalInfo.accept("검색어를 입력하세요.")
                  return
              }
        guard !self.requestData.query.hasPrefix(" ") else {
            self.items.accept([])
            self.additionalInfo.accept("공백으로 시작하는 검색어를 입력할 수 없습니다.")
            return
        }
        
        SearchAPIService.shared.searchImages(request: self.requestData) { result in
            switch result {
            case .success(let data):
                self.requestData.isEnd = data.meta.isEnd
                
                var items: [ImageItem] = self.items.value
                if !isPaginated {
                    items = []
                }
                
                data.documents.forEach { document in
                    let item = ImageItem(
                        imageURL: document.imageURL,
                        sitename: document.displaySitename,
                        date: document.datetime
                    )
                    
                    items.append(item)
                }
                
                if items.isEmpty {
                    self.additionalInfo.accept("검색 결과가 없습니다.")
                }
                
                self.items.accept(items)
            case .failure(let error):
                if let error = error as? SearchError {
                    self.additionalInfo.accept(error.errorDescription)
                } else {
                    self.additionalInfo.accept(error.localizedDescription)
                }
            }
        }
    }
}
