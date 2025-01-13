Return-Path: <io-uring+bounces-5839-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76307A0AE7B
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 05:41:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 841171612B6
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 04:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32812170A0A;
	Mon, 13 Jan 2025 04:40:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1777C2F56;
	Mon, 13 Jan 2025 04:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736743256; cv=none; b=PnTBWvEzbJKWw/shYPZrXyW/4CXLnMgkFJLTpT/zHG7xoF2Ul3qtOwF9ABJhagU6Ar5+p3n19p/DR5MqmkfxwpnlMbGxtgTzbstSnyxc3/5h/5QO06FP/P0Lz30qyU3Axqp6yMeIbJKtQ89Ox6H6ic+twO7NxE34PfehHBEFwAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736743256; c=relaxed/simple;
	bh=cVHDtU1Ye/Co0xDzOHaJcHrb83HM5RcLbXbyvIPVLiY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BB55hxu3fI5ZlG5u03Fd+1XxFN1M3gt2d+PF6v3Kzfn4eawMv6LAPTVVve45o0H/5YVfnhI7Z3dfzK3CMDmuHTvTmwAl/sj5hMW1PV8bP3mcAp+OwB6PIpqJMFA5vJ7IQTwBNuQrszu2c6x/NOfEYM+VaYjrob0gkGBuVBW/Qkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YWfd24tmQz1kyCV;
	Mon, 13 Jan 2025 12:37:42 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id E82F91402E0;
	Mon, 13 Jan 2025 12:40:49 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 13 Jan 2025 12:40:49 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Mon, 13 Jan 2025 12:40:49 +0800
From: lizetao <lizetao1@huawei.com>
To: Pavel Begunkov <asml.silence@gmail.com>, Bui Quang Minh
	<minhquangbui99@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>,
	"syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com"
	<syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com>
Subject: RE: [PATCH] io_uring: simplify the SQPOLL thread check when
 cancelling requests
Thread-Topic: [PATCH] io_uring: simplify the SQPOLL thread check when
 cancelling requests
Thread-Index: AQHbZQBAfPWaG4hxx06y9utYvVroALMTRYCQ//+EZoCAAFRSgIABAbTw
Date: Mon, 13 Jan 2025 04:40:49 +0000
Message-ID: <7a3696740cd546cd95cd821a7a7be03c@huawei.com>
References: <20250112143358.49671-1-minhquangbui99@gmail.com>
 <aff011219272498a900f052d0142978c@huawei.com>
 <3cab5ad8-3089-46c7-868e-38bd3c250b26@gmail.com>
 <75e12d85-9c2e-4b06-99d1-bc29c5422b69@gmail.com>
In-Reply-To: <75e12d85-9c2e-4b06-99d1-bc29c5422b69@gmail.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGF2ZWwgQmVndW5r
b3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+DQo+IFNlbnQ6IE1vbmRheSwgSmFudWFyeSAxMywg
MjAyNSA1OjE2IEFNDQo+IFRvOiBCdWkgUXVhbmcgTWluaCA8bWluaHF1YW5nYnVpOTlAZ21haWwu
Y29tPjsgbGl6ZXRhbw0KPiA8bGl6ZXRhbzFAaHVhd2VpLmNvbT47IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gQ2M6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz47IGlvLXVyaW5n
QHZnZXIua2VybmVsLm9yZzsNCj4gc3l6Ym90KzNjNzUwYmUwMWRhYjY3MmM1MTNkQHN5emthbGxl
ci5hcHBzcG90bWFpbC5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gaW9fdXJpbmc6IHNpbXBs
aWZ5IHRoZSBTUVBPTEwgdGhyZWFkIGNoZWNrIHdoZW4NCj4gY2FuY2VsbGluZyByZXF1ZXN0cw0K
PiANCj4gT24gMS8xMi8yNSAxNjoxNCwgQnVpIFF1YW5nIE1pbmggd3JvdGU6DQo+IC4uLg0KPiA+
Pj4gQEAgLTI4OTgsNyArMjg5OSwxMiBAQCBzdGF0aWMgX19jb2xkIHZvaWQgaW9fcmluZ19leGl0
X3dvcmsoc3RydWN0DQo+ID4+PiB3b3JrX3N0cnVjdCAqd29yaykNCj4gPj4+IMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAoY3R4LT5mbGFncyAmIElPUklOR19TRVRVUF9ERUZFUl9UQVNLUlVOKQ0KPiA+
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW9fbW92ZV90YXNrX3dvcmtfZnJvbV9sb2Nh
bChjdHgpOw0KPiA+Pj4NCj4gPj4+IC3CoMKgwqDCoMKgwqDCoCB3aGlsZSAoaW9fdXJpbmdfdHJ5
X2NhbmNlbF9yZXF1ZXN0cyhjdHgsIE5VTEwsIHRydWUpKQ0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKg
IC8qDQo+ID4+PiArwqDCoMKgwqDCoMKgwqDCoCAqIEV2ZW4gaWYgU1FQT0xMIHRocmVhZCByZWFj
aGVzIHRoaXMgcGF0aCwgZG9uJ3QgZm9yY2UNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoMKgICogaW9w
b2xsIGhlcmUsIGxldCB0aGUgaW9fdXJpbmdfY2FuY2VsX2dlbmVyaWMgaGFuZGxlDQo+ID4+PiAr
wqDCoMKgwqDCoMKgwqDCoCAqIGl0Lg0KPiA+Pg0KPiA+PiBKdXN0IGN1cmlvdXMsIHdpbGwgc3Ff
dGhyZWFkIGVudGVyIHRoaXMgaW9fcmluZ19leGl0X3dvcmsgcGF0aD8NCj4gPg0KPiA+IEFGQUlL
LCB5ZXMuIFRoZSBTUVBPTEwgdGhyZWFkIGlzIGNyZWF0ZWQgd2l0aCBjcmVhdGVfaW9fdGhyZWFk
LCB0aGlzIGZ1bmN0aW9uDQo+IGNyZWF0ZXMgYSBuZXcgdGFzayB3aXRoIENMT05FX0ZJTEVTLiBT
byBhbGwgdGhlIG9wZW4gZmlsZXMgaXMgc2hhcmVkLiBUaGVyZSB3aWxsDQo+IGJlIGNhc2UgdGhh
dCB0aGUgcGFyZW50IGNsb3NlcyBpdHMgaW9fdXJpbmcgZmlsZSBhbmQgU1FQT0xMIHRocmVhZCBi
ZWNvbWUgdGhlDQo+IG9ubHkgb3duZXIgb2YgdGhhdCBmaWxlLiBTbyBpdCBjYW4gcmVhY2ggdGhp
cyBwYXRoIHdoZW4gdGVybWluYXRpbmcuDQo+IA0KPiBUaGUgZnVuY3Rpb24gaXMgcnVuIGJ5IGEg
c2VwYXJhdGUga3RocmVhZCwgdGhlIHNxcG9sbCB0YXNrIGRvZXNuJ3QgY2FsbCBpdCBkaXJlY3Rs
eS4NCg0KSSBhbHNvIHRoaW5rIHNvLCB0aGUgc3Fwb2xsIHRhc2sgbWF5IG5vdCBjYWxsIGlvX3Jp
bmdfZXhpdF93b3JrKCkuDQo+IA0KPiBbLi4uXQ0KPiA+Pj4+IGlvX3VyaW5nLA0KPiA+Pj4gLcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBjYW5jZWxfYWxsKTsNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY2FuY2Vs
X2FsbCwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdHJ1ZSk7DQo+ID4+PiDCoMKgwqDCoMKgwqDC
oMKgwqAgfQ0KPiA+Pj4NCj4gPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAobG9vcCkgew0KPiA+
Pj4gLS0NCj4gPj4+IDIuNDMuMA0KPiA+Pj4NCj4gPj4NCj4gPj4gTWF5YmUgeW91IG1pc3Mgc29t
ZXRoaW5nLCBqdXN0IGxpa2UgQmVndW5rb3YgbWVudGlvbmVkIGluIHlvdXIgbGFzdA0KPiB2ZXJz
aW9uIHBhdGNoOg0KPiA+Pg0KPiA+PiDCoMKgIGlvX3VyaW5nX2NhbmNlbF9nZW5lcmljDQo+ID4+
IMKgwqDCoMKgIFdBUk5fT05fT05DRShzcWQgJiYgc3FkLT50aHJlYWQgIT0gY3VycmVudCk7DQo+
ID4+DQo+ID4+IFRoaXMgV0FSTl9PTl9PTkNFIHdpbGwgbmV2ZXIgYmUgdHJpZ2dlcmVkLCBzbyB5
b3UgY291bGQgcmVtb3ZlIGl0Lg0KPiA+DQo+ID4gSGUgbWVhbnQgdGhhdCB3ZSBkb24ndCBuZWVk
IHRvIGFubm90YXRlIHNxZC0+dGhyZWFkIGFjY2VzcyBpbiB0aGlzIGRlYnVnDQo+IGNoZWNrLiBU
aGUgaW9fdXJpbmdfY2FuY2VsX2dlbmVyaWMgZnVuY3Rpb24gaGFzIGFzc3VtcHRpb24gdGhhdCB0
aGUgc2dkIGlzIG5vdA0KPiBOVUxMIG9ubHkgd2hlbiBpdCdzIGNhbGxlZCBieSBhIFNRUE9MTCB0
aHJlYWQuIFNvIHRoZSBjaGVjayBtZWFucyB0byBlbnN1cmUNCj4gdGhpcyBhc3N1bXB0aW9uLiBB
IGRhdGEgcmFjZSBoYXBwZW5zIG9ubHkgd2hlbiB0aGlzIGZ1bmN0aW9uIGlzIGNhbGxlZCBieSBv
dGhlcg0KPiB0YXNrcyB0aGFuIHRoZSBTUVBPTEwgdGhyZWFkLCBzbyBpdCBjYW4gcmFjZSB3aXRo
IHRoZSBTUVBPTEwgdGVybWluYXRpb24uDQo+IEhvd2V2ZXIsIHRoZSBzZ2QgaXMgbm90IE5VTEwg
b25seSB3aGVuIHRoaXMgZnVuY3Rpb24gaXMgY2FsbGVkIGJ5IFNRUE9MTA0KPiB0aHJlYWQuIElu
IG5vcm1hbCBzaXR1YXRpb24gZm9sbG93aW5nIHRoZSBpb191cmluZ19jYW5jZWxfZ2VuZXJpYydz
IGFzc3VtcHRpb24sDQo+IHRoZSBkYXRhIHJhY2UgY2Fubm90IGhhcHBlbi4gQW5kIGluIGNhc2Ug
dGhlIGFzc3VtcHRpb24gaXMgYnJva2VuLCB0aGUNCj4gd2FybmluZyBhbG1vc3QgYWx3YXlzIGlz
IHRyaWdnZXJlZCBldmVuIGlmIGRhdGEgcmFjZSBoYXBwZW5zLiBTbyB3ZSBjYW4gaWdub3JlDQo+
IHRoZSByYWNlIGhlcmUuDQo+IA0KPiBSaWdodC4gQW5kIHRoYXQncyB0aGUgcG9pbnQgb2Ygd2Fy
bmluZ3MsIHRoZXkncmUgc3VwcG9zZWQgdG8gYmUgdW50cmlnZ2VyYWJsZSwNCj4gb3RoZXJ3aXNl
IHRoZXJlIGlzIGEgcHJvYmxlbSB3aXRoIHRoZSBjb2RlIHRoYXQgbmVlZHMgdG8gYmUgZml4ZWQu
DQoNCk9rYXksIEkgdW5kZXJzdGFuZCB0aGUgbWVhbmluZyBvZiB0aGlzIFdBUk4uDQo+IA0KPiAt
LQ0KPiBQYXZlbCBCZWd1bmtvdg0KDQotLS0NCkxpIFpldGFvDQoNCg==

