Return-Path: <io-uring+bounces-6405-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66A56A34157
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 15:08:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17A9B7A03E3
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 14:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F4C221713;
	Thu, 13 Feb 2025 14:04:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E616A2222B6;
	Thu, 13 Feb 2025 14:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739455475; cv=none; b=jHLNn72BWZo94qm0TUgxOXuxiokGQ02i4XAPorxuuZF8vDMie0Sn9CGfpTuhec5emd/C9Zi8tFJLZ+MQO5TNobQo2m+qRzWoG4w9eub/rfrKoBjugzSdGUGOY1YGE4f3z8dLZXXft4S/oVdbnMjeRpKRBRLH8huQxWpfO/5ZsGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739455475; c=relaxed/simple;
	bh=7GxreNtLxkyAsAf/SHzi0GF3A7llOYJx5Atvolf2RKc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qw+ZOgP/PFxPbjU7YJwXrSAq3FtbU/saMhkKTW592sqoSroKpi1uQKyxsU7kC+sSY+MZe7h1fqJJbuYOFn/BZE4IIPDu15y/P28ZklaUUmnnuA0cFu3XtNyeO+vITKrqXcNP+3aVpQtqd9aIyShfi4LNOBVxRXJmGAc/18gLChg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ytxfb1dNHzkXNF;
	Thu, 13 Feb 2025 22:00:55 +0800 (CST)
Received: from kwepemd500011.china.huawei.com (unknown [7.221.188.45])
	by mail.maildlp.com (Postfix) with ESMTPS id 0B2A21800EA;
	Thu, 13 Feb 2025 22:04:29 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd500011.china.huawei.com (7.221.188.45) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 13 Feb 2025 22:04:28 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Thu, 13 Feb 2025 22:04:28 +0800
From: lizetao <lizetao1@huawei.com>
To: Caleb Sander Mateos <csander@purestorage.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Subject: RE: [PATCH] io_uring: use lockless_cq flag in io_req_complete_post()
Thread-Topic: [PATCH] io_uring: use lockless_cq flag in io_req_complete_post()
Thread-Index: AQHbfOhWd2OE9cuOPEKuwkCotYxPjrNFRZPg
Date: Thu, 13 Feb 2025 14:04:28 +0000
Message-ID: <acc4f93c55574b8abd55da174248e9d2@huawei.com>
References: <20250212005119.3433005-1-csander@purestorage.com>
In-Reply-To: <20250212005119.3433005-1-csander@purestorage.com>
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
cnVhcnkgMTIsIDIwMjUgODo1MSBBTQ0KPiBUbzogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRr
PjsgUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+DQo+IENjOiBDYWxlYiBT
YW5kZXIgTWF0ZW9zIDxjc2FuZGVyQHB1cmVzdG9yYWdlLmNvbT47IGlvLQ0KPiB1cmluZ0B2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW1BB
VENIXSBpb191cmluZzogdXNlIGxvY2tsZXNzX2NxIGZsYWcgaW4gaW9fcmVxX2NvbXBsZXRlX3Bv
c3QoKQ0KPiANCj4gaW9fdXJpbmdfY3JlYXRlKCkgY29tcHV0ZXMgY3R4LT5sb2NrbGVzc19jcSBh
czoNCj4gY3R4LT50YXNrX2NvbXBsZXRlIHx8IChjdHgtPmZsYWdzICYgSU9SSU5HX1NFVFVQX0lP
UE9MTCkNCj4gDQo+IFNvIHVzZSBpdCB0byBzaW1wbGlmeSB0aGF0IGV4cHJlc3Npb24gaW4gaW9f
cmVxX2NvbXBsZXRlX3Bvc3QoKS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENhbGViIFNhbmRlciBN
YXRlb3MgPGNzYW5kZXJAcHVyZXN0b3JhZ2UuY29tPg0KPiAtLS0NCj4gIGlvX3VyaW5nL2lvX3Vy
aW5nLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRp
b24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9pb191cmluZy9pb191cmluZy5jIGIvaW9fdXJpbmcv
aW9fdXJpbmcuYyBpbmRleA0KPiBlYzk4YTBlYzZmMzQuLjBiZDk0NTk5ZGY4MSAxMDA2NDQNCj4g
LS0tIGEvaW9fdXJpbmcvaW9fdXJpbmcuYw0KPiArKysgYi9pb191cmluZy9pb191cmluZy5jDQo+
IEBAIC04OTcsMTEgKzg5NywxMSBAQCBzdGF0aWMgdm9pZCBpb19yZXFfY29tcGxldGVfcG9zdChz
dHJ1Y3QgaW9fa2lvY2INCj4gKnJlcSwgdW5zaWduZWQgaXNzdWVfZmxhZ3MpDQo+IA0KPiAgCS8q
DQo+ICAJICogSGFuZGxlIHNwZWNpYWwgQ1Egc3luYyBjYXNlcyB2aWEgdGFza193b3JrLiBERUZF
Ul9UQVNLUlVODQo+IHJlcXVpcmVzDQo+ICAJICogdGhlIHN1Ym1pdHRlciB0YXNrIGNvbnRleHQs
IElPUE9MTCBwcm90ZWN0cyB3aXRoIHVyaW5nX2xvY2suDQo+ICAJICovDQo+IC0JaWYgKGN0eC0+
dGFza19jb21wbGV0ZSB8fCAoY3R4LT5mbGFncyAmIElPUklOR19TRVRVUF9JT1BPTEwpKSB7DQo+
ICsJaWYgKGN0eC0+bG9ja2xlc3NfY3EpIHsNCg0KV2hlbiB0aGUgY29tcGxldGlvbl9sb2NrIGlz
IG5vdCBoZWxkLCB0aGUgcmVxIGNvbXBsZXRpb24gZXZlbnQgbmVlZHMgdG8gYmUgaGFuZGxlZCB0
aHJvdWdoDQp0aGUgdGFza193b3JrIG1lY2hhbmlzbSwgc28gdGhpcyBtb2RpZmljYXRpb24gbWFr
ZXMgc2Vuc2UgdG8gbWUuDQoNCj4gIAkJcmVxLT5pb190YXNrX3dvcmsuZnVuYyA9IGlvX3JlcV90
YXNrX2NvbXBsZXRlOw0KPiAgCQlpb19yZXFfdGFza193b3JrX2FkZChyZXEpOw0KPiAgCQlyZXR1
cm47DQo+ICAJfQ0KPiANCj4gLS0NCj4gMi40NS4yDQo+IA0KDQpSZXZpZXdlZC1ieTogTGkgWmV0
YW8gPGxpemV0YW8xQGh1YXdlaS5jb20+DQoNCi0tLQ0KTGkgWmV0YW8NCg==

