//
//  ViewController.swift
//  PipeLineAR
//
//  Created by Tuncay Cansız on 12.09.2019.
//  Copyright © 2019 Tuncay Cansız. All rights reserved.
//

import UIKit
import RealityKit
import ARKit
import Vision

class ViewController: UIViewController {
    
    //MARK: - Variables
    @IBOutlet var arView: ARView!
    
    var cardViewController:CardViewController!
    
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    var visionRequests = [VNRequest]()
    var handDetect = true
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    let cardHeight:CGFloat = 160
    let cardHandleAreaHeight:CGFloat = 0
    
    var cardVisible = false
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    var buttonSenderTag = 0

    
    
    //MARK: - All Object on the ViewContoller
    
    lazy var createPlanetButton : UIButton = {
        let image = UIImage(named: "world") as UIImage?
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTapPlanetButton(recognizer:)))
        button.addGestureRecognizer(tapGestureRecognizer)
        return button
    }()
    
    lazy var createFurnitureButton: UIButton = {
        let image = UIImage(named: "furniture") as UIImage?
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTapFurnitureButton(recognizer:)))
        button.addGestureRecognizer(tapGestureRecognizer)
        return button
    }()
    
    
    lazy var createCubeButton : UIButton = {
        let image = UIImage(named: "cubeBox") as UIImage?
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTapCubeButton(recognizer:)))
        button.addGestureRecognizer(tapGestureRecognizer)
        return button
    }()
    
    lazy var createCharacterButton : UIButton = {
        let image = UIImage(named: "astronaut") as UIImage?
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTapCharacterButton(recognizer:)))
         button.addGestureRecognizer(tapGestureRecognizer)
        return button
    }()
    
    var crossAim : UIImageView = {
        let image = UIImage(named: "crossAim")
        let iv = UIImageView()
        iv.image = image
        iv.isHidden = true
        iv.clipsToBounds = true
        iv.contentMode = UIView.ContentMode.scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        setupCardViewController()
            
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.addARViewObject), name: NSNotification.Name("addARViewObject"), object: nil)
                
        // Setup Vision Model
        guard let selectedModel = try? VNCoreMLModel(for: hand_model().model) else {
            fatalError("Model not founded.")
        }
    
        // Set up Vision-CoreML Request
        let classificationRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
        visionRequests = [classificationRequest]
        
        // Begin Loop to Update CoreML
        loopCoreMLUpdate()
    }
    
    //MARK: - Touch Functions
    @objc func addARViewObject(){
        if cardViewController.groupName == "Planets" {
            switch cardViewController.selectedItem {
            case 1:
                let worldAnchor = try! Experience.loadEarthDay()
                arView.scene.anchors.append(worldAnchor)
                break
            case 2:
                let worldAnchor = try! Experience.loadEarthNight()
                arView.scene.anchors.append(worldAnchor)
            case 3:
                let worldAnchor = try! Experience.loadMoon()
                arView.scene.anchors.append(worldAnchor)
            
            case 4:
                let worldAnchor = try! Experience.loadCeresFictional()
                arView.scene.anchors.append(worldAnchor)
            
            case 5:
                let worldAnchor = try! Experience.loadErisFictional()
                arView.scene.anchors.append(worldAnchor)
            
            case 6:
                let worldAnchor = try! Experience.loadHuemeaFictional()
                arView.scene.anchors.append(worldAnchor)
            
            case 7:
                let worldAnchor = try! Experience.loadJupiter()
                arView.scene.anchors.append(worldAnchor)
            
            case 8:
                let worldAnchor = try! Experience.loadMars()
                arView.scene.anchors.append(worldAnchor)
            case 9:
                let worldAnchor = try! Experience.loadMercury()
                arView.scene.anchors.append(worldAnchor)
            default:
                print("nil")
            }
        }
        
        if cardViewController.groupName == "Furnitures" {
            switch cardViewController.selectedItem {
            case 1:
                let furnitureAnchor = try! Experience.loadFurniture1()
                arView.scene.anchors.append(furnitureAnchor)
                break
            case 2:
                let furnitureAnchor = try! Experience.loadFurniture2()
                arView.scene.anchors.append(furnitureAnchor)
            case 3:
                let furnitureAnchor = try! Experience.loadFurniture3()
                arView.scene.anchors.append(furnitureAnchor)
            
            case 4:
                let furnitureAnchor = try! Experience.loadFurniture4()
                arView.scene.anchors.append(furnitureAnchor)
            
            case 5:
                let furnitureAnchor = try! Experience.loadFurniture5()
                arView.scene.anchors.append(furnitureAnchor)
            
            case 6:
                let furnitureAnchor = try! Experience.loadFurniture6()
                arView.scene.anchors.append(furnitureAnchor)
            default:
                print("nil")
            }
        }
        
        if cardViewController.groupName == "Cubes" {
            switch cardViewController.selectedItem {
            case 1:
                let cubeAnchor = try! Experience.loadCube1()
                arView.scene.anchors.append(cubeAnchor)
                break
            case 2:
                let cubeAnchor = try! Experience.loadCube2()
                arView.scene.anchors.append(cubeAnchor)
            case 3:
                let cubeAnchor = try! Experience.loadCube3()
                arView.scene.anchors.append(cubeAnchor)
            default:
                print("nil")
            }
        }
        
        if cardViewController.groupName == "Characters" {
            switch cardViewController.selectedItem {
            case 1:
                let characterAnchor = try! Experience.loadCharacter1()
                arView.scene.anchors.append(characterAnchor)
                break
            case 2:
                let characterAnchor = try! Experience.loadCharacter2()
                arView.scene.anchors.append(characterAnchor)
            default:
                print("nil")
            }
        }
    }
    
    @objc func handleCardTapPlanetButton(recognizer:UITapGestureRecognizer) {
        cardViewController.groupName = "Planets"
        cardViewController.headerLabel.text = "Planet Object"
        cardViewController.explanationLabel.text = "Some Planet Object"
        NotificationCenter.default.post(name: NSNotification.Name("clearCardView"), object: nil)
        
        self.buttonSenderTag = 1
        
        self.createFurnitureButton.isHidden = true
        self.createCubeButton.isHidden = true
        self.createCharacterButton.isHidden = true
        self.crossAim.isHidden = false
        
        if self.cardVisible == true {
            self.buttonSenderTag = 0
            self.createFurnitureButton.isHidden = false
            self.createCubeButton.isHidden = false
            self.createCharacterButton.isHidden = false
            self.crossAim.isHidden = true
        }
        
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.3)
        default:
            break
        }
    }
    
    
    @objc func handleCardTapFurnitureButton(recognizer:UITapGestureRecognizer) {
        cardViewController.groupName = "Furnitures"
        cardViewController.headerLabel.text = "Furniture Object"
        cardViewController.explanationLabel.text = "Some Furniture Object"
        NotificationCenter.default.post(name: NSNotification.Name("clearCardView"), object: nil)
    
        self.buttonSenderTag = 2
        
        self.createPlanetButton.isHidden = true
        self.createCubeButton.isHidden = true
        self.createCharacterButton.isHidden = true
        self.crossAim.isHidden = false
        
        if self.cardVisible == true {
            self.buttonSenderTag = 0
            self.createPlanetButton.isHidden = false
            self.createCubeButton.isHidden = false
            self.createCharacterButton.isHidden = false
            self.crossAim.isHidden = true
        }
        
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.3)
        default:
            break
        }
    }
    
    @objc func handleCardTapCubeButton(recognizer:UITapGestureRecognizer) {
        cardViewController.groupName = "Cubes"
        cardViewController.headerLabel.text = "Cube Object"
        cardViewController.explanationLabel.text = "Some Cube Object"
        NotificationCenter.default.post(name: NSNotification.Name("clearCardView"), object: nil)
        
        self.buttonSenderTag = 3
        
        self.createPlanetButton.isHidden = true
        self.createFurnitureButton.isHidden = true
        self.createCharacterButton.isHidden = true
        self.crossAim.isHidden = false
        
        if self.cardVisible == true {
            self.buttonSenderTag = 0
            self.createPlanetButton.isHidden = false
            self.createFurnitureButton.isHidden = false
            self.createCharacterButton.isHidden = false
            self.crossAim.isHidden = true
        }

        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.3)
        default:
            break
        }
    }

    @objc func handleCardTapCharacterButton(recognizer:UITapGestureRecognizer) {
        cardViewController.groupName = "Characters"
        cardViewController.headerLabel.text = "Character Object"
        cardViewController.explanationLabel.text = "Some Character Object"
        NotificationCenter.default.post(name: NSNotification.Name("clearCardView"), object: nil)
        self.buttonSenderTag = 4
        
        self.createPlanetButton.isHidden = true
        self.createCubeButton.isHidden = true
        self.createFurnitureButton.isHidden = true
        self.crossAim.isHidden = false
        
        if self.cardVisible == true {
            self.buttonSenderTag = 0
            self.createPlanetButton.isHidden = false
            self.createCubeButton.isHidden = false
            self.createFurnitureButton.isHidden = false
            self.crossAim.isHidden = true
        }

        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.3)
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
                
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                
                if self.cardVisible == false {
                    self.createPlanetButton.isHidden = false
                    self.createFurnitureButton.isHidden = false
                    self.createCubeButton.isHidden = false
                    self.createCharacterButton.isHidden = false
                    self.cardViewController.groupName = ""
                    self.crossAim.isHidden = true
                }
                self.runningAnimations.removeAll()
            }
                
            frameAnimator.startAnimation()
                runningAnimations.append(frameAnimator)
                let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                    switch state {
                    case .expanded:
                        self.cardViewController.view.layer.cornerRadius = 12
                    case .collapsed:
                        self.cardViewController.view.layer.cornerRadius = 0
                    }
                }
            
                cornerRadiusAnimator.startAnimation()
                runningAnimations.append(cornerRadiusAnimator)
            }
        }
        
        func startInteractiveTransition(state:CardState, duration:TimeInterval) {
            if runningAnimations.isEmpty {
                animateTransitionIfNeeded(state: state, duration: duration)
            }
            for animator in runningAnimations {
                animator.pauseAnimation()
                animationProgressWhenInterrupted = animator.fractionComplete
            }
        }
        
        func updateInteractiveTransition(fractionCompleted:CGFloat) {
            for animator in runningAnimations {
                animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
            }
        }
        
        func continueInteractiveTransition (){
            for animator in runningAnimations {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    //MARK: - All Object on ViewController are located here.
    func setupCardViewController(){
        cardViewController = CardViewController()
        self.addChild(cardViewController)
        self.arView.addSubview(cardViewController.view)
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
    }
    
    func setupButtons(){
        arView.addSubview(createPlanetButton)
        NSLayoutConstraint.activate([createPlanetButton.bottomAnchor.constraint(equalTo: arView.centerYAnchor, constant: -60),
                                     createPlanetButton.rightAnchor.constraint(equalTo: arView.rightAnchor, constant: -5),
                                     createPlanetButton.widthAnchor.constraint(equalToConstant: 50),
                                     createPlanetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    
        arView.addSubview(createFurnitureButton)
        NSLayoutConstraint.activate([createFurnitureButton.topAnchor.constraint(equalTo: createPlanetButton.bottomAnchor, constant: 10),
                                     createFurnitureButton.rightAnchor.constraint(equalTo: arView.rightAnchor, constant: -5),
                                     createFurnitureButton.widthAnchor.constraint(equalToConstant: 50),
                                     createFurnitureButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        arView.addSubview(createCubeButton)
        NSLayoutConstraint.activate([createCubeButton.topAnchor.constraint(equalTo: createFurnitureButton.bottomAnchor, constant: 10),
                                     createCubeButton.rightAnchor.constraint(equalTo: arView.rightAnchor, constant: -5),
                                     createCubeButton.widthAnchor.constraint(equalToConstant: 50),
                                     createCubeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        arView.addSubview(createCharacterButton)
        NSLayoutConstraint.activate([createCharacterButton.topAnchor.constraint(equalTo: createCubeButton.bottomAnchor, constant: 10),
                                     createCharacterButton.rightAnchor.constraint(equalTo: arView.rightAnchor, constant: -5),
                                     createCharacterButton.widthAnchor.constraint(equalToConstant: 50),
                                     createCharacterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        arView.addSubview(crossAim)
        NSLayoutConstraint.activate([crossAim.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
                                     crossAim.centerYAnchor.constraint(equalTo: arView.centerYAnchor),
                                     crossAim.widthAnchor.constraint(equalToConstant: 50),
                                     crossAim.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - MACHINE LEARNING
    func loopCoreMLUpdate() {
        // Continuously run CoreML whenever it's ready. (Preventing 'hiccups' in Frame Rate)
        dispatchQueueML.async {
            // 1. Run Update.
            self.updateCoreML()
            // 2. Loop this function.
            self.loopCoreMLUpdate()
        }
    }
      
    func updateCoreML() {
        // Get Camera Image as RGB
        let pixbuff : CVPixelBuffer? = (arView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
          
        // Prepare CoreML/Vision Request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
          
        // Run Vision Image Request
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
    
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        // Catch Errors
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        
        guard let observations = request.results else {
            print("No results")
            return
        }
          
        // Get Classifications
        let classifications = observations[0...2] // top 3 results
            .compactMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:" : %.2f", $0.confidence))" })
            .joined(separator: "\n")
          
            // Render Classifications
            DispatchQueue.main.async {
                let topPrediction = classifications.components(separatedBy: "\n")[0]
                let topPredictionName = topPrediction.components(separatedBy: ":")[0].trimmingCharacters(in: .whitespaces)
                let topPredictionScore:Float? = Float(topPrediction.components(separatedBy: ":")[1].trimmingCharacters(in: .whitespaces))
        
                if (topPredictionScore! > 0.99 && topPredictionName == "FIVE-UB-RHand"){
                    if self.handDetect == false {
                        print("el var")
                        self.handDetect = true
                        let worldAnchor = try! Experience.loadEarthDay()
                        self.arView.scene.anchors.append(worldAnchor)
                    }
                }
                else{
                    if (topPredictionScore! > 0.01 && topPredictionName == "no-hand"){
                        self.handDetect = false
                }
            }
        }
    }
      
    // MARK: - HIDE STATUS BAR
    override var prefersStatusBarHidden : Bool { return true }
}
