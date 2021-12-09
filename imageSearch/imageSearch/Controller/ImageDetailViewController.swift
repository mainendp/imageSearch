//
//  ImageDetailViewController.swift
//  imageSearch
//
//  Created by 장창순 on 2021/12/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher


final class ImageDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let bottomView = UIView()
    private let sitename = UILabel()
    private let date = UILabel()
    private let closeButton = UIButton()
    
    private let disposeBag = DisposeBag()
    private var viewModel: ImageDetailViewModel?
    
    init(viewModel: ImageDetailViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setup()
        self.layout()
        self.bind()
    }
}


extension ImageDetailViewController {
    
    private func setup() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.contentView)
        
        self.imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.imageView)
        
        self.sitename.textColor = .white
        self.bottomView.addSubview(self.sitename)
        
        self.date.textColor = .white
        self.bottomView.addSubview(self.date)
        
        self.bottomView.backgroundColor = .gray
        self.contentView.addSubview(self.bottomView)

        self.closeButton.setTitle("닫기", for: .normal)
        self.closeButton.setTitleColor(.white, for: .normal)
        self.closeButton.backgroundColor = .gray
        self.view.addSubview(self.closeButton)
    }
    
    private func layout() {
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
        }

        self.contentView.snp.makeConstraints { make in
            make.top.equalTo(self.scrollView.contentLayoutGuide.snp.top)
            make.bottom.greaterThanOrEqualTo(self.scrollView.contentLayoutGuide.snp.bottom)
            make.leading.equalTo(self.scrollView.contentLayoutGuide.snp.leading)
            make.trailing.equalTo(self.scrollView.contentLayoutGuide.snp.trailing)
            make.width.equalTo(self.scrollView.frameLayoutGuide.snp.width)
        }
        
        self.bottomView.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60.0)
            make.bottom.equalToSuperview()
        }
        
        self.sitename.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().offset(-8.0)
        }
        
        self.date.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().offset(-8.0)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8.0)
            make.trailing.equalToSuperview().offset(-8.0)
        }
    }
    
    private func bind() {
        guard let viewModel = self.viewModel else {
            print("viewModel is not set")
            return
        }
        
        viewModel.imageURL.asDriver()
            .drive(onNext: { [weak self] imageURL in
                guard let self = self else { return }
                self.setImage(imageURL: imageURL)
            })
            .disposed(by: self.disposeBag)
        
        viewModel.sitename.asDriver()
            .map { "출처 : \($0)" }
            .drive(self.sitename.rx.text)
            .disposed(by: self.disposeBag)
        
        viewModel.date.asDriver()
            .map { "작성 시간 : \($0)" }
            .drive(self.date.rx.text)
            .disposed(by: self.disposeBag)
        
        self.closeButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.onCloseButtonTapped()
            }
            .disposed(by: self.disposeBag)
    }
}


extension ImageDetailViewController {
    
    private func setImage(imageURL: String) {
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: URL(string: imageURL)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let ratio = data.image.size.width / data.image.size.height
                let height = self.view.bounds.width / ratio
                
                self.imageView.snp.makeConstraints { make in
                    make.top.leading.trailing.equalToSuperview()
                    make.height.equalTo(height)
                }
            case .failure(let error):
                let alert = UIAlertController(
                    title: "에러",
                    message: "이미지를 불러올 수 없습니다. \n 에러코드 : \(error.errorCode)",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    private func onCloseButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

