# LSXTransition
转场动画
转场动画用法：包含如下头文件LSXBaseAnimation.h 1.设置设置导航控制器代理<UINavigationControllerDelegate>：
self.delegate = self;
在自定义导航控制器内部实现如下转场动画代理方法：
// > 添加用户交互
- (nullable id
<UIViewControllerInteractiveTransitioning>)navigationController:(UINavig
ationController *)navigationController

interactionControllerForAnimationController:(LSXBaseAnimation *)
animationControlle
{
return animationControlle.interactivePopTransition;
}

// > 自定义转场动画
- (nullable id
<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigati
onController *)navigationController

animationControllerForOperation:(UINavigationControllerOperation)operati
on

fromViewController:(UIViewController *)fromVC

toViewController:(UIViewController *)toVC
{
if (fromVC.interactivePopTransition)
{

LSXBaseAnimation *animation = [[LSXBaseAnimation alloc]
initWithType:operation Duration:0.6 animateType:LSXAnimateTypeKuGou];

animation.interactivePopTransition =
fromVC.interactivePopTransition;
return animation; //手势
}
else
{

LSXBaseAnimation *animation = [[LSXBaseAnimation alloc]
initWithType:operation Duration:0.6 animateType:LSXAnimateTypeKuGou];

return animation;//非手势
}

}
3.在需要恢复导航控制器等控制器中定制返回恢复的按钮：
@weakify(self);
self.block = ^{
@strongify(self);

UIButton *leftBtn = [UIButton
buttonWithType:UIButtonTypeCustom];
[leftBtn setBackgroundImage:[UIImage
imageNamed:@"backbutton_icon3"] forState:UIControlStateNormal];
leftBtn.frame = CGRectMake(0, 0, 30, 30);
[leftBtn addTarget:self action:@selector(backBtnClick)
forControlEvents:UIControlEventTouchUpInside];

self.navigationItem.leftBarButtonItem = [[UIBarButtonItem
alloc]initWithCustomView:leftBtn];
};
