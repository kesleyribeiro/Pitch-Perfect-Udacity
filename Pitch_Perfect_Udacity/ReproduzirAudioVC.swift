//
//  ReproduzirAudioVC.swift
//  Pitch_Perfect_Udacity
//
//  Created by Kesley Ribeiro on 5/Feb/18.
//  Copyright © 2018 Kesley Ribeiro. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - ReproduzirAudioVC: AVAudioPlayerDelegate

class ReproduzirAudioVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var caracolBtn: UIButton!
    @IBOutlet weak var coelhoBtn: UIButton!
    @IBOutlet weak var esquiloBtn: UIButton!
    @IBOutlet weak var vaderBtn: UIButton!
    @IBOutlet weak var passarinhoBtn: UIButton!
    @IBOutlet weak var reverbBtn: UIButton!
    @IBOutlet weak var pararBtn: UIButton!

    // MARK: Variaveis
    var guardarURLAudio: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case caracol = 0, coelho, esquilo, vader, passarinho, reverb
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }

    // MARK: Actions

    @IBAction func acaoReproduzirAudio(_ sender: UIButton) {
        switch (ButtonType(rawValue: sender.tag)!) {
        case .caracol:
            playSound(rate: 0.5)
        case .coelho:
            playSound(rate: 1.5)
        case .esquilo:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .passarinho:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
    }
    
    @IBAction func acaoPararReproducao(_ sender: AnyObject) {
        stopAudio()
    }

}
