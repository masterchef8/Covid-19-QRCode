//
//  ViewController.swift
//  Covid-19-QRCode
//
//  Created by Somebody on 06/04/2020.
//  Copyright © 2020 Somebody. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate {

    @IBOutlet weak var QRCodeView: UIImageView!
    @IBOutlet weak var Motifs: UIPickerView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var Report: UITextView!
    
    let pickerData = ["sport", "travail", "courses", "sante", "famille", "judiciare", "missions"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Motifs.delegate = self
        self.Motifs.dataSource = self
        //self.DatePicker.date = Date()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func generate(_ sender: UIButton) {
        let str = generateString()
        QRCodeView.image = generateQRCode(from: str!)
        Report.text = str
        UIImageWriteToSavedPhotosAlbum(QRCodeView.image!, self, nil, nil)
        
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    func generateString() -> String? {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR_POSIX")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: DatePicker.date)
        dateFormatter.dateFormat = "HH:mm"
        var heure = dateFormatter.string(from: DatePicker.date)
        heure = heure.replacingOccurrences(of: ":", with: "h")
        let str = "Cree le: \(date) a \(heure); Nom: xxxxx; Prenom: xxxxx; Naissance: xxxxxx a xxxxx; Adresse: xxxxxx; Sortie: \(date) a \(heure); Motifs: \(pickerData[Motifs.selectedRow(inComponent: 0)])"
        print(str)

        return str
    }

    // MARK: UIPicker Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
      
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

}

