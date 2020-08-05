Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625FC23C40F
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 05:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgHEDov (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Aug 2020 23:44:51 -0400
Received: from mail-bjbon0148.outbound.protection.partner.outlook.cn ([42.159.36.148]:47951
        "EHLO CN01-BJB-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbgHEDov (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 4 Aug 2020 23:44:51 -0400
X-Greylist: delayed 959 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2020 23:44:49 EDT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YY8PBB7X/gNLxs1gx5/3BjmmkBulF2YbNvhxlFdb9W3t/IqsxkCtNptwpuriW082TTQDH+BKOhjwCMFm7xTSx5nlZisKyNCMoPie3N0OPhvdw0sncW3VKKTz2HzdF5pcJ0cai+AgvH11N+vTBrXiJzB1Fp/QQ/z/Oq/nVafLvvu28Qsuc6Nj+f5XmzrRl0idOyGcfCkhJyAGwl+nmc8LlgjOhvlx8oKOXBycvks1JmGvR+pZAZ7pheWxzrjzkGPxMV6AznePwMkJSfPpBB0UMYfStZUWuIF4lrRz/Z6v9VmyNYgNoVwAuZlJFVOcj2M3bLLENCO5EmWjhCmU45F35g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01Z4Wq5fbCVaO/E3sIHIKESEAmqG6xOGM0PbSd77958=;
 b=nCVWbvPfSwMcjy2fd7wkI3FWOnhsCsf+l0s1ThOACEx4zf34oV5dvCAXVHZnaIaHFkC08j/epl7D2QH9QMgnaDhxhpds4Cqf8Gc4BsQdNdRGvWca7dlRsWR9C/dOAMqsXMHbXsZFGaCrA42f5bwUM8mlGoT/YhHQcfs47ps/FUyx2nf8MTqNgOtlq+Yu9lrukhiLBTOPovwyNyMRWlTorUMEx5/45xEZpQ5miY1/A+yLM2tm7nGXFGgxmSqPgYvSmLnbhUGAfDnVDOdzNVj8ECFs1RLEwmVKP9MR7HN7Q1mdmCCDP/6CudjFgnn/EIg+2uXF0+QvZlQMDwJ1nsjF0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01Z4Wq5fbCVaO/E3sIHIKESEAmqG6xOGM0PbSd77958=;
 b=o1sO8Fr6nZHwucHsuulzWpsp8X0j3KYkpvRpbeco15l9D5W+T0c20Tfo2pjvrvoD8MtWHIIGQwtALQHJtkwU36BfsFgQYCrFB7oy/QVTm0c0FQVrsrcBk9Fh60bzIQJgPSFAQj7V78jxYqlrkIcKXOx0uC6zQs/WDwJZ5Cf3W70=
Received: from SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn (10.43.110.79) by
 SHXPR01MB0813.CHNPR01.prod.partner.outlook.cn (10.43.107.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.17; Wed, 5 Aug 2020 03:28:47 +0000
Received: from SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn ([10.43.110.79])
 by SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn ([10.43.110.79]) with mapi
 id 15.20.3239.022; Wed, 5 Aug 2020 03:28:47 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
CC:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH liburing v3 0/2] add support for new timeout feature
Thread-Topic: [PATCH liburing v3 0/2] add support for new timeout feature
Thread-Index: AQHWatiHmsscSDFy6UqrTXhZC+C9ig==
Date:   Wed, 5 Aug 2020 03:28:47 +0000
Message-ID: <3CC9BEDE-0509-4EC7-948C-77746E40B531@eoitek.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=eoitek.com;
x-originating-ip: [180.167.157.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19194b0c-907a-47c8-5a4e-08d838efaa37
x-ms-traffictypediagnostic: SHXPR01MB0813:
x-microsoft-antispam-prvs: <SHXPR01MB08139A7009B2ACE6A78CF14D944B0@SHXPR01MB0813.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tUo0JruCw/rOZZ8EjJtiHR2S1qvCc+7alVR9wAAKT3zOSNW0KIKdDCNz/PZqsCwfjNvNRwHOROTh2QJSWIimq2Hg/OYPdJLuvfHHX4XKGjr6Jc4fO8Ra9Wtkeg0ssY4orD8XiM/zI+CT/e8hs7Lp/RQ3I94oM7LVRHr2zGIkq3SWOKhW1KcF5t00FPBbSTaFKE1AWOc2Z6JN/G4Cxae+N9B244eaEinKX780CE+CFDfP83Tp9yi5R2fzdn88t9FUSOvwIY+6698bDLnoIp05nFqygX5p2X2xC3uSSxuXeRUyCClE6dm8tiZePpBkzMJTzfi7hPW4SzM2ikAjOlKkgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(346002)(328002)(329002)(66556008)(76116006)(85182001)(66476007)(33656002)(4326008)(71200400001)(86362001)(26005)(2616005)(6916009)(95416001)(63696004)(64756008)(66946007)(8676002)(36756003)(508600001)(5660300002)(2906002)(4744005)(186003)(8936002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: k5hMf5a4Gtzr9x0r0KvyESgc/O0c25HbxrYBzlSLeAZXratweKi47k3GdXR2MLYT+/ykbB1i1az6OTa0FoiUPlJ2dFVjxK9uav3y/cC1dm7DM5CF94B2TlDNarBGjlPjwEChUXXX0bdj3XoCe72Gq1xlX9XgRpt5GphR+OBqcmMkg5TJLP1AykRvPLCJ0K0z0m958FD0V18yiXhLbXVDPGOhOSxAjcLF1pepCmZSpS2LUaA6yLAC2/n8Z6tPWOVdGy/3GA/hFTKJ+i0KrKTqQ4ZGBQ4mcT8nH5KA31phHLT2Zsjj30+OLACFk1mO865X7hHIV09UxEfSrtC34KXxzV4pZgrfGhzL28+zMttbZgcpsglfP3+ABPUikRtJpa71o5biI1qDserptch9KCnq+S9xbeuCtZDTdHIA6Aa4WNL66vS3oXrmp3kSESJeVnqhd2gUpezglP/y9C4jV4FVMU2vT6Mjw2sTnr4g3expAQtiUaaLtgoy8RQyTfxdF8xMkU8xtGeYZ/o0fHOe2+EhieK3eV9BPbsqE92j00NUm4jvmTLTLL7E8qWnN+iQ/Lp/vfw3lmgOiNl9lb/ezQypnw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC61D75A342F2C43B35E491899795615@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: 19194b0c-907a-47c8-5a4e-08d838efaa37
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 03:28:47.4739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mtj36xgTDqVdvyBNLD/tVg/FkTCwe7we4tNOwJeJ6ixrbUyYKLwHlFAIOUikCuXFQXT7iKqWz/3HXnulME7Whg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SHXPR01MB0813
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

PiBkaWZmIC0tZ2l0IGEvc3JjL2luY2x1ZGUvbGlidXJpbmcuaCBiL3NyYy9pbmNsdWRlL2xpYnVy
aW5nLmgNCj4gaW5kZXggMDUwNWE0Zi4uODJjMjk4MCAxMDA2NDQNCj4gLS0tIGEvc3JjL2luY2x1
ZGUvbGlidXJpbmcuaA0KPiArKysgYi9zcmMvaW5jbHVkZS9saWJ1cmluZy5oDQo+IEBAIC01Niw2
ICs1Niw5IEBAIHN0cnVjdCBpb191cmluZyB7DQo+ICAJc3RydWN0IGlvX3VyaW5nX3NxIHNxOw0K
PiAgCXN0cnVjdCBpb191cmluZ19jcSBjcTsNCj4gIAl1bnNpZ25lZCBmbGFnczsNCj4gKwl1bnNp
Z25lZCBmbGFnc19pbnRlcm5hbDsNCj4gKwl1bnNpZ25lZCBmZWF0dXJlczsNCj4gKwl1bnNpZ25l
ZCBwYWRbNF07DQo+ICAJaW50IHJpbmdfZmQ7DQo+ICB9Ow0KDQpXb24ndCBpdCBicmVhayBleGlz
dGluZyBjb2RlIHJ1bnMgb24gbmV3ZXIga2VybmVsPw0KV29uJ3QgaXQgYnJlYWsgY29kZSBjb21w
aWxlZCB3aXRoIG5ldyBsaWJ1cmluZyBidXQgcnVucyBvbiBvbGRlciBrZXJuZWw/DQoNCklNTyBJ
biB0aGlzIGNhc2UsIGEgbmV3IHN5c2NhbGwgYGlvX3VyaW5nX3NldHVwMmAgaXMgcmVxdWlyZWQg
YXQgbGVhc3QuDQoNClJlZ2FyZHMsDQpDYXJ0ZXINCg0K
