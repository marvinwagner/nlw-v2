//
//  ViewController.swift
//  Ecoleta
//
//  Created by Marvin Wagner on 08/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import UIKit

class CustomButtonSelect: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = .init(srgbRed: 0.12, green: 0.51, blue: 0.30, alpha: 1)
        self.layer.cornerRadius = 5
        self.contentEdgeInsets = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
    }
}

final class HomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var ufTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var ufButtonPicker: UIButton!
    @IBOutlet weak var entrarButton: UIButton!
    
    var ibge = IBGEManagement()
    
    var selectedCountry: String?
    var ufList = [String]()
    var cityList = [String]()

    let ufPickerView = UFPickerView()
    let cityPickerView = CityPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()

        ibge.delegate = self
        ibge.fetchUFs()
                
        entrarButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        entrarButton.imageView?.contentMode = .scaleAspectFit
        entrarButton.tintColor = .white
        entrarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        entrarButton.layer.cornerRadius = 10
        
        configurePickerView()
        configureToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.tintColor = #colorLiteral(red: 0.2246646881, green: 0.8201124072, blue: 0.5479601026, alpha: 1)
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        // colocar o icone nas duas propriedades é obrigatório para substituir o icone padrão
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        
        if let destination = segue.destination as? PointViewController {
            destination.selectedUF = ufTextField.text == "" ? "SC" : ufTextField.text
            destination.selectedCity = cityTextField.text == "" ? "Blumenau" : cityTextField.text
        }
    }

    func configurePickerView() {
        ufPickerView.delegate = self
        ufTextField.inputView = ufPickerView
        
        cityPickerView.delegate = self
        cityTextField.inputView = cityPickerView
    }
    
    func configureToolBar() {
        let toolBarUF = UIToolbar()
        toolBarUF.sizeToFit()
        let buttonUF = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.actionUF))
        toolBarUF.setItems([buttonUF], animated: true)
        toolBarUF.isUserInteractionEnabled = true
        ufTextField.inputAccessoryView = toolBarUF
        
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        cityTextField.inputAccessoryView = toolBar
    }

    @objc func actionUF() {
        view.endEditing(true)
        
        ibge.fetchCities(forUF: ufTextField.text!)
    }

    @objc func action() {
        view.endEditing(true)
    }
    
    @IBAction func enterPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segueGoToMap, sender: self)
    }
}

extension HomeViewController : IBGEManagementDelegate {
    func didFailWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    func didLoadUFs(_ ufs: [String]) {
        DispatchQueue.main.async {
            self.ufList.append(contentsOf: ufs)
        }
    }
    
    func didLoadCities(_ cities: [String]) {
        DispatchQueue.main.async {
            self.cityList.append(contentsOf: cities)
        }
    }
}

//MARK: - PickerView methods
extension HomeViewController : UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.inputView == ufPickerView {
            return ufList.count // number of dropdown items
        } else {
            return cityList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.inputView == ufPickerView {
            return ufList[row] // dropdown item
        } else {
            return cityList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.inputView == ufPickerView {
            ufTextField.text = ufList[row]
        } else {
            cityTextField.text = cityList[row]
        }
    }
}

//MARK: - Custom Classes
class UFPickerView : UIPickerView {
    
}
class CityPickerView : UIPickerView {
    
}

class CustomSearchTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = .init(srgbRed: 0.42, green: 0.42, blue: 0.50, alpha: 1)
        self.layer.cornerRadius = 10
        
        
        let imageView = UIImageView();
        let image = UIImage(systemName: "chevron.down")
        imageView.tintColor = UIColor(displayP3Red: 0.42, green: 0.42, blue: 0.50, alpha: 1)
        imageView.image = image;
        self.rightView = imageView
        self.rightViewMode = .always
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15))
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15))
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15))
    }
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        //return bounds.inset(by: UIEdgeInsets(top: 12, left: bounds.width, bottom: 12, right: bounds.width - 15))
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= 15
        return textRect
    }
}

