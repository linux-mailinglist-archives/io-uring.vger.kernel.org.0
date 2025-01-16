Return-Path: <io-uring+bounces-5916-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB564A13A87
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 14:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 149E73A0581
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 13:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392B31E98FE;
	Thu, 16 Jan 2025 13:09:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDBE1DE4DF
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 13:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737032987; cv=none; b=pvpKbpzKdxJqMZpXk0lptI50xoCwZKKmjOmxClHEXpNXgue4AwiAnTIILcpY4BqH717+dA1O7U/hI4lvfDU4uaIB+X1xkSAWonTOUHU8FGTOm4834zzsKwij7rFh1qCPPk7r83YKsKvGoIDUYy1Z0l1bG4FoYQCbh7gW5NwKe9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737032987; c=relaxed/simple;
	bh=at7XW0yItEMdQHkUb15Up9RzkB4xonyajFGgIzESR0E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KEMmWXnOtHHnkLU/pio+1P0QtxwhAx9cBIGaKnNtVtDNNjhGhFFiYlJ6yBtx+g+VXI0j0uo4iH2FzAJJPYrEV7lxR26nJUMJHIMDFxh4NTBGeWnfC7UtB24/YY68J/rMdybHvtbl9bNPGtkTT4CDoWV4G78vyu2rHt+BDNfT5Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4YYjrm39WMz20nyG;
	Thu, 16 Jan 2025 21:10:00 +0800 (CST)
Received: from kwepemd500011.china.huawei.com (unknown [7.221.188.45])
	by mail.maildlp.com (Postfix) with ESMTPS id 2DC701A0188;
	Thu, 16 Jan 2025 21:09:36 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd500011.china.huawei.com (7.221.188.45) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 16 Jan 2025 21:09:35 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Thu, 16 Jan 2025 21:09:35 +0800
From: lizetao <lizetao1@huawei.com>
To: Pavel Begunkov <asml.silence@gmail.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Subject: RE: [PATCH 1/1] io_uring: clean up io_uring_register_get_file()
Thread-Topic: [PATCH 1/1] io_uring: clean up io_uring_register_get_file()
Thread-Index: AQHbZ8HH3VRcq8Oa/0mmwg6MNUJV77MZX/EA
Date: Thu, 16 Jan 2025 13:09:35 +0000
Message-ID: <5c2d3f69cb7c48d48b33c1a84dddaa8c@huawei.com>
References: <0d0b13a63e8edd6b5d360fc821dcdb035cb6b7e0.1736995897.git.asml.silence@gmail.com>
In-Reply-To: <0d0b13a63e8edd6b5d360fc821dcdb035cb6b7e0.1736995897.git.asml.silence@gmail.com>
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
b3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBKYW51YXJ5IDE2
LCAyMDI1IDEwOjUzIEFNDQo+IFRvOiBpby11cmluZ0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGFz
bWwuc2lsZW5jZUBnbWFpbC5jb20NCj4gU3ViamVjdDogW1BBVENIIDEvMV0gaW9fdXJpbmc6IGNs
ZWFuIHVwIGlvX3VyaW5nX3JlZ2lzdGVyX2dldF9maWxlKCkNCj4gDQo+IE1ha2UgaXQgYWx3YXlz
IHJlZmVyZW5jZSB0aGUgcmV0dXJuZWQgZmlsZS4gSXQncyBzYWZlciwgZXNwZWNpYWxseSB3aXRo
DQo+IHVucmVnaXN0cmF0aW9ucyBoYXBwZW5pbmcgdW5kZXIgaXQuIEFuZCBpdCBtYWtlcyB0aGUg
YXBpIGNsZWFuZXIgd2l0aCBubw0KPiBjb25kaXRpb25hbCBjbGVhbiB1cHMgYnkgdGhlIGNhbGxl
ci4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBhdmVsIEJlZ3Vua292IDxhc21sLnNpbGVuY2VAZ21h
aWwuY29tPg0KPiAtLS0NCj4gIGlvX3VyaW5nL3JlZ2lzdGVyLmMgfCA2ICsrKystLQ0KPiAgaW9f
dXJpbmcvcnNyYy5jICAgICB8IDQgKystLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlv
bnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvcmVnaXN0
ZXIuYyBiL2lvX3VyaW5nL3JlZ2lzdGVyLmMgaW5kZXgNCj4gNWU0ODQxMzcwNmFjLi5hOTNjOTc5
YzJmMzggMTAwNjQ0DQo+IC0tLSBhL2lvX3VyaW5nL3JlZ2lzdGVyLmMNCj4gKysrIGIvaW9fdXJp
bmcvcmVnaXN0ZXIuYw0KPiBAQCAtODQxLDYgKzg0MSw4IEBAIHN0cnVjdCBmaWxlICppb191cmlu
Z19yZWdpc3Rlcl9nZXRfZmlsZSh1bnNpZ25lZCBpbnQgZmQsDQo+IGJvb2wgcmVnaXN0ZXJlZCkN
Cj4gIAkJCXJldHVybiBFUlJfUFRSKC1FSU5WQUwpOw0KPiAgCQlmZCA9IGFycmF5X2luZGV4X25v
c3BlYyhmZCwgSU9fUklOR0ZEX1JFR19NQVgpOw0KPiAgCQlmaWxlID0gdGN0eC0+cmVnaXN0ZXJl
ZF9yaW5nc1tmZF07DQo+ICsJCWlmIChmaWxlKQ0KPiArCQkJZ2V0X2ZpbGUoZmlsZSk7DQoNClNo
b3VsZCBwZXJmb3JtYW5jZSBiZSBhIHByaW9yaXR5IGhlcmU/DQo+ICAJfSBlbHNlIHsNCj4gIAkJ
ZmlsZSA9IGZnZXQoZmQpOw0KPiAgCX0NCj4gQEAgLTkwNyw3ICs5MDksNyBAQCBTWVNDQUxMX0RF
RklORTQoaW9fdXJpbmdfcmVnaXN0ZXIsIHVuc2lnbmVkIGludCwgZmQsDQo+IHVuc2lnbmVkIGlu
dCwgb3Bjb2RlLA0KPiAgCXRyYWNlX2lvX3VyaW5nX3JlZ2lzdGVyKGN0eCwgb3Bjb2RlLCBjdHgt
PmZpbGVfdGFibGUuZGF0YS5uciwNCj4gIAkJCQljdHgtPmJ1Zl90YWJsZS5uciwgcmV0KTsNCj4g
IAltdXRleF91bmxvY2soJmN0eC0+dXJpbmdfbG9jayk7DQo+IC0JaWYgKCF1c2VfcmVnaXN0ZXJl
ZF9yaW5nKQ0KPiAtCQlmcHV0KGZpbGUpOw0KPiArDQo+ICsJZnB1dChmaWxlKTsNCj4gIAlyZXR1
cm4gcmV0Ow0KPiAgfQ0KPiBkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvcnNyYy5jIGIvaW9fdXJpbmcv
cnNyYy5jIGluZGV4DQo+IDk2NGE0N2M4ZDg1ZS4uNzkyYzIyYjZmMmQ0IDEwMDY0NA0KPiAtLS0g
YS9pb191cmluZy9yc3JjLmMNCj4gKysrIGIvaW9fdXJpbmcvcnNyYy5jDQo+IEBAIC0xMDczLDcg
KzEwNzMsNyBAQCBpbnQgaW9fcmVnaXN0ZXJfY2xvbmVfYnVmZmVycyhzdHJ1Y3QgaW9fcmluZ19j
dHggKmN0eCwNCj4gdm9pZCBfX3VzZXIgKmFyZykNCj4gIAlpZiAoSVNfRVJSKGZpbGUpKQ0KPiAg
CQlyZXR1cm4gUFRSX0VSUihmaWxlKTsNCj4gIAlyZXQgPSBpb19jbG9uZV9idWZmZXJzKGN0eCwg
ZmlsZS0+cHJpdmF0ZV9kYXRhLCAmYnVmKTsNCj4gLQlpZiAoIXJlZ2lzdGVyZWRfc3JjKQ0KPiAt
CQlmcHV0KGZpbGUpOw0KPiArDQo+ICsJZnB1dChmaWxlKTsNCj4gIAlyZXR1cm4gcmV0Ow0KPiAg
fQ0KPiAtLQ0KPiAyLjQ3LjENCj4gDQoNCg0KLS0tDQpMaSBaZXRhbw0K

