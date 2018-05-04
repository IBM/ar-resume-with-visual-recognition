/**
 
 Copyright 2017 IBM Corp. All Rights Reserved.
 Licensed under the Apache License, Version 2.0 (the 'License'); you may not
 use this file except in compliance with the License. You may obtain a copy of
 the License at
 http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an 'AS IS' BASIS, WITHOUT
 WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 License for the specific language governing permissions and limitations under
 the License.
 */

import UIKit
import SceneKit
import ARKit
import Vision
import RxSwift
import RxCocoa
import SwiftyJSON
import VisualRecognitionV3
import PKHUD
import CoreML


class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var 👜 = DisposeBag()
    var faces: [Face] = []
    var bounds: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var visualRecognition: VisualRecognition?
    var cloudantRestCall: CloudantRESTCall?
    var classifierIds: [String] = ["SanjeevGhimire_967590069","ScottDAngelo_1040670748","SteveMartinelli_2096165720"]
    
    let VERSION = "2017-12-07"
    
    var isTraining: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        bounds = sceneView.bounds
        //configure IBM cloud services required by this app
        self.configureCloudantAndVisualRecognition()
        
        self.cloudantRestCall?.createDatabase(databaseName: Constant.databaseName){ (dbDetails) in
            print(dbDetails)
            if(dbDetails["ok"].exists()){
                //add info for test database.
                let userData1 = ["classificationId": "SteveMartinelli_2096165720",
                                 "fullname": Constant.SteveName,
                                 "linkedin": Constant.SteveLI,
                                 "twitter": Constant.SteveTW,
                                 "facebook": Constant.SteveFB,
                                 "phone": Constant.StevePh,
                                 "location": Constant.SteveLoc]
                
                self.cloudantRestCall?.updatePersonData(userData: JSON(userData1)){ (resultJSON) in
                    if(!resultJSON["ok"].boolValue){
                        print("Error while saving user Data",userData1)
                        return
                    }
                }
                
                let userData2 = ["classificationId": "SanjeevGhimire_967590069",
                                 "fullname": Constant.SanjeevName,
                                 "linkedin": Constant.SanjeevLI,
                                 "twitter": Constant.SanjeevTW,
                                 "facebook": Constant.SanjeevFB,
                                 "phone": Constant.SanjeevPh,
                                 "location": Constant.SanjeevLoc]
                
                self.cloudantRestCall?.updatePersonData(userData: JSON(userData2)){ (resultJSON) in
                    if(!resultJSON["ok"].boolValue){
                        print("Error while saving user Data",userData2)
                        return
                    }
                }
                
                let userData3 = ["classificationId": "ScottDAngelo_1040670748",
                                 "fullname": Constant.ScottName,
                                 "linkedin": Constant.ScottLI,
                                 "twitter": Constant.ScottTW,
                                 "facebook": Constant.ScottFB,
                                 "phone": Constant.ScottPh,
                                 "location": Constant.ScottLoc]
                
                self.cloudantRestCall?.updatePersonData(userData: JSON(userData3)){ (resultJSON) in
                    if(!resultJSON["ok"].boolValue){
                        print("Error while saving user Data",userData3)
                        return
                    }
                }
            }
        }
        
        let localModels = try? self.visualRecognition?.listLocalModels()
            if let count = localModels??.count, count > 0 {
                localModels??.forEach { classifierId in
                    if(!self.classifierIds.contains(classifierId)){
                        self.classifierIds.append(classifierId)
                    }
                }
                self.isTraining = false;
            }else{
            
                self.visualRecognition?.listClassifiers(){
                classifiers in
                    //if in case users have uploaded their images and trained VR in the cloud
                    if(classifiers.classifiers.count > 0 && classifiers.classifiers[0].status == "ready"){
                        classifiers.classifiers.forEach{
                            classifier in
                            if(!self.classifierIds.contains(classifier.classifierID)){
                                self.classifierIds.append(classifier.classifierID)
                            }
                            self.visualRecognition?.updateLocalModel(classifierID: classifier.classifierID)
                        }
                    }
            }
        }
    }
 
    // Setup cloudant driver and visual recognition api
    func configureCloudantAndVisualRecognition() {
        // Retrieve plist
        guard let path = Bundle.main.path(forResource: "BMSCredentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
                return
        }
        
        // Retrieve credentials
        guard let vrApiKey = credentials["visualrecognitionApi_key"] as? String, !vrApiKey.isEmpty,
            let url = credentials["cloudantUrl"] as? String, !url.isEmpty else {
                return
        }
        
        self.visualRecognition = VisualRecognition.init(apiKey: vrApiKey, version: self.VERSION)
        self.cloudantRestCall = CloudantRESTCall.init(cloudantUrl: url)
        self.cloudantRestCall?.database = Constant.databaseName
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
        
        Observable<Int>.interval(0.6, scheduler: SerialDispatchQueueScheduler(qos: .default))
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap{_ in self.updateToLocalModels()}
            .flatMap{_ in self.faceObservation() }
            .flatMap{ Observable.from($0)}
            .flatMap{ self.faceClassification(face: $0.observation, image: $0.image, frame: $0.frame) }
            .subscribe { [unowned self] event in
                guard let element = event.element else {
                    print("No element available")
                    return
                }
                self.updateNode(classes: element.classes, position: element.position, frame: element.frame)
            }.disposed(by: 👜)
        
        Observable<Int>.interval(0.6, scheduler: SerialDispatchQueueScheduler(qos: .default))
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe { [unowned self] _ in
                
                self.faces.filter{ $0.updated.isAfter(seconds: 1.5) && !$0.hidden }.forEach{ face in
                    //print("Hide node: \(face.name)")
                    DispatchQueue.main.async{ face.node.hide() }
                }
            }.disposed(by: 👜)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        👜 = DisposeBag()
        sceneView.session.pause()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
        switch camera.trackingState {
        case .limited(.initializing):
            PKHUD.sharedHUD.contentView = PKHUDProgressView(title: "Initializing", subtitle: nil)
            PKHUD.sharedHUD.show()
        case .notAvailable:
            print("Not available")
        default:
            PKHUD.sharedHUD.hide()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    // MARK: - Face detections
    private func faceObservation() -> Observable<[(observation: VNFaceObservation, image: CIImage, frame: ARFrame)]> {
        return Observable<[(observation: VNFaceObservation, image: CIImage, frame: ARFrame)]>.create{ observer in
            guard let frame = self.sceneView.session.currentFrame else {
                print("No frame available")
                observer.onCompleted()
                return Disposables.create()
            }
            
            // Create and rotate image
            let image = CIImage.init(cvPixelBuffer: frame.capturedImage).rotate
            let facesRequest = VNDetectFaceRectanglesRequest { request, error in
                guard error == nil else {
                    print("Face request error: \(error!.localizedDescription)")
                    observer.onCompleted()
                    return
                }
                guard let observations = request.results as? [VNFaceObservation] else {
                    print("No face observations")
                    observer.onCompleted()
                    return
                }
                // Map response
                let response = observations.map({ (face) -> (observation: VNFaceObservation, image: CIImage, frame: ARFrame) in
                    return (observation: face, image: image, frame: frame)
                })
                observer.onNext(response)
                observer.onCompleted()
                
            }
            try? VNImageRequestHandler(ciImage: image).perform([facesRequest])
            
            return Disposables.create()
        }
    }
    
    
    private func faceClassification(face: VNFaceObservation, image: CIImage, frame: ARFrame) -> Observable<(classes: [ClassifiedImage], position: SCNVector3, frame: ARFrame)> {
        return Observable<(classes: [ClassifiedImage], position: SCNVector3, frame: ARFrame)>.create{ observer in
            
            // Determine position of the face
            let boundingBox = self.transformBoundingBox(face.boundingBox)
            guard let worldCoord = self.normalizeWorldCoord(boundingBox) else {
                print("No feature point found")
                observer.onCompleted()
                return Disposables.create()
            }
            
            // Create Classification request
            let pixel = image.cropImage(toFace: face)
            //convert the cropped image to UI image
            let uiImage: UIImage = self.convert(cmage: pixel)
         
            let failure = { (error: Error) in print(error) }
            guard let visualRecognition = self.visualRecognition else {
                print("No handle on visual recognition service")
                observer.onCompleted()
                return Disposables.create()
            }
            visualRecognition.classifyWithLocalModel(image: uiImage, classifierIDs: self.classifierIds, threshold: 0, failure: failure) { classifiedImages in
                  observer.onNext((classes: classifiedImages.images, position: worldCoord, frame: frame))
                  observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    
    /// Transform bounding box according to device orientation
    ///
    /// - Parameter boundingBox: of the face
    /// - Returns: transformed bounding box
    private func transformBoundingBox(_ boundingBox: CGRect) -> CGRect {
        var size: CGSize
        var origin: CGPoint
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            size = CGSize(width: boundingBox.width * bounds.height,
                          height: boundingBox.height * bounds.width)
        default:
            size = CGSize(width: boundingBox.width * bounds.width,
                          height: boundingBox.height * bounds.height)
        }
        
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            origin = CGPoint(x: boundingBox.minY * bounds.width,
                             y: boundingBox.minX * bounds.height)
        case .landscapeRight:
            origin = CGPoint(x: (1 - boundingBox.maxY) * bounds.width,
                             y: (1 - boundingBox.maxX) * bounds.height)
        case .portraitUpsideDown:
            origin = CGPoint(x: (1 - boundingBox.maxX) * bounds.width,
                             y: boundingBox.minY * bounds.height)
        default:
            origin = CGPoint(x: boundingBox.minX * bounds.width,
                             y: (1 - boundingBox.maxY) * bounds.height)
        }
        
        return CGRect(origin: origin, size: size)
    }
    
    /// In order to get stable vectors, we determine multiple coordinates within an interval.
    ///
    /// - Parameters:
    ///   - boundingBox: Rect of the face on the screen
    /// - Returns: the normalized vector
    private func normalizeWorldCoord(_ boundingBox: CGRect) -> SCNVector3? {
        
        var array: [SCNVector3] = []
        Array(0...2).forEach{_ in
            if let position = determineWorldCoord(boundingBox) {
                array.append(position)
            }
            //usleep(12000) // .012 seconds
        }
        
        if array.isEmpty {
            return nil
        }
        
        return SCNVector3.center(array)
    }
    
    
    /// Determine the vector from the position on the screen.
    ///
    /// - Parameter boundingBox: Rect of the face on the screen
    /// - Returns: the vector in the sceneView
    private func determineWorldCoord(_ boundingBox: CGRect) -> SCNVector3? {
        let arHitTestResults = sceneView.hitTest(CGPoint(x: boundingBox.midX, y: boundingBox.midY), types: [.featurePoint])
        
        // Filter results that are to close
        if let closestResult = arHitTestResults.filter({ $0.distance > 0.10 }).first {
            //            print("vector distance: \(closestResult.distance)")
            return SCNVector3.positionFromTransform(closestResult.worldTransform)
        }
        return nil
    }
    
    private func updateNode(classes: [ClassifiedImage], position: SCNVector3, frame: ARFrame) {
        guard let classifiedImage = classes.first else {
            print("No classification found")
            return
        }
        
        // get the classifier result with best score
        var personWithHighScore: ClassifierResult? = nil
        var highestScore: Double = 0.0
        classifiedImage.classifiers.forEach { classifierResult in
            guard let score = classifierResult.classes.first?.score else {
                // handle error Throw or return
                print("Score not found in the JSON")
                return
            }
//            let score: Double = (classifierResult.classes.first?.score)!
            if(Double(score) > highestScore){
                highestScore = score
                personWithHighScore = classifierResult
            }
        }
        
        let name = personWithHighScore?.name
        let classifierId = personWithHighScore?.classifierID
        
        // Filter for existent face
        let results = self.faces.filter{ $0.name == name && $0.timestamp != frame.timestamp }
            .sorted{ $0.node.position.distance(toVector: position) < $1.node.position.distance(toVector: position) }
        
        // Create new face
        //note:: texture
        guard let existentFace = results.first else {
            self.cloudantRestCall?.getResumeInfo(classificationId: classifierId!) { (resultJSON) in
                let node = SCNNode.init(withJSON: resultJSON["docs"][0], position: position)
                DispatchQueue.main.async {
                    self.sceneView.scene.rootNode.addChildNode(node)
                    node.show()
                }
                let face = Face.init(name: name!, node: node, timestamp: frame.timestamp)
                self.faces.append(face)
            }
            return
        }
        // Update existent face
        DispatchQueue.main.async {
            
            // Filter for face that's already displayed
            if let displayFace = results.filter({ !$0.hidden }).first  {
                let distance = displayFace.node.position.distance(toVector: position)
                if(distance >= 0.03 ) {
                    displayFace.node.move(position)
                }
                displayFace.timestamp = frame.timestamp
                
            } else {
                existentFace.node.position = position
                existentFace.node.show()
                existentFace.timestamp = frame.timestamp
            }
        }
    }
    
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
   
    private func updateToLocalModels() -> Observable<Bool>{
        return Observable<Bool>.create{ observer in
            // check if visual recognition is not ready yet.
            self.visualRecognition?.listClassifiers(){ classifiers in
                let count: Int = classifiers.classifiers.count
                if(count > 0 && classifiers.classifiers[0].status == "ready"){
                    classifiers.classifiers.forEach{
                        classifier in
                        if(!self.classifierIds.contains(classifier.classifierID)){
                            self.classifierIds.append(classifier.classifierID)
                        }
                        self.visualRecognition?.updateLocalModel(classifierID: classifier.classifierID)
                    }
                }
            }
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

