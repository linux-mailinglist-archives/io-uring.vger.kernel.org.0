Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209122968E9
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 05:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370027AbgJWDzJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 23:55:09 -0400
Received: from mail-eopbgr750050.outbound.protection.outlook.com ([40.107.75.50]:19681
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S370025AbgJWDzJ (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 22 Oct 2020 23:55:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2wyWj9aFhoueMes7ivgZFIv8P8iMkmcPI4PlLvVvRnpTJsQrvvwRPCcC670F3ggUf/F+irQElmhvU+45GptXK0YrgdJX8moMBf2Sx6HGYBUJ5cgEsb+u+u8TfC1JNkX21IU6x2YfR4jwEHq1dacTpWeOLtssULEub+cOIyRTeqXmu4qhjxoUu3nLnufNEb7HpcIICWDC7Z048eS9bcq4BNLL9scPRVxdJf2E1RcFrlZOvBWFuMFnX4mdznmTYaGWBdbW1S5sN3k0BKlacHkSG3bgKgbovsuzdbAbJJpHmdbEWMEeprr2r++F5sy1iVFMWgxnciOCpjW4FIdVyOnPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuYw/To0vyXP/UFmopsjkmI2ULCwYTQoOGwH5nS6Od4=;
 b=ePY+VqdXW08pumtwf3TXFi6rE3Pu2vu0CCtqeLU/i3UeGe5xWAeackfRd3HstoxPMCzUnm2ze/EijlYvQKF1rHHLhp2sj9Rjd5h2Un+UElnEP5/X5aq0KC0uMYZvcZAyRraQdBQr1sVCUxHVIX6dLwbI9j0HxGwLuoUvq1qKyy0L7jZ7gAJwm2HE0EZSTH7xOPyRSgV7jcN7quWMDu8T1eop6WK50pt+BYYWVu4efgnBkjLRBLliiXRW17AlV7wREnMFFJuO3YhX3pHPQ2Das7nDlgnjtuzL8UXUCcYMrZ45oWpho2z0pp6D4Ts8wa76ObmcDhiXTmHW4hRe8mV17w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuYw/To0vyXP/UFmopsjkmI2ULCwYTQoOGwH5nS6Od4=;
 b=eR7DAYDRLAZwaYh/wlCIkxoEyeBORM+oyQ1TBcNh8b8YlUKMZwlXSGtO8cOYgZCp7dadKCngp3TM4Lti8YB4J9gPS5lsqxKXr6SisTe1M6Q2djso4ncKuOcLf3Og3x3NsSHObZ/3cr15IpjYhgFCxPGNeo6qiWXhHCs3/1C8Htw=
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by SJ0PR11MB4942.namprd11.prod.outlook.com (2603:10b6:a03:2ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Fri, 23 Oct
 2020 03:55:04 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05%3]) with mapi id 15.20.3455.030; Fri, 23 Oct 2020
 03:55:04 +0000
From:   "Zhang, Qiang" <Qiang.Zhang@windriver.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: =?gb2312?B?u9i4tDogUXVlc3Rpb24gb24gaW8td3E=?=
Thread-Topic: Question on io-wq
Thread-Index: AQHWqFIIJfBUWm45qk6/o7Xr3klK5qmjqOaAgADl1fA=
Date:   Fri, 23 Oct 2020 03:55:04 +0000
Message-ID: <BYAPR11MB2632F2892640FCF08997B36AFF1A0@BYAPR11MB2632.namprd11.prod.outlook.com>
References: <98c41fba-87fe-b08d-2c8c-da404f91ef31@windriver.com>,<8dd4bc4c-9d8e-fb5a-6931-3e861ad9b4bf@kernel.dk>
In-Reply-To: <8dd4bc4c-9d8e-fb5a-6931-3e861ad9b4bf@kernel.dk>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ce81b46-1204-4eae-ed6f-08d877076cc8
x-ms-traffictypediagnostic: SJ0PR11MB4942:
x-microsoft-antispam-prvs: <SJ0PR11MB4942089D3AB1ED1B8B7D3ABFFF1A0@SJ0PR11MB4942.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XNdctyWfhu062euVH25il2W3TKyrqFw48UEsZtBNBwb9w9wu4R+mYYKScD9tumM/xsKAZBHKAAyHFpgupFYiGEQy8O9+QkF7kOmheJp4pqYqs0TOGTaR7nl1h5AndPySZb2Pc2iKH3uzGXbJPnlZPrN2Ms7EFmaOCappZVg+1ovmtLcZQ44Pvv16xrFChY/WBgiu+MBaF0JKAzHCjDrB3lpazSiSslgHgP79U/4fdkPYuvr5/zYSF8vQfo2RvAnQE1LDXAwofL7750gD4i6LYYExoLttFeOit7qP5enEUY2sbxnuU71rgcXvdqYn0yOY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(136003)(376002)(346002)(396003)(55016002)(71200400001)(86362001)(224303003)(66556008)(66946007)(6916009)(52536014)(66446008)(76116006)(5660300002)(91956017)(83380400001)(66476007)(64756008)(9686003)(7696005)(26005)(54906003)(33656002)(316002)(6506007)(186003)(53546011)(8936002)(4326008)(2906002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FTThlufwHLTIfF5CSQ/MgBpAJR9UumYRfiHVbv7Kjz26DQCDRmIR4/kQdZmhp2N6g5U4lxiLp2BsZKrW6X80tARCw3p7/Z+wXZcdXKJkYUKeD6mIJbZdu3hxmLqjXg16gQ1Js6Ps0VyePDFsLB9Twp/HvDwzA7g35fPuUSyKMSHfF/qkrUHtgkaOakliuXZ/z0NSZ17DfD/1luTfbYe+ZuvhN3DW2KfV8VkiODW2ka0oFOeyH68pN25Hq22fCl5rS25nhptSKyiF49blffag3P9vaqg8jMl8mBH5EHRimW/zErlzR+gXYgrgX72oylJ4zrPEFGxGhHvZ4HAEst92QNtLRjpb17VGJdInNoLW8JUpK2ZUgNwuVdK3u1cFjit3CE8TTK5MOvQ9IdL3Fryc41fdUgJxSqYT8DTfNbnr9m0SX3SdZ07Et2wg1cMaAloVtORy08DBcWYgd6rqBYbFwTSnOMy/4GZLs5U0NAhWvZc5QG8aKLPzqOw7dQLu1vlZZWxrKt4YXNHk+6jjAcoJ98t337MVdGMlLRu/H9FdA2FRBSW58A4z43VHW4fs8Quj5YSV71ODJtwnt9YhnyNHkmXw8KRJfnFrBQZRTXcQjZwPG9kFAVxynJVC5AihImx1oZhi2V0larzBuULJgFdxfQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2632.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce81b46-1204-4eae-ed6f-08d877076cc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2020 03:55:04.5369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bdpoI1Il0gIp2GTQMMxZ7SCSvsUNOg6eHUl/pOEhWJyQLLmo7H5jbWIQtTi+9y/+xZ+NQOz+kGkSwF3HEyjzA/P9K1vFmjXGlPlolKvcWDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4942
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCreivP7IyzogSmVucyBB
eGJvZSA8YXhib2VAa2VybmVsLmRrPgq3osvNyrG85DogMjAyMMTqMTDUwjIyyNUgMjI6MDgKytW8
/sjLOiBaaGFuZywgUWlhbmcKs63LzTogdmlyb0B6ZW5pdi5saW51eC5vcmcudWs7IGlvLXVyaW5n
QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtZnNk
ZXZlbEB2Z2VyLmtlcm5lbC5vcmcK1vfM4jogUmU6IFF1ZXN0aW9uIG9uIGlvLXdxCgpPbiAxMC8y
Mi8yMCAzOjAyIEFNLCBaaGFuZyxRaWFuZyB3cm90ZToKPgo+IEhpIEplbnMgQXhib2UKPgo+IFRo
ZXJlIGFyZSBzb21lIHByb2JsZW0gaW4gJ2lvX3dxZV93b3JrZXInIHRocmVhZCwgd2hlbiB0aGUK
PiAnaW9fd3FlX3dvcmtlcicgYmUgY3JlYXRlIGFuZCAgU2V0dGluZyB0aGUgYWZmaW5pdHkgb2Yg
Q1BVcyBpbiBOVU1BCj4gbm9kZXMsIGR1ZSB0byBDUFUgaG90cGx1ZywgV2hlbiB0aGUgbGFzdCBD
UFUgZ29pbmcgZG93biwgdGhlCj4gJ2lvX3dxZV93b3JrZXInIHRocmVhZCB3aWxsIHJ1biBhbnl3
aGVyZS4gd2hlbiB0aGUgQ1BVIGluIHRoZSBub2RlIGdvZXMKPiBvbmxpbmUgYWdhaW4sIHdlIHNo
b3VsZCByZXN0b3JlIHRoZWlyIGNwdSBiaW5kaW5ncz8KCj5Tb21ldGhpbmcgbGlrZSB0aGUgYmVs
b3cgc2hvdWxkIGhlbHAgaW4gZW5zdXJpbmcgYWZmaW5pdGllcyBhcmUKPmFsd2F5cyBjb3JyZWN0
IC0gdHJpZ2dlciBhbiBhZmZpbml0eSBzZXQgZm9yIGFuIG9ubGluZSBDUFUgZXZlbnQuIFdlCj5z
aG91bGQgbm90IG5lZWQgdG8gZG8gaXQgZm9yIG9mZmxpbmluZy4gQ2FuIHlvdSB0ZXN0IGl0PwoK
Cj5kaWZmIC0tZ2l0IGEvZnMvaW8td3EuYyBiL2ZzL2lvLXdxLmMKPmluZGV4IDQwMTJmZjU0MWI3
Yi4uM2JmMDI5ZDExNzBlIDEwMDY0NAo+LS0tIGEvZnMvaW8td3EuYwo+KysrIGIvZnMvaW8td3Eu
Ywo+QEAgLTE5LDYgKzE5LDcgQEAKID4jaW5jbHVkZSA8bGludXgvdGFza193b3JrLmg+CiA+I2lu
Y2x1ZGUgPGxpbnV4L2Jsay1jZ3JvdXAuaD4KID4jaW5jbHVkZSA8bGludXgvYXVkaXQuaD4KPisj
aW5jbHVkZSA8bGludXgvY3B1Lmg+CgogPiNpbmNsdWRlICJpby13cS5oIgo+Cj5AQCAtMTIzLDkg
KzEyNCwxMyBAQCBzdHJ1Y3QgaW9fd3EgewogPiAgICAgICByZWZjb3VudF90IHJlZnM7CiAgPiAg
ICAgIHN0cnVjdCBjb21wbGV0aW9uIGRvbmU7Cj4KPisgICAgICAgc3RydWN0IGhsaXN0X25vZGUg
Y3B1aHBfbm9kZTsKPisKID4gICAgICAgcmVmY291bnRfdCB1c2VfcmVmczsKID59Owo+Cj4rc3Rh
dGljIGVudW0gY3B1aHBfc3RhdGUgaW9fd3Ffb25saW5lOwo+KwogPnN0YXRpYyBib29sIGlvX3dv
cmtlcl9nZXQoc3RydWN0IGlvX3dvcmtlciAqd29ya2VyKQogPnsKICAgPiAgICAgcmV0dXJuIHJl
ZmNvdW50X2luY19ub3RfemVybygmd29ya2VyLT5yZWYpOwo+QEAgLTEwOTYsNiArMTEwMSwxMyBA
QCBzdHJ1Y3QgaW9fd3EgKmlvX3dxX2NyZWF0ZSh1bnNpZ25lZCBib3VuZGVkLCA+c3RydWN0IGlv
X3dxX2RhdGEgKmRhdGEpCiA+ICAgICAgICAgICAgICAgcmV0dXJuIEVSUl9QVFIoLUVOT01FTSk7
CiAgPiAgICAgIH0KPgo+KyAgICAgICByZXQgPSBjcHVocF9zdGF0ZV9hZGRfaW5zdGFuY2Vfbm9j
YWxscyhpb193cV9vbmxpbmUsID4md3EtPmNwdWhwX25vZGUpOwo+KyAgICAgICBpZiAocmV0KSB7
Cj4rICAgICAgICAgICAgICAga2ZyZWUod3EtPndxZXMpOwo+KyAgICAgICAgICAgICAgIGtmcmVl
KHdxKTsKPisgICAgICAgICAgICAgICByZXR1cm4gRVJSX1BUUihyZXQpOwo+KyAgICAgICB9Cj4r
Cj4gICAgICAgIHdxLT5mcmVlX3dvcmsgPSBkYXRhLT5mcmVlX3dvcms7Cj4gICAgICAgIHdxLT5k
b193b3JrID0gZGF0YS0+ZG9fd29yazsKPgo+QEAgLTExNDUsNiArMTE1Nyw3IEBAIHN0cnVjdCBp
b193cSAqaW9fd3FfY3JlYXRlKHVuc2lnbmVkIGJvdW5kZWQsID5zdHJ1Y3QgaW9fd3FfZGF0YSAq
ZGF0YSkKID4gICAgICAgcmV0ID0gUFRSX0VSUih3cS0+bWFuYWdlcik7CiA+ICAgICAgIGNvbXBs
ZXRlKCZ3cS0+ZG9uZSk7CiA+ZXJyOgo+KyAgICAgICBjcHVocF9zdGF0ZV9yZW1vdmVfaW5zdGFu
Y2Vfbm9jYWxscyhpb193cV9vbmxpbmUsID4md3EtPmNwdWhwX25vZGUpOwogID4gICAgICBmb3Jf
ZWFjaF9ub2RlKG5vZGUpCiA+ICAgICAgICAgICAgICAga2ZyZWUod3EtPndxZXNbbm9kZV0pOwog
PiAgICAgICBrZnJlZSh3cS0+d3Flcyk7Cj5AQCAtMTE2NCw2ICsxMTc3LDggQEAgc3RhdGljIHZv
aWQgX19pb193cV9kZXN0cm95KHN0cnVjdCBpb193cSAqd3EpCiA+ewogPiAgICAgICBpbnQgbm9k
ZTsKPgo+KyAgICAgICBjcHVocF9zdGF0ZV9yZW1vdmVfaW5zdGFuY2Vfbm9jYWxscyhpb193cV9v
bmxpbmUsID4md3EtPmNwdWhwX25vZGUpOwo+KwogICA+ICAgICBzZXRfYml0KElPX1dRX0JJVF9F
WElULCAmd3EtPnN0YXRlKTsKICA+ICAgICAgaWYgKHdxLT5tYW5hZ2VyKQogPiAgICAgICAgICAg
ICAgIGt0aHJlYWRfc3RvcCh3cS0+bWFuYWdlcik7Cj5AQCAtMTE5MSwzICsxMjA2LDQwIEBAIHN0
cnVjdCB0YXNrX3N0cnVjdCAqaW9fd3FfZ2V0X3Rhc2soc3RydWN0IGlvX3dxID4qd3EpCiA+ewog
PiAgICAgIHJldHVybiB3cS0+bWFuYWdlcjsKID59Cj4rCj4rc3RhdGljIGJvb2wgaW9fd3Ffd29y
a2VyX2FmZmluaXR5KHN0cnVjdCBpb193b3JrZXIgKndvcmtlciwgdm9pZCAqZGF0YSkKPit7Cj4r
ICAgICAgIHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzayA9IHdvcmtlci0+dGFzazsKPisgICAgICAg
dW5zaWduZWQgbG9uZyBmbGFnczsKPisKICAgICAgICAgICBzdHJ1Y3QgcnFfZmxhZ3MgcmY7CgoK
PisgICAgICAgcmF3X3NwaW5fbG9ja19pcnFzYXZlKCZ0YXNrLT5waV9sb2NrLCBmbGFncyk7Cj4r
ICAgICAgIGRvX3NldF9jcHVzX2FsbG93ZWQodGFzaywgY3B1bWFza19vZl9ub2RlKHdvcmtlci0+
d3FlLT5ub2RlKSk7Cj4rICAgICAgIHRhc2stPmZsYWdzIHw9IFBGX05PX1NFVEFGRklOSVRZOwo+
KyAgICAgICByYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdGFzay0+cGlfbG9jaywgZmxhZ3Mp
OwoKCj4rICAgICAgIHJldHVybiBmYWxzZTsKPit9Cj4rCj4rc3RhdGljIGludCBpb193cV9jcHVf
b25saW5lKHVuc2lnbmVkIGludCBjcHUsIHN0cnVjdCBobGlzdF9ub2RlICpub2RlKQo+K3sKPisg
ICAgICAgc3RydWN0IGlvX3dxICp3cSA9IGhsaXN0X2VudHJ5X3NhZmUobm9kZSwgc3RydWN0IGlv
X3dxLCBjcHVocF9ub2RlKTsKPisgICAgICAgaW50IGk7Cj4rCj4rICAgICAgIHJjdV9yZWFkX2xv
Y2soKTsKPisgICAgICAgZm9yX2VhY2hfbm9kZShpKQo+KyAgICAgICAgICAgICAgIGlvX3dxX2Zv
cl9lYWNoX3dvcmtlcih3cS0+d3Flc1tpXSwgaW9fd3Ffd29ya2VyX2FmZmluaXR5LCA+TlVMTCk7
Cj4rICAgICAgIHJjdV9yZWFkX3VubG9jaygpOwo+KyAgICAgICByZXR1cm4gMDsKPit9Cj4rCj4r
c3RhdGljIF9faW5pdCBpbnQgaW9fd3FfaW5pdCh2b2lkKQo+K3sKPisgICAgICAgaW50IHJldDsK
PisKPisgICAgICAgcmV0ID0gY3B1aHBfc2V0dXBfc3RhdGVfbXVsdGkoQ1BVSFBfQVBfT05MSU5F
X0RZTiwgPiJpby0+d3Evb25saW5lIiwKPisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBpb193cV9jcHVfb25saW5lLCBOVUxMKTsKPisgICAgICAgaWYgKHJldCA8IDApCj4r
ICAgICAgICAgICAgICAgcmV0dXJuIHJldDsKPisgICAgICAgaW9fd3Ffb25saW5lID0gcmV0Owo+
KyAgICAgICByZXR1cm4gMDsKPit9Cj4rc3Vic3lzX2luaXRjYWxsKGlvX3dxX2luaXQpOwo+Cj4t
LQo+SmVucyBBeGJvZQoK
