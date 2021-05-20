//
//  JuegosViewController.swift
//  AdrianColeccionDeJuegos
//
//  Created by Mac 14 on 5/17/21.
//  Copyright © 2021 Mac 14. All rights reserved.
//

import UIKit

class JuegosViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var imagePicker = UIImagePickerController()
    var juego:Juego? = nil
    var listaCategorias = ["Accion", "Aventura", "Estrategia", "Deportivo"]
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        listCategorias.delegate = self
        listCategorias.dataSource = self
        if juego != nil {
            JuegoImageView.image = UIImage(data: (juego!.imagen!) as Data)
            tituloTextField.text = juego!.titulo
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
            pickerCategoria.text = juego!.categoria

            var index:Int = 0
            for (idx, value) in listaCategorias.enumerated()
               {
                if value == juego?.categoria {
                       index = idx
                   }
               }
            self.listCategorias.selectRow(index, inComponent: 0, animated: true)
        }else{
            eliminarBoton.isHidden = true
        }
    }
    
    @IBOutlet weak var JuegoImageView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    @IBOutlet weak var eliminarBoton: UIButton!
    @IBOutlet weak var pickerCategoria: UITextField!
    @IBOutlet weak var listCategorias: UIPickerView!
    
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        if juego != nil {
            juego!.titulo! = tituloTextField.text!
            juego!.imagen = JuegoImageView.image?.jpegData(compressionQuality: 0.5)
            juego!.categoria = pickerCategoria.text
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context: context)
            juego.titulo = tituloTextField.text
            juego.imagen = JuegoImageView.image?.jpegData(compressionQuality: 0.5)
            juego.categoria = pickerCategoria.text
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func seleccionaCategoria(_ sender: Any) {
        if listCategorias.isHidden{
            self.listCategorias.isHidden = false
        }else{
            self.listCategorias.isHidden = true
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        JuegoImageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }

}

extension JuegosViewController : UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listaCategorias.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}


extension JuegosViewController : UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
         self.view.endEditing(true)
        return listaCategorias[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.pickerCategoria.text = self.listaCategorias[row]
        self.listCategorias.isHidden = true
    }
}

