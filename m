Return-Path: <io-uring+bounces-6903-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02DB2A4B7D3
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 07:20:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25CD816A220
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 06:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F10A1DDC23;
	Mon,  3 Mar 2025 06:20:20 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8D53398A;
	Mon,  3 Mar 2025 06:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740982820; cv=none; b=SKPDhh7i6fNyhZ08XG+ryBQKzdHjbVlvVF4tlLDghMj5DI+sRiyb/TBu5LeLCijSJkFdKiZZv5GAzzJU0VGL9ZQWfKeMz+CMVLosE1RdBbScK2oAS3sI3tw3WYTI11AIVsHAhngeuvCxuIs+4kutOnjbTMbciClHf5FT5eJCa78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740982820; c=relaxed/simple;
	bh=YPC0l9fpFGIz1o3+5Xb6xsb0PhkgrUAnN4Ofjmfa0dY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Sb+UpPUcmKNEbNwCAoiO8JCjQtmo7kC5LMLztGR3uUtO/ie5zPwgrGvovphMMupubv+Ceabpe7G+oywfpw2+eU6UoVexP24/Ksu1hciseRdV0PRLhAgYKb01eKdM6RhIOBU0AYM0WkdMVVI+dn4Jajh7KEXjtuXh0aSInqjKzIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Z5pVL0zR1zvWqJ;
	Mon,  3 Mar 2025 14:16:26 +0800 (CST)
Received: from kwepemd500010.china.huawei.com (unknown [7.221.188.84])
	by mail.maildlp.com (Postfix) with ESMTPS id A5A0118007F;
	Mon,  3 Mar 2025 14:20:12 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd500010.china.huawei.com (7.221.188.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 3 Mar 2025 14:20:12 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Mon, 3 Mar 2025 14:20:12 +0800
From: lizetao <lizetao1@huawei.com>
To: Caleb Sander Mateos <csander@purestorage.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Subject: RE: [PATCH] io_uring/rsrc: include io_uring_types.h in rsrc.h
Thread-Topic: [PATCH] io_uring/rsrc: include io_uring_types.h in rsrc.h
Thread-Index: AQHbitlAv6dO9f+qAEamcK3Qvj/SnrNg8tUg
Date: Mon, 3 Mar 2025 06:20:12 +0000
Message-ID: <b2c805442bec4b03817d5a36ba96efb1@huawei.com>
References: <20250301183612.937529-1-csander@purestorage.com>
In-Reply-To: <20250301183612.937529-1-csander@purestorage.com>
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
IE1hdGVvcyA8Y3NhbmRlckBwdXJlc3RvcmFnZS5jb20+DQo+IFNlbnQ6IFN1bmRheSwgTWFyY2gg
MiwgMjAyNSAyOjM2IEFNDQo+IFRvOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+OyBQYXZl
bCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdtYWlsLmNvbT4NCj4gQ2M6IENhbGViIFNhbmRlciBN
YXRlb3MgPGNzYW5kZXJAcHVyZXN0b3JhZ2UuY29tPjsgaW8tDQo+IHVyaW5nQHZnZXIua2VybmVs
Lm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0hdIGlv
X3VyaW5nL3JzcmM6IGluY2x1ZGUgaW9fdXJpbmdfdHlwZXMuaCBpbiByc3JjLmgNCj4gDQo+IGlv
X3VyaW5nL3JzcmMuaCB1c2VzIHNldmVyYWwgdHlwZXMgZnJvbSBpbmNsdWRlL2xpbnV4L2lvX3Vy
aW5nX3R5cGVzLmguDQo+IEluY2x1ZGUgaW9fdXJpbmdfdHlwZXMuaCBleHBsaWNpdGx5IGluIHJz
cmMuaCB0byBhdm9pZCBkZXBlbmRpbmcgb24gdXNlcnMgb2YNCj4gcnNyYy5oIGluY2x1ZGluZyBp
b191cmluZ190eXBlcy5oIGZpcnN0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2FsZWIgU2FuZGVy
IE1hdGVvcyA8Y3NhbmRlckBwdXJlc3RvcmFnZS5jb20+DQo+IC0tLQ0KPiAgaW9fdXJpbmcvcnNy
Yy5oIHwgMSArDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYg
LS1naXQgYS9pb191cmluZy9yc3JjLmggYi9pb191cmluZy9yc3JjLmggaW5kZXggOGY5MTJhYTZi
Y2M5Li5mMTBhMTI1MmIzZTkNCj4gMTAwNjQ0DQo+IC0tLSBhL2lvX3VyaW5nL3JzcmMuaA0KPiAr
KysgYi9pb191cmluZy9yc3JjLmgNCj4gQEAgLTEsOSArMSwxMCBAQA0KPiAgLy8gU1BEWC1MaWNl
bnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4gICNpZm5kZWYgSU9VX1JTUkNfSA0KPiAgI2RlZmlu
ZSBJT1VfUlNSQ19IDQo+IA0KPiArI2luY2x1ZGUgPGxpbnV4L2lvX3VyaW5nX3R5cGVzLmg+DQo+
ICAjaW5jbHVkZSA8bGludXgvbG9ja2RlcC5oPg0KPiANCj4gIGVudW0gew0KPiAgCUlPUklOR19S
U1JDX0ZJTEUJCT0gMCwNCj4gIAlJT1JJTkdfUlNSQ19CVUZGRVIJCT0gMSwNCj4gLS0NCj4gMi40
NS4yDQo+IA0KDQpSZXZpZXdlZC1ieTogTGkgWmV0YW8gPGxpemV0YW8xQGh1YXdlaS5jb20+DQoN
Ci0tLQ0KTGkgWmV0YW8NCg0K

