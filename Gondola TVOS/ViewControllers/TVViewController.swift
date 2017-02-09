//
//  TVViewController.swift
//  Gondola TVOS
//
//  Created by Chris on 9/02/2017.
//  Copyright © 2017 Chris Hulbert. All rights reserved.
//

import UIKit

class TVViewController: UIViewController {
    
    let metadata: GondolaMetadata
    
    init(metadata: GondolaMetadata) {
        self.metadata = metadata
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var rootView = TVView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        rootView.collection.dataSource = self
//        rootView.collection.delegate = self
    }
    
}

extension TVViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 // metadata.tvShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let b = UIView()
        b.backgroundColor = UIColor.white
        cell.backgroundView = b
        return cell
    }

}

class TVView: UIView {
    
    let collection: UICollectionView
    
    init() {
        let size = UIScreen.main.bounds.size
        
        // TODO have a layout helper.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let itemWidth = round((size.width - 2*60 - 4*20) / 5)
        let itemHeight = round(itemWidth * 1.5)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        collection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        
        super.init(frame: CGRect.zero)
        
        addSubview(collection)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = bounds.width
        let h = bounds.height

        collection.frame = bounds
    }
    
}
