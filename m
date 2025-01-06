Return-Path: <io-uring+bounces-5678-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 781FBA02408
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 12:14:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66662163B44
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 11:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D1901DAC8E;
	Mon,  6 Jan 2025 11:14:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E442CA8
	for <io-uring@vger.kernel.org>; Mon,  6 Jan 2025 11:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736162046; cv=none; b=Wl+KtVeWjUeHhh31eMyLoKjDUOS/dpQLmYrI+UjnDGIWipsIWACRfcGOo5g6rNL/G3uBOkKxFEVSoTa2b5YPmvCPxuunUSoupReptFunqb+ixel1la6acNZm1PYuy9KyUSXjYoPtrCsi/sY40T5aVoWO6eqaFC3HJ6onfS+kO5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736162046; c=relaxed/simple;
	bh=D5aU/gnP/zNwNzXhfTL+vuxIbL0PsruSoR5AItoLIbg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GanRXrCRw+HEMrr4Py4lPmSkzDW2pyOjDhScx2nvMwkwO6Npgvn4nGIKpfRT/7Sr+SfCHeFRuaMjcdKgYUxXdhSmOOsjCdEzkQm+yCm2pzgoK4abOv3F99dARfZW6mTIPG2K1EVejqpK84d4exsEkS9ARiib+oX8XijdJ1GcuNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4YRWly0d5Lz20nhb;
	Mon,  6 Jan 2025 19:14:22 +0800 (CST)
Received: from kwepemd500010.china.huawei.com (unknown [7.221.188.84])
	by mail.maildlp.com (Postfix) with ESMTPS id C064A140135;
	Mon,  6 Jan 2025 19:13:59 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd500010.china.huawei.com (7.221.188.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 6 Jan 2025 19:13:59 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Mon, 6 Jan 2025 19:13:59 +0800
From: lizetao <lizetao1@huawei.com>
To: Pavel Begunkov <asml.silence@gmail.com>
CC: Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: RE: [PATCH 4/4] io_uring/rw: pre-mapped rw attributes
Thread-Topic: [PATCH 4/4] io_uring/rw: pre-mapped rw attributes
Thread-Index: AQHbWr7wWoh3JM7uW02tpU6pwSvT/rMJnx5w
Date: Mon, 6 Jan 2025 11:13:59 +0000
Message-ID: <e5b94e50bc9b41a9ab17161df38eadc5@huawei.com>
References: <cover.1735301337.git.asml.silence@gmail.com>
 <ea95e358ce21fe69200df6a0b1e747b8817a6ec6.1735301337.git.asml.silence@gmail.com>
In-Reply-To: <ea95e358ce21fe69200df6a0b1e747b8817a6ec6.1735301337.git.asml.silence@gmail.com>
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
b3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+DQo+IFNlbnQ6IE1vbmRheSwgRGVjZW1iZXIgMzAs
IDIwMjQgOTozMCBQTQ0KPiBUbzogaW8tdXJpbmdAdmdlci5rZXJuZWwub3JnDQo+IENjOiBhc21s
LnNpbGVuY2VAZ21haWwuY29tOyBBbnVqIEd1cHRhIDxhbnVqMjAuZ0BzYW1zdW5nLmNvbT47IEth
bmNoYW4NCj4gSm9zaGkgPGpvc2hpLmtAc2Ftc3VuZy5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCA0
LzRdIGlvX3VyaW5nL3J3OiBwcmUtbWFwcGVkIHJ3IGF0dHJpYnV0ZXMNCj4gDQo+IEluc3RlYWQg
b2YgY29weV9mcm9tX3VzZXIoKSdpbmcgcmVxdWVzdCBhdHRyaWJ1dGVzLCBhbGxvdyBpdCB0byBi
ZSBncmFiYndkDQo+IGZyb20gYSByZWdpc3RlcmVkIHByZS1yZWdpc3RlcmVkIHBhcmFtZXRlciBy
ZWdpb24gbGlrZSB3ZSBkbyB3aXRoIHJlZ2lzdGVyZWQNCj4gd2FpdCBhcmd1bWVudHMuDQo+IA0K
PiBTdWdnZXN0ZWQtYnk6IEFudWogR3VwdGEgPGFudWoyMC5nQHNhbXN1bmcuY29tPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdtYWlsLmNvbT4NCj4gLS0t
DQo+ICBpbmNsdWRlL3VhcGkvbGludXgvaW9fdXJpbmcuaCB8ICA0ICsrKy0NCj4gIGlvX3VyaW5n
L3J3LmMgICAgICAgICAgICAgICAgIHwgMTkgKysrKysrKysrKysrKystLS0tLQ0KPiAgMiBmaWxl
cyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9pb191cmluZy5oIGIvaW5jbHVkZS91YXBpL2xpbnV4
L2lvX3VyaW5nLmggaW5kZXgNCj4gMzhmMGQ2YjEwZWFmLi5lYzZlNmZkMzdkMWMgMTAwNjQ0DQo+
IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9pb191cmluZy5oDQo+ICsrKyBiL2luY2x1ZGUvdWFw
aS9saW51eC9pb191cmluZy5oDQo+IEBAIC0xMTIsNyArMTEyLDkgQEAgc3RydWN0IGlvX3VyaW5n
X3NxZSB7ICB9Ow0KPiANCj4gIC8qIHNxZS0+YXR0cl90eXBlX21hc2sgZmxhZ3MgKi8NCj4gLSNk
ZWZpbmUgSU9SSU5HX1JXX0FUVFJfRkxBR19QSQkoMVUgPDwgMCkNCj4gKyNkZWZpbmUgSU9SSU5H
X1JXX0FUVFJfRkxBR19QSQkJKDFVTCA8PCAwKQ0KPiArI2RlZmluZSBJT1JJTkdfUldfQVRUUl9S
RUdJU1RFUkVECSgxVUwgPDwgNjMpDQpXaHkgdXNlICgxVUwgPDwgNjMpIGluc3RlYWQgb2YgKDFV
TCA8PCAxKSBoZXJlPw0KPiArDQo+ICAvKiBQSSBhdHRyaWJ1dGUgaW5mb3JtYXRpb24gKi8NCj4g
IHN0cnVjdCBpb191cmluZ19hdHRyX3BpIHsNCj4gIAkJX191MTYJZmxhZ3M7DQo+IGRpZmYgLS1n
aXQgYS9pb191cmluZy9ydy5jIGIvaW9fdXJpbmcvcncuYyBpbmRleCBkYzFhY2FmOTVkYjEuLmIx
ZGI0NTk1Nzg4Yg0KPiAxMDA2NDQNCj4gLS0tIGEvaW9fdXJpbmcvcncuYw0KPiArKysgYi9pb191
cmluZy9ydy5jDQo+IEBAIC0yNzEsMTAgKzI3MSwxNyBAQCBzdGF0aWMgaW50IGlvX3ByZXBfcndf
cGkoc3RydWN0IGlvX2tpb2NiICpyZXEsIHN0cnVjdA0KPiBpb19ydyAqcncsIGludCBkZGlyLA0K
PiAgCXNpemVfdCBwaV9sZW47DQo+ICAJaW50IHJldDsNCj4gDQo+IC0JaWYgKGNvcHlfZnJvbV91
c2VyKCZfX3BpX2F0dHIsIHU2NF90b191c2VyX3B0cihhdHRyX3B0ciksDQo+IC0JICAgIHNpemVv
ZihwaV9hdHRyKSkpDQo+IC0JCXJldHVybiAtRUZBVUxUOw0KPiAtCXBpX2F0dHIgPSAmX19waV9h
dHRyOw0KPiArCWlmIChhdHRyX3R5cGVfbWFzayAmIElPUklOR19SV19BVFRSX1JFR0lTVEVSRUQp
IHsNCj4gKwkJcGlfYXR0ciA9IGlvX2FyZ3NfZ2V0X3B0cigmcmVxLT5jdHgtPnNxZV9hcmdzLCBh
dHRyX3B0ciwNCj4gKwkJCQkJICBzaXplb2YocGlfYXR0cikpOw0KSGVyZSBwaV9hdHRyIGlzIGp1
c3QgcG9pbnRlciwgc28gbWF5YmUgc2l6ZW9mKF9fcGlfYXR0cikgb3Igc2l6ZW9mKHN0cnVjdCBp
b191cmluZ19hdHRyX3BpKSB3aWxsIGJlIGJldHRlci4NCj4gKwkJaWYgKElTX0VSUihwaV9hdHRy
KSkNCj4gKwkJCXJldHVybiBQVFJfRVJSKHBpX2F0dHIpOw0KPiArCX0gZWxzZSB7DQo+ICsJCWlm
IChjb3B5X2Zyb21fdXNlcigmX19waV9hdHRyLCB1NjRfdG9fdXNlcl9wdHIoYXR0cl9wdHIpLA0K
PiArCQkgICAgc2l6ZW9mKHBpX2F0dHIpKSkNCkp1c3QgbGlrZSBhYm92ZSwgc2hvdWxlIGJlIHNp
emVvZihzdHJ1Y3QgaW9fdXJpbmdfYXR0cl9waSkgaGVyZS4NCj4gKwkJCXJldHVybiAtRUZBVUxU
Ow0KPiArCQlwaV9hdHRyID0gJl9fcGlfYXR0cjsNCj4gKwl9DQo+IA0KPiAgCWlmIChwaV9hdHRy
LT5yc3ZkKQ0KPiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gQEAgLTI5NCw2ICszMDEsOCBAQCBzdGF0
aWMgaW50IGlvX3ByZXBfcndfcGkoc3RydWN0IGlvX2tpb2NiICpyZXEsIHN0cnVjdA0KPiBpb19y
dyAqcncsIGludCBkZGlyLA0KPiAgCXJldHVybiByZXQ7DQo+ICB9DQo+IA0KPiArI2RlZmluZSBJ
T19SV19BVFRSX0FMTE9XRURfTUFTSyAoSU9SSU5HX1JXX0FUVFJfRkxBR19QSSB8DQo+ICtJT1JJ
TkdfUldfQVRUUl9SRUdJU1RFUkVEKQ0KPiArDQo+ICBzdGF0aWMgaW50IGlvX3ByZXBfcncoc3Ry
dWN0IGlvX2tpb2NiICpyZXEsIGNvbnN0IHN0cnVjdCBpb191cmluZ19zcWUgKnNxZSwNCj4gIAkJ
ICAgICAgaW50IGRkaXIsIGJvb2wgZG9faW1wb3J0KQ0KPiAgew0KPiBAQCAtMzMyLDcgKzM0MSw3
IEBAIHN0YXRpYyBpbnQgaW9fcHJlcF9ydyhzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgY29uc3Qgc3Ry
dWN0DQo+IGlvX3VyaW5nX3NxZSAqc3FlLA0KPiAgCQl1NjQgYXR0cl9wdHI7DQo+IA0KPiAgCQkv
KiBvbmx5IFBJIGF0dHJpYnV0ZSBpcyBzdXBwb3J0ZWQgY3VycmVudGx5ICovDQo+IC0JCWlmIChh
dHRyX3R5cGVfbWFzayAhPSBJT1JJTkdfUldfQVRUUl9GTEFHX1BJKQ0KVGhlIGNvbW1lbnQgbmVl
ZHMgdG8gYmUgYWRqdXN0ZWQuDQo+ICsJCWlmIChhdHRyX3R5cGVfbWFzayAmIElPX1JXX0FUVFJf
QUxMT1dFRF9NQVNLKQ0KSGVyZSBzaG91bGQgYmUgYXR0cl90eXBlX21hc2sgJiB+SU9fUldfQVRU
Ul9BTExPV0VEX01BU0sgPw0KPiAgCQkJcmV0dXJuIC1FSU5WQUw7DQo+IA0KPiAgCQlhdHRyX3B0
ciA9IFJFQURfT05DRShzcWUtPmF0dHJfcHRyKTsNCj4gLS0NCj4gMi40Ny4xDQo+IA0KDQotLQ0K
TGkgWmV0YW8NCg0K

