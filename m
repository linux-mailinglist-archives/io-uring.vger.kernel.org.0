Return-Path: <io-uring+bounces-5829-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CA4A0A75F
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 07:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FCB7167E20
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 06:45:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F931494A8;
	Sun, 12 Jan 2025 06:45:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84974154BF0
	for <io-uring@vger.kernel.org>; Sun, 12 Jan 2025 06:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736664346; cv=none; b=W5VipQGoGlTJJPrcRQ2Q6AMVc6lXHIYcTI5V+7B3c2xmB6VWU24q41+2Q53xXXGd1w4rIG49WEILkdEkFTOYxp6oSkZEpzzdqsKKn1pXayxAMxEHpVeZZF7jXe5fkwqOsmXw1Sk6hGDXtP7ZqFOsTSNXrMGyZLl9FQJF6Y9smSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736664346; c=relaxed/simple;
	bh=5O5GrY2DL3HmVqMBs1zEvv0fX+L0ULWNILdSDuIXxW0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ys7eucwD5+lb+x2nyWeTvSRlT7TXH2hX4lfNpasfz2R6092JiMsdN7zmXPcD03Sob52fopm7NfuPMbUjnRQXGDGSfIIRM9Zn1vzVjiIp3uhOwvtHiyqzgQgWvDOgfWZqFVsOKJABf8VnGnifNF1W5hiBi3FfOwvnANgowBHjM34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YW5VC0WRWz1JGd2;
	Sun, 12 Jan 2025 14:44:51 +0800 (CST)
Received: from kwepemd100011.china.huawei.com (unknown [7.221.188.204])
	by mail.maildlp.com (Postfix) with ESMTPS id 83299140114;
	Sun, 12 Jan 2025 14:45:40 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100011.china.huawei.com (7.221.188.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sun, 12 Jan 2025 14:45:40 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Sun, 12 Jan 2025 14:45:40 +0800
From: lizetao <lizetao1@huawei.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
CC: Pavel Begunkov <asml.silence@gmail.com>, "juntong.deng@outlook.com"
	<juntong.deng@outlook.com>, "ryabinin.a.a@gmail.com"
	<ryabinin.a.a@gmail.com>, "kasan-dev@googlegroups.com"
	<kasan-dev@googlegroups.com>
Subject: RE: KASAN reported an error while executing accept-reust.t testcase
Thread-Topic: KASAN reported an error while executing accept-reust.t testcase
Thread-Index: AdtkMiVyVeZvS0/xQj+24imZgOjMRP//rdsA//6ZQvA=
Date: Sun, 12 Jan 2025 06:45:40 +0000
Message-ID: <c14929fc328f43baa7ac2ad8f85a8f2b@huawei.com>
References: <ec2a6ca08c614c10853fbb1270296ac4@huawei.com>
 <98125b67-7b63-427f-b822-a12779d50a13@kernel.dk>
In-Reply-To: <98125b67-7b63-427f-b822-a12779d50a13@kernel.dk>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmVucyBBeGJvZSA8
YXhib2VAa2VybmVsLmRrPg0KPiBTZW50OiBTdW5kYXksIEphbnVhcnkgMTIsIDIwMjUgMToxMyBB
TQ0KPiBUbzogbGl6ZXRhbyA8bGl6ZXRhbzFAaHVhd2VpLmNvbT47IGlvLXVyaW5nIDxpby11cmlu
Z0B2Z2VyLmtlcm5lbC5vcmc+DQo+IENjOiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdt
YWlsLmNvbT4NCj4gU3ViamVjdDogUmU6IEtBU0FOIHJlcG9ydGVkIGFuIGVycm9yIHdoaWxlIGV4
ZWN1dGluZyBhY2NlcHQtcmV1c3QudCB0ZXN0Y2FzZQ0KPiANCj4gT24gMS8xMS8yNSA3OjA3IEFN
LCBsaXpldGFvIHdyb3RlOg0KPiA+IEhpIGFsbCwNCj4gPg0KPiA+IFdoZW4gSSBydW4gdGhlIHRl
c3RjYXNlIGxpYnVyaW5nL2FjY2VwdC1yZXVzdC50IHdpdGggQ09ORklHX0tBU0FOPXkNCj4gPiBh
bmQgQ09ORklHX0tBU0FOX0VYVFJBX0lORk89eSwgSSBnb3QgYSBlcnJvciByZXBvcnRlZCBieSBL
QVNBTjoNCj4gDQo+IExvb2tzIG1vcmUgbGlrZSB5b3UgZ2V0IEtBU0FOIGNyYXNoaW5nLi4uDQo+
IA0KPiA+IFVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IHZpcnR1YWwg
YWRkcmVzcw0KPiA+IDAwMDAwYzY0NTUwMDgwMDggTWVtIGFib3J0IGluZm86DQo+ID4gICBFU1Ig
PSAweDAwMDAwMDAwOTYwMDAwMDQNCj4gPiAgIEVDID0gMHgyNTogREFCVCAoY3VycmVudCBFTCks
IElMID0gMzIgYml0cw0KPiA+ICAgU0VUID0gMCwgRm5WID0gMA0KPiA+ICAgRUEgPSAwLCBTMVBU
VyA9IDANCj4gPiAgIEZTQyA9IDB4MDQ6IGxldmVsIDAgdHJhbnNsYXRpb24gZmF1bHQgRGF0YSBh
Ym9ydCBpbmZvOg0KPiA+ICAgSVNWID0gMCwgSVNTID0gMHgwMDAwMDAwNCwgSVNTMiA9IDB4MDAw
MDAwMDANCj4gPiAgIENNID0gMCwgV25SID0gMCwgVG5EID0gMCwgVGFnQWNjZXNzID0gMA0KPiA+
ICAgR0NTID0gMCwgT3ZlcmxheSA9IDAsIERpcnR5Qml0ID0gMCwgWHMgPSAwIHVzZXIgcGd0YWJs
ZTogNGsgcGFnZXMsDQo+ID4gNDgtYml0IFZBcywgcGdkcD0wMDAwMDAwMTEwNGM1MDAwIFswMDAw
MGM2NDU1MDA4MDA4XQ0KPiA+IHBnZD0wMDAwMDAwMDAwMDAwMDAwLCBwNGQ9MDAwMDAwMDAwMDAw
MDAwMCBJbnRlcm5hbCBlcnJvcjogT29wczoNCj4gPiAwMDAwMDAwMDk2MDAwMDA0IFsjMV0gUFJF
RU1QVCBTTVAgTW9kdWxlcyBsaW5rZWQgaW46DQo+ID4gQ1BVOiA2IFVJRDogMCBQSUQ6IDM1MiBD
b21tOiBrd29ya2VyL3UxMjg6NSBOb3QgdGFpbnRlZA0KPiA+IDYuMTMuMC1yYzYtZzBhMmNiNzkz
NTA3ZCAjNSBIYXJkd2FyZSBuYW1lOiBsaW51eCxkdW1teS12aXJ0IChEVCkNCj4gPiBXb3JrcXVl
dWU6IGlvdV9leGl0IGlvX3JpbmdfZXhpdF93b3JrDQo+ID4gcHN0YXRlOiAxMDAwMDAwNSAobnpj
ViBkYWlmIC1QQU4gLVVBTyAtVENPIC1ESVQgLVNTQlMgQlRZUEU9LS0pIHBjIDoNCj4gPiBfX2th
c2FuX21lbXBvb2xfdW5wb2lzb25fb2JqZWN0KzB4MzgvMHgxNzANCj4gPiBsciA6IGlvX25ldG1z
Z19jYWNoZV9mcmVlKzB4OGMvMHgxODANCj4gPiBzcCA6IGZmZmY4MDAwODMyOTdhOTANCj4gPiB4
Mjk6IGZmZmY4MDAwODMyOTdhOTAgeDI4OiBmZmZmZDRkN2Y2N2U4OGU0IHgyNzogMDAwMDAwMDAw
MDAwMDAwMw0KPiA+IHgyNjogMWZmZmU1OTU4MDExNTAyZSB4MjU6IGZmZmYyY2FiZmY5NzZjMTgg
eDI0OiAxZmZmZTU5NTdmZjJlZDgzDQo+ID4geDIzOiBmZmZmMmNhYmZmOTc2YzEwIHgyMjogMDAw
MDBjNjQ1NTAwODAwMCB4MjE6IDAwMDI5OTI1NDAyMDAwMDENCj4gPiB4MjA6IDAwMDAwMDAwMDAw
MDAwMDAgeDE5OiAwMDAwMGM2NDU1MDA4MDAwIHgxODogMDAwMDAwMDA0ODk2ODNmOA0KPiA+IHgx
NzogZmZmZmQ0ZDdmNjgwMDZhYyB4MTY6IGZmZmZkNGQ3ZjY3ZWIzZTAgeDE1OiBmZmZmZDRkN2Y2
N2U4OGU0DQo+ID4geDE0OiBmZmZmZDRkN2Y3NjZkZWFjIHgxMzogZmZmZmQ0ZDdmNjYxOTAzMCB4
MTI6IGZmZmY3YTliMDEyZTNlMjYNCj4gPiB4MTE6IDFmZmZmYTliMDEyZTNlMjUgeDEwOiBmZmZm
N2E5YjAxMmUzZTI1IHg5IDogZmZmZmQ0ZDdmNzY2ZGViYw0KPiA+IHg4IDogZmZmZmQ0ZDgwOTcx
ZjEyOCB4NyA6IDAwMDAwMDAwMDAwMDAwMDEgeDYgOiAwMDAwODU2NGZlZDFjMWRiDQo+ID4geDUg
OiBmZmZmZDRkODA5NzFmMTI4IHg0IDogZmZmZjdhOWIwMTJlM2UyNiB4MyA6IGZmZmYyY2FiZmY5
NzZjMDANCj4gPiB4MiA6IGZmZmZjMWZmYzAwMDAwMDAgeDEgOiAwMDAwMDAwMDAwMDAwMDAwIHgw
IDogMDAwMjk5MjU0MDIwMDAwMSBDYWxsDQo+ID4gdHJhY2U6DQo+ID4gIF9fa2FzYW5fbWVtcG9v
bF91bnBvaXNvbl9vYmplY3QrMHgzOC8weDE3MCAoUCkNCj4gPiAgaW9fbmV0bXNnX2NhY2hlX2Zy
ZWUrMHg4Yy8weDE4MA0KPiA+ICBpb19yaW5nX2V4aXRfd29yaysweGQ0Yy8weDEzYTANCj4gPiAg
cHJvY2Vzc19vbmVfd29yaysweDUyYy8weDEwMDANCj4gPiAgd29ya2VyX3RocmVhZCsweDgzMC8w
eGRjMA0KPiA+ICBrdGhyZWFkKzB4MmJjLzB4MzQ4DQo+ID4gIHJldF9mcm9tX2ZvcmsrMHgxMC8w
eDIwDQo+ID4gQ29kZTogYWEwMDAzZjUgYWEwMTAzZjQgOGIxMzE4NTMgYWExMzAzZjYgKGY5NDAw
NjYyKSAtLS1bIGVuZCB0cmFjZQ0KPiA+IDAwMDAwMDAwMDAwMDAwMDAgXS0tLQ0KPiA+DQo+ID4N
Cj4gPiBJIHByZWxpbWluYXJ5IGFuYWx5emVkIHRoZSBhY2NlcHQgYW5kIGNvbm5lY3QgY29kZSBs
b2dpYy4gSW4gdGhlDQo+ID4gYWNjZXB0LXJldXNlLnQgdGVzdGNhc2UsIGttc2ctPmZyZWVfaW92
IGlzIG5vdCB1c2VkLCBzbyB3aGVuIGNhbGxpbmcNCj4gPiBpb19uZXRtc2dfY2FjaGVfZnJlZSgp
LCB0aGUNCj4gPiBrYXNhbl9tZW1wb29sX3VucG9pc29uX29iamVjdChrbXNnLT5mcmVlX2lvdi4u
LikgcGF0aCBzaG91bGQgbm90IGJlDQo+ID4gZXhlY3V0ZWQuDQo+ID4NCj4gPg0KPiA+IEkgdXNl
ZCB0aGUgaGFyZHdhcmUgd2F0Y2hwb2ludCB0byBjYXB0dXJlIHRoZSBmaXJzdCBzY2VuZSBvZiBt
b2RpZnlpbmcga21zZy0NCj4gPmZyZWVfaW92Og0KPiA+DQo+ID4gVGhyZWFkIDMgaGl0IEhhcmR3
YXJlIHdhdGNocG9pbnQgNzogKjB4ZmZmZjAwMDBlYmZjNTQxMCBPbGQgdmFsdWUgPSAwDQo+ID4g
TmV3IHZhbHVlID0gLTIxMTgxMjM1MCBrYXNhbl9zZXRfdHJhY2sgKHN0YWNrPTxvcHRpbWl6ZWQg
b3V0PiwNCj4gPiB0cmFjaz08b3B0aW1pemVkIG91dD4pIGF0IC4vYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9jdXJyZW50Lmg6MjENCj4gPiAyMQkJcmV0dXJuIChzdHJ1Y3QgdGFza19zdHJ1Y3QgKilz
cF9lbDA7DQo+ID4NCj4gPiAjIGJ0DQo+ID4ga2FzYW5fc2V0X3RyYWNrDQo+ID4ga2FzYW5fc2F2
ZV90cmFjaw0KPiA+IGthc2FuX3NhdmVfZnJlZV9pbmZvDQo+ID4gcG9pc29uX3NsYWJfb2JqZWN0
DQo+ID4gX19rYXNhbl9tZW1wb29sX3BvaXNvbl9vYmplY3QNCj4gPiBrYXNhbl9tZW1wb29sX3Bv
aXNvbl9vYmplY3QNCj4gPiBpb19hbGxvY19jYWNoZV9wdXQNCj4gPiBpb19uZXRtc2dfcmVjeWNs
ZQ0KPiA+IGlvX3JlcV9tc2dfY2xlYW51cA0KPiA+IGlvX2Nvbm5lY3QNCj4gPiBpb19pc3N1ZV9z
cWUNCj4gPiBpb19xdWV1ZV9zcWUNCj4gPiBpb19yZXFfdGFza19zdWJtaXQNCj4gPiAuLi4NCj4g
Pg0KPiA+DQo+ID4gSXQncyBhIGJpdCBzdHJhbmdlLiBJdCB3YXMgbW9kaWZpZWQgYnkgS0FTQU4u
IEkgY2FuJ3QgdW5kZXJzdGFuZCB0aGlzLg0KPiA+IE1heWJlIEkgbWlzc2VkIHNvbWV0aGluZz8g
UGxlYXNlIGxldCBtZSBrbm93LiBUaGFua3MuDQo+IA0KPiBMb29rcyBsaWtlIEtBU0FOIHdpdGgg
dGhlIGV4dHJhIGluZm8gZW5kcyB1cCB3cml0aW5nIHRvIGlvX2FzeW5jX21zZ2hkci0NCj4gPmZy
ZWVfaW92IHNvbWVob3cuIE5vIGlkZWEuLi4gRm9yIHRoZSB0ZXN0IGNhc2UgaW4gcXVlc3Rpb24s
IC0+ZnJlZV9pb3Ygc2hvdWxkDQo+IGJlIE5VTEwgd2hlbiBpbml0aWFsbHkgYWxsb2NhdGVkLCBh
bmQgdGhlIGlvX3VyaW5nIGNvZGUgaXNuJ3Qgc3RvcmluZyB0byBpdC4gWWV0DQo+IGl0J3Mgbm9u
LU5VTEwgd2hlbiB5b3UgbGF0ZXIgZ28gYW5kIGZyZWUgaXQsIGFmdGVyIGNhbGxpbmcNCj4ga2Fz
YW5fbWVtcG9vbF9wb2lzb25fb2JqZWN0KCkuDQoNCkkgYWxzbyB0aGluayBzbyBhbmQgd291bGQg
SnVudG9uZyBhbmQgUnlhYmluaW4gb3Igb3RoZXJzIEtBU0FOIGRldmVsb3BlcnMgYmUgaW50ZXJl
c3RlZA0KSW4gdGhpcyBwcm9ibGVtPw0KDQorQ0MganVudG9uZy5kZW5nQG91dGxvb2suY29tLCBy
eWFiaW5pbi5hLmFAZ21haWwuY29tIGFuZCBrYXNhbi1kZXZAZ29vZ2xlZ3JvdXBzLmNvbQ0KDQpU
aGFuayB5b3Ugc28gbXVzaC4NCj4gDQo+IC0tDQo+IEplbnMgQXhib2UNCg0KLS0tDQpMaSBaZXRh
bw0K

