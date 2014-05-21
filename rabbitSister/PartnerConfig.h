//
//  PartnerConfig.h
//  MQPDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//  ※为安全起见，公私钥的设置须从商户的服务端中获取，不要在客户端中写死。※
//  
//  提示：如何获取安全校验码和合作身份者ID
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myOrder.htm)
//  3.点击“查询合作者身份(PID)”、“查询安全校验码(Key)”、商户公私钥
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

// 合作身份者ID，以2088开头由16位纯数字组成的字符串
#define PartnerID @"2088111473970070"
// 商户签约支付宝账号
#define SellerID  @"webmaster@tojie.com"

// 商户的私钥（MD5）
#define MD5_KEY @"uuyr2597s0aetobky1ntx8x2osk10102"

// 商户私钥（RSA）
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMQ7AVkiai61f9fAsPuNcn3OmRPmjWma+QAHLZL7kiCG6vAqUivZjFx1bg1flM0XbWSYlm7W149FXo1VD0Yw7Ss0izUeoH7+VJMwvUHThks15e4P5+mlnUYw04X2M7ie09FUoCkOT5gH/G5Sj7IgSCx++SOfQQrxJ9UUzskVBpG/AgMBAAECgYBkZTPpYJwmzaFcxy9FZDbheuQCtIBBOZKPmxyMCL3Yem6U9XIZETKo00O8/9vnmkbTouXES5L5sCoR8SThaoLMI5FVRIoEbvdfmWbBO13Is/eCyyGNpDNj6TMANFXx8TZjaNIE4nLDh3uFRxVpBMZgoPkYYXqZspga2n1eLqAUYQJBAPfnDVO6ufHQl49ebRtImB2PUrK2cXViW3HMYjzoOUztGlIAnW4WVW0lw9Q5kM/Js340dnffIeyEAm+sANQyNCkCQQDKo9/LwhOW/Au/3Jq1WOUPY3VWSeFS1tJmxrCYAWAF5n8RParlI7MBNxrcMgAxTV6DwXGwPTkRsnx1CLI0G5OnAkEAqwgmorC+Hv55wjk0b1FrWWGLfa7vojvkuSN4V2skNVWUBiVUeCJCd9ZJQD8jEKipBJZvcY5pWkNNZvw1ajDk2QJAdskDOj0FIL+U354grmdytseVk8RxKg81fPvBrwk3UZ4hJGki0XlQyEiWHTfONxhkbBWsYCQzXPVk0XIMjFESBwJBAO9ZDkfqRi2kXEIdZca11GQi7OLU1UbSbdCEwQXw10EExqLYI+nMu51jEzMAXdYVmOBHbtP8fPr8KL69Z1qPHns="


// 支付宝公钥，无需修改该值
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
