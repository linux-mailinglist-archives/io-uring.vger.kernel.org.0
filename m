Return-Path: <io-uring+bounces-6125-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 040FEA1C1F9
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 07:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E7DF7A1245
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 06:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336D8207667;
	Sat, 25 Jan 2025 06:59:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE97B1D5CEB;
	Sat, 25 Jan 2025 06:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737788353; cv=none; b=ss5ppDwlLfKGNfSd1SEjaLbe+ObjDeFN+V2LGc0hC0wZmEXwXqxtBx79H84aBp41j6SWZKak728HqBTX9LFBT1wrgHdAEFj4ox6NVL3ImtUIyNaaHJgxFRZzvkJOIh0o2RpXk9ugU5foTtFNggQ5e0NGs2heY7gHJ6isQYwR20w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737788353; c=relaxed/simple;
	bh=JA1JAzJ1EfU1wv6nUQhdJonbSORd8QY0tbKV6r659BM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jp3TbwFVImiJfZBfSpcWomlXpkarej6u/qLfsfvGfVCHEgSQFdWIQsDPnzJjNp7NdhpHyl9wgngI+DTEjiON48BnGyi6Ezv55FOYdU93kDg3dUHPxVpqwNC1uiEq8OrjoC5xGvUDeYrrJdcBCMWDj5b9uUgqRj8/3paTqtxj/zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Yg56m0Vvrz1l00X;
	Sat, 25 Jan 2025 14:55:44 +0800 (CST)
Received: from kwepemd200010.china.huawei.com (unknown [7.221.188.124])
	by mail.maildlp.com (Postfix) with ESMTPS id ADD341402C4;
	Sat, 25 Jan 2025 14:59:06 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200010.china.huawei.com (7.221.188.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 25 Jan 2025 14:59:06 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Sat, 25 Jan 2025 14:59:06 +0800
From: lizetao <lizetao1@huawei.com>
To: Pavel Begunkov <asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: Xan Charbonnet <xan@charbonnet.com>, Salvatore Bonaccorso
	<carnil@debian.org>
Subject: RE: [PATCH stable-6.1 1/1] io_uring: fix waiters missing wake ups
Thread-Topic: [PATCH stable-6.1 1/1] io_uring: fix waiters missing wake ups
Thread-Index: AQHbbpFPgOGrLlGZ8UW45KUl0YJ2IrMnD/Gg
Date: Sat, 25 Jan 2025 06:59:06 +0000
Message-ID: <da9d505df3f648ad8660ad6e53a6f77c@huawei.com>
References: <760086647776a5aebfa77cfff728837d476a4fd8.1737718881.git.asml.silence@gmail.com>
In-Reply-To: <760086647776a5aebfa77cfff728837d476a4fd8.1737718881.git.asml.silence@gmail.com>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGF2ZWwgQmVndW5rb3Yg
PGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+DQo+IFNlbnQ6IFNhdHVyZGF5LCBKYW51YXJ5IDI1LCAy
MDI1IDI6NTQgQU0NCj4gVG86IGlvLXVyaW5nQHZnZXIua2VybmVsLm9yZzsgc3RhYmxlQHZnZXIu
a2VybmVsLm9yZw0KPiBDYzogYXNtbC5zaWxlbmNlQGdtYWlsLmNvbTsgWGFuIENoYXJib25uZXQg
PHhhbkBjaGFyYm9ubmV0LmNvbT47DQo+IFNhbHZhdG9yZSBCb25hY2NvcnNvIDxjYXJuaWxAZGVi
aWFuLm9yZz4NCj4gU3ViamVjdDogW1BBVENIIHN0YWJsZS02LjEgMS8xXSBpb191cmluZzogZml4
IHdhaXRlcnMgbWlzc2luZyB3YWtlIHVwcw0KPiANCj4gWyB1cHN0cmVhbSBjb21taXQgMzE4MWUy
MmZiNzk5MTBjNzA3MWU4NGE0M2FmOTNhYzg5ZThhNzEwNiBdDQo+IA0KPiBUaGVyZSBhcmUgcmVw
b3J0cyBvZiBtYXJpYWRiIGhhbmdzLCB3aGljaCBpcyBjYXVzZWQgYnkgYSBtaXNzaW5nIGJhcnJp
ZXIgaW4gdGhlDQo+IHdha2luZyBjb2RlIHJlc3VsdGluZyBpbiB3YWl0ZXJzIGxvc2luZyBldmVu
dHMuDQo+IA0KPiBUaGUgcHJvYmxlbSB3YXMgaW50cm9kdWNlZCBpbiBhIGJhY2twb3J0DQo+IDNh
YjkzMjZmOTNlYzQgKCJpb191cmluZzogd2FrZSB1cCBvcHRpbWlzYXRpb25zIiksIGFuZCB0aGUg
Y2hhbmdlIHJlc3RvcmVzDQo+IHRoZSBiYXJyaWVyIHByZXNlbnQgaW4gdGhlIG9yaWdpbmFsIGNv
bW1pdA0KPiAzYWI5MzI2ZjkzZWM0ICgiaW9fdXJpbmc6IHdha2UgdXAgb3B0aW1pc2F0aW9ucyIp
DQo+IA0KPiBSZXBvcnRlZCBieTogWGFuIENoYXJib25uZXQgPHhhbkBjaGFyYm9ubmV0LmNvbT4N
Cj4gRml4ZXM6IDNhYjkzMjZmOTNlYzQgKCJpb191cmluZzogd2FrZSB1cCBvcHRpbWlzYXRpb25z
IikNCj4gTGluazogaHR0cHM6Ly9idWdzLmRlYmlhbi5vcmcvY2dpLWJpbi9idWdyZXBvcnQuY2dp
P2J1Zz0xMDkzMjQzIzk5DQo+IFNpZ25lZC1vZmYtYnk6IFBhdmVsIEJlZ3Vua292IDxhc21sLnNp
bGVuY2VAZ21haWwuY29tPg0KPiAtLS0NCj4gIGlvX3VyaW5nL2lvX3VyaW5nLmMgfCA0ICsrKy0N
Cj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9pb191cmluZy9pb191cmluZy5jIGIvaW9fdXJpbmcvaW9fdXJpbmcuYyBp
bmRleA0KPiA5YjU4YmE0NjE2ZDQwLi5lNWE4ZWU5NDRlZjU5IDEwMDY0NA0KPiAtLS0gYS9pb191
cmluZy9pb191cmluZy5jDQo+ICsrKyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMNCj4gQEAgLTU5Miw4
ICs1OTIsMTAgQEAgc3RhdGljIGlubGluZSB2b2lkIF9faW9fY3FfdW5sb2NrX3Bvc3RfZmx1c2go
c3RydWN0DQo+IGlvX3JpbmdfY3R4ICpjdHgpDQo+ICAJaW9fY29tbWl0X2NxcmluZyhjdHgpOw0K
PiAgCXNwaW5fdW5sb2NrKCZjdHgtPmNvbXBsZXRpb25fbG9jayk7DQo+ICAJaW9fY29tbWl0X2Nx
cmluZ19mbHVzaChjdHgpOw0KPiAtCWlmICghKGN0eC0+ZmxhZ3MgJiBJT1JJTkdfU0VUVVBfREVG
RVJfVEFTS1JVTikpDQo+ICsJaWYgKCEoY3R4LT5mbGFncyAmIElPUklOR19TRVRVUF9ERUZFUl9U
QVNLUlVOKSkgew0KPiArCQlzbXBfbWIoKTsNCj4gIAkJX19pb19jcXJpbmdfd2FrZShjdHgpOw0K
PiArCX0NCj4gIH0NCj4gDQo+ICB2b2lkIGlvX2NxX3VubG9ja19wb3N0KHN0cnVjdCBpb19yaW5n
X2N0eCAqY3R4KQ0KPiAtLQ0KPiAyLjQ3LjENCj4gDQoNClJldmlld2VkLWJ5OiBMaSBaZXRhbyA8
bGl6ZXRhbzFAaHVhd2VpLmNvbT4NCg0KLS0NCkxpIFpldGFvDQo=

