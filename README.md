# ruler_picker   标尺选择器

This is a picker with ruler style for flutter.

标尺样式来选择数字，支持自定义 marker

# demo    演示

![demo](https://i.imgur.com/zYizFdT.gif)

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

./example 文件夹

