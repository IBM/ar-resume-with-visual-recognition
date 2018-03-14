# Augmented Reality based Résumé with Visual Recognition
In this code pattern, we will create augmented reality based résumé with Visual recognition. The iOS app recognizes the face and presents you with the AR view that contains details of the person in the camera view. The app utilizes IBM Visual Recognition to classify the image and uses that classification to get details about the person that is stored in IBM Cloudant


# Flow

![ARResume Architecture](https://github.com/sanjeevghimire/ARBasedResumeWithFaceRecognition/blob/master/ARResume.jpg "ARResume Architecture")

1. Face recognition using iOS Vision API
2. Classify cropped face using IBM Visual Recognition
3. Get details from IBM Cloudant using the classification
4. Overlay the data in front of the user in the mobile camera view


# Included Components
1. Swift mobile app
    1. Face Recognition using Vision API
    1. ARKit : An iOS augmented reality platform        
2. IBM Visual Recognition: An IBM service to analyze the visual content of images or video frames to understand what is happening in a scene
3. IBM Cloudant DB: A highly scalable and performant JSON database service


# Steps
1. Clone the project using `git clone https://github.com/IBM/ARBasedResumeWithFaceRecognition`
2. Login to IBM Bluemix account, create a IBM Visual Recognition service and save the credentials.
3. Using the IBM Visual Recognition Beta Tool, create a classifier. A classifier will train the visual recognition so that the    VR API will recognizse different images of the same person. Use atleast 10 images of your head shot and also use a negative    training by using a different headshot which is not you.
4. Create a IBM Cloudant database and save the credentials. Create a JSON with the classificationId as one of the key-value      pair. This ID will be used to retrieve details about the classified person.
5. Update the `credentials.swift` file with the Cloudant and VR credentials as the app communicates with both of the services    using their API
6. Open the cloned project using `Xcode`
7. From command line, run `pod install`
8. After `step 7` is done, run `carthage update --platform iOS`
9. Once `step 7` and `step 8` are successful, `build and run` using Xcode.


3. Get IBM Cloudant Database and update the Credentials.swift
4. Open the project using Xcode
5. Build and Run

# Test
To test locally you can do the following: 
1. Train IBM visual recognition with your head shot images. Please use atleast 10 images of your head shot and use a negative trainig by using a different head shot which is not you.
2. Update the cloudant database using the classification id from the training to store your information. The JSON will be in the format:

```
{  
  "classificationId": "<classification id from vr training>",
  "fullname": "<name of the person in image>",
  "linkedin": "<linked in user id of the person in image>",
  "twitter": "<twitter username of the person in image>",
  "facebook": "<facebook username of the person in image>",
  "phone": "<phone number of the person in image>",
  "location": "<location (city,state) of the person in image>"
}
```
3. Run the app and point the camera view to your image.

# Links
* [ARKit](https://developer.apple.com/arkit)
* [Watson Swift SDK](https://github.com/watson-developer-cloud/swift-sdk)
* [IBM Visual Recognition](https://www.ibm.com/watson/services/visual-recognition-4)
* [IBM Cloudant](https://www.ibm.com/cloud/cloudant) 

# License
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)



