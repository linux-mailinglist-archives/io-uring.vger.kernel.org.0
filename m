Return-Path: <io-uring+bounces-6552-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D91E6A3B194
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 07:25:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 619AC3B21B2
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 06:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C554D1B87F8;
	Wed, 19 Feb 2025 06:25:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39C21B4153;
	Wed, 19 Feb 2025 06:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739946310; cv=none; b=DbNAF2Dgx5yb/vanouTpLtVj0XjsSjSVxx15EbcIZieZXdIgvG5xC1ZHFkzUUBrtmitchV80Hmebes49qd105j+5qVQZSC533/I2ajSQx+83qeNrq3jOxf2jTilt7fLIGKn3FNTIDYC1I535kfeEXbKJfHLta4pU63YxswTSw7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739946310; c=relaxed/simple;
	bh=RnnYDsoQxBRKq7+3ID676QXf2lCJ2IDRIn/vWknGnW0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RUo7EN3dqohVdMvYLK25vCzpIVY6OYREB7Gw7uczDasGMgZJZFLoqEESYuN0syUWFHQ+e52pev5EMKso1RJQzuVLWKGO0OAvXpTEyvt8MJBNPYSrApveMXrn8bFUxb58noF4Ekq4bwSsPJPsH/rKisnMWJMwyWSS5kQw4Q7ye/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YyR8X6dsgzjYF5;
	Wed, 19 Feb 2025 14:20:28 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id 08E0D18010B;
	Wed, 19 Feb 2025 14:25:05 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 19 Feb 2025 14:25:04 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Wed, 19 Feb 2025 14:25:04 +0800
From: lizetao <lizetao1@huawei.com>
To: Caleb Sander Mateos <csander@purestorage.com>
CC: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] io_uring/rsrc: remove unused constants
Thread-Topic: [PATCH] io_uring/rsrc: remove unused constants
Thread-Index: AQHbgn9Ll4Ev2kd5F0iFmZ8cjznzrrNOKNuA
Date: Wed, 19 Feb 2025 06:25:04 +0000
Message-ID: <d00aa2f3083b48189667355d938089ec@huawei.com>
References: <20250219033444.2020136-1-csander@purestorage.com>
In-Reply-To: <20250219033444.2020136-1-csander@purestorage.com>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2FsZWIgU2FuZGVy
IE1hdGVvcyA8Y3NhbmRlckBwdXJlc3RvcmFnZS5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgRmVi
cnVhcnkgMTksIDIwMjUgMTE6MzUgQU0NCj4gVG86IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5k
az47IFBhdmVsIEJlZ3Vua292IDxhc21sLnNpbGVuY2VAZ21haWwuY29tPg0KPiBDYzogQ2FsZWIg
U2FuZGVyIE1hdGVvcyA8Y3NhbmRlckBwdXJlc3RvcmFnZS5jb20+OyBpby0NCj4gdXJpbmdAdmdl
ci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQ
QVRDSF0gaW9fdXJpbmcvcnNyYzogcmVtb3ZlIHVudXNlZCBjb25zdGFudHMNCj4gDQo+IElPX05P
REVfQUxMT0NfQ0FDSEVfTUFYIGhhcyBiZWVuIHVudXNlZCBzaW5jZSBjb21taXQgZmJiYjhlOTkx
ZDg2DQo+ICgiaW9fdXJpbmcvcnNyYzogZ2V0IHJpZCBvZiBpb19yc3JjX25vZGUgYWxsb2NhdGlv
biBjYWNoZSIpIHJlbW92ZWQgdGhlDQo+IHJzcmNfbm9kZV9jYWNoZS4NCj4gDQo+IElPX1JTUkNf
VEFHX1RBQkxFX1NISUZUIGFuZCBJT19SU1JDX1RBR19UQUJMRV9NQVNLIGhhdmUgYmVlbg0KPiB1
bnVzZWQgc2luY2UgY29tbWl0IDcwMjlhY2Q4YTk1MCAoImlvX3VyaW5nL3JzcmM6IGdldCByaWQg
b2YgcGVyLXJpbmcNCj4gaW9fcnNyY19ub2RlIGxpc3QiKSByZW1vdmVkIHRoZSBzZXBhcmF0ZSB0
YWcgdGFibGUgZm9yIHJlZ2lzdGVyZWQgbm9kZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYWxl
YiBTYW5kZXIgTWF0ZW9zIDxjc2FuZGVyQHB1cmVzdG9yYWdlLmNvbT4NCj4gLS0tDQo+ICBpb191
cmluZy9yc3JjLmggfCA2IC0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvcnNyYy5oIGIvaW9fdXJpbmcvcnNyYy5oIGlu
ZGV4DQo+IGE2ZDg4M2M2MmIyMi4uMDI5N2RhZjAyYWM3IDEwMDY0NA0KPiAtLS0gYS9pb191cmlu
Zy9yc3JjLmgNCj4gKysrIGIvaW9fdXJpbmcvcnNyYy5oDQo+IEBAIC0yLDE2ICsyLDEwIEBADQo+
ICAjaWZuZGVmIElPVV9SU1JDX0gNCj4gICNkZWZpbmUgSU9VX1JTUkNfSA0KPiANCj4gICNpbmNs
dWRlIDxsaW51eC9sb2NrZGVwLmg+DQo+IA0KPiAtI2RlZmluZSBJT19OT0RFX0FMTE9DX0NBQ0hF
X01BWCAzMg0KPiAtDQo+IC0jZGVmaW5lIElPX1JTUkNfVEFHX1RBQkxFX1NISUZUCShQQUdFX1NI
SUZUIC0gMykNCj4gLSNkZWZpbmUgSU9fUlNSQ19UQUdfVEFCTEVfTUFYCSgxVSA8PCBJT19SU1JD
X1RBR19UQUJMRV9TSElGVCkNCj4gLSNkZWZpbmUgSU9fUlNSQ19UQUdfVEFCTEVfTUFTSwkoSU9f
UlNSQ19UQUdfVEFCTEVfTUFYIC0gMSkNCj4gLQ0KPiAgZW51bSB7DQo+ICAJSU9SSU5HX1JTUkNf
RklMRQkJPSAwLA0KPiAgCUlPUklOR19SU1JDX0JVRkZFUgkJPSAxLA0KPiAgfTsNCj4gDQo+IC0t
DQo+IDIuNDUuMg0KPiANCg0KUmV2aWV3ZWQtYnk6IExpIFpldGFvIDxsaXpldGFvMUBodWF3ZWku
Y29tPg0KDQotLS0NCkxpIFpldGFvDQoNCg==

