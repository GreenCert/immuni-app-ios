// PickerHealthCardDate.swift
// Copyright (C) 2020 Presidenza del Consiglio dei Ministri.
// Please refer to the AUTHORS file for more information.
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import Tempura
import UIKit
import DropDown
public struct TextFieldCodeTypeVM: ViewModel {}

open class TextFieldCodeType: UIView, ModellableView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        style()
    }

    private let container = UIView()
    private let selectIcon = UIImageView()
    private let dropDownIcon = UIImageView()
    public let textfield = UITextField()
    private let dropdown = DropDown()


    var didChangeCodeType: CustomInteraction<CodeType>?

    public func setup() {

        addSubview(container)
        container.addSubview(selectIcon)
        container.addSubview(dropDownIcon)
        container.addSubview(textfield)

        textfield.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapContainer))
        container.addGestureRecognizer(tapGesture)
        let tapGestureSelect = UITapGestureRecognizer(target: self, action: #selector(didTapSelect))
        textfield.addGestureRecognizer(tapGestureSelect)
        textfield.inputView = UIView()
    }
    @objc private func didTapSelect() {
        Self.Style.pickerIcon(selectIcon, onFocus: true)
        self.dropdown.cornerRadius = 15
        self.dropdown.backgroundColor = Palette.white
        self.dropdown.selectedTextColor = Palette.purple
        self.dropdown.cellConfiguration = { (index, item) in
            return "  \(item)"
          }
        self.dropdown.dataSource = CodeType.getCodeList()
        self.dropdown.anchorView = self.container
        self.dropdown.bottomOffset = CGPoint(x: 0, y: (self.container.frame.size.height+10))
        self.dropdown.show()
        self.dropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self, let codeType = CodeType(rawValue: item) else { return }
            self.textfield.text = item
            
            self.didChangeCodeType?(codeType)
            Self.Style.pickerIcon(self.selectIcon, onFocus: false)
            }
    }

    @objc private func didTapContainer() {

        if textfield.isFirstResponder {
            textfield.resignFirstResponder()
        } else {
            textfield.becomeFirstResponder()
        }
    }

    public func style() {
        Self.Style.container(container)
        Self.Style.dropDownIcon(dropDownIcon)
    }

    public func update(oldModel _: TextFieldCodeTypeVM?) {
        guard let _ = model else {
            return
        }

        Self.Style.shadow(container)
        Self.Style.pickerIcon(selectIcon, onFocus: false)
        Self.Style.textfield(textfield, isEnabled: self.textfield.isEnabled)

        setNeedsLayout()
    }
    override open func layoutSubviews() {
        super.layoutSubviews()

        container.pin
            .vertically()
            .horizontally(15)

        selectIcon.pin
            .size(24)
            .left(12)
            .vCenter()
        
        dropDownIcon.pin
            .size(24)
            .right(12)
            .vCenter()

        textfield.pin
            .after(of: selectIcon)
            .horizontally(36)
            .marginLeft(5)
            .vertically(5)
    }

    // Helpers

    @discardableResult override open func resignFirstResponder() -> Bool {
        return textfield.resignFirstResponder()
    }
}

// MARK: - Style

extension TextFieldCodeType {
    enum Style {
        static func container(_ view: UIView) {
            view.backgroundColor = Palette.white
            view.layer.cornerRadius = 15
        }

        static func shadow(_ view: UIView) {
            view.addShadow(.textfieldFocus)
        }

        static func pickerIcon(_ view: UIImageView, onFocus: Bool) {
            view.image = Asset.Home.tipology.image
            view.contentMode = .scaleAspectFit
            view.image = view.image?.withRenderingMode(.alwaysTemplate)
            view.tintColor = onFocus ? Palette.primary : Palette.grayNormal
        }
        
        static func dropDownIcon(_ view: UIImageView) {
            view.image = Asset.Home.down.image
            view.contentMode = .scaleAspectFit
        }

        static func textfield(_ textfield: UITextField, isEnabled: Bool) {
            let textStyle = TextStyles.p.byAdding([
                .color(Palette.primary)
            ])
            let placeholderStyle = TextStyles.p.byAdding([
                .color(isEnabled ? Palette.grayNormal : Palette.grayExtraWhite),
                .font(UIFont.boldSystemFont(ofSize: 14.0))
            ])

            textfield.returnKeyType = .search
            textfield.tintColor = Palette.primary
            textfield.typingAttributes = textStyle.attributes
            textfield.defaultTextAttributes = textStyle.attributes

            let placeholder = NSAttributedString(string: "Tipologia di codice")
            textfield.attributedPlaceholder = placeholder.styled(with: placeholderStyle)
        }
    }
}

// MARK: - Delegate

extension TextFieldCodeType: UITextFieldDelegate {
  
    public func textFieldDidBeginEditing(_: UITextField) {}

    public func textFieldDidEndEditing(_: UITextField) {}

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return false
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
