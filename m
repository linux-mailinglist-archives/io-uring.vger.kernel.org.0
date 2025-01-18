Return-Path: <io-uring+bounces-5996-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB05A15C44
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 11:00:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEC433A81CC
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 10:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0427816CD33;
	Sat, 18 Jan 2025 10:00:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93551552E3
	for <io-uring@vger.kernel.org>; Sat, 18 Jan 2025 10:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737194439; cv=none; b=WL9LStvaKgnw9UjPZ1qUB2dBqcfLbTth3oIyrRCkMaeF2mHDz7yRfxBbzo/SW7hq+jimHZN5Oc+NeMwk5gQAbB5LZblX+s+AqFzykPih7ckg1sKq6qXNy0VJj5WubYJj8Bof+rslY5Lt3MNryUS6KDl3z0Hmuvf4NwiD1/Em6RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737194439; c=relaxed/simple;
	bh=1CKjoC61DsdZ/dOV9au4mXeUpJDgxSjBG7C0mAnUAHs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=drnBi8+W3SsKxuJwRu8361AxbBpvQLuZoEroPKZIfTcxYrQc60j7zmqfvRDuxbUOClrUyoPe7TrjfQsb74oAAS7pvjYXYO5Mvr5VqFlN7VfdxtTzrZOfxkEbq783k9pUHa7qrOysyRirZ4hfH5rzPWzeyLMukVhe3cwBFSMEx9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YZs681kxyzrSVT;
	Sat, 18 Jan 2025 17:40:32 +0800 (CST)
Received: from kwepemd200010.china.huawei.com (unknown [7.221.188.124])
	by mail.maildlp.com (Postfix) with ESMTPS id D5E49180217;
	Sat, 18 Jan 2025 17:42:11 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200010.china.huawei.com (7.221.188.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 18 Jan 2025 17:42:11 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Sat, 18 Jan 2025 17:42:11 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: RE: [PATCH] test/defer: fix deadlock when io_uring_submit fail
Thread-Topic: [PATCH] test/defer: fix deadlock when io_uring_submit fail
Thread-Index: AdtnTle0AdCKvQv4QCG1RPRIudIQwwAlLjSAAGp9rIA=
Date: Sat, 18 Jan 2025 09:42:11 +0000
Message-ID: <e3567f48dad84d06bbca5d40d1ec79c0@huawei.com>
References: <77ab74b3fdff491db2a5596b1edc86b6@huawei.com>
 <70895666-4ec5-4a2e-a9c2-33c296087beb@kernel.dk>
In-Reply-To: <70895666-4ec5-4a2e-a9c2-33c296087beb@kernel.dk>
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
YXhib2VAa2VybmVsLmRrPg0KPiBTZW50OiBUaHVyc2RheSwgSmFudWFyeSAxNiwgMjAyNSAxMDo1
MSBQTQ0KPiBUbzogbGl6ZXRhbyA8bGl6ZXRhbzFAaHVhd2VpLmNvbT47IFBhdmVsIEJlZ3Vua292
IDxhc21sLnNpbGVuY2VAZ21haWwuY29tPg0KPiBDYzogaW8tdXJpbmdAdmdlci5rZXJuZWwub3Jn
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHRlc3QvZGVmZXI6IGZpeCBkZWFkbG9jayB3aGVuIGlv
X3VyaW5nX3N1Ym1pdCBmYWlsDQo+IA0KPiBPbiAxLzE1LzI1IDY6MTAgQU0sIGxpemV0YW8gd3Jv
dGU6DQo+ID4gV2hpbGUgcGVyZm9ybWluZyBmYXVsdCBpbmplY3Rpb24gdGVzdGluZywgYSBidWcg
cmVwb3J0IHdhcyB0cmlnZ2VyZWQ6DQo+ID4NCj4gPiAgIEZBVUxUX0lOSkVDVElPTjogZm9yY2lu
ZyBhIGZhaWx1cmUuDQo+ID4gICBuYW1lIGZhaWxfdXNlcmNvcHksIGludGVydmFsIDEsIHByb2Jh
YmlsaXR5IDAsIHNwYWNlIDAsIHRpbWVzIDANCj4gPiAgIENQVTogMTIgVUlEOiAwIFBJRDogMTg3
OTUgQ29tbTogZGVmZXIudCBUYWludGVkOiBHICAgICAgICAgICBPDQo+IDYuMTMuMC1yYzYtZ2Yy
YTBhMzdiMTc0YiAjMTcNCj4gPiAgIFRhaW50ZWQ6IFtPXT1PT1RfTU9EVUxFDQo+ID4gICBIYXJk
d2FyZSBuYW1lOiBsaW51eCxkdW1teS12aXJ0IChEVCkNCj4gPiAgIENhbGwgdHJhY2U6DQo+ID4g
ICAgc2hvd19zdGFjaysweDIwLzB4MzggKEMpDQo+ID4gICAgZHVtcF9zdGFja19sdmwrMHg3OC8w
eDkwDQo+ID4gICAgZHVtcF9zdGFjaysweDFjLzB4MjgNCj4gPiAgICBzaG91bGRfZmFpbF9leCsw
eDU0NC8weDY0OA0KPiA+ICAgIHNob3VsZF9mYWlsKzB4MTQvMHgyMA0KPiA+ICAgIHNob3VsZF9m
YWlsX3VzZXJjb3B5KzB4MWMvMHgyOA0KPiA+ICAgIGdldF90aW1lc3BlYzY0KzB4N2MvMHgyNTgN
Cj4gPiAgICBfX2lvX3RpbWVvdXRfcHJlcCsweDMxYy8weDc5OA0KPiA+ICAgIGlvX2xpbmtfdGlt
ZW91dF9wcmVwKzB4MWMvMHgzMA0KPiA+ICAgIGlvX3N1Ym1pdF9zcWVzKzB4NTljLzB4MWQ1MA0K
PiA+ICAgIF9fYXJtNjRfc3lzX2lvX3VyaW5nX2VudGVyKzB4OGRjLzB4ZmEwDQo+ID4gICAgaW52
b2tlX3N5c2NhbGwrMHg3NC8weDI3MA0KPiA+ICAgIGVsMF9zdmNfY29tbW9uLmNvbnN0cHJvcC4w
KzB4YjQvMHgyNDANCj4gPiAgICBkb19lbDBfc3ZjKzB4NDgvMHg2OA0KPiA+ICAgIGVsMF9zdmMr
MHgzOC8weDc4DQo+ID4gICAgZWwwdF82NF9zeW5jX2hhbmRsZXIrMHhjOC8weGQwDQo+ID4gICAg
ZWwwdF82NF9zeW5jKzB4MTk4LzB4MWEwDQo+ID4NCj4gPiBUaGUgZGVhZGxvY2sgc3RhY2sgaXMg
YXMgZm9sbG93czoNCj4gPg0KPiA+ICAgaW9fY3FyaW5nX3dhaXQrMHhhNjQvMHgxMDYwDQo+ID4g
ICBfX2FybTY0X3N5c19pb191cmluZ19lbnRlcisweDQ2Yy8weGZhMA0KPiA+ICAgaW52b2tlX3N5
c2NhbGwrMHg3NC8weDI3MA0KPiA+ICAgZWwwX3N2Y19jb21tb24uY29uc3Rwcm9wLjArMHhiNC8w
eDI0MA0KPiA+ICAgZG9fZWwwX3N2YysweDQ4LzB4NjgNCj4gPiAgIGVsMF9zdmMrMHgzOC8weDc4
DQo+ID4gICBlbDB0XzY0X3N5bmNfaGFuZGxlcisweGM4LzB4ZDANCj4gPiAgIGVsMHRfNjRfc3lu
YysweDE5OC8weDFhMA0KPiA+DQo+ID4gVGhpcyBpcyBiZWNhdXNlIGFmdGVyIHRoZSBzdWJtaXNz
aW9uIGZhaWxzLCB0aGUgZGVmZXIudCB0ZXN0Y2FzZSBpcyBzdGlsbCB3YWl0aW5nIHRvDQo+IHN1
Ym1pdCB0aGUgZmFpbGVkIHJlcXVlc3QsIHJlc3VsdGluZyBpbiBhbiBldmVudHVhbCBkZWFkbG9j
ay4NCj4gPiBTb2x2ZSB0aGUgcHJvYmxlbSBieSB0ZWxsaW5nIHdhaXRfY3FlcyB0aGUgbnVtYmVy
IG9mIHJlcXVlc3RzIHRvIHdhaXQgZm9yLg0KPiANCj4gSSBzdXNwZWN0IHRoaXMgd291bGQgYmUg
Zml4ZWQgYnkgc2V0dGluZyBJT1JJTkdfU0VUVVBfU1VCTUlUX0FMTCBmb3IgcmluZyBpbml0LA0K
PiBzb21ldGhpbmcgcHJvYmFibHkgYWxsL21vc3QgdGVzdHMgc2hvdWxkIHNldC4NCg0KDQpJIHRl
c3RlZCBpdCBhbmQgZm91bmQgdGhhdCBJT1JJTkdfU0VUVVBfU1VCTUlUX0FMTCBjYW4gaW5kZWVk
IHNvbHZlIHRoaXMgcHJvYmxlbS4gDQpTaG91bGQgSSBqdXN0IG1vZGlmeSB0aGlzIHByb2JsZW0g
b3IgYWRkIElPUklOR19TRVRVUF9TVUJNSVRfQUxMIHRvIHRoZSBnZW5lcmFsIHBhdGggdG8NCnNv
bHZlIG1vc3QgcG9zc2libGUgcHJvYmxlbXM/DQo+IA0KPiAtLQ0KPiBKZW5zIEF4Ym9lDQoNCi0t
LQ0KTGkgWmV0YW8NCg0K

