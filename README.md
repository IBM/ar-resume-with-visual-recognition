# Use Watson Visual Recognition to create an Augmented Reality based résumé

The easiest way to find and connect to people around the world is through social media apps like Facebook, Twitter and LinkedIn. These, however, only provide text based search capabilities. However, with the recently announced release of the iOS ARKit toolkit, search is now possible using facial recognition. Combining iOS face recognition using Vision API, classification using IBM Visual Recognition, and person identification using classified image and data, one can build an app to search faces and identify them. One of the use cases is to build a Augmented Reality based résumé using visual recognition.

The main purpose of this code pattern is to demonstrate how to identify a person and his details using Augmented Reality and Visual Recognition. The iOS app recognizes the face and presents you with the AR view that displays a résumé of the person in the camera view. The app utilizes Watson Visual Recognition to classify the image and uses that classification to get details about the person from data stored in a Cloudant NoSQL database.

After completing this code pattern a user will know how to:

* Configure ARKit
* Use the iOS Vision module
* Create a Swift iOS application that uses the Watson Swift SDK
* Use the face classifier of Watson Visual Recognition

# Flow
![ARResume Architecture](images/architecture.png)

1. User opens the app on their mobile
2. A face is detected using the iOS Vision module
3. An image of the face is sent to Watson Visual Recognition to be classified
4. Additional information about the person are retrieved from a Cloudant database based on the classification from Watson Visual Recognition
5. The information from the database is placed in front of the original person's face in the mobile camera view

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

1. At a command line, clone this repo:
```
git clone https://github.com/IBM/ar-resume-with-visual-recognition
```

2. Log into [IBM Cloud](http://bluemix.net/) account and create a [Watson Visual Recognition](https://console.bluemix.net/catalog/services/visual-recognition) service. Create a set of credentials and identify your API key.

3. When the app loads, the app will create 3 classifiers for each of the zip files [`ResumeAR/sanjeev.zip`](ResumeAR/sanjeev.zip), [`ResumeAR/steve.zip`](ResumeAR/steve.zip) and [`ResumeAR/scott.zip`](ResumeAR/scott.zip).
> To create a new classifier use the [Watson Visual Recognition tool](https://watson-visual-recognition.ng.bluemix.net/). A classifier will train the visual recognition service, it will be able to recognize different images of the same person. Use at least ten images of your head shot and also create a negative data set by using headshots that are not your own.

4. Create an [IBM Cloudant NoSQL database](https://console.bluemix.net/catalog/services/cloudant-nosql-db) and save the credentials. Each JSON document in this database represents **one** person. The JSON schema can be found in [`schema.json`]
(ResumeAR/schema.json). When the app loads, it will also create 3 documents for the 3 classification done in step 3. 
> To create new documents in the same database, Use the [`schema.json`](ResumeAR/schema.json) provided to fill out the details. Replace the `classificationId` in the schema with the `classificationId` you receive from the classifier once the Watson Visual Recognition model has been successfully trained. This ID will be used to retrieve details about the classified person.

5. Open the project using `Xcode`.

6. Update [`ResumeAR/Credentials.swift`](ResumeAR/Credentials.swift) with the Cloudant and Watson Visual Recognition credentials.

7. At a command line, run `pod install` to install the dependencies.
![Pod Install Output](images/pod-install-output.png)

8. Run `carthage update --platform iOS` to install the Watson related dependencies.
![Carthage Install Output](images/carthage-output.png)

9. Once the previous steps are complete go back to Xcode and run the application by clicking the the `Build` and `Run` menu options.
![Xcode Build and Run](images/build-and-run.png)

NOTE: The tranining in Watson Visual Recognition might take couple of minutes. If the status is in `training`, then the AR will show `Training in progress` in your view. You can check the status of your classifier by using following curl command:

```
curl "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classifiers?api_key={API_KEY}&verbose=true&version=2016-05-20"
```

Replace the `API_KEY` with the Watson Visual Recognition api key.

10. To test you can use the test images provided in [`images/TestImages`](images/TestImages) folder.

# Adding to the database

To create a new entry in the database perform the following steps: 

1. Create a new Watson Visual Recognition classifier using the [online tool](https://watson-visual-recognition.ng.bluemix.net/) for each person you want to be able to identify, use at least ten images of that person.

2. Update the Cloudant database using the classifier ID from the previous step. To update the database perform a `POST` command like the following:

```
data='{"classificationId":"Watson_VR_Classifier_ID","fullname":"Joe Smith","linkedin":"jsmith","twitter":"jsmith","facebook":"jsmith","phone":"512-555-1234","location":"San Francisco"}'

curl -H "Content-Type: application/json" -X POST -d $data https://$ACCOUNT.cloudant.com/$DATABASE
```

> The `$ACCOUNT` variable is the URL which can be found in the credentials that you created when setting up Cloudant.

> The `$DATABASE` variable is the database name you created in IBM Cloudant.

> See [`ResumeAR/schema.json`](ResumeAR/schema.json) for additional information about the Cloudant database configuration.

3. Run the app and point the camera view to your image.

# Sample Output

![Sample Output](images/sample-output.png)

# Learn more

* **Artificial Intelligence Code Patterns**: Enjoyed this Code Pattern? Check out our other [AI Code Patterns](https://developer.ibm.com/code/technologies/artificial-intelligence/).
* **AI and Data Code Pattern Playlist**: Bookmark our [playlist](https://www.youtube.com/playlist?list=PLzUbsvIyrNfknNewObx5N7uGZ5FKH0Fde) with all of our Code Pattern videos
* **With Watson**: Want to take your Watson app to the next level? Looking to utilize Watson Brand assets? [Join the With Watson program](https://www.ibm.com/watson/with-watson/) to leverage exclusive brand, marketing, and tech resources to amplify and accelerate your Watson embedded commercial solution.

# Links

* [ARKit](https://developer.apple.com/arkit)
* [Watson Swift SDK](https://github.com/watson-developer-cloud/swift-sdk)
* [IBM Visual Recognition](https://www.ibm.com/watson/services/visual-recognition-4)
* [IBM Cloudant](https://www.ibm.com/cloud/cloudant) 

# License

[Apache 2.0](LICENSE)
