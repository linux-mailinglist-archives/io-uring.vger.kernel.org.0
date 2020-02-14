Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F8215D3CE
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 09:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgBNI3i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 03:29:38 -0500
Received: from mail-bjbon0132.outbound.protection.partner.outlook.cn ([42.159.36.132]:43031
        "EHLO CN01-BJB-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725897AbgBNI3i (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 14 Feb 2020 03:29:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sx0rzITF3MBFyQAVOoZ2bkingYbNs1QETiLizeg5NM0X4uyO+w398Bd+vbi485AjvCKWTqwcz9TWFtz5xVz1hbe2iavA2FmsnrWTvgXGxggbRTXOEG5IJUUU4N2F2il1Ic5YgJbmkp5rxoP5geM8S0sxs+ifcvUu1817WA6bHYaxTaMMEz2/bYFlkhZa282TeXVJ8/4Q3LV09J8BT6tAR6Y3mmYx5jqXps0fOoELR87UYhlq7CIMEyuA7J8CWF8e9B7DtQ7Ogl7gNQKVAKRAoL5VY3WILWVTBCV7ZB1DUdIH+wbCZ/Dq/XFa04jvAPxSDRMLCxSLXxnx4es8CFXXXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6FCtLEbex9ZtgX6aHZOMg7UPszY08JNfbsxDV2kW/8=;
 b=Wp6MPAeJ+xOJAt5Ectox5e1iG/ieC1fjjCHNfyLW+AY5tLyfPLvF9XGP8l9gr+ZII1u7RG1tHcqpWGoPfd+/933KgcZovlYj5ryHmPoEhr4XeJFE3wd1HR/dkJSp9rXUVHjLaUnhsB29PvtEr5+laMKDbTMd8WdfI9qtH+yqhQh2IliyV3W5/e6JCwrkKKuMbaGmn4HMuuysdiFpuQK+D7VXUh3dv8lcxW96MYriAOKAXYva5fL6y83rPk1m6BqzmmAO4XCZHTQU6fhXE/H8dMIBY99S2k91TYcicvWfeJx02xPyvb5S3IFovRKMA659oJpGlhDEe4JJhYLtw6kn1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6FCtLEbex9ZtgX6aHZOMg7UPszY08JNfbsxDV2kW/8=;
 b=R/nbVhxPrvmlaT8uA1CFU3McQKWuFFKbpt2t17dCntpl0wnJDOvDBLYRDbTmHZNAsqOUjoQ/gdJhKeQOlPx1wbDort7lO2Sf0ddD3TQ0dOlLtAzbC6ZnkbII+aRaz877P/SrO5MkYVrhQ3VSkr+6p4ohnPwktGWEb5L4M/vvR1k=
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn (10.43.108.138)
 by SH0PR01MB0601.CHNPR01.prod.partner.outlook.cn (10.43.108.19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.23; Fri, 14 Feb
 2020 08:29:25 +0000
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138])
 by SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138]) with mapi
 id 15.20.2729.021; Fri, 14 Feb 2020 08:29:25 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     io-uring <io-uring@vger.kernel.org>
Subject: [FEATURE REQUEST] Specify a sqe won't generate a cqe
Thread-Topic: [FEATURE REQUEST] Specify a sqe won't generate a cqe
Thread-Index: AQHV4xDdFxABP4gMcUC8VSNKsMTjEA==
Date:   Fri, 14 Feb 2020 08:29:24 +0000
Message-ID: <9A41C624-3D2C-40BC-A910-59CBDC5BB76E@eoitek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=carter.li@eoitek.com; 
x-originating-ip: [183.200.9.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1a9a05d-033a-4978-aafc-08d7b127ffde
x-ms-traffictypediagnostic: SH0PR01MB0601:
x-microsoft-antispam-prvs: <SH0PR01MB06015F839353DA2C827AD8A494150@SH0PR01MB0601.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03137AC81E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(329002)(328002)(199004)(189003)(76116006)(66476007)(66556008)(8676002)(2616005)(81166006)(66446008)(85182001)(36756003)(64756008)(6916009)(59450400001)(86362001)(95416001)(2906002)(26005)(186003)(81156014)(33656002)(8936002)(71200400001)(5660300002)(508600001)(63696004)(66946007)(966005);DIR:OUT;SFP:1102;SCL:1;SRVR:SH0PR01MB0601;H:SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:3;
received-spf: None (protection.outlook.com: eoitek.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d7MvY8LDCQ8wp9Vh6o/Gk7VpsBk3+lhruXQ7bURZQGx/1wEpBtyY3Na6XkegYPQ0stOhgy8wDS55rkz48nvgsdVHm14Fm5oT+od344PeUv9srEN1owumwS8Mq7vw2/fO7GtVdzjADUypck3rB8oAg07T49+/q/VFNECnW0YCigfozj28mNc+i0tlk7Q2sfO3f93S276Uyte9QpCx5tWeiAWpjXG5Y9ao4ghvNbj7BBX3zH/joJkfxQFf4ZjTbFmY+ScOpws77yyHs1HHinBhXL+6rSIpXOEqehP8oPBoK4+/KF2+ifD1y/CL9kF9vA56b5SpphBcJWp/RE7aBGSrXzsH6A/WN82ZnIvceeolcO+kN7jkkt94pyNlcPgXL9at99xgjKzb3TMwopftXzSy4cJEQdgwqmEBDqc54pg9WPo6oWy1V1Q/eYgnW6YK+0Ugo5LxPitb7m6zWnd7fZodKwm9Xi49lnmGGSS1ykCN5yWmBAC244L9A4KHzmNZzVPZAOT3SqkaEmmtmmIUitlyKA==
x-ms-exchange-antispam-messagedata: y0uPLpvf8tqdcZsC6kkultwHgrosGuQTMzPvjI3vH6xWm9h7yF76T5w9cQd0vfrCwCW/j143tMQJOLXyGkpj3g8VUwSoNMxMee1kmSFue6BPdQB0MU3oD2gFJ/Gfx3x9TUwkWmj23X4Zrz+AU2upbQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B49EBF2B6141345927780F9C45129B2@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a9a05d-033a-4978-aafc-08d7b127ffde
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2020 08:29:24.8799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yMURVH7dwLuArRsbIDLFo1pTT9WbRkV/AxkD+yArMzBE+w85t8cbbTPWXAzA571H1+ctmjc1v5Wy0bMZoU4uZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0601
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

VG8gaW1wbGVtZW50IGlvX3VyaW5nX3dhaXRfY3FlX3RpbWVvdXQsIHdlIGludHJvZHVjZSBhIG1h
Z2ljIG51bWJlcg0KY2FsbGVkIGBMSUJVUklOR19VREFUQV9USU1FT1VUYC4gVGhlIHByb2JsZW0g
aXMgdGhhdCBub3Qgb25seSB3ZQ0KbXVzdCBtYWtlIHN1cmUgdGhhdCB1c2VycyBzaG91bGQgbmV2
ZXIgc2V0IHNxZS0+dXNlcl9kYXRhIHRvDQpMSUJVUklOR19VREFUQV9USU1FT1VULCBidXQgYWxz
byBpbnRyb2R1Y2UgZXh0cmEgY29tcGxleGl0eSB0bw0KZmlsdGVyIG91dCBUSU1FT1VUIGNxZXMu
DQoNCkZvcm1lciBkaXNjdXNzaW9uOiBodHRwczovL2dpdGh1Yi5jb20vYXhib2UvbGlidXJpbmcv
aXNzdWVzLzUzDQoNCknigJltIHN1Z2dlc3RpbmcgaW50cm9kdWNpbmcgYSBuZXcgU1FFIGZsYWcg
Y2FsbGVkIElPU1FFX0lHTk9SRV9DUUUNCnRvIHNvbHZlIHRoaXMgcHJvYmxlbS4NCg0KRm9yIGEg
c3FlIHRhZ2dlZCB3aXRoIElPU1FFX0lHTk9SRV9DUUUgZmxhZywgaXQgd29u4oCZdCBnZW5lcmF0
ZSBhIGNxZQ0Kb24gY29tcGxldGlvbi4gU28gdGhhdCBJT1JJTkdfT1BfVElNRU9VVCBjYW4gYmUg
ZmlsdGVyZWQgb24ga2VybmVsDQpzaWRlLg0KDQpJbiBhZGRpdGlvbiwgYElPU1FFX0lHTk9SRV9D
UUVgIGNhbiBiZSB1c2VkIHRvIHNhdmUgY3Egc2l6ZS4NCg0KRm9yIGV4YW1wbGUgYFBPTExfQURE
KFBPTExJTiktPlJFQUQvUkVDVmAgbGluayBjaGFpbiwgcGVvcGxlIHVzdWFsbHkNCmRvbuKAmXQg
Y2FyZSB0aGUgcmVzdWx0IG9mIGBQT0xMX0FERGAgaXMgKCBzaW5jZSBpdCB3aWxsIGFsd2F5cyBi
ZQ0KUE9MTElOICksIGBJT1NRRV9JR05PUkVfQ1FFYCBjYW4gYmUgc2V0IG9uIGBQT0xMX0FERGAg
dG8gc2F2ZSBsb3RzDQpvZiBjcSBzaXplLg0KDQpCZXNpZGVzIFBPTExfQURELCBwZW9wbGUgdXN1
YWxseSBkb27igJl0IGNhcmUgdGhlIHJlc3VsdCBvZiBQT0xMX1JFTU9WRQ0KL1RJTUVPVVRfUkVN
T1ZFL0FTWU5DX0NBTkNFTC9DTE9TRS4gVGhlc2Ugb3BlcmF0aW9ucyBjYW4gYWxzbyBiZSB0YWdn
ZWQNCndpdGggSU9TUUVfSUdOT1JFX0NRRS4NCg0KVGhvdWdodHM/
