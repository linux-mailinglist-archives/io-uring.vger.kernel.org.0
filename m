Return-Path: <io-uring+bounces-6435-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC6BA35888
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 09:09:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C5077A1DE0
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 08:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ABF52222B6;
	Fri, 14 Feb 2025 08:08:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B8684037
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 08:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739520533; cv=none; b=gWcCBkYumJ4m7ANpgtYTQ49lZ7pAH/3YILXfzhpatDc6AcC5Jx8hnciWwiIG40NgGHRoFQbSDPpIB+lR8jDYXHT5R6i3n/Ep6Qfrr0yMj/3h3iNMqKQU9uKEN+Idb9AFRTyTjo61lhHA5GDv1GTznT+mY4hbjJA1FqcwWO2mSTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739520533; c=relaxed/simple;
	bh=cAak1B1y/e1DwS43hqVZ0aNQMdDp1F0NBs2mIuHnQws=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IVr+eKm6L89nhoTXhx74VwjAfYO5gRkubICIQonCrG4VLmtcoJWkcn2icqCHF3TTtb5EVA2aZLbPa4LGKXZRy82zenjnk1gxs3nQx8a9L8ty4tFp0NMmwiwx+CFzrfPY5tbF67/IS2CNksEi5bcnRSnG3Rel/SUbsvCT4WjsQcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YvPjR21Mmz1ltYx;
	Fri, 14 Feb 2025 16:04:59 +0800 (CST)
Received: from kwepemd500010.china.huawei.com (unknown [7.221.188.84])
	by mail.maildlp.com (Postfix) with ESMTPS id 59ABE140155;
	Fri, 14 Feb 2025 16:08:47 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd500010.china.huawei.com (7.221.188.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 14 Feb 2025 16:08:47 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Fri, 14 Feb 2025 16:08:46 +0800
From: lizetao <lizetao1@huawei.com>
To: Dmitry Antipov <dmantipov@yandex.ru>, Jens Axboe <axboe@kernel.dk>
CC: Jeff Moyer <jmoyer@redhat.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
Subject: RE: [PATCH] io_uring: avoid implicit conversion to ktime_t
Thread-Topic: [PATCH] io_uring: avoid implicit conversion to ktime_t
Thread-Index: AQHbfrPUl8B2ym1e3kCBJmlb+6hkgbNGcbDA
Date: Fri, 14 Feb 2025 08:08:46 +0000
Message-ID: <9e2073ea0a744a40be6b81d6d329550c@huawei.com>
References: <20250214073954.3641025-1-dmantipov@yandex.ru>
In-Reply-To: <20250214073954.3641025-1-dmantipov@yandex.ru>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRG1pdHJ5IEFudGlw
b3YgPGRtYW50aXBvdkB5YW5kZXgucnU+DQo+IFNlbnQ6IEZyaWRheSwgRmVicnVhcnkgMTQsIDIw
MjUgMzo0MCBQTQ0KPiBUbzogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPg0KPiBDYzogSmVm
ZiBNb3llciA8am1veWVyQHJlZGhhdC5jb20+OyBpby11cmluZ0B2Z2VyLmtlcm5lbC5vcmc7IERt
aXRyeQ0KPiBBbnRpcG92IDxkbWFudGlwb3ZAeWFuZGV4LnJ1Pg0KPiBTdWJqZWN0OiBbUEFUQ0hd
IGlvX3VyaW5nOiBhdm9pZCBpbXBsaWNpdCBjb252ZXJzaW9uIHRvIGt0aW1lX3QNCj4gDQo+IElu
ICdpb19nZXRfZXh0X2FyZygpJywgZG8gbm90IGFzc3VtZSB0aGF0ICdtaW5fd2FpdF91c2VjJyBv
ZiAnc3RydWN0DQo+IGlvX3VyaW5nX2dldGV2ZW50c19hcmcnICh3aGljaCBpcyAnX191MzInKSBt
dWx0aXBsaWVkIGJ5IE5TRUNfUEVSX1VTRUMgbWF5DQo+IGJlIGltcGxpY2l0bHkgY29udmVydGVk
IHRvICdrdGltZV90JyBidXQgdXNlIHRoZSBjb252ZW5pZW50ICd1c190b19rdGltZSgpJw0KPiBo
ZWxwZXIgaW5zdGVhZC4gQ29tcGlsZSB0ZXN0ZWQgb25seS4NCj4gDQo+IFN1Z2dlc3RlZC1ieTog
SmVmZiBNb3llciA8am1veWVyQHJlZGhhdC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IERtaXRyeSBB
bnRpcG92IDxkbWFudGlwb3ZAeWFuZGV4LnJ1Pg0KPiAtLS0NCj4gSSBkaWRuJ3QgYWRkIEZpeGVz
OiBhcyBwZXIgSmVmZidzIHJlbWFyayBhdCBodHRwczovL2xvcmUua2VybmVsLm9yZy9pby0NCj4g
dXJpbmcveDQ5ZWQwMWxrc28uZnNmQHNlZ2ZhdWx0LnVzZXJzeXMucmVkaGF0LmNvbS9ULyN0Ow0K
PiBpZiB5b3UgdGhpbmsgdGhhdCBpdCBzaG91bGQgYmUsIG1vc3QgbGlrZWx5IHRoZXkgYXJlOg0K
PiANCj4gYWEwMGY2N2FkYzJjICgiaW9fdXJpbmc6IGFkZCBzdXBwb3J0IGZvciBmaXhlZCB3YWl0
IHJlZ2lvbnMiKQ0KPiA3ZWQ5ZTA5ZTJkMTMgKCJpb191cmluZzogd2lyZSB1cCBtaW4gYmF0Y2gg
d2FrZSB0aW1lb3V0IikNCj4gLS0tDQo+ICBpb191cmluZy9pb191cmluZy5jIHwgNCArKy0tDQo+
ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2lvX3VyaW5nL2lvX3VyaW5nLmMgYi9pb191cmluZy9pb191cmluZy5jIGlu
ZGV4DQo+IDdmMjUwMGFjYTk1Yy4uZjczNTU1ZTk4MWZhIDEwMDY0NA0KPiAtLS0gYS9pb191cmlu
Zy9pb191cmluZy5jDQo+ICsrKyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMNCj4gQEAgLTMyNTcsNyAr
MzI1Nyw3IEBAIHN0YXRpYyBpbnQgaW9fZ2V0X2V4dF9hcmcoc3RydWN0IGlvX3JpbmdfY3R4ICpj
dHgsDQo+IHVuc2lnbmVkIGZsYWdzLA0KPiANCj4gIAkJaWYgKHctPmZsYWdzICYgfklPUklOR19S
RUdfV0FJVF9UUykNCj4gIAkJCXJldHVybiAtRUlOVkFMOw0KPiAtCQlleHRfYXJnLT5taW5fdGlt
ZSA9IFJFQURfT05DRSh3LT5taW5fd2FpdF91c2VjKSAqDQo+IE5TRUNfUEVSX1VTRUM7DQo+ICsJ
CWV4dF9hcmctPm1pbl90aW1lID0gdXNfdG9fa3RpbWUoUkVBRF9PTkNFKHctDQo+ID5taW5fd2Fp
dF91c2VjKSk7DQo+ICAJCWV4dF9hcmctPnNpZyA9IHU2NF90b191c2VyX3B0cihSRUFEX09OQ0Uo
dy0+c2lnbWFzaykpOw0KPiAgCQlleHRfYXJnLT5hcmdzeiA9IFJFQURfT05DRSh3LT5zaWdtYXNr
X3N6KTsNCj4gIAkJaWYgKHctPmZsYWdzICYgSU9SSU5HX1JFR19XQUlUX1RTKSB7DQo+IEBAIC0z
Mjg2LDcgKzMyODYsNyBAQCBzdGF0aWMgaW50IGlvX2dldF9leHRfYXJnKHN0cnVjdCBpb19yaW5n
X2N0eCAqY3R4LA0KPiB1bnNpZ25lZCBmbGFncywNCj4gIAlpZiAoY29weV9mcm9tX3VzZXIoJmFy
ZywgdWFyZywgc2l6ZW9mKGFyZykpKQ0KPiAgCQlyZXR1cm4gLUVGQVVMVDsNCj4gICNlbmRpZg0K
PiAtCWV4dF9hcmctPm1pbl90aW1lID0gYXJnLm1pbl93YWl0X3VzZWMgKiBOU0VDX1BFUl9VU0VD
Ow0KPiArCWV4dF9hcmctPm1pbl90aW1lID0gdXNfdG9fa3RpbWUoYXJnLm1pbl93YWl0X3VzZWMp
Ow0KPiAgCWV4dF9hcmctPnNpZyA9IHU2NF90b191c2VyX3B0cihhcmcuc2lnbWFzayk7DQo+ICAJ
ZXh0X2FyZy0+YXJnc3ogPSBhcmcuc2lnbWFza19zejsNCj4gIAlpZiAoYXJnLnRzKSB7DQo+IC0t
DQo+IDIuNDguMQ0KPiANCj4gDQoNClJldmlld2VkLWJ5OiBMaSBaZXRhbyA8bGl6ZXRhbzFAaHVh
d2VpLmNvbT4NCg0KLS0tDQpMaSBaZXRhbw0K

