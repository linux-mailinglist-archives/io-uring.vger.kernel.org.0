Return-Path: <io-uring+bounces-5183-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E199E1D08
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 14:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 105941647D4
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8CF21EC016;
	Tue,  3 Dec 2024 13:04:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9795C1EC018
	for <io-uring@vger.kernel.org>; Tue,  3 Dec 2024 13:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733231073; cv=none; b=MyxGuylELeI+DcinelNJFLIY6gwf03SLMgXpCtGd9tmUxPoHrtkD7EkecwEL5N1N9H97Q8i6CDazHdEEuOJU8V3SB8wkRJk7HCjPrF7W+wJ8HD4148fMLnx9O8LAKjGhg28fyX/ri/DGLaKUlGqr+GYOZiWWJ8S+ye1O/71l9y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733231073; c=relaxed/simple;
	bh=q6zgkmhZARI7bTRUuj7VBYdeARUhAMCELXlvX0QL4G0=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Tku0XXqTCIr260uQr6d6JEiiHlkBhdu4CabRZ9wKIch8SRl1wyhtYvblzVsGDaqLL3aXQTUhzhpYw2XktNo2WEyWYmjp4EU0VC3hZS8P2Yf1bSSLLyNx4hJAaUlHwWDZDaf98kgqtwGRf1Y/U2RHJ0jzpi1PgcZnBd7tKIJkNYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y2gm42KRNz1k0KY;
	Tue,  3 Dec 2024 21:02:12 +0800 (CST)
Received: from kwepemd100011.china.huawei.com (unknown [7.221.188.204])
	by mail.maildlp.com (Postfix) with ESMTPS id CCA6D1A016C;
	Tue,  3 Dec 2024 21:04:27 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100011.china.huawei.com (7.221.188.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 3 Dec 2024 21:04:27 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Tue, 3 Dec 2024 21:04:27 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>, "masahiroy@kernel.org"
	<masahiroy@kernel.org>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, Pavel Begunkov
	<asml.silence@gmail.com>
Subject: CONFIG_IO_URING can be enabled although it is not visible
Thread-Topic: CONFIG_IO_URING can be enabled although it is not visible
Thread-Index: AdtFg9eeRdhpR7aoTye8SqZtsvQbkA==
Date: Tue, 3 Dec 2024 13:04:27 +0000
Message-ID: <5b03eb679ae74070b25510190549bdb9@huawei.com>
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

SGksDQoNCldoZW4gSSBjaG9zZSB0byBlbmFibGUgQ09ORklHX0lPX1VSSU5HLCBJIGZvdW5kIHRo
YXQgQ09ORklHX0lPX1VSSU5HIGNhbiBhbHNvIGJlIGVuYWJsZWQgd2hlbg0KQ09ORklHX0VYUEVS
VCBpcyBuLiBJdCBzZWVtcyB0aGF0IG90aGVyIG1hY3JvcyBhcmUgaW4gYSBzaW1pbGFyIHNpdHVh
dGlvbiwgc28gaXMgdGhpcyByZWFzb25hYmxlPw0KDQpTeW1ib2w6IElPX1VSSU5HIFs9eV0gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANClR5cGUgIDog
Ym9vbCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIA0KRGVmaW5lZCBhdCBpbml0L0tjb25maWc6MTcyNiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgDQogIFByb21wdDogRW5hYmxlIElPIHVyaW5nIHN1cHBv
cnQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgVmlzaWJsZSBpZjog
RVhQRVJUIFs9bl0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IA0KICBMb2NhdGlvbjogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgDQogICAgLT4gR2VuZXJhbCBzZXR1cCAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCigxKSAgIC0+IENvbmZpZ3VyZSBz
dGFuZGFyZCBrZXJuZWwgZmVhdHVyZXMgKGV4cGVydCB1c2VycykgKEVYUEVSVCBbPW5dKQ0KICAg
ICAgICAtPiBFbmFibGUgSU8gdXJpbmcgc3VwcG9ydCAoSU9fVVJJTkcgWz15XSkgICAgICAgICAg
ICAgICAgICAgICAgDQpTZWxlY3RzOiBJT19XUSBbPW5dICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICANClNlbGVjdGVkIGJ5IFtuXTogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAtIEJMS19E
RVZfVUJMSyBbPW5dICYmIEJMS19ERVYgWz15XSAgICAgICAgICAgDQoNCi0tDQpMaSBaZXRhbyAg
ICAgICAgICAgICAgICAgICAgICAgIA0K

