//
//  ViewController.swift
//  PetsDiffingiOS13
//
//  Created by Alfian Losari on 18/07/19.
//  Copyright © 2019 alfianlosari. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, CatImage>! = nil
    var sectionCats: [[CatImage]] = CatImage.shuffledSectionCats

    
    var slider: UISlider!

    var delay: Int = 1000

    var isDiffing = false {
        didSet {
            self.slider.isHidden = !self.isDiffing
        }
    }
    
    func configureNavItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: isDiffing ? "Stop" : "😸😸😸",
                                                            style: .plain, target: self,
                                                            action: #selector(toggleDiff))
    }
    
    private func setupSlider() {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = 250
        slider.maximumValue = 1000
        slider.value = Float(self.delay)
        
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        navigationItem.titleView = slider
        slider.isHidden = true
        self.slider = slider
    }
    
    @objc private func sliderChanged(_ sender: UISlider) {
        self.delay = Int(sender.value)
    }
    
    @objc func toggleDiff() {
        isDiffing.toggle()
        if isDiffing {
            performDiffing()
        }
        configureNavItem()
    }
    
    
    private func performDiffing() {
        if !isDiffing {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(delay)) {
            let snapshot = self.createSnapshot()
            self.dataSource.apply(snapshot, animatingDifferences: true)
            self.performDiffing()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavItem()
        setupSlider()
        setupCollectionView()
        configureDataSource()
    }
    
  
    private func setupCollectionView() {
        title = "Cats"
        navigationController?.navigationBar.prefersLargeTitles = true
       
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(PetRoundedThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: "PetRoundedCell")
        collectionView.register(PetThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: "PetCell")

        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError()
            }
            
            switch section {
            case .rounded:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(0.2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                group.interItemSpacing = .fixed(16)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                section.orthogonalScrollingBehavior = .continuous
                return section
                
            case .customGrid:
                let leadingItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                                       heightDimension: .fractionalHeight(1.0)))
                leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                let trailingItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(0.3)))
                trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                let trailingGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                       heightDimension: .fractionalHeight(1.0)),
                    subitem: trailingItem, count: 2)
                
                let containerGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalHeight(0.4)),
                    subitems: [leadingItem, trailingGroup])

                let section = NSCollectionLayoutSection(group: containerGroup)
                section.orthogonalScrollingBehavior = .continuous
                return section
                
            case .twoGrid:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.475),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(0.475))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                group.interItemSpacing = .flexible(0.05)
                
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

                return section
            }
        }
        return layout
    }
    
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, CatImage>(collectionView: collectionView, cellProvider: {
            (cv, indexPath, catImage) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError()
            }
    
            switch section {
            case .rounded:
                let cell = cv.dequeueReusableCell(withReuseIdentifier: "PetRoundedCell", for: indexPath) as! PetRoundedThumbnailCollectionViewCell
                cell.configure(catImage.image)
                return cell
                
            default:
                let cell = cv.dequeueReusableCell(withReuseIdentifier: "PetCell", for: indexPath) as! PetThumbnailCollectionViewCell
                cell.configure(catImage.image)
                return cell
            }
        })
        
        let snapshot = createSnapshot()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, CatImage>  {
        let snapshot = NSDiffableDataSourceSnapshot<Section, CatImage>()
        
        self.sectionCats = CatImage.shuffledSectionCats
        for (index, cats) in sectionCats.enumerated() {
            if let section = Section(rawValue: index) {
                snapshot.appendSections([section])
                snapshot.appendItems(cats, toSection: section)
            }
        }
        return snapshot
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let image = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(ac, animated: true, completion: nil)
    }
    
}
