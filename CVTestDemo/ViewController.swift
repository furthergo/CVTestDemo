//
//  ViewController.swift
//  CVTestDemo
//
//  Created by futhergo on 2020/7/23.
//  Copyright © 2020 futhergo. All rights reserved.
//

import UIKit

class Item: NSObject {
    var name = "123"
    var count = 3
}

class ItemCell: UICollectionViewCell {
    private let nameLabel = UILabel(frame: .zero)
    private let countLabel = UILabel(frame: .zero)
    
    var item: Item? {
        didSet {
            nameLabel.text = item?.name
            countLabel.text = "\(item?.count ?? 0)"
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configSubViews() {
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 15)
        contentView.addSubview(nameLabel)
        
        countLabel.textColor = .yellow
        countLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        contentView.addSubview(countLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 20, y: 0, width: 100, height: contentView.bounds.height)
    }
}

class ViewController: UIViewController {
    
    private let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var ds = [Item]()
    
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        configSubViews()
        let t = Timer(timeInterval: 0.5, target: self, selector: #selector(refreshDS), userInfo: nil, repeats: true)
        t.fire()
        timer = t
        RunLoop.current.add(t, forMode: .common)
    }

    private func configSubViews() {
        let ly = UICollectionViewFlowLayout()
        ly.scrollDirection = .vertical
        ly.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        ly.minimumLineSpacing = 0
        ly.minimumInteritemSpacing = 0
        cv.collectionViewLayout = ly
        cv.register(ItemCell.self, forCellWithReuseIdentifier: "cell.cell")
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        view.addSubview(cv)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cv.frame = view.bounds
    }
    
    @objc private func refreshDS() {
        let c = 1 + Int(arc4random_uniform(20))
        ds.removeAll()
        for i in 0..<c {
            let item = Item()
            item.name = "\(c - i)"
            item.count = c - i
            ds.append(item)
        }
        cv.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell.cell", for: indexPath)
        (cell as? ItemCell)?.item = ds[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("will display\(ds[indexPath.row])")
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("end  display\(ds[indexPath.row])")
    }
}

