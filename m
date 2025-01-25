Return-Path: <io-uring+bounces-6126-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A25C6A1C1FF
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 08:03:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEDED164C5F
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 07:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E061CCEC8;
	Sat, 25 Jan 2025 07:03:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5828118A6B0
	for <io-uring@vger.kernel.org>; Sat, 25 Jan 2025 07:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737788621; cv=none; b=UiYBZMTqqSC/Q9BBuE/cG7kKnDMpTMIvff/lMvBwIlEwbJgMSrceNqJuaTTh7xthd0YQUVisSBxUwHEf1P96lOc06p05MsFfhaPZmgO6SM7F49nAGC3dWo2vHeejYw0uzkgVYVorpRNA9nhpaDvgmzlN7VEzTeBmjyVjP3JoCWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737788621; c=relaxed/simple;
	bh=WWcD8QvEhWfsatg3dxK+k5tfddRUGHySvHxw92iyUgg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V2vuuX9UCY4FeUIUi4339VNdyI5Zw/FnrdG9vih8qYf/TYfsGzGf+AHlRiXo2ajTy+oirpIneXxD8lxMqHNFYBHUabLF+aYaA0m/arGyKoJu9oFl9Zx5JJKqlN9K1Xj38zlqevdEhQs+vPKomsJALOhhQDB6Fcm/8IqLLJAJo1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Yg4sr5RzDz1V4vJ;
	Sat, 25 Jan 2025 14:44:32 +0800 (CST)
Received: from kwepemd100010.china.huawei.com (unknown [7.221.188.107])
	by mail.maildlp.com (Postfix) with ESMTPS id 2B9B61402C7;
	Sat, 25 Jan 2025 14:47:56 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100010.china.huawei.com (7.221.188.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 25 Jan 2025 14:47:55 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Sat, 25 Jan 2025 14:47:45 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Subject: RE: [PATCH] io_uring/register: use atomic_read/write for sq_flags
 migration
Thread-Topic: [PATCH] io_uring/register: use atomic_read/write for sq_flags
 migration
Thread-Index: AQHbbqfhAneC9VTBIkihYzpe3TBmDbMnDJmA
Date: Sat, 25 Jan 2025 06:47:45 +0000
Message-ID: <6e3287d0d5c349a4a511ab338bb8fd3a@huawei.com>
References: <58689f80-097c-4644-a748-2e848629b379@kernel.dk>
In-Reply-To: <58689f80-097c-4644-a748-2e848629b379@kernel.dk>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmVucyBBeGJvZSA8YXhi
b2VAa2VybmVsLmRrPg0KPiBTZW50OiBTYXR1cmRheSwgSmFudWFyeSAyNSwgMjAyNSA1OjM1IEFN
DQo+IFRvOiBpby11cmluZyA8aW8tdXJpbmdAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBb
UEFUQ0hdIGlvX3VyaW5nL3JlZ2lzdGVyOiB1c2UgYXRvbWljX3JlYWQvd3JpdGUgZm9yIHNxX2Zs
YWdzDQo+IG1pZ3JhdGlvbg0KPiANCj4gQSBwcmV2aW91cyBjb21taXQgY2hhbmdlZCBhbGwgb2Yg
dGhlIG1pZ3JhdGlvbiBmcm9tIHRoZSBvbGQgdG8gdGhlIG5ldyByaW5nDQo+IGZvciByZXNpemlu
ZyB0byB1c2UgUkVBRC9XUklURV9PTkNFLiBIb3dldmVyLCAtPnNxX2ZsYWdzIGlzIGFuIGF0b21p
Y190LCBhbmQNCj4gd2hpbGUgbW9zdCBhcmNocyB3b24ndCBjb21wbGFpbiBvbiB0aGlzLCBzb21l
IHdpbGwgaW5kZWVkIGZsYWcgdGhpczoNCj4gDQo+IGlvX3VyaW5nL3JlZ2lzdGVyLmM6NTU0Ojk6
IHNwYXJzZTogc3BhcnNlOiBjYXN0IHRvIG5vbi1zY2FsYXINCj4gaW9fdXJpbmcvcmVnaXN0ZXIu
Yzo1NTQ6OTogc3BhcnNlOiBzcGFyc2U6IGNhc3QgZnJvbSBub24tc2NhbGFyDQo+IA0KPiBKdXN0
IHVzZSBhdG9taWNfc2V0L2F0b21pY19yZWFkIGZvciBoYW5kbGluZyB0aGlzIGNhc2UuDQo+IA0K
PiBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+IENsb3Nl
czogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvb2Uta2J1aWxkLWFsbC8yMDI1MDEyNDIwMDAuQTJz
S3FhQ0wtDQo+IGxrcEBpbnRlbC5jb20vDQo+IEZpeGVzOiAyYzVhYWUxMjlmNDIgKCJpb191cmlu
Zy9yZWdpc3RlcjogZG9jdW1lbnQgaW9fcmVnaXN0ZXJfcmVzaXplX3JpbmdzKCkNCj4gc2hhcmVk
IG1lbSB1c2FnZSIpDQo+IFNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5k
az4NCj4gDQo+IC0tLQ0KPiANCj4gZGlmZiAtLWdpdCBhL2lvX3VyaW5nL3JlZ2lzdGVyLmMgYi9p
b191cmluZy9yZWdpc3Rlci5jIGluZGV4DQo+IDBkYjE4MTQzN2FlMy4uOWE0ZDJmYmNlNGFlIDEw
MDY0NA0KPiAtLS0gYS9pb191cmluZy9yZWdpc3Rlci5jDQo+ICsrKyBiL2lvX3VyaW5nL3JlZ2lz
dGVyLmMNCj4gQEAgLTU1Miw3ICs1NTIsNyBAQCBzdGF0aWMgaW50IGlvX3JlZ2lzdGVyX3Jlc2l6
ZV9yaW5ncyhzdHJ1Y3QgaW9fcmluZ19jdHgNCj4gKmN0eCwgdm9pZCBfX3VzZXIgKmFyZykNCj4g
IAljdHgtPmNxZV9jYWNoZWQgPSBjdHgtPmNxZV9zZW50aW5lbCA9IE5VTEw7DQo+IA0KPiAgCVdS
SVRFX09OQ0Uobi5yaW5ncy0+c3FfZHJvcHBlZCwgUkVBRF9PTkNFKG8ucmluZ3MtDQo+ID5zcV9k
cm9wcGVkKSk7DQo+IC0JV1JJVEVfT05DRShuLnJpbmdzLT5zcV9mbGFncywgUkVBRF9PTkNFKG8u
cmluZ3MtPnNxX2ZsYWdzKSk7DQo+ICsJYXRvbWljX3NldCgmbi5yaW5ncy0+c3FfZmxhZ3MsIGF0
b21pY19yZWFkKCZvLnJpbmdzLT5zcV9mbGFncykpOw0KPiAgCVdSSVRFX09OQ0Uobi5yaW5ncy0+
Y3FfZmxhZ3MsIFJFQURfT05DRShvLnJpbmdzLT5jcV9mbGFncykpOw0KPiAgCVdSSVRFX09OQ0Uo
bi5yaW5ncy0+Y3Ffb3ZlcmZsb3csIFJFQURfT05DRShvLnJpbmdzLQ0KPiA+Y3Ffb3ZlcmZsb3cp
KTsNCj4gDQo+IC0tDQo+IEplbnMgQXhib2UNCj4gDQoNClJldmlld2VkLWJ5OiBMaSBaZXRhbyA8
bGl6ZXRhbzFAaHVhd2VpLmNvbT4NCg0KLS0NCkxpIFpldGFvDQo=

