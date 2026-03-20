class_name LocalisationLabel extends Label

@export_multiline var english_text: String
@export_multiline var polish_text: String

func getText() -> String:
	return english_text if Settings.getSettingsData().isEnglish() else polish_text
