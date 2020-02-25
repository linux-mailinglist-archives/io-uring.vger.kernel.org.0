Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6D516B79C
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 03:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBYCOq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 21:14:46 -0500
Received: from mail-shaon0154.outbound.protection.partner.outlook.cn ([42.159.164.154]:49094
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726962AbgBYCOq (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 24 Feb 2020 21:14:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gV6L6sw9qGx2yqjJvjwWFS9lile9uJxdnSiB8YDFF525rQaDGyTQG5bczyjzHgsHEummts2MQjWgTi6m3lhfNLc/CSWeYyReh2kB5r1ISGVZezcfSM6bPMziC5Mn1k7l6Afhda+ILLTCrfNk+i0CbTii7T0WT9OHtdsw4QAxKGU4MIDy4j9HhOqCvMCOiE/VR7U3gQRmMUvR8YwL7DN0Xi8a7loITb3LsW/djjqG5hTaAWQVvl4lwLOiMeeazUiYh70x+vKz9cgqjnrb9py9Ruh0Ar0kwLBmQtXUnYZmNUgP1x1JtllyWXjsJzkclBI2WtmSJEODHUmdczlOsW9HsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVpa4DTUxKfsFQemDgccYAeo76It55LuEO6aaVU2HPU=;
 b=BrhmsMACbG2xLIJ2+IKGvAuvQotNk73rccloJOqHriP3mt82JKFMs8zlkogWjplULWFrQYQ6eqCp3PL0+FsnYjyNtGOzlQL3tE6K9Hs1ydtuMhswUVJUF/5tyRXf3S3vpNWRZQDr7S8+eCVf1S7TLVbtI2EJJvREw7toJLFuGWH70RqvCqyU7YI2UXnx3ueUmIAVKQwZdz/UP1c0+hHP9BhH1aRitXbuBO44oRHvf92k57oHOaZadVxT9Q/5/JnmWT5t2UvphgdN8IHQFnsFn/HPhVV8ochMPXya/B1e4Se0ACqte+ZxlPZs3w6UIDctWR7nsk2hhzKmV9E+RnpQsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVpa4DTUxKfsFQemDgccYAeo76It55LuEO6aaVU2HPU=;
 b=W7wMZWbsimJSHZjir+UYqaQ4R85xDF0s9fMVQcPS05iF38zi4WgLk+uinHgEzuQbtbCpasREkOgXAfXqN8zVlWmrzi64T3Ix89MzlEWWXet54dmRQL+QkUvyaN6AMgmNSyC1BC8p+tMrwgsEZyxg9dmfNnUh6G8mNgt1m9ECJfg=
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn (10.43.108.138)
 by SH0PR01MB0524.CHNPR01.prod.partner.outlook.cn (10.43.108.79) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.24; Tue, 25 Feb
 2020 02:14:38 +0000
Received: from SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138])
 by SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn ([10.43.108.138]) with mapi
 id 15.20.2750.016; Tue, 25 Feb 2020 02:14:38 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Subject: Re: [RFC] single cqe per link
Thread-Topic: [RFC] single cqe per link
Thread-Index: AQHV63QdEitKeZxv0E6EAMm1LcMaoagrK8AA
Date:   Tue, 25 Feb 2020 02:14:38 +0000
Message-ID: <9E393343-7DB8-49D1-A7A2-611F88124C11@eoitek.com>
References: <1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com>
In-Reply-To: <1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=carter.li@eoitek.com; 
x-originating-ip: [183.200.9.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2492e004-0e15-40e1-7900-08d7b998776e
x-ms-traffictypediagnostic: SH0PR01MB0524:
x-microsoft-antispam-prvs: <SH0PR01MB0524F982B306323C9975588894ED0@SH0PR01MB0524.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(329002)(328002)(189003)(199004)(33656002)(86362001)(64756008)(95416001)(66946007)(66446008)(186003)(4326008)(26005)(2616005)(2906002)(71200400001)(59450400001)(6916009)(508600001)(63696004)(8936002)(8676002)(81166006)(81156014)(5660300002)(76116006)(85182001)(54906003)(36756003)(66556008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:SH0PR01MB0524;H:SH0PR01MB0491.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: eoitek.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mhkOTrcMERmLQurmUHnxxJOy2AKvp3KIz+Bd7/duDW+a109IThTEnxrYmJlinMNM8XbgzRLqrgtzyS8ek7ua/pbXm69DHbksGO5tAbuRVbX3sXbItNUyl4JGe9ic6TVc49VVK+8FFTbHM8eWvaDQ/HfaFDZvRaVnSgz3+93VArGLMEG6Z6HrG8PUrMl+U2n+YwMdEOFvDSE0OD6+FxUIFbXlMFI8teCueOMlWbkI5oUQTC7A30oQUfqoBfEB0xIQZlOF7xIRRHHdZ5t6ZtDaIdyX7jPw+7YY/wmc/slaAyBomR3c6lTk2t0dVDQmo60lDc8LWBqpNI0FoSNE1h6o2vEJa8sEB4znjZeHbL/YWJpMkblHKvnqJmToLzR1Qcis49yWCifYTSpBaQnpf9haBc2i1igqvqS5IRD9NxA6kLy2z2VlVRdYWTZCr1QERF0C
x-ms-exchange-antispam-messagedata: oWuEqRnkIIWmototha3on+ZR7pZuO6PMX6hF6c4Y8rm3TJ17/4dzfxcPkCPsxRRGFHbs9YqU3Mg1qaAjSp2L21dwm5DBu/LILkxfNR0HSitMifBQ4uV6sgNBjuQdzRsn1nndxL/2Xpi9knfuZc8uSg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1F4050BE8CB9045967E865AD0147294@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2492e004-0e15-40e1-7900-08d7b998776e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 02:14:38.5081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H2jQqfYD28GWbr3HXTYUQaTXXxBXF9CLSTABORNIObyIhxgaKAkOVR+1jn2Ci946VlhYZ+mVWNvqAujFDBrQaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0524
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SGVsbG8gUGF2ZWwsDQoNCkkgc3RpbGwgdGhpbmsgZmxhZ3MgdGFnZ2VkIG9uIHNxZXMgY291bGQg
YmUgYSBiZXR0ZXIgY2hvaWNlLCB3aGljaCBnaXZlcyB1c2VycyBhbiBhYmlsaXR5IHRvIGRlc2lk
ZSBpZiB0aGV5IHdhbnQgdG8gaWdub3JlIHRoZSBjcWVzLCBub3Qgb25seSBmb3IgbGlua3MsIGJ1
dCBhbHNvIGZvciBub3JtYWwgc3Flcy4NCg0KSW4gYWRkaXRpb24sIGJveGVkIGNxZXMgY291bGRu
4oCZdCByZXNvbHZlIHRoZSBpc3N1ZSBvZiBJT1JJTkdfSU9fVElNRU9VVC4NCg0KQ2FydGVyDQoN
Cj4gMjAyMOW5tDLmnIgyNeaXpSDkuIrljYg4OjM577yMUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2ls
ZW5jZUBnbWFpbC5jb20+IOWGmemBk++8mg0KPiANCj4gSSd2ZSBnb3QgY3VyaW91cyBhYm91dCBw
ZXJmb3JtYW5jZSBvZiB0aGUgaWRlYSBvZiBoYXZpbmcgb25seSAxIENRRSBwZXIgbGluaw0KPiAo
Zm9yIHRoZSBmYWlsZWQgb3IgbGFzdCBvbmUpLiBUZXN0ZWQgaXQgd2l0aCBhIHF1aWNrIGRpcnR5
IHBhdGNoIGRvaW5nDQo+IHN1Ym1pdC1hbmQtcmVhcCBvZiBhIG5vcHMtbGluayAocGF0Y2hlZCBm
b3IgaW5saW5lIGV4ZWN1dGlvbikuDQo+IA0KPiAxKSBsaW5rIHNpemU6IDEwMA0KPiBvbGQ6IDIw
NiBucyBwZXIgbm9wDQo+IG5ldzogMTQ0IG5zIHBlciBub3ANCj4gDQo+IDIpIGxpbmsgc2l6ZTog
MTANCj4gb2xkOiAyMzQgbnMgcGVyIG5vcA0KPiBuZXc6IDE4MSBucyBwZXIgbm9wDQo+IA0KPiAz
KSBsaW5rIHNpemU6IDEwLCBGT1JDRV9BU1lOQw0KPiBvbGQ6IDY2NyBucyBwZXIgbm9wDQo+IG5l
dzogNTY5IG5zIHBlciBub3ANCj4gDQo+IA0KPiBUaGUgcGF0Y2ggYmVsb3cgYnJlYWtzIHNlcXVl
bmNlcywgbGlua2VkX3RpbWVvdXQgYW5kIHdobyBrbm93cyB3aGF0IGVsc2UuDQo+IFRoZSBmaXJz
dCBvbmUgcmVxdWlyZXMgc3luY2hyb25pc2F0aW9uL2F0b21pYywgc28gaXQncyBhIGJpdCBpbiB0
aGUgd2F5LiBJJ3ZlDQo+IGJlZW4gd29uZGVyaW5nLCB3aGV0aGVyIElPU1FFX0lPX0RSQUlOIGlz
IHBvcHVsYXIgYW5kIGhvdyBtdWNoIGl0J3MgdXNlZC4gV2UgY2FuDQo+IHRyeSB0byBmaW5kIHRy
YWRlb2ZmIG9yIGV2ZW4gZGlzYWJsZSBpdCB3aXRoIHRoaXMgZmVhdHVyZS4NCj4gDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZnMvaW9fdXJpbmcuYyBiL2ZzL2lvX3VyaW5nLmMNCj4gaW5kZXggNjVhNjFi
OGIzN2M0Li45ZWMyOWYwMWNmZGEgMTAwNjQ0DQo+IC0tLSBhL2ZzL2lvX3VyaW5nLmMNCj4gKysr
IGIvZnMvaW9fdXJpbmcuYw0KPiBAQCAtMTE2NCw3ICsxMTY0LDcgQEAgc3RhdGljIGJvb2wgaW9f
Y3FyaW5nX292ZXJmbG93X2ZsdXNoKHN0cnVjdCBpb19yaW5nX2N0eA0KPiAqY3R4LCBib29sIGZv
cmNlKQ0KPiAJcmV0dXJuIGNxZSAhPSBOVUxMOw0KPiB9DQo+IA0KPiAtc3RhdGljIHZvaWQgaW9f
Y3FyaW5nX2ZpbGxfZXZlbnQoc3RydWN0IGlvX2tpb2NiICpyZXEsIGxvbmcgcmVzKQ0KPiArc3Rh
dGljIHZvaWQgX19pb19jcXJpbmdfZmlsbF9ldmVudChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgbG9u
ZyByZXMpDQo+IHsNCj4gCXN0cnVjdCBpb19yaW5nX2N0eCAqY3R4ID0gcmVxLT5jdHg7DQo+IAlz
dHJ1Y3QgaW9fdXJpbmdfY3FlICpjcWU7DQo+IEBAIC0xMTk2LDEzICsxMTk2LDMxIEBAIHN0YXRp
YyB2b2lkIGlvX2NxcmluZ19maWxsX2V2ZW50KHN0cnVjdCBpb19raW9jYiAqcmVxLA0KPiBsb25n
IHJlcykNCj4gCX0NCj4gfQ0KPiANCj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBpb19pZ25vcmVfY3Fl
KHN0cnVjdCBpb19raW9jYiAqcmVxKQ0KPiArew0KPiArCWlmICghKHJlcS0+Y3R4LT5mbGFncyAm
IElPUklOR19TRVRVUF9CT1hFRF9DUUUpKQ0KPiArCQlyZXR1cm4gZmFsc2U7DQo+ICsNCj4gKwly
ZXR1cm4gKHJlcS0+ZmxhZ3MgJiAoUkVRX0ZfTElOS3xSRVFfRl9GQUlMX0xJTkspKSA9PSBSRVFf
Rl9MSU5LOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgdm9pZCBpb19jcXJpbmdfZmlsbF9ldmVudChz
dHJ1Y3QgaW9fa2lvY2IgKnJlcSwgbG9uZyByZXMpDQo+ICt7DQo+ICsJaWYgKGlvX2lnbm9yZV9j
cWUocmVxKSkNCj4gKwkJcmV0dXJuOw0KPiArCV9faW9fY3FyaW5nX2ZpbGxfZXZlbnQocmVxLCBy
ZXMpOw0KPiArfQ0KPiArDQo+IHN0YXRpYyB2b2lkIGlvX2NxcmluZ19hZGRfZXZlbnQoc3RydWN0
IGlvX2tpb2NiICpyZXEsIGxvbmcgcmVzKQ0KPiB7DQo+IAlzdHJ1Y3QgaW9fcmluZ19jdHggKmN0
eCA9IHJlcS0+Y3R4Ow0KPiAJdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gDQo+ICsJaWYgKGlvX2ln
bm9yZV9jcWUocmVxKSkNCj4gKwkJcmV0dXJuOw0KPiArDQo+IAlzcGluX2xvY2tfaXJxc2F2ZSgm
Y3R4LT5jb21wbGV0aW9uX2xvY2ssIGZsYWdzKTsNCj4gLQlpb19jcXJpbmdfZmlsbF9ldmVudChy
ZXEsIHJlcyk7DQo+ICsJX19pb19jcXJpbmdfZmlsbF9ldmVudChyZXEsIHJlcyk7DQo+IAlpb19j
b21taXRfY3FyaW5nKGN0eCk7DQo+IAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZjdHgtPmNvbXBs
ZXRpb25fbG9jaywgZmxhZ3MpOw0KPiANCj4gQEAgLTcwODQsNyArNzEwMiw4IEBAIHN0YXRpYyBs
b25nIGlvX3VyaW5nX3NldHVwKHUzMiBlbnRyaWVzLCBzdHJ1Y3QNCj4gaW9fdXJpbmdfcGFyYW1z
IF9fdXNlciAqcGFyYW1zKQ0KPiANCj4gCWlmIChwLmZsYWdzICYgfihJT1JJTkdfU0VUVVBfSU9Q
T0xMIHwgSU9SSU5HX1NFVFVQX1NRUE9MTCB8DQo+IAkJCUlPUklOR19TRVRVUF9TUV9BRkYgfCBJ
T1JJTkdfU0VUVVBfQ1FTSVpFIHwNCj4gLQkJCUlPUklOR19TRVRVUF9DTEFNUCB8IElPUklOR19T
RVRVUF9BVFRBQ0hfV1EpKQ0KPiArCQkJSU9SSU5HX1NFVFVQX0NMQU1QIHwgSU9SSU5HX1NFVFVQ
X0FUVEFDSF9XUSB8DQo+ICsJCQlJT1JJTkdfU0VUVVBfQk9YRURfQ1FFKSkNCj4gCQlyZXR1cm4g
LUVJTlZBTDsNCj4gDQo+IAlyZXQgPSBpb191cmluZ19jcmVhdGUoZW50cmllcywgJnApOw0KPiBk
aWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2lvX3VyaW5nLmggYi9pbmNsdWRlL3VhcGkv
bGludXgvaW9fdXJpbmcuaA0KPiBpbmRleCAwODg5MWNjMWMxZTcuLjNkNjkzNjllMjUyYyAxMDA2
NDQNCj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2lvX3VyaW5nLmgNCj4gKysrIGIvaW5jbHVk
ZS91YXBpL2xpbnV4L2lvX3VyaW5nLmgNCj4gQEAgLTg2LDYgKzg2LDcgQEAgZW51bSB7DQo+ICNk
ZWZpbmUgSU9SSU5HX1NFVFVQX0NRU0laRQkoMVUgPDwgMykJLyogYXBwIGRlZmluZXMgQ1Egc2l6
ZSAqLw0KPiAjZGVmaW5lIElPUklOR19TRVRVUF9DTEFNUAkoMVUgPDwgNCkJLyogY2xhbXAgU1Ev
Q1EgcmluZyBzaXplcyAqLw0KPiAjZGVmaW5lIElPUklOR19TRVRVUF9BVFRBQ0hfV1EJKDFVIDw8
IDUpCS8qIGF0dGFjaCB0byBleGlzdGluZyB3cSAqLw0KPiArI2RlZmluZSBJT1JJTkdfU0VUVVBf
Qk9YRURfQ1FFCSgxVSA8PCA2KQkvKiBzaW5nbGUgc3FlIHBlciBsaW5rICovDQo+IA0KPiBlbnVt
IHsNCj4gCUlPUklOR19PUF9OT1AsDQo+IA0KPiANCj4gLS0gDQo+IFBhdmVsIEJlZ3Vua292DQoN
Cg==
