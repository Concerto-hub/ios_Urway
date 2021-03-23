//
//  ViewController.swift
//  UrwayDemoApp
//
//

import UIKit
import Urway
import PassKit

class ViewController: UIViewController , UIScrollViewDelegate{
    
    
    @IBOutlet var amountField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var zipField: UITextField!
    @IBOutlet var currencyField: UITextField!
    @IBOutlet var countryField: UITextField!
    @IBOutlet var actionField: UITextField!
    
    @IBOutlet var trackIDField: UITextField!
    
    @IBOutlet var utf1: UITextField!
    @IBOutlet var utf2: UITextField!
    @IBOutlet var utf3: UITextField!
    @IBOutlet var utf4: UITextField!
    @IBOutlet var utf5: UITextField!
    
    @IBOutlet var merchantField: UITextField!
    @IBOutlet var tockenField: UITextField!
    @IBOutlet var picker: UIPickerView!
    
    @IBOutlet var stateField: UITextField!
    @IBOutlet var cityField: UITextField!
    @IBOutlet var addressField: UITextField!
    @IBOutlet var holderField: UITextField!

    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var holderStakView: UIStackView!
    
    @IBOutlet var segmentController: UISegmentedControl!
    @IBOutlet var topsegmentController: UISegmentedControl!
    
    @IBOutlet var topHolderStack: UIStackView!
    
    var pickerHeightAnchor: NSLayoutConstraint? = nil
    var addressHeightAnchor: NSLayoutConstraint? = nil
    var stateHeightAnchor: NSLayoutConstraint? = nil
    var cityHeightAnchor: NSLayoutConstraint? = nil
    var countryHeightAnchor: NSLayoutConstraint? = nil
    var cardTokenHeightAnchor:NSLayoutConstraint? = nil
    
    let pickerData = ["Add" , "Update" , "Delete"]
    var selectedText = "Add"
    var isTokenEnabled: Bool = true
    var paymentController: UIViewController? = nil
    
    var paymentString: NSString = ""
    var isApplePayPaymentTrxn:Bool = false;

    var paymentRequest : PKPaymentRequest = {
           let request = PKPaymentRequest()
           request.merchantIdentifier = "merchant.testios.com"
           request.supportedNetworks = [.quicPay, .masterCard, .visa , .amex , .discover , .mada ]
           request.merchantCapabilities = .capability3DS
           request.countryCode = "SA"
           request.currencyCode = "SAR"
           return request
       }()
    
    var isSucessStatus: Bool = false
    
    
    var originalSize: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
              
        self.title = "DEMO"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.view.backgroundColor = .white
        self.scrollview.showsVerticalScrollIndicator = false
        self.scrollview.delegate = self
        
        self.originalSize = self.tockenField.frame.height
        
        prepareConstraints()
        enableTokenFieldsAction()
        
        segmentController.setTitle("Present", forSegmentAt: 0)
        segmentController.setTitle("Not Present", forSegmentAt: 1)
        
        
        topsegmentController.setTitle("Normal Pay", forSegmentAt: 0)
        topsegmentController.setTitle("Apple Pay", forSegmentAt: 1)
        
        

        
        if  UIScreen.main.traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = .white
        } else {
            self.view.backgroundColor = .black
        }

    
    }
    
    
    @IBAction func indexChanged(_ sender: Any) {
       let index =  topsegmentController.selectedSegmentIndex
        UIView.animate(withDuration: 0.3) {
            self.topHolderStack.alpha = (index == 1) ? 0 : 1
            self.topHolderStack.isHidden = index == 1
            self.view.layoutIfNeeded()
        }

        self.isTokenEnabled = index == 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        [amountField , emailField , zipField , currencyField , countryField ,tockenField , actionField , utf1 , utf2 , utf3 , utf4 , utf5 , stateField , cityField, addressField, trackIDField , merchantField].forEach({$0?.text = ""})
        
        if  UIScreen.main.traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = .white
        } else {
            self.view.backgroundColor = .black
        }
    }
    
    @IBAction func urWayTapped() {        
       let isApplePayPayment = topsegmentController.selectedSegmentIndex == 1
        
        
        if isApplePayPayment {
            self.applePaymentconfigureSDK()
            self.applePayButtonAction()
            self.isApplePayPaymentTrxn=true;
        } else {
            self.normalPaymentconfigureSDK()
            self.initializeSDK()
            self.isApplePayPaymentTrxn=false;
        }
        
    }
    
    
    fileprivate func initializeSDK() {
        UWInitialization(self) { (controller , result) in
            self.paymentController = controller
            guard let nonNilController = self.paymentController else {
                self.presentAlert(resut: result)
                return
            }
            
            self.navigationController?.pushViewController(nonNilController, animated: true)
        }

    }
    
    func applePaymentconfigureSDK() {
        let terminalId = "IosPay"
        let password = "password"
        let merchantKey = "96f0a1bd28450c130552bc38d8cb507655ca66d92ea7f558b37d4322c8802b39"
        let url = "https://payments-dev.urway-tech.com/URWAYPGService/transaction/jsonProcess/JSONrequest"
     
        UWConfiguration(password: password, merchantKey: merchantKey, terminalID: terminalId , url: url)
    }
    
    
    func normalPaymentconfigureSDK() {
        let terminalId = "iOSAndTerm"
        let password = "password"
        let merchantKey = "07dc98635e206f259d9d19a12a02750c8c3a996354bc959508e45449c1bcd02f"
        let url = "https://payments-dev.urway-tech.com/URWAYPGService/transaction/jsonProcess/JSONrequest"
     
        UWConfiguration(password: password, merchantKey: merchantKey, terminalID: terminalId , url: url)
    }
    
    fileprivate func applePayButtonAction() {
        
        
        UWInitialization(self) { (controller , result) in
            self.paymentController = controller
            guard let _ = self.paymentController else {
                self.presentAlert(resut: result)
                return
            }
        }
        
        isSucessStatus = false
        let floatAmount = Double(amountField.text ?? "0") ?? .zero
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "iPhone XR 128 GB",
                                                                   amount: NSDecimalNumber(floatLiteral: floatAmount) )]
        let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if controller != nil {
            controller!.delegate = self
            present(controller!, animated: true, completion: nil)
        }
    }
}


//MARK: - APPLE PAYMENT CODE
extension ViewController : PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        isSucessStatus ? self.initializeSDK() : nil
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        self.paymentString = UWInitializer.generatePaymentKey(payment: payment)
        isSucessStatus = true
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}


extension ViewController {
    
    fileprivate func prepareConstraints() {
        scrollview.contentSize = CGSize(width: self.view.frame.width, height: (self.holderStakView.frame.height  + 100))
        self.picker.translatesAutoresizingMaskIntoConstraints = false
        self.picker.dataSource = self
        self.picker.delegate = self
        self.pickerHeightAnchor = picker.heightAnchor.constraint(equalToConstant: 0)
        self.cardTokenHeightAnchor = tockenField.heightAnchor.constraint(equalToConstant: self.originalSize)
        self.stateHeightAnchor = stateField.heightAnchor.constraint(equalToConstant: self.originalSize)
        self.cityHeightAnchor = cityField.heightAnchor.constraint(equalToConstant: self.originalSize)
        self.countryHeightAnchor = countryField.heightAnchor.constraint(equalToConstant: self.originalSize)
        self.addressHeightAnchor = addressField.heightAnchor.constraint(equalToConstant: self.originalSize)

        
        self.pickerHeightAnchor?.isActive = true
        self.cardTokenHeightAnchor?.isActive = true
        self.stateHeightAnchor?.isActive = true
        self.cityHeightAnchor?.isActive = true
        self.countryHeightAnchor?.isActive = true
        self.addressHeightAnchor?.isActive = true
        
        self.view.layoutIfNeeded()
    }
    
    @IBAction func switchOnePressed(_ sender: UISwitch) {
        if sender.isOn {
            isTokenEnabled = true
            enableTokenFieldsAction()
        } else {
            isTokenEnabled = false
            disableTockenFields()
        }
    }

    
    func enableTokenFieldsAction() {
        self.pickerHeightAnchor?.constant = 100
        self.picker.isHidden = false

        self.cityHeightAnchor?.constant = 0
        self.countryHeightAnchor?.constant = self.originalSize
        self.addressHeightAnchor?.constant = 0
        self.stateHeightAnchor?.constant = 0
        
        
        self.cityField.text = ""
        self.countryField.text = ""
        self.addressField.text = ""
        self.stateField.text = ""
        self.tockenField.text = ""
        
        self.cardTokenHeightAnchor?.constant = 0//5123456934530008
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    func disableTockenFields() {

        self.picker.isHidden = true
        self.pickerHeightAnchor?.constant = 0
        self.cityHeightAnchor?.constant = self.originalSize
        self.countryHeightAnchor?.constant = self.originalSize
        self.addressHeightAnchor?.constant = self.originalSize
        self.stateHeightAnchor?.constant = self.originalSize
        self.cardTokenHeightAnchor?.constant = self.originalSize
        
        
         UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK:- Picker
extension ViewController: UIPickerViewDataSource , UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.cardTokenHeightAnchor?.constant = row == 0 ? 0 : self.originalSize
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        self.selectedText = pickerData[row]
    }
}

extension ViewController: Initializer {
   
 
    
  func prepareModel() -> UWInitializer {
        let model = UWInitializer.init(amount: amountField.text ?? "",
                                       email: emailField.text ?? "",
                                       zipCode: zipField.text ?? "",
                                       currency: currencyField.text ?? "",
                                       country: countryField.text ?? "" ,
                                       actionCode: actionField.text ?? "",
                                       trackIdCode: trackIDField.text ?? "",
                                       udf4: isApplePayPaymentTrxn ? "ApplePay" : "",
                                       udf5:  isApplePayPaymentTrxn ? paymentString : "" ,
                                      //udf5: paymentString,
                                       address: addressField.text ,
                                       createTokenIsEnabled: isTokenEnabled,
                                       merchantIP: merchantField.text ?? "",
                                       cardToken: tockenField.text,
                                       pickerType: isTokenEnabled ? pickerType(rawValue: selectedText) : nil,
                                       state: stateField.text ,
                                       merchantidentifier: paymentRequest.merchantIdentifier ,
                                       tokenizationType: "\(segmentController.selectedSegmentIndex)",
                                       holderName: holderField.text)
        return model
    }
    
    
    func didPaymentResult(result: paymentResult, error: Error?, model: PaymentResultData?) {
        switch result {
        case .sucess:
            
            print("PAYMENT SUCESS")
            DispatchQueue.main.async {
                self.navigateTOReceptPage(model: model)
            }
            
        case.failure:
            
            print("PAYMENT FAILURE")
            DispatchQueue.main.async {
                self.navigateTOReceptPage(model: model)
            }
            
          
        case .mandatory(let fieldName):
            print(fieldName)
            break
        }
    }
    
    func navigateTOReceptPage(model: PaymentResultData?) {
        self.paymentController?.navigationController?.popViewController(animated: true)
        
        let controller = ReceptConfiguration.setup()
        controller.model = model
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true, completion: nil)
        
       
     
       
    }
    
}

extension ViewController {
    func presentAlert(resut: paymentResult) {
          var displayTitle: String = ""
          var key: mandatoryEnum = .amount

          switch resut {
          case .mandatory(let fields):
              key = fields
          default:
              break
          }
          
          switch  key {
          case .amount:
              displayTitle = "Amount"
          case.country:
              displayTitle = "Country"
          case.action_code:
              displayTitle = "Action Code"
          case.currency:
              displayTitle = "Currency"
          case.email:
              displayTitle = "Email"
          case.trackId:
              displayTitle = "TrackID"
          case .tockenID:
            displayTitle = "TockenID"
        }
          
          let alert = UIAlertController(title: "Alert", message: "Check \(displayTitle) Field", preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
      }
     
}
