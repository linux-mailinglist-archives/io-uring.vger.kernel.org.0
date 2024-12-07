Return-Path: <io-uring+bounces-5291-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D3F59E7E47
	for <lists+io-uring@lfdr.de>; Sat,  7 Dec 2024 06:19:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4ABF01885BB6
	for <lists+io-uring@lfdr.de>; Sat,  7 Dec 2024 05:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 878D81BDCF;
	Sat,  7 Dec 2024 05:19:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1505928FC
	for <io-uring@vger.kernel.org>; Sat,  7 Dec 2024 05:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733548789; cv=none; b=L+9VCsIN0AuA9h2ckssCR0vm02RGkUGiHA+eMs1WZ8HBFajceSfPaSxlehYi/qooXQFrsQ0C0+cAlPijLxdpXQJETkHxy5MmVyBQUaC2MUzG4soTeuD8mB322b/178O86VTS8W1pBTDg4ZZdITeENvrcDrpbc54HZ8OOnRzs96o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733548789; c=relaxed/simple;
	bh=QS4zMrssLXtvMeSJqnGuhItkdiXuGZamCdbKo7mEFe4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TderYNV5B5dABSKGXEEL7hhHRU+Kad4PBYNxBk8xXqlaciBvvHgwgT0UmfCuTCrr2xZ1QZN3S/7reISjs1pzoSd6XL0Hkk1BFzpehvbcZ9vNamYb1f+aWSL6zzMKz3D7KsbUbNLLPTRo2sTmfvX6NVds2oZ0+DYo7+XPo2Yr0eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Y4xF04cWRz11M3R;
	Sat,  7 Dec 2024 13:16:36 +0800 (CST)
Received: from kwepemd200012.china.huawei.com (unknown [7.221.188.145])
	by mail.maildlp.com (Postfix) with ESMTPS id 0EFC718007C;
	Sat,  7 Dec 2024 13:19:37 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200012.china.huawei.com (7.221.188.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 7 Dec 2024 13:19:36 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Sat, 7 Dec 2024 13:19:33 +0800
From: lizetao <lizetao1@huawei.com>
To: David Wei <dw@davidwei.uk>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Subject: RE: [PATCH for-next] io_uring: clean up io_prep_rw_setup()
Thread-Topic: [PATCH for-next] io_uring: clean up io_prep_rw_setup()
Thread-Index: AQHbSEDVaNypHsebjUu78aiyI549BbLaPiOQ
Date: Sat, 7 Dec 2024 05:19:33 +0000
Message-ID: <62af3d54790b4b3f9a83234d6259ca97@huawei.com>
References: <20241207004144.783631-1-dw@davidwei.uk>
In-Reply-To: <20241207004144.783631-1-dw@davidwei.uk>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgV2VpIDxkd0Bk
YXZpZHdlaS51az4NCj4gU2VudDogU2F0dXJkYXksIERlY2VtYmVyIDcsIDIwMjQgODo0MiBBTQ0K
PiBUbzogaW8tdXJpbmdAdmdlci5rZXJuZWwub3JnDQo+IENjOiBEYXZpZCBXZWkgPGR3QGRhdmlk
d2VpLnVrPjsgSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPjsgUGF2ZWwNCj4gQmVndW5rb3Yg
PGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCBmb3ItbmV4dF0gaW9f
dXJpbmc6IGNsZWFuIHVwIGlvX3ByZXBfcndfc2V0dXAoKQ0KPiANCj4gUmVtb3ZlIHVubmVjZXNz
YXJ5IGNhbGwgdG8gaW92X2l0ZXJfc2F2ZV9zdGF0ZSgpIGluIGlvX3ByZXBfcndfc2V0dXAoKSBh
cw0KPiBpb19pbXBvcnRfaW92ZWMoKSBhbHJlYWR5IGRvZXMgdGhpcy4gVGhlbiB0aGUgcmVzdWx0
IGZyb20NCj4gaW9faW1wb3J0X2lvdmVjKCkgY2FuIGJlIHJldHVybmVkIGRpcmVjdGx5Lg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogRGF2aWQgV2VpIDxkd0BkYXZpZHdlaS51az4NCj4gLS0tDQo+ICBp
b191cmluZy9ydy5jIHwgOCArLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCA3IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2lvX3VyaW5nL3J3LmMgYi9p
b191cmluZy9ydy5jIGluZGV4IDA0ZTQ0NjdhYjBlZS4uNWIyNGZkOGI2OWY2DQo+IDEwMDY0NA0K
PiAtLS0gYS9pb191cmluZy9ydy5jDQo+ICsrKyBiL2lvX3VyaW5nL3J3LmMNCj4gQEAgLTI0MCw3
ICsyNDAsNiBAQCBzdGF0aWMgaW50IGlvX3J3X2FsbG9jX2FzeW5jKHN0cnVjdCBpb19raW9jYiAq
cmVxKQ0KPiBzdGF0aWMgaW50IGlvX3ByZXBfcndfc2V0dXAoc3RydWN0IGlvX2tpb2NiICpyZXEs
IGludCBkZGlyLCBib29sIGRvX2ltcG9ydCkgIHsNCj4gIAlzdHJ1Y3QgaW9fYXN5bmNfcncgKnJ3
Ow0KPiAtCWludCByZXQ7DQo+IA0KPiAgCWlmIChpb19yd19hbGxvY19hc3luYyhyZXEpKQ0KPiAg
CQlyZXR1cm4gLUVOT01FTTsNCj4gQEAgLTI0OSwxMiArMjQ4LDcgQEAgc3RhdGljIGludCBpb19w
cmVwX3J3X3NldHVwKHN0cnVjdCBpb19raW9jYiAqcmVxLCBpbnQNCj4gZGRpciwgYm9vbCBkb19p
bXBvcnQpDQo+ICAJCXJldHVybiAwOw0KPiANCj4gIAlydyA9IHJlcS0+YXN5bmNfZGF0YTsNCj4g
LQlyZXQgPSBpb19pbXBvcnRfaW92ZWMoZGRpciwgcmVxLCBydywgMCk7DQo+IC0JaWYgKHVubGlr
ZWx5KHJldCA8IDApKQ0KPiAtCQlyZXR1cm4gcmV0Ow0KPiAtDQo+IC0JaW92X2l0ZXJfc2F2ZV9z
dGF0ZSgmcnctPml0ZXIsICZydy0+aXRlcl9zdGF0ZSk7DQo+IC0JcmV0dXJuIDA7DQo+ICsJcmV0
dXJuIGlvX2ltcG9ydF9pb3ZlYyhkZGlyLCByZXEsIHJ3LCAwKTsNCj4gIH0NCj4gDQo+ICBzdGF0
aWMgaW5saW5lIHZvaWQgaW9fbWV0YV9zYXZlX3N0YXRlKHN0cnVjdCBpb19hc3luY19ydyAqaW8p
DQo+IC0tDQo+IDIuNDMuNQ0KPiANCg0KTG9vayBnb29kIHRvIG1lLiBObyBsb2dpYyBjaGFuZ2Vz
LCBvbmx5IGNvbXBpbGF0aW9uIGFuZCB0ZXN0aW5nLg0KVGVzdGVkLWJ5OiBMaSBaZXRhbyA8bGl6
ZXRhbzFAaHVhd2VpLmNvbT4NCg==

