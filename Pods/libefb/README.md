# libefb

## 迁移说明

使用xcode 5.1 iOS SDK 7.1编译，以及[CocoaPods](http://cocoapods.org)来进行包管理

在项目文件夹下增加文件 _Podfile_

    # Podfile

    platform :ios, '7.0'
    inhibit_all_warnings!

    pod 'libefb', :git => 'http://192.168.243.230:8080/git/efb2/libefb.git'，:branch => 'dev'

如果是第一次安装CocoaPods，在命令行运行命令

    pod install

这一步依赖网络情况，时间会比较长，之后如果Podfile发生变化，就可以使用下面的形式更新依赖

    pod install --no-repo-update

等待命令完成，如果出现警告，请确认按照警告修改项目设置。

当需要更新框架或者其他模块版本时，使用`update`命令

    pod update

该命令将会根据`Podfile`的定义，将依赖模块升级到允许使用的最新版本，并安装到工程中。

使用xcode打开项目目录下的xxx.xcworkspace文件（xxx为项目名称）

* 把之前的efbcore子项目删除

* 全文搜索“#import <efbcore/” 前缀，并改为“#import <”

提交修改到git之前，修改项目目录下的.gitignore文件，使之包含如下内容

    build/
    .DS_Store
    *.xcworkspace
    xcuserdata
    *.mode1v3
    *.pbxuser
    *.ipa
    .svn/
    #release-package.sh
    Pods/

## 迁移所需要的代码修改

1 修改`main.c`文件，调用`EFBApplicationMain`入口函数。

    #import <DefaultAppDelegate.h>
    #import "MyAppDelegate.h"

    int main(int argc, char *argv[])
    {
        @autoreleasepool {
            /* 如果不需要派生自己的DefaultAppDelegate子类，则可以直接使用
                int EFBDefaultApplicationMain(int argc, char * argv[])
              入口函数 */
            return EFBApplicationMain(argc, argv, nil, NSStringFromClass([MyAppDelegate class]));
        }
    }

2、去掉所有对`contentView`的引用

3、EFBAccessoryBar的使用

    - (void)viewDidLoad
    {
        [super viewDidLoad];

        EFBAccessoryBarItem * item =
        [[EFBAccessoryBarItem alloc] initWithStyleClass:@"accessory-lock"
                                                target:self
                                                action:@selector(onLockTapped:)];

        self.accessoryItems = @[item];

        /* Any other initialization */

        /* tell EFBBaseViewController to finish loading views. */
        [self didFinishLoadView];
    }

`styleClass`用于在样式表中定义按钮图片，可以使用`:selected`选择符定义选中状态下的按钮样式。
如果需要对工具条做任何修改，则直接对self.accessoryBar属性重新复制即可

4、添加`default.css`文件到工程中，在其中编写界面需要的样式表。在开始写自己的样式之前，
需要引用基本样式表文件`efb.css`

    /* default.css */

    @import url("efb.css")

    button.myClass {
        background-image: url("img-btn.png");
    }

5、功能模块定义文件`app.list`中的`EFBTabIconPrefix`值将会设置为功能对应按钮的CSS class值。所以，需要在`default.css`中设置对应的图片和样式。例如，在`app.list`中有如下设置：

    ........
    EFBViewControllerTitle    "基本信息"
    EFBTabIconPrefix          "app-information"
    EFBViewControllerClass    "DemoViewController"
    ........

那么就需要在`default.css`中做如下设置

    /* default.css */

    ...

    .app-information {
        background-image: url("img-app-tasks@2x.png");
    }

    ...

目前框架使用[PixateFreeStyle](http://pixate.github.io/pixate-freestyle-ios/)来加载
CSS样式表，具体说明参见[这里](http://pixate.github.io/pixate-freestyle-ios/)

## 安装CocoaPods

如果之前没有安装过CocoaPods，则需要先进行安装。打开命令行窗口，执行下面的命令

    gem install cocoapods


## Author

xuyang, xuy@adcc.com.cn

## License

libefb is available under the MIT license. See the LICENSE file for more info.
