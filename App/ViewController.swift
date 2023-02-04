import UIKit
import VoxeetSDK

class ViewController: UIViewController {
    
    /*
     *  MARK: Properties
     */
    
    // Session UI.
    var sessionTextField: UITextField!
    var logInButton: UIButton!
    var logoutButton: UIButton!
    
    // Conference UI.
    var conferenceTextField: UITextField!
    var startButton: UIButton!
    var leaveButton: UIButton!
    var startVideoButton: UIButton!
    var stopVideoButton: UIButton!
 
 
    
    // Videos views.
    var videosView1: VTVideoView!
    var videosView2: VTVideoView!
    
    // Participant label.
    var participantsLabel: UILabel!
    
    // User interface settings.
    let margin: CGFloat = 16
    let buttonWidth: CGFloat = 120
    let buttonHeight: CGFloat = 35
    let textFieldWidth: CGFloat = 120 + 16 + 120
    let textFieldHeight: CGFloat = 40
    
    // polling feature for isSpeaking
    var timer = Timer()
    var localParticpant: VTParticipant!;
    var remoteParticpant: VTParticipant!;
    
    
    /*
     *  MARK: Methods
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init UI.
        initSessionUI()
        initConferenceUI()
        
        // Conference delegate.
        VoxeetSDK.shared.conference.delegate = self
        print(VoxeetSDK.version())  //[VoxeetSDK] 3.8.0 (1)
    }
    
    func initSessionUI() {
        var statusBarHeight: CGFloat {
            // 13.0 and later
            if #available(iOS 13.0, *){
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                return  window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0;
            }else {
                return UIApplication.shared.statusBarFrame.height
            }
        }
        
        let randomNames = ["Thor",
                           "Cap",
                           "Tony Stark",
                           "Black Panther",
                           "Black Widow",
                           "Hulk",
                           "Spider-Man"]
        
        // Session text field.
        sessionTextField = UITextField(frame: CGRect(x: margin,
                                                     y: statusBarHeight + margin,
                                                     width: textFieldWidth, height: textFieldHeight))
        sessionTextField.borderStyle = .roundedRect
        sessionTextField.placeholder = "Username"
        sessionTextField.autocorrectionType = .no
        sessionTextField.text = randomNames.randomElement()
        sessionTextField.delegate = self
        self.view.addSubview(sessionTextField)
        
        // Open session button.
        logInButton = UIButton(type: .system) as UIButton
        logInButton.frame = CGRect(x: margin,
                                   y: sessionTextField.frame.origin.y + sessionTextField.frame.height + margin,
                                   width: buttonWidth, height: buttonHeight)
        logInButton.backgroundColor = logInButton.tintColor
        logInButton.layer.cornerRadius = 5
        logInButton.isEnabled = true
        logInButton.isSelected = true
        logInButton.setTitle("LOG IN", for: .normal)
        logInButton.addTarget(self, action: #selector(logInButtonAction), for: .touchUpInside)
        self.view.addSubview(logInButton)
        
        // Close session button.
        logoutButton = UIButton(type: .system) as UIButton
        logoutButton.frame = CGRect(x: logInButton.frame.origin.x + logInButton.frame.width + margin,
                                    y: logInButton.frame.origin.y,
                                    width: buttonWidth, height: buttonHeight)
        logoutButton.backgroundColor = logoutButton.tintColor
        logoutButton.layer.cornerRadius = 5
        logoutButton.isEnabled = false
        logoutButton.isSelected = true
        logoutButton.setTitle("LOGOUT", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        self.view.addSubview(logoutButton)
    }
    
    func initConferenceUI() {
        // Session text field.
        conferenceTextField = UITextField(frame: CGRect(x: margin,
                                                        y: logoutButton.frame.origin.y + logoutButton.frame.height + margin,
                                                        width: textFieldWidth, height: textFieldHeight))
        conferenceTextField.borderStyle = .roundedRect
        conferenceTextField.placeholder = "Conference alias"
        conferenceTextField.autocorrectionType = .no
        conferenceTextField.text = "dev-portal"
        conferenceTextField.delegate = self
        self.view.addSubview(conferenceTextField)
        
        // Conference create/join button.
        startButton = UIButton(type: .system) as UIButton
        startButton.frame = CGRect(x: margin,
                                   y: conferenceTextField.frame.origin.y + conferenceTextField.frame.height + margin,
                                   width: buttonWidth, height: buttonHeight)
        startButton.backgroundColor = startButton.tintColor
        startButton.layer.cornerRadius = 5
        startButton.isEnabled = false
        startButton.isSelected = true
        startButton.setTitle("START", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        self.view.addSubview(startButton)
        
        // Conference leave button.
        leaveButton = UIButton(type: .system) as UIButton
        leaveButton.frame = CGRect(x: startButton.frame.origin.x + startButton.frame.width + margin,
                                   y: startButton.frame.origin.y,
                                   width: buttonWidth, height: buttonHeight)
        leaveButton.backgroundColor = leaveButton.tintColor
        leaveButton.layer.cornerRadius = 5
        leaveButton.isEnabled = false
        leaveButton.isSelected = true
        leaveButton.setTitle("LEAVE", for: .normal)
        leaveButton.addTarget(self, action: #selector(leaveButtonAction), for: .touchUpInside)
        self.view.addSubview(leaveButton)
        
        // Start video button.
        startVideoButton = UIButton(type: .system) as UIButton
        startVideoButton.frame = CGRect(x: margin,
                                        y: startButton.frame.origin.y + startButton.frame.height + margin,
                                        width: buttonWidth, height: buttonHeight)
        startVideoButton.backgroundColor = startVideoButton.tintColor
        startVideoButton.layer.cornerRadius = 5
        startVideoButton.isEnabled = false
        startVideoButton.isSelected = true
        startVideoButton.setTitle("START VIDEO", for: .normal)
        startVideoButton.addTarget(self, action: #selector(startVideoButtonAction), for: .touchUpInside)
        self.view.addSubview(startVideoButton)
        
        // Stop video button.
        stopVideoButton = UIButton(type: .system) as UIButton
        stopVideoButton.frame = CGRect(x: startButton.frame.origin.x + startButton.frame.width + margin,
                                       y: startVideoButton.frame.origin.y,
                                       width: buttonWidth, height: buttonHeight)
        stopVideoButton.backgroundColor = stopVideoButton.tintColor
        stopVideoButton.layer.cornerRadius = 5
        stopVideoButton.isEnabled = false
        stopVideoButton.isSelected = true
        stopVideoButton.setTitle("STOP VIDEO", for: .normal)
        stopVideoButton.addTarget(self, action: #selector(stopVideoButtonAction), for: .touchUpInside)
        self.view.addSubview(stopVideoButton)
        
        // Video views.
        videosView1 = VTVideoView(frame: CGRect(x: margin,
                                                y: startVideoButton.frame.origin.y + startVideoButton.frame.height + margin,
                                                width: buttonWidth, height: buttonWidth))
        videosView1.backgroundColor = .black
        videosView1.layer.borderWidth = 3
        videosView1.layer.borderColor = UIColor.clear.cgColor
        
        
        videosView2 = VTVideoView(frame: CGRect(x:margin,
                                                y: startVideoButton.frame.origin.y + startVideoButton.frame.height + margin,
                                                width: self.view.frame.width - (margin * 2), height: self.view.frame.height / 2))
        videosView2.backgroundColor = .black
   
        videosView2.layer.borderWidth = 3
        videosView2.layer.borderColor = UIColor.clear.cgColor
        
        self.view.addSubview(videosView2)
        self.view.addSubview(videosView1)
        // Participants label.
        participantsLabel = UILabel(frame: CGRect(x: margin,
                                                  y: videosView2.frame.origin.y + videosView2.frame.height + margin,
                                                  width: textFieldWidth, height: textFieldHeight))
        participantsLabel.backgroundColor = .lightGray
        participantsLabel.adjustsFontSizeToFitWidth = true
        participantsLabel.minimumScaleFactor = 0.1
        self.view.addSubview(participantsLabel)
        
 
        
    
    }
    
    @objc func logInButtonAction(sender: UIButton!) {
        // Open user session.
        let info = VTParticipantInfo(externalID: nil, name: sessionTextField.text, avatarURL: nil)
        VoxeetSDK.shared.session.open(info: info) { error in
            self.logInButton.isEnabled = false
            self.logoutButton.isEnabled = true
            self.startButton.isEnabled = true
            self.leaveButton.isEnabled = false
        }
    }
    
    @objc func logoutButtonAction(sender: UIButton!) {
        // Close user session
        VoxeetSDK.shared.session.close { error in
            self.logInButton.isEnabled = true
            self.logoutButton.isEnabled = false
            self.startButton.isEnabled = false
            self.leaveButton.isEnabled = false
        }
    }
    
    @objc func startButtonAction(sender: UIButton!) {
        // Create a conference room with an alias.
        let options = VTConferenceOptions()
        options.alias = conferenceTextField.text ?? ""
        options.params.dolbyVoice = true
        options.params.liveRecording = true; // Enables generation of the recording at the end of the conference
        VoxeetSDK.shared.conference.create(options: options, success: { conference in
            // Join the conference with its id.
            VoxeetSDK.shared.conference.join(conference: conference, success: { response in
                self.logoutButton.isEnabled = false
                self.startButton.isEnabled = false
                self.leaveButton.isEnabled = true
                self.startVideoButton.isEnabled = true
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [self] _ in
                    self.whoIsSpeaking();
                   })
            }, fail: { error in })
        }, fail: { error in })
    }
    
    @objc func leaveButtonAction(sender: UIButton!) {
        VoxeetSDK.shared.conference.leave { error in
            self.logoutButton.isEnabled = true
            self.startButton.isEnabled = true
            self.leaveButton.isEnabled = false
            self.startVideoButton.isEnabled = false
            self.stopVideoButton.isEnabled = false
            self.participantsLabel.text = nil
        }
    }
    
    @objc func startVideoButtonAction(sender: UIButton!) {
        VoxeetSDK.shared.video.local.start { error in
            if error == nil {
                self.startVideoButton.isEnabled = false
                self.stopVideoButton.isEnabled = true
            }
        }
    }
    
    
    @objc func stopVideoButtonAction(sender: UIButton!) {
        VoxeetSDK.shared.video.local.stop { error in
            if error == nil {
                self.startVideoButton.isEnabled = true
                self.stopVideoButton.isEnabled = false
            }
        }
    }
    
 
    
@objc private func whoIsSpeaking() {
              
        if ((localParticpant == nil)) {return };
        
        let isSpeaking  = VoxeetSDK.shared.conference.isSpeaking(participant: localParticpant);
        
        if(isSpeaking == true){
            videosView1.layer.borderWidth = 3
            videosView1.layer.borderColor = UIColor.green.cgColor
        }else {
            videosView1.layer.borderWidth = 3
            videosView1.layer.borderColor = UIColor.clear.cgColor
        }
        
        if ((remoteParticpant == nil)) {return };
        
        let isRemoteSpeaking  = VoxeetSDK.shared.conference.isSpeaking(participant: remoteParticpant);
        if(isRemoteSpeaking == true){
            videosView2.layer.borderWidth = 3
            videosView2.layer.borderColor = UIColor.green.cgColor
        }else {
            videosView2.layer.borderWidth = 3
            videosView2.layer.borderColor = UIColor.clear.cgColor
        }
    }
}

extension ViewController: VTConferenceDelegate {
    func statusUpdated(status: VTConferenceStatus) {}
    
    func permissionsUpdated(permissions: [Int]) {}
    
    func participantAdded(participant: VTParticipant) {}
    
    func participantUpdated(participant: VTParticipant) {}
    
    func streamAdded(participant: VTParticipant, stream: MediaStream) {
        streamUpdated(participant: participant, stream: stream)
    }
    
    func streamUpdated(participant: VTParticipant, stream: MediaStream) {
            if participant.id == VoxeetSDK.shared.session.participant?.id {
                if !stream.videoTracks.isEmpty {
                    videosView1.attach(participant: participant, stream: stream)
                    localParticpant = participant;
                } else {
                    videosView1.unattach() /* Optional */
                    
                }
            } else {
                if !stream.videoTracks.isEmpty {
                    videosView2.attach(participant: participant, stream: stream)
                    remoteParticpant = participant;
                } else {
                    videosView2.unattach() /* Optional */
                }
            }
        // Update participants label.
        updateParticipantsLabel()
    }
    
    func streamRemoved(participant: VTParticipant, stream: MediaStream) {
        updateParticipantsLabel()
    }
    
    func updateParticipantsLabel() {
        // Update participants label.
        let participants = VoxeetSDK.shared.conference.current?.participants
            .filter({ $0.streams.isEmpty == false })
        let usernames = participants?.map({ $0.info.name ?? "" })
        participantsLabel.text = usernames?.joined(separator: ", ")
    }
}

// extend to dismiss keboard
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
