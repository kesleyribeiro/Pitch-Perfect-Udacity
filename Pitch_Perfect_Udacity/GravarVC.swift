//
//  GravarVC.swift
//  Pitch_Perfect_Udacity
//
//  Created by Kesley Ribeiro on 5/Feb/18.
//  Copyright © 2018 Kesley Ribeiro. All rights reserved.
//

import UIKit
import AVFoundation

class GravarVC: UIViewController, AVAudioRecorderDelegate {

    // Segue
    struct Storyboard {
        static let segueParaTelaReproduzirAudio = "reproduzirAudio"
    }

    // Outlets
    @IBOutlet weak var gravarBtn: UIButton!
    @IBOutlet weak var pararBtn: UIButton!
    @IBOutlet weak var gravandoLbl: UILabel!
    
    // MARK: Variaveis
     var gravarAudio: AVAudioRecorder!

    // Primeira função executada
    override func viewDidLoad() {
        super.viewDidLoad()

        // Iniciar com botão "PARAR" desabilitado
        pararBtn.isEnabled = false
    }
    
    // MARK: Actions
    
    // Função do botão Gravar aúdio
    @IBAction func acaoGravar(_ sender: Any) {

        // Desabilitar o botão "GRAVAR"
        gravarBtn.isEnabled = false
        
        // Alterar texto
        gravandoLbl.text = "Gravando aúdio..."

        // Habilita o botão "PARAR"
        pararBtn.isEnabled = true
        
        let pacoteDiretorio = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let nomeArquivo = "gravarAudio.wav"
        let pathArray = [pacoteDiretorio, nomeArquivo]
        let caminhoDoArquivo = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)

        try! gravarAudio = AVAudioRecorder(url: caminhoDoArquivo!, settings: [:])
        gravarAudio.delegate = self
        gravarAudio.isMeteringEnabled = true
        gravarAudio.prepareToRecord()
        gravarAudio.record()
    }

    // Função do botão parar de gravar aúdio
    @IBAction func acaoParar(_ sender: Any) {
        
        // Habilitar o botão "GRAVAR"
        gravarBtn.isEnabled = true

        // Redefinir texto original
        gravandoLbl.text = "Toque para gravar"
        
        // Desabilitar o botão "PARAR"
        pararBtn.isEnabled = false
        
        // Parar gravação
        gravarAudio.stop()

        // Desativar AVAudioSession
        let sessaoAudio = AVAudioSession.sharedInstance()
        try! sessaoAudio.setActive(false)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

        // Sucesso
        if flag {
            // Apresentar a próxima ViewController conforme o nome identificador da segue
            performSegue(withIdentifier: Storyboard.segueParaTelaReproduzirAudio, sender: gravarAudio.url)
        }
        // Erro
        else {
            print("Gravação não foi completada!")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.segueParaTelaReproduzirAudio {
            let reproduzirAudioVC = segue.destination as! ReproduzirAudioVC
            let guardarURLAudio = sender as! URL
            reproduzirAudioVC.guardarURLAudio = guardarURLAudio            
        }
    }
    
}

