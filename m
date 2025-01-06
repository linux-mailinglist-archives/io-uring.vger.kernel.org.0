Return-Path: <io-uring+bounces-5681-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB63A025E7
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 13:48:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9B5818852F6
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 12:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E071DC04C;
	Mon,  6 Jan 2025 12:47:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC411DE4E0;
	Mon,  6 Jan 2025 12:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167650; cv=none; b=XJK8CPDSRFT7HGv5zDgaIrHEtS4KqrLDcIIHdw55AsTZI5v7QmZchZxCjmpJxQreqQ93zd4a3/OXnp4X5U8bSzsODLCTuh5k0490J1gUI9JDiuc/7gMWKZvZVycd/z/W6Y6PmovkQqnHQh/BGoKpVGO2fEzhqA6Kf3MoeQHW/74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167650; c=relaxed/simple;
	bh=omKhY5SHSObfh9cRxI3ADc2s160SuGOoLL1fZzia7m8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bKPp59SJM1xfO3VeXrfei19s4OZkR95an0UfPTQPhGClQKIwcWyB+yR0rp/hEui7mfKuUzz3oYnz/0+h53dlgaBi3LYzxIAd68xc8fCEKBH7iI3pEqBm6wCFinRSq8maEc+5ZweKEBrgtVnBhjQWovtX+4NHJy+pDLkts65KDnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4YRYmj3ghmzRkjr;
	Mon,  6 Jan 2025 20:45:09 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id B383718010A;
	Mon,  6 Jan 2025 20:47:22 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 6 Jan 2025 20:47:22 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Mon, 6 Jan 2025 20:47:22 +0800
From: lizetao <lizetao1@huawei.com>
To: Mark Harmstone <maharmstone@fb.com>, Jens Axboe <axboe@kernel.dk>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: RE: [PATCH 2/4] io_uring/cmd: add per-op data to struct
 io_uring_cmd_data
Thread-Topic: [PATCH 2/4] io_uring/cmd: add per-op data to struct
 io_uring_cmd_data
Thread-Index: AQHbXfCReYc9ryeva0GJNdEZEtgE0rMJtTwg
Date: Mon, 6 Jan 2025 12:47:22 +0000
Message-ID: <974022e6b52a4ae39f10ea4410dd8e25@huawei.com>
References: <20250103150233.2340306-1-maharmstone@fb.com>
 <20250103150233.2340306-3-maharmstone@fb.com>
In-Reply-To: <20250103150233.2340306-3-maharmstone@fb.com>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFyayBIYXJtc3Rv
bmUgPG1haGFybXN0b25lQGZiLmNvbT4NCj4gU2VudDogRnJpZGF5LCBKYW51YXJ5IDMsIDIwMjUg
MTE6MDIgUE0NCj4gVG86IGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZzsgaW8tdXJpbmdAdmdl
ci5rZXJuZWwub3JnDQo+IENjOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+IFN1Ympl
Y3Q6IFtQQVRDSCAyLzRdIGlvX3VyaW5nL2NtZDogYWRkIHBlci1vcCBkYXRhIHRvIHN0cnVjdA0K
PiBpb191cmluZ19jbWRfZGF0YQ0KPiANCj4gRnJvbTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVs
LmRrPg0KPiANCj4gSW4gY2FzZSBhbiBvcCBoYW5kbGVyIGZvciAtPnVyaW5nX2NtZCgpIG5lZWRz
IHN0YWJsZSBzdG9yYWdlIGZvciB1c2VyIGRhdGEsIGl0DQo+IGNhbiBhbGxvY2F0ZSBpb191cmlu
Z19jbWRfZGF0YS0+b3BfZGF0YSBhbmQgdXNlIGl0IGZvciB0aGUgZHVyYXRpb24gb2YgdGhlDQo+
IHJlcXVlc3QuIFdoZW4gdGhlIHJlcXVlc3QgZ2V0cyBjbGVhbmVkIHVwLCB1cmluZ19jbWQgd2ls
bCBmcmVlIGl0DQo+IGF1dG9tYXRpY2FsbHkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4
Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+IC0tLQ0KPiAgaW5jbHVkZS9saW51eC9pb191cmluZy9j
bWQuaCB8ICAxICsNCj4gIGlvX3VyaW5nL3VyaW5nX2NtZC5jICAgICAgICAgfCAxMyArKysrKysr
KysrKy0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9pb191cmluZy9jbWQuaCBiL2lu
Y2x1ZGUvbGludXgvaW9fdXJpbmcvY21kLmggaW5kZXgNCj4gNjFmOTdhMzk4ZTlkLi5hNjVjNzA0
MzA3OGYgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvaW9fdXJpbmcvY21kLmgNCj4gKysr
IGIvaW5jbHVkZS9saW51eC9pb191cmluZy9jbWQuaA0KPiBAQCAtMjAsNiArMjAsNyBAQCBzdHJ1
Y3QgaW9fdXJpbmdfY21kIHsNCj4gDQo+ICBzdHJ1Y3QgaW9fdXJpbmdfY21kX2RhdGEgew0KPiAg
CXN0cnVjdCBpb191cmluZ19zcWUJc3Flc1syXTsNCj4gKwl2b2lkCQkJKm9wX2RhdGE7DQo+ICB9
Ow0KPiANCj4gIHN0YXRpYyBpbmxpbmUgY29uc3Qgdm9pZCAqaW9fdXJpbmdfc3FlX2NtZChjb25z
dCBzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUpIGRpZmYNCj4gLS1naXQgYS9pb191cmluZy91cmlu
Z19jbWQuYyBiL2lvX3VyaW5nL3VyaW5nX2NtZC5jIGluZGV4DQo+IDYyOWNiNDI2NmRhNi4uY2U3
NzI2YTA0ODgzIDEwMDY0NA0KPiAtLS0gYS9pb191cmluZy91cmluZ19jbWQuYw0KPiArKysgYi9p
b191cmluZy91cmluZ19jbWQuYw0KPiBAQCAtMjMsMTIgKzIzLDE2IEBAIHN0YXRpYyBzdHJ1Y3Qg
aW9fdXJpbmdfY21kX2RhdGENCj4gKmlvX3VyaW5nX2FzeW5jX2dldChzdHJ1Y3QgaW9fa2lvY2Ig
KnJlcSkNCj4gDQo+ICAJY2FjaGUgPSBpb19hbGxvY19jYWNoZV9nZXQoJmN0eC0+dXJpbmdfY2Fj
aGUpOw0KPiAgCWlmIChjYWNoZSkgew0KPiArCQljYWNoZS0+b3BfZGF0YSA9IE5VTEw7DQoNCldo
eSBpcyBvcF9kYXRhIHNldCB0byBOVUxMIGhlcmU/IElmIHlvdSBhcmUgd29ycmllZCBhYm91dCBz
b21lIG9taXNzaW9ucywgd291bGQgaXQgYmUNCmJldHRlciB0byB1c2UgV0FSTl9PTiB0byBhc3Nl
cnQgdGhhdCBvcF9kYXRhIGlzIGEgbnVsbCBwb2ludGVyPyBUaGlzIHdpbGwgYWxzbyBtYWtlIGl0
IGVhc2llcg0KdG8gYW5hbHl6ZSB0aGUgY2F1c2Ugb2YgdGhlIHByb2JsZW0uDQoNCi0tLQ0KTGkg
WmV0YW8NCg==

