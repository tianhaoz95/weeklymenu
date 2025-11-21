// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '每周菜单';

  @override
  String get loginButton => '登录';

  @override
  String get signupButton => '注册';

  @override
  String get emailHint => '电子邮件';

  @override
  String get passwordHint => '密码';

  @override
  String get confirmPasswordHint => '确认密码';

  @override
  String get forgotPasswordButton => '忘记密码?';

  @override
  String get sendResetEmailButton => '发送重置邮件';

  @override
  String get weeklyMenuTitle => '每周菜单';

  @override
  String get cookbookTitle => '食谱';

  @override
  String get settingsTitle => '设置';

  @override
  String get noAccountYet => '还没有账号?';

  @override
  String passwordResetEmailSent(String email) {
    return '密码重置邮件已发送至$email';
  }

  @override
  String get errorGeneratingMenu => '生成每周菜单错误';

  @override
  String get noWeeklyMenuGenerated => '尚未生成每周菜单。点击刷新图标生成！';

  @override
  String get userNotLoggedInError => '用户未登录。';

  @override
  String get errorLoadingRecipes => '加载食谱出错。';

  @override
  String get recipeAddedMessage => '食谱已添加！';

  @override
  String get recipeUpdatedMessage => '食谱已更新！';

  @override
  String get addRecipeTitle => '添加新食谱';

  @override
  String get recipeNameLabel => '食谱名称';

  @override
  String get ingredientsLabel => '配料（逗号分隔）';

  @override
  String get instructionsLabel => '说明（每行一个）';

  @override
  String get cuisinesLabel => '菜系：';

  @override
  String get categoriesLabel => '类别：';

  @override
  String get starRatingLabel => '星级评分：';

  @override
  String get deleteAccountButton => '删除账户';

  @override
  String get settingsScreenTitle => '设置';

  @override
  String get welcomeMessage => '欢迎';

  @override
  String get selectMealsForMenu => '选择每周菜单的餐点：';

  @override
  String get selectWeekdaysForMenu => '选择每周菜单的日期：';

  @override
  String get logoutButton => '退出';

  @override
  String get cookbookScreenTitle => '食谱';

  @override
  String deleteRecipeConfirmation(String recipeName) {
    return '您确定要删除“$recipeName”吗？';
  }

  @override
  String get noRecipesAdded => '尚未添加食谱。点击 + 添加您的第一个食谱！';

  @override
  String get shoppingListScreenTitle => '购物清单';

  @override
  String get noItemsInShoppingList => '购物清单中没有商品。';

  @override
  String get saveButton => '保存';

  @override
  String get cancelButton => '取消';

  @override
  String get addButton => '添加';

  @override
  String get recipeNameCannotBeEmpty => '食谱名称不能为空。';

  @override
  String get confirmAccountDeletionTitle => '确认删除账户';

  @override
  String get confirmAccountDeletionContent => '您确定要删除您的账户吗？此操作无法撤消。';

  @override
  String get deleteButton => '删除';

  @override
  String get reauthenticateTitle => '重新认证';

  @override
  String get confirmButton => '确认';

  @override
  String get passwordRequiredToDeleteAccount => '删除账户需要密码。';

  @override
  String get editRecipeTitle => '编辑食谱';

  @override
  String get error => '错误';

  @override
  String get guest => '访客';

  @override
  String get breakfast => '早餐';

  @override
  String get lunch => '午餐';

  @override
  String get dinner => '晚餐';

  @override
  String get snack => '零食';

  @override
  String get monday => '周一';

  @override
  String get tuesday => '周二';

  @override
  String get wednesday => '周三';

  @override
  String get thursday => '周四';

  @override
  String get friday => '周五';

  @override
  String get saturday => '周六';

  @override
  String get sunday => '周日';

  @override
  String get ratingLabel => '评分';

  @override
  String get deletedMessage => '已删除。';

  @override
  String get appetizer => '开胃菜';

  @override
  String get main_course => '主菜';

  @override
  String get dessert => '甜点';

  @override
  String get american => '美式';

  @override
  String get italian => '意式';

  @override
  String get mexican => '墨西哥式';

  @override
  String get indian => '印度式';

  @override
  String get chinese => '中式';

  @override
  String get japanese => '日式';

  @override
  String get mediterranean => '地中海式';
}
