//
//  SCNNode+Text.swift
//  ResumeAR
//
//  Created by Sanjeev Ghimire on 11/28/17.
//  Copyright © 2017 Sanjeev Ghimire. All rights reserved.
//
import Foundation
import ARKit
//import Async
import SwiftyJSON

public extension SCNNode {
    convenience init(withJSON profile : JSON, position: SCNVector3) {
        let bubbleDepth : Float = 0.01 // the 'depth' of 3D text
        
        // TEXT BILLBOARD CONSTRAINT
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
//        let container = SCNBox.init(width: 0.5, height: 0.5, length: 0.01, chamferRadius: 0)
//        let containerNode = SCNNode(geometry: container)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.black;
//
//        container.firstMaterial = material
//        containerNode.scale = SCNVector3Make(0.5, 0.5, 0.5)
//        containerNode.simdPosition = simd_float3.init(x: 0, y: 0, z: 0)
        
        // Full Name text
        let fullName = profile["fullname"].stringValue
        let fullNameBubble = SCNText(string: fullName, extrusionDepth: CGFloat(bubbleDepth))
        fullNameBubble.font = UIFont(name: "Times New Roman", size: 0.10)?.withTraits(traits: .traitBold)
        fullNameBubble.alignmentMode = kCAAlignmentCenter
        fullNameBubble.firstMaterial?.diffuse.contents = UIColor.black
        fullNameBubble.firstMaterial?.specular.contents = UIColor.white
        fullNameBubble.firstMaterial?.isDoubleSided = true
        fullNameBubble.chamferRadius = CGFloat(bubbleDepth)
        // fullname BUBBLE NODE
        let (minBound, maxBound) = fullNameBubble.boundingBox
        let fullNameNode = SCNNode(geometry: fullNameBubble)
        // Centre Node - to Centre-Bottom point
        fullNameNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        fullNameNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        fullNameNode.simdPosition = simd_float3.init(x: 0.1, y: 0.06, z: 0)
        
        
        // linkedin text
        let linkedIn = "LinkedIn: " + profile["linkedin"].stringValue
        let linkedInBubble = SCNText(string: linkedIn, extrusionDepth: CGFloat(bubbleDepth))
        linkedInBubble.font = UIFont(name: "Times New Roman", size: 0.10)?.withTraits(traits: .traitBold)
        linkedInBubble.alignmentMode = kCAAlignmentCenter
        linkedInBubble.firstMaterial?.diffuse.contents = UIColor.black
        linkedInBubble.firstMaterial?.specular.contents = UIColor.white
        linkedInBubble.firstMaterial?.isDoubleSided = true
        linkedInBubble.chamferRadius = CGFloat(bubbleDepth)
        // fullname BUBBLE NODE
        //let (minBoundL, maxBoundL) = linkedInBubble.boundingBox
        let linkedInNode = SCNNode(geometry: linkedInBubble)
        // Centre Node - to Centre-Bottom point
        linkedInNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        linkedInNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        linkedInNode.simdPosition = simd_float3.init(x: 0.1, y: 0.05, z: 0)
        //twitter text
        let twitter = "Twitter: " + profile["twitter"].stringValue
        let twitterBubble = SCNText(string: twitter, extrusionDepth: CGFloat(bubbleDepth))
        twitterBubble.font = UIFont(name: "Times New Roman", size: 0.10)?.withTraits(traits: .traitBold)
        twitterBubble.alignmentMode = kCAAlignmentCenter
        twitterBubble.firstMaterial?.diffuse.contents = UIColor.black
        twitterBubble.firstMaterial?.specular.contents = UIColor.white
        twitterBubble.firstMaterial?.isDoubleSided = true
        twitterBubble.chamferRadius = CGFloat(bubbleDepth)
        // fullname BUBBLE NODE
        //let (minBoundL, maxBoundL) = linkedInBubble.boundingBox
        let twitterNode = SCNNode(geometry: twitterBubble)
        // Centre Node - to Centre-Bottom point
        twitterNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        twitterNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        twitterNode.simdPosition = simd_float3.init(x: 0.1, y: 0.04, z: 0)
        //facebook
        let facebook = "Facebook: "+profile["facebook"].stringValue
        let fbBubble = SCNText(string: facebook, extrusionDepth: CGFloat(bubbleDepth))
        fbBubble.font = UIFont(name: "Times New Roman", size: 0.10)?.withTraits(traits: .traitBold)
        fbBubble.alignmentMode = kCAAlignmentCenter
        fbBubble.firstMaterial?.diffuse.contents = UIColor.black
        fbBubble.firstMaterial?.specular.contents = UIColor.white
        fbBubble.firstMaterial?.isDoubleSided = true
        fbBubble.chamferRadius = CGFloat(bubbleDepth)
        // fullname BUBBLE NODE
        //let (minBoundL, maxBoundL) = linkedInBubble.boundingBox
        let fbNode = SCNNode(geometry: fbBubble)
        // Centre Node - to Centre-Bottom point
        fbNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        fbNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        fbNode.simdPosition = simd_float3.init(x: 0.1, y: 0.03, z: 0)
        //phone
        let phone = "Phone: "+profile["phone"].stringValue
        let phoneBubble = SCNText(string: phone, extrusionDepth: CGFloat(bubbleDepth))
        phoneBubble.font = UIFont(name: "Times New Roman", size: 0.10)?.withTraits(traits: .traitBold)
        phoneBubble.alignmentMode = kCAAlignmentCenter
        phoneBubble.firstMaterial?.diffuse.contents = UIColor.black
        phoneBubble.firstMaterial?.specular.contents = UIColor.white
        phoneBubble.firstMaterial?.isDoubleSided = true
        phoneBubble.chamferRadius = CGFloat(bubbleDepth)
        // fullname BUBBLE NODE
        //let (minBoundL, maxBoundL) = linkedInBubble.boundingBox
        let phoneNode = SCNNode(geometry: phoneBubble)
        // Centre Node - to Centre-Bottom point
        phoneNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        phoneNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        phoneNode.simdPosition = simd_float3.init(x: 0.1, y: 0.02, z: 0)
        //location
        let location = "Location: "+profile["location"].stringValue
        let locBubble = SCNText(string: location, extrusionDepth: CGFloat(bubbleDepth))
        locBubble.font = UIFont(name: "Times New Roman", size: 0.10)?.withTraits(traits: .traitBold)
        locBubble.alignmentMode = kCAAlignmentCenter
        locBubble.firstMaterial?.diffuse.contents = UIColor.black
        locBubble.firstMaterial?.specular.contents = UIColor.white
        locBubble.firstMaterial?.isDoubleSided = true
        locBubble.chamferRadius = CGFloat(bubbleDepth)
        // fullname BUBBLE NODE
        //let (minBoundL, maxBoundL) = linkedInBubble.boundingBox
        let locNode = SCNNode(geometry: locBubble)
        // Centre Node - to Centre-Bottom point
        locNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        locNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        locNode.simdPosition = simd_float3.init(x: 0.1, y: 0.01, z: 0)
        
        // 3D IMAGE NODE
        let faceScene = SCNScene(named: "art.scnassets/ship.scn")
        //let box = SCNBox.init(width: 0.5, height: 0.5, length: 0.01, chamferRadius: 0)
        let boxNode = SCNNode()
        //faceScene!.rootNode.addChildNode(boxNode)
        boxNode.addChildNode((faceScene?.rootNode)!)
        boxNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        boxNode.simdPosition = simd_float3.init(x: -0.05, y: 0, z: 0)
        
        // CENTRE POINT NODE
        let sphere = SCNSphere(radius: 0.004)
        sphere.firstMaterial?.diffuse.contents = UIColor.gray
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.opacity = 0.6
        
//        containerNode.addChildNode(boxNode)
//        containerNode.addChildNode(bubbleNode)
//        containerNode.addChildNode(sphereNode)
        
        
        self.init()
        addChildNode(boxNode)
        addChildNode(fullNameNode)
        addChildNode(linkedInNode)
        addChildNode(twitterNode)
        addChildNode(fbNode)
        addChildNode(phoneNode)
        addChildNode(locNode)
        addChildNode(sphereNode)
        //addChildNode(containerNode)
        constraints = [billboardConstraint]
        self.position = position
    }
    
    func move(_ position: SCNVector3)  {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.4
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        self.position = position
        opacity = 1
        SCNTransaction.commit()
    }
    
    func hide()  {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 2.0
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        opacity = 0
        SCNTransaction.commit()
    }
    
    func show()  {
        opacity = 0
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.4
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        opacity = 1
        SCNTransaction.commit()
    }
}

private extension UIFont {
    // Based on: https://stackoverflow.com/questions/4713236/how-do-i-set-bold-and-italic-on-uilabel-of-iphone-ipad
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
}

