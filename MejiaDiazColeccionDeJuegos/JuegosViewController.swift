//
//  JuegosViewController.swift
//  MejiaDiazColeccionDeJuegos
//
//  Created by MacBook Pro on 17/05/23.
//

import UIKit

class JuegosViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    

    @IBOutlet weak var tituloTextView: UITextField!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoriaPicker: UIPickerView!
    @IBOutlet weak var eliminarBoton: UIButton!
 
    var imagePicker = UIImagePickerController()
    var juego:Juego? = nil
    var categorias:[String] = ["Acción","Terror","Aventura","Plataformas","FPS"]
    var categoria:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriaPicker.dataSource = self
        categoriaPicker.delegate = self
        
        imagePicker.delegate = self
        if juego != nil, let index = categorias.firstIndex(of: juego!.categoria!){
            imageView.image = UIImage(data: (juego!.imagen!) as Data)
            tituloTextView.text = juego!.titulo
            categoriaPicker.selectRow(index, inComponent: 0, animated: false)
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
            eliminarBoton.isHidden = false
        } else {
            eliminarBoton.isHidden = true
        }
    }
    
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func camaraTapped(_ sender: Any) {
    }
    @IBAction func agregarTapped(_ sender: Any) {
        
        if juego != nil {
            juego!.titulo! = tituloTextView.text!
            juego!.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
            juego!.categoria! = categoria
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context: context)
            juego.titulo = tituloTextView.text
            juego.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
            juego.categoria = categoria
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        imageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorias.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorias[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoria = categorias[row]
    }
}
