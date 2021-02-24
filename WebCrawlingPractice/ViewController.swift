//
//  ViewController.swift
//  WebCrawlingPractice
//
//  Created by 권준상 on 2021/02/20.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController {
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var fuelEfficiencyLabel: UILabel!
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var saleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchHTMLParsingResultWill() {
            () in print()
        }
    }

    func fetchHTMLParsingResultWill(completion: @escaping () -> ()) {
        
        let urlAddress = "https://auto.naver.com/car/main.nhn?yearsId=134453"
        
        guard let url = URL(string: urlAddress) else { return }
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            
            // MARK: 이미지 url 정보 가져오기
            let imagesrc: Elements = try doc.select("div#carMainImgArea.img_group").select("div.main_img").select("img[src]")

            let stringImage = try imagesrc.attr("src").description
            let urlImage = URL(string: stringImage)
            
            
            // MARK: 차 이름 정보 가져오기
            let title: Elements = try doc.select(".end_model").select("h3")
           
            // MARK: 차 메인 정보들 가져오기
            let mainInfo: Elements = try doc.select(".detail_lst").select("dd")
    
            // MARK: UI 세팅
            let data = try Data(contentsOf: urlImage!)
            carImage.image = UIImage(data: data)
            
            carLabel.text = try title.text()
            
            var count = 0
            for element in mainInfo {
                switch count {
                case 0:
                    fuelEfficiencyLabel.text = try element.text()
                    count += 1
                case 1:
                    fuelLabel.text = try element.text()
                    count += 1
                case 2:
                    powerLabel.text = try element.text()
                    count += 1
                case 3:
                    saleLabel.text = try element.text()
                default:
                    print("error")
                }
            }
        
            print("Title : \(try title.text())")
            
            completion()
        } catch let error {
            print("Error : \(error)")
        }
    }


}

