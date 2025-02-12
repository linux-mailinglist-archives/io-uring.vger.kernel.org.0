Return-Path: <io-uring+bounces-6365-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B2FBA32B89
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 17:24:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C93A63A25A5
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 16:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11BC2135A1;
	Wed, 12 Feb 2025 16:24:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028D11E766F;
	Wed, 12 Feb 2025 16:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739377485; cv=none; b=ZedNPUG/afFghsFfFZlVjF1jZXVmUvszEhHKV5nX46jTD914Jc93s8ZVq2n2va/mW/skPGooH8nnv9O9U4nfLRrZ3bd6+8EIrVe4c2gStcnuvAiDmKPASNpcdhUk/bgPlSsNctkPHV4AacnmSTDNb7sQBjScpmL+F5CXyRfC2S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739377485; c=relaxed/simple;
	bh=GRS9ax3wN+bieY+KEnsqa9qqa9HX5fGmjjLn0u3zBPQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jJaAUWocgNzj67W5oITSHfaNP0962AWm3T7GSHQRzbVNgSNspBbm/+YMji2/vmR13/5bThTnbgh9m06o/em8Nf7bjpNh+B+OKS5zSkiqjTxDuYbRTPfZSVNwWZYm2KSQhQsN1ua0t727yDK51SsdKxUH+st/F8DBCdYFHC/h1eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4YtNvM3tcPz20qKr;
	Thu, 13 Feb 2025 00:25:03 +0800 (CST)
Received: from kwepemd500010.china.huawei.com (unknown [7.221.188.84])
	by mail.maildlp.com (Postfix) with ESMTPS id 0E08C1402CF;
	Thu, 13 Feb 2025 00:24:34 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd500010.china.huawei.com (7.221.188.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 13 Feb 2025 00:24:33 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Thu, 13 Feb 2025 00:24:33 +0800
From: lizetao <lizetao1@huawei.com>
To: Caleb Sander Mateos <csander@purestorage.com>, Jens Axboe
	<axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] io_uring: use IO_REQ_LINK_FLAGS more
Thread-Topic: [PATCH] io_uring: use IO_REQ_LINK_FLAGS more
Thread-Index: AQHbfMJ74rJl+dLZSU6Ux2PgSQvA+7ND25tw
Date: Wed, 12 Feb 2025 16:24:33 +0000
Message-ID: <4edea498ea61476484fd3829349e4fb0@huawei.com>
References: <20250211202002.3316324-1-csander@purestorage.com>
In-Reply-To: <20250211202002.3316324-1-csander@purestorage.com>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2FsZWIgU2FuZGVy
IE1hdGVvcyA8Y3NhbmRlckBwdXJlc3RvcmFnZS5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgRmVi
cnVhcnkgMTIsIDIwMjUgNDoyMCBBTQ0KPiBUbzogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRr
PjsgUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+DQo+IENjOiBDYWxlYiBT
YW5kZXIgTWF0ZW9zIDxjc2FuZGVyQHB1cmVzdG9yYWdlLmNvbT47IGlvLQ0KPiB1cmluZ0B2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW1BB
VENIXSBpb191cmluZzogdXNlIElPX1JFUV9MSU5LX0ZMQUdTIG1vcmUNCj4gDQo+IFJlcGxhY2Ug
dGhlIDIgaW5zdGFuY2VzIG9mIFJFUV9GX0xJTksgfCBSRVFfRl9IQVJETElOSyB3aXRoIHRoZSBt
b3JlDQo+IGNvbW1vbmx5IHVzZWQgSU9fUkVRX0xJTktfRkxBR1MuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBDYWxlYiBTYW5kZXIgTWF0ZW9zIDxjc2FuZGVyQHB1cmVzdG9yYWdlLmNvbT4NCj4gLS0t
DQo+ICBpb191cmluZy9pb191cmluZy5jIHwgNyArKysrLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwg
NCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2lvX3Vy
aW5nL2lvX3VyaW5nLmMgYi9pb191cmluZy9pb191cmluZy5jIGluZGV4DQo+IGVjOThhMGVjNmYz
NC4uOGJiOGMwOTljM2UxIDEwMDY0NA0KPiAtLS0gYS9pb191cmluZy9pb191cmluZy5jDQo+ICsr
KyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMNCj4gQEAgLTEwOCwxNSArMTA4LDE3IEBADQo+ICAJCQkg
IElPU1FFX0lPX0hBUkRMSU5LIHwgSU9TUUVfQVNZTkMpDQo+IA0KPiAgI2RlZmluZSBTUUVfVkFM
SURfRkxBR1MJKFNRRV9DT01NT05fRkxBR1MgfA0KPiBJT1NRRV9CVUZGRVJfU0VMRUNUIHwgXA0K
PiAgCQkJSU9TUUVfSU9fRFJBSU4gfCBJT1NRRV9DUUVfU0tJUF9TVUNDRVNTKQ0KPiANCj4gKyNk
ZWZpbmUgSU9fUkVRX0xJTktfRkxBR1MgKFJFUV9GX0xJTksgfCBSRVFfRl9IQVJETElOSykNCj4g
Kw0KPiAgI2RlZmluZSBJT19SRVFfQ0xFQU5fRkxBR1MgKFJFUV9GX0JVRkZFUl9TRUxFQ1RFRCB8
DQo+IFJFUV9GX05FRURfQ0xFQU5VUCB8IFwNCj4gIAkJCQlSRVFfRl9QT0xMRUQgfCBSRVFfRl9J
TkZMSUdIVCB8DQo+IFJFUV9GX0NSRURTIHwgXA0KPiAgCQkJCVJFUV9GX0FTWU5DX0RBVEEpDQo+
IA0KPiAtI2RlZmluZSBJT19SRVFfQ0xFQU5fU0xPV19GTEFHUyAoUkVRX0ZfUkVGQ09VTlQgfCBS
RVFfRl9MSU5LIHwNCj4gUkVRX0ZfSEFSRExJTksgfFwNCj4gKyNkZWZpbmUgSU9fUkVRX0NMRUFO
X1NMT1dfRkxBR1MgKFJFUV9GX1JFRkNPVU5UIHwNCj4gSU9fUkVRX0xJTktfRkxBR1MgfCBcDQo+
ICAJCQkJIFJFUV9GX1JFSVNTVUUgfCBJT19SRVFfQ0xFQU5fRkxBR1MpDQo+IA0KPiAgI2RlZmlu
ZSBJT19UQ1RYX1JFRlNfQ0FDSEVfTlIJKDFVIDw8IDEwKQ0KPiANCj4gICNkZWZpbmUgSU9fQ09N
UExfQkFUQ0gJCQkzMg0KPiBAQCAtMTI5LDExICsxMzEsMTAgQEAgc3RydWN0IGlvX2RlZmVyX2Vu
dHJ5IHsNCj4gIAl1MzIJCQlzZXE7DQo+ICB9Ow0KPiANCj4gIC8qIHJlcXVlc3RzIHdpdGggYW55
IG9mIHRob3NlIHNldCBzaG91bGQgdW5kZXJnbyBpb19kaXNhcm1fbmV4dCgpICovICAjZGVmaW5l
DQo+IElPX0RJU0FSTV9NQVNLIChSRVFfRl9BUk1fTFRJTUVPVVQgfCBSRVFfRl9MSU5LX1RJTUVP
VVQgfA0KPiBSRVFfRl9GQUlMKSAtI2RlZmluZSBJT19SRVFfTElOS19GTEFHUyAoUkVRX0ZfTElO
SyB8IFJFUV9GX0hBUkRMSU5LKQ0KPiANCj4gIC8qDQo+ICAgKiBObyB3YWl0ZXJzLiBJdCdzIGxh
cmdlciB0aGFuIGFueSB2YWxpZCB2YWx1ZSBvZiB0aGUgdHcgY291bnRlcg0KPiAgICogc28gdGhh
dCB0ZXN0cyBhZ2FpbnN0IC0+Y3Ffd2FpdF9uciB3b3VsZCBmYWlsIGFuZCBza2lwIHdha2VfdXAo
KS4NCj4gICAqLw0KPiBAQCAtMTE1NSwxMSArMTE1NiwxMSBAQCBzdGF0aWMgaW5saW5lIHZvaWQg
aW9fcmVxX2xvY2FsX3dvcmtfYWRkKHN0cnVjdA0KPiBpb19raW9jYiAqcmVxLA0KPiANCj4gIAkv
Kg0KPiAgCSAqIFdlIGRvbid0IGtub3cgaG93IG1hbnkgcmV1cWVzdHMgaXMgdGhlcmUgaW4gdGhl
IGxpbmsgYW5kIHdoZXRoZXINCj4gIAkgKiB0aGV5IGNhbiBldmVuIGJlIHF1ZXVlZCBsYXppbHks
IGZhbGwgYmFjayB0byBub24tbGF6eS4NCj4gIAkgKi8NCj4gLQlpZiAocmVxLT5mbGFncyAmIChS
RVFfRl9MSU5LIHwgUkVRX0ZfSEFSRExJTkspKQ0KPiArCWlmIChyZXEtPmZsYWdzICYgSU9fUkVR
X0xJTktfRkxBR1MpDQo+ICAJCWZsYWdzICY9IH5JT1VfRl9UV1FfTEFaWV9XQUtFOw0KPiANCj4g
IAlndWFyZChyY3UpKCk7DQo+IA0KPiAgCWhlYWQgPSBSRUFEX09OQ0UoY3R4LT53b3JrX2xsaXN0
LmZpcnN0KTsNCj4gLS0NCj4gMi40NS4yDQo+IA0KDQpSZXZpZXdlZC1ieTogTGkgWmV0YW8gPGxp
emV0YW8xQGh1YXdlaS5jb20+DQoNCi0tLQ0KTGkgWmV0YW8NCg0K

