Return-Path: <io-uring+bounces-5949-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A09A8A147A7
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:40:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 141163A624A
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 01:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD76133062;
	Fri, 17 Jan 2025 01:40:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F147FBA2
	for <io-uring@vger.kernel.org>; Fri, 17 Jan 2025 01:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737078030; cv=none; b=Yi1ts9dLnryfh0ZlUzpRs99GKlsJqrUyCLdSpHhgwIIcGGzDpcs5rf2IUTJy/Z0OZ38W9YTAOrxh08ffVdlNlctr6ohFtrxYQ1/aKwXA2XXtziQq8aXFyiCZolFj6TvKmKk7aBeG7PvScKHB+3w7XbimxhGCoMNPBFlWROL6IJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737078030; c=relaxed/simple;
	bh=cf2FSfurwYfEUZzr8qcwxhirTPEqJKCbXvo2ouZ6ci8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X5bAe4QO3TFOOaJRjCjf3OlTApYsjo6gWZbHH5UJyOl5xvag8Y1q5cWmn6ZK3mR6rrt7qxFFvrO/gR5gWEnhFiYej0uF36cjwvkIbcwSxHsjyjNA2K1SI8w5YnaSHFE40z9El/JZGBgSo02xjKV+mKvMtKQv+hUH29ENg9jYqFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4YZ2W46BC9z20p1F;
	Fri, 17 Jan 2025 09:40:48 +0800 (CST)
Received: from kwepemd200012.china.huawei.com (unknown [7.221.188.145])
	by mail.maildlp.com (Postfix) with ESMTPS id 79EE91401F3;
	Fri, 17 Jan 2025 09:40:24 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200012.china.huawei.com (7.221.188.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 17 Jan 2025 09:40:24 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Fri, 17 Jan 2025 09:40:24 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: RE: [PATCH 1/1] io_uring: clean up io_uring_register_get_file()
Thread-Topic: [PATCH 1/1] io_uring: clean up io_uring_register_get_file()
Thread-Index: AQHbZ8HH3VRcq8Oa/0mmwg6MNUJV77MZX/EA//+LJ4CAAUbBIA==
Date: Fri, 17 Jan 2025 01:40:23 +0000
Message-ID: <2e706fca1404496aae045f599637bb5a@huawei.com>
References: <0d0b13a63e8edd6b5d360fc821dcdb035cb6b7e0.1736995897.git.asml.silence@gmail.com>
 <5c2d3f69cb7c48d48b33c1a84dddaa8c@huawei.com>
 <eb0fb2c4-bf88-4fa8-bbe3-4eca830606aa@kernel.dk>
In-Reply-To: <eb0fb2c4-bf88-4fa8-bbe3-4eca830606aa@kernel.dk>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmVucyBBeGJvZSA8
YXhib2VAa2VybmVsLmRrPg0KPiBTZW50OiBUaHVyc2RheSwgSmFudWFyeSAxNiwgMjAyNSAxMDox
MCBQTQ0KPiBUbzogbGl6ZXRhbyA8bGl6ZXRhbzFAaHVhd2VpLmNvbT47IFBhdmVsIEJlZ3Vua292
IDxhc21sLnNpbGVuY2VAZ21haWwuY29tPg0KPiBDYzogaW8tdXJpbmdAdmdlci5rZXJuZWwub3Jn
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8xXSBpb191cmluZzogY2xlYW4gdXAgaW9fdXJpbmdf
cmVnaXN0ZXJfZ2V0X2ZpbGUoKQ0KPiANCj4gT24gMS8xNi8yNSA2OjA5IEFNLCBsaXpldGFvIHdy
b3RlOg0KPiA+IEhpLA0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+
IEZyb206IFBhdmVsIEJlZ3Vua292IDxhc21sLnNpbGVuY2VAZ21haWwuY29tPg0KPiA+PiBTZW50
OiBUaHVyc2RheSwgSmFudWFyeSAxNiwgMjAyNSAxMDo1MyBBTQ0KPiA+PiBUbzogaW8tdXJpbmdA
dmdlci5rZXJuZWwub3JnDQo+ID4+IENjOiBhc21sLnNpbGVuY2VAZ21haWwuY29tDQo+ID4+IFN1
YmplY3Q6IFtQQVRDSCAxLzFdIGlvX3VyaW5nOiBjbGVhbiB1cCBpb191cmluZ19yZWdpc3Rlcl9n
ZXRfZmlsZSgpDQo+ID4+DQo+ID4+IE1ha2UgaXQgYWx3YXlzIHJlZmVyZW5jZSB0aGUgcmV0dXJu
ZWQgZmlsZS4gSXQncyBzYWZlciwgZXNwZWNpYWxseQ0KPiA+PiB3aXRoIHVucmVnaXN0cmF0aW9u
cyBoYXBwZW5pbmcgdW5kZXIgaXQuIEFuZCBpdCBtYWtlcyB0aGUgYXBpIGNsZWFuZXINCj4gPj4g
d2l0aCBubyBjb25kaXRpb25hbCBjbGVhbiB1cHMgYnkgdGhlIGNhbGxlci4NCj4gPj4NCj4gPj4g
U2lnbmVkLW9mZi1ieTogUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+DQo+
ID4+IC0tLQ0KPiA+PiAgaW9fdXJpbmcvcmVnaXN0ZXIuYyB8IDYgKysrKy0tDQo+ID4+ICBpb191
cmluZy9yc3JjLmMgICAgIHwgNCArKy0tDQo+ID4+ICAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gPj4NCj4gPj4gZGlmZiAtLWdpdCBhL2lvX3VyaW5n
L3JlZ2lzdGVyLmMgYi9pb191cmluZy9yZWdpc3Rlci5jIGluZGV4DQo+ID4+IDVlNDg0MTM3MDZh
Yy4uYTkzYzk3OWMyZjM4IDEwMDY0NA0KPiA+PiAtLS0gYS9pb191cmluZy9yZWdpc3Rlci5jDQo+
ID4+ICsrKyBiL2lvX3VyaW5nL3JlZ2lzdGVyLmMNCj4gPj4gQEAgLTg0MSw2ICs4NDEsOCBAQCBz
dHJ1Y3QgZmlsZSAqaW9fdXJpbmdfcmVnaXN0ZXJfZ2V0X2ZpbGUodW5zaWduZWQNCj4gPj4gaW50
IGZkLCBib29sIHJlZ2lzdGVyZWQpDQo+ID4+ICAJCQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsN
Cj4gPj4gIAkJZmQgPSBhcnJheV9pbmRleF9ub3NwZWMoZmQsIElPX1JJTkdGRF9SRUdfTUFYKTsN
Cj4gPj4gIAkJZmlsZSA9IHRjdHgtPnJlZ2lzdGVyZWRfcmluZ3NbZmRdOw0KPiA+PiArCQlpZiAo
ZmlsZSkNCj4gPj4gKwkJCWdldF9maWxlKGZpbGUpOw0KPiA+DQo+ID4gU2hvdWxkIHBlcmZvcm1h
bmNlIGJlIGEgcHJpb3JpdHkgaGVyZT8NCj4gDQo+IFBlcmZvcm1hbmNlIG9ubHkgcmVhbGx5IG1h
dHRlcnMgZm9yIGhpZ2ggZnJlcXVlbmN5IGludm9jYXRpb25zLCBvZiB3aGljaCB0aGUNCj4gcmVn
aXN0ZXIgcGFydCBpcyBub3QuIFNvIG5vLCBzaG91bGQgbm90IG1hdHRlciBhdCBhbGwuDQpPay4g
SSBnb3QgaXQuDQoNClRlc3RlZC1ieTogTGkgWmV0YW8gPGxpemV0YW8xQGh1YXdlaS5jb20+DQpS
ZXZpZXdlZC1ieTogTGkgWmV0YW8gPGxpemV0YW8xQGh1YXdlaS5jb20+DQo+IA0KPiAtLQ0KPiBK
ZW5zIEF4Ym9lDQoNCi0tLQ0KTGkgWmV0YW8NCg==

