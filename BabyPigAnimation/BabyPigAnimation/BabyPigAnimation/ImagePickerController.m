//
//  ImagePickerController.m
//  BabyPigAnimation
//
//  Created by hanbo on 2018/10/17.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "ImagePickerController.h"
#import <TZImagePickerController/TZImagePickerController.h>

@interface ImagePickerController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@end

@implementation ImagePickerController

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
//        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        
        _imagePickerVc.navigationBar.barTintColor = [UIColor redColor];
        
        _imagePickerVc.navigationBar.tintColor = [UIColor yellowColor];
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 50);
    button.center = self.view.center;
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"相机" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 调用相机
- (void)handleAction:(UIButton *)sender {
    NSString *takePhotoTitle = @"拍照";
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    [alertVc addAction:takePhotoAction];
    UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushTZImagePickerController];
    }];
    [alertVc addAction:imagePickerAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:cancelAction];
//    UIPopoverPresentationController *popover = alertVc.popoverPresentationController;
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    if (popover) {
//        popover.sourceView = cell;
//        popover.sourceRect = cell.bounds;
//        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    }
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)pushTZImagePickerController {

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
//
//    @property (nonatomic, strong) UIImage *takePictureImage;
//    @property (nonatomic, strong) UIImage *photoSelImage;
//    @property (nonatomic, strong) UIImage *photoDefImage;
//    @property (nonatomic, strong) UIImage *photoOriginSelImage;
//    @property (nonatomic, strong) UIImage *photoOriginDefImage;
//    @property (nonatomic, strong) UIImage *photoPreviewOriginDefImage;
//    @property (nonatomic, strong) UIImage *photoNumberIconImage;
//
//#pragma mark -
//    /// Appearance / 外观颜色 + 按钮文字
//    @property (nonatomic, strong) UIColor *oKButtonTitleColorNormal;
//    @property (nonatomic, strong) UIColor *oKButtonTitleColorDisabled;
//    @property (nonatomic, strong) UIColor *naviBgColor;
//    @property (nonatomic, strong) UIColor *naviTitleColor;
//    @property (nonatomic, strong) UIFont *naviTitleFont;
//    @property (nonatomic, strong) UIColor *barItemTextColor;
//    @property (nonatomic, strong) UIFont *barItemTextFont;
//
//    @property (nonatomic, copy) NSString *doneBtnTitleStr;
//    @property (nonatomic, copy) NSString *cancelBtnTitleStr;
//    @property (nonatomic, copy) NSString *previewBtnTitleStr;
//    @property (nonatomic, copy) NSString *fullImageBtnTitleStr;
//    @property (nonatomic, copy) NSString *settingBtnTitleStr;
//    @property (nonatomic, copy) NSString *processHintStr;
//
//    imagePickerVc.navigationItem.title = @"相册";
    
    imagePickerVc.title = @"选择相册";
//    imagePickerVc.doneBtnTitleStr = @"完成";
//    imagePickerVc.settingBtnTitleStr = @"设置相册";
//    imagePickerVc.processHintStr = @"123124";
//    imagePickerVc.previewBtnTitleStr = @"下一步";
     imagePickerVc.navigationBar.translucent = NO;
     imagePickerVc.photoWidth = 1000;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
     imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
     imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
     imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
     imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];

    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        NSLog(@"选择好图片");
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
//    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//    _selectedAssets = [NSMutableArray arrayWithArray:assets];
//    _isSelectOriginalPhoto = isSelectOriginalPhoto;
//    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
 
    // 1.打印图片名字
//    [self printAssetsName:assets];
    // 2.图片位置信息
    for (PHAsset *phAsset in assets) {
        NSLog(@"location:%@",phAsset.location);
        
        [[TZImageManager manager] getOriginalPhotoDataWithAsset:phAsset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
            
            NSLog(@"--%@--", info);
            
        }];
        
    }
    
    /*
     // 3. 获取原图的示例，这样一次性获取很可能会导致内存飙升，建议获取1-2张，消费和释放掉，再获取剩下的
     __block NSMutableArray *originalPhotos = [NSMutableArray array];
     __block NSInteger finishCount = 0;
     for (NSInteger i = 0; i < assets.count; i++) {
     [originalPhotos addObject:@1];
     }
     for (NSInteger i = 0; i < assets.count; i++) {
     PHAsset *asset = assets[i];
     [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info) {
     finishCount += 1;
     [originalPhotos replaceObjectAtIndex:i withObject:photo];
     if (finishCount >= assets.count) {
     NSLog(@"All finished.");
     }
     }];
     }
     */
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//    tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
    [tzImagePickerVc showProgressHUD];
    
    
     UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if ([type isEqualToString:@"public.image"]) {
       
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
