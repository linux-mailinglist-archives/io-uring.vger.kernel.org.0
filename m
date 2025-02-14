Return-Path: <io-uring+bounces-6432-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD615A35564
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 04:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAEC57A49A1
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 03:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863E04A08;
	Fri, 14 Feb 2025 03:39:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA640153836
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 03:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739504369; cv=none; b=Ogfr/xLIB5yzQJbwtHs46YfeaZ7nyDBVw4rdMH+vgc4ufPCHipaLGqievjBUtU+5P5y+fs1eZr4ZHbo0+OgdBy50RDcZphrDhK2swNjK6QqtzaO7V0pm+uhsNBZi37yXR4Hjf/Hc+jkO/CuXBVO7mO5mbKZhUg9A5x4432uNpxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739504369; c=relaxed/simple;
	bh=Sj3k+oSKkZbNsCm/dyumWcN5rlkG2z6Ww7Y6nMJnvCw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PwRzYeHtFvnzGzCaBYYHhiSz32H/4Z2T0IraTdWInlM7yZjzNIYdmvGeqPX86AXw5HRMIhZ8oj+apFisazI+/t1Maea0W1dgA5wTbiImNPuZkpmQ2VKh/kXf8TzienvvUoSlTBtN/OcgAazWpv0BJ60z8WYaWQuGlr15x0ceJ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YvHl60Ch9zgckJ;
	Fri, 14 Feb 2025 11:36:02 +0800 (CST)
Received: from kwepemd200012.china.huawei.com (unknown [7.221.188.145])
	by mail.maildlp.com (Postfix) with ESMTPS id 4E880140121;
	Fri, 14 Feb 2025 11:39:23 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200012.china.huawei.com (7.221.188.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 14 Feb 2025 11:39:22 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Fri, 14 Feb 2025 11:39:22 +0800
From: lizetao <lizetao1@huawei.com>
To: Keith Busch <kbusch@kernel.org>
CC: Keith Busch <kbusch@meta.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Subject: RE: [PATCHv2 0/6] ublk zero-copy support
Thread-Topic: [PATCHv2 0/6] ublk zero-copy support
Thread-Index: AQHbfB/vq06q5HS6S0+pcuuiJTiiHrNFWNrg//+LSYCAATaMUA==
Date: Fri, 14 Feb 2025 03:39:22 +0000
Message-ID: <3a6ca1b138984c6bb8809237c30f98dd@huawei.com>
References: <20250211005646.222452-1-kbusch@meta.com>
 <83fd69a8aa77450093acb1ada05c188f@huawei.com> <Z64YiTHfvA-_NCsl@kbusch-mbp>
In-Reply-To: <Z64YiTHfvA-_NCsl@kbusch-mbp>
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
PGtidXNjaEBrZXJuZWwub3JnPg0KPiBTZW50OiBGcmlkYXksIEZlYnJ1YXJ5IDE0LCAyMDI1IDEy
OjA3IEFNDQo+IFRvOiBsaXpldGFvIDxsaXpldGFvMUBodWF3ZWkuY29tPg0KPiBDYzogS2VpdGgg
QnVzY2ggPGtidXNjaEBtZXRhLmNvbT47IGlvLXVyaW5nQHZnZXIua2VybmVsLm9yZzsNCj4gYXhi
b2VAa2VybmVsLmRrDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0h2MiAwLzZdIHVibGsgemVyby1jb3B5
IHN1cHBvcnQNCj4gDQo+IE9uIFRodSwgRmViIDEzLCAyMDI1IGF0IDAzOjEyOjQzUE0gKzAwMDAs
IGxpemV0YW8gd3JvdGU6DQo+ID4gSSB0ZXN0ZWQgdGhpcyBwYXRjaCBzZXQuIFdoZW4gSSB1c2Ug
bnVsbCBhcyB0aGUgZGV2aWNlLCB0aGUgdGVzdCByZXN1bHRzIGFyZSBsaWtlDQo+IHlvdXIgdjEu
DQo+ID4gV2hlbiB0aGUgYnMgaXMgNGssIHRoZXJlIGlzIGEgc2xpZ2h0IGltcHJvdmVtZW50OyB3
aGVuIHRoZSBicyBpcyA2NGssIHRoZXJlIGlzDQo+IGEgc2lnbmlmaWNhbnQgaW1wcm92ZW1lbnQu
DQo+ID4gSG93ZXZlciwgd2hlbiBJIHVzZWQgbG9vcCBhcyB0aGUgZGV2aWNlLCBJIGZvdW5kIHRo
YXQgdGhlcmUgd2FzIG5vDQo+IGltcHJvdmVtZW50LCB3aGV0aGVyIHVzaW5nIDRrIG9yIDY0ay4g
QXMgZm9sbG93Og0KPiA+DQo+ID4gICB1YmxrIGFkZCAtdCBsb29wIC1mIC4vdWJsay1sb29wLmlt
Zw0KPiA+ICAgdWJsayBhZGQgLXQgbG9vcCAtZiAuL3VibGstbG9vcC16ZXJvY29weS5pbWcNCj4g
Pg0KPiA+ICAgZmlvIC1maWxlbmFtZT0vZGV2L3VibGtiMCAtZGlyZWN0PTEgLXJ3PXJlYWQgLWlv
ZGVwdGg9MSAtaW9lbmdpbmU9aW9fdXJpbmcNCj4gLWJzPTEyOGsgLXNpemU9NUcNCj4gPiAgICAg
cmVhZDogSU9QUz0yMDE1LCBCVz0xMjZNaUIvcyAoMTMyTUIvcykoMTI2ME1pQi8xMDAwNW1zZWMp
DQo+ID4NCj4gPiAgIGZpbyAtZmlsZW5hbWU9L2Rldi91YmxrYjEgLWRpcmVjdD0xIC1ydz1yZWFk
IC1pb2RlcHRoPTEgLWlvZW5naW5lPWlvX3VyaW5nDQo+IC1icz0xMjhrIC1zaXplPTVHDQo+ID4g
ICAgIHJlYWQ6IElPUFM9MTk5OCwgQlc9MTI1TWlCL3MgKDEzMU1CL3MpKDEyNTBNaUIvMTAwMDVt
c2VjKQ0KPiA+DQo+ID4NCj4gPiBTbywgdGhpcyBwYXRjaCBzZXQgaXMgb3B0aW1pemVkIGZvciBu
dWxsIHR5cGUgZGV2aWNlcz8gT3IgaWYgSSd2ZSBtaXNzZWQgYW55IGtleQ0KPiBpbmZvcm1hdGlv
biwgcGxlYXNlIGxldCBtZSBrbm93Lg0KPiANCj4gV2hhdCBkbyB5b3UgZ2V0IGlmIGlmIHlvdSBy
dW4geW91ciBmaW8gam9iIGRpcmVjdGx5IG9uIHlvdXIgdWJsay1sb29wLmltZyBmaWxlPw0KDQpJ
IHRlc3QgaXQgZGlyZWN0bHkgb24gdWJsay1sb29wLmltZywgYW5kIHRoZSByZXN1bHQgaXMgYXMg
Zm9sbG93Og0KICANCiAgZmlvIC1maWxlbmFtZT0uL3VibGstbG9vcC5pbWcgLWRpcmVjdD0xIC1y
dz1yZWFkIC1pb2RlcHRoPTEgLWlvZW5naW5lPWlvX3VyaW5nIC1icz0xMjhrIC1zaXplPTVHDQog
IHJlYWQ6IElPUFM9MTAwNSwgQlc9MTI2TWlCL3MgKDEzMk1CL3MpKDEyNThNaUIvMTAwMDltc2Vj
KQ0KDQpGcm9tIHRoZSB0ZXN0IHJlc3VsdHMsIHRoaXMgc2VlbXMgdG8gYmUgbGltaXRlZCBieSB0
aGUgcGVyZm9ybWFuY2UgbGltaXRhdGlvbnMgb2YgdGhlIGZpbGUgc3lzdGVtDQp3aGVyZSAuL3Vi
bGstbG9vcC5pbWcgaXMgbG9jYXRlZC4NCg0KPiBUaHJvdWdocHV0IHNob3VsZCBpbXByb3ZlIHVu
dGlsIHlvdSd2ZSBzYXR1cmF0ZWQgdGhlIGJhY2tlbmQgZGV2aWNlLg0KPiBPbmNlIHlvdSBoaXQg
dGhhdCBwb2ludCwgdGhlIHByaW1hcnkgYmVuZWZpdCBvZiB6ZXJvLWNvcHkgY29tZSBmcm9tIGRl
Y3JlYXNlZA0KPiBtZW1vcnkgYW5kIENQVSB1dGlsaXphdGlvbnMuDQoNCi0tLQ0KTGkgWmV0YW8N
Cg==

