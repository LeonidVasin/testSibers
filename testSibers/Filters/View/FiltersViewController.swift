//
//  FiltersViewController.swift
//  SibersTest
//
//  Created by user on 05.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, FiltersViewInput {
    
    //Почему-то приложение отжирает слишком много памяти, при обработке приложения. это связано с CGImage, но что с этим сделать, пока что не знаю
    //Раньше была возможность использовать CFRelease, сейчас я не нашел ничего подобного. Взамен пришел takeUnretain, но его нельзя использовать просто так
    //Пока что не могу понять почему иногда не скролится collection view. Знаю, что, скорее всего, блокирую основной поток, но это не так и много информации

    var output: FiltersViewOutput!
    
    fileprivate var filterImages: [FilterImageViewModel] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectionImageButton: UIButton!
    @IBOutlet weak var originalImageView: UIImageView!
    
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
    }
    
    func disabledFiltersAndShowImageView() {
        originalImageView.isHidden = false
        selectionImageButton.isHidden = true
        
        enableButtons()
    }
    
    func setupOriginal(_ image: UIImage) {
        originalImageView.image = image
    }
    
    func showChooseDoWithResult(at index: Int) {
        var alertStyle: UIAlertControllerStyle = .alert
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            alertStyle = .actionSheet
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            self.output.tapSaveImage(at: index)
        }
        alertController.addAction(saveAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            self.output.tapDeleteImage(at: index)
        }
        alertController.addAction(deleteAction)
        
        let reuseAction = UIAlertAction(title: "Reuse", style: .default) { (action) in
            self.output.tapReuseImage(at: index)
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
    
    func updateViewModel(at index: Int, viewModel: FilterImageViewModel) {
        DispatchQueue.main.async {
            self.filterImages[index] = viewModel
            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    func newViewModel(_ viewModel: FilterImageViewModel) {
        DispatchQueue.main.async {
            self.filterImages.insert(viewModel, at: 0)
            self.collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
        }
    }
    
    func deleteViewModel(at index: Int) {
        DispatchQueue.main.async {
            self.filterImages.remove(at: index)
            self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
}

extension FiltersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.tapFilterImage(at: indexPath.row)
    }
}

extension FiltersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! FilterImageCollectionViewCell
        cell.imageView.image = filterImages[indexPath.row].image
        if filterImages[indexPath.row].image == nil {
            cell.progressView.isHidden = false
            cell.progressView.progress = Float(filterImages[indexPath.row].procent!)
        } else {
            cell.progressView.isHidden = true
        }
        
        return cell
    }
}

extension FiltersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 200.0)
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