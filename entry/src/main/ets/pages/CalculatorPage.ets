// pages/CalculatorPage.ets
@Entry
@Component
struct CalculatorPage {
  @State displayText: string = '0';
  @State firstNum: number = 0;
  @State operator: string = '';
  @State isReset: boolean = false;

  build() {
    Column() {
      // 显示区域
      Stack({ alignContent: Alignment.BottomEnd }) {
        Text(this.displayText)
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .maxLines(1)
          .padding(20)
      }
      .width('100%')
      .flexGrow(1)
      .backgroundColor('#F5F5F5')

      // 修复后的Grid按钮区域（所有回调函数添加void返回类型）
      Grid() {
        // 第一行：AC、DEL、÷
        GridItem() { this.buildButton('AC', '#FF4D4F', (): void => this.clearAll()) }
        GridItem() { this.buildButton('DEL', '#FF9500', (): void => this.deleteLast()) }
        GridItem() { this.buildButton('÷', '#007DFF', (): void => this.setOperator('/')) }

        // 第二行：7、8、9、×
        GridItem() { this.buildButton('7', '#FFFFFF', (): void => this.appendNum('7')) }
        GridItem() { this.buildButton('8', '#FFFFFF', (): void => this.appendNum('8')) }
        GridItem() { this.buildButton('9', '#FFFFFF', (): void => this.appendNum('9')) }
        GridItem() { this.buildButton('×', '#007DFF', (): void => this.setOperator('*')) }

        // 第三行：4、5、6、-（已添加void返回类型）
        GridItem() { this.buildButton('4', '#FFFFFF', (): void => this.appendNum('4')) }
        GridItem() { this.buildButton('5', '#FFFFFF', (): void => this.appendNum('5')) }
        GridItem() { this.buildButton('6', '#FFFFFF', (): void => this.appendNum('6')) }
        GridItem() { this.buildButton('-', '#007DFF', (): void => this.setOperator('-')) }

        // 第四行：1、2、3、+（已添加void返回类型）
        GridItem() { this.buildButton('1', '#FFFFFF', (): void => this.appendNum('1')) }
        GridItem() { this.buildButton('2', '#FFFFFF', (): void => this.appendNum('2')) }
        GridItem() { this.buildButton('3', '#FFFFFF', (): void => this.appendNum('3')) }
        GridItem() { this.buildButton('+', '#007DFF', (): void => this.setOperator('+')) }

        // 第五行：0、.、=（已添加void返回类型）
        GridItem({ columnSpan: 2 }) { this.buildButton('0', '#FFFFFF', (): void => this.appendNum('0')) }
        GridItem() { this.buildButton('.', '#FFFFFF', (): void => this.appendDot()) }
        GridItem() { this.buildButton('=', '#00C689', (): void => this.calculateResult()) }
      }
      // API 12适配的行列配置
      .columns({ count: 4, sizeType: GridSizeType.FIXED })
      .rows({ count: 5, sizeType: GridSizeType.FIXED })
      .rowHeight(60)
      .width('100%')
      .backgroundColor('#E5E5E5')
      .borderRadius({ topLeft: 20, topRight: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 按钮构建器（显式声明void返回类型）
  @Builder
  buildButton(text: string, bgColor: string, onClick: () => void): void {
    Button(text)
      .width('90%')
      .height('90%')
      .backgroundColor(bgColor)
      .fontSize(24)
      .fontWeight(FontWeight.Bold)
      .fontColor(text === '=' || bgColor.startsWith('#FF') || bgColor.startsWith('#007DFF') ? Color.White : Color.Black)
      .borderRadius(15)
      .onClick(onClick)
  }

  // 所有业务函数均显式声明void返回类型
  appendNum(num: string): void {
    if (this.isReset) {
      this.displayText = num;
      this.isReset = false;
    } else {
      this.displayText = this.displayText === '0' ? num : this.displayText + num;
    }
  }

  appendDot(): void {
    if (this.isReset) {
      this.displayText = '0.';
      this.isReset = false;
    } else if (!this.displayText.includes('.')) {
      this.displayText += '.';
    }
  }

  setOperator(op: string): void {
    this.firstNum = parseFloat(this.displayText);
    this.operator = op;
    this.isReset = true;
  }

  calculateResult(): void {
    if (!this.operator || this.isReset) return;
    const secondNum = parseFloat(this.displayText);
    let result = 0;

    switch (this.operator) {
      case '+':
        result = this.firstNum + secondNum;
        break;
      case '-':
        result = this.firstNum - secondNum;
        break;
      case '*':
        result = this.firstNum * secondNum;
        break;
      case '/':
        if (secondNum === 0) {
          this.displayText = '错误';
          this.isReset = true;
          return;
        }
        result = this.firstNum / secondNum;
        break;
    }

    this.displayText = result % 1 === 0 ? result.toString() : result.toFixed(6).replace(/\.?0*$/, '');
    this.isReset = true;
    this.operator = '';
  }

  clearAll(): void {
    this.displayText = '0';
    this.firstNum = 0;
    this.operator = '';
    this.isReset = false;
  }

  deleteLast(): void {
    if (this.displayText.length === 1 || this.displayText === '错误') {
      this.displayText = '0';
    } else {
      this.displayText = this.displayText.slice(0, -1);
    }
    this.isReset = false;
  }
}