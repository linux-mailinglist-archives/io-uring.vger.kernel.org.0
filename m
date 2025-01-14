Return-Path: <io-uring+bounces-5853-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E435A0FE73
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 03:07:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AB7E7A1BA9
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 02:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B05291EB2E;
	Tue, 14 Jan 2025 02:06:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA248493
	for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 02:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736820416; cv=none; b=aXRx4q7+BFjM8TzH7btNWM5BjOgxvqEL0eg0sc6EsuF5JndMO5OYT4LNzq/wcqX1n/6XM+YJfh++qIhLzrJVulbVG9yC061xr11sQqx9Arj0bqOcdcVMjMbJg+P89+xHFnDOD1eqY3ZdX/w+iotIueBPSNsiiTJ99FG1iOVThU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736820416; c=relaxed/simple;
	bh=YgaC0fzUTNraUPayw/nF1wraGESscFUv5sbDTjUJlII=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mGJHvS07VCti6o7VjFDSaO2v1w8ggazQc5YZnjNmQ8BiO0vbZruxGIugDHg9CfjqiSP/FoSDy8HQc0Wpm22UUklu3fKx+rXXGOECxbCUbXCQzROg9etb7MX6l0Dfw5Pdbly4VpGfcpycPWHkfoU+rHAJMIoD8yH79+TaUVodEdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4YXC9n6PgrzRlHP;
	Tue, 14 Jan 2025 10:04:29 +0800 (CST)
Received: from kwepemd100010.china.huawei.com (unknown [7.221.188.107])
	by mail.maildlp.com (Postfix) with ESMTPS id 4158A1802E1;
	Tue, 14 Jan 2025 10:06:51 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100010.china.huawei.com (7.221.188.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 14 Jan 2025 10:06:50 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Tue, 14 Jan 2025 10:06:50 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: [PATCH] io_uring/io-wq: Fix a small time window for reading
 work->flags
Thread-Topic: [PATCH] io_uring/io-wq: Fix a small time window for reading
 work->flags
Thread-Index: AdtmKOA8sg05Tt97QvCw7GBc1hDbnw==
Date: Tue, 14 Jan 2025 02:06:50 +0000
Message-ID: <5fd306d40ebb4da0a657da9a9be5cec1@huawei.com>
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

VGhlcmUgaXMgYSBzbWFsbCB0aW1lIHdpbmRvdyB0aGF0IGlzIG1vZGlmaWVkIGJ5IG90aGVyIHRh
c2tzIGFmdGVyDQpyZWFkaW5nIHdvcmstPmZsYWdzLiBJdCBpcyBjaGFuZ2VkIHRvIHJlYWQgYmVm
b3JlIHVzZSwgd2hpY2ggaXMgbW9yZQ0KaW4gbGluZSB3aXRoIHRoZSBzZW1hbnRpY3Mgb2YgYXRv
bXMuDQoNCkZpeGVzOiAzNDc0ZDFiOTNmODkgKCJpb191cmluZy9pby13cTogbWFrZSBpb193cV93
b3JrIGZsYWdzIGF0b21pYyIpDQpTaWduZWQtb2ZmLWJ5OiBMaSBaZXRhbyA8bGl6ZXRhbzFAaHVh
d2VpLmNvbT4NCi0tLQ0KIGlvX3VyaW5nL2lvLXdxLmMgfCA1ICsrLS0tDQogMSBmaWxlIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2lvX3Vy
aW5nL2lvLXdxLmMgYi9pb191cmluZy9pby13cS5jDQppbmRleCBhMzhmMzZiNjgwNjAuLjc1MDk2
ZTc3YjFmZSAxMDA2NDQNCi0tLSBhL2lvX3VyaW5nL2lvLXdxLmMNCisrKyBiL2lvX3VyaW5nL2lv
LXdxLmMNCkBAIC05MzIsNyArOTMyLDYgQEAgc3RhdGljIGJvb2wgaW9fd3Ffd29ya19tYXRjaF9p
dGVtKHN0cnVjdCBpb193cV93b3JrICp3b3JrLCB2b2lkICpkYXRhKQ0KIHZvaWQgaW9fd3FfZW5x
dWV1ZShzdHJ1Y3QgaW9fd3EgKndxLCBzdHJ1Y3QgaW9fd3Ffd29yayAqd29yaykNCiB7DQogCXN0
cnVjdCBpb193cV9hY2N0ICphY2N0ID0gaW9fd29ya19nZXRfYWNjdCh3cSwgd29yayk7DQotCXVu
c2lnbmVkIGludCB3b3JrX2ZsYWdzID0gYXRvbWljX3JlYWQoJndvcmstPmZsYWdzKTsNCiAJc3Ry
dWN0IGlvX2NiX2NhbmNlbF9kYXRhIG1hdGNoID0gew0KIAkJLmZuCQk9IGlvX3dxX3dvcmtfbWF0
Y2hfaXRlbSwNCiAJCS5kYXRhCQk9IHdvcmssDQpAQCAtOTQ1LDcgKzk0NCw3IEBAIHZvaWQgaW9f
d3FfZW5xdWV1ZShzdHJ1Y3QgaW9fd3EgKndxLCBzdHJ1Y3QgaW9fd3Ffd29yayAqd29yaykNCiAJ
ICogYmVlbiBtYXJrZWQgYXMgb25lIHRoYXQgc2hvdWxkIG5vdCBnZXQgZXhlY3V0ZWQsIGNhbmNl
bCBpdCBoZXJlLg0KIAkgKi8NCiAJaWYgKHRlc3RfYml0KElPX1dRX0JJVF9FWElULCAmd3EtPnN0
YXRlKSB8fA0KLQkgICAgKHdvcmtfZmxhZ3MgJiBJT19XUV9XT1JLX0NBTkNFTCkpIHsNCisJICAg
IChhdG9taWNfcmVhZCgmd29yay0+ZmxhZ3MpICYgSU9fV1FfV09SS19DQU5DRUwpKSB7DQogCQlp
b19ydW5fY2FuY2VsKHdvcmssIHdxKTsNCiAJCXJldHVybjsNCiAJfQ0KQEAgLTk1OSw3ICs5NTgs
NyBAQCB2b2lkIGlvX3dxX2VucXVldWUoc3RydWN0IGlvX3dxICp3cSwgc3RydWN0IGlvX3dxX3dv
cmsgKndvcmspDQogCWRvX2NyZWF0ZSA9ICFpb193cV9hY3RpdmF0ZV9mcmVlX3dvcmtlcih3cSwg
YWNjdCk7DQogCXJjdV9yZWFkX3VubG9jaygpOw0KIA0KLQlpZiAoZG9fY3JlYXRlICYmICgod29y
a19mbGFncyAmIElPX1dRX1dPUktfQ09OQ1VSUkVOVCkgfHwNCisJaWYgKGRvX2NyZWF0ZSAmJiAo
KGF0b21pY19yZWFkKCZ3b3JrLT5mbGFncykgJiBJT19XUV9XT1JLX0NPTkNVUlJFTlQpIHx8DQog
CSAgICAhYXRvbWljX3JlYWQoJmFjY3QtPm5yX3J1bm5pbmcpKSkgew0KIAkJYm9vbCBkaWRfY3Jl
YXRlOw0KIA0KLS0gDQoyLjMzLjANCg==

