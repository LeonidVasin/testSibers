//
//  FiltersViewController.swift
//  SibersTest
//
//  Created by user on 05.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, FiltersViewInput {

    var output: FiltersViewOutput!
    
    @IBOutlet weak var selectionImageButton: UIButton!
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var spinnerView: SpinnerView!
    
    @IBOutlet weak var rotateFilterButton: UIButton!
    @IBOutlet weak var blackWhiteFilterButton: UIButton!
    @IBOutlet weak var mirrorFilterButton: UIButton!
    @IBOutlet weak var invertionFilterButton: UIButton!
    @IBOutlet weak var mirrorLeftOnRightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        output.tabButtonSelectionImageProvider()
    }
    
    @IBAction func applyFilterAt(_ sender: UIButton) {
        switch sender.tag {
        case Filter.rotate.hashValue:
            output.select(.rotate)
        case Filter.blackWhite.hashValue:
            output.select(.blackWhite)
        case Filter.mirror.hashValue:
            output.select(.mirror)
        case Filter.invertion.hashValue:
            output.select(.invertion)
        case Filter.mirrorLeftOnRight.hashValue:
            output.select(.mirrorLeftOnRight)
        default:
            break
        }
    }

    // MARK: FiltersViewInput
    func setupInitialState() {
        spinnerView.progress = 0.0
        spinnerView.isHidden = true
        originalImageView.isHidden = true
        selectionImageButton.isHidden = false
        
        rotateFilterButton.setTitle("Rotate", for: .normal)
        blackWhiteFilterButton.setTitle("Black-White", for: .normal)
        mirrorFilterButton.setTitle("Mirror", for: .normal)
        invertionFilterButton.setTitle("Invertion", for: .normal)
        mirrorLeftOnRightButton.setTitle("Mirror 1/2", for: .normal)
        
        rotateFilterButton.tag = Filter.rotate.hashValue
        blackWhiteFilterButton.tag = Filter.blackWhite.hashValue
        mirrorFilterButton.tag = Filter.mirror.hashValue
        invertionFilterButton.tag = Filter.invertion.hashValue
        mirrorLeftOnRightButton.tag = Filter.mirrorLeftOnRight.hashValue
        
        disableButtons()
        
        selectionImageButton.setTitle("Select image", for: .normal)
        
        let tapGestureOriginalImage = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureOriginalImage))
        originalImageView.addGestureRecognizer(tapGestureOriginalImage)
        originalImageView.isUserInteractionEnabled = true
        
        filterImageView.isUserInteractionEnabled = true
        let tapGestureFilterImage = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureFilterImage))
        filterImageView.addGestureRecognizer(tapGestureFilterImage)
    }
    
    func enableButtons() {
        rotateFilterButton.isEnabled = true
        blackWhiteFilterButton.isEnabled = true
        mirrorFilterButton.isEnabled = true
        invertionFilterButton.isEnabled = true
        mirrorLeftOnRightButton.isEnabled = true
        
        rotateFilterButton.layer.borderColor = UIColor(red: 0.0, green: 111.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        blackWhiteFilterButton.layer.borderColor = UIColor(red: 0.0, green: 111.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        mirrorFilterButton.layer.borderColor = UIColor(red: 0.0, green: 111.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        invertionFilterButton.layer.borderColor = UIColor(red: 0.0, green: 111.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        mirrorLeftOnRightButton.layer.borderColor = UIColor(red: 0.0, green: 111.0/255.0, blue: 1.0, alpha: 1.0).cgColor
    }
    
    func disableButtons() {
        rotateFilterButton.layer.borderColor = UIColor(red: 203.0/255.0, green: 203.0/255.0, blue: 203.0/255.0, alpha: 1.0).cgColor
        blackWhiteFilterButton.layer.borderColor = UIColor(red: 203.0/255.0, green: 203.0/255.0, blue: 203.0/255.0, alpha: 1.0).cgColor
        mirrorFilterButton.layer.borderColor = UIColor(red: 203.0/255.0, green: 203.0/255.0, blue: 203.0/255.0, alpha: 1.0).cgColor
        invertionFilterButton.layer.borderColor = UIColor(red: 203.0/255.0, green: 203.0/255.0, blue: 203.0/255.0, alpha: 1.0).cgColor
        mirrorLeftOnRightButton.layer.borderColor = UIColor(red: 203.0/255.0, green: 203.0/255.0, blue: 203.0/255.0, alpha: 1.0).cgColor
        
        rotateFilterButton.isEnabled = false
        blackWhiteFilterButton.isEnabled = false
        mirrorFilterButton.isEnabled = false
        invertionFilterButton.isEnabled = false
        mirrorLeftOnRightButton.isEnabled = false
    }
    
    func handleTapGestureOriginalImage() {
        output.tapOriginlImage()
    }
    
    func handleTapGestureFilterImage() {
        output.tapFilterImage()
    }
    
    func showChooseImageDataProvider() {
        var alertStyle: UIAlertControllerStyle = .alert
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            alertStyle = .actionSheet
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
        let photoAction = UIAlertAction(title: "Photo", style: .default) { (action) in
            self.output.selectDataProvider(at: .camera)
        }
        alertController.addAction(photoAction)
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { (action) in
            self.output.selectDataProvider(at: .photoLibrary)
        }
        alertController.addAction(libraryAction)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        
        self.present(alertController, animated: true, completion: {
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    func showImagePickerController(at type: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = type
        if type == .camera {
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.videoQuality = .typeHigh
            imagePickerController.showsCameraControls = true
        }
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func setupFiltered(_ image: UIImage?) {
        filterImageView.image = image
    }
    
    func disabledFiltersAndShowImageView() {
        originalImageView.isHidden = false
        selectionImageButton.isHidden = true
        
        enableButtons()
    }
    
    func setupOriginal(_ image: UIImage) {
        originalImageView.image = image
    }
    
    func showChooseDoWithResult() {
        var alertStyle: UIAlertControllerStyle = .alert
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            alertStyle = .actionSheet
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            self.output.tapSaveImage()
        }
        alertController.addAction(saveAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            self.output.tapDeleteImage()
        }
        alertController.addAction(deleteAction)
        
        let reuseAction = UIAlertAction(title: "Reuse", style: .default) { (action) in
            self.output.tapReuseImage()
        }
        alertController.addAction(reuseAction)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        
        self.present(alertController, animated: true, completion: {
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    func alertControllerBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func clearFilterImageView() {
        filterImageView.image = nil
    }
    
    func showSpinner() {
        spinnerView.isHidden = false
        
        disableButtons()
    }
    
    func removeSpinner() {
        spinnerView.isHidden = true
        spinnerView.progress = 0.0
        
        enableButtons()
    }
    
    func updateSpinner(at procent: Double) {
        spinnerView.progress = CGFloat(procent)
    }
}

extension FiltersViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            output.select(image.fixOrientation())
        }
        self.dismiss(animated: true, completion: nil)
    }
}
