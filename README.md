# ruler_picker   标尺选择器

This is a picker with ruler style for flutter.

标尺样式来选择数字，支持自定义 marker

# Usage   使用方法

```
RulerPicker(
  controller: _rulerPickerController,
  onValueChange: (value) {
    setState(() {
      _textEditingController.text = value.toString();
    });
  },
  width: 300,
  height: 100,
),
```
# Example 示例代码

./sample 文件夹


