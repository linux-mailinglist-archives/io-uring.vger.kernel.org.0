Return-Path: <io-uring+bounces-6429-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28F1BA354B5
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 03:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C07DC16CD24
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 02:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0D5013212A;
	Fri, 14 Feb 2025 02:27:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0579977F11;
	Fri, 14 Feb 2025 02:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739500043; cv=none; b=lDSxbfwlLXJhh5KuGhdsXQFCq3ijaNR2oGYXiWKxopFotgg96sI5K1CDabCws3ozOogI0EfZHwCfYnWCYG3QdWOkJuwPmzz+7TdT8e0cRpDNOGal3dwe5bz+tdYPzxfhabRtMf1WwpMpcMIBgV1gqrUzmcjcdgF98z/l03X//8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739500043; c=relaxed/simple;
	bh=VGjW49Ky5aAmkdqjTBP8wPAMIVbvtI2xGwKTTGHTgGg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uIn7xdE2gec8RGOLN5jA7/giU4jd72A+LuZ7h+SipqQxBGF7OLB5uBXmqs8bIFdqHjhH31I63HBOXG9l4xZaZedSVrBgN+OQcQMB/kOrliOMI25rTdUtF5wZl95tu0QDXFNXMWQXfFdw+Yie3119n6yN5wDt7pCJdAAFCiWKzTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YvG7P1FDTz1ltbD;
	Fri, 14 Feb 2025 10:23:29 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (unknown [7.221.188.25])
	by mail.maildlp.com (Postfix) with ESMTPS id EECDE14013B;
	Fri, 14 Feb 2025 10:27:16 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd500012.china.huawei.com (7.221.188.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 14 Feb 2025 10:27:16 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Fri, 14 Feb 2025 10:27:16 +0800
From: lizetao <lizetao1@huawei.com>
To: David Wei <dw@davidwei.uk>
CC: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, "Mina
 Almasry" <almasrymina@google.com>, Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>, Pedro Tammela <pctammela@mojatatu.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v13 11/11] io_uring/zcrx: add selftest
Thread-Topic: [PATCH net-next v13 11/11] io_uring/zcrx: add selftest
Thread-Index: AQHbfYBn2X1L1dgCzkucb4YxeYskSbNGEijg
Date: Fri, 14 Feb 2025 02:27:16 +0000
Message-ID: <81bc32eee1b1406883fb330efa341621@huawei.com>
References: <20250212185859.3509616-1-dw@davidwei.uk>
 <20250212185859.3509616-12-dw@davidwei.uk>
In-Reply-To: <20250212185859.3509616-12-dw@davidwei.uk>
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

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgV2VpIDxk
d0BkYXZpZHdlaS51az4NCj4gU2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5IDEzLCAyMDI1IDI6NTgg
QU0NCj4gVG86IGlvLXVyaW5nQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
Zw0KPiBDYzogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPjsgUGF2ZWwgQmVndW5rb3YNCj4g
PGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3Jn
PjsgUGFvbG8gQWJlbmkNCj4gPHBhYmVuaUByZWRoYXQuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxk
YXZlbUBkYXZlbWxvZnQubmV0PjsgRXJpYyBEdW1hemV0DQo+IDxlZHVtYXpldEBnb29nbGUuY29t
PjsgSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8aGF3a0BrZXJuZWwub3JnPjsgRGF2aWQNCj4gQWhl
cm4gPGRzYWhlcm5Aa2VybmVsLm9yZz47IE1pbmEgQWxtYXNyeSA8YWxtYXNyeW1pbmFAZ29vZ2xl
LmNvbT47DQo+IFN0YW5pc2xhdiBGb21pY2hldiA8c3Rmb21pY2hldkBnbWFpbC5jb20+OyBKb2Ug
RGFtYXRvDQo+IDxqZGFtYXRvQGZhc3RseS5jb20+OyBQZWRybyBUYW1tZWxhIDxwY3RhbW1lbGFA
bW9qYXRhdHUuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5leHQgdjEzIDExLzExXSBpb191
cmluZy96Y3J4OiBhZGQgc2VsZnRlc3QNCj4gDQo+IEFkZCBhIHNlbGZ0ZXN0IGZvciBpb191cmlu
ZyB6ZXJvIGNvcHkgUnguIFRoaXMgdGVzdCBjYW5ub3QgcnVuIGxvY2FsbHkgYW5kDQo+IHJlcXVp
cmVzIGEgcmVtb3RlIGhvc3QgdG8gYmUgY29uZmlndXJlZCBpbiBuZXQuY29uZmlnLiBUaGUgcmVt
b3RlIGhvc3QgbXVzdA0KPiBoYXZlIGhhcmR3YXJlIHN1cHBvcnQgZm9yIHplcm8gY29weSBSeCBh
cyBsaXN0ZWQgaW4gdGhlIGRvY3VtZW50YXRpb24gcGFnZS4NCj4gVGhlIHRlc3Qgd2lsbCByZXN0
b3JlIHRoZSBOSUMgY29uZmlnIGJhY2sgdG8gYmVmb3JlIHRoZSB0ZXN0IGFuZCBpcyBpZGVtcG90
ZW50Lg0KPiANCj4gbGlidXJpbmcgaXMgcmVxdWlyZWQgdG8gY29tcGlsZSB0aGUgdGVzdCBhbmQg
YmUgaW5zdGFsbGVkIG9uIHRoZSByZW1vdGUgaG9zdA0KPiBydW5uaW5nIHRoZSB0ZXN0Lg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogRGF2aWQgV2VpIDxkd0BkYXZpZHdlaS51az4NCj4gLS0tDQo+ICAu
Li4vc2VsZnRlc3RzL2RyaXZlcnMvbmV0L2h3Ly5naXRpZ25vcmUgICAgICAgfCAgIDIgKw0KPiAg
Li4uL3Rlc3Rpbmcvc2VsZnRlc3RzL2RyaXZlcnMvbmV0L2h3L01ha2VmaWxlIHwgICA1ICsNCj4g
IC4uLi9zZWxmdGVzdHMvZHJpdmVycy9uZXQvaHcvaW91LXpjcnguYyAgICAgICB8IDQyNiArKysr
KysrKysrKysrKysrKysNCj4gIC4uLi9zZWxmdGVzdHMvZHJpdmVycy9uZXQvaHcvaW91LXpjcngu
cHkgICAgICB8ICA2NCArKysNCj4gIDQgZmlsZXMgY2hhbmdlZCwgNDk3IGluc2VydGlvbnMoKykN
Cj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9kcml2ZXJzL25l
dC9ody9pb3UtemNyeC5jDQo+ICBjcmVhdGUgbW9kZSAxMDA3NTUgdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvZHJpdmVycy9uZXQvaHcvaW91LXpjcngucHkNCj4gDQo+IGRpZmYgLS1naXQgYS90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9kcml2ZXJzL25ldC9ody8uZ2l0aWdub3JlDQo+IGIvdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvZHJpdmVycy9uZXQvaHcvLmdpdGlnbm9yZQ0KPiBpbmRleCBlOWZl
NmVkZTY4MWEuLjY5NDJiZjU3NTQ5NyAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvZHJpdmVycy9uZXQvaHcvLmdpdGlnbm9yZQ0KPiArKysgYi90b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9kcml2ZXJzL25ldC9ody8uZ2l0aWdub3JlDQo+IEBAIC0xICsxLDMgQEANCj4gKyMg
U1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seSBpb3UtemNyeA0KPiAgbmNkZXZt
ZW0NCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2RyaXZlcnMvbmV0L2h3
L01ha2VmaWxlDQo+IGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvZHJpdmVycy9uZXQvaHcvTWFr
ZWZpbGUNCj4gaW5kZXggMjFiYTY0Y2UxZTM0Li43ZWZjNDdjODk0NjMgMTAwNjQ0DQo+IC0tLSBh
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2RyaXZlcnMvbmV0L2h3L01ha2VmaWxlDQo+ICsrKyBi
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2RyaXZlcnMvbmV0L2h3L01ha2VmaWxlDQo+IEBAIC0x
LDUgKzEsNyBAQA0KPiAgIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCsgT1IgTUlU
DQo+IA0KPiArVEVTVF9HRU5fRklMRVMgPSBpb3UtemNyeA0KPiArDQo+ICBURVNUX1BST0dTID0g
XA0KPiAgCWNzdW0ucHkgXA0KPiAgCWRldmxpbmtfcG9ydF9zcGxpdC5weSBcDQo+IEBAIC0xMCw2
ICsxMiw3IEBAIFRFU1RfUFJPR1MgPSBcDQo+ICAJZXRodG9vbF9ybW9uLnNoIFwNCj4gIAlod19z
dGF0c19sMy5zaCBcDQo+ICAJaHdfc3RhdHNfbDNfZ3JlLnNoIFwNCj4gKwlpb3UtemNyeC5weSBc
DQo+ICAJbG9vcGJhY2suc2ggXA0KPiAgCW5pY19saW5rX2xheWVyLnB5IFwNCj4gIAluaWNfcGVy
Zm9ybWFuY2UucHkgXA0KPiBAQCAtMzgsMyArNDEsNSBAQCBpbmNsdWRlIC4uLy4uLy4uL2xpYi5t
ayAgIyBZTkwgYnVpbGQgIFlOTF9HRU5TIDo9IGV0aHRvb2wNCj4gbmV0ZGV2ICBpbmNsdWRlIC4u
Ly4uLy4uL25ldC95bmwubWsNCj4gKw0KPiArJChPVVRQVVQpL2lvdS16Y3J4OiBMRExJQlMgKz0g
LWx1cmluZw0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvZHJpdmVycy9u
ZXQvaHcvaW91LXpjcnguYw0KPiBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2RyaXZlcnMvbmV0
L2h3L2lvdS16Y3J4LmMNCj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gaW5kZXggMDAwMDAwMDAw
MDAwLi4wMTBjMjYxZDIxMzINCj4gLS0tIC9kZXYvbnVsbA0KPiArKysgYi90b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9kcml2ZXJzL25ldC9ody9pb3UtemNyeC5jDQo+IEBAIC0wLDAgKzEsNDI2IEBA
DQo+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArI2luY2x1ZGUgPGFz
c2VydC5oPg0KPiArI2luY2x1ZGUgPGVycm5vLmg+DQo+ICsjaW5jbHVkZSA8ZXJyb3IuaD4NCj4g
KyNpbmNsdWRlIDxmY250bC5oPg0KPiArI2luY2x1ZGUgPGxpbWl0cy5oPg0KPiArI2luY2x1ZGUg
PHN0ZGJvb2wuaD4NCj4gKyNpbmNsdWRlIDxzdGRpbnQuaD4NCj4gKyNpbmNsdWRlIDxzdGRpby5o
Pg0KPiArI2luY2x1ZGUgPHN0ZGxpYi5oPg0KPiArI2luY2x1ZGUgPHN0cmluZy5oPg0KPiArI2lu
Y2x1ZGUgPHVuaXN0ZC5oPg0KPiArDQo+ICsjaW5jbHVkZSA8YXJwYS9pbmV0Lmg+DQo+ICsjaW5j
bHVkZSA8bGludXgvZXJycXVldWUuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9pZl9wYWNrZXQuaD4N
Cj4gKyNpbmNsdWRlIDxsaW51eC9pcHY2Lmg+DQo+ICsjaW5jbHVkZSA8bGludXgvc29ja2V0Lmg+
DQo+ICsjaW5jbHVkZSA8bGludXgvc29ja2lvcy5oPg0KPiArI2luY2x1ZGUgPG5ldC9ldGhlcm5l
dC5oPg0KPiArI2luY2x1ZGUgPG5ldC9pZi5oPg0KPiArI2luY2x1ZGUgPG5ldGluZXQvaW4uaD4N
Cj4gKyNpbmNsdWRlIDxuZXRpbmV0L2lwLmg+DQo+ICsjaW5jbHVkZSA8bmV0aW5ldC9pcDYuaD4N
Cj4gKyNpbmNsdWRlIDxuZXRpbmV0L3RjcC5oPg0KPiArI2luY2x1ZGUgPG5ldGluZXQvdWRwLmg+
DQo+ICsjaW5jbHVkZSA8c3lzL2Vwb2xsLmg+DQo+ICsjaW5jbHVkZSA8c3lzL2lvY3RsLmg+DQo+
ICsjaW5jbHVkZSA8c3lzL21tYW4uaD4NCj4gKyNpbmNsdWRlIDxzeXMvcmVzb3VyY2UuaD4NCj4g
KyNpbmNsdWRlIDxzeXMvc29ja2V0Lmg+DQo+ICsjaW5jbHVkZSA8c3lzL3N0YXQuaD4NCj4gKyNp
bmNsdWRlIDxzeXMvdGltZS5oPg0KPiArI2luY2x1ZGUgPHN5cy90eXBlcy5oPg0KPiArI2luY2x1
ZGUgPHN5cy91bi5oPg0KPiArI2luY2x1ZGUgPHN5cy93YWl0Lmg+DQo+ICsNCg0KV2hlbiBJIGNv
bXBpbGVkIHRoaXMgdGVzdGNhc2UsIEkgZ290IHNvbWUgZXJyb3JzOg0KDQogIGlvdS16Y3J4LmM6
MTQ1Ojk6IGVycm9yOiB2YXJpYWJsZSDigJhyZWdpb25fcmVn4oCZIGhhcyBpbml0aWFsaXplciBi
dXQgaW5jb21wbGV0ZSB0eXBlDQogIGlvdS16Y3J4LmM6MTQ4OjEyOiBlcnJvcjog4oCYSU9SSU5H
X01FTV9SRUdJT05fVFlQRV9VU0VS4oCZIHVuZGVjbGFyZWQgKGZpcnN0IHVzZSBpbiB0aGlzIGZ1
bmN0aW9uKQ0KICAuLi4NCg0KSXQgc2VlbXMgdGhhdCB0aGUgbGludXgvaW9fdXJpbmcuaCBzaG91
bGQgYmUgaW5jbHVkZWQgaGVyZS4NCg0KQWxzbywgYWZ0ZXIgaW5jbHVkZSB0aGlzIGhlYWRlciBm
aWxlLCBzb21lIGVycm9ycyBzdGlsbCBleGlzdC4gDQoNCiAgaW91LXpjcnguYzooLnRleHQrMHg1
ZjApOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBpb191cmluZ19yZWdpc3Rlcl9pZnEnDQoNCkl0
IGlzIGNhdXNlZCBiZWNhdXNlIGlvX3VyaW5nX3JlZ2lzdGVyX2lmcSBzeW1ib2wgd2FzIG5vdCBl
eHBvcnRlZCBpbiBsaWJ1cmluZy4NCg0KRmluYWxseSBzb21lIHdhcm5pbmdzIHNob3VsZCBhbHNv
IGJlIGZpeGVkOg0KDQogIGlvdS16Y3J4LmM6Mjg4OjE3OiB3YXJuaW5nOiBwYXNzaW5nIGFyZ3Vt
ZW50IDIgb2Yg4oCYYmluZOKAmSBmcm9tIGluY29tcGF0aWJsZSBwb2ludGVyIHR5cGUNCiAgaW91
LXpjcnguYzozMjY6MTg6IHdhcm5pbmc6IHBhc3NpbmcgYXJndW1lbnQgMiBvZiDigJhjb25uZWN0
4oCZIGZyb20gaW5jb21wYXRpYmxlIHBvaW50ZXIgdHlwZQ0KDQo+ICsjaW5jbHVkZSA8bGlidXJp
bmcuaD4NCg0KLS0tDQpMaSBaZXRhbw0K

