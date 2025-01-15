Return-Path: <io-uring+bounces-5874-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8C0DA12474
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 14:10:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 712B33A438B
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 13:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53ADA2459AA;
	Wed, 15 Jan 2025 13:10:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8199B2459A3
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 13:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736946615; cv=none; b=a8N7YqChJ4SoAUKfH7Ey1Y0oNlJdLa7F7Z/5fgrb/Oke33TlZfUYbiJ42AiH6SoxIXcKFs7Qo8mOJohc98YGzhUoFWFpG3GpLlPmyro0o7xl46fImWEf3y+BM+W00C6spRBn3L8mrCP45FUJ/mIOqrq35QZX1fdjWFYXsl0m4cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736946615; c=relaxed/simple;
	bh=qp+FUUG0qWx5N5JB2aJeyNxnALeDYwotFojNI8zEUEc=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BT4PbXlYbdHkz3MUXpWXQfAmVfFc0i6WwUimU0xTN41fsFxZ2js3SIA3Ci+7Luzzbx4RjRd59APNhZh5pAWMST/y/j9aveqKUq0zc0wMVpHpOhrGCQGW1K9OlDkTxJrS+Z4yKwh1AbYhUVE4MglNm4GaNfxqZ2LqL+AbB3u/9ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YY5qr6p15z11SRM;
	Wed, 15 Jan 2025 21:07:04 +0800 (CST)
Received: from kwepemd100011.china.huawei.com (unknown [7.221.188.204])
	by mail.maildlp.com (Postfix) with ESMTPS id 6C1781402C7;
	Wed, 15 Jan 2025 21:10:07 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100011.china.huawei.com (7.221.188.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 15 Jan 2025 21:10:07 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Wed, 15 Jan 2025 21:10:07 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: [PATCH] test/defer: fix deadlock when io_uring_submit fail
Thread-Topic: [PATCH] test/defer: fix deadlock when io_uring_submit fail
Thread-Index: AdtnTle0AdCKvQv4QCG1RPRIudIQww==
Date: Wed, 15 Jan 2025 13:10:06 +0000
Message-ID: <77ab74b3fdff491db2a5596b1edc86b6@huawei.com>
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

V2hpbGUgcGVyZm9ybWluZyBmYXVsdCBpbmplY3Rpb24gdGVzdGluZywgYSBidWcgcmVwb3J0IHdh
cyB0cmlnZ2VyZWQ6DQoNCiAgRkFVTFRfSU5KRUNUSU9OOiBmb3JjaW5nIGEgZmFpbHVyZS4NCiAg
bmFtZSBmYWlsX3VzZXJjb3B5LCBpbnRlcnZhbCAxLCBwcm9iYWJpbGl0eSAwLCBzcGFjZSAwLCB0
aW1lcyAwDQogIENQVTogMTIgVUlEOiAwIFBJRDogMTg3OTUgQ29tbTogZGVmZXIudCBUYWludGVk
OiBHICAgICAgICAgICBPICAgICAgIDYuMTMuMC1yYzYtZ2YyYTBhMzdiMTc0YiAjMTcNCiAgVGFp
bnRlZDogW09dPU9PVF9NT0RVTEUNCiAgSGFyZHdhcmUgbmFtZTogbGludXgsZHVtbXktdmlydCAo
RFQpDQogIENhbGwgdHJhY2U6DQogICBzaG93X3N0YWNrKzB4MjAvMHgzOCAoQykNCiAgIGR1bXBf
c3RhY2tfbHZsKzB4NzgvMHg5MA0KICAgZHVtcF9zdGFjaysweDFjLzB4MjgNCiAgIHNob3VsZF9m
YWlsX2V4KzB4NTQ0LzB4NjQ4DQogICBzaG91bGRfZmFpbCsweDE0LzB4MjANCiAgIHNob3VsZF9m
YWlsX3VzZXJjb3B5KzB4MWMvMHgyOA0KICAgZ2V0X3RpbWVzcGVjNjQrMHg3Yy8weDI1OA0KICAg
X19pb190aW1lb3V0X3ByZXArMHgzMWMvMHg3OTgNCiAgIGlvX2xpbmtfdGltZW91dF9wcmVwKzB4
MWMvMHgzMA0KICAgaW9fc3VibWl0X3NxZXMrMHg1OWMvMHgxZDUwDQogICBfX2FybTY0X3N5c19p
b191cmluZ19lbnRlcisweDhkYy8weGZhMA0KICAgaW52b2tlX3N5c2NhbGwrMHg3NC8weDI3MA0K
ICAgZWwwX3N2Y19jb21tb24uY29uc3Rwcm9wLjArMHhiNC8weDI0MA0KICAgZG9fZWwwX3N2Yysw
eDQ4LzB4NjgNCiAgIGVsMF9zdmMrMHgzOC8weDc4DQogICBlbDB0XzY0X3N5bmNfaGFuZGxlcisw
eGM4LzB4ZDANCiAgIGVsMHRfNjRfc3luYysweDE5OC8weDFhMA0KDQpUaGUgZGVhZGxvY2sgc3Rh
Y2sgaXMgYXMgZm9sbG93czoNCg0KICBpb19jcXJpbmdfd2FpdCsweGE2NC8weDEwNjANCiAgX19h
cm02NF9zeXNfaW9fdXJpbmdfZW50ZXIrMHg0NmMvMHhmYTANCiAgaW52b2tlX3N5c2NhbGwrMHg3
NC8weDI3MA0KICBlbDBfc3ZjX2NvbW1vbi5jb25zdHByb3AuMCsweGI0LzB4MjQwDQogIGRvX2Vs
MF9zdmMrMHg0OC8weDY4DQogIGVsMF9zdmMrMHgzOC8weDc4DQogIGVsMHRfNjRfc3luY19oYW5k
bGVyKzB4YzgvMHhkMA0KICBlbDB0XzY0X3N5bmMrMHgxOTgvMHgxYTANCg0KVGhpcyBpcyBiZWNh
dXNlIGFmdGVyIHRoZSBzdWJtaXNzaW9uIGZhaWxzLCB0aGUgZGVmZXIudCB0ZXN0Y2FzZSBpcyBz
dGlsbCB3YWl0aW5nIHRvIHN1Ym1pdCB0aGUgZmFpbGVkIHJlcXVlc3QsIHJlc3VsdGluZyBpbiBh
biBldmVudHVhbCBkZWFkbG9jay4NClNvbHZlIHRoZSBwcm9ibGVtIGJ5IHRlbGxpbmcgd2FpdF9j
cWVzIHRoZSBudW1iZXIgb2YgcmVxdWVzdHMgdG8gd2FpdCBmb3IuDQoNCkZpeGVzOiA2ZjZkZTQ3
ZDYxMjYgKCJ0ZXN0L2RlZmVyOiBUZXN0IGRlZmVycmluZyB3aXRoIGRyYWluIGFuZCBsaW5rcyIp
DQpTaWduZWQtb2ZmLWJ5OiBMaSBaZXRhbyA8bGl6ZXRhbzFAaHVhd2VpLmNvbT4NCi0tLQ0KIHRl
c3QvZGVmZXIuYyB8IDEyICsrKysrKy0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlv
bnMoKyksIDYgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS90ZXN0L2RlZmVyLmMgYi90ZXN0
L2RlZmVyLmMgaW5kZXggYjA3NzBlZi4uMjQ0N2JlMCAxMDA2NDQNCi0tLSBhL3Rlc3QvZGVmZXIu
Yw0KKysrIGIvdGVzdC9kZWZlci5jDQpAQCAtNjksMTIgKzY5LDEyIEBAIGVycjoNCiAJcmV0dXJu
IDE7DQogfQ0KIA0KLXN0YXRpYyBpbnQgd2FpdF9jcWVzKHN0cnVjdCB0ZXN0X2NvbnRleHQgKmN0
eCkNCitzdGF0aWMgaW50IHdhaXRfY3FlcyhzdHJ1Y3QgdGVzdF9jb250ZXh0ICpjdHgsIGludCBu
dW0pDQogew0KIAlpbnQgcmV0LCBpOw0KIAlzdHJ1Y3QgaW9fdXJpbmdfY3FlICpjcWU7DQogDQot
CWZvciAoaSA9IDA7IGkgPCBjdHgtPm5yOyBpKyspIHsNCisJZm9yIChpID0gMDsgaSA8IG51bTsg
aSsrKSB7DQogCQlyZXQgPSBpb191cmluZ193YWl0X2NxZShjdHgtPnJpbmcsICZjcWUpOw0KIA0K
IAkJaWYgKHJldCA8IDApIHsNCkBAIC0xMDUsNyArMTA1LDcgQEAgc3RhdGljIGludCB0ZXN0X2Nh
bmNlbGVkX3VzZXJkYXRhKHN0cnVjdCBpb191cmluZyAqcmluZykNCiAJCWdvdG8gZXJyOw0KIAl9
DQogDQotCWlmICh3YWl0X2NxZXMoJmN0eCkpDQorCWlmICh3YWl0X2NxZXMoJmN0eCwgcmV0KSkN
CiAJCWdvdG8gZXJyOw0KIA0KIAlmb3IgKGkgPSAwOyBpIDwgbnI7IGkrKykgew0KQEAgLTEzOSw3
ICsxMzksNyBAQCBzdGF0aWMgaW50IHRlc3RfdGhyZWFkX2xpbmtfY2FuY2VsKHN0cnVjdCBpb191
cmluZyAqcmluZykNCiAJCWdvdG8gZXJyOw0KIAl9DQogDQotCWlmICh3YWl0X2NxZXMoJmN0eCkp
DQorCWlmICh3YWl0X2NxZXMoJmN0eCwgcmV0KSkNCiAJCWdvdG8gZXJyOw0KIA0KIAlmb3IgKGkg
PSAwOyBpIDwgbnI7IGkrKykgew0KQEAgLTE4NSw3ICsxODUsNyBAQCBzdGF0aWMgaW50IHRlc3Rf
ZHJhaW5fd2l0aF9saW5rZWRfdGltZW91dChzdHJ1Y3QgaW9fdXJpbmcgKnJpbmcpDQogCQlnb3Rv
IGVycjsNCiAJfQ0KIA0KLQlpZiAod2FpdF9jcWVzKCZjdHgpKQ0KKwlpZiAod2FpdF9jcWVzKCZj
dHgsIHJldCkpDQogCQlnb3RvIGVycjsNCiANCiAJZnJlZV9jb250ZXh0KCZjdHgpOw0KQEAgLTIx
Miw3ICsyMTIsNyBAQCBzdGF0aWMgaW50IHJ1bl9kcmFpbmVkKHN0cnVjdCBpb191cmluZyAqcmlu
ZywgaW50IG5yKQ0KIAkJZ290byBlcnI7DQogCX0NCiANCi0JaWYgKHdhaXRfY3FlcygmY3R4KSkN
CisJaWYgKHdhaXRfY3FlcygmY3R4LCByZXQpKQ0KIAkJZ290byBlcnI7DQogDQogCWZyZWVfY29u
dGV4dCgmY3R4KTsNCi0tDQoyLjMzLjANCg==

