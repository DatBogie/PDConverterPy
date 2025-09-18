import os, sys, json, rblxopencloud
from PySide6.QtCore import QDir, Qt, QStandardPaths
from PySide6.QtWidgets import QMainWindow, QLineEdit, QPushButton, QApplication, QVBoxLayout, QWidget, QComboBox, QFileDialog


_DATA_FOLDER_PATH = os.path.join(QStandardPaths.writableLocation(QStandardPaths.StandardLocation.ConfigLocation),"PDConverter")
_DATA_PATH = os.path.join(_DATA_FOLDER_PATH,"data.json")

if not os.path.exists(_DATA_FOLDER_PATH):
    os.mkdir(_DATA_FOLDER_PATH)

_API_KEY = None
_USER_ID = None

if os.path.exists(_DATA_PATH):
    with open(_DATA_PATH,"r") as f:
        try:
            data = json.load(f)
            _API_KEY = data["api-key"]
            _USER_ID = data["user-id"]
        except:pass

class LevelData():
    def __init__(self):
        self.reset()
    def reset(self):
        self.levelPath = None
        self.levelName = None
        self.levelNames = []
        self.songName = None
        self.songId = None
        self.assets = []
        self.assetIds = []
        self.files = {}
        self.levelJSON = None
    def request(self):
        global _API_KEY, _USER_ID
        print(_API_KEY,_USER_ID)
        if not _API_KEY or not _USER_ID: raise(Exception("No API Key!"))
        
        self.levelJSON = json.loads(self.files[self.levelName])
        self.songName = self.levelJSON["settings"]["songFilename"]
        
        usr = rblxopencloud.User(_USER_ID,_API_KEY)
        
        with open(os.path.join(self.levelPath,self.songName),"rb") as song:
            operation = usr.upload_asset(song,rblxopencloud.AssetType.Audio,self.songName,"Automatically uploaded via Planets Dance Converter.",0)
        asset = operation.wait()
        self.songId = asset.id
            
    def getLevelContents(self):
        data = QDir(self.levelPath).entryInfoList()
        for f in data:
            if f.isDir(): continue
            fName = f.fileName()
            if fName.lower().endswith(".adofai"):
                self.levelNames.append(fName)
            with open(f.absoluteFilePath(),"rb") as file:
                self.files[fName] = file.read()
    def setPath(self,levelPath:str) -> list[str]:
        self.reset()
        print(levelPath)
        self.levelPath = levelPath
        self.getLevelContents()
        return self.levelNames
        

def writeConfig():
    global _API_KEY, _USER_ID
    try:
        with open(_DATA_PATH,"w") as DATA_FILE:
            json.dump({ "api-key": _API_KEY, "user-id": _USER_ID }, DATA_FILE)
    except Exception as e:
        print(e)

class MainWindow(QMainWindow):
    LEVEL_DATA = LevelData()
    def __init__(self):
        super().__init__()
        
        # Overarching Layout
        centralWidget = QWidget()
        self.setCentralWidget(centralWidget)
        mainLay = QVBoxLayout()
        mainLay.setAlignment(Qt.AlignmentFlag.AlignTop)
        centralWidget.setLayout(mainLay)
        
        # Inputs
        self.uplFolder = QPushButton("Choose Folder...")
        self.uplFolder.clicked.connect(self.fUplFolder)
        mainLay.addWidget(self.uplFolder)

        self.levelName = QComboBox()
        self.levelName.currentTextChanged.connect(self.fLevelName)
        mainLay.addWidget(self.levelName)
        
        self.userId = QLineEdit()
        self.userId.setPlaceholderText("Enter UserId...")
        self.userId.textEdited.connect(self.fUserId)
        mainLay.addWidget(self.userId)
        if _USER_ID:
            self.userId.setText(_USER_ID)
        
        self.apiKey = QLineEdit()
        self.apiKey.setPlaceholderText("Enter API Key...")
        self.apiKey.textEdited.connect(self.fApiKey)
        mainLay.addWidget(self.apiKey)
        if _API_KEY:
            self.apiKey.setText(_API_KEY)
        
        self.submit = QPushButton("Convert")
        self.submit.clicked.connect(self.fSubmit)
        mainLay.addWidget(self.submit)
    def fLevelName(self):
        if not self.levelName.currentText() or self.levelName.currentText() == "":
            self.LEVEL_DATA.levelName = None
        else:
            self.LEVEL_DATA.levelName = self.levelName.currentText()
    def fApiKey(self):
        global _API_KEY
        _API_KEY = self.apiKey.text().strip()
        writeConfig()
    def fUserId(self):
        global _USER_ID
        _USER_ID = self.userId.text().strip()
        writeConfig()
    def fSubmit(self):
        self.LEVEL_DATA.request()
    def fUplFolder(self):
        folderPath = QFileDialog.getExistingDirectory(self,"Choose ADOFAI Level")
        if not folderPath: return
        comboItems = self.LEVEL_DATA.setPath(folderPath)
        self.levelName.clear()
        self.levelName.addItems(comboItems)
        for x in comboItems:
            if x.lower() == "main.adofai":
                self.levelName.setCurrentText(x)
                break

if __name__ == "__main__":
    app = QApplication([])
    win = MainWindow()
    win.show()
    sys.exit(app.exec())