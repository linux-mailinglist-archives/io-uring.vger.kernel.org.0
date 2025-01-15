Return-Path: <io-uring+bounces-5865-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8672FA116DA
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 02:51:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC08C188AD48
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 01:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 264623597F;
	Wed, 15 Jan 2025 01:50:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FF33B1A1
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 01:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736905843; cv=none; b=h8PZxD5T/EZkUAI5+l3YNLcSWOM4qtQlr4qlij2MSNPid0hBpvYRFPxCBDM87k8r4Aim7cGykeczkXqGzc+IRKgRtUO/+zI7kZbtOC4qE+vf1T9NgCXQqYvXCK/mVFcKm7n55aOfqdfWlyehya6ei4v9q6NQis6FFa2nSBFmoMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736905843; c=relaxed/simple;
	bh=0k15K5k8FQbZNIDaQyU1xNwiMgVyy2PoRyHQ/dfVHqw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PPjKztGN1RHrpXEXMYUqk9YCPUq83VcsEfLBu6PMaVTptOqgshLA++dEnDQ+HNlfpGfYrJOkS/jijuzHzZlhUWMjydUWhgOi2x8WHC1TqRhyfgjaSOcCmlqSweNp1lbWZC1noUPGq94nJvpRRSnS4ra3Qec9Gqo2HwLotA3hnCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4YXpmS2LPmzRlH7;
	Wed, 15 Jan 2025 09:48:08 +0800 (CST)
Received: from kwepemd200012.china.huawei.com (unknown [7.221.188.145])
	by mail.maildlp.com (Postfix) with ESMTPS id B8003140417;
	Wed, 15 Jan 2025 09:50:30 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200012.china.huawei.com (7.221.188.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 15 Jan 2025 09:50:30 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Wed, 15 Jan 2025 09:50:30 +0800
From: lizetao <lizetao1@huawei.com>
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: RE: [PATCH] io_uring/io-wq: Fix a small time window for reading
 work->flags
Thread-Topic: [PATCH] io_uring/io-wq: Fix a small time window for reading
 work->flags
Thread-Index: AdtmKOA8sg05Tt97QvCw7GBc1hDbnwANI7kAACRZjJA=
Date: Wed, 15 Jan 2025 01:50:30 +0000
Message-ID: <6d68ba2ae0d74895aec47379e94997cb@huawei.com>
References: <5fd306d40ebb4da0a657da9a9be5cec1@huawei.com>
 <0993bb5e-debd-4513-9481-a7d93f8c3c25@gmail.com>
In-Reply-To: <0993bb5e-debd-4513-9481-a7d93f8c3c25@gmail.com>
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
b3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgSmFudWFyeSAx
NSwgMjAyNSAxMjoyMiBBTQ0KPiBUbzogbGl6ZXRhbyA8bGl6ZXRhbzFAaHVhd2VpLmNvbT47IEpl
bnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4NCj4gQ2M6IGlvLXVyaW5nQHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBpb191cmluZy9pby13cTogRml4IGEgc21hbGwgdGlt
ZSB3aW5kb3cgZm9yIHJlYWRpbmcgd29yay0NCj4gPmZsYWdzDQo+IA0KPiBPbiAxLzE0LzI1IDAy
OjA2LCBsaXpldGFvIHdyb3RlOg0KPiA+IFRoZXJlIGlzIGEgc21hbGwgdGltZSB3aW5kb3cgdGhh
dCBpcyBtb2RpZmllZCBieSBvdGhlciB0YXNrcyBhZnRlcg0KPiA+IHJlYWRpbmcgd29yay0+Zmxh
Z3MuIEl0IGlzIGNoYW5nZWQgdG8gcmVhZCBiZWZvcmUgdXNlLCB3aGljaCBpcyBtb3JlDQo+IA0K
PiBDYW4geW91IGVsYWJvcmF0ZSBvbiB3aGF0IHJhY2VzIHdpdGggd2hhdD8gSSBkb24ndCBpbW1l
ZGlhdGVseSBzZWUgYW55IHJhY2UNCj4gaGVyZS4NCg0KVGhlcmUgaXMgc3VjaCBhIHJhY2UgY29u
dGV4dDoNCgkNCgl3b3JrZXIJCQkJCQkJCQkJCQlwcm9jZXNzDQppb193b3JrZXJfaGFuZGxlX3dv
cms6CQkJCQkJCQkJCUlPUklOR19PUF9BU1lOQ19DQU5DRUwNCglpb193cV9lbnF1ZXVlCQkJCQkJ
CQkJCV9faW9fd3Ffd29ya2VyX2NhbmNlbA0KCQl3b3JrX2ZsYWdzID0gYXRvbWljX3JlYWQoJndv
cmstPmZsYWdzKTsJLy8gbm8gSU9fV1FfV09SS19DQU5DRUwJCQ0KCQkJCQkJCQkJCQkJCWF0b21p
Y19vcihJT19XUV9XT1JLX0NBTkNFTCwgJndvcmstPmZsYWdzKTsNCgkJaWYgKHdvcmtfZmxhZ3Mg
JiBJT19XUV9XT1JLX0NBTkNFTCkJLy8gZmFsc2UNCg0KVGhlcmUgc2VlbXMgdG8gYmUgYSBzbWFs
bCB0aW1lIHdpbmRvdyBoZXJlLCByZXN1bHRpbmcgaW4gdGhlIGxhdGVzdCBmbGFncyBub3QgYmVp
bmcgdXNlZC4NCg0KPiANCj4gPiBpbiBsaW5lIHdpdGggdGhlIHNlbWFudGljcyBvZiBhdG9tcy4N
Cj4gPiBGaXhlczogMzQ3NGQxYjkzZjg5ICgiaW9fdXJpbmcvaW8td3E6IG1ha2UgaW9fd3Ffd29y
ayBmbGFncyBhdG9taWMiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IExpIFpldGFvIDxsaXpldGFvMUBo
dWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+ICAgaW9fdXJpbmcvaW8td3EuYyB8IDUgKystLS0NCj4g
PiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvaW8td3EuYyBiL2lvX3VyaW5nL2lvLXdxLmMgaW5k
ZXgNCj4gPiBhMzhmMzZiNjgwNjAuLjc1MDk2ZTc3YjFmZSAxMDA2NDQNCj4gPiAtLS0gYS9pb191
cmluZy9pby13cS5jDQo+ID4gKysrIGIvaW9fdXJpbmcvaW8td3EuYw0KPiA+IEBAIC05MzIsNyAr
OTMyLDYgQEAgc3RhdGljIGJvb2wgaW9fd3Ffd29ya19tYXRjaF9pdGVtKHN0cnVjdA0KPiBpb193
cV93b3JrICp3b3JrLCB2b2lkICpkYXRhKQ0KPiA+ICAgdm9pZCBpb193cV9lbnF1ZXVlKHN0cnVj
dCBpb193cSAqd3EsIHN0cnVjdCBpb193cV93b3JrICp3b3JrKQ0KPiA+ICAgew0KPiA+ICAgCXN0
cnVjdCBpb193cV9hY2N0ICphY2N0ID0gaW9fd29ya19nZXRfYWNjdCh3cSwgd29yayk7DQo+ID4g
LQl1bnNpZ25lZCBpbnQgd29ya19mbGFncyA9IGF0b21pY19yZWFkKCZ3b3JrLT5mbGFncyk7DQo+
ID4gICAJc3RydWN0IGlvX2NiX2NhbmNlbF9kYXRhIG1hdGNoID0gew0KPiA+ICAgCQkuZm4JCT0g
aW9fd3Ffd29ya19tYXRjaF9pdGVtLA0KPiA+ICAgCQkuZGF0YQkJPSB3b3JrLA0KPiA+IEBAIC05
NDUsNyArOTQ0LDcgQEAgdm9pZCBpb193cV9lbnF1ZXVlKHN0cnVjdCBpb193cSAqd3EsIHN0cnVj
dA0KPiBpb193cV93b3JrICp3b3JrKQ0KPiA+ICAgCSAqIGJlZW4gbWFya2VkIGFzIG9uZSB0aGF0
IHNob3VsZCBub3QgZ2V0IGV4ZWN1dGVkLCBjYW5jZWwgaXQgaGVyZS4NCj4gPiAgIAkgKi8NCj4g
PiAgIAlpZiAodGVzdF9iaXQoSU9fV1FfQklUX0VYSVQsICZ3cS0+c3RhdGUpIHx8DQo+ID4gLQkg
ICAgKHdvcmtfZmxhZ3MgJiBJT19XUV9XT1JLX0NBTkNFTCkpIHsNCj4gPiArCSAgICAoYXRvbWlj
X3JlYWQoJndvcmstPmZsYWdzKSAmIElPX1dRX1dPUktfQ0FOQ0VMKSkgew0KPiA+ICAgCQlpb19y
dW5fY2FuY2VsKHdvcmssIHdxKTsNCj4gPiAgIAkJcmV0dXJuOw0KPiA+ICAgCX0NCj4gPiBAQCAt
OTU5LDcgKzk1OCw3IEBAIHZvaWQgaW9fd3FfZW5xdWV1ZShzdHJ1Y3QgaW9fd3EgKndxLCBzdHJ1
Y3QNCj4gaW9fd3Ffd29yayAqd29yaykNCj4gPiAgIAlkb19jcmVhdGUgPSAhaW9fd3FfYWN0aXZh
dGVfZnJlZV93b3JrZXIod3EsIGFjY3QpOw0KPiA+ICAgCXJjdV9yZWFkX3VubG9jaygpOw0KPiA+
DQo+ID4gLQlpZiAoZG9fY3JlYXRlICYmICgod29ya19mbGFncyAmIElPX1dRX1dPUktfQ09OQ1VS
UkVOVCkgfHwNCj4gPiArCWlmIChkb19jcmVhdGUgJiYgKChhdG9taWNfcmVhZCgmd29yay0+Zmxh
Z3MpICYNCj4gPiArSU9fV1FfV09SS19DT05DVVJSRU5UKSB8fA0KPiA+ICAgCSAgICAhYXRvbWlj
X3JlYWQoJmFjY3QtPm5yX3J1bm5pbmcpKSkgew0KPiA+ICAgCQlib29sIGRpZF9jcmVhdGU7DQo+
ID4NCj4gDQo+IC0tDQo+IFBhdmVsIEJlZ3Vua292DQoNCg0KLS0tDQpMaSBaZXRhbw0KDQo=

