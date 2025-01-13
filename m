Return-Path: <io-uring+bounces-5840-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52802A0B043
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 08:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C2841881E2E
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 07:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C583231A5B;
	Mon, 13 Jan 2025 07:49:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B7C3C1F;
	Mon, 13 Jan 2025 07:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736754559; cv=none; b=j5FoSNoLphJCWQW7l3J22fZAw23F2h5uvbszlQ2ZRVqWsA6w9L8BkpM8tkB9aGZrES+Q57sAwdaJ8ywOo8zmsUMLOs9g4sZEyD/lqbQctljLXAeeB2eXp91EM8dt2UCDQGP7ket4G4mlk3RSL3TYv2czqRmtjOjdtAXSJ4Mra0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736754559; c=relaxed/simple;
	bh=FnN71iyjFIJmgiI/6QSVhhE9UDtgpu8STC1sn+73TYw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jFbA+TWMgn7Ga5v6sqZePFoGPyVRkHYrJvjOgvNWElCUtDbSakAkhs/9EubtC58NOxx369na3iZaDwr7JlGivAnxDsIk3irclePAHfyLZiwh2psuVxa8/p08ULEKfvjIkEyGptbj8SYEHjoSoKng03noeoNqMAndA2WLd7069I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4YWktK3kt2z2y8vY;
	Mon, 13 Jan 2025 15:49:29 +0800 (CST)
Received: from kwepemd200010.china.huawei.com (unknown [7.221.188.124])
	by mail.maildlp.com (Postfix) with ESMTPS id D8C081402C3;
	Mon, 13 Jan 2025 15:49:05 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200010.china.huawei.com (7.221.188.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 13 Jan 2025 15:49:05 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Mon, 13 Jan 2025 15:49:05 +0800
From: lizetao <lizetao1@huawei.com>
To: Bui Quang Minh <minhquangbui99@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com"
	<syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com>
Subject: RE: [PATCH] io_uring: simplify the SQPOLL thread check when
 cancelling requests
Thread-Topic: [PATCH] io_uring: simplify the SQPOLL thread check when
 cancelling requests
Thread-Index: AQHbZQBAfPWaG4hxx06y9utYvVroALMUVSEg
Date: Mon, 13 Jan 2025 07:49:05 +0000
Message-ID: <e9e5bda7706244598c977c8cfaeaca38@huawei.com>
References: <20250112143358.49671-1-minhquangbui99@gmail.com>
In-Reply-To: <20250112143358.49671-1-minhquangbui99@gmail.com>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQnVpIFF1YW5nIE1pbmgg
PG1pbmhxdWFuZ2J1aTk5QGdtYWlsLmNvbT4NCj4gU2VudDogU3VuZGF5LCBKYW51YXJ5IDEyLCAy
MDI1IDEwOjM0IFBNDQo+IFRvOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IENjOiBC
dWkgUXVhbmcgTWluaCA8bWluaHF1YW5nYnVpOTlAZ21haWwuY29tPjsgSmVucyBBeGJvZQ0KPiA8
YXhib2VAa2VybmVsLmRrPjsgUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+
OyBpby0NCj4gdXJpbmdAdmdlci5rZXJuZWwub3JnOw0KPiBzeXpib3QrM2M3NTBiZTAxZGFiNjcy
YzUxM2RAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbTsgbGl6ZXRhbw0KPiA8bGl6ZXRhbzFAaHVh
d2VpLmNvbT4NCj4gU3ViamVjdDogW1BBVENIXSBpb191cmluZzogc2ltcGxpZnkgdGhlIFNRUE9M
TCB0aHJlYWQgY2hlY2sgd2hlbiBjYW5jZWxsaW5nDQo+IHJlcXVlc3RzDQo+IA0KPiBJbiBpb191
cmluZ190cnlfY2FuY2VsX3JlcXVlc3RzLCB3ZSBjaGVjayB3aGV0aGVyIHNxX2RhdGEtPnRocmVh
ZCA9PQ0KPiBjdXJyZW50IHRvIGRldGVybWluZSBpZiB0aGUgZnVuY3Rpb24gaXMgY2FsbGVkIGJ5
IHRoZSBTUVBPTEwgdGhyZWFkIHRvIGRvIGlvcG9sbA0KPiB3aGVuIElPUklOR19TRVRVUF9TUVBP
TEwgaXMgc2V0LiBUaGlzIGNoZWNrIGNhbiByYWNlIHdpdGggdGhlIFNRUE9MTA0KPiB0aHJlYWQg
dGVybWluYXRpb24uDQo+IA0KPiBpb191cmluZ19jYW5jZWxfZ2VuZXJpYyBpcyB1c2VkIGluIDIg
cGxhY2VzOiBpb191cmluZ19jYW5jZWxfZ2VuZXJpYyBhbmQNCj4gaW9fcmluZ19leGl0X3dvcmsu
IEluIGlvX3VyaW5nX2NhbmNlbF9nZW5lcmljLCB3ZSBoYXZlIHRoZSBpbmZvcm1hdGlvbg0KPiB3
aGV0aGVyIHRoZSBjdXJyZW50IGlzIFNRUE9MTCB0aHJlYWQgYWxyZWFkeS4gSW4gaW9fcmluZ19l
eGl0X3dvcmssIGluIGNhc2UNCj4gdGhlIFNRUE9MTCB0aHJlYWQgcmVhY2hlcyB0aGlzIHBhdGgs
IHdlIGRvbid0IG5lZWQgdG8gaW9wb2xsIGFuZCBsZWF2ZSB0aGF0IGZvcg0KPiBpb191cmluZ19j
YW5jZWxfZ2VuZXJpYyB0byBoYW5kbGUuDQo+IA0KPiBTbyB0byBhdm9pZCB0aGUgcmFjeSBjaGVj
aywgdGhpcyBjb21taXQgYWRkcyBhIGJvb2xlYW4gZmxhZyB0bw0KPiBpb191cmluZ190cnlfY2Fu
Y2VsX3JlcXVlc3RzIHRvIGRldGVybWluZSBpZiB3ZSBuZWVkIHRvIGRvIGlvcG9sbCBpbnNpZGUg
dGhlDQo+IGZ1bmN0aW9uIGFuZCBvbmx5IHNldHMgdGhpcyBmbGFnIGluIGlvX3VyaW5nX2NhbmNl
bF9nZW5lcmljIHdoZW4gdGhlIGN1cnJlbnQgaXMNCj4gU1FQT0xMIHRocmVhZC4NCj4gDQo+IFJl
cG9ydGVkLWJ5OiBzeXpib3QrM2M3NTBiZTAxZGFiNjcyYzUxM2RAc3l6a2FsbGVyLmFwcHNwb3Rt
YWlsLmNvbQ0KPiBSZXBvcnRlZC1ieTogTGkgWmV0YW8gPGxpemV0YW8xQGh1YXdlaS5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IEJ1aSBRdWFuZyBNaW5oIDxtaW5ocXVhbmdidWk5OUBnbWFpbC5jb20+
DQo+IC0tLQ0KPiAgaW9fdXJpbmcvaW9fdXJpbmcuYyB8IDIxICsrKysrKysrKysrKysrKy0tLS0t
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvaW9fdXJpbmcuYyBiL2lvX3VyaW5nL2lvX3VyaW5n
LmMgaW5kZXgNCj4gZmY2OTFmMzc0NjJjLi5mMjhlYTEyNTQxNDMgMTAwNjQ0DQo+IC0tLSBhL2lv
X3VyaW5nL2lvX3VyaW5nLmMNCj4gKysrIGIvaW9fdXJpbmcvaW9fdXJpbmcuYw0KPiBAQCAtMTQz
LDcgKzE0Myw4IEBAIHN0cnVjdCBpb19kZWZlcl9lbnRyeSB7DQo+IA0KPiAgc3RhdGljIGJvb2wg
aW9fdXJpbmdfdHJ5X2NhbmNlbF9yZXF1ZXN0cyhzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwNCj4g
IAkJCQkJIHN0cnVjdCBpb191cmluZ190YXNrICp0Y3R4LA0KPiAtCQkJCQkgYm9vbCBjYW5jZWxf
YWxsKTsNCj4gKwkJCQkJIGJvb2wgY2FuY2VsX2FsbCwNCj4gKwkJCQkJIGJvb2wgZm9yY2VfaW9w
b2xsKTsNCj4gDQo+ICBzdGF0aWMgdm9pZCBpb19xdWV1ZV9zcWUoc3RydWN0IGlvX2tpb2NiICpy
ZXEpOw0KPiANCj4gQEAgLTI4OTgsNyArMjg5OSwxMiBAQCBzdGF0aWMgX19jb2xkIHZvaWQgaW9f
cmluZ19leGl0X3dvcmsoc3RydWN0DQo+IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiAgCQlpZiAoY3R4
LT5mbGFncyAmIElPUklOR19TRVRVUF9ERUZFUl9UQVNLUlVOKQ0KPiAgCQkJaW9fbW92ZV90YXNr
X3dvcmtfZnJvbV9sb2NhbChjdHgpOw0KPiANCj4gLQkJd2hpbGUgKGlvX3VyaW5nX3RyeV9jYW5j
ZWxfcmVxdWVzdHMoY3R4LCBOVUxMLCB0cnVlKSkNCj4gKwkJLyoNCj4gKwkJICogRXZlbiBpZiBT
UVBPTEwgdGhyZWFkIHJlYWNoZXMgdGhpcyBwYXRoLCBkb24ndCBmb3JjZQ0KPiArCQkgKiBpb3Bv
bGwgaGVyZSwgbGV0IHRoZSBpb191cmluZ19jYW5jZWxfZ2VuZXJpYyBoYW5kbGUNCj4gKwkJICog
aXQuDQo+ICsJCSAqLw0KPiArCQl3aGlsZSAoaW9fdXJpbmdfdHJ5X2NhbmNlbF9yZXF1ZXN0cyhj
dHgsIE5VTEwsIHRydWUsIGZhbHNlKSkNCj4gIAkJCWNvbmRfcmVzY2hlZCgpOw0KPiANCj4gIAkJ
aWYgKGN0eC0+c3FfZGF0YSkgew0KPiBAQCAtMzA2Niw3ICszMDcyLDggQEAgc3RhdGljIF9fY29s
ZCBib29sIGlvX3VyaW5nX3RyeV9jYW5jZWxfaW93cShzdHJ1Y3QNCj4gaW9fcmluZ19jdHggKmN0
eCkNCj4gDQo+ICBzdGF0aWMgX19jb2xkIGJvb2wgaW9fdXJpbmdfdHJ5X2NhbmNlbF9yZXF1ZXN0
cyhzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwNCj4gIAkJCQkJCXN0cnVjdCBpb191cmluZ190YXNr
ICp0Y3R4LA0KPiAtCQkJCQkJYm9vbCBjYW5jZWxfYWxsKQ0KPiArCQkJCQkJYm9vbCBjYW5jZWxf
YWxsLA0KPiArCQkJCQkJYm9vbCBmb3JjZV9pb3BvbGwpDQo+ICB7DQo+ICAJc3RydWN0IGlvX3Rh
c2tfY2FuY2VsIGNhbmNlbCA9IHsgLnRjdHggPSB0Y3R4LCAuYWxsID0gY2FuY2VsX2FsbCwgfTsN
Cj4gIAllbnVtIGlvX3dxX2NhbmNlbCBjcmV0Ow0KPiBAQCAtMzA5Niw3ICszMTAzLDcgQEAgc3Rh
dGljIF9fY29sZCBib29sDQo+IGlvX3VyaW5nX3RyeV9jYW5jZWxfcmVxdWVzdHMoc3RydWN0IGlv
X3JpbmdfY3R4ICpjdHgsDQo+IA0KPiAgCS8qIFNRUE9MTCB0aHJlYWQgZG9lcyBpdHMgb3duIHBv
bGxpbmcgKi8NCj4gIAlpZiAoKCEoY3R4LT5mbGFncyAmIElPUklOR19TRVRVUF9TUVBPTEwpICYm
IGNhbmNlbF9hbGwpIHx8DQo+IC0JICAgIChjdHgtPnNxX2RhdGEgJiYgY3R4LT5zcV9kYXRhLT50
aHJlYWQgPT0gY3VycmVudCkpIHsNCj4gKwkgICAgZm9yY2VfaW9wb2xsKSB7DQo+ICAJCXdoaWxl
ICghd3FfbGlzdF9lbXB0eSgmY3R4LT5pb3BvbGxfbGlzdCkpIHsNCj4gIAkJCWlvX2lvcG9sbF90
cnlfcmVhcF9ldmVudHMoY3R4KTsNCj4gIAkJCXJldCA9IHRydWU7DQo+IEBAIC0zMTY5LDEzICsz
MTc2LDE1IEBAIF9fY29sZCB2b2lkIGlvX3VyaW5nX2NhbmNlbF9nZW5lcmljKGJvb2wNCj4gY2Fu
Y2VsX2FsbCwgc3RydWN0IGlvX3NxX2RhdGEgKnNxZCkNCj4gIAkJCQkJY29udGludWU7DQo+ICAJ
CQkJbG9vcCB8PSBpb191cmluZ190cnlfY2FuY2VsX3JlcXVlc3RzKG5vZGUtDQo+ID5jdHgsDQo+
ICAJCQkJCQkJY3VycmVudC0+aW9fdXJpbmcsDQo+IC0JCQkJCQkJY2FuY2VsX2FsbCk7DQo+ICsJ
CQkJCQkJY2FuY2VsX2FsbCwNCj4gKwkJCQkJCQlmYWxzZSk7DQo+ICAJCQl9DQo+ICAJCX0gZWxz
ZSB7DQo+ICAJCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGN0eCwgJnNxZC0+Y3R4X2xpc3QsIHNxZF9s
aXN0KQ0KPiAgCQkJCWxvb3AgfD0gaW9fdXJpbmdfdHJ5X2NhbmNlbF9yZXF1ZXN0cyhjdHgsDQo+
ICAJCQkJCQkJCSAgICAgY3VycmVudC0NCj4gPmlvX3VyaW5nLA0KPiAtCQkJCQkJCQkgICAgIGNh
bmNlbF9hbGwpOw0KPiArCQkJCQkJCQkgICAgIGNhbmNlbF9hbGwsDQo+ICsJCQkJCQkJCSAgICAg
dHJ1ZSk7DQo+ICAJCX0NCj4gDQo+ICAJCWlmIChsb29wKSB7DQo+IC0tDQo+IDIuNDMuMA0KPiAN
Cg0KUmV2aWV3ZWQtYnk6IExpIFpldGFvPGxpemV0YW8xQGh1YXdlaS5jb20+DQoNCi0tLQ0KTGkg
WmV0YW8NCg0K

