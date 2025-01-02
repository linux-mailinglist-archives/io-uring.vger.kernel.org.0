Return-Path: <io-uring+bounces-5648-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 400DB9FF969
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 13:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 109967A1494
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 12:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2017C1A4E77;
	Thu,  2 Jan 2025 12:38:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A142F1A38E3
	for <io-uring@vger.kernel.org>; Thu,  2 Jan 2025 12:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735821533; cv=none; b=M37EODs5BggL+if+M1XwcuTFO0snx2iQAXhDaj+jwadyfVGfbP6Rr/woJ5QYuGjwMZzwatMeWQrsa23iR6lBZssLmw1JaxwP9zb5yR0KGY8lFiERUqlDtjO9ylfxmTx7m+t2VQCxth9dO96MxrDRKP+kD32CaH1DEOh/W1isetw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735821533; c=relaxed/simple;
	bh=kBFrtIXZcTkUAgGyqaoYAgt3kNXRJzNPWqgLmHdLWS4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PflWHYMN8XweCpH2VNr/qpA6LPHrAuUjYPImT7luUBgBb5IJTWsh0fBVbKI6H0Rb877/GRj0pwtTjbFR1/HTl12+P8SS7mscjWVmNjIlK9KTsHQBAkcjhQFPAtkQ4W+jblsjZPxKWo8mo6dqxVFhLEirFSSxLYPxQeTqupOFGgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YP5lh13FZzgbGN;
	Thu,  2 Jan 2025 20:35:44 +0800 (CST)
Received: from kwepemd100011.china.huawei.com (unknown [7.221.188.204])
	by mail.maildlp.com (Postfix) with ESMTPS id E183A140382;
	Thu,  2 Jan 2025 20:38:46 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100011.china.huawei.com (7.221.188.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 2 Jan 2025 20:38:46 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Thu, 2 Jan 2025 20:38:46 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>
CC: io-uring <io-uring@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggZm9yLW5leHRdIGlvX3VyaW5nOiBlbnN1cmUgaW9f?=
 =?utf-8?Q?queue=5Fdeferred()_is_out-of-line?=
Thread-Topic: [PATCH for-next] io_uring: ensure io_queue_deferred() is
 out-of-line
Thread-Index: AQHbWxwit1rECkjHTky1CpVJgUVA97MDbx5w
Date: Thu, 2 Jan 2025 12:38:46 +0000
Message-ID: <9b1201df8c2d4f8cbe957c57deac2f95@huawei.com>
References: <c1596f5f-405b-4370-997d-f42c8303c58c@kernel.dk>
In-Reply-To: <c1596f5f-405b-4370-997d-f42c8303c58c@kernel.dk>
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
YXhib2VAa2VybmVsLmRrPg0KPiBTZW50OiBUdWVzZGF5LCBEZWNlbWJlciAzMSwgMjAyNCA4OjM3
IEFNDQo+IFRvOiBpby11cmluZyA8aW8tdXJpbmdAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0
OiBbUEFUQ0ggZm9yLW5leHRdIGlvX3VyaW5nOiBlbnN1cmUgaW9fcXVldWVfZGVmZXJyZWQoKSBp
cyBvdXQtb2YtbGluZQ0KPiANCj4gVGhpcyBpcyBub3QgdGhlIGhvdCBwYXRoLCBpdCdzIGEgc2xv
dyBwYXRoLiBZZXQgdGhlIGxvY2tpbmcgZm9yIGl0IGlzIGluIHRoZSBob3QgcGF0aCwNCj4gYW5k
IF9fY29sZCBkb2VzIG5vdCBwcmV2ZW50IGl0IGZyb20gYmVpbmcgaW5saW5lZC4NCj4gDQo+IE1v
dmUgdGhlIGxvY2tpbmcgdG8gdGhlIGZ1bmN0aW9uIGl0c2VsZiwgYW5kIG1hcmsgaXQgbm9pbmxp
bmUgYXMgd2VsbCB0byBhdm9pZCBpdA0KPiBwb2xsdXRpbmcgdGhlIGljYWNoZSBvZiB0aGUgaG90
IHBhdGguDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+
DQo+IA0KPiAtLS0NCj4gDQo+IGRpZmYgLS1naXQgYS9pb191cmluZy9pb191cmluZy5jIGIvaW9f
dXJpbmcvaW9fdXJpbmcuYyBpbmRleA0KPiA0MmQ0Y2M1ZGE3M2IuLmRiMTk4YmQ0MzViNSAxMDA2
NDQNCj4gLS0tIGEvaW9fdXJpbmcvaW9fdXJpbmcuYw0KPiArKysgYi9pb191cmluZy9pb191cmlu
Zy5jDQo+IEBAIC01NTAsOCArNTUwLDkgQEAgdm9pZCBpb19yZXFfcXVldWVfaW93cShzdHJ1Y3Qg
aW9fa2lvY2IgKnJlcSkNCj4gIAlpb19yZXFfdGFza193b3JrX2FkZChyZXEpOw0KPiAgfQ0KPiAN
Cj4gLXN0YXRpYyBfX2NvbGQgdm9pZCBpb19xdWV1ZV9kZWZlcnJlZChzdHJ1Y3QgaW9fcmluZ19j
dHggKmN0eCkNCj4gK3N0YXRpYyBfX2NvbGQgbm9pbmxpbmUgdm9pZCBpb19xdWV1ZV9kZWZlcnJl
ZChzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCkNCj4gIHsNCj4gKwlzcGluX2xvY2soJmN0eC0+Y29t
cGxldGlvbl9sb2NrKTsNCkp1c3QgYSBkaWdyZXNzaW9uLCB3aGV0aGVyIHRoZSBpb191cmluZyBz
dWJzeXN0ZW0gd2VsY29tZXMgc2NvcGUtYmFzZWQgY2xlYW51cCBoZWxwZXJzLCB0aGlzIGlzIHNv
bWV3aGF0DQpjb250cm92ZXJzaWFsIGluIG90aGVyIHN1Ym1vZHVsZXMuDQo+ICAJd2hpbGUgKCFs
aXN0X2VtcHR5KCZjdHgtPmRlZmVyX2xpc3QpKSB7DQo+ICAJCXN0cnVjdCBpb19kZWZlcl9lbnRy
eSAqZGUgPSBsaXN0X2ZpcnN0X2VudHJ5KCZjdHgtPmRlZmVyX2xpc3QsDQo+ICAJCQkJCQlzdHJ1
Y3QgaW9fZGVmZXJfZW50cnksIGxpc3QpOw0KPiBAQCAtNTYyLDYgKzU2Myw3IEBAIHN0YXRpYyBf
X2NvbGQgdm9pZCBpb19xdWV1ZV9kZWZlcnJlZChzdHJ1Y3QgaW9fcmluZ19jdHgNCj4gKmN0eCkN
Cj4gIAkJaW9fcmVxX3Rhc2tfcXVldWUoZGUtPnJlcSk7DQo+ICAJCWtmcmVlKGRlKTsNCj4gIAl9
DQo+ICsJc3Bpbl91bmxvY2soJmN0eC0+Y29tcGxldGlvbl9sb2NrKTsNCj4gIH0NCj4gDQo+ICB2
b2lkIF9faW9fY29tbWl0X2NxcmluZ19mbHVzaChzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCkgQEAg
LTU3MCwxMSArNTcyLDgNCj4gQEAgdm9pZCBfX2lvX2NvbW1pdF9jcXJpbmdfZmx1c2goc3RydWN0
IGlvX3JpbmdfY3R4ICpjdHgpDQo+ICAJCWlvX3BvbGxfd3Ffd2FrZShjdHgpOw0KPiAgCWlmIChj
dHgtPm9mZl90aW1lb3V0X3VzZWQpDQo+ICAJCWlvX2ZsdXNoX3RpbWVvdXRzKGN0eCk7DQo+IC0J
aWYgKGN0eC0+ZHJhaW5fYWN0aXZlKSB7DQo+IC0JCXNwaW5fbG9jaygmY3R4LT5jb21wbGV0aW9u
X2xvY2spOw0KPiArCWlmIChjdHgtPmRyYWluX2FjdGl2ZSkNCj4gIAkJaW9fcXVldWVfZGVmZXJy
ZWQoY3R4KTsNCj4gLQkJc3Bpbl91bmxvY2soJmN0eC0+Y29tcGxldGlvbl9sb2NrKTsNCj4gLQl9
DQo+ICAJaWYgKGN0eC0+aGFzX2V2ZmQpDQo+ICAJCWlvX2V2ZW50ZmRfZmx1c2hfc2lnbmFsKGN0
eCk7DQo+ICB9DQo+IA0KPiAtLQ0KPiBKZW5zIEF4Ym9lDQo+IA0KDQpSZXZpZXdlZC1ieTogTGkg
WmV0YW88bGl6ZXRhbzFAaHVhd2VpLmNvbT4NCg0KLS0tDQpMaSBaZXRhbw0K

