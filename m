Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6292924CD39
	for <lists+io-uring@lfdr.de>; Fri, 21 Aug 2020 07:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgHUFWr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Aug 2020 01:22:47 -0400
Received: from mail-shaon0141.outbound.protection.partner.outlook.cn ([42.159.164.141]:62934
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725908AbgHUFWq (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 21 Aug 2020 01:22:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyB1EB0JjuazJMYpXbViGIOxTzZmTKQqIR2ONA9/JOQjnbmsTZ0Bj+MwXqD3VktCHq951Gd1igIJNg8S5RRUadTF5EzOCFUn0kbBt8dYitbxwYa0GjcdwXbOynWS772F5XwoYx1yfZU+fJ1CqKtrJ+nDLHKMLSeCq/mpx8zPn2W3fSg7wlnWkQMpwCevFCZLvl2zFw+bBc8ZPsvI/9oq8bgcTeeUHFGDIWEe7tRM9WF7c3Fzke2UpM1PalhqnzfrI8KmKopP+nstwkNIg8+DTi2NQ7v9K1+VFccst2fkb1VlI+7hTeCN17HSyxTGV4D55QJuz8Xix+DJUP10pS4zmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xy9tvRLyQQy9J88K4caz2CdP335WpvYh0bUwr0gdTk4=;
 b=OVQ8yH2FPYJmetjMyrRXwc84nF9D4ttXH8Os94FmlluSYXYZD80iwvPX2C+aCAssFZrcKqdsZ47HzpFm/p9ubBIGEHifIp8Jz+ftnGt4ajwyu7/yjE5/HArDBEUoGjyFUQj3qk5EZv4VYFjeY6GaCJmyVQE5lSoVH7Z53g163IS3CpykiPy+82knJpwDjyYQrXBCkv71q0rAir+vZJxLZoZDaLxdBkyI5hs8gDHHvCw/7JEf4FxovMIKeCm3n+bqpRP79xk4sCiNi/sH7NG6XtwDv58+O3JroE6dRFkcVpopw6Z9wNk817GrnlMPMuQIFW4GivYtSxgIYRMsHQ+d6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xy9tvRLyQQy9J88K4caz2CdP335WpvYh0bUwr0gdTk4=;
 b=Fnl1SCkAIZ7QzhczrUCQgF8UYBXrWa4KHTi9Z8rkk63zaWfvTtvZWU8gHblXk39iUcT11ETW04zurdocSWqbbA6JmBU8oG69839Na3Y3dsLPzVlNqBmLTDpgQAzIPBsSqhvWi+zWP8vdFwDwdkmqbq9GObtxCreaMc4h++nSlO0=
Received: from SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn (10.43.110.79) by
 SHXPR01MB0591.CHNPR01.prod.partner.outlook.cn (10.43.109.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.25; Fri, 21 Aug 2020 05:22:42 +0000
Received: from SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn ([10.43.110.79])
 by SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn ([10.43.110.79]) with mapi
 id 15.20.3305.027; Fri, 21 Aug 2020 05:22:42 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     io-uring <io-uring@vger.kernel.org>
Subject: Questions about IORING_OP_ASYNC_CANCEL usage
Thread-Topic: Questions about IORING_OP_ASYNC_CANCEL usage
Thread-Index: AQHWd3sY3OeKjGPnKU+CzdhJk9Ejxg==
Date:   Fri, 21 Aug 2020 05:22:42 +0000
Message-ID: <49134331-96D8-45AE-83F2-E5409A6748E2@eoitek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=eoitek.com;
x-originating-ip: [180.167.157.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab8c7288-9c7b-4a54-f8ec-08d845923ac9
x-ms-traffictypediagnostic: SHXPR01MB0591:
x-microsoft-antispam-prvs: <SHXPR01MB059154D9F87F82D684F16686945B0@SHXPR01MB0591.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:534;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AQ4UwSzsG0la4nB+vdtBVMW2kkAQViOLvFpubqHbTb0eQ9rrGKHcrqTzauLc2Up+x4Lz9aqMlHAa4bRPN8VEJeJy+2eZawo2UDdAXzWPyxXw0Ytl6EBDgQQpy+nW7I5xF2M1GFWcV3GpHhqbNLaQUrK4BppPXL/KSvdU300LAfBOyZ3mO3ILFw255V2BU+d/UsYLkdUiVeSgqnT91P0cQpH+LJBuIiDwI20htenxm0G8LCweph8GBl+tcx3tLkQtJuyxW8FaoSkJPQ/delFT+LB9lLLuTPQDX/qyJpPL2VNqs0aB0AXSkqfjmuKnsnyasRtHJGGfrtE2AkoxbiuCTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(328002)(329002)(76116006)(83380400001)(66446008)(64756008)(33656002)(66476007)(71200400001)(66556008)(4326008)(63696004)(66946007)(26005)(4744005)(6916009)(85182001)(95416001)(186003)(2616005)(8676002)(36756003)(59450400001)(508600001)(86362001)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2H9wg9l47/eSBCU3i5J5bW7wCQIxYb1P6zDdjf7f8iGbOsqzRvcX7mjrYbhbF1jcqOaZmTXKTWqU2dAyz5yfJ3WE7Ajk19IbE2rUjtku2//G4Z7Q5jj6AfMXYfHxlgcHrL2RsgK0UTTpzW5Esy6y+jwnj6OUp8dAMJc2ME70GzhHf3e4qZHRMXhrnCbYM5jPvjlRd3sw/HSvLTvQVoMXFShqqDRczq6ryzsFJCRQ3k56IBS9XD/mUvyy4vgYEMW4LM2pIBSD7RAL6Zj00ThcHTsW90DL5A3K8E68ObR6qKWwAf7oPZbAwSNlRj+dC2VhFwa1ImHzDl9Ep9ptaOH8L42omWnC45AehUHxUPnAy98MPT5qePeYXsxL6RbJw+6IM9lrbjXfBEMyCJXBy5mvRfGFs7lhmWiMRKQals3a+1+qMzXCoCp3HoCITKTdj98Wi5jIU0iGuCmGjRskQAnhWXA1eQH4NwycvUWSf4ROXPTfLXwYsQKOzNc9AwctWO+qUMkOfds5lZu3CYCCWXGf65qCp39dRPd+j9gWM8W3rMNV9dVD9j4Bbxo35wSvtyxiawf1GkPU0lGL3OozimCtsA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0DB53B0EAB03844B96E7DD9A0F07EA4@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8c7288-9c7b-4a54-f8ec-08d845923ac9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2020 05:22:42.4573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ErFB7R32ITe8aSEz7pOrdd7izWsQltR0n/ly+uE3jf9mRU731qAJojTRbWg9euPjSpzY6b7bZ9mvGWNBimewsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SHXPR01MB0591
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SGkgSmVucywNCg0KSSBoYXZlIHNvbWUgKCBtYXliZSBzdHVwaWQgKSBxdWVzdGlvbnMgYWJvdXQg
SU9SSU5HX09QX0FTWU5DX0NBTkNFTDoNCg0KMS4gRG9lcyBJT1JJTkdfT1BfQVNZTkNfQ0FOQ0VM
IGFsd2F5cyBjb21wbGV0ZSBpbmxpbmUgKCBpLmUuIGZpbmlzaGVzIGJlZm9yZSB0aGUgaW9fdXJp
bmdfZW50ZXIgc3lzY2FsbCByZXR1cm5zICk/DQoNCjIuIERvZXMgcmVjZW50IGNoYW5nZXMgb2Yg
YXN5bmMgYnVmZmVyZWQgcmVhZHMgaGF2ZSBhbnkgaW1wYWN0IHdpdGggY2FuY2VsYXRpb24/IENh
biB3ZSBjYW5jZWwgYSBidWZmZXJlZCBJT1JJTkdfT1BfUkVBRFYgb3BlcmF0aW9uIGFmdGVyIGl0
4oCZcyBzdGFydGVkPyBBbHRob3VnaCB0aGUgZGlzay0+a2VybmVsIERNQSBvcGVyYXRpb24gaXMg
bm90IGNhbmNlbGFibGUsIGNhbiB3ZSBjYW5jZWwgdGhlIGtlcm5lbC0+dXNlcmxhbmQgZGF0YSBj
b3B5Pw0KDQozLiBJIGhlYXJkIHRoYXQgYWxsIGJ1ZmZlcmVkIHdyaXRlcyBhcmUgc2VyaWFsaXpl
ZCBvbiB0aGUgaW5vZGUgbXV0ZXguIElmIGEgYnVmZmVyZWQgSU9SSU5HX09QX1dSSVRFViBpcyBi
bG9ja2VkIG9uIHRoZSBub2RlIG11dGV4LCBjYW4gd2UgY2FuY2VsIGl0Pw0KDQpUaGFua3MgaW4g
YWR2YW5jZSwNCkNhcnRlcg==
