Return-Path: <io-uring+bounces-5752-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 052D5A061C2
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 17:24:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91DB7188258C
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 16:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185E119F489;
	Wed,  8 Jan 2025 16:24:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F77F1FE46F;
	Wed,  8 Jan 2025 16:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736353472; cv=none; b=kjadaSWd46+WEwCAwP+0+q6bYEyWsAgAWZm3IdYsqI+JDoaBi17QlbbOB4F/lVX5HF5sd5nQJk0JpdbYSbgn5fGh46zCCAdTEFklchAWrVKk370tkIonemxiMULRE1NQs5Gj326O2QD5CaWm2aX7keRWxJuzmqRQ9gJBMwj1U/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736353472; c=relaxed/simple;
	bh=0izXUeylTPPB6pOFED07FfZTJc4xNq6BsMjvdQXVAlY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tGTqiedENB+pt4I1fXo2oH5kqDsXaTQexGSdZnDa3NEu6SiTfdUCff7w2GisjSXvFw/f7S6BynoCrNbtZd9H3mUGuOGxkPjrAWUzsTDTBRcIhzfhwx/TTZY6SV4lwDT0hTlg69BUTH8jwmR5Y7ZZsuISxtX6HGzfK15DGRmGCsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YStWn6RqXz1JHGN;
	Thu,  9 Jan 2025 00:23:33 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (unknown [7.221.188.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 779C0140159;
	Thu,  9 Jan 2025 00:24:19 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd500012.china.huawei.com (7.221.188.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 9 Jan 2025 00:24:19 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Thu, 9 Jan 2025 00:24:19 +0800
From: lizetao <lizetao1@huawei.com>
To: Bui Quang Minh <minhquangbui99@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"syzbot+5988142e8a69a67b1418@syzkaller.appspotmail.com"
	<syzbot+5988142e8a69a67b1418@syzkaller.appspotmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] io_uring/sqpoll: annotate data race for access in debug
 check
Thread-Topic: [PATCH] io_uring/sqpoll: annotate data race for access in debug
 check
Thread-Index: AQHbYd+rla2mhaKv1kenQH6NEOAxvrMNDeaA
Date: Wed, 8 Jan 2025 16:24:19 +0000
Message-ID: <71f1cec18e94459995dfb4bed9a79939@huawei.com>
References: <20250108151052.7944-1-minhquangbui99@gmail.com>
In-Reply-To: <20250108151052.7944-1-minhquangbui99@gmail.com>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQnVpIFF1YW5nIE1p
bmggPG1pbmhxdWFuZ2J1aTk5QGdtYWlsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBKYW51YXJ5
IDgsIDIwMjUgMTE6MTEgUE0NCj4gVG86IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g
Q2M6IEJ1aSBRdWFuZyBNaW5oIDxtaW5ocXVhbmdidWk5OUBnbWFpbC5jb20+OyBKZW5zIEF4Ym9l
DQo+IDxheGJvZUBrZXJuZWwuZGs+OyBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdtYWls
LmNvbT47IGlvLQ0KPiB1cmluZ0B2Z2VyLmtlcm5lbC5vcmc7DQo+IHN5emJvdCs1OTg4MTQyZThh
NjlhNjdiMTQxOEBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tDQo+IFN1YmplY3Q6IFtQQVRDSF0g
aW9fdXJpbmcvc3Fwb2xsOiBhbm5vdGF0ZSBkYXRhIHJhY2UgZm9yIGFjY2VzcyBpbiBkZWJ1ZyBj
aGVjaw0KPiANCj4gc3FkLT50aHJlYWQgbXVzdCBvbmx5IGJlIGFjY2VzcyB3aGlsZSBob2xkaW5n
IHNxZC0+bG9jay4gSW4NCj4gaW9fc3FfdGhyZWFkX3N0b3AsIHRoZSBzcWQtPnRocmVhZCBhY2Nl
c3MgdG8gd2FrZSB1cCB0aGUgc3EgdGhyZWFkIGlzIHBsYWNlZA0KPiB3aGlsZSBob2xkaW5nIHNx
ZC0+bG9jaywgYnV0IHRoZSBhY2Nlc3MgaW4gZGVidWcgY2hlY2sgaXMgbm90LiBBcyB0aGlzIGFj
Y2VzcyBpZg0KPiBmb3IgZGVidWcgY2hlY2sgb25seSwgd2UgY2FuIHNhZmVseSBpZ25vcmUgdGhl
IGRhdGEgcmFjZSBoZXJlLiBTbyB3ZSBhbm5vdGF0ZQ0KPiB0aGlzIGFjY2VzcyB3aXRoIGRhdGFf
cmFjZSB0byBzaWxlbmNlIEtDU0FOLg0KPiANCj4gUmVwb3J0ZWQtYnk6IHN5emJvdCs1OTg4MTQy
ZThhNjlhNjdiMTQxOEBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tDQo+IFNpZ25lZC1vZmYtYnk6
IEJ1aSBRdWFuZyBNaW5oIDxtaW5ocXVhbmdidWk5OUBnbWFpbC5jb20+DQo+IC0tLQ0KPiAgaW9f
dXJpbmcvc3Fwb2xsLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9pb191cmluZy9zcXBvbGwuYyBiL2lv
X3VyaW5nL3NxcG9sbC5jIGluZGV4DQo+IDllNWJkNzlmZDJiNS4uMjA4OGM1NmRiYWEwIDEwMDY0
NA0KPiAtLS0gYS9pb191cmluZy9zcXBvbGwuYw0KPiArKysgYi9pb191cmluZy9zcXBvbGwuYw0K
PiBAQCAtNTcsNyArNTcsNyBAQCB2b2lkIGlvX3NxX3RocmVhZF9wYXJrKHN0cnVjdCBpb19zcV9k
YXRhICpzcWQpDQo+IA0KPiAgdm9pZCBpb19zcV90aHJlYWRfc3RvcChzdHJ1Y3QgaW9fc3FfZGF0
YSAqc3FkKSAgew0KPiAtCVdBUk5fT05fT05DRShzcWQtPnRocmVhZCA9PSBjdXJyZW50KTsNCj4g
KwlXQVJOX09OX09OQ0UoZGF0YV9yYWNlKHNxZC0+dGhyZWFkKSA9PSBjdXJyZW50KTsNCj4gIAlX
QVJOX09OX09OQ0UodGVzdF9iaXQoSU9fU1FfVEhSRUFEX1NIT1VMRF9TVE9QLCAmc3FkLQ0KPiA+
c3RhdGUpKTsNCj4gDQo+ICAJc2V0X2JpdChJT19TUV9USFJFQURfU0hPVUxEX1NUT1AsICZzcWQt
PnN0YXRlKTsNCj4gLS0NCj4gMi40My4wDQo+IA0KDQpUaGUgbW9kaWZpY2F0aW9uIG9mIHRoaXMg
cGF0Y2ggaXRzZWxmIGlzIGZpbmUsIGJ1dCB0aGVyZSBhcmUgdHdvIG90aGVyIHRoaW5ncyBJIG5l
ZWQgdG8gY29uZmlybS4NCjHjgIFEb2VzIHRoZSBpb191cmluZ19jYW5jZWxfZ2VuZXJpYygpIHJl
cXVpcmUgdGhlIHNhbWUgbW9kaWZpY2F0aW9uPw0KMuOAgUl0IGlzIG5vdCBob2xkaW5nIHNxZC0+
bG9jayBpbiBpb19yZXFfbm9ybWFsX3dvcmtfYWRkKCksIGlzIGl0IHNhZmU/DQoNClRoYW5rcy4N
ClJldmlld2VkLWJ5OiBMaSBaZXRhbzxsaXpldGFvMUBodWF3ZWkuY29tPg0KDQotLS0NCkxpIFpl
dGFvDQo=

