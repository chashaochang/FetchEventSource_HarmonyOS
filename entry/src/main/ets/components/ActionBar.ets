
@ComponentV2
export struct ActionBar {
  @Param title: string = ''
  @Param enableNavBack: boolean = true
  @Param isLight: boolean = false
  pathStack: NavPathStack = AppStorage.get("PathStack") as NavPathStack

  build() {
    RelativeContainer() {
      if (this.enableNavBack) {
        SymbolGlyph($r('sys.symbol.chevron_backward'))
          .fontSize(24).fontColor([this.isLight ? Color.White : Color.Black])
          .fontWeight(FontWeight.Bold)
          .padding($r('app.float.actionbar_nav_icon_padding'))
          .alignRules({
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            center: { anchor: '__container__', align: VerticalAlign.Center }
          }).onClick(() => {
          this.pathStack.pop()
        })
      }
      Text(this.title)
        .fontSize('22fp')
        .fontColor(this.isLight ? Color.White : Color.Black)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          center: { anchor: '__container__', align: VerticalAlign.Center }
        })
    }.height('48vp').zIndex(1)
  }
}