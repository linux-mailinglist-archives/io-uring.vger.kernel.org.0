Return-Path: <io-uring+bounces-5055-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E31B9D9A2B
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 16:08:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F099E2814C8
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 15:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47E71D54E3;
	Tue, 26 Nov 2024 15:07:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EC31D5CFE
	for <io-uring@vger.kernel.org>; Tue, 26 Nov 2024 15:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732633676; cv=none; b=OEXevWpT+Re+FHsO6a2a/SAJDekHMQfFIC7bBiNERfj9zEfabpzccB1x1ZV1YcNNLRsHaStPdnpE32scQWStimBBf5LOJtBvPKKk7DbQ8K+gqhHr+8jW/glpPzvbLOKWEGKfmyxLPK2hjNig/VDHWSmzXlce7JQ8FbFX1baP4rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732633676; c=relaxed/simple;
	bh=KJU/wn41E41PdXO0rTwEAHu2R7CWppT/fVqJT51yYiw=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Dp3YeJePvPYBLRUqmmp/rzuA5IyHIrUIrzrwkgGsz07QVdHQfHSn53bd+tdoMW/zBpHXaOgP30zJFSnkaTqHDzv784mLsxl0ZurUFxwkw8URgkh5HDFRivjJ1/bJDMlWJVBzXcWnDvS30F6XJVdNPa3DvsupQPNjrYOZrFLOUHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XyQq52qFtzPpq6;
	Tue, 26 Nov 2024 23:05:05 +0800 (CST)
Received: from kwepemd200012.china.huawei.com (unknown [7.221.188.145])
	by mail.maildlp.com (Postfix) with ESMTPS id 9F1A8140137;
	Tue, 26 Nov 2024 23:07:51 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200012.china.huawei.com (7.221.188.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 26 Nov 2024 23:07:51 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Tue, 26 Nov 2024 23:07:51 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: re: [PATCH -next] io_uring: add support for fchmod
Thread-Topic: [PATCH -next] io_uring: add support for fchmod
Thread-Index: AdtAFPBlum2L39VhQky8w4+VWsNEYw==
Date: Tue, 26 Nov 2024 15:07:51 +0000
Message-ID: <ad222c8b35e54627b0244d5ee4d54f0c@huawei.com>
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

SGksDQoNCj5PbiAxMS8yMy8yNCA1OjIzIEFNLCBsaXpldGFvIHdyb3RlOg0KPj4gSGkNCj4+IA0K
Pj4+PiBPbiAxMS8xOS8yNCAxOjEyIEFNLCBsaXpldGFvIHdyb3RlOg0KPj4+PiBBZGRzIHN1cHBv
cnQgZm9yIGRvaW5nIGNobW9kIHRocm91Z2ggaW9fdXJpbmcuIElPUklOR19PUF9GQ0hNT0QgDQo+
Pj4+IGJlaGF2ZXMgbGlrZSBmY2htb2QoMikgYW5kIHRha2VzIHRoZSBzYW1lIGFyZ3VtZW50cy4N
Cj4+IA0KPj4+IExvb2tzIHByZXR0eSBzdHJhaWdodCBmb3J3YXJkLiBUaGUgb25seSBkb3duc2lk
ZSBpcyB0aGUgZm9yY2VkIHVzZSBvZiBSRVFfRl9GT1JDRV9BU1lOQyAtIGRpZCB5b3UgbG9vayBp
bnRvIGhvdyBmZWFzaWJsZSBpdCB3b3VsZCBiZSB0byBhbGxvdyBub24tYmxvY2tpbmcgaXNzdWUg
b2YgdGhpcz8gV291bGQgaW1hZ2luZSB0aGUgbWFqb3JpdHkgb2YgZmNobW9kIGNhbGxzIGVuZCB1
cCBub3QgYmxvY2tpbmcgaW4gdGhlIGZpcnN0IHBsYWNlLg0KPj4gDQo+PiBZZXMsIEkgY29uc2lk
ZXJlZCBmY2htb2QgdG8gYWxsb3cgYXN5bmNocm9ub3VzIGV4ZWN1dGlvbiBhbmQgd3JvdGUgYSB0
ZXN0IGNhc2UgdG8gdGVzdCBpdCwgdGhlIHJlc3VsdHMgYXJlIGFzIGZvbGxvd3M6DQo+PiANCj4+
IGZjaG1vZDoNCj4+IHJlYWwJMG0xLjQxM3MNCj4+IHVzZXIJMG0wLjI1M3MNCj4+IHN5cwkwbTEu
MDc5cw0KPj4gDQo+PiBpb191cmluZyArIGZjaG1vZDoNCj4+IHJlYWwJMG0xLjI2OHMNCj4+IHVz
ZXIJMG0wLjAxNXMNCj4+IHN5cwkwbTUuNzM5cw0KPj4gDQo+PiBUaGVyZSBpcyBhYm91dCBhIDEw
JSBpbXByb3ZlbWVudC4NCg0KPiBBbmQgdGhhdCBtYWtlcyBzZW5zZSBpZiB5b3UncmUga2VlcGlu
ZyBzb21lIGZjaG1vZCBpbmZsaWdodCwgYXMgeW91J2QgZ2VuZXJhbGx5IGp1c3QgaGF2ZSBvbmUg
aW8td3EgcHJvY2Vzc2luZyB0aGVtIGFuZCBydW5uaW5nIHRoaW5ncyBpbiBwYXJhbGxlbCB3aXRo
IHN1Ym1pc3Npb24uIEJ1dCB3aGF0IHlvdSB5b3Uga2VlcCBhbiBpbmRlcHRoIGNvdW50IG9mIDEs
IGVnIGRvIHN5bmMgZmNobW9kPyBUaGVuIGl0J2QgYmUgY29uc2lkZXJhYmx5IHNsb3dlciB0aGFu
IHRoZSBzeXNjYWxsLg0KSW5kZWVkLCBXaGVuIHBlcmZvcm1pbmcgUkVRX0ZfRk9SQ0VfQVNZTkMg
b3BlcmF0aW9ucyBhdCBkZXB0aCAxLCBwZXJmb3JtYW5jZSBpcyBkZWdyYWRlZC4gVGhlIHJlc3Vs
dHMgYXJlIGFzIGZvbGxvd3M6DQoNCmZjaG1vZDoNCnJlYWwJMG0yLjI4NXMNCnVzZXIJMG0wLjA1
MHMNCnN5cwkwbTEuOTk2cw0KDQppb191cmluZyArIGZjaG1vZDoNCnJlYWwJMG0yLjU0MXMNCnVz
ZXIJMG0wLjAxM3MNCnN5cwkwbTIuMzc5cw0KDQo+VGhpcyBpc24ndCBuZWNlc3NhcmlseSBzb21l
dGhpbmcgdG8gd29ycnkgYWJvdXQsIGJ1dCBmYWN0IGlzIHRoYXQgaWYgeW91IGNhbiBkbyBhIG5v
bmJsb2NrIGlzc3VlIGFuZCBoYXZlIGl0IHN1Y2NlZWQgbW9zdCBvZiB0aGUgdGltZSwgdGhhdCds
bCBiZSBtb3JlIGVmZmljaWVudCAoYW5kIGZhc3RlciBmb3IgbG93L3N5bmMgZmNobW9kKSB0aGFu
IHNvbWV0aGluZyB0aGF0IGp1c3Qgb2ZmbG9hZHMgdG8gaW8td3EuIFlvdSBjYW4gc2VlIHRoYXQg
ZnJvbSB5b3VyIHJlc3VsdHMgdG9vLCBjb21wYXJpbmcgdGhlIHN5cyBudW1iZXIgbmV0d2VlbiB0
aGUgdHdvLg0KSG93ZXZlciwgd2hlbiBJIHJlbW92ZSBSRVFfRl9GT1JDRV9BU1lOQyBhbmQgdXNl
IElPX1VSSU5HX0ZfTk9OQkxPQ0ssIHRoZSBwZXJmb3JtYW5jZSBpcyBub3QgaW1wcm92ZWQuIFRo
ZSBtZWFzdXJlZCByZXN1bHRzIGFyZSBhcyBmb2xsb3dzOg0KZmNobW9kOg0KcmVhbAkwbTIuMTMy
cw0KdXNlcgkwbTAuMDQ4cw0Kc3lzCTBtMS44NDVzDQoNCmlvX3VyaW5nICsgZmNobW9kOg0KcmVh
bAkwbTIuMTk2cw0KdXNlcgkwbTAuMDA1cw0Kc3lzCTBtMi4wOTdzDQoNCj5IZW5jZSB3aHkgSSdt
IGFza2luZyBpZiB5b3UgbG9va2VkIGludG8gZG9pbmcgYSBub25ibG9ja2luZyBpc3N1ZSBhdCBh
bGwuIFRoaXMgd29uJ3QgbmVjZXNzYXJpbHkgZ2F0ZSB0aGUgaW5jbHVzaW9uIG9mIHRoZSBwYXRj
aCwgYW5kIGl0IGlzIHNvbWV0aGluZyB0aGF0IGNhbiBiZSBjaGFuZ2VkIGRvd24gdGhlIGxpbmUs
IEknbSBtb3N0bHkganVzdCBjdXJpb3VzLg0KRG9lcyB0aGlzIHJlc3VsdCBtZWV0IGV4cGVjdGF0
aW9ucz8gT3IgbWF5YmUgSSBtaXNzZWQgc29tZXRoaW5nLCBwbGVhc2UgbGV0IG1lIGtub3cNCg0K
Pi0tDQo+SmVucyBBeGJvZQ0KDQotLS0NCkxpIFpldGFvDQo=

