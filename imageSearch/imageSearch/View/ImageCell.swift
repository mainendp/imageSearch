//
//  ImageCell.swift
//  imageSearch
//
//  Created by 장창순 on 2021/12/09.
//

import UIKit
import Kingfisher


final class ImageCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.kf.cancelDownloadTask()
        self.imageView.image = nil
    }
}


extension ImageCell {
    
    private func setup() {
        self.backgroundColor = .clear
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.contentView.addSubview(self.imageView)
    }
    
    private func layout() {
        self.imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setData(imageURL: String) {
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: URL(string: imageURL))
    }
}
