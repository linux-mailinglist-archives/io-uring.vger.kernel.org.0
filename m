Return-Path: <io-uring+bounces-6473-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 258B8A36C02
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 05:39:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77A187A3805
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 04:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004381547E9;
	Sat, 15 Feb 2025 04:39:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F020E748F
	for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 04:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739594362; cv=none; b=FHEZKuEXzB7B4+M31VUeWC6XZ0YIBVWtrMe2bV08WkiW2I+jRBUDTLPNoOSjFU0yzn2n5iHxlVI1iP5PFKr7RNzmGKLqU4jEx9wu938qMliiZTDgenBCr59hR1D+eL81rh6WsmlXwBTxXUVoV6vmB+Lij3se4USnkjTZHU1pwo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739594362; c=relaxed/simple;
	bh=dIPfZRBw+59o3SsaiabgyjyPaKpfcAToOlnyfZfj8lU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BCGoZocfYkUms1VKRzilwc87qulPmHQF2MPLYllEH9Ic45qhFNsU1Fo87G9gEJX4+CL4bA6vgDkIsart9tdim+jY+y0+qXCDNIZTid2gIPclcjylkgWGSxQ3e7vryf3LpcwXFmZPynvWrRwbuCFHEIkAePoNLFB3iLzTi2bT9wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Yvx161bZqz1ltZL;
	Sat, 15 Feb 2025 12:35:22 +0800 (CST)
Received: from kwepemd500011.china.huawei.com (unknown [7.221.188.45])
	by mail.maildlp.com (Postfix) with ESMTPS id 64A2E1A016C;
	Sat, 15 Feb 2025 12:39:11 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd500011.china.huawei.com (7.221.188.45) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 15 Feb 2025 12:39:11 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Sat, 15 Feb 2025 12:39:11 +0800
From: lizetao <lizetao1@huawei.com>
To: Pavel Begunkov <asml.silence@gmail.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Subject: RE: [PATCH 1/1] io_uring: prevent opcode speculation
Thread-Topic: [PATCH 1/1] io_uring: prevent opcode speculation
Thread-Index: AQHbfzJuGn6VgP8bnkiQWV1o6Ni7zbNHyJNA
Date: Sat, 15 Feb 2025 04:39:10 +0000
Message-ID: <fb0de760ab8c48a79e8e4dadfb10ffcf@huawei.com>
References: <7eddbf31c8ca0a3947f8ed98271acc2b4349c016.1739568408.git.asml.silence@gmail.com>
In-Reply-To: <7eddbf31c8ca0a3947f8ed98271acc2b4349c016.1739568408.git.asml.silence@gmail.com>
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
b3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+DQo+IFNlbnQ6IFNhdHVyZGF5LCBGZWJydWFyeSAx
NSwgMjAyNSA2OjQ4IEFNDQo+IFRvOiBpby11cmluZ0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGFz
bWwuc2lsZW5jZUBnbWFpbC5jb20NCj4gU3ViamVjdDogW1BBVENIIDEvMV0gaW9fdXJpbmc6IHBy
ZXZlbnQgb3Bjb2RlIHNwZWN1bGF0aW9uDQo+IA0KPiBzcWUtPm9wY29kZSBpcyB1c2VkIGZvciBk
aWZmZXJlbnQgdGFibGVzLCBtYWtlIHN1cmUgd2Ugc2FudGl0aXNlIGl0DQo+IGFnYWluc3Qgc3Bl
Y3VsYXRpb25zLg0KPiANCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gRml4ZXM6IGQz
NjU2MzQ0ZmVhMDMgKCJpb191cmluZzogYWRkIGxvb2t1cCB0YWJsZSBmb3IgdmFyaW91cyBvcGNv
ZGUgbmVlZHMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNl
QGdtYWlsLmNvbT4NCj4gLS0tDQo+ICBpb191cmluZy9pb191cmluZy5jIHwgMiArKw0KPiAgMSBm
aWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2lvX3VyaW5n
L2lvX3VyaW5nLmMgYi9pb191cmluZy9pb191cmluZy5jIGluZGV4DQo+IDI2M2U1MDRiZTRhOC4u
MjlhNDIzNjVhNDgxIDEwMDY0NA0KPiAtLS0gYS9pb191cmluZy9pb191cmluZy5jDQo+ICsrKyBi
L2lvX3VyaW5nL2lvX3VyaW5nLmMNCj4gQEAgLTIwNDUsNiArMjA0NSw4IEBAIHN0YXRpYyBpbnQg
aW9faW5pdF9yZXEoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIHN0cnVjdA0KPiBpb19raW9jYiAq
cmVxLA0KPiAgCQlyZXEtPm9wY29kZSA9IDA7DQo+ICAJCXJldHVybiBpb19pbml0X2ZhaWxfcmVx
KHJlcSwgLUVJTlZBTCk7DQo+ICAJfQ0KPiArCW9wY29kZSA9IGFycmF5X2luZGV4X25vc3BlYyhv
cGNvZGUsIElPUklOR19PUF9MQVNUKTsNCj4gKw0KPiAgCWRlZiA9ICZpb19pc3N1ZV9kZWZzW29w
Y29kZV07DQo+ICAJaWYgKHVubGlrZWx5KHNxZV9mbGFncyAmIH5TUUVfQ09NTU9OX0ZMQUdTKSkg
ew0KPiAgCQkvKiBlbmZvcmNlIGZvcndhcmRzIGNvbXBhdGliaWxpdHkgb24gdXNlcnMgKi8NCj4g
LS0NCj4gMi40OC4xDQo+IA0KDQpSZXZpZXdlZC1ieTogTGkgWmV0YW8gPGxpemV0YW8xQGh1YXdl
aS5jb20+DQoNCi0tLQ0KTGkgWmV0YW8NCg0K

