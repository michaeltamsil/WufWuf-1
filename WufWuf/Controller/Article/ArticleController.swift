//
//  ArticleController.swift
//  WufWuf
//
//  Created by Farras Doko on 06/08/20.
//  Copyright © 2020 wufwuf. All rights reserved.
//

import UIKit
import ReadMoreTextView

class ArticleController: UIViewController {
    
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var detailLabel: ReadMoreTextView!
    @IBOutlet weak var readMore: UIButton!
    
    var navTitle: String?
    var detail = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = navTitle
        
        switch navTitle {
        case "Katarak":
            let cameraBarItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(goToKatarakScr))
            navigationItem.setRightBarButton(cameraBarItem, animated: false)
            break
        case "Demodex":
            let cameraBarItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(goToDemodexScr))
            navigationItem.setRightBarButton(cameraBarItem, animated: false) 
            break
        default:
            break
        }
        
        changeDetail()
        
        // TAG: - Deprecated Read More Button
        readMore.isHidden = true
    }
    
    @objc func goToDemodexScr() {
        let scanDemodexController:UIViewController = UIStoryboard(name: "DemoDexScannerScreen", bundle: nil).instantiateViewController(withIdentifier: "main")
        present(scanDemodexController, animated: true, completion: nil)
    }
    
    @objc func goToKatarakScr() {
        let scanKatarakController:UIViewController = UIStoryboard(name: "ScannerScreen", bundle: nil).instantiateViewController(withIdentifier: "ScannerScreen1") as UIViewController
        present(scanKatarakController, animated: true, completion: nil)
    }
    
    
    func getArticle(_ detail: [Any]) -> NSMutableAttributedString {
        let string = NSMutableAttributedString()
        for article in detail {
            if let articleString = article as? String {
                let p = NSAttributedString(string: articleString, attributes: [.font:UIFont.systemFont(ofSize: 17)])
                string.append(p)
            } else if article is UIImage {
                let image = NSTextAttachment(image: resizeImage(article as! UIImage, 190))
                let imageString = NSAttributedString(attachment: image)
                let imageCentered = NSMutableAttributedString(attributedString: imageString)
                
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .center
                imageCentered.addAttribute(.paragraphStyle, value: paragraph, range: NSMakeRange(0, 1))
                
                string.append(imageCentered)
            } else if let article = article as? [String] {
                let attrString = NSMutableAttributedString()
                for listedString in article {
                    let index = listedString.index(listedString.startIndex, offsetBy: 3)
                    let bullet = listedString[..<index]
                    
                    var attributes: [NSAttributedString.Key:Any] = [.font:UIFont.systemFont(ofSize: 17)]
                    
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.headIndent = (bullet as NSString).size(withAttributes: attributes).width
                    attributes[.paragraphStyle] = paragraph
                    
                    attrString.append(NSAttributedString(string: listedString, attributes: attributes))
                }
                
                string.append(attrString)
            }
            else {
                string.append(article as! NSAttributedString)
            }
        }
        return string
    }
    
    @IBAction func onChanged(_ sender: UISegmentedControl) {
        changeDetail()
    }
    
    func changeDetail() {
        switch navTitle {
        case "Katarak":
            switch segmented.titleForSegment(at: segmented.selectedSegmentIndex) {
            case "Pengertian":
                detail = getArticle(katarakPengertian)
                let attr = NSAttributedString(string: kPengertianMore, attributes: [.font:UIFont.systemFont(ofSize: 17)])
                detail.append(attr)
                detailLabel.attributedText = detail
                
                bannerImg.image = UIImage(named: "pengertian-katarak")
                
                let attributedReadMoreText = NSMutableAttributedString(string: "... ")
                attributedReadMoreText.append(NSAttributedString(string: "selanjutnya", attributes: [
                    .foregroundColor: UIColor.lightGray,
                    .font: UIFont.systemFont(ofSize: 17)
                ]))
                detailLabel.attributedReadMoreText = attributedReadMoreText
                
                detailLabel.shouldTrim = true
                detailLabel.setNeedsUpdateTrim()
                break
            case "Penyebab":
                detailLabel.attributedText = getArticle(katarakPenyebab)
                bannerImg.image = UIImage(named: "penyebab-katarak")
                
                detailLabel.shouldTrim = false
                break
            case "Gejala":
                detailLabel.attributedText = getArticle(katarakGejala)
                bannerImg.image = UIImage(named: "gejala-katarak")
                
                detailLabel.shouldTrim = false
                break
            case "Diagnosa":
                detailLabel.attributedText = getArticle(katarakDiagnosa)
                bannerImg.image = UIImage(named: "diagnosa-katarak")
                
                detailLabel.shouldTrim = false
                break
            default:
                break
            }
        case "Demodex":
            
            switch segmented.titleForSegment(at: segmented.selectedSegmentIndex) {
            case "Pengertian":
                detail = getArticle(demodexPengertian)
                let attr = NSAttributedString(string: dPengertianMore, attributes: [.font:UIFont.systemFont(ofSize: 17)])
                detail.append(attr)
                detailLabel.attributedText = detail
                
                bannerImg.image = UIImage(named: "demodex-pengertian")
                
                let attributedReadMoreText = NSMutableAttributedString(string: "... ")
                attributedReadMoreText.append(NSAttributedString(string: "selanjutnya", attributes: [
                    .foregroundColor: UIColor.lightGray,
                    .font: UIFont.systemFont(ofSize: 17)
                ]))
                detailLabel.attributedReadMoreText = attributedReadMoreText
                
                detailLabel.shouldTrim = true
                detailLabel.setNeedsUpdateTrim()
                break
            case "Penyebab":
                detailLabel.attributedText = getArticle(demodexPenyebab)
                bannerImg.image = UIImage(named: "demodex-penyebab")
                
                detailLabel.shouldTrim = false
                break
            case "Gejala":
                detail = getArticle(demodexGejala)
                let attr = NSAttributedString(string: dGejalaMore, attributes: [.font:UIFont.systemFont(ofSize: 17)])
                detail.append(attr)
                detailLabel.attributedText = detail
                
                bannerImg.image = UIImage(named: "demodex-gejala")

                let attributedReadMoreText = NSMutableAttributedString(string: "... ")
                attributedReadMoreText.append(NSAttributedString(string: "selanjutnya", attributes: [
                    .foregroundColor: UIColor.lightGray,
                    .font: UIFont.systemFont(ofSize: 17)
                ]))
                detailLabel.attributedReadMoreText = attributedReadMoreText

                detailLabel.shouldTrim = true
                detailLabel.setNeedsUpdateTrim()
                break
            case "Diagnosa":
                detailLabel.attributedText = getArticle(demodexDiagnosa)
                bannerImg.image = UIImage(named: "demodex-diagnosa")
                
                detailLabel.shouldTrim = false
                break
            default:
                break
            }
        default:
            break
        }
    }
    @IBAction func readMoreTapped(_ sender: UIButton) {
        switch navTitle {
        case "Katarak":
            switch segmented.titleForSegment(at: segmented.selectedSegmentIndex) {
            case "Pengertian":
                let attr = NSAttributedString(string: kPengertianMore, attributes: [.font:UIFont.systemFont(ofSize: 17)])
                detail.append(attr)
                detailLabel.attributedText = detail
                readMore.isHidden = true
                break
            default:
                break
            }
        case "Demodex":
            switch segmented.titleForSegment(at: segmented.selectedSegmentIndex) {
            case "Pengertian":
                let attr = NSAttributedString(string: dPengertianMore, attributes: [.font:UIFont.systemFont(ofSize: 17)])
                detail.append(attr)
                detailLabel.attributedText = detail
                readMore.isHidden = true
                break
            case "Gejala":
                let attr = NSAttributedString(string: dGejalaMore, attributes: [.font:UIFont.systemFont(ofSize: 17)])
                detail.append(attr)
                detailLabel.attributedText = detail
                readMore.isHidden = true
                break
            default:
                break
            }
        default:
            break
        }
    }
    
    func resizeImage(_ image: UIImage,_ height: CGFloat) -> UIImage {
        let scale = height / image.size.height
        let width = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
