local a_name, a_env = ...

local popup_edit_text
StaticPopupDialogs["SR13_UTILS_COPYPASTA"] = {
   preferredIndex = 3,
   text = "Ctrl-C",
   button1 = ACCEPT,
   button2 = CLOSE,
   hasEditBox = 1,
   OnShow = function(self)
      local editBox = _G[self:GetName().."EditBox"]
      editBox:SetText(popup_edit_text)
      editBox:HighlightText()
      editBox:SetAutoFocus(false)
      editBox:SetJustifyH("LEFT")
      editBox:SetJustifyV("TOP")
      editBox:SetFocus()
      local dialogBox = editBox:GetParent()
      dialogBox:SetPoint("CENTER", "UIParent")
   end,
   EditBoxOnEnterPressed = function(self)
      self:GetParent():Hide();
   end,
   EditBoxOnEscapePressed = function(self)
      self:GetParent():Hide();
   end,
   OnHide = function(self)
      _G[self:GetName().."EditBox"]:SetText("");
   end,
   timeout = 0,
   hideOnEscape = 1,
}

function a_env.Copypasta(text)
   popup_edit_text = text
   StaticPopup_Show("SR13_UTILS_COPYPASTA")
end
_G[a_name] = _G[a_name] or {}
_G[a_name].Copypasta = a_env.Copypasta
-- /run _G["SR13-Utils"].Copypasta("Test!")
