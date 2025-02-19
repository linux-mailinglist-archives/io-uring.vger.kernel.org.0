Return-Path: <io-uring+bounces-6546-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93F8EA3AF8A
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 03:23:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A9961898A29
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 02:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2AE13D891;
	Wed, 19 Feb 2025 02:20:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF84413665A
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 02:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739931637; cv=none; b=p2oSYe5u7HcR6+OZijN6mxK2Bk0pbJfOTi27mdvEIRZpf6wZ3FrDvLCWHreK4F7GtOr5p2qsQfZAssxi6xn31f3ObZIk+e8gZ10G+JdERqlj6vDMoh37pky1g8Yn71GxmlQGa4a8DBV8Mu/Iv0GPIgeeJix5cfQWvEvuCWWBd6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739931637; c=relaxed/simple;
	bh=101K7QN353npTkyMO8V5oJaZQIz8FYhfGZAGzHFfKCE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NKWQP0CZQPHRBsSTTwHYHczH9XvgIFPZKFC9Qr8oTHs2fX0kbJpajFvTPz3APai1qvlpEPgWkjk6esfpibvzplQOLr3dlZmdwadWscV1azT+aoqUQglVBrgx18R+8YGbsFURawJnwJgQu6AGw34MI8EpaTrDtakxYM3rT8g+UNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4YyKkM73btz1Y1sW;
	Wed, 19 Feb 2025 10:15:55 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id 8F99F1800ED;
	Wed, 19 Feb 2025 10:20:31 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 19 Feb 2025 10:20:31 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Wed, 19 Feb 2025 10:20:31 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>
CC: io-uring <io-uring@vger.kernel.org>
Subject: RE: [PATCH] io_uring: fix spelling error in uapi io_uring.h
Thread-Topic: [PATCH] io_uring: fix spelling error in uapi io_uring.h
Thread-Index: AQHbgl/A/deJF/SqBEuJR78H+pmSyLNN5MiQ
Date: Wed, 19 Feb 2025 02:20:31 +0000
Message-ID: <3d0040e7243c40e8b413abe6d29e04e1@huawei.com>
References: <fd1a291b-e6e5-4ab0-9a2a-b5751b3e4a02@kernel.dk>
In-Reply-To: <fd1a291b-e6e5-4ab0-9a2a-b5751b3e4a02@kernel.dk>
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
b2VAa2VybmVsLmRrPg0KPiBTZW50OiBXZWRuZXNkYXksIEZlYnJ1YXJ5IDE5LCAyMDI1IDc6NDkg
QU0NCj4gVG86IGlvLXVyaW5nIDxpby11cmluZ0B2Z2VyLmtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6
IFtQQVRDSF0gaW9fdXJpbmc6IGZpeCBzcGVsbGluZyBlcnJvciBpbiB1YXBpIGlvX3VyaW5nLmgN
Cj4gDQo+IFRoaXMgaXMgb2J2aW91c2x5IG5vdCB0aGF0IGltcG9ydGFudCwgYnV0IHdoZW4gY2hh
bmdlcyBhcmUgc3luY2VkIGJhY2sgZnJvbQ0KPiB0aGUga2VybmVsIHRvIGxpYnVyaW5nLCB0aGUg
Y29kZXNwZWxsIENJIGVuZHMgdXAgZXJyb3JpbmcgYmVjYXVzZSBvZiB0aGlzDQo+IG1pc3NwZWxs
aW5nLiBMZXQncyBqdXN0IGNvcnJlY3QgaXQgYW5kIGF2b2lkIHRoaXMgYml0aW5nIHVzIGFnYWlu
IG9uIGFuIGltcG9ydC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtl
cm5lbC5kaz4NCj4gDQo+IC0tLQ0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51
eC9pb191cmluZy5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2lvX3VyaW5nLmggaW5kZXgNCj4gZTEx
YzgyNjM4NTI3Li4wNTBmYThlYjJlOGYgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51
eC9pb191cmluZy5oDQo+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9pb191cmluZy5oDQo+IEBA
IC0zODAsNyArMzgwLDcgQEAgZW51bSBpb191cmluZ19vcCB7DQo+ICAgKgkJCQlyZXN1bHQgCXdp
bGwgYmUgdGhlIG51bWJlciBvZiBidWZmZXJzIHNlbmQsDQo+IHdpdGgNCj4gICAqCQkJCXRoZSBz
dGFydGluZyBidWZmZXIgSUQgaW4gY3FlLT5mbGFncyBhcyBwZXINCj4gICAqCQkJCXVzdWFsIGZv
ciBwcm92aWRlZCBidWZmZXIgdXNhZ2UuIFRoZSBidWZmZXJzDQo+IC0gKgkJCQl3aWxsIGJlCWNv
bnRpZ2lvdXMgZnJvbSB0aGUgc3RhcnRpbmcgYnVmZmVyIElELg0KPiArICoJCQkJd2lsbCBiZQlj
b250aWd1b3VzIGZyb20gdGhlIHN0YXJ0aW5nIGJ1ZmZlciBJRC4NCj4gICAqLw0KPiAgI2RlZmlu
ZSBJT1JJTkdfUkVDVlNFTkRfUE9MTF9GSVJTVAkoMVUgPDwgMCkNCj4gICNkZWZpbmUgSU9SSU5H
X1JFQ1ZfTVVMVElTSE9UCQkoMVUgPDwgMSkNCj4gLS0NCj4gSmVucyBBeGJvZQ0KPiANCg0KUmV2
aWV3ZWQtYnk6IExpIFpldGFvIDxsaXpldGFvMUBodWF3ZWkuY29tPg0KDQotLS0NCkxpIFpldGFv
DQoNCg==

