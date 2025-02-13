Return-Path: <io-uring+bounces-6417-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A0BFA34B0F
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 17:59:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62F91177C2B
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 16:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B9D16BE17;
	Thu, 13 Feb 2025 16:52:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7A71C863C
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739465550; cv=none; b=YFKKYeHtRdihUSxiqzIIYjt5ygxJ54rErtQ40iM08Y3/dAePW9dpRndh112aErHMLFz/4cgGEZXHxlea4xwqcNl2EeNI/+6wcVh19Hz0VhTFjWW6qhy7RfLqSDuq3hQ3IRotMCw8EX3VTObxqDBW36PAYyys9wlNQDjE7lCnbIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739465550; c=relaxed/simple;
	bh=Xg77T5eII7VGBmgxETejCbTBjpE1JF6/Z192WdQwsSo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hOvsGMdtRnMTvbEzxxm5ScXdIJkFoqL/mW1+Qbrp7bcXjo5o4MuQ9o4kcKl9bOJXLXpl7aHZF0L8BAYSn56etpUuslcO44UcCVVPSqqdDxMw5QtThKxyqYsc/ijFFdJc5qcFRkSkRNIBVt/xs9A68Fcrzd+LFusJaU5cpRGfJfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Yv1P10FrmzRmch;
	Fri, 14 Feb 2025 00:49:25 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id 6A80A1402C3;
	Fri, 14 Feb 2025 00:52:19 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 14 Feb 2025 00:52:19 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Fri, 14 Feb 2025 00:52:19 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>
CC: io-uring <io-uring@vger.kernel.org>
Subject: RE: [PATCH v2] io_uring/uring_cmd: unconditionally copy SQEs at prep
 time
Thread-Topic: [PATCH v2] io_uring/uring_cmd: unconditionally copy SQEs at prep
 time
Thread-Index: AQHbfjbGlkcKuz3bC0OG8BvUFEbQLrNFcsSw
Date: Thu, 13 Feb 2025 16:52:18 +0000
Message-ID: <5fe5789d746e4a1bb6cb351db3130bab@huawei.com>
References: <4e4dcdf3-f060-4118-911d-5b492cef8f8f@kernel.dk>
In-Reply-To: <4e4dcdf3-f060-4118-911d-5b492cef8f8f@kernel.dk>
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
YXhib2VAa2VybmVsLmRrPg0KPiBTZW50OiBGcmlkYXksIEZlYnJ1YXJ5IDE0LCAyMDI1IDEyOjMx
IEFNDQo+IFRvOiBpby11cmluZyA8aW8tdXJpbmdAdmdlci5rZXJuZWwub3JnPg0KPiBDYzogQ2Fs
ZWIgU2FuZGVyIE1hdGVvcyA8Y3NhbmRlckBwdXJlc3RvcmFnZS5jb20+DQo+IFN1YmplY3Q6IFtQ
QVRDSCB2Ml0gaW9fdXJpbmcvdXJpbmdfY21kOiB1bmNvbmRpdGlvbmFsbHkgY29weSBTUUVzIGF0
IHByZXANCj4gdGltZQ0KPiANCj4gVGhpcyBpc24ndCBnZW5lcmFsbHkgbmVjZXNzYXJ5LCBidXQg
Y29uZGl0aW9ucyBoYXZlIGJlZW4gb2JzZXJ2ZWQgd2hlcmUgU1FFDQo+IGRhdGEgaXMgYWNjZXNz
ZWQgZnJvbSB0aGUgb3JpZ2luYWwgU1FFIGFmdGVyIHByZXAgaGFzIGJlZW4gZG9uZSBhbmQgb3V0
c2lkZSBvZg0KPiB0aGUgaW5pdGlhbCBpc3N1ZS4gT3Bjb2RlIHByZXAgaGFuZGxlcnMgbXVzdCBl
bnN1cmUgdGhhdCBhbnkgU1FFIHJlbGF0ZWQgZGF0YSBpcw0KPiBzdGFibGUgYmV5b25kIHRoZSBw
cmVwIHBoYXNlLCBidXQgdXJpbmdfY21kIGlzIGEgYml0IHNwZWNpYWwgaW4gaG93IGl0IGhhbmRs
ZXMNCj4gdGhlIFNRRSB3aGljaCBtYWtlcyBpdCBzdXNjZXB0aWJsZSB0byByZWFkaW5nIHN0YWxl
IGRhdGEuIElmIHRoZSBhcHBsaWNhdGlvbiBoYXMNCj4gcmV1c2VkIHRoZSBTUUUgYmVmb3JlIHRo
ZSBvcmlnaW5hbCBjb21wbGV0ZXMsIHRoZW4gdGhhdCBjYW4gbGVhZCB0byBkYXRhDQo+IGNvcnJ1
cHRpb24uDQo+IA0KPiBEb3duIHRoZSBsaW5lIHdlIGNhbiByZWxheCB0aGlzIGFnYWluIG9uY2Ug
dXJpbmdfY21kIGhhcyBiZWVuIHNhbml0aXplZCBhIGJpdCwNCj4gYW5kIGF2b2lkIHVubmVjZXNz
YXJpbHkgY29weWluZyB0aGUgU1FFLg0KPiANCj4gUmVwb3J0ZWQtYnk6IENhbGViIFNhbmRlciBN
YXRlb3MgPGNzYW5kZXJAcHVyZXN0b3JhZ2UuY29tPg0KPiBSZXZpZXdlZC1ieTogQ2FsZWIgU2Fu
ZGVyIE1hdGVvcyA8Y3NhbmRlckBwdXJlc3RvcmFnZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEpl
bnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4NCj4gDQo+IC0tLQ0KPiANCj4gVjI6DQo+IC0gUGFz
cyBpbiBTUUUgZm9yIGNvcHksIGFuZCBkcm9wIGhlbHBlciBmb3IgY29weQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2lvX3VyaW5nL3VyaW5nX2NtZC5jIGIvaW9fdXJpbmcvdXJpbmdfY21kLmMgaW5kZXgN
Cj4gOGFmNzc4MDQwN2I3Li5lNjcwMWI3YWExNDcgMTAwNjQ0DQo+IC0tLSBhL2lvX3VyaW5nL3Vy
aW5nX2NtZC5jDQo+ICsrKyBiL2lvX3VyaW5nL3VyaW5nX2NtZC5jDQo+IEBAIC0xNjUsMTUgKzE2
NSw2IEBAIHZvaWQgaW9fdXJpbmdfY21kX2RvbmUoc3RydWN0IGlvX3VyaW5nX2NtZA0KPiAqaW91
Y21kLCBzc2l6ZV90IHJldCwgdTY0IHJlczIsICB9ICBFWFBPUlRfU1lNQk9MX0dQTChpb191cmlu
Z19jbWRfZG9uZSk7DQo+IA0KPiAtc3RhdGljIHZvaWQgaW9fdXJpbmdfY21kX2NhY2hlX3NxZXMo
c3RydWN0IGlvX2tpb2NiICpyZXEpIC17DQo+IC0Jc3RydWN0IGlvX3VyaW5nX2NtZCAqaW91Y21k
ID0gaW9fa2lvY2JfdG9fY21kKHJlcSwgc3RydWN0DQo+IGlvX3VyaW5nX2NtZCk7DQo+IC0Jc3Ry
dWN0IGlvX3VyaW5nX2NtZF9kYXRhICpjYWNoZSA9IHJlcS0+YXN5bmNfZGF0YTsNCj4gLQ0KPiAt
CW1lbWNweShjYWNoZS0+c3FlcywgaW91Y21kLT5zcWUsIHVyaW5nX3NxZV9zaXplKHJlcS0+Y3R4
KSk7DQo+IC0JaW91Y21kLT5zcWUgPSBjYWNoZS0+c3FlczsNCj4gLX0NCj4gLQ0KPiAgc3RhdGlj
IGludCBpb191cmluZ19jbWRfcHJlcF9zZXR1cChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwNCj4gIAkJ
CQkgICBjb25zdCBzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUpDQo+ICB7DQo+IEBAIC0xODUsMTAg
KzE3NiwxNSBAQCBzdGF0aWMgaW50IGlvX3VyaW5nX2NtZF9wcmVwX3NldHVwKHN0cnVjdCBpb19r
aW9jYg0KPiAqcmVxLA0KPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gIAljYWNoZS0+b3BfZGF0YSA9
IE5VTEw7DQo+IA0KPiAtCWlvdWNtZC0+c3FlID0gc3FlOw0KPiAtCS8qIGRlZmVyIG1lbWNweSB1
bnRpbCB3ZSBuZWVkIGl0ICovDQo+IC0JaWYgKHVubGlrZWx5KHJlcS0+ZmxhZ3MgJiBSRVFfRl9G
T1JDRV9BU1lOQykpDQo+IC0JCWlvX3VyaW5nX2NtZF9jYWNoZV9zcWVzKHJlcSk7DQo+ICsJLyoN
Cj4gKwkgKiBVbmNvbmRpdGlvbmFsbHkgY2FjaGUgdGhlIFNRRSBmb3Igbm93IC0gdGhpcyBpcyBv
bmx5IG5lZWRlZCBmb3INCj4gKwkgKiByZXF1ZXN0cyB0aGF0IGdvIGFzeW5jLCBidXQgcHJlcCBo
YW5kbGVycyBtdXN0IGVuc3VyZSB0aGF0IGFueQ0KPiArCSAqIHNxZSBkYXRhIGlzIHN0YWJsZSBi
ZXlvbmQgcHJlcC4gU2luY2UgdXJpbmdfY21kIGlzIHNwZWNpYWwgaW4NCj4gKwkgKiB0aGF0IGl0
IGRvZXNuJ3QgcmVhZCBpbiBwZXItb3AgZGF0YSwgcGxheSBpdCBzYWZlIGFuZCBlbnN1cmUgdGhh
dA0KPiArCSAqIGFueSBTUUUgZGF0YSBpcyBzdGFibGUgYmV5b25kIHByZXAuIFRoaXMgY2FuIGxh
dGVyIGdldCByZWxheGVkLg0KPiArCSAqLw0KPiArCW1lbWNweShjYWNoZS0+c3Flcywgc3FlLCB1
cmluZ19zcWVfc2l6ZShyZXEtPmN0eCkpOw0KPiArCWlvdWNtZC0+c3FlID0gY2FjaGUtPnNxZXM7
DQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+IA0KPiBAQCAtMjUxLDE2ICsyNDcsOCBAQCBpbnQgaW9f
dXJpbmdfY21kKHN0cnVjdCBpb19raW9jYiAqcmVxLCB1bnNpZ25lZCBpbnQNCj4gaXNzdWVfZmxh
Z3MpDQo+ICAJfQ0KPiANCj4gIAlyZXQgPSBmaWxlLT5mX29wLT51cmluZ19jbWQoaW91Y21kLCBp
c3N1ZV9mbGFncyk7DQo+IC0JaWYgKHJldCA9PSAtRUFHQUlOKSB7DQo+IC0JCXN0cnVjdCBpb191
cmluZ19jbWRfZGF0YSAqY2FjaGUgPSByZXEtPmFzeW5jX2RhdGE7DQo+IC0NCj4gLQkJaWYgKGlv
dWNtZC0+c3FlICE9IGNhY2hlLT5zcWVzKQ0KPiAtCQkJaW9fdXJpbmdfY21kX2NhY2hlX3NxZXMo
cmVxKTsNCj4gLQkJcmV0dXJuIC1FQUdBSU47DQo+IC0JfSBlbHNlIGlmIChyZXQgPT0gLUVJT0NC
UVVFVUVEKSB7DQo+IC0JCXJldHVybiAtRUlPQ0JRVUVVRUQ7DQo+IC0JfQ0KPiAtDQo+ICsJaWYg
KHJldCA9PSAtRUFHQUlOIHx8IHJldCA9PSAtRUlPQ0JRVUVVRUQpDQo+ICsJCXJldHVybiByZXQ7
DQo+ICAJaWYgKHJldCA8IDApDQo+ICAJCXJlcV9zZXRfZmFpbChyZXEpOw0KPiAgCWlvX3JlcV91
cmluZ19jbGVhbnVwKHJlcSwgaXNzdWVfZmxhZ3MpOw0KPiANCj4gLS0NCj4gSmVucyBBeGJvZQ0K
PiANCj4gDQoNClJldmlld2VkLWJ5OiBMaSBaZXRhbyA8bGl6ZXRhbzFAaHVhd2VpLmNvbT4NCg0K
LS0tDQpMaSBaZXRhbw0KDQo=

