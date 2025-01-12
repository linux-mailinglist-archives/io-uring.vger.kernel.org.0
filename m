Return-Path: <io-uring+bounces-5834-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E06A0AA96
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 16:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D9B31658FC
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 15:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ECF61B4243;
	Sun, 12 Jan 2025 15:45:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7701714B7;
	Sun, 12 Jan 2025 15:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736696750; cv=none; b=uoIFIWvYBVAujnwxn+3G7qfXb1oB1sxhcoqqJqtvEfsIqyvTlsGTwCqZRlSY9j0Dl0FcnhuyH48SW8w9q8a5Z84S0w/1VxAX63vsTzIMh0OI5KiydckqypRzWEW7qkj1LLZbfWjWOHJTgJjtf3A/nbEt6XAEr06hL/p2VMWV24E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736696750; c=relaxed/simple;
	bh=eEtUu/2GFyytOZ5xOVrjIqozcfXkl7MvonTjzREctv0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rZ6ktUayFGk+4a7kju7rA+IJMef9mWvKGdRo/ZYtYB6prY1xxjs948ocsuh9p3k7Nst8T+4yXrOqPzkHRNJTn0ebg+jh7KWV/ruKO1q/FPxOaF+ZxFD6B07b/6SYu6XkYnTjUcmBbUXh4cZ1IzlRMApTJyn5AyGnNgmbUeV7ma8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YWKTC5Vd6z1JHVr;
	Sun, 12 Jan 2025 23:44:47 +0800 (CST)
Received: from kwepemd100010.china.huawei.com (unknown [7.221.188.107])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E66118001B;
	Sun, 12 Jan 2025 23:45:37 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100010.china.huawei.com (7.221.188.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sun, 12 Jan 2025 23:45:37 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Sun, 12 Jan 2025 23:45:37 +0800
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
Thread-Index: AQHbZQBAfPWaG4hxx06y9utYvVroALMTRYCQ
Date: Sun, 12 Jan 2025 15:45:37 +0000
Message-ID: <aff011219272498a900f052d0142978c@huawei.com>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQnVpIFF1YW5nIE1p
bmggPG1pbmhxdWFuZ2J1aTk5QGdtYWlsLmNvbT4NCj4gU2VudDogU3VuZGF5LCBKYW51YXJ5IDEy
LCAyMDI1IDEwOjM0IFBNDQo+IFRvOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IENj
OiBCdWkgUXVhbmcgTWluaCA8bWluaHF1YW5nYnVpOTlAZ21haWwuY29tPjsgSmVucyBBeGJvZQ0K
PiA8YXhib2VAa2VybmVsLmRrPjsgUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5j
b20+OyBpby0NCj4gdXJpbmdAdmdlci5rZXJuZWwub3JnOw0KPiBzeXpib3QrM2M3NTBiZTAxZGFi
NjcyYzUxM2RAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbTsgbGl6ZXRhbw0KPiA8bGl6ZXRhbzFA
aHVhd2VpLmNvbT4NCj4gU3ViamVjdDogW1BBVENIXSBpb191cmluZzogc2ltcGxpZnkgdGhlIFNR
UE9MTCB0aHJlYWQgY2hlY2sgd2hlbiBjYW5jZWxsaW5nDQo+IHJlcXVlc3RzDQo+IA0KPiBJbiBp
b191cmluZ190cnlfY2FuY2VsX3JlcXVlc3RzLCB3ZSBjaGVjayB3aGV0aGVyIHNxX2RhdGEtPnRo
cmVhZCA9PQ0KPiBjdXJyZW50IHRvIGRldGVybWluZSBpZiB0aGUgZnVuY3Rpb24gaXMgY2FsbGVk
IGJ5IHRoZSBTUVBPTEwgdGhyZWFkIHRvIGRvIGlvcG9sbA0KPiB3aGVuIElPUklOR19TRVRVUF9T
UVBPTEwgaXMgc2V0LiBUaGlzIGNoZWNrIGNhbiByYWNlIHdpdGggdGhlIFNRUE9MTA0KPiB0aHJl
YWQgdGVybWluYXRpb24uDQo+IA0KPiBpb191cmluZ19jYW5jZWxfZ2VuZXJpYyBpcyB1c2VkIGlu
IDIgcGxhY2VzOiBpb191cmluZ19jYW5jZWxfZ2VuZXJpYyBhbmQNCj4gaW9fcmluZ19leGl0X3dv
cmsuIEluIGlvX3VyaW5nX2NhbmNlbF9nZW5lcmljLCB3ZSBoYXZlIHRoZSBpbmZvcm1hdGlvbg0K
PiB3aGV0aGVyIHRoZSBjdXJyZW50IGlzIFNRUE9MTCB0aHJlYWQgYWxyZWFkeS4gSW4gaW9fcmlu
Z19leGl0X3dvcmssIGluIGNhc2UNCj4gdGhlIFNRUE9MTCB0aHJlYWQgcmVhY2hlcyB0aGlzIHBh
dGgsIHdlIGRvbid0IG5lZWQgdG8gaW9wb2xsIGFuZCBsZWF2ZSB0aGF0IGZvcg0KPiBpb191cmlu
Z19jYW5jZWxfZ2VuZXJpYyB0byBoYW5kbGUuDQo+IA0KPiBTbyB0byBhdm9pZCB0aGUgcmFjeSBj
aGVjaywgdGhpcyBjb21taXQgYWRkcyBhIGJvb2xlYW4gZmxhZyB0bw0KPiBpb191cmluZ190cnlf
Y2FuY2VsX3JlcXVlc3RzIHRvIGRldGVybWluZSBpZiB3ZSBuZWVkIHRvIGRvIGlvcG9sbCBpbnNp
ZGUgdGhlDQo+IGZ1bmN0aW9uIGFuZCBvbmx5IHNldHMgdGhpcyBmbGFnIGluIGlvX3VyaW5nX2Nh
bmNlbF9nZW5lcmljIHdoZW4gdGhlIGN1cnJlbnQgaXMNCj4gU1FQT0xMIHRocmVhZC4NCj4gDQo+
IFJlcG9ydGVkLWJ5OiBzeXpib3QrM2M3NTBiZTAxZGFiNjcyYzUxM2RAc3l6a2FsbGVyLmFwcHNw
b3RtYWlsLmNvbQ0KPiBSZXBvcnRlZC1ieTogTGkgWmV0YW8gPGxpemV0YW8xQGh1YXdlaS5jb20+
DQo+IFNpZ25lZC1vZmYtYnk6IEJ1aSBRdWFuZyBNaW5oIDxtaW5ocXVhbmdidWk5OUBnbWFpbC5j
b20+DQo+IC0tLQ0KPiAgaW9fdXJpbmcvaW9fdXJpbmcuYyB8IDIxICsrKysrKysrKysrKysrKy0t
LS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvaW9fdXJpbmcuYyBiL2lvX3VyaW5nL2lvX3Vy
aW5nLmMgaW5kZXgNCj4gZmY2OTFmMzc0NjJjLi5mMjhlYTEyNTQxNDMgMTAwNjQ0DQo+IC0tLSBh
L2lvX3VyaW5nL2lvX3VyaW5nLmMNCj4gKysrIGIvaW9fdXJpbmcvaW9fdXJpbmcuYw0KPiBAQCAt
MTQzLDcgKzE0Myw4IEBAIHN0cnVjdCBpb19kZWZlcl9lbnRyeSB7DQo+IA0KPiAgc3RhdGljIGJv
b2wgaW9fdXJpbmdfdHJ5X2NhbmNlbF9yZXF1ZXN0cyhzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwN
Cj4gIAkJCQkJIHN0cnVjdCBpb191cmluZ190YXNrICp0Y3R4LA0KPiAtCQkJCQkgYm9vbCBjYW5j
ZWxfYWxsKTsNCj4gKwkJCQkJIGJvb2wgY2FuY2VsX2FsbCwNCj4gKwkJCQkJIGJvb2wgZm9yY2Vf
aW9wb2xsKTsNCj4gDQo+ICBzdGF0aWMgdm9pZCBpb19xdWV1ZV9zcWUoc3RydWN0IGlvX2tpb2Ni
ICpyZXEpOw0KPiANCj4gQEAgLTI4OTgsNyArMjg5OSwxMiBAQCBzdGF0aWMgX19jb2xkIHZvaWQg
aW9fcmluZ19leGl0X3dvcmsoc3RydWN0DQo+IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiAgCQlpZiAo
Y3R4LT5mbGFncyAmIElPUklOR19TRVRVUF9ERUZFUl9UQVNLUlVOKQ0KPiAgCQkJaW9fbW92ZV90
YXNrX3dvcmtfZnJvbV9sb2NhbChjdHgpOw0KPiANCj4gLQkJd2hpbGUgKGlvX3VyaW5nX3RyeV9j
YW5jZWxfcmVxdWVzdHMoY3R4LCBOVUxMLCB0cnVlKSkNCj4gKwkJLyoNCj4gKwkJICogRXZlbiBp
ZiBTUVBPTEwgdGhyZWFkIHJlYWNoZXMgdGhpcyBwYXRoLCBkb24ndCBmb3JjZQ0KPiArCQkgKiBp
b3BvbGwgaGVyZSwgbGV0IHRoZSBpb191cmluZ19jYW5jZWxfZ2VuZXJpYyBoYW5kbGUNCj4gKwkJ
ICogaXQuDQoNCkp1c3QgY3VyaW91cywgd2lsbCBzcV90aHJlYWQgZW50ZXIgdGhpcyBpb19yaW5n
X2V4aXRfd29yayBwYXRoPw0KDQo+ICsJCSAqLw0KPiArCQl3aGlsZSAoaW9fdXJpbmdfdHJ5X2Nh
bmNlbF9yZXF1ZXN0cyhjdHgsIE5VTEwsIHRydWUsIGZhbHNlKSkNCj4gIAkJCWNvbmRfcmVzY2hl
ZCgpOw0KPiANCj4gIAkJaWYgKGN0eC0+c3FfZGF0YSkgew0KPiBAQCAtMzA2Niw3ICszMDcyLDgg
QEAgc3RhdGljIF9fY29sZCBib29sIGlvX3VyaW5nX3RyeV9jYW5jZWxfaW93cShzdHJ1Y3QNCj4g
aW9fcmluZ19jdHggKmN0eCkNCj4gDQo+ICBzdGF0aWMgX19jb2xkIGJvb2wgaW9fdXJpbmdfdHJ5
X2NhbmNlbF9yZXF1ZXN0cyhzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwNCj4gIAkJCQkJCXN0cnVj
dCBpb191cmluZ190YXNrICp0Y3R4LA0KPiAtCQkJCQkJYm9vbCBjYW5jZWxfYWxsKQ0KPiArCQkJ
CQkJYm9vbCBjYW5jZWxfYWxsLA0KPiArCQkJCQkJYm9vbCBmb3JjZV9pb3BvbGwpDQo+ICB7DQo+
ICAJc3RydWN0IGlvX3Rhc2tfY2FuY2VsIGNhbmNlbCA9IHsgLnRjdHggPSB0Y3R4LCAuYWxsID0g
Y2FuY2VsX2FsbCwgfTsNCj4gIAllbnVtIGlvX3dxX2NhbmNlbCBjcmV0Ow0KPiBAQCAtMzA5Niw3
ICszMTAzLDcgQEAgc3RhdGljIF9fY29sZCBib29sDQo+IGlvX3VyaW5nX3RyeV9jYW5jZWxfcmVx
dWVzdHMoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsDQo+IA0KPiAgCS8qIFNRUE9MTCB0aHJlYWQg
ZG9lcyBpdHMgb3duIHBvbGxpbmcgKi8NCj4gIAlpZiAoKCEoY3R4LT5mbGFncyAmIElPUklOR19T
RVRVUF9TUVBPTEwpICYmIGNhbmNlbF9hbGwpIHx8DQo+IC0JICAgIChjdHgtPnNxX2RhdGEgJiYg
Y3R4LT5zcV9kYXRhLT50aHJlYWQgPT0gY3VycmVudCkpIHsNCj4gKwkgICAgZm9yY2VfaW9wb2xs
KSB7DQo+ICAJCXdoaWxlICghd3FfbGlzdF9lbXB0eSgmY3R4LT5pb3BvbGxfbGlzdCkpIHsNCj4g
IAkJCWlvX2lvcG9sbF90cnlfcmVhcF9ldmVudHMoY3R4KTsNCj4gIAkJCXJldCA9IHRydWU7DQo+
IEBAIC0zMTY5LDEzICszMTc2LDE1IEBAIF9fY29sZCB2b2lkIGlvX3VyaW5nX2NhbmNlbF9nZW5l
cmljKGJvb2wNCj4gY2FuY2VsX2FsbCwgc3RydWN0IGlvX3NxX2RhdGEgKnNxZCkNCj4gIAkJCQkJ
Y29udGludWU7DQo+ICAJCQkJbG9vcCB8PSBpb191cmluZ190cnlfY2FuY2VsX3JlcXVlc3RzKG5v
ZGUtDQo+ID5jdHgsDQo+ICAJCQkJCQkJY3VycmVudC0+aW9fdXJpbmcsDQo+IC0JCQkJCQkJY2Fu
Y2VsX2FsbCk7DQo+ICsJCQkJCQkJY2FuY2VsX2FsbCwNCj4gKwkJCQkJCQlmYWxzZSk7DQo+ICAJ
CQl9DQo+ICAJCX0gZWxzZSB7DQo+ICAJCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGN0eCwgJnNxZC0+
Y3R4X2xpc3QsIHNxZF9saXN0KQ0KPiAgCQkJCWxvb3AgfD0gaW9fdXJpbmdfdHJ5X2NhbmNlbF9y
ZXF1ZXN0cyhjdHgsDQo+ICAJCQkJCQkJCSAgICAgY3VycmVudC0NCj4gPmlvX3VyaW5nLA0KPiAt
CQkJCQkJCQkgICAgIGNhbmNlbF9hbGwpOw0KPiArCQkJCQkJCQkgICAgIGNhbmNlbF9hbGwsDQo+
ICsJCQkJCQkJCSAgICAgdHJ1ZSk7DQo+ICAJCX0NCj4gDQo+ICAJCWlmIChsb29wKSB7DQo+IC0t
DQo+IDIuNDMuMA0KPiANCg0KTWF5YmUgeW91IG1pc3Mgc29tZXRoaW5nLCBqdXN0IGxpa2UgQmVn
dW5rb3YgbWVudGlvbmVkIGluIHlvdXIgbGFzdCB2ZXJzaW9uIHBhdGNoOg0KDQogIGlvX3VyaW5n
X2NhbmNlbF9nZW5lcmljDQogICAgV0FSTl9PTl9PTkNFKHNxZCAmJiBzcWQtPnRocmVhZCAhPSBj
dXJyZW50KTsNCg0KVGhpcyBXQVJOX09OX09OQ0Ugd2lsbCBuZXZlciBiZSB0cmlnZ2VyZWQsIHNv
IHlvdSBjb3VsZCByZW1vdmUgaXQuDQoNCi0tLQ0KTGkgWmV0YW8NCg0K

