Return-Path: <io-uring+bounces-5717-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AE5EA034D8
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 03:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1B981882E29
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D5B6208A9;
	Tue,  7 Jan 2025 02:04:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D37EF9EC;
	Tue,  7 Jan 2025 02:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215448; cv=none; b=rXXRJEoYZz9+D+rT951LB7POfWV0hfZ1dQmkmM9JQ8uJxIkQKAcCmIs4nJMS5rfPg8W/z0ore1WDxrILaVhzNPbKUP0oBlmOBfJALG5F8idcewSscUmz9QC6EdXrZoeNQ+oaIr1xdmx1WAHFEpLQB6agzKqqHv1H8J3uHQ7h/48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215448; c=relaxed/simple;
	bh=X0k4gALR4W67fEYRvPK9D71X+PUBn138vMjmLJh589g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pMOLW5cgVmnrKzHS//sy9hQ60ud2hZVu3pFhRZtI8h7jzrf54qMeMnclcuseCco/sTD4VPOKJWiNxYTg8jtx3w0so+06ri0foYLAAz2Dv4F45AUxgi/AIk2mtcC55BsT8LrUtcN62pDbaZzg1J4N4DIpLBE0N+GUer7j3Wqpzns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YRvR85NQWz11RtG;
	Tue,  7 Jan 2025 10:01:08 +0800 (CST)
Received: from kwepemd200010.china.huawei.com (unknown [7.221.188.124])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D89618010A;
	Tue,  7 Jan 2025 10:04:02 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200010.china.huawei.com (7.221.188.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 7 Jan 2025 10:04:01 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Tue, 7 Jan 2025 10:04:01 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>, Mark Harmstone <maharmstone@fb.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: RE: [PATCH 2/4] io_uring/cmd: add per-op data to struct
 io_uring_cmd_data
Thread-Topic: [PATCH 2/4] io_uring/cmd: add per-op data to struct
 io_uring_cmd_data
Thread-Index: AQHbXfCReYc9ryeva0GJNdEZEtgE0rMJtTwg//+cPACAAUBcQA==
Date: Tue, 7 Jan 2025 02:04:01 +0000
Message-ID: <3e2e277ed6bf40ae87890b41133f5314@huawei.com>
References: <20250103150233.2340306-1-maharmstone@fb.com>
 <20250103150233.2340306-3-maharmstone@fb.com>
 <974022e6b52a4ae39f10ea4410dd8e25@huawei.com>
 <01b838d9-485f-47a5-9ee6-f2d79f71ae32@kernel.dk>
In-Reply-To: <01b838d9-485f-47a5-9ee6-f2d79f71ae32@kernel.dk>
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
YXhib2VAa2VybmVsLmRrPg0KPiBTZW50OiBNb25kYXksIEphbnVhcnkgNiwgMjAyNSAxMDo0NiBQ
TQ0KPiBUbzogbGl6ZXRhbyA8bGl6ZXRhbzFAaHVhd2VpLmNvbT47IE1hcmsgSGFybXN0b25lIDxt
YWhhcm1zdG9uZUBmYi5jb20+DQo+IENjOiBsaW51eC1idHJmc0B2Z2VyLmtlcm5lbC5vcmc7IGlv
LXVyaW5nQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDIvNF0gaW9fdXJp
bmcvY21kOiBhZGQgcGVyLW9wIGRhdGEgdG8gc3RydWN0DQo+IGlvX3VyaW5nX2NtZF9kYXRhDQo+
IA0KPiBPbiAxLzYvMjUgNTo0NyBBTSwgbGl6ZXRhbyB3cm90ZToNCj4gPiBIaSwNCj4gPg0KPiA+
PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBNYXJrIEhhcm1zdG9uZSA8
bWFoYXJtc3RvbmVAZmIuY29tPg0KPiA+PiBTZW50OiBGcmlkYXksIEphbnVhcnkgMywgMjAyNSAx
MTowMiBQTQ0KPiA+PiBUbzogbGludXgtYnRyZnNAdmdlci5rZXJuZWwub3JnOyBpby11cmluZ0B2
Z2VyLmtlcm5lbC5vcmcNCj4gPj4gQ2M6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4NCj4g
Pj4gU3ViamVjdDogW1BBVENIIDIvNF0gaW9fdXJpbmcvY21kOiBhZGQgcGVyLW9wIGRhdGEgdG8g
c3RydWN0DQo+ID4+IGlvX3VyaW5nX2NtZF9kYXRhDQo+ID4+DQo+ID4+IEZyb206IEplbnMgQXhi
b2UgPGF4Ym9lQGtlcm5lbC5kaz4NCj4gPj4NCj4gPj4gSW4gY2FzZSBhbiBvcCBoYW5kbGVyIGZv
ciAtPnVyaW5nX2NtZCgpIG5lZWRzIHN0YWJsZSBzdG9yYWdlIGZvciB1c2VyDQo+ID4+IGRhdGEs
IGl0IGNhbiBhbGxvY2F0ZSBpb191cmluZ19jbWRfZGF0YS0+b3BfZGF0YSBhbmQgdXNlIGl0IGZv
ciB0aGUNCj4gPj4gZHVyYXRpb24gb2YgdGhlIHJlcXVlc3QuIFdoZW4gdGhlIHJlcXVlc3QgZ2V0
cyBjbGVhbmVkIHVwLCB1cmluZ19jbWQNCj4gPj4gd2lsbCBmcmVlIGl0IGF1dG9tYXRpY2FsbHku
DQo+ID4+DQo+ID4+IFNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4N
Cj4gPj4gLS0tDQo+ID4+ICBpbmNsdWRlL2xpbnV4L2lvX3VyaW5nL2NtZC5oIHwgIDEgKw0KPiA+
PiAgaW9fdXJpbmcvdXJpbmdfY21kLmMgICAgICAgICB8IDEzICsrKysrKysrKysrLS0NCj4gPj4g
IDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPj4N
Cj4gPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvaW9fdXJpbmcvY21kLmgNCj4gPj4gYi9p
bmNsdWRlL2xpbnV4L2lvX3VyaW5nL2NtZC5oIGluZGV4IDYxZjk3YTM5OGU5ZC4uYTY1YzcwNDMw
NzhmDQo+ID4+IDEwMDY0NA0KPiA+PiAtLS0gYS9pbmNsdWRlL2xpbnV4L2lvX3VyaW5nL2NtZC5o
DQo+ID4+ICsrKyBiL2luY2x1ZGUvbGludXgvaW9fdXJpbmcvY21kLmgNCj4gPj4gQEAgLTIwLDYg
KzIwLDcgQEAgc3RydWN0IGlvX3VyaW5nX2NtZCB7DQo+ID4+DQo+ID4+ICBzdHJ1Y3QgaW9fdXJp
bmdfY21kX2RhdGEgew0KPiA+PiAgCXN0cnVjdCBpb191cmluZ19zcWUJc3Flc1syXTsNCj4gPj4g
Kwl2b2lkCQkJKm9wX2RhdGE7DQo+ID4+ICB9Ow0KPiA+Pg0KPiA+PiAgc3RhdGljIGlubGluZSBj
b25zdCB2b2lkICppb191cmluZ19zcWVfY21kKGNvbnN0IHN0cnVjdCBpb191cmluZ19zcWUNCj4g
Pj4gKnNxZSkgZGlmZiAtLWdpdCBhL2lvX3VyaW5nL3VyaW5nX2NtZC5jIGIvaW9fdXJpbmcvdXJp
bmdfY21kLmMgaW5kZXgNCj4gPj4gNjI5Y2I0MjY2ZGE2Li5jZTc3MjZhMDQ4ODMgMTAwNjQ0DQo+
ID4+IC0tLSBhL2lvX3VyaW5nL3VyaW5nX2NtZC5jDQo+ID4+ICsrKyBiL2lvX3VyaW5nL3VyaW5n
X2NtZC5jDQo+ID4+IEBAIC0yMywxMiArMjMsMTYgQEAgc3RhdGljIHN0cnVjdCBpb191cmluZ19j
bWRfZGF0YQ0KPiA+PiAqaW9fdXJpbmdfYXN5bmNfZ2V0KHN0cnVjdCBpb19raW9jYiAqcmVxKQ0K
PiA+Pg0KPiA+PiAgCWNhY2hlID0gaW9fYWxsb2NfY2FjaGVfZ2V0KCZjdHgtPnVyaW5nX2NhY2hl
KTsNCj4gPj4gIAlpZiAoY2FjaGUpIHsNCj4gPj4gKwkJY2FjaGUtPm9wX2RhdGEgPSBOVUxMOw0K
PiA+DQo+ID4gV2h5IGlzIG9wX2RhdGEgc2V0IHRvIE5VTEwgaGVyZT8gSWYgeW91IGFyZSB3b3Jy
aWVkIGFib3V0IHNvbWUNCj4gPiBvbWlzc2lvbnMsIHdvdWxkIGl0IGJlIGJldHRlciB0byB1c2Ug
V0FSTl9PTiB0byBhc3NlcnQgdGhhdCBvcF9kYXRhIGlzDQo+ID4gYSBudWxsIHBvaW50ZXI/IFRo
aXMgd2lsbCBhbHNvIG1ha2UgaXQgZWFzaWVyIHRvIGFuYWx5emUgdGhlIGNhdXNlIG9mDQo+ID4g
dGhlIHByb2JsZW0uDQo+IA0KPiBDbGVhcmluZyB0aGUgcGVyLW9wIGRhdGEgaXMgcHJ1ZGVudCB3
aGVuIGFsbG9jYXRpbmcgZ2V0dGluZyB0aGlzIHN0cnVjdCwgdG8gYXZvaWQNCj4gcHJldmlvdXMg
Z2FyYmFnZS4gVGhlIGFsdGVybmF0aXZlIHdvdWxkIGJlIGNsZWFyaW5nIGl0IHdoZW4gaXQncyBm
cmVlZCwgZWl0aGVyDQo+IHdheSBpcyBmaW5lIGltaG8uIEEgV0FSTl9PTiB3b3VsZCBub3QgbWFr
ZSBzZW5zZSwgYXMgaXQgY2FuIHZhbGlkbHkgYmUgbm9uLQ0KPiBOVUxMIGFscmVhZHkuDQoNCkkg
c3RpbGwgY2FuJ3QgZnVsbHkgdW5kZXJzdGFuZCwgdGhlIHVzYWdlIGxvZ2ljIG9mIG9wX2RhdGEg
c2hvdWxkIGJlIGFzIGZvbGxvd3M6DQpXaGVuIGFwcGx5aW5nIGZvciBhbmQgaW5pdGlhbGl6aW5n
IHRoZSBjYWNoZSwgb3BfZGF0YSBoYXMgYmVlbiBzZXQgdG8gTlVMTC4NCkluIGlvX3JlcV91cmlu
Z19jbGVhbnVwLCB0aGUgb3BfZGF0YSBtZW1vcnkgd2lsbCBiZSByZWxlYXNlZCBhbmQgc2V0IHRv
IE5VTEwuDQpTbyBpZiB0aGUgY2FjaGUgaW4gdXJpbmdfY2FjaGUsIGl0cyBvcF9kYXRhIHNob3Vs
ZCBiZSBOVUxMPyBJZiBpdCBpcyBub24tTlVMTCwgaXMgdGhlcmUNCmEgcmlzayBvZiBtZW1vcnkg
bGVhayBpZiBpdCBpcyBkaXJlY3RseSBzZXQgdG8gbnVsbD8NCj4gDQo+IC0tDQo+IEplbnMgQXhi
b2UNCg0KLS0tDQpMaSBaZXRhbw0K

