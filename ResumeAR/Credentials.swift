//
//  Credentials.swift
//  ResumeAR
//
//  Created by Sanjeev Ghimire on 11/1/17.
//  Copyright © 2017 Sanjeev Ghimire. All rights reserved.
//

public struct Credentials {
//    //weather api credentials from bluemix
//    public static let CLASSIFICATION_API_URL = "<visual recognition url>"
//    public static let VR_API_KEY = "<VR API key>"
//    public static let VERSION = "2017-11-08"
//
//    //cloudant details
//    public static let CLOUDANT_USERNAME = "<username>";
//    public static let CLOUDANT_PASSWORD = "<password>";
//    public static let CLOUDANT_HOST = "<host>";
//    public static let CLOUDANT_DATABASE = "<database name>";
//    public static let CLOUDANT_PORT = 443;
//    public static let CLOUDANT_URL = "<cloudant url>";
    
    
    // GET classify URL
    public static let CLASSIFICATION_API_URL = "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?version=2016-05-20&threshold=0&owners=me&api_key="
    //POST create classifier
    public static let CREATE_CLASSIFIER_URL = "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classifiers?version=2016-05-20&api_key="
    public static let CLOUDANT_URL_GET_CLASSIFIER = "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classifiers?api_key="
    public static let VR_API_KEY = "54af183c2b444862db4ada552dff06f09fe40eab"
    public static let VERSION = "2017-11-08"
    
    //cloudant details
    public static let CLOUDANT_USERNAME = "d8a01891-e4d2-4102-b5f8-751fb735ce31-bluemix";
    public static let CLOUDANT_PASSWORD = "5e9d0ff369265882b5278ce57c242be9b62d17763c97f03dd849de61af76bb46";
    public static let CLOUDANT_HOST = "d8a01891-e4d2-4102-b5f8-751fb735ce31-bluemix.cloudant.com";
    public static let CLOUDANT_DATABASE = "resumear";
    public static let CLOUDANT_PORT = 443;
    public static let CLOUDANT_URL = "https://d8a01891-e4d2-4102-b5f8-751fb735ce31-bluemix:5e9d0ff369265882b5278ce57c242be9b62d17763c97f03dd849de61af76bb46@d8a01891-e4d2-4102-b5f8-751fb735ce31-bluemix.cloudant.com/resumear/_find"
    public static let CLOUDANT_URL_CREATE = "https://d8a01891-e4d2-4102-b5f8-751fb735ce31-bluemix:5e9d0ff369265882b5278ce57c242be9b62d17763c97f03dd849de61af76bb46@d8a01891-e4d2-4102-b5f8-751fb735ce31-bluemix.cloudant.com/resumear"

}
