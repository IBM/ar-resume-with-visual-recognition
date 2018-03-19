# Augmented Reality based Résumé with Visual Recognition
In this code pattern, we will create augmented reality based résumé with Visual recognition. The iOS app recognizes the face and presents you with the AR view that contains details of the person in the camera view. The app utilizes IBM Visual Recognition to classify the image and uses that classification to get details about the person that is stored in IBM Cloudant


# Flow

![ARResume Architecture](architecture.png)

1. User initiates the ar app.
2. App opens up the camera view to detect the face, and crops it.
3. Classify cropped face using IBM Visual Recognition
4. Get details from IBM Cloudant using the classification
5. Overlay the data in front of the user in the mobile camera view


# Included Components
* [ARKit](https://developer.apple.com/arkit/): ARKit is an augmented reality framework for iOS applications.
* [Watson Visual Recognition](https://www.ibm.com/watson/developercloud/visual-recognition.html): Visual Recognition understands the contents of images - visual concepts tag the image, find human faces, approximate age and gender, and find similar images in a collection.
* [Cloudant NoSQL DB](https://console.ng.bluemix.net/catalog/services/cloudant-nosql-db): A fully managed data layer designed for modern web and mobile applications that leverages a flexible JSON schema.

# Technologies

* [Artificial Intelligence](https://medium.com/ibm-data-science-experience): Artificial intelligence can be applied to disparate solution spaces to deliver disruptive technologies.
* [Mobile](https://mobilefirstplatform.ibmcloud.com/): Systems of engagement are increasingly using mobile technology as the platform for delivery.

# Watch the Video

[![](https://i.ytimg.com/vi/9ue2ClqNzsE/0.jpg)](https://youtu.be/9ue2ClqNzsE)

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

To add the document you can use the followig POST command

```
curl https://$ACCOUNT.cloudant.com/$DATABASE \
    -X POST \
    -H "Content-Type: application/json" \
    -d "$JSON"
```

where `$ACCOUNT` is your bluemix account id, `$DATABASE` is the database you created in IBM Cloudant and `$JSON` is above json.

3. Run the app and point the camera view to your image.

# Links
* [ARKit](https://developer.apple.com/arkit)
* [Watson Swift SDK](https://github.com/watson-developer-cloud/swift-sdk)
* [IBM Visual Recognition](https://www.ibm.com/watson/services/visual-recognition-4)
* [IBM Cloudant](https://www.ibm.com/cloud/cloudant) 

# License
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)



