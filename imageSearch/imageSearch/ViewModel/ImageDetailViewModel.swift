//
//  ImageDetailViewModel.swift
//  imageSearch
//
//  Created by 장창순 on 2021/12/09.
//

import Foundation
import RxSwift
import RxRelay


final class ImageDetailViewModel {
    
    private let imageItem: ImageItem?
    
    let imageURL = BehaviorRelay<String>(value: "")
    let sitename = BehaviorRelay<String>(value: "")
    let date = BehaviorRelay<String>(value: "")
    
    var disposeBag = DisposeBag()
    
    init(with imageItem: ImageItem) {
        self.imageItem = imageItem
        
        if let imageURL = self.imageItem?.imageURL {
            self.imageURL.accept(imageURL)
        }
        
        if let sitename = self.imageItem?.sitename,
           !sitename.isEmpty {
            self.sitename.accept(sitename)
        } else {
            self.sitename.accept("출처 정보가 없습니다.")
        }
        
        if let date = self.imageItem?.date,
           !date.isEmpty {
            self.date.accept(date.convertDateToString())
        } else {
            self.date.accept("작성 시간 정보가 없습니다.")
        }
    }
}
