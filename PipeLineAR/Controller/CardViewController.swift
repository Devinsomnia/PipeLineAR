//
//  CardViewController.swift
//  PipeLineAR
//
//  Created by Tuncay Cansız on 13.09.2019.
//  Copyright © 2019 Tuncay Cansız. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    //MARK: - Variables
    var viewController : ViewController!
    public var items = [Items]()
    var groupName = ""
    var selectedItem = 0
    
    //MARK: - All Object on the CardViewContoller
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(tap(_:))))
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    let cardView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardViewHeader: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 254, green: 252, blue: 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor.rgb(red: 220, green: 220, blue: 220, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var headerLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 77, green: 75, blue: 82, alpha: 1)
        label.numberOfLines = 1
        (Device.deviceModel == "iPhone") ? (label.font = UIFont.boldSystemFont(ofSize: (Device.screenWidth * 0.035))) : (label.font = UIFont.boldSystemFont(ofSize: (Device.screenWidth * 0.025)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cardViewBody: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var explanationLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.rgb(red: 77, green: 75, blue: 82, alpha: 1)
        label.numberOfLines = 1
        (Device.deviceModel == "iPhone") ? (label.font = UIFont.boldSystemFont(ofSize: (Device.screenWidth * 0.03))) : (label.font = UIFont.boldSystemFont(ofSize: (Device.screenWidth * 0.02)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(CardViewController.clearCardView), name: NSNotification.Name("clearCardView"), object: nil)
        setupCardViewController()
    }
    
    //MARK: - All Object on CardViewController are located here.
    func setupCardViewController(){
        view.addSubview(cardView)
        NSLayoutConstraint.activate([cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     cardView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     cardView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        cardView.addSubview(cardViewHeader)
        NSLayoutConstraint.activate([cardViewHeader.topAnchor.constraint(equalTo: cardView.topAnchor),
                                     cardViewHeader.leftAnchor.constraint(equalTo: cardView.leftAnchor),
                                     cardViewHeader.rightAnchor.constraint(equalTo: cardView.rightAnchor),
                                     cardViewHeader.heightAnchor.constraint(equalToConstant: (Device.screenHeight * 8 / 100))
        ])
        
        cardView.addSubview(separatorView)
        NSLayoutConstraint.activate([separatorView.topAnchor.constraint(equalTo: cardViewHeader.bottomAnchor),
                                     separatorView.leftAnchor.constraint(equalTo: cardViewHeader.leftAnchor),
                                     separatorView.rightAnchor.constraint(equalTo: cardViewHeader.rightAnchor),
                                     separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        cardViewHeader.addSubview(headerLabel)
        NSLayoutConstraint.activate([headerLabel.centerYAnchor.constraint(equalTo: cardViewHeader.centerYAnchor),
                                     headerLabel.centerXAnchor.constraint(equalTo: cardViewHeader.centerXAnchor)
        ])
        
        cardView.addSubview(cardViewBody)
        NSLayoutConstraint.activate([cardViewBody.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
                                     cardViewBody.leftAnchor.constraint(equalTo: cardView.leftAnchor),
                                     cardViewBody.rightAnchor.constraint(equalTo: cardView.rightAnchor),
                                     cardViewBody.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
        
        cardViewBody.addSubview(explanationLabel)
        NSLayoutConstraint.activate([explanationLabel.topAnchor.constraint(equalTo: cardViewBody.topAnchor, constant: (Device.screenWidth * 1) / 100),
                                     explanationLabel.leftAnchor.constraint(equalTo: cardViewBody.leftAnchor, constant: (Device.screenWidth * 1) / 100)
        ])
        
        cardViewBody.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: (Device.screenWidth * 1) / 100),
                                     collectionView.leadingAnchor.constraint(equalTo: cardViewBody.leadingAnchor, constant: (Device.screenWidth * 1) / 100),
                                     collectionView.trailingAnchor.constraint(equalTo: cardViewBody.trailingAnchor, constant: -(Device.screenWidth * 1) / 100),
                                     collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}

extension CardViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: collectionView.frame.width/2)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCell {
            let data = items[indexPath.row]
            cell.updateViews(item: data)
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
            return cell
        }
        return CustomCell()
    }
    
    //MARK: - Touch Functions
    @objc func clearCardView(){
        if groupName == "Planets" {
            items = ItemService.instance.getItems(forGroupName: "Planets")
        }
        else if groupName == "Furnitures"{
            items = ItemService.instance.getItems(forGroupName: "Furnitures")
        }
        else if groupName == "Cubes" {
            items = ItemService.instance.getItems(forGroupName: "Cubes")
        }
        else if groupName == "Characters" {
            items = ItemService.instance.getItems(forGroupName: "Characters")
        }
        else{
            items.removeAll()
        }
        self.collectionView.reloadData()
    }

    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        
        if let index = indexPath {
            selectedItem = index.row + 1
            NotificationCenter.default.post(name: NSNotification.Name("addARViewObject"), object: nil)
        }
    }
}

//MARK: - ViewCell
class CustomCell: UICollectionViewCell {
    
    fileprivate let bg: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .blue
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    func updateViews(item: Items) {
        bg.image = UIImage(named: item.itemImage)
    }
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
    
        contentView.addSubview(bg)
        NSLayoutConstraint.activate([bg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                     bg.widthAnchor.constraint(equalToConstant: 50),
                                     bg.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

