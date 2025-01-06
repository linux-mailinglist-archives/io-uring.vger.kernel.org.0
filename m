Return-Path: <io-uring+bounces-5679-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D166CA02456
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 12:33:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 548691885720
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 11:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4B71DAC92;
	Mon,  6 Jan 2025 11:33:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092E8192B74
	for <io-uring@vger.kernel.org>; Mon,  6 Jan 2025 11:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736163234; cv=none; b=AoX/Vm9CXclkCx3L9ymMLXuPS1tFsTgpxw3MlZZboQ22wRXgEYI7/gGvjbx7QwW7EPHG+xrKtGoSe2xrBrjOnQq5oTp0JQLBv1/7SsNtK3sMa4SgxX+p4yPQF9Ohi+WutpbGt3qPhcO6/R7fSybZFVeaTaKV4MtfpGQwZSWZxIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736163234; c=relaxed/simple;
	bh=/doaobmNyVVV0wua2WnwayA4Mb5SI8xj8P365uuQs0s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p5eqe1KV+iM/q+tTRhW+ziVISSmgCWFjaJtnn9qZGwvrWk/gAUJ1Kbvgj2fBHd2sndiUH/57Y+WbSWKvQTqF/0VGvTjCTI5WMZqUjSXE2uLuPVi4Zh68M6DX1D3ZYdllEStvNB8p3XuPBoVqLQdtJGXUWQLvXnu3d0WUwFz216o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4YRX635rhVz1W3dx;
	Mon,  6 Jan 2025 19:30:03 +0800 (CST)
Received: from kwepemd200012.china.huawei.com (unknown [7.221.188.145])
	by mail.maildlp.com (Postfix) with ESMTPS id 14BA214022E;
	Mon,  6 Jan 2025 19:33:43 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200012.china.huawei.com (7.221.188.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 6 Jan 2025 19:33:42 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Mon, 6 Jan 2025 19:33:42 +0800
From: lizetao <lizetao1@huawei.com>
To: Pavel Begunkov <asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
CC: Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>
Subject: RE: [PATCH 2/4] io_uring: add registered request arguments
Thread-Topic: [PATCH 2/4] io_uring: add registered request arguments
Thread-Index: AQHbWr7rQF+JtRfN0kyxiRauVnZ4z7MJp1ug
Date: Mon, 6 Jan 2025 11:33:42 +0000
Message-ID: <4cda935c978f48ceac6d69dd2e9587f9@huawei.com>
References: <cover.1735301337.git.asml.silence@gmail.com>
 <cb3cc963ad684d5687b90f28ff9d928a20f80b76.1735301337.git.asml.silence@gmail.com>
In-Reply-To: <cb3cc963ad684d5687b90f28ff9d928a20f80b76.1735301337.git.asml.silence@gmail.com>
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
bmNoYW4NCj4gSm9zaGkgPGpvc2hpLmtAc2Ftc3VuZy5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCAy
LzRdIGlvX3VyaW5nOiBhZGQgcmVnaXN0ZXJlZCByZXF1ZXN0IGFyZ3VtZW50cw0KPiANCj4gU2lt
aWxhcmx5IHRvIHJlZ2lzdGVyZWQgd2FpdCBhcmd1bWVudHMgd2Ugd2FudCB0byBoYXZlIGEgcHJl
LW1hcHBlZCBzcGFjZQ0KPiBmb3IgdmFyaW91cyByZXF1ZXN0IGFyZ3VtZW50cy4gVXNlIHRoZSBz
YW1lIHBhcmFtZXRlciByZWdpb24sIGhvd2V2ZXIgYXMgLQ0KPiA+d2FpdF9hcmdzIGhhcyBkaWZm
ZXJlbnQgbGlmZXRpbWUgcnVsZXMsIGFkZCBhIG5ldyBpbnN0YW5jZSBvZiBzdHJ1Y3QNCj4gaW9f
cmVnX2FyZ3MuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxl
bmNlQGdtYWlsLmNvbT4NCj4gLS0tDQo+ICBpbmNsdWRlL2xpbnV4L2lvX3VyaW5nX3R5cGVzLmgg
fCAyICsrDQo+ICBpb191cmluZy9yZWdpc3Rlci5jICAgICAgICAgICAgfCAzICsrKw0KPiAgMiBm
aWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L2lvX3VyaW5nX3R5cGVzLmggYi9pbmNsdWRlL2xpbnV4L2lvX3VyaW5nX3R5cGVzLmgN
Cj4gaW5kZXggNDkwMDhmMDBkMDY0Li5jZDY2NDI4NTU1MzMgMTAwNjQ0DQo+IC0tLSBhL2luY2x1
ZGUvbGludXgvaW9fdXJpbmdfdHlwZXMuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L2lvX3VyaW5n
X3R5cGVzLmgNCj4gQEAgLTI5OSw2ICsyOTksOCBAQCBzdHJ1Y3QgaW9fcmluZ19jdHggew0KPiAN
Cj4gIAkJc3RydWN0IGlvX3N1Ym1pdF9zdGF0ZQlzdWJtaXRfc3RhdGU7DQo+IA0KPiArCQlzdHJ1
Y3QgaW9fcmVnX2FyZ3MJc3FlX2FyZ3M7DQo+ICsNCj4gIAkJLyoNCj4gIAkJICogTW9kaWZpY2F0
aW9ucyBhcmUgcHJvdGVjdGVkIGJ5IC0+dXJpbmdfbG9jayBhbmQgLQ0KPiA+bW1hcF9sb2NrLg0K
PiAgCQkgKiBUaGUgZmxhZ3MsIGJ1Zl9wYWdlcyBhbmQgYnVmX25yX3BhZ2VzIGZpZWxkcyBzaG91
bGQgYmUNCj4gc3RhYmxlIGRpZmYgLS1naXQgYS9pb191cmluZy9yZWdpc3Rlci5jIGIvaW9fdXJp
bmcvcmVnaXN0ZXIuYyBpbmRleA0KPiBiOTI2ZWIwNTM0MDguLmQyMjMyYjkwYTgxZCAxMDA2NDQN
Cj4gLS0tIGEvaW9fdXJpbmcvcmVnaXN0ZXIuYw0KPiArKysgYi9pb191cmluZy9yZWdpc3Rlci5j
DQo+IEBAIC02MDcsNiArNjA3LDkgQEAgc3RhdGljIGludCBpb19yZWdpc3Rlcl9tZW1fcmVnaW9u
KHN0cnVjdCBpb19yaW5nX2N0eA0KPiAqY3R4LCB2b2lkIF9fdXNlciAqdWFyZykNCj4gIAkJY3R4
LT53YWl0X2FyZ3MucHRyID0gaW9fcmVnaW9uX2dldF9wdHIoJmN0eC0+cGFyYW1fcmVnaW9uKTsN
Cj4gIAkJY3R4LT53YWl0X2FyZ3Muc2l6ZSA9IHJkLnNpemU7DQo+ICAJfQ0KPiArDQo+ICsJY3R4
LT5zcWVfYXJncy5wdHIgPSBpb19yZWdpb25fZ2V0X3B0cigmY3R4LT5wYXJhbV9yZWdpb24pOw0K
PiArCWN0eC0+c3FlX2FyZ3Muc2l6ZSA9IHJkLnNpemU7DQoNCldoeSBub3QgYWRkIGFuIGVudW0g
dmFsdWUgYWdhaW5zdCBzcWVfYXJncz8gV2lsbCBtaXhpbmcgaXQgd2l0aA0KSU9SSU5HX01FTV9S
RUdJT05fUkVHX1dBSVRfQVJHIGNhdXNlIG1hbmFnZW1lbnQgY29uZnVzaW9uPw0KPiAgCXJldHVy
biAwOw0KPiAgfQ0KPiANCj4gLS0NCj4gMi40Ny4xDQo+IA0KDQotLS0NCkxpIFpldGFvDQo=

