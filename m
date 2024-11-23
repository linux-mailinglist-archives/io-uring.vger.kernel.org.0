Return-Path: <io-uring+bounces-5003-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B86F09D68FF
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 13:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E422281D6F
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 12:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD6217A583;
	Sat, 23 Nov 2024 12:23:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD441442F2
	for <io-uring@vger.kernel.org>; Sat, 23 Nov 2024 12:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732364631; cv=none; b=DiPeRT83NUSDOkQwfRfi1xaTDCFViV66rptAS7tyGaBZyPQxBv91MjzyLr6uyBeLW2/eC9eXbu8XNyonLLRbpRfIKc9ZuOPtQC8FMZ5SqXSb0hTyL+BhW50GzgMFFTnynvFpg7SKvD/fV/Q5bbbMShJfchKVDuPnBeMVoBZvomg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732364631; c=relaxed/simple;
	bh=VG6TBjrs+7YEdsPnkd/7mMuayZ6gu84YB2KEnSmW3g0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XcMk0ZY/qKfAmD4AgzUvbO/VjhQsE2GwYf4+PNZyzxCnoTA2JvNkXzglW39RvxVQw7NB1NJThGnEvl6mB9CIGv2QRb2pf3ypLxqfUtnav9DpC3BSOPYAv3JYuGCBCDJZa1eCwPHxDmx5WgxJcwFFlekAvea4lr7UxatuR7uql+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XwWKw1Djcz1jy8Z;
	Sat, 23 Nov 2024 20:21:40 +0800 (CST)
Received: from kwepemd200010.china.huawei.com (unknown [7.221.188.124])
	by mail.maildlp.com (Postfix) with ESMTPS id DD8B41A0188;
	Sat, 23 Nov 2024 20:23:42 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd200010.china.huawei.com (7.221.188.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 23 Nov 2024 20:23:42 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Sat, 23 Nov 2024 20:23:39 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>, lizetao
	<lizetao1@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggLW5leHRdIGlvX3VyaW5nOiBhZGQgc3VwcG9ydCBm?=
 =?utf-8?Q?or_fchmod?=
Thread-Topic: [PATCH -next] io_uring: add support for fchmod
Thread-Index: Ads6Wn5Us6O6He9UT4KWT2JV2JtSNwAwVosAAKFZHtA=
Date: Sat, 23 Nov 2024 12:23:39 +0000
Message-ID: <8609cb5ca3bf4d2c8018ec2339f36430@huawei.com>
References: <e291085644e14b3eb4d1c3995098bf4e@huawei.com>
 <2fe3005b-279d-489d-823f-731c6a52e5b1@kernel.dk>
In-Reply-To: <2fe3005b-279d-489d-823f-731c6a52e5b1@kernel.dk>
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

SGkNCg0KPj5PbiAxMS8xOS8yNCAxOjEyIEFNLCBsaXpldGFvIHdyb3RlOg0KPj4gQWRkcyBzdXBw
b3J0IGZvciBkb2luZyBjaG1vZCB0aHJvdWdoIGlvX3VyaW5nLiBJT1JJTkdfT1BfRkNITU9EIA0K
Pj5iZWhhdmVzIGxpa2UgZmNobW9kKDIpIGFuZCB0YWtlcyB0aGUgc2FtZSBhcmd1bWVudHMuDQoN
Cj4gTG9va3MgcHJldHR5IHN0cmFpZ2h0IGZvcndhcmQuIFRoZSBvbmx5IGRvd25zaWRlIGlzIHRo
ZSBmb3JjZWQgdXNlIG9mIFJFUV9GX0ZPUkNFX0FTWU5DIC0gZGlkIHlvdSBsb29rIGludG8gaG93
IGZlYXNpYmxlIGl0IHdvdWxkIGJlIHRvIGFsbG93IG5vbi1ibG9ja2luZyBpc3N1ZSBvZiB0aGlz
PyBXb3VsZCBpbWFnaW5lIHRoZSBtYWpvcml0eSBvZiBmY2htb2QgY2FsbHMgZW5kIHVwIG5vdCBi
bG9ja2luZyBpbiB0aGUgZmlyc3QgcGxhY2UuDQoNClllcywgSSBjb25zaWRlcmVkIGZjaG1vZCB0
byBhbGxvdyBhc3luY2hyb25vdXMgZXhlY3V0aW9uIGFuZCB3cm90ZSBhIHRlc3QgY2FzZSB0byB0
ZXN0IGl0LCB0aGUgcmVzdWx0cyBhcmUgYXMgZm9sbG93czoNCg0KZmNobW9kOg0KcmVhbAkwbTEu
NDEzcw0KdXNlcgkwbTAuMjUzcw0Kc3lzCTBtMS4wNzlzDQoNCmlvX3VyaW5nICsgZmNobW9kOg0K
cmVhbAkwbTEuMjY4cw0KdXNlcgkwbTAuMDE1cw0Kc3lzCTBtNS43MzlzDQoNClRoZXJlIGlzIGFi
b3V0IGEgMTAlIGltcHJvdmVtZW50Lg0KDQo+IC0tDQo+SmVucyBBeGJvZQ0KDQotLQ0KTGkgWmV0
YW8NCg==

