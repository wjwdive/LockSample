# Xcode构建配置与Scheme配置指南

## 问题分析
目前项目存在以下问题：
1. 项目只有Debug和Release两个构建配置，缺少Test配置
2. 所有Scheme（包括LockSample-Dev和LockSample-Test）都指向Release配置
3. 我们创建的xcconfig文件没有关联到任何构建配置

## 解决步骤

### 一、添加Test构建配置

1. 打开Xcode项目
2. 选择项目根目录 -> 选择`LockSample`项目 -> 选择`Info`标签
3. 在`Configurations`部分，点击底部的`+`按钮
4. 选择`Duplicate Debug Configuration`
5. 将新配置命名为`Test`

### 二、关联xcconfig文件到构建配置

1. 选择项目根目录 -> 选择`LockSample`项目 -> 选择`Info`标签
2. 在`Configurations`部分，为每个配置设置对应的xcconfig文件：
   - **Debug**：选择`Config/Debug.xcconfig`
   - **Test**：选择`Config/Test.xcconfig`
   - **Release**：选择`Config/Release.xcconfig`
3. 对`LockSample`目标也进行同样的设置

### 三、配置Scheme

#### 配置LockSample-Dev Scheme
1. 选择顶部菜单栏`Product` -> `Scheme` -> `Edit Scheme...`
2. 在弹出窗口中，左侧选择`Run`
3. 右侧`Build Configuration`下拉菜单选择`Debug`
4. 点击`Close`保存

#### 配置LockSample-Test Scheme
1. 选择顶部菜单栏`Product` -> `Scheme` -> `Edit Scheme...`
2. 在弹出窗口中，左侧选择`Run`
3. 右侧`Build Configuration`下拉菜单选择`Test`
4. 点击`Close`保存

#### 配置LockSample Scheme
1. 选择顶部菜单栏`Product` -> `Scheme` -> `Edit Scheme...`
2. 在弹出窗口中，左侧选择`Run`
3. 右侧`Build Configuration`下拉菜单选择`Release`
4. 点击`Close`保存

### 四、验证配置

1. 选择`LockSample-Dev` Scheme
2. 运行项目
3. 查看控制台输出，应该看到：
   ```
   ==========================
   当前运行环境: 开发环境 (Debug)
   应用名称: LockSample
   应用版本: 1.0
   Bundle ID: com.example.lockSample.dev
   API基础地址: https://dev-api.example.com
   ==========================
   ```

4. 选择`LockSample-Test` Scheme
5. 运行项目
6. 查看控制台输出，应该看到：
   ```
   ==========================
   当前运行环境: 测试环境 (Test)
   应用名称: LockSample
   应用版本: 1.0
   Bundle ID: com.example.lockSample.test
   API基础地址: https://test-api.example.com
   ==========================
   ```

5. 选择`LockSample` Scheme
6. 运行项目
7. 查看控制台输出，应该看到：
   ```
   ==========================
   当前运行环境: 生产环境 (Release)
   应用名称: LockSample
   应用版本: 1.0
   Bundle ID: com.example.lockSample
   API基础地址: https://api.example.com
   ==========================
   ```

## 常见问题排查

### 1. 仍然显示"未知环境"
- 检查构建配置是否正确关联了xcconfig文件
- 检查Scheme是否选择了正确的构建配置
- 清理项目（Product -> Clean Build Folder）后重新构建

### 2. Bundle ID没有变化
- 检查xcconfig文件中的PRODUCT_BUNDLE_IDENTIFIER设置
- 确保xcconfig文件已正确关联到构建配置

### 3. API地址没有变化
- 检查xcconfig文件中的API_BASE_URL设置
- 确保AppDelegate.m中的printCurrentEnvironment方法使用了正确的预处理器宏

## 命令行构建

你可以使用以下命令行进行不同环境的构建：

### 开发环境
```bash
xcodebuild -scheme "LockSample-Dev" -configuration Debug -sdk iphonesimulator build
```

### 测试环境
```bash
xcodebuild -scheme "LockSample-Test" -configuration Test -sdk iphonesimulator build
```

### 生产环境
```bash
xcodebuild -scheme "LockSample" -configuration Release -sdk iphonesimulator build
```
