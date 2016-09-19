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
    
    static func requestLatex(preText: String, imageView: UIImageView) {
        print("pretext = " + preText)
        
        let parameters: [String: String] = [
            "english" : preText
        ]
        Alamofire.request("http://10.144.6.201:5000/", method: .post, parameters: parameters).responseJSON{ response in
            
            //print(response.result.value)
            if let result = response.result.value {
                let json = result as! NSDictionary
                let latex = json["latex"] as! String
                print(latex)
                
                let url = "https://chart.googleapis.com/chart?cht=tx&chl=" + latex
                print("url = " + url)
                imageView.downloadedFrom(link: url)
                //downloadImage(imageView: imageView, url: URL(string: url))
            }
            
        }
        
    }
    
}


extension UIImageView {
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        contentMode = .center
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                let data = data , error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
}
