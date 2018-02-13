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

        // Chamar a função passando false como parâmetro
        configurarBotoes(false)
    }
    
    // MARK: Actions
    
    // Função do botão Gravar aúdio
    @IBAction func acaoGravar(_ sender: Any) {

        // Chamar a função passando true como parâmetro
        configurarBotoes(true)

        let pacoteDiretorio = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let nomeArquivo = "arquivoAudioGravado.wav"
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
        
        // Chamar a função passando false como parâmetro
        configurarBotoes(false)
        
        // Parar gravação
        gravarAudio.stop()

        // Desativar AVAudioSession
        let sessaoAudio = AVAudioSession.sharedInstance()
        try! sessaoAudio.setActive(false)
    }
    
    func configurarBotoes(_ estaGravando: Bool) {

        // Botão de gravar ficará habilitado somente se não estiver gravando
        gravarBtn.isEnabled = !estaGravando

        // Botão de parar ficará habilitado somente se estiver gravando
        pararBtn.isEnabled = estaGravando

        // Define o label de acordo com estar ou não estar gravando
        gravandoLbl.text = estaGravando ? "Gravando áudio..." : "Toque para gravar"
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

        // Sucesso
        if flag {
            // Apresentar a próxima ViewController conforme o nome identificador da segue
            performSegue(withIdentifier: Storyboard.segueParaTelaReproduzirAudio, sender: gravarAudio.url)
        }
        // Erro
        else {
            let alerta = UIAlertController(title: "Ocorreu um erro", message: "Infelizmente a gravação não foi completada. Tente novamente!", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
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

