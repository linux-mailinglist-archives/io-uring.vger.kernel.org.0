Return-Path: <io-uring+bounces-6127-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D5CA1C20D
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 08:17:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4E083A6754
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 07:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C66371547F3;
	Sat, 25 Jan 2025 07:17:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D71241A8F
	for <io-uring@vger.kernel.org>; Sat, 25 Jan 2025 07:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737789439; cv=none; b=tRSjZhN/3cgyPqogX2S0dvd888XpUFrEC6xEYof8Ij1N6mabdkYfARKTKm2Q356DyTadWjj1RAfhkBGn3oHiyTRW/U4ruCVK5dEO3ImbOCFvHdFyVhufBLPgOhr/7vFXsVV9BTGH+DZZBjotE/s3kUO4eEce7hdA8Il5GivVcak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737789439; c=relaxed/simple;
	bh=QqpdunPlgtsU9E0DmfsAGUrW2EEOmAgPkm01H78Wze4=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cUGDceSaz8JTXKoX9T3BuSVKiOnz3hqWgbHN8Di37GaTm584HmIHulFTGhAuTrWhd/frrwtKdF8sMmQy861qcoqBqOS5Emkt7aiGjVjXZawWDEdw1FOx1qiAWCGEZxDdYC420FHWnm1DYxgE54Cd/VUb7YG+DMwq1WKWf23sGWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Yg5YX2yBvzrShq;
	Sat, 25 Jan 2025 15:15:28 +0800 (CST)
Received: from kwepemd100012.china.huawei.com (unknown [7.221.188.214])
	by mail.maildlp.com (Postfix) with ESMTPS id B49BB180101;
	Sat, 25 Jan 2025 15:17:06 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100012.china.huawei.com (7.221.188.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 25 Jan 2025 15:17:06 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Sat, 25 Jan 2025 15:17:06 +0800
From: lizetao <lizetao1@huawei.com>
To: Sidong Yang <sidong.yang@furiosa.ai>, io-uring <io-uring@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: RE: [PATCH v2] io_uring/futex: Factor out common free logic into
 io_free_ifd()
Thread-Topic: [PATCH v2] io_uring/futex: Factor out common free logic into
 io_free_ifd()
Thread-Index: AQHbbncNHOtHqg8Zo0iVdO2QEuqJDrMnFBFA
Date: Sat, 25 Jan 2025 07:17:06 +0000
Message-ID: <f6b930ef687c4f0d895fcf019fc56eaf@huawei.com>
References: <20250124154344.6928-1-sidong.yang@furiosa.ai>
In-Reply-To: <20250124154344.6928-1-sidong.yang@furiosa.ai>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2lkb25nIFlhbmcg
PHNpZG9uZy55YW5nQGZ1cmlvc2EuYWk+DQo+IFNlbnQ6IEZyaWRheSwgSmFudWFyeSAyNCwgMjAy
NSAxMTo0NCBQTQ0KPiBUbzogaW8tdXJpbmcgPGlvLXVyaW5nQHZnZXIua2VybmVsLm9yZz47IEpl
bnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4NCj4gQ2M6IFNpZG9uZyBZYW5nIDxzaWRvbmcueWFu
Z0BmdXJpb3NhLmFpPg0KPiBTdWJqZWN0OiBbUEFUQ0ggdjJdIGlvX3VyaW5nL2Z1dGV4OiBGYWN0
b3Igb3V0IGNvbW1vbiBmcmVlIGxvZ2ljIGludG8NCj4gaW9fZnJlZV9pZmQoKQ0KPiANCj4gVGhp
cyBwYXRjaCBpbnRyb2R1Y2VzIGlvX2ZyZWVfaWZkKCkgdGhhdCB0cnkgdG8gY2FjaGUgb3IgZnJl
ZSBpb19mdXRleF9kYXRhLiBJdA0KPiBjb3VsZCBiZSB1c2VkIGZvciBjb21wbGV0aW9uLiBJdCBh
bHNvIGNvdWxkIGJlIHVzZWQgZm9yIGVycm9yIHBhdGggaW4NCj4gaW9fZnV0ZXhfd2FpdCgpLiBP
bGQgY29kZSBqdXN0IHJlbGVhc2UgdGhlIGlmZCBidXQgaXQgY291bGQgYmUgY2FjaGVkLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogU2lkb25nIFlhbmcgPHNpZG9uZy55YW5nQGZ1cmlvc2EuYWk+DQo+
IC0tLQ0KPiB2MjogdXNlIGlvX2ZyZWVfaWZkKCkgZm9yIGNvbXBsZXRpb24NCj4gLS0tDQo+ICBp
b191cmluZy9mdXRleC5jIHwgMTIgKysrKysrKysrLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgOSBp
bnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2lvX3VyaW5n
L2Z1dGV4LmMgYi9pb191cmluZy9mdXRleC5jIGluZGV4DQo+IGUyOTY2MmYwMzllMS4uOTRhNzE1
OWY5Y2ZmIDEwMDY0NA0KPiAtLS0gYS9pb191cmluZy9mdXRleC5jDQo+ICsrKyBiL2lvX3VyaW5n
L2Z1dGV4LmMNCj4gQEAgLTQ0LDYgKzQ0LDEzIEBAIHZvaWQgaW9fZnV0ZXhfY2FjaGVfZnJlZShz
dHJ1Y3QgaW9fcmluZ19jdHggKmN0eCkNCj4gIAlpb19hbGxvY19jYWNoZV9mcmVlKCZjdHgtPmZ1
dGV4X2NhY2hlLCBrZnJlZSk7ICB9DQo+IA0KPiArc3RhdGljIHZvaWQgaW9fZnJlZV9pZmQoc3Ry
dWN0IGlvX3JpbmdfY3R4ICpjdHgsIHN0cnVjdCBpb19mdXRleF9kYXRhDQo+ICsqaWZkKSB7DQo+
ICsJaWYgKCFpb19hbGxvY19jYWNoZV9wdXQoJmN0eC0+ZnV0ZXhfY2FjaGUsIGlmZCkpIHsNCj4g
KwkJa2ZyZWUoaWZkKTsNCj4gKwl9DQo+ICt9DQoNCmlubGluZSBzdGF0aWMgdm9pZCBpb19mcmVl
X2lmZChzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgc3RydWN0IGlvX2Z1dGV4X2RhdGEgKmlmZCkN
CnsNCglpZiAoIWlvX2FsbG9jX2NhY2hlX3B1dCgmY3R4LT5mdXRleF9jYWNoZSwgaWZkKSkNCgkJ
a2ZyZWUoaWZkKTsNCn0NCg0KTWF5YmUgaW5saW5lIGZ1bmN0aW9uIHdvdWxkIGJlIGJldHRlciBo
ZXJlLCBhbmQgdGhlIGNvZGUgZm9ybWF0IG5lZWRzIHRvIGJlIGZpbmUtdHVuZWQuDQoNCj4gKw0K
PiAgc3RhdGljIHZvaWQgX19pb19mdXRleF9jb21wbGV0ZShzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwg
c3RydWN0IGlvX3R3X3N0YXRlICp0cykgIHsNCj4gIAlyZXEtPmFzeW5jX2RhdGEgPSBOVUxMOw0K
PiBAQCAtNTcsOCArNjQsNyBAQCBzdGF0aWMgdm9pZCBpb19mdXRleF9jb21wbGV0ZShzdHJ1Y3Qg
aW9fa2lvY2IgKnJlcSwgc3RydWN0DQo+IGlvX3R3X3N0YXRlICp0cykNCj4gIAlzdHJ1Y3QgaW9f
cmluZ19jdHggKmN0eCA9IHJlcS0+Y3R4Ow0KPiANCj4gIAlpb190d19sb2NrKGN0eCwgdHMpOw0K
PiAtCWlmICghaW9fYWxsb2NfY2FjaGVfcHV0KCZjdHgtPmZ1dGV4X2NhY2hlLCBpZmQpKQ0KPiAt
CQlrZnJlZShpZmQpOw0KPiArCWlvX2ZyZWVfaWZkKGN0eCwgaWZkKTsNCj4gIAlfX2lvX2Z1dGV4
X2NvbXBsZXRlKHJlcSwgdHMpOw0KPiAgfQ0KPiANCj4gQEAgLTM1MywxMyArMzU5LDEzIEBAIGlu
dCBpb19mdXRleF93YWl0KHN0cnVjdCBpb19raW9jYiAqcmVxLCB1bnNpZ25lZCBpbnQNCj4gaXNz
dWVfZmxhZ3MpDQo+ICAJCXJldHVybiBJT1VfSVNTVUVfU0tJUF9DT01QTEVURTsNCj4gIAl9DQo+
IA0KPiArCWlvX2ZyZWVfaWZkKGN0eCwgaWZkKTsNCj4gIGRvbmVfdW5sb2NrOg0KPiAgCWlvX3Jp
bmdfc3VibWl0X3VubG9jayhjdHgsIGlzc3VlX2ZsYWdzKTsNCj4gIGRvbmU6DQo+ICAJaWYgKHJl
dCA8IDApDQo+ICAJCXJlcV9zZXRfZmFpbChyZXEpOw0KPiAgCWlvX3JlcV9zZXRfcmVzKHJlcSwg
cmV0LCAwKTsNCj4gLQlrZnJlZShpZmQpOw0KDQpTaW5jZSBrZnJlZSgpIGlzIGRlbGV0ZWQsIGl0
IGlzIHJlZHVuZGFudCB0byBpbml0aWFsaXplIGlmZCB0byBOVUxMLiBZb3UgY2FuIGNvbnNpZGVy
IG1vZGlmeWluZyBpdCBsaWtlIHRoaXM6DQotICAgICAgIHN0cnVjdCBpb19mdXRleF9kYXRhICpp
ZmQgPSBOVUxMOw0KICAgICAgICBzdHJ1Y3QgZnV0ZXhfaGFzaF9idWNrZXQgKmhiOw0KKyAgICAg
ICBzdHJ1Y3QgaW9fZnV0ZXhfZGF0YSAqaWZkOw0KDQo+ICAJcmV0dXJuIElPVV9PSzsNCj4gIH0N
Cj4gDQo+IC0tDQo+IDIuNDMuMA0KPiANCg0KLS0NCkxpIFpldGFvDQoNCg==

