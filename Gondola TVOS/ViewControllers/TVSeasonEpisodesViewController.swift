//
//  TVSeasonEpisodesViewController.swift
//  Gondola TVOS
//
//  Created by Chris on 12/02/2017.
//  Copyright © 2017 Chris Hulbert. All rights reserved.
//
//  This shows the details of a season and the list of episodes to choose from.

import UIKit

class TVSeasonEpisodesViewController: UIViewController {
    
    let show: TVShowMetadata
    let season: TVSeasonMetadata
    let backdrop: UIImage?
    
    init(show: TVShowMetadata, season: TVSeasonMetadata, backdrop: UIImage?) {
        self.show = show
        self.season = season
        self.backdrop = backdrop
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var rootView = TVSeasonEpisodesView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.collection.register(PictureCell.self, forCellWithReuseIdentifier: "cell")
        
        rootView.collection.dataSource = self
        // rootView.collection.delegate = self
        
        rootView.title.text = season.name
        rootView.overview.text = season.overview
        
        // Load the backdrop.
        ServiceHelpers.imageRequest(path: show.backdrop) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.rootView.background.image = image
                    UIView.animate(withDuration: 0.3) {
                        self.rootView.background.alpha = 1
                    }
                }
                
            case .failure(let error):
                NSLog("Error loading backdrop: \(error)")
            }
        }
    }
    
}

extension TVSeasonEpisodesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return show.seasons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let episode = season.episodes[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PictureCell
        
        cell.label.text = episode.name
        
        cell.image.image = nil
        cell.imageAspectRatio = 9/16
        
        // TODO use a reusable image view? Or some helper that checks for stale?
        cell.imagePath = episode.image
        ServiceHelpers.imageRequest(path: episode.image) { result in
            DispatchQueue.main.async {
                if cell.imagePath == episode.image { // Cell hasn't been recycled?
                    switch result {
                    case .success(let image):
                        cell.image.image = image
                        
                    case .failure(let error):
                        NSLog("error: \(error)")
                        // TODO show sad cloud image.
                    }
                }
            }
        }
        
        return cell
    }
    
}

class TVSeasonEpisodesView: UIView {
    
    let background = UIImageView()
    let dim = UIView()
    let title = UILabel()
    let overview = UILabel()
    let collection: UICollectionView
    let layout = UICollectionViewFlowLayout()
    
    init() {
        // TODO have a layout helper.
        layout.scrollDirection = .vertical
        let itemHeight = PictureCell.height(forWidth: K.itemWidth, imageAspectRatio: 9/16)
        layout.itemSize = CGSize(width: K.itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: LayoutHelpers.vertMargins, left: LayoutHelpers.sideMargins, bottom: LayoutHelpers.vertMargins, right: LayoutHelpers.sideMargins)
        
        collection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collection.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
        
        super.init(frame: CGRect.zero)
        
        background.contentMode = .scaleAspectFill
        background.alpha = 0
        addSubview(background)
        
        dim.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(dim)
        
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 60, weight: UIFontWeightThin)
        addSubview(title)
        
        overview.textColor = UIColor.white
        overview.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightLight)
        overview.numberOfLines = 0
        addSubview(overview)
        
        addSubview(collection)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = bounds.width
        let h = bounds.height
        
        background.frame = bounds
        
        let collectionWidth = K.itemWidth + 2*LayoutHelpers.sideMargins
        collection.frame = CGRect(x: w - collectionWidth, y: 0, width: collectionWidth, height: h)
        
        dim.frame = CGRect(x: 0, y: 0, width: w - collectionWidth, height: h)
        
        title.frame = CGRect(x: LayoutHelpers.sideMargins,
                             y: LayoutHelpers.vertMargins,
                             width: w/2 - 2*LayoutHelpers.sideMargins,
                             height: ceil(title.font.lineHeight))
        
        let overviewTop = title.frame.maxY + 40
        let overviewBottom = collection.frame.minY - LayoutHelpers.vertMargins
        let overviewWidth = w/2 - 2*LayoutHelpers.sideMargins
        let maxOverviewHeight = overviewBottom - overviewTop
        let textOverviewHeight = ceil(overview.sizeThatFits(CGSize(width: overviewWidth, height: 999)).height)
        let overviewHeight = min(textOverviewHeight, maxOverviewHeight)
        overview.frame = CGRect(x: LayoutHelpers.sideMargins,
                                y: overviewTop,
                                width: 100, //overviewWidth,
                                height: 100) //overviewHeight)
    }
    
    struct K {
        static let itemWidth: CGFloat = round(UIScreen.main.bounds.width/4)
    }
    
}
