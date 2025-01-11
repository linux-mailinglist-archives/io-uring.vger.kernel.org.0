Return-Path: <io-uring+bounces-5824-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C7ABA0A40A
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 15:07:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E89016917D
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 14:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C45AB661;
	Sat, 11 Jan 2025 14:07:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14C624B22A
	for <io-uring@vger.kernel.org>; Sat, 11 Jan 2025 14:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736604460; cv=none; b=n3DpEIQvpvSNpH/5eaSxp9aY9fxagQdy2Fuq1fCv+wv7HyNmR7Vd7DLRNibWRAxPQsG+HmRp1Qft4YDhsPVW4+2MCNJhd2gd/UNYssUaDxR24/ASwxM1onREfXOJAlGzg+jvG4DVS7H0hAnkOnY7ZVYFfQecJF7zS/OR2yVcd4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736604460; c=relaxed/simple;
	bh=4MHptBOtsrUNsXVAG38TVuBhiWFl2dLntIy4EOGWA1s=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qemE1k9XH5zGQKWge7oZTgr6qWJkHQBTFxt9ol5HDu8ljmf0s5cVCvLdEZVbhTpdgMRgy7CgcM37+FEXsJm5j1lLzVv6q9uilyptPvM5SUzErFScm4T77u0FFp23dpVIz/ux4FDHqv7RecRvGizAtkxDT7/O5+HhPQBw6eikVf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YVgLX5mg0z1JHQv;
	Sat, 11 Jan 2025 22:06:44 +0800 (CST)
Received: from kwepemd100012.china.huawei.com (unknown [7.221.188.214])
	by mail.maildlp.com (Postfix) with ESMTPS id 80CA01402CA;
	Sat, 11 Jan 2025 22:07:33 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100012.china.huawei.com (7.221.188.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 11 Jan 2025 22:07:33 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Sat, 11 Jan 2025 22:07:33 +0800
From: lizetao <lizetao1@huawei.com>
To: io-uring <io-uring@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Subject: KASAN reported an error while executing accept-reust.t testcase
Thread-Topic: KASAN reported an error while executing accept-reust.t testcase
Thread-Index: AdtkMiVyVeZvS0/xQj+24imZgOjMRA==
Date: Sat, 11 Jan 2025 14:07:32 +0000
Message-ID: <ec2a6ca08c614c10853fbb1270296ac4@huawei.com>
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

SGkgYWxsLA0KDQpXaGVuIEkgcnVuIHRoZSB0ZXN0Y2FzZSBsaWJ1cmluZy9hY2NlcHQtcmV1c3Qu
dCB3aXRoIENPTkZJR19LQVNBTj15IGFuZCBDT05GSUdfS0FTQU5fRVhUUkFfSU5GTz15LCBJIGdv
dA0KYSBlcnJvciByZXBvcnRlZCBieSBLQVNBTjoNCg0KVW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwg
cGFnaW5nIHJlcXVlc3QgYXQgdmlydHVhbCBhZGRyZXNzIDAwMDAwYzY0NTUwMDgwMDgNCk1lbSBh
Ym9ydCBpbmZvOg0KICBFU1IgPSAweDAwMDAwMDAwOTYwMDAwMDQNCiAgRUMgPSAweDI1OiBEQUJU
IChjdXJyZW50IEVMKSwgSUwgPSAzMiBiaXRzDQogIFNFVCA9IDAsIEZuViA9IDANCiAgRUEgPSAw
LCBTMVBUVyA9IDANCiAgRlNDID0gMHgwNDogbGV2ZWwgMCB0cmFuc2xhdGlvbiBmYXVsdA0KRGF0
YSBhYm9ydCBpbmZvOg0KICBJU1YgPSAwLCBJU1MgPSAweDAwMDAwMDA0LCBJU1MyID0gMHgwMDAw
MDAwMA0KICBDTSA9IDAsIFduUiA9IDAsIFRuRCA9IDAsIFRhZ0FjY2VzcyA9IDANCiAgR0NTID0g
MCwgT3ZlcmxheSA9IDAsIERpcnR5Qml0ID0gMCwgWHMgPSAwDQp1c2VyIHBndGFibGU6IDRrIHBh
Z2VzLCA0OC1iaXQgVkFzLCBwZ2RwPTAwMDAwMDAxMTA0YzUwMDANClswMDAwMGM2NDU1MDA4MDA4
XSBwZ2Q9MDAwMDAwMDAwMDAwMDAwMCwgcDRkPTAwMDAwMDAwMDAwMDAwMDANCkludGVybmFsIGVy
cm9yOiBPb3BzOiAwMDAwMDAwMDk2MDAwMDA0IFsjMV0gUFJFRU1QVCBTTVANCk1vZHVsZXMgbGlu
a2VkIGluOg0KQ1BVOiA2IFVJRDogMCBQSUQ6IDM1MiBDb21tOiBrd29ya2VyL3UxMjg6NSBOb3Qg
dGFpbnRlZCA2LjEzLjAtcmM2LWcwYTJjYjc5MzUwN2QgIzUNCkhhcmR3YXJlIG5hbWU6IGxpbnV4
LGR1bW15LXZpcnQgKERUKQ0KV29ya3F1ZXVlOiBpb3VfZXhpdCBpb19yaW5nX2V4aXRfd29yaw0K
cHN0YXRlOiAxMDAwMDAwNSAobnpjViBkYWlmIC1QQU4gLVVBTyAtVENPIC1ESVQgLVNTQlMgQlRZ
UEU9LS0pDQpwYyA6IF9fa2FzYW5fbWVtcG9vbF91bnBvaXNvbl9vYmplY3QrMHgzOC8weDE3MA0K
bHIgOiBpb19uZXRtc2dfY2FjaGVfZnJlZSsweDhjLzB4MTgwDQpzcCA6IGZmZmY4MDAwODMyOTdh
OTANCngyOTogZmZmZjgwMDA4MzI5N2E5MCB4Mjg6IGZmZmZkNGQ3ZjY3ZTg4ZTQgeDI3OiAwMDAw
MDAwMDAwMDAwMDAzDQp4MjY6IDFmZmZlNTk1ODAxMTUwMmUgeDI1OiBmZmZmMmNhYmZmOTc2YzE4
IHgyNDogMWZmZmU1OTU3ZmYyZWQ4Mw0KeDIzOiBmZmZmMmNhYmZmOTc2YzEwIHgyMjogMDAwMDBj
NjQ1NTAwODAwMCB4MjE6IDAwMDI5OTI1NDAyMDAwMDENCngyMDogMDAwMDAwMDAwMDAwMDAwMCB4
MTk6IDAwMDAwYzY0NTUwMDgwMDAgeDE4OiAwMDAwMDAwMDQ4OTY4M2Y4DQp4MTc6IGZmZmZkNGQ3
ZjY4MDA2YWMgeDE2OiBmZmZmZDRkN2Y2N2ViM2UwIHgxNTogZmZmZmQ0ZDdmNjdlODhlNA0KeDE0
OiBmZmZmZDRkN2Y3NjZkZWFjIHgxMzogZmZmZmQ0ZDdmNjYxOTAzMCB4MTI6IGZmZmY3YTliMDEy
ZTNlMjYNCngxMTogMWZmZmZhOWIwMTJlM2UyNSB4MTA6IGZmZmY3YTliMDEyZTNlMjUgeDkgOiBm
ZmZmZDRkN2Y3NjZkZWJjDQp4OCA6IGZmZmZkNGQ4MDk3MWYxMjggeDcgOiAwMDAwMDAwMDAwMDAw
MDAxIHg2IDogMDAwMDg1NjRmZWQxYzFkYg0KeDUgOiBmZmZmZDRkODA5NzFmMTI4IHg0IDogZmZm
ZjdhOWIwMTJlM2UyNiB4MyA6IGZmZmYyY2FiZmY5NzZjMDANCngyIDogZmZmZmMxZmZjMDAwMDAw
MCB4MSA6IDAwMDAwMDAwMDAwMDAwMDAgeDAgOiAwMDAyOTkyNTQwMjAwMDAxDQpDYWxsIHRyYWNl
Og0KIF9fa2FzYW5fbWVtcG9vbF91bnBvaXNvbl9vYmplY3QrMHgzOC8weDE3MCAoUCkNCiBpb19u
ZXRtc2dfY2FjaGVfZnJlZSsweDhjLzB4MTgwDQogaW9fcmluZ19leGl0X3dvcmsrMHhkNGMvMHgx
M2EwDQogcHJvY2Vzc19vbmVfd29yaysweDUyYy8weDEwMDANCiB3b3JrZXJfdGhyZWFkKzB4ODMw
LzB4ZGMwDQoga3RocmVhZCsweDJiYy8weDM0OA0KIHJldF9mcm9tX2ZvcmsrMHgxMC8weDIwDQpD
b2RlOiBhYTAwMDNmNSBhYTAxMDNmNCA4YjEzMTg1MyBhYTEzMDNmNiAoZjk0MDA2NjIpIA0KLS0t
WyBlbmQgdHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tDQoNCg0KSSBwcmVsaW1pbmFyeSBhbmFs
eXplZCB0aGUgYWNjZXB0IGFuZCBjb25uZWN0IGNvZGUgbG9naWMuIEluIHRoZSBhY2NlcHQtcmV1
c2UudCB0ZXN0Y2FzZSwga21zZy0+ZnJlZV9pb3YgaXMNCm5vdCB1c2VkLCBzbyB3aGVuIGNhbGxp
bmcgaW9fbmV0bXNnX2NhY2hlX2ZyZWUoKSwgdGhlIGthc2FuX21lbXBvb2xfdW5wb2lzb25fb2Jq
ZWN0KGttc2ctPmZyZWVfaW92Li4uKSBwYXRoDQpzaG91bGQgbm90IGJlIGV4ZWN1dGVkLg0KDQoN
CkkgdXNlZCB0aGUgaGFyZHdhcmUgd2F0Y2hwb2ludCB0byBjYXB0dXJlIHRoZSBmaXJzdCBzY2Vu
ZSBvZiBtb2RpZnlpbmcga21zZy0+ZnJlZV9pb3Y6DQoNClRocmVhZCAzIGhpdCBIYXJkd2FyZSB3
YXRjaHBvaW50IDc6ICoweGZmZmYwMDAwZWJmYzU0MTANCk9sZCB2YWx1ZSA9IDANCk5ldyB2YWx1
ZSA9IC0yMTE4MTIzNTANCmthc2FuX3NldF90cmFjayAoc3RhY2s9PG9wdGltaXplZCBvdXQ+LCB0
cmFjaz08b3B0aW1pemVkIG91dD4pIGF0IC4vYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9jdXJyZW50
Lmg6MjENCjIxCQlyZXR1cm4gKHN0cnVjdCB0YXNrX3N0cnVjdCAqKXNwX2VsMDsNCg0KIyBidA0K
a2FzYW5fc2V0X3RyYWNrDQprYXNhbl9zYXZlX3RyYWNrDQprYXNhbl9zYXZlX2ZyZWVfaW5mbw0K
cG9pc29uX3NsYWJfb2JqZWN0DQpfX2thc2FuX21lbXBvb2xfcG9pc29uX29iamVjdA0Ka2FzYW5f
bWVtcG9vbF9wb2lzb25fb2JqZWN0DQppb19hbGxvY19jYWNoZV9wdXQNCmlvX25ldG1zZ19yZWN5
Y2xlDQppb19yZXFfbXNnX2NsZWFudXANCmlvX2Nvbm5lY3QNCmlvX2lzc3VlX3NxZQ0KaW9fcXVl
dWVfc3FlDQppb19yZXFfdGFza19zdWJtaXQNCi4uLg0KDQoNCkl0J3MgYSBiaXQgc3RyYW5nZS4g
SXQgd2FzIG1vZGlmaWVkIGJ5IEtBU0FOLiBJIGNhbid0IHVuZGVyc3RhbmQgdGhpcy4NCk1heWJl
IEkgbWlzc2VkIHNvbWV0aGluZz8gUGxlYXNlIGxldCBtZSBrbm93LiBUaGFua3MuDQoNCi0tLQ0K
TGkgWmV0YW8NCg==

