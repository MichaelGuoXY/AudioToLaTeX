//
//  LatexService.swift
//  SpeechRecognitionServerExample
//
//  Created by Guo Xiaoyu on 9/17/16.
//
//

import Foundation
import Alamofire

@objc class LatexService : NSObject{
    static func requestLatex(preText: String, getImageFromURL: (_ url : URL) -> Void) {
        print("pretext = " + preText)
        let parameters: [String: String] = [
            "english" : preText
        ]
        Alamofire.request("http://10.144.6.201:5000/", method: .post, parameters: parameters).responseJSON{ response in
            
            print(response)
            let latex : String
            do {
                let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as Dictionary
                print("\(json)")
                if let x = json["latex"] as? String {
                    latex = String(x)
                }
            } catch {
                print("error serializing JSON: \(error)")
            }

            let url = "http://chart.googleapis.com/chart/?cht=tx&chl=" + latex
            getImageFromURL(url)
        }
        
    }
    
    /*
    static func requestPicture(latexString: String) {
        let parameters: [String: String] = [
            "cht" : "tx",
            "chl" : latexString
        ]
        
        Alamofire.request("http://chart.googleapis.com/chart", method: .get, parameters: parameters).responseJSON{ response in
            print(response)
        }
    }
    */
    
}
