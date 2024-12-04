Return-Path: <io-uring+bounces-5196-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E56F29E30F4
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 02:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBC061671DC
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 01:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 823C6567D;
	Wed,  4 Dec 2024 01:55:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1345227
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 01:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733277304; cv=none; b=g3u0fUt9+AT2bJD53oN2HAZkTRz5EEq2pPvlkZ+hmNRoM/lbKqzW8S3Xg0+SbXo1QKkfLuMjmGi+z6mhDYCSaasmcvN99kv9xCsaZVVK9y3N1cx/U34WgAb+3uFYVnxpOoZZjn+h8a7yQjzYxJUGfvFWHYbugmUHYuaaJ4yqv4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733277304; c=relaxed/simple;
	bh=MQv6cVGp1DsBL8UXuU5WJ2UEY9+a/LkNOFqQIAuaAwU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V2BYtIB4eGxq3+9sCOybiBbSvz+l3Jjzx8fOZitK5xzLH8vYVY+wFdwEEP0XvcDm4+Ka3M8H9XpxHdqMBU+8rnAOsKjf2rrJtcgWWzqk2Jf/8K8JC7gLzP6Zwm4O774bTQxOp3LjGNN/K+16SCHxGgxFV4Yb957RG19sLMMmYvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Y30s63g8zz2GcLm;
	Wed,  4 Dec 2024 09:52:42 +0800 (CST)
Received: from kwepemd100010.china.huawei.com (unknown [7.221.188.107])
	by mail.maildlp.com (Postfix) with ESMTPS id DB4571A0188;
	Wed,  4 Dec 2024 09:54:58 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100010.china.huawei.com (7.221.188.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 4 Dec 2024 09:54:58 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Wed, 4 Dec 2024 09:54:58 +0800
From: lizetao <lizetao1@huawei.com>
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: RE: [PATCH -next] io_uring: add support for fchmod
Thread-Topic: [PATCH -next] io_uring: add support for fchmod
Thread-Index: AdtAFPBlum2L39VhQky8w4+VWsNEYwFOdNGAACgI30A=
Date: Wed, 4 Dec 2024 01:54:58 +0000
Message-ID: <8f309e91581b4c5ca664d4685f1045a3@huawei.com>
References: <ad222c8b35e54627b0244d5ee4d54f0c@huawei.com>
 <283d7be4-27d2-4123-96be-34c9c77c1371@gmail.com>
In-Reply-To: <283d7be4-27d2-4123-96be-34c9c77c1371@gmail.com>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGF2ZWwgQmVndW5r
b3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDMs
IDIwMjQgMTA6NDQgUE0NCj4gVG86IGxpemV0YW8gPGxpemV0YW8xQGh1YXdlaS5jb20+OyBKZW5z
IEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+IENjOiBpby11cmluZ0B2Z2VyLmtlcm5lbC5vcmcN
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCAtbmV4dF0gaW9fdXJpbmc6IGFkZCBzdXBwb3J0IGZvciBm
Y2htb2QNCj4gDQo+IE9uIDExLzI2LzI0IDE1OjA3LCBsaXpldGFvIHdyb3RlOg0KPiA+Pj4+PiBP
biAxMS8xOS8yNCAxOjEyIEFNLCBsaXpldGFvIHdyb3RlOg0KPiA+Pj4+PiBBZGRzIHN1cHBvcnQg
Zm9yIGRvaW5nIGNobW9kIHRocm91Z2ggaW9fdXJpbmcuDQo+IElPUklOR19PUF9GQ0hNT0QNCj4g
Pj4+Pj4gYmVoYXZlcyBsaWtlIGZjaG1vZCgyKSBhbmQgdGFrZXMgdGhlIHNhbWUgYXJndW1lbnRz
Lg0KPiA+Pj4NCj4gPj4+PiBMb29rcyBwcmV0dHkgc3RyYWlnaHQgZm9yd2FyZC4gVGhlIG9ubHkg
ZG93bnNpZGUgaXMgdGhlIGZvcmNlZCB1c2Ugb2YNCj4gUkVRX0ZfRk9SQ0VfQVNZTkMgLSBkaWQg
eW91IGxvb2sgaW50byBob3cgZmVhc2libGUgaXQgd291bGQgYmUgdG8gYWxsb3cNCj4gbm9uLWJs
b2NraW5nIGlzc3VlIG9mIHRoaXM/IFdvdWxkIGltYWdpbmUgdGhlIG1ham9yaXR5IG9mIGZjaG1v
ZCBjYWxscyBlbmQNCj4gdXAgbm90IGJsb2NraW5nIGluIHRoZSBmaXJzdCBwbGFjZS4NCj4gPj4+
DQo+ID4+PiBZZXMsIEkgY29uc2lkZXJlZCBmY2htb2QgdG8gYWxsb3cgYXN5bmNocm9ub3VzIGV4
ZWN1dGlvbiBhbmQgd3JvdGUgYQ0KPiB0ZXN0IGNhc2UgdG8gdGVzdCBpdCwgdGhlIHJlc3VsdHMg
YXJlIGFzIGZvbGxvd3M6DQo+ID4+Pg0KPiANCj4gRllJLCB0aGlzIGVtYWlsIGdvdCBpbnRvIHNw
YW0uDQpTb3JyeSB0byBib3RoZXIgZXZlcnlvbmUsIGJ1dCBJIHdvdWxkIGxpa2UgdG8ga25vdyBp
ZiB0aGVyZSBhcmUgYW55IHBsYW5zIHRvIGltcGxlbWVudA0KYXN5bmNocm9ub3VzIHN5c3RlbSBj
YWxscyB0aHJvdWdoIGlvX3VyaW5nLCBhbmQgd2hpY2ggc3lzdGVtIGNhbGxzIGFyZSBpbiB0aGUg
cGxhbm5pbmcuDQoNCi0tDQpMaSBaZXRhbw0KDQo=

