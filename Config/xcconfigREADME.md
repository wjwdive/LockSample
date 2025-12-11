# 配置文件说明

本项目使用xcconfig文件来管理不同环境的配置。

## 配置文件结构

```
Config/
├── Common.xcconfig    # 共享配置
├── Debug.xcconfig     # 开发环境配置
├── Test.xcconfig      # 测试环境配置
└── Release.xcconfig   # 生产环境配置
```

## 使用方法

### 1. 将xcconfig文件关联到项目

1. 打开Xcode项目
2. 选择项目文件（LockSample.xcodeproj）
3. 选择"LockSample"项目（不是target）
4. 进入"Info"标签页
5. 在"Configurations"部分，为每个配置选择对应的xcconfig文件：
   - Debug: Config/Debug.xcconfig
   - Test: Config/Test.xcconfig
   - Release: Config/Release.xcconfig

### 2. 在代码中使用配置变量

#### 在Objective-C中：

```objc
// 获取API地址
#ifdef TEST_ENV
    NSString *baseURL = @"https://test-api.example.com";
#elif PROD_ENV
    NSString *baseURL = @"https://api.example.com";
#endif

// 或者使用Info.plist中的变量
NSString *baseURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"API_BASE_URL"];
```

#### 在Swift中：

```swift
// 获取API地址
#if TEST_ENV
    let baseURL = "https://test-api.example.com"
#elseif PROD_ENV
    let baseURL = "https://api.example.com"
#endif

// 或者使用Info.plist中的变量
if let baseURL = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String {
    // 使用baseURL
}
```

### 3. 创建不同环境的Scheme

1. 打开Xcode项目
2. 选择"Product" -> "Scheme" -> "New Scheme..."
3. 为开发环境创建一个Scheme，例如"LockSample-Dev"
4. 为测试环境创建一个Scheme，例如"LockSample-Test"
5. 为生产环境创建一个Scheme，例如"LockSample-Prod"
6. 为每个Scheme配置对应的构建配置：
   - LockSample-Dev: 使用Debug配置
   - LockSample-Test: 使用Test配置
   - LockSample-Prod: 使用Release配置

### 4. 构建和打包

#### 使用命令行构建开发环境：
```bash
xcodebuild -scheme LockSample-Dev -configuration Debug build
```

#### 使用命令行构建测试环境：
```bash
xcodebuild -scheme LockSample-Test -configuration Test build
```

#### 使用命令行构建生产环境：
```bash
xcodebuild -scheme LockSample-Prod -configuration Release build
```

#### 使用命令行打包生产环境：
```bash
xcodebuild -scheme LockSample-Prod -configuration Release archive -archivePath ./build/LockSample.xcarchive
xcodebuild -exportArchive -archivePath ./build/LockSample.xcarchive -exportPath ./build -exportOptionsPlist ExportOptions.plist
```

## 配置变量说明

### Common.xcconfig
- `PRODUCT_NAME`: 应用名称
- `PRODUCT_BUNDLE_IDENTIFIER`: Bundle ID
- `MARKETING_VERSION`: 市场版本号
- `CURRENT_PROJECT_VERSION`: 内部版本号
- `IPHONEOS_DEPLOYMENT_TARGET`: 支持的最低iOS版本

### Debug.xcconfig (开发环境)
- `DEBUG_INFORMATION_FORMAT`: 调试信息格式
- `ENABLE_NS_ASSERTIONS`: 是否启用NSAssert断言
- `ENABLE_TESTABILITY`: 是否启用测试能力
- `SWIFT_OPTIMIZATION_LEVEL`: Swift优化级别
- `GCC_OPTIMIZATION_LEVEL`: GCC优化级别
- `GCC_PREPROCESSOR_DEFINITIONS`: 预处理器宏定义
- `API_BASE_URL`: 开发环境API地址
- `PRODUCT_BUNDLE_IDENTIFIER`: 开发环境Bundle ID

### Test.xcconfig (测试环境)
- `DEBUG_INFORMATION_FORMAT`: 调试信息格式
- `ENABLE_NS_ASSERTIONS`: 是否启用NSAssert断言
- `ENABLE_TESTABILITY`: 是否启用测试能力
- `SWIFT_OPTIMIZATION_LEVEL`: Swift优化级别
- `GCC_OPTIMIZATION_LEVEL`: GCC优化级别
- `GCC_PREPROCESSOR_DEFINITIONS`: 预处理器宏定义
- `API_BASE_URL`: 测试环境API地址
- `PRODUCT_BUNDLE_IDENTIFIER`: 测试环境Bundle ID（带.test后缀）

### Release.xcconfig
- `DEBUG_INFORMATION_FORMAT`: 调试信息格式
- `ENABLE_NS_ASSERTIONS`: 是否启用NSAssert断言
- `ENABLE_TESTABILITY`: 是否启用测试能力
- `SWIFT_OPTIMIZATION_LEVEL`: Swift优化级别
- `GCC_OPTIMIZATION_LEVEL`: GCC优化级别
- `GCC_PREPROCESSOR_DEFINITIONS`: 预处理器宏定义
- `API_BASE_URL`: 生产环境API地址
- `PRODUCT_BUNDLE_IDENTIFIER`: 生产环境Bundle ID

## 注意事项

1. 确保将xcconfig文件添加到版本控制系统中
2. 不要在xcconfig文件中存储敏感信息（如API密钥）
3. 对于敏感信息，建议使用环境变量或密钥管理工具
4. 定期更新配置文件以反映最新的环境设置
