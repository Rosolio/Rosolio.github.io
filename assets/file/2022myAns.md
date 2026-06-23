# 2022

> Largely Generatd By Doubao.
> CORRECTNESS NOT GUARANTEED.

## 一.简答题

### 1. 什么是软件工程

- 应用系统的、规范的、可量化的来开发、运行和维护软件，即将工程应用到软件

### 2. 配置管理中变更控制的过程

- 变更请求 - 影响分析 - 决策评审 - 通知相关方 - 跟踪闭环

### 3. 迭代增量模型和演化模型的差异及优缺点

- 迭代增量模型在项目开始时需要商定项目的范围和前景，因此适用于大规模、成熟稳定的领域
- 演化模型不需要，适用于不稳定领域的大规模软件系统
- 迭代增量模型优点：
  - 迭代开发适应实际情况
  - 并行开发缩短开发时间
  - 渐进交付加强用户反馈
- 缺点：
  - 加入构件不能破环原有系统，要求具有开放式的体系结构
  - 难以在项目早期商定好项目的前景和范围，不适用于不稳定领域
- 演化模型优点：类似迭代增量模型
- 缺点：
  - 无法在项目早期确定项目的前景范围，项目的整体计划难以把握
  - 体系结构难做，体系结构几乎确定会发生变化
  - 容易退化为构建修复模式

## 二、需求获取

### 1. 写出校园卡自助系统的用例

- 校园卡余额查询
- 校园卡充值（银行卡）
- 校园卡消费明细查询
- 校园卡充值记录查询

### 2. 针对充值功能，写出业务需求、用户需求、系统级需求

- 业务需求

1. 支持师生线上自助充值，减轻线下卡务窗口工作量；
2. 充值资金同步财务系统，账目可追溯、资金合规安全；
3. 每日00:10-23:00开放充值，保障全天候服务；

- 用户需求

1. 在APP完成校园卡充值；
2. 使用已绑定银行卡支付；
3. 充值后实时展示新余额与充值金额；
4. 可按时间筛选、查询历史充值记录；

- 系统级需求

1. 校验充值金额合规性；
2. 调用银行接口发起扣款，接收并校验支付回调；
3. 支付成功实时更新校园卡余额，生成完整充值流水；
4. 提供分页、按时间筛选的充值记录查询接口。

### 3. 系统需要提供API供其他管理系统调用，属于什么需求？还有什么对外接口？

- 对外接口。
- 统一身份认证系统接口：用户登录身份验证/银行系统接口：充值扣款、退款、交易结果查询

## 三、需求分析

> 学校师生可以进行充值、查询余额、绑定银行卡、查询明细等操作。

### 1. 分析名词，确定概念类。

- User（用户）：代表在校师生
- CampusCard（校园卡）：用户持有的校园卡
- BankCard（银行卡）：用户绑定的用于充值的银行卡
- Transaction（交易记录）：所有交易的抽象类
- RechargeRecord（充值记录）：继承自 Transaction
- ConsumeRecord（消费记录）：继承自 Transaction
- Password（在线支付密码）

### 2. 辨识概念类之间的联系（包括依赖、关联、聚合、组合、继承）。

- 关联关系：
  - User 与 CampusCard：一对一关联（一个用户拥有一张校园卡）
  - User 与 BankCard：一对多关联（一个用户可以绑定多张银行卡）
  - CampusCard 与 Transaction：一对多关联（一张校园卡有多条交易记录）
- 组合关系：
  - CampusCard 与 Password
- 继承关系：
  - RechargeRecord 继承自 Transaction
  - ConsumeRecord 继承自 Transaction

### 3. 识别重要属性，画出概念类图。

![alt text](/assets/img/secii/7cfea471550ba843dbac549b0465180d_720.png)

## 四、体系结构

### 1. 画出整个校园卡自助系统的物理包图。分为客户端和服务器端，体现分层概念，包含所有模块。html三包和展示层在客户端，逻辑层和数据层在服务器端，使用http通信和rest api。

![alt text](/assets/img/secii/b670cee8da4f36746925be275eed5f0d_720.png)

### 2. 针对充值服务（充值、查询充值记录）写出展示层和逻辑层间接口（代码）以及逻辑层和数据层间接口。注意写出接口所在包名。

> 豆包生成。正确性概不负责。

- 展示层和逻辑层间接口
  ```java
  public interface IRechargeService {
    RechargeResp submitRecharge(String userId, String bankCardId, BigDecimal amount);
  }

  public interface IRecordService {
    PageDTO<RechargeRecord> queryRechargeRecord(String userId, String startTime, String endTime, int pageNum, int pageSize);
  }
  ```
- 逻辑层和数据层间接口
  ```java
   public interface IRechargeDAO {
    CampusCard getCardByUserId(String userId);
    int addBalance(String cardId, BigDecimal amount);
  }

  public interface IRecordDAO {
    int insertRechargeRecord(RechargeRecord record);
    List<RechargeRecord> selectByCardId(String cardId, Date start, Date end, RowBounds page);
    int countRecord(String cardId, Date start, Date end);
  }
  ```

## 五、用户在充值时有不同的优惠券，同时可以用不同的充值方式（支付宝、微信等）。

### 1. 画出User,Card,多种Coupon,ThirdPayment,PaymentRecord类图。

![alt text](/assets/img/secii/c4cae9967c05a580ed1c2d59f9e45d7e_720.png)

### 2. 当添加新的优惠券（有数值折扣、比例折扣）时，系统如何实现变更。

- Coupon是个抽象类，添加新优惠券只需要增加Coupon的子类。

### 3. 画出充值时对象交互的顺序图。

```text
UI(Presentation)       Service           RechargeDAO   ThirdPayment       RecordDAO
      |                   |                   |              |               |
1.发起充值请求(userId,金额,支付方式,优惠券)
      |------------------>|                   |              |               |
      |                   | 2.根据userId查询校园卡
      |                   |------------------>|              |               |
      |                   | 2.1 返回校园卡信息
      |                   |<------------------|              |               |
      |                   |                   |              |               |
      |                   | 3.计算优惠券抵扣，得到实付金额
      |                   |                   |              |               |
      |                   | 4.调用第三方支付扣款(实付金额)
      |                   |--------------------------------->|               |
      |                   | 4.1 返回支付成功结果
      |                   |<---------------------------------|               |
      |                   |                   |              |               |
      |                   | 5.更新校园卡余额(cardId,充值金额)
      |                   |------------------>|              |               |
      |                   | 5.1 余额更新完成
      |                   |<------------------|              |               |
      |                   |                   |              |               |
      |                   | 6.新增充值流水记录
      |                   |------------------------------------------------->|
      |                   | 6.1 流水保存成功
      |                   |<-------------------------------------------------|
      | 7.返回充值结果（新余额、订单号）            |              |               |
      |<------------------|                   |              |               |
```

## 六、（模块化与信息隐藏）

### 1. 用户包持有优惠券包中的优惠券，优惠券包又查询用户包信息以发放优惠券。违反了什么包原则？如何修改？画出修改后的包图和类图。

- 违反的包原则：违反了无环依赖原则 (ADP)，即包之间的依赖关系应该是无环的。用户包依赖优惠券包，优惠券包又依赖用户包，形成了循环依赖，导致两个包无法独立编译和测试。
- 修改方案：
  引入一个中间层common包，将用户和优惠券的公共接口和数据结构放在其中
  用户包和优惠券包都依赖common包，而不直接依赖对方
  将发放优惠券的逻辑移到用户包中，优惠券包只负责定义优惠券的类型和计算逻辑
  修改后的包图：

```plaintext
+----------------+       +----------------+
|   用户包       |       |   优惠券包      |
+----------------+       +----------------+
| User           |       | Coupon         |
| UserService    |       | CouponService  |
+----------------+       +----------------+
        |                    |
        |                    |
        +--------+-----------+
                 |
          +----------------+
          |   common包     |
          +----------------+
          | UserDTO        |
          | CouponDTO      |
          +----------------+
```

### 2.

```c
void issueCoupon(List<User> users) {
  for (user:users) {
    addCoupon(user, user.getType());
  }
}

void addCoupon(User u, int type) {
  switch (type) {
    case STUDENT:
      u.addCoupon(new FiveYuanCoupon());
      break;
    case TEACHER:
      u.addCoupon(new TenYuanCoupon());
      break;
            ....
  }
}
```

#### (1)以上代码中issueCoupon和addCoupon是哪种耦合？可以接受吗？如何修改？

#### (2)addCoupon中多次调用user的addCoupon，如何优化？

- (1) 耦合类型及可接受性
  issueCoupon和addCoupon之间是**控制耦合**，因为issueCoupon通过type参数控制addCoupon内部的分支逻辑。这种耦合是不可接受的，因为：

1. 当添加新的用户类型时，需要修改addCoupon方法的switch语句，违反了开闭原则
2. type参数的含义不明确，容易出错
3. 两个方法之间的依赖关系过强

- 修改方法：采用多态和工厂模式重构代码

```java
// 定义用户接口
public interface User {
  Coupon createCoupon();
}

// 学生用户实现
public class StudentUser implements User {
  @Override
  public Coupon createCoupon() {
    return new FiveYuanCoupon();
  }
}

// 教师用户实现
public class TeacherUser implements User {
  @Override
  public Coupon createCoupon() {
    return new TenYuanCoupon();
  }
}

// 重构后的方法
void issueCoupon(List<User> users) {
  for (User user : users) {
    user.addCoupon(user.createCoupon());
  }
}
```

- (2) 多次调用 user.addCoupon 的优化
  可以采用批量添加的方式优化，减少方法调用次数：

```java
// 在User类中添加批量添加优惠券的方法
public class User {
  private List<Coupon> coupons = new ArrayList<>();

  public void addCoupons(List<Coupon> coupons) {
    this.coupons.addAll(coupons);
  }
}

// 重构后的方法
void issueCoupon(List<User> users) {
  for (User user : users) {
    List<Coupon> coupons = Collections.singletonList(user.createCoupon());
    user.addCoupons(coupons);
  }
}
```

## 七、（设计模式）

### 1. 以下类图违反了什么类的设计原则？如何优化

- 违反的原则：违反了**接口隔离原则 (ISP)**
  ，即客户端不应该依赖它不需要的接口。Payment接口包含了electricPayment、waterPayment和dinnerPayment三个方法，但每个Transaction实现类只需要实现其中一个方法，导致实现类必须提供不需要的方法的空实现。
- 优化方案：将Payment接口拆分为三个独立的接口，每个接口只包含一个方法：

```java
public interface ElectricPayment {
  void electricPayment();
}

public interface WaterPayment {
  void waterPayment();
}

public interface DinnerPayment {
  void dinnerPayment();
}

public class ElectricTransaction implements ElectricPayment {
  @Override
  public void electricPayment() {
    // 实现电费支付逻辑
  }
}

public class WaterTransaction implements WaterPayment {
  @Override
  public void waterPayment() {
    // 实现水费支付逻辑
  }
}

public class DinnerTransaction implements DinnerPayment {
  @Override
  public void dinnerPayment() {
    // 实现餐费支付逻辑
  }
}
```

### 2. 用户有微信支付、支付宝支付，预计未来还会有更多的支付方式。使用哪种设计模式可以方便实现？这种设计模式有什么好处？使用了哪些类设计原则？画出这种设计模式的类图描述。

- 适用设计模式：策略模式
- 好处：

1. 易于扩展新的支付方式，只需添加新的策略类即可，无需修改现有代码
2. 避免了使用大量的if-else或switch语句
3. 提高了代码的可维护性和可测试性
4. 在运行时动态切换支付方式

- 使用的类设计原则：

1. 开闭原则：对扩展开放，对修改关闭
2. 单一职责原则：每个支付方式类只负责自己的支付逻辑
3. 依赖倒置原则：依赖抽象，不依赖具体实现
4. 策略模式类图：

```text
+------------------------------------+
|        PaymentContext              |
+------------------------------------+
| - paymentStrategy: PaymentStrategy |
+------------------------------------+
| + setPaymentStrategy()             |
| + pay()                            |
+------------------------------------+
                |
                |
                v
+--------------------------------+
|        PaymentStrategy         | <<interface>>
+--------------------------------+
| + pay(amount: BigDecimal)      |
+--------------------------------+
                  ^
                  |
          +-------+-------+
          |               |
+----------------+ +----------------+
| AlipayStrategy | | WechatStrategy |
+----------------+ +----------------+
| + pay()        | | + pay()        |
+----------------+ +----------------+
```

## 八、（软件构造）从软件构造的角度分析以下代码的优缺点。

```java
void doPost(HttpRequest rsq, HttpResponse resp) throws ServletException,
  IOException {
  String old = rsq.getParameter("old");
  String new1 = rsq.getParameter("new1");
  String new2 = rsq.getParameter("new2");
  String username = rsq.getParameter("username");
  boolean flag = false;
  PrintWriter writer = resp.getWriter();
  if (new1.indexOf(new2) != -1 && old.indexOf(new1) == -1 && new2.indexOf(new1) != -1 && new1.
    indexOf(old) == -1) {
    if (dao.loginUser(username, old)) {
      dao.rePassword(new1);
      writer.print("yes");
    } else {
      writer.print("no");
    }
  } else {
    writer.print("no");
  }
  writer.flush();
  writer.close();
}
```

- 优点

1. 实现了基本的密码修改功能，逻辑清晰
2. 代码量少，结构简单，易于理解

- 缺点

1. 参数校验缺失：没有对输入参数进行非空校验和合法性校验，可能导致空指针异常
2. 代码可读性差：变量命名不规范（new1、new2），复杂的条件表达式没有注释说明
3. 异常处理不完善：没有捕获和处理 DAO 层可能抛出的异常，可能导致系统崩溃
4. 资源泄漏风险：PrintWriter的关闭操作没有放在finally块中，可能导致资源泄漏
5. 耦合度高：直接在 Servlet 中调用 DAO 层，没有分层设计，不利于维护和扩展
6. 逻辑错误：密码修改的条件表达式逻辑错误，无法正确验证两次输入的新密码是否一致
7. SQL 注入风险：如果 DAO 层没有使用预编译语句，可能存在 SQL 注入漏洞
8. 没有事务控制：密码修改操作没有事务支持，可能导致数据不一致

## 九、（人机交互）从人机交互的角度分析校园卡自助系统，说出好的地方；说出不好的地方并给出建议（至少三点）

- 好的地方

1. 功能集中：将校园卡相关的所有功能集中在一个页面，方便用户查找和使用
2. 快捷充值：提供了 10 元、20 元、50 元、100 元、200 元等固定金额的快捷充值按钮，减少用户输入
3. 记录分类清晰：将交易记录分为消费记录和充值记录，支持按时间范围筛选，方便用户查询
4. 信息展示直观：首页直接显示校园卡余额，用户可以一目了然地看到自己的卡内余额

- 不好的地方及建议

1. 充值时间限制：每天 00:00-00:10 不能充值，给深夜需要充值的用户带来不便
   建议：优化系统维护时间，将维护时间调整到凌晨 2:00-3:00 用户量最少的时段，或者实现不间断服务
2. 支付方式单一：只支持银行卡充值，不支持微信、支付宝等主流支付方式
   建议：增加微信、支付宝支付方式，满足不同用户的支付习惯
3. 充值失败提示不详细：当充值失败时，只提示 "充值失败"，没有说明具体原因
   建议：提供详细的失败原因提示，如 "银行卡余额不足"、"银行卡已过期"、"网络异常" 等，并给出相应的解决方法
4. 密码修改流程复杂：需要输入旧密码、新密码、确认新密码，但没有密码强度提示
   建议：增加密码强度提示，引导用户设置安全的密码；同时简化密码修改流程，支持短信验证码重置密码

## 十.（软件测试）条件覆盖是指保证程序中每个判断的每个结果都至少满足一次。对上文的doPost方法：

### 1.计算圈复杂度

- 圈复杂度：第一层if(A && B && C && D)，4个判定节点，第二层if，1个判定节点。圈复杂度 5+1=6.

### 2.设计最小的100%条件覆盖的测试用例集。只需要提供old、new1、new2的值，username可不考虑。（注意短路判断特性）

| 用例编号 | old 值         | new1 值     | new2 值     | 子条件执行结果                  | 覆盖的子条件取值                |
|------|---------------|------------|------------|--------------------------|-------------------------|
| 1    | "a"           | "abc"      | "d"        | A=F（短路 B/C/D）            | A=F                     |
| 2    | "xabcx"       | "abc"      | "ab"       | A=T, B=F（短路 C/D）         | A=T, B=F                |
| 3    | "old"         | "abc"      | "ab"       | A=T, B=T, C=F（短路 D）      | A=T, B=T, C=F           |
| 4    | "old"         | "abcold"   | "abcold"   | A=T, B=T, C=T, D=F（短路 E） | A=T, B=T, C=T, D=F      |
| 5    | "correct_old" | "new_pass" | "new_pass" | A=T, B=T, C=T, D=T, E=T  | A=T, B=T, C=T, D=T, E=T |
| 6    | "wrong_old"   | "new_pass" | "new_pass" | A=T, B=T, C=T, D=T, E=F  | A=T, B=T, C=T, D=T, E=F |
