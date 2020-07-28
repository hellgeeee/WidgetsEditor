import QtQuick 2.10


QtObject {
  enum EditingMode {
    SETTINGS = 0,
    GRAPHIC_EDITING = 1,
    TEXT_EDITING = 2,
    IN_OUT_SETTINGS = 3,
    TUTORIAL = 4,
    ABOUT = 5
  }
    enum AttributeRepresentation {
      TEXT = 0,
      ANALOG = 1
    }

    enum FileChoosing {
      IN_FILE = 0,
      OUT_FILE = 1,
      EXISTING_WIDGETS_FILE
    }
}
