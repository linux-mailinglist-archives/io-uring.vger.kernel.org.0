Return-Path: <io-uring+bounces-6407-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 654C0A346B6
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 16:27:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B92943AC8C6
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 15:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8113726B097;
	Thu, 13 Feb 2025 15:12:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A3926B0A4
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 15:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459574; cv=none; b=tNcL9ZA2VOeOVbMIhXaoqr9qxc50M9Q8jgGM3gdrziFCDA1Z9GBjm9Z+nVnUlIIL9UBR4VehFlybqpfVr6EzyvqqJA5N43J+cQNizX97l7FRwe2Yx6rFb5ikHBcayfXY+fWUzqpCif9rk2sA6dPGeGu92UNZ3dQdLo4r2Y6lhTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459574; c=relaxed/simple;
	bh=XPpyt8tli3OMOzVDvxhqfrJuiwPfZ4ysU7k9wbzI0vs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JDIYLcqbk19L1pToi50htBOgpIgCnk2kft1XHKjXV64FKYFUniBTVzhpsInUDovgoLuusPSjB4VtQBO84X2u4pIU6KTVAJ7cvsKs/0nras+tiEtH/0G1rtA4Hr4ikLzVClwoAkWshOYd34AgctUijbBsVN3d3MAqGH1gqxX63co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ytz9L4qzFzkXKS;
	Thu, 13 Feb 2025 23:09:10 +0800 (CST)
Received: from kwepemd100010.china.huawei.com (unknown [7.221.188.107])
	by mail.maildlp.com (Postfix) with ESMTPS id 86D8218010B;
	Thu, 13 Feb 2025 23:12:44 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100010.china.huawei.com (7.221.188.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 13 Feb 2025 23:12:44 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Thu, 13 Feb 2025 23:12:44 +0800
From: lizetao <lizetao1@huawei.com>
To: Keith Busch <kbusch@meta.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, "axboe@kernel.dk"
	<axboe@kernel.dk>
Subject: RE: [PATCHv2 0/6] ublk zero-copy support
Thread-Topic: [PATCHv2 0/6] ublk zero-copy support
Thread-Index: AQHbfB/vq06q5HS6S0+pcuuiJTiiHrNFWNrg
Date: Thu, 13 Feb 2025 15:12:43 +0000
Message-ID: <83fd69a8aa77450093acb1ada05c188f@huawei.com>
References: <20250211005646.222452-1-kbusch@meta.com>
In-Reply-To: <20250211005646.222452-1-kbusch@meta.com>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS2VpdGggQnVzY2gg
PGtidXNjaEBtZXRhLmNvbT4NCj4gU2VudDogVHVlc2RheSwgRmVicnVhcnkgMTEsIDIwMjUgODo1
NyBBTQ0KPiBUbzogbWluZy5sZWlAcmVkaGF0LmNvbTsgYXNtbC5zaWxlbmNlQGdtYWlsLmNvbTsg
YXhib2VAa2VybmVsLmRrOyBsaW51eC0NCj4gYmxvY2tAdmdlci5rZXJuZWwub3JnOyBpby11cmlu
Z0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGJlcm5kQGJzYmVybmQuY29tOyBLZWl0aCBCdXNjaCA8
a2J1c2NoQGtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFtQQVRDSHYyIDAvNl0gdWJsayB6ZXJvLWNv
cHkgc3VwcG9ydA0KPiANCj4gRnJvbTogS2VpdGggQnVzY2ggPGtidXNjaEBrZXJuZWwub3JnPg0K
PiANCj4gUHJldmlvdXMgdmVyc2lvbiB3YXMgZGlzY3Vzc2VkIGhlcmU6DQo+IA0KPiAgIGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWJsb2NrLzIwMjUwMjAzMTU0NTE3LjkzNzYyMy0xLQ0K
PiBrYnVzY2hAbWV0YS5jb20vDQo+IA0KPiBUaGUgc2FtZSB1Ymxrc3J2IHJlZmVyZW5jZSBjb2Rl
IGluIHRoYXQgbGluayB3YXMgdXNlZCB0byB0ZXN0IHRoZSBrZXJuZWwgc2lkZQ0KPiBjaGFuZ2Vz
Lg0KPiANCj4gQmVmb3JlIGxpc3Rpbmcgd2hhdCBoYXMgY2hhbmdlZCwgSSB3YW50IHRvIG1lbnRp
b24gd2hhdCBpcyB0aGUgc2FtZTogdGhlDQo+IHJlbGlhbmNlIG9uIHRoZSByaW5nIGN0eCBsb2Nr
IHRvIHNlcmlhbGl6ZSB0aGUgcmVnaXN0ZXIgYWhlYWQgb2YgYW55IHVzZS4gSSdtIG5vdA0KPiBp
Z25vcmluZyB0aGUgZmVlZGJhY2s7IEkganVzdCBkb24ndCBoYXZlIGEgc29saWQgYW5zd2VyIHJp
Z2h0IG5vdywgYW5kIHdhbnQgdG8NCj4gcHJvZ3Jlc3Mgb24gdGhlIG90aGVyIGZyb250cyBpbiB0
aGUgbWVhbnRpbWUuDQo+IA0KPiBIZXJlJ3Mgd2hhdCdzIGRpZmZlcmVudCBmcm9tIHRoZSBwcmV2
aW91czoNCj4gDQo+ICAtIEludHJvZHVjZWQgYW4gb3B0aW9uYWwgJ3JlbGVhc2UnIGNhbGxiYWNr
IHdoZW4gdGhlIHJlc291cmNlIG5vZGUgaXMNCj4gICAgbm8gbG9uZ2VyIHJlZmVyZW5jZWQuIFRo
ZSBjYWxsYmFjayBhZGRyZXNzZXMgYW55IGJ1Z2d5IGFwcGxpY2F0aW9ucw0KPiAgICB0aGF0IG1h
eSBjb21wbGV0ZSB0aGVpciByZXF1ZXN0IGFuZCB1bnJlZ2lzdGVyIHRoZWlyIGluZGV4IHdoaWxl
IElPDQo+ICAgIGlzIGluIGZsaWdodC4gVGhpcyBvYnZpYXRlcyBhbnkgbmVlZCB0byB0YWtlIGV4
dHJhIHBhZ2UgcmVmZXJlbmNlcw0KPiAgICBzaW5jZSBpdCBwcmV2ZW50cyB0aGUgcmVxdWVzdCBm
cm9tIGNvbXBsZXRpbmcuDQo+IA0KPiAgLSBSZW1vdmVkIHBlZWtpbmcgaW50byB0aGUgaW9fY2Fj
aGUgZWxlbWVudCBzaXplIGFuZCBpbnN0ZWFkIHVzZSBhDQo+ICAgIG1vcmUgaW50dWl0aXZlIGJ2
ZWMgc2VnbWVudCBjb3VudCBsaW1pdCB0byBkZWNpZGUgaWYgd2UncmUgY2FjaGluZw0KPiAgICB0
aGUgaW11IChzdWdnZXN0ZWQgYnkgUGF2ZWwpLg0KPiANCj4gIC0gRHJvcHBlZCB0aGUgY29uc3Qg
cmVxdWVzdCBjaGFuZ2VzOyBpdCdzIG5vdCBuZWVkZWQuDQoNCkkgdGVzdGVkIHRoaXMgcGF0Y2gg
c2V0LiBXaGVuIEkgdXNlIG51bGwgYXMgdGhlIGRldmljZSwgdGhlIHRlc3QgcmVzdWx0cyBhcmUg
bGlrZSB5b3VyIHYxLg0KV2hlbiB0aGUgYnMgaXMgNGssIHRoZXJlIGlzIGEgc2xpZ2h0IGltcHJv
dmVtZW50OyB3aGVuIHRoZSBicyBpcyA2NGssIHRoZXJlIGlzIGEgc2lnbmlmaWNhbnQgaW1wcm92
ZW1lbnQuDQpIb3dldmVyLCB3aGVuIEkgdXNlZCBsb29wIGFzIHRoZSBkZXZpY2UsIEkgZm91bmQg
dGhhdCB0aGVyZSB3YXMgbm8gaW1wcm92ZW1lbnQsIHdoZXRoZXIgdXNpbmcgNGsgb3IgNjRrLiBB
cyBmb2xsb3c6DQoNCiAgdWJsayBhZGQgLXQgbG9vcCAtZiAuL3VibGstbG9vcC5pbWcgDQogIHVi
bGsgYWRkIC10IGxvb3AgLWYgLi91YmxrLWxvb3AtemVyb2NvcHkuaW1nDQoNCiAgZmlvIC1maWxl
bmFtZT0vZGV2L3VibGtiMCAtZGlyZWN0PTEgLXJ3PXJlYWQgLWlvZGVwdGg9MSAtaW9lbmdpbmU9
aW9fdXJpbmcgLWJzPTEyOGsgLXNpemU9NUcNCiAgICByZWFkOiBJT1BTPTIwMTUsIEJXPTEyNk1p
Qi9zICgxMzJNQi9zKSgxMjYwTWlCLzEwMDA1bXNlYykNCg0KICBmaW8gLWZpbGVuYW1lPS9kZXYv
dWJsa2IxIC1kaXJlY3Q9MSAtcnc9cmVhZCAtaW9kZXB0aD0xIC1pb2VuZ2luZT1pb191cmluZyAt
YnM9MTI4ayAtc2l6ZT01Rw0KICAgIHJlYWQ6IElPUFM9MTk5OCwgQlc9MTI1TWlCL3MgKDEzMU1C
L3MpKDEyNTBNaUIvMTAwMDVtc2VjKQ0KDQoNClNvLCB0aGlzIHBhdGNoIHNldCBpcyBvcHRpbWl6
ZWQgZm9yIG51bGwgdHlwZSBkZXZpY2VzPyBPciBpZiBJJ3ZlIG1pc3NlZCBhbnkga2V5IGluZm9y
bWF0aW9uLCBwbGVhc2UgbGV0IG1lIGtub3cuDQoNCg0KLS0tDQpMaSBaZXRhbw0KDQo=

