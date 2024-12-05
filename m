Return-Path: <io-uring+bounces-5248-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F769E4DD4
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 07:55:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04EDA1881574
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 06:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7125217C208;
	Thu,  5 Dec 2024 06:55:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6698918FDAF
	for <io-uring@vger.kernel.org>; Thu,  5 Dec 2024 06:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733381708; cv=none; b=TuRII9+izJFSYLTXITw1/sTncNZl5yWyiWHDba5QnDMe2H445u5vVbIfJl+z1SzgBoa1iGwwN0bCScDWMldt8w/mwiThBIgLxChrxyz7VY4gDvlKBwZi8mFvs2zqDqUz/BRB2YFgVq9UAkhL8S8Ech9O6DiUHmCkWXMwxaJ5bME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733381708; c=relaxed/simple;
	bh=ECTtRqtDsMe0g+fjKqifg4tSycAi1OYlVlotPYwEb5E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TaM4Q8qMvtNuKLK+04aHAFD9tQtfb9umM+APM1C9t2JlxygCDr0cqfabx3y6OMgcimneb+ainhqjHc/Ekjq+GeDOAD3NlJHd0eMOeed7jLRBHa+8S22+tIsK7DaCI7qn1sOrXmGniaYtzjQADBsqNPkK4oc18MXuXwvHm/lOZcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y3lWC0PRyz1JDWP;
	Thu,  5 Dec 2024 14:54:47 +0800 (CST)
Received: from kwepemd100010.china.huawei.com (unknown [7.221.188.107])
	by mail.maildlp.com (Postfix) with ESMTPS id 83A911A016C;
	Thu,  5 Dec 2024 14:54:55 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100010.china.huawei.com (7.221.188.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 5 Dec 2024 14:54:55 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Thu, 5 Dec 2024 14:54:55 +0800
From: lizetao <lizetao1@huawei.com>
To: Anuj Gupta <anuj20.g@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>, "anuj1072538@gmail.com"
	<anuj1072538@gmail.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"vishak.g@samsung.com" <vishak.g@samsung.com>
Subject: RE: [PATCH] io_uring: expose read/write attribute capability
Thread-Topic: [PATCH] io_uring: expose read/write attribute capability
Thread-Index: AQHbRt8S7fg5Feg3u0iWhX9aH2sBnLLXN1Pw
Date: Thu, 5 Dec 2024 06:54:55 +0000
Message-ID: <17dd78d37d984d82baa26c70263b40bc@huawei.com>
References: <CGME20241205062910epcas5p2aed41bc2f50a58cb1966543dfd31c316@epcas5p2.samsung.com>
 <20241205062109.1788-1-anuj20.g@samsung.com>
In-Reply-To: <20241205062109.1788-1-anuj20.g@samsung.com>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW51aiBHdXB0YSA8YW51
ajIwLmdAc2Ftc3VuZy5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBEZWNlbWJlciA1LCAyMDI0IDI6
MjEgUE0NCj4gVG86IGF4Ym9lQGtlcm5lbC5kazsgYXNtbC5zaWxlbmNlQGdtYWlsLmNvbTsgYW51
ajEwNzI1MzhAZ21haWwuY29tDQo+IENjOiBpby11cmluZ0B2Z2VyLmtlcm5lbC5vcmc7IHZpc2hh
ay5nQHNhbXN1bmcuY29tOyBBbnVqIEd1cHRhDQo+IDxhbnVqMjAuZ0BzYW1zdW5nLmNvbT4NCj4g
U3ViamVjdDogW1BBVENIXSBpb191cmluZzogZXhwb3NlIHJlYWQvd3JpdGUgYXR0cmlidXRlIGNh
cGFiaWxpdHkNCj4gDQo+IEFmdGVyIGNvbW1pdCA5YTIxM2QzYjgwYzAsIHdlIGNhbiBwYXNzIGFk
ZGl0aW9uYWwgYXR0cmlidXRlcyBhbG9uZyB3aXRoDQo+IHJlYWQvd3JpdGUuIEhvd2V2ZXIsIHVz
ZXJzcGFjZSBkb2Vzbid0IGtub3cgdGhhdC4gQWRkIGEgbmV3IGZlYXR1cmUgZmxhZw0KPiBJT1JJ
TkdfRkVBVF9SV19BVFRSLCB0byBub3RpZnkgdGhlIHVzZXJzcGFjZSB0aGF0IHRoZSBrZXJuZWwg
aGFzIHRoaXMNCj4gYWJpbGl0eS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFudWogR3VwdGEgPGFu
dWoyMC5nQHNhbXN1bmcuY29tPg0KPiAtLS0NCj4gIGluY2x1ZGUvdWFwaS9saW51eC9pb191cmlu
Zy5oIHwgMSArDQo+ICBpb191cmluZy9pb191cmluZy5jICAgICAgICAgICB8IDMgKystDQo+ICAy
IGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9pb191cmluZy5oIGIvaW5jbHVkZS91YXBpL2xp
bnV4L2lvX3VyaW5nLmgNCj4gaW5kZXggMzhmMGQ2YjEwZWFmLi5lMTFjODI2Mzg1MjcgMTAwNjQ0
DQo+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9pb191cmluZy5oDQo+ICsrKyBiL2luY2x1ZGUv
dWFwaS9saW51eC9pb191cmluZy5oDQo+IEBAIC01NzcsNiArNTc3LDcgQEAgc3RydWN0IGlvX3Vy
aW5nX3BhcmFtcyB7DQo+ICAjZGVmaW5lIElPUklOR19GRUFUX1JFR19SRUdfUklORwkoMVUgPDwg
MTMpDQo+ICAjZGVmaW5lIElPUklOR19GRUFUX1JFQ1ZTRU5EX0JVTkRMRQkoMVUgPDwgMTQpDQo+
ICAjZGVmaW5lIElPUklOR19GRUFUX01JTl9USU1FT1VUCQkoMVUgPDwgMTUpDQo+ICsjZGVmaW5l
IElPUklOR19GRUFUX1JXX0FUVFIJCSgxVSA8PCAxNikNCj4gDQo+ICAvKg0KPiAgICogaW9fdXJp
bmdfcmVnaXN0ZXIoMikgb3Bjb2RlcyBhbmQgYXJndW1lbnRzIGRpZmYgLS1naXQNCj4gYS9pb191
cmluZy9pb191cmluZy5jIGIvaW9fdXJpbmcvaW9fdXJpbmcuYyBpbmRleA0KPiBhOGNiZTY3NGU1
ZDYuLmE4OTVkZTU0ZWIzZSAxMDA2NDQNCj4gLS0tIGEvaW9fdXJpbmcvaW9fdXJpbmcuYw0KPiAr
KysgYi9pb191cmluZy9pb191cmluZy5jDQo+IEBAIC0zNzEwLDcgKzM3MTAsOCBAQCBzdGF0aWMg
X19jb2xkIGludCBpb191cmluZ19jcmVhdGUodW5zaWduZWQgZW50cmllcywNCj4gc3RydWN0IGlv
X3VyaW5nX3BhcmFtcyAqcCwNCj4gIAkJCUlPUklOR19GRUFUX0VYVF9BUkcgfA0KPiBJT1JJTkdf
RkVBVF9OQVRJVkVfV09SS0VSUyB8DQo+ICAJCQlJT1JJTkdfRkVBVF9SU1JDX1RBR1MgfCBJT1JJ
TkdfRkVBVF9DUUVfU0tJUA0KPiB8DQo+ICAJCQlJT1JJTkdfRkVBVF9MSU5LRURfRklMRSB8DQo+
IElPUklOR19GRUFUX1JFR19SRUdfUklORyB8DQo+IC0JCQlJT1JJTkdfRkVBVF9SRUNWU0VORF9C
VU5ETEUgfA0KPiBJT1JJTkdfRkVBVF9NSU5fVElNRU9VVDsNCj4gKwkJCUlPUklOR19GRUFUX1JF
Q1ZTRU5EX0JVTkRMRSB8DQo+IElPUklOR19GRUFUX01JTl9USU1FT1VUIHwNCj4gKwkJCUlPUklO
R19GRUFUX1JXX0FUVFI7DQo+IA0KPiAgCWlmIChjb3B5X3RvX3VzZXIocGFyYW1zLCBwLCBzaXpl
b2YoKnApKSkgew0KPiAgCQlyZXQgPSAtRUZBVUxUOw0KPiAtLQ0KPiAyLjI1LjENCj4gDQoNClJl
dmlld2VkLWJ5OiBMaSBaZXRhbyA8bGl6ZXRhbzFAaHVhd2VpLmNvbT4NCg0KLS0NCkxpIFpldGFv
DQoNCg==

