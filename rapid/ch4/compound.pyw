import sys
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import (QApplication, QComboBox, QDialog, QDoubleSpinBox, QGridLayout, QLabel)


class Form(QDialog):

    def __init__(self, parent=None):
        super(Form, self).__init__(parent)

        startingAmountLabel = QLabel("Amount:")
        self.startingAmountSpin = QDoubleSpinBox()
        self.startingAmountSpin.setRange(0.01, 1000000000.00)
        self.startingAmountSpin.setValue(100)
        self.startingAmountSpin.setPrefix("£ ")
        rateLabel = QLabel("Rate:")
        self.rateSpin = QDoubleSpinBox()
        self.rateSpin.setRange(0.01, 100)
        self.rateSpin.setValue(5)
        self.rateSpin.setSuffix(" %")
        yearsLabel = QLabel("Years:")
        self.yearsSpin = QComboBox()
        self.yearsSpin.addItem("1 year")
        self.yearsSpin.addItems(["{0} years".format(x) for x in range(2, 26)])
        amountAfterInterestLabel = QLabel("After interest:")
        self.amountAfterInterest = QLabel()

        grid = QGridLayout()
        grid.addWidget(startingAmountLabel, 0, 0)
        grid.addWidget(self.startingAmountSpin, 0, 1)
        grid.addWidget(rateLabel, 1, 0)
        grid.addWidget(self.rateSpin, 1, 1)
        grid.addWidget(yearsLabel, 2, 0)
        grid.addWidget(self.yearsSpin, 2, 1)
        grid.addWidget(amountAfterInterestLabel, 3, 0)
        grid.addWidget(self.amountAfterInterest, 3, 1)
        self.setLayout(grid)

        self.startingAmountSpin.valueChanged.connect(self.updateUi)
        self.rateSpin.valueChanged.connect(self.updateUi)
        self.yearsSpin.currentIndexChanged.connect(self.updateUi)

        self.setWindowTitle("Compound interest")

    def updateUi(self):
        """Calculates teh compound interest and then updates the UI"""
        startAmount = self.startingAmountSpin.value()
        rate = self.rateSpin.value()
        years = self.yearsSpin.currentIndex() + 1
        afterInterest = startAmount * ((1 + (rate / 100.0)) ** years)
        self.amountAfterInterest.setText("£ {0:.2f}".format(afterInterest))

app = QApplication(sys.argv)
form = Form()
form.show()
form.updateUi()
app.exec_()
