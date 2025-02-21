Return-Path: <io-uring+bounces-6593-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E26DA3EFAD
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 10:12:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B13C17F35B
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 09:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD5C2AE89;
	Fri, 21 Feb 2025 09:11:00 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C7A33EA;
	Fri, 21 Feb 2025 09:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740129059; cv=none; b=t5q16fTiiIiT0zKPQvjhH9MrfXu3lRKErLRE9dCzooERcoPv30RcXIJZSKmCiJRJ6heDZMdRXFs/We3HPOdRs6lf4gyQ7J2tI0i7osfTyHKtf+ORqDr5QvD/M3X9BpfXSs/joQ1BeDyDbwbn9bS1Yj+L4N41mnLM9UaX8jK2kLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740129059; c=relaxed/simple;
	bh=AHLxsYdK+o7CJ2XtDFl3oFh8sKefJVTye7o6XxDml1U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zdi/uF2NWEGWRtMcgZVd6AEBSFQnAyJNE75T5gCvmWdr7ZOkeasD9o3lLWgtgPW3isjRyYQ3RFnbfc81NiiB1FD3JijO/RolV3aMXpg5A55NXxetPxZyngx6IRF9zW8YlxEAw9ov74ZZlrEvpiIbQye3gv25OCylin1DZpx6v9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Yzkkw1H9mz1GDfR;
	Fri, 21 Feb 2025 17:06:16 +0800 (CST)
Received: from kwepemd200010.china.huawei.com (unknown [7.221.188.124])
	by mail.maildlp.com (Postfix) with ESMTPS id B33721402E2;
	Fri, 21 Feb 2025 17:10:54 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200010.china.huawei.com (7.221.188.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 21 Feb 2025 17:10:54 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Fri, 21 Feb 2025 17:10:54 +0800
From: lizetao <lizetao1@huawei.com>
To: Bui Quang Minh <minhquangbui99@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
Subject: RE: [PATCH] io_uring: add missing IORING_MAP_OFF_ZCRX_REGION in
 io_uring_mmap
Thread-Topic: [PATCH] io_uring: add missing IORING_MAP_OFF_ZCRX_REGION in
 io_uring_mmap
Thread-Index: AQHbhD7+hhZgMRil3kSQZU4uDzijo7NRd6Ww
Date: Fri, 21 Feb 2025 09:10:54 +0000
Message-ID: <590cff7ccda34b028706b9288f8928d3@huawei.com>
References: <20250221085933.26034-1-minhquangbui99@gmail.com>
In-Reply-To: <20250221085933.26034-1-minhquangbui99@gmail.com>
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
bmggPG1pbmhxdWFuZ2J1aTk5QGdtYWlsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAy
MSwgMjAyNSA1OjAwIFBNDQo+IFRvOiBpby11cmluZ0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IEpl
bnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz47IFBhdmVsIEJlZ3Vua292DQo+IDxhc21sLnNpbGVu
Y2VAZ21haWwuY29tPjsgRGF2aWQgV2VpIDxkd0BkYXZpZHdlaS51az47IGxpbnV4LQ0KPiBrZXJu
ZWxAdmdlci5rZXJuZWwub3JnOyBCdWkgUXVhbmcgTWluaCA8bWluaHF1YW5nYnVpOTlAZ21haWwu
Y29tPg0KPiBTdWJqZWN0OiBbUEFUQ0hdIGlvX3VyaW5nOiBhZGQgbWlzc2luZyBJT1JJTkdfTUFQ
X09GRl9aQ1JYX1JFR0lPTiBpbg0KPiBpb191cmluZ19tbWFwDQo+IA0KPiBBbGxvdyB1c2VyIHRv
IG1tYXAgdGhlIGtlcm5lbCBhbGxvY2F0ZWQgemVyb2NvcHktcnggcmVmaWxsIHF1ZXVlLg0KPiAN
Cg0KTWF5YmUgZml4ZWQtdGFnIHNob3VsZCBiZSBhZGRlZCBoZXJlLg0KDQpPdGhlciB0aGFuIHRo
YXQsIGl0IGxvb2tzIGdvb2QgdG8gbWUuDQpSZXZpZXdlZC1ieTogTGkgWmV0YW8gPGxpemV0YW8x
QGh1YXdlaS5jb20+DQoNCi0tLQ0KTGkgWmV0YW8NCg==

