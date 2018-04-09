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

import Foundation
import Vision
import ARKit

public extension CIImage {
    
    var rotate: CIImage {
        get {
            return self.oriented(UIDevice.current.orientation.cameraOrientation())
        }
    }
    
    /// Cropping the image containing the face.
    ///
    /// - Parameter toFace: the face to extract
    /// - Returns: the cropped image
    func cropImage(toFace face: VNFaceObservation) -> CIImage {
        let percentage: CGFloat = 0.6
        
        let width = face.boundingBox.width * CGFloat(extent.size.width)
        let height = face.boundingBox.height * CGFloat(extent.size.height)
        let x = face.boundingBox.origin.x * CGFloat(extent.size.width)
        let y = face.boundingBox.origin.y * CGFloat(extent.size.height)
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        let increasedRect = rect.insetBy(dx: width * -percentage, dy: height * -percentage)
        return self.cropped(to: increasedRect)
    }
}

private extension UIDeviceOrientation {
    func cameraOrientation() -> CGImagePropertyOrientation {
        switch self {
        case .landscapeLeft: return .up
        case .landscapeRight: return .down
        case .portraitUpsideDown: return .left
        default: return .right
        }
    }
}

