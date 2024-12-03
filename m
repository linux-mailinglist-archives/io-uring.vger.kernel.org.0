Return-Path: <io-uring+bounces-5171-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F90B9E1768
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 10:27:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E92E8285921
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 09:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837A61DF26C;
	Tue,  3 Dec 2024 09:27:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE0B1DF25E;
	Tue,  3 Dec 2024 09:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733218030; cv=none; b=uxG4EhLEGKFdK1qdAjyx3PYl45nkMNKkK89Qr9fNstsEAkdu5rmfmCa50865hsteo0Apyy940VlL6O58KLuKyrsPfCJDgMqXjdm47U0A3WWsd0jIZEy86JKpANJEcyXdE6tbCgp8dkvbzWbSB5QajNveeM4XVNUa3fMDGd7yF6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733218030; c=relaxed/simple;
	bh=KTvn/Gjc1QNifOEf2fzkR5J6AXF3ghX35zNWUoTlCOY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E6Sgz9qTa/SPpqHA1UFC5mAkTylKMRFt8JQ/dlfy3pTfQhTHvH9UaRvQoNRkigxZNvHBd7iclcznk5kNoHXCl4RFmWywhxh/rwnDD2TvUlqy1UqUFx3QoSynzv1ic76aPIp1hp0UAqHDEbzxnomO8rngw3/XNe7uRVjFnNBwoiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y2Zzh51CKz1JDTX;
	Tue,  3 Dec 2024 17:26:56 +0800 (CST)
Received: from kwepemd500011.china.huawei.com (unknown [7.221.188.45])
	by mail.maildlp.com (Postfix) with ESMTPS id 208D01A0188;
	Tue,  3 Dec 2024 17:27:03 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd500011.china.huawei.com (7.221.188.45) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 3 Dec 2024 17:27:02 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Tue, 3 Dec 2024 17:27:02 +0800
From: lizetao <lizetao1@huawei.com>
To: Bernd Schubert <bschubert@ddn.com>
CC: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	Kanchan Joshi <joshi.k@samsung.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] io_uring: Change res2 parameter type in io_uring_cmd_done
Thread-Topic: [PATCH] io_uring: Change res2 parameter type in
 io_uring_cmd_done
Thread-Index: AQHbRMWpVSKVZoFu80ypzjGJCjeqXLLUPplg
Date: Tue, 3 Dec 2024 09:27:02 +0000
Message-ID: <ddf57e59ff2046e497125242f86aa9d7@huawei.com>
References: <20241202-io_uring_cmd_done-res2-as-u64-v1-1-74f33388c3d8@ddn.com>
In-Reply-To: <20241202-io_uring_cmd_done-res2-as-u64-v1-1-74f33388c3d8@ddn.com>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmVybmQgU2NodWJl
cnQgPGJzY2h1YmVydEBkZG4uY29tPg0KPiBTZW50OiBNb25kYXksIERlY2VtYmVyIDIsIDIwMjQg
MTA6MjIgUE0NCj4gVG86IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz47IFBhdmVsIEJlZ3Vu
a292DQo+IDxhc21sLnNpbGVuY2VAZ21haWwuY29tPjsgS2FuY2hhbiBKb3NoaSA8am9zaGkua0Bz
YW1zdW5nLmNvbT4NCj4gQ2M6IGlvLXVyaW5nQHZnZXIua2VybmVsLm9yZzsgQmVybmQgU2NodWJl
cnQgPGJzY2h1YmVydEBkZG4uY29tPjsNCj4gc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJq
ZWN0OiBbUEFUQ0hdIGlvX3VyaW5nOiBDaGFuZ2UgcmVzMiBwYXJhbWV0ZXIgdHlwZSBpbg0KPiBp
b191cmluZ19jbWRfZG9uZQ0KPiANCj4gQ2hhbmdlIHRoZSB0eXBlIG9mIHRoZSByZXMyIHBhcmFt
ZXRlciBpbiBpb191cmluZ19jbWRfZG9uZSBmcm9tIHNzaXplX3QgdG8NCj4gdTY0LiBUaGlzIGFs
aWducyB0aGUgcGFyYW1ldGVyIHR5cGUgd2l0aCBpb19yZXFfc2V0X2NxZTMyX2V4dHJhLCB3aGlj
aA0KPiBleHBlY3RzIHU2NCBhcmd1bWVudHMuDQo+IFRoZSBjaGFuZ2UgZWxpbWluYXRlcyBwb3Rl
bnRpYWwgaXNzdWVzIG9uIDMyLWJpdCBhcmNoaXRlY3R1cmVzIHdoZXJlIHNzaXplX3QNCj4gbWln
aHQgYmUgMzItYml0Lg0KPiANCj4gT25seSB1c2VyIG9mIHBhc3NpbmcgcmVzMiBpcyBkcml2ZXJz
L252bWUvaG9zdC9pb2N0bC5jIGFuZCBpdCBhY3R1YWxseSBwYXNzZXMNCj4gdTY0Lg0KPiANCj4g
Rml4ZXM6IGVlNjkyYTIxZTliZiAoImZzLGlvX3VyaW5nOiBhZGQgaW5mcmFzdHJ1Y3R1cmUgZm9y
IHVyaW5nLWNtZCIpDQo+IFNpZ25lZC1vZmYtYnk6IEJlcm5kIFNjaHViZXJ0IDxic2NodWJlcnRA
ZGRuLmNvbT4NCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gLS0tDQo+ICBpbmNsdWRl
L2xpbnV4L2lvX3VyaW5nL2NtZC5oIHwgMiArLQ0KPiAgaW9fdXJpbmcvdXJpbmdfY21kLmMgICAg
ICAgICB8IDIgKy0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvaW9fdXJpbmcvY21kLmgg
Yi9pbmNsdWRlL2xpbnV4L2lvX3VyaW5nL2NtZC5oDQo+IGluZGV4DQo+IDU3OGEzZmRmNWM3MTlj
ZjQ1ZmQ0YjZmOWM4OTQyMDRkNmI0Zjk0NmMuLjc1NjkxY2EyMDQzYWNkZjY4NzcwOWJiMmYyDQo+
IDc4MjlhMWJjN2ExMTAzIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2lvX3VyaW5nL2Nt
ZC5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvaW9fdXJpbmcvY21kLmgNCj4gQEAgLTQzLDcgKzQz
LDcgQEAgaW50IGlvX3VyaW5nX2NtZF9pbXBvcnRfZml4ZWQodTY0IHVidWYsIHVuc2lnbmVkDQo+
IGxvbmcgbGVuLCBpbnQgcncsDQo+ICAgKiBOb3RlOiB0aGUgY2FsbGVyIHNob3VsZCBuZXZlciBo
YXJkIGNvZGUgQGlzc3VlX2ZsYWdzIGFuZCBpcyBvbmx5IGFsbG93ZWQNCj4gICAqIHRvIHBhc3Mg
dGhlIG1hc2sgcHJvdmlkZWQgYnkgdGhlIGNvcmUgaW9fdXJpbmcgY29kZS4NCj4gICAqLw0KPiAt
dm9pZCBpb191cmluZ19jbWRfZG9uZShzdHJ1Y3QgaW9fdXJpbmdfY21kICpjbWQsIHNzaXplX3Qg
cmV0LCBzc2l6ZV90IHJlczIsDQo+ICt2b2lkIGlvX3VyaW5nX2NtZF9kb25lKHN0cnVjdCBpb191
cmluZ19jbWQgKmNtZCwgc3NpemVfdCByZXQsIHU2NCByZXMyLA0KPiAgCQkJdW5zaWduZWQgaXNz
dWVfZmxhZ3MpOw0KPiANCj4gIHZvaWQgX19pb191cmluZ19jbWRfZG9faW5fdGFzayhzdHJ1Y3Qg
aW9fdXJpbmdfY21kICppb3VjbWQsIGRpZmYgLS1naXQNCj4gYS9pb191cmluZy91cmluZ19jbWQu
YyBiL2lvX3VyaW5nL3VyaW5nX2NtZC5jIGluZGV4DQo+IGQ5ZmIyMTQzZjU2ZmY1ZDEzNDgzNjg3
ZmE5NDljMjkzZjliOGRiZWYuLmFmODQyZTliNGViOTc1YmE1NmFhZWFhYTANCj4gYzJlMjA3YTc3
MzJiZWJhIDEwMDY0NA0KPiAtLS0gYS9pb191cmluZy91cmluZ19jbWQuYw0KPiArKysgYi9pb191
cmluZy91cmluZ19jbWQuYw0KPiBAQCAtMTUxLDcgKzE1MSw3IEBAIHN0YXRpYyBpbmxpbmUgdm9p
ZCBpb19yZXFfc2V0X2NxZTMyX2V4dHJhKHN0cnVjdA0KPiBpb19raW9jYiAqcmVxLA0KPiAgICog
Q2FsbGVkIGJ5IGNvbnN1bWVycyBvZiBpb191cmluZ19jbWQsIGlmIHRoZXkgb3JpZ2luYWxseSBy
ZXR1cm5lZA0KPiAgICogLUVJT0NCUVVFVUVEIHVwb24gcmVjZWl2aW5nIHRoZSBjb21tYW5kLg0K
PiAgICovDQo+IC12b2lkIGlvX3VyaW5nX2NtZF9kb25lKHN0cnVjdCBpb191cmluZ19jbWQgKmlv
dWNtZCwgc3NpemVfdCByZXQsIHNzaXplX3QNCj4gcmVzMiwNCj4gK3ZvaWQgaW9fdXJpbmdfY21k
X2RvbmUoc3RydWN0IGlvX3VyaW5nX2NtZCAqaW91Y21kLCBzc2l6ZV90IHJldCwgdTY0DQo+ICty
ZXMyLA0KPiAgCQkgICAgICAgdW5zaWduZWQgaXNzdWVfZmxhZ3MpDQo+ICB7DQo+ICAJc3RydWN0
IGlvX2tpb2NiICpyZXEgPSBjbWRfdG9faW9fa2lvY2IoaW91Y21kKTsNCj4gDQo+IC0tLQ0KPiBi
YXNlLWNvbW1pdDogN2FmMDhiNTdiY2I5ZWJmNzg2NzVjNTAwNjljNTQxMjVjMGE4Yjc5NQ0KPiBj
aGFuZ2UtaWQ6IDIwMjQxMjAyLWlvX3VyaW5nX2NtZF9kb25lLXJlczItYXMtdTY0LTIxN2E0ZTQ3
YjkzZg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiAtLQ0KPiBCZXJuZCBTY2h1YmVydCA8YnNjaHVi
ZXJ0QGRkbi5jb20+DQo+IA0KDQpJIGhhdmUgYXBwbGllZCB0aGlzIHBhdGNoIHRvIHRoZSBsaW51
eC1ibG9jay9mb3ItbmV4dCBicmFuY2ggYW5kIHRlc3RlZCBjb21waWxhdGlvbg0KdXNpbmcgdGhl
IENPTkZJR19JT19VUklORz15IGFuZCBDT05GSUdfSU9fVVJJTkc9biBvcHRpb25zIHJlc3BlY3Rp
dmVseS4NCkEgc21hbGwgc3VnZ2VzdGlvbiBpcyB0aGF0IHdoZW4gQ09ORklHX0lPX1VSSU5HPW4s
IHRoZSByZXQyIHBhcmFtZXRlciB0eXBlIG9mIGlvX3VyaW5nX2NtZF9kb25lIGNhbg0KYWxzbyBi
ZSBjaGFuZ2VkIHRvIHU2NC4NCg0KVGVzdGVkLWJ5OiBMaSBaZXRhbyA8bGl6ZXRhbzFAaHVhd2Vp
LmNvbT4NClJldmlld2VkLWJ5OiBMaSBaZXRhbyA8bGl6ZXRhbzFAaHVhd2VpLmNvbT4NCg0KLS0N
CkxpIFpldGFvDQo=

