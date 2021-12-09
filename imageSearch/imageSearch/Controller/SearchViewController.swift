//
//  SearchViewController.swift
//  imageSearch
//
//  Created by 장창순 on 2021/12/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class SearchViewController: UIViewController {
    
    static let imageSize: CGFloat = UIScreen.main.bounds.width / 3
    
    private let additionalLabel = UILabel()
    private let searchBar = UISearchBar()
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(
            width: SearchViewController.imageSize,
            height: SearchViewController.imageSize
        )
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
       
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        
        return collectionView
    }()

    private let disposeBag = DisposeBag()
    private var viewModel: SearchViewModel?
    
    init(with viewModel: SearchViewModel) {
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


extension SearchViewController {
    
    private func setup() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.searchBar)
        
        self.additionalLabel.textAlignment = .center
        self.additionalLabel.numberOfLines = 0
        self.view.addSubview(self.additionalLabel)
        
        self.collectionView.isHidden = true
        self.collectionView.register(
            ImageCell.self,
            forCellWithReuseIdentifier: "ImageCell"
        )
        self.view.addSubview(self.collectionView)
    }
    
    private func layout() {
        self.searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50.0)
        }
        
        self.additionalLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func bind() {
        guard let viewModel = self.viewModel else {
            print("viewModel is not set")
            return
        }
        
        self.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .bind { [weak self] text in
                guard let self = self else { return }

                self.collectionView.setContentOffset(.zero, animated: false)
                
                self.viewModel?.requestData = SearchRequest(query: text)
                self.viewModel?.searchImages()
            }
            .disposed(by: self.disposeBag)
        
        viewModel.items.asDriver()
            .drive(self.collectionView.rx.items(
                cellIdentifier: "ImageCell",
                cellType: ImageCell.self)
            ) { index, item, cell in
                cell.setData(imageURL: item.imageURL)
                
                if viewModel.items.value.count == index + 1 {
                    viewModel.onNextPage.accept(())
                }
            }
            .disposed(by: self.disposeBag)
        
        viewModel.items.asDriver()
            .map { $0.isEmpty }
            .drive(self.collectionView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        viewModel.additionalInfo.asDriver()
            .drive(self.additionalLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                
                self.onImage(indexPath.row)
            }
            .disposed(by: self.disposeBag)
    }
}


extension SearchViewController {
    
    private func onImage(_ index: Int) {
        guard let viewModel = viewModel else {
            print("viewModel is not set")
            return
        }
        
        let imageDetailVM = ImageDetailViewModel(with: viewModel.items.value[index])
        let detailVC = ImageDetailViewController(viewModel: imageDetailVM)
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true, completion: nil)
    }
}
