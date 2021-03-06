//
//  ViewController.swift
//  calculator
//
//  Created by osakamiseri on 2020/04/20.
//  Copyright © 2020 osakamiseri. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    var firstNumber = ""
    var secondNumber = ""
    var calculateStatus: CalculateStatus.Item = .none
    let numbers = [
        ["C","%","$","÷"],
        ["7","8","9","×"],
        ["4","5","6","-"],
        ["1","2","3","+"],
        ["0",".","="],
    ]

    @IBOutlet private weak var caluculator: UICollectionView! {
        didSet {
            caluculator.delegate = self
            caluculator.dataSource = self
            caluculator.register(CaluculatorViewCell.self, forCellWithReuseIdentifier: "cellID")
            calculatorHeight.constant = view.frame.width * 1.4
            caluculator.backgroundColor = .clear
            caluculator.contentInset = .init(top: 10, left: 14, bottom: 0, right: 14)
        }
    }
    @IBOutlet private weak var numberLabel: UILabel! {
        didSet {
            numberLabel.text = "0"
        }
    }
    @IBOutlet weak var calculatorHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    func clear() {
        firstNumber = ""
        secondNumber = ""
        numberLabel.text = "0"
        calculateStatus = .none
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout CollectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        width = ((collectionView.frame.width - 10) - 14 * 5) / 4
        let height = width
        
        if indexPath.section == 4 && indexPath.row == 0 {
            width = width * 2 + 14 + 3
        }
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        let cell = caluculator.dequeueReusableCell(withReuseIdentifier: "cellID", for:
                                                    indexPath) as! CaluculatorViewCell
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]

        numbers[indexPath.section][indexPath.row].forEach { (numberString) in
            if "0"..."9" ~= numberString || numberString.description == "." {
                cell.numberLabel.backgroundColor = .darkGray
            } else if numberString == "C" || numberString == "$" || numberString == "%" {
                cell.numberLabel.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
                cell.numberLabel.textColor = .black
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numbers[indexPath.section][indexPath.row]
        
        switch calculateStatus {
        case .none:
            switch number {
            case "0"..."9":
                firstNumber += number
                numberLabel.text = firstNumber
                
                if firstNumber.hasPrefix("0") {
                    firstNumber = ""
                }
                
            case ".":
                if confirmIncLudeDecimalPoint(numberString: firstNumber) {
                    firstNumber += number
                    numberLabel.text = firstNumber
                }
            case "+":
                calculateStatus = .plus
            case "-":
                calculateStatus = .minus
            case "×":
                calculateStatus = .multiplication
            case "÷":
                calculateStatus = .division
            case "C":
                clear()
                
            default:
                break
            }
            
        case .plus, .minus, .multiplication, .division:
            switch number {
            case "0"..."9":
                secondNumber += number
                numberLabel.text = secondNumber
                
                if secondNumber.hasPrefix("0") {
                    secondNumber = ""
                }

            case ".":
                if confirmIncLudeDecimalPoint(numberString: secondNumber) {
                    secondNumber += number
                    numberLabel.text = secondNumber
                }
            case "=":
                let firstNum = Double(firstNumber) ?? 0
                let secondNum = Double(secondNumber) ?? 0
                var resultString: String?
                
                switch calculateStatus {
                case .plus:
                    resultString = String(firstNum + secondNum)
                case .minus:
                    resultString = String(firstNum - secondNum)
                case .multiplication:
                    resultString = String(firstNum * secondNum)
                case .division:
                    resultString = String(firstNum / secondNum)
                default:
                    break
                }
                
                if let result = resultString, result.hasSuffix(".0") {
                    resultString = result.replacingOccurrences(of: ".0", with: "")
                }
                numberLabel.text = resultString
                firstNumber = ""
                secondNumber = ""
                firstNumber += resultString ?? ""
                calculateStatus = .none
                
            case "C":
                clear()
                
            default: break
            }
        }
    }
    
    private func confirmIncLudeDecimalPoint(numberString: String) -> Bool {
        if numberString.range(of: ".") != nil || numberString.count == 0 {
            return true
        } else {
            return false
        }
    }
}

