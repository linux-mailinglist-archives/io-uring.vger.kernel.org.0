Return-Path: <io-uring+bounces-5778-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C2FFA06C5C
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 04:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D93C3A74D8
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 03:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C98136327;
	Thu,  9 Jan 2025 03:40:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0281813B7AE
	for <io-uring@vger.kernel.org>; Thu,  9 Jan 2025 03:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736394040; cv=none; b=Y/GEkqep05UyqmwJ4O7UFUnFcE0ZSTtCeVhzKrZt1hxgeN+/ZVhV6gAVWUTE9UV2L8Hn17VERGMOe3jnSgkDYOAn8IurRhScnM/KNb7ITceqNDvFsCawUFm+ssDEQRHkRpzRnbUAwsVAJBqPpdvkmdbIO0dJCQ3Z9wsEYyMFniQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736394040; c=relaxed/simple;
	bh=F0NKAYRusgvE1rNwXBhC/7b7Zz+iwvOaAppVLv5unmM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PZgB+wv5740Or8RfUOzgV8+IRiBY5JSPrRWYZV8qpu+9LDCR2PAbSTx5mrjB8CLFXyQCIHHQnOs2ScIcVYIchcG5225JlwnQmlWphPG8vPKR1alFO4pgIoJ/yytRXDGQRrAsMzLI2hAUlHLqkpgkC85Tr8t4hYUQdK7lxaejr/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YT9X53CMtz1JHJb;
	Thu,  9 Jan 2025 11:39:49 +0800 (CST)
Received: from kwepemd500010.china.huawei.com (unknown [7.221.188.84])
	by mail.maildlp.com (Postfix) with ESMTPS id 876E91A0188;
	Thu,  9 Jan 2025 11:40:35 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd500010.china.huawei.com (7.221.188.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 9 Jan 2025 11:40:35 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Thu, 9 Jan 2025 11:40:35 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>
CC: io-uring <io-uring@vger.kernel.org>
Subject: RE: [PATCH] io_uring/eventfd: ensure io_eventfd_signal() defers
 another RCU period
Thread-Topic: [PATCH] io_uring/eventfd: ensure io_eventfd_signal() defers
 another RCU period
Thread-Index: AQHbYib+SUr4irNljUW7eN796cnLHbMNy+bw
Date: Thu, 9 Jan 2025 03:40:35 +0000
Message-ID: <1722809acef1438fb99fb8b4ab435039@huawei.com>
References: <7812ebd4-674f-4ad7-8c13-401684e8099b@kernel.dk>
In-Reply-To: <7812ebd4-674f-4ad7-8c13-401684e8099b@kernel.dk>
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

SGksDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEplbnMgQXhib2UgPGF4
Ym9lQGtlcm5lbC5kaz4NCj4gU2VudDogVGh1cnNkYXksIEphbnVhcnkgOSwgMjAyNSA3OjQyIEFN
DQo+IFRvOiBpby11cmluZyA8aW8tdXJpbmdAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBb
UEFUQ0hdIGlvX3VyaW5nL2V2ZW50ZmQ6IGVuc3VyZSBpb19ldmVudGZkX3NpZ25hbCgpIGRlZmVy
cyBhbm90aGVyDQo+IFJDVSBwZXJpb2QNCj4gDQo+IGlvX2V2ZW50ZmRfZG9fc2lnbmFsKCkgaXMg
aW52b2tlZCBmcm9tIGFuIFJDVSBjYWxsYmFjaywgYnV0IHdoZW4gZHJvcHBpbmcgdGhlDQo+IHJl
ZmVyZW5jZSB0byB0aGUgaW9fZXZfZmQsIGl0IGNhbGxzIGlvX2V2ZW50ZmRfZnJlZSgpIGRpcmVj
dGx5IGlmIHRoZSByZWZjb3VudA0KPiBkcm9wcyB0byB6ZXJvLiBUaGlzIGlzbid0IGNvcnJlY3Qs
IGFzIGFueSBwb3RlbnRpYWwgZnJlZWluZyBvZiB0aGUgaW9fZXZfZmQgc2hvdWxkDQo+IGJlIGRl
ZmVycmVkIGFub3RoZXIgUkNVIGdyYWNlIHBlcmlvZC4NCj4gDQo+IEp1c3QgY2FsbCBpb19ldmVu
dGZkX3B1dCgpIHJhdGhlciB0aGFuIG9wZW4tY29kZSB0aGUgZGVjLWFuZC10ZXN0IGFuZCBmcmVl
LA0KPiB3aGljaCB3aWxsIGNvcnJlY3RseSBkZWZlciBpdCBhbm90aGVyIFJDVSBncmFjZSBwZXJp
b2QuDQo+IA0KPiBGaXhlczogMjFhMDkxYjk3MGNkICgiaW9fdXJpbmc6IHNpZ25hbCByZWdpc3Rl
cmVkIGV2ZW50ZmQgdG8gcHJvY2VzcyBkZWZlcnJlZA0KPiB0YXNrIHdvcmsiKQ0KPiBSZXBvcnRl
ZC1ieTogSmFubiBIb3JuIDxqYW5uaEBnb29nbGUuY29tPg0KPiBDYzogc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+
IA0KPiAtLS0NCj4gDQo+IGRpZmYgLS1naXQgYS9pb191cmluZy9ldmVudGZkLmMgYi9pb191cmlu
Zy9ldmVudGZkLmMgaW5kZXgNCj4gZmFiOTM2ZDMxYmE4Li4xMDBkNWRhOTRjYjkgMTAwNjQ0DQo+
IC0tLSBhL2lvX3VyaW5nL2V2ZW50ZmQuYw0KPiArKysgYi9pb191cmluZy9ldmVudGZkLmMNCj4g
QEAgLTMzLDIwICszMywxOCBAQCBzdGF0aWMgdm9pZCBpb19ldmVudGZkX2ZyZWUoc3RydWN0IHJj
dV9oZWFkICpyY3UpDQo+ICAJa2ZyZWUoZXZfZmQpOw0KPiAgfQ0KPiANCj4gLXN0YXRpYyB2b2lk
IGlvX2V2ZW50ZmRfZG9fc2lnbmFsKHN0cnVjdCByY3VfaGVhZCAqcmN1KQ0KPiArc3RhdGljIHZv
aWQgaW9fZXZlbnRmZF9wdXQoc3RydWN0IGlvX2V2X2ZkICpldl9mZCkNCj4gIHsNCj4gLQlzdHJ1
Y3QgaW9fZXZfZmQgKmV2X2ZkID0gY29udGFpbmVyX29mKHJjdSwgc3RydWN0IGlvX2V2X2ZkLCBy
Y3UpOw0KPiAtDQo+IC0JZXZlbnRmZF9zaWduYWxfbWFzayhldl9mZC0+Y3FfZXZfZmQsIEVQT0xM
X1VSSU5HX1dBS0UpOw0KPiAtDQo+ICAJaWYgKHJlZmNvdW50X2RlY19hbmRfdGVzdCgmZXZfZmQt
PnJlZnMpKQ0KPiAtCQlpb19ldmVudGZkX2ZyZWUocmN1KTsNCj4gKwkJY2FsbF9yY3UoJmV2X2Zk
LT5yY3UsIGlvX2V2ZW50ZmRfZnJlZSk7DQo+ICB9DQo+IA0KPiAtc3RhdGljIHZvaWQgaW9fZXZl
bnRmZF9wdXQoc3RydWN0IGlvX2V2X2ZkICpldl9mZCkNCj4gK3N0YXRpYyB2b2lkIGlvX2V2ZW50
ZmRfZG9fc2lnbmFsKHN0cnVjdCByY3VfaGVhZCAqcmN1KQ0KPiAgew0KPiAtCWlmIChyZWZjb3Vu
dF9kZWNfYW5kX3Rlc3QoJmV2X2ZkLT5yZWZzKSkNCj4gLQkJY2FsbF9yY3UoJmV2X2ZkLT5yY3Us
IGlvX2V2ZW50ZmRfZnJlZSk7DQo+ICsJc3RydWN0IGlvX2V2X2ZkICpldl9mZCA9IGNvbnRhaW5l
cl9vZihyY3UsIHN0cnVjdCBpb19ldl9mZCwgcmN1KTsNCj4gKw0KPiArCWV2ZW50ZmRfc2lnbmFs
X21hc2soZXZfZmQtPmNxX2V2X2ZkLCBFUE9MTF9VUklOR19XQUtFKTsNCj4gKwlpb19ldmVudGZk
X3B1dChldl9mZCk7DQo+ICB9DQo+IA0KPiAgc3RhdGljIHZvaWQgaW9fZXZlbnRmZF9yZWxlYXNl
KHN0cnVjdCBpb19ldl9mZCAqZXZfZmQsIGJvb2wgcHV0X3JlZikNCj4gDQo+IC0tDQo+IEplbnMg
QXhib2UNCj4gDQo+IA0KDQpUZXN0ZWQtYnk6IExpIFpldGFvIDxsaXpldGFvMUBodWF3ZWkuY29t
Pg0KUmV2aWV3ZWQtYnk6IExpIFpldGFvPGxpemV0YW8xQGh1YXdlaS5jb20+DQoNCi0tLQ0KTGkg
WmV0YW8NCg0K

