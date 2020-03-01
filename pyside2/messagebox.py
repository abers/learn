#!/usr/bin/python

import sys
from PySide2.QtWidgets import QApplication, QMessageBox

# Create the Application object
app = QApplication(sys.argv)

# Create a simple dialog box
msg_box = QMessageBox()
msg_box.setText("Hellow World!")
msg_box.show()

sys.exit(msg_box.exec_())
