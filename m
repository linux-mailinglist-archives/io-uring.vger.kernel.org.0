Return-Path: <io-uring+bounces-6932-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADCB1A4E290
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 16:13:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC8D4179EB1
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B94227D766;
	Tue,  4 Mar 2025 15:01:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from beeline3.cc.itu.edu.tr (beeline3.cc.itu.edu.tr [160.75.25.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1B22512ED
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 15:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=160.75.25.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741100472; cv=pass; b=Zuh8DWzJx54vTyZ/K5EpdW+76+BzO8aAe61U1TWa1CS5eN5LWmjndkGs4C8kYJWSRn71CwWP7ij8BTt5tmxNW8Nae6o6gGm72RYzK9oX6G1k4Dc3dwCZEN1DGp5z2ubZGLbVIp6vF/aeFZfC/McLjCrlieb3uQn6QhivsD7gqII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741100472; c=relaxed/simple;
	bh=AffzCFirDGYzwyBd4MxRuDnpq9s/aYmXt5gKnvmD54I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=axX9eOoIO71Ic4j8guBugetAWN/9JyY6a1Cj90/c07CGNIw9VU5oVHz6x6ONVPL6Rf9a/iKmDgoq3NtkWJB94ijtHiKmnFXR64CWkvWleDYRhAcB5a3ktlDBTlO9vCAoRzXE7DqYHjymyydCRRax+ZBAcfcioQ2v6XXH3XtKJXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=none smtp.mailfrom=cc.itu.edu.tr; arc=none smtp.client-ip=45.249.212.188; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=pass smtp.client-ip=160.75.25.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cc.itu.edu.tr
Received: from lesvatest1.cc.itu.edu.tr (lesvatest1.cc.itu.edu.tr [10.146.128.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by beeline3.cc.itu.edu.tr (Postfix) with ESMTPS id C730F40CEC89
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 18:01:08 +0300 (+03)
X-Envelope-From: <root@cc.itu.edu.tr>
Received: from lesva1.cc.itu.edu.tr (unknown [160.75.70.79])
	by lesvatest1.cc.itu.edu.tr (Postfix) with ESMTP id 4Z6f3D1tQSzFy9L
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 17:59:20 +0300 (+03)
Received: by le1 (Postfix, from userid 0)
	id F327242749; Tue,  4 Mar 2025 17:59:17 +0300 (+03)
X-Envelope-From: <linux-kernel+bounces-541085-bozkiru=itu.edu.tr@vger.kernel.org>
Received: from fgw2.itu.edu.tr (fgw2.itu.edu.tr [160.75.25.104])
	by le2 (Postfix) with ESMTP id 4641B41F78
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 10:21:13 +0300 (+03)
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by fgw2.itu.edu.tr (Postfix) with SMTP id D63212DCE5
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 10:21:12 +0300 (+03)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 994293AD3DB
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 07:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFEC31EA7D4;
	Mon,  3 Mar 2025 07:20:59 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556F512B93;
	Mon,  3 Mar 2025 07:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740986458; cv=none; b=upUs85v3Yqwa4h8Pb270klm+aX+Fp2wQ/PQZIpyHDUV39EXdfiUvbsv37rtGVOLXvYTfiUa8RxUT/KT5wlesKUW4DqQOXoRBsJLanWfPhs+VpURAU03cxmG2mpxZe6o34ZUIIjUqMsql2lmuvY8d9TRaBSHrIKZaKeHdygcZs3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740986458; c=relaxed/simple;
	bh=AffzCFirDGYzwyBd4MxRuDnpq9s/aYmXt5gKnvmD54I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P6mWwbUL/8zG+M8HCNa8hdVnZ/Zo9PGfPAiWs8Mv+ZAYhYl4Y8x1hzeROiXoWmK2AUN0DMpOg4LdiCb/8XP/VoRwH06xjSrvMZYa8qLpXCC8vahAX8f+VnS15APOIgOLQFQQlshcEiC5LmI7Lj76uZsb0DCqkEOnEqvD/2sn6c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Z5qrf0lSLzCs7T;
	Mon,  3 Mar 2025 15:17:22 +0800 (CST)
Received: from kwepemd100010.china.huawei.com (unknown [7.221.188.107])
	by mail.maildlp.com (Postfix) with ESMTPS id DCD501402C8;
	Mon,  3 Mar 2025 15:20:50 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (7.221.188.25) by
 kwepemd100010.china.huawei.com (7.221.188.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 3 Mar 2025 15:20:50 +0800
Received: from kwepemd500012.china.huawei.com ([7.221.188.25]) by
 kwepemd500012.china.huawei.com ([7.221.188.25]) with mapi id 15.02.1258.034;
 Mon, 3 Mar 2025 15:20:50 +0800
From: lizetao <lizetao1@huawei.com>
To: Caleb Sander Mateos <csander@purestorage.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Subject: RE: [PATCH 1/5] io_uring/rsrc: split out io_free_node() helper
Thread-Topic: [PATCH 1/5] io_uring/rsrc: split out io_free_node() helper
Thread-Index: AQHbijzkEG092hh2Z0Cp4En6e2dDUbNhAimg
Date: Mon, 3 Mar 2025 07:20:50 +0000
Message-ID: <18e5b97243724652998257c52be8cc49@huawei.com>
References: <20250228235916.670437-1-csander@purestorage.com>
In-Reply-To: <20250228235916.670437-1-csander@purestorage.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ITU-Libra-ESVA-Information: Please contact Istanbul Teknik Universitesi for more information
X-ITU-Libra-ESVA-ID: 4Z6f3D1tQSzFy9L
X-ITU-Libra-ESVA: No virus found
X-ITU-Libra-ESVA-From: root@cc.itu.edu.tr
X-ITU-Libra-ESVA-Watermark: 1741705177.26034@JLuASIM2bmpPpHNLjJ5QUg
X-ITU-MailScanner-SpamCheck: not spam

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2FsZWIgU2FuZGVy
IE1hdGVvcyA8Y3NhbmRlckBwdXJlc3RvcmFnZS5jb20+DQo+IFNlbnQ6IFNhdHVyZGF5LCBNYXJj
aCAxLCAyMDI1IDc6NTkgQU0NCj4gVG86IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz47IFBh
dmVsIEJlZ3Vua292IDxhc21sLnNpbGVuY2VAZ21haWwuY29tPg0KPiBDYzogQ2FsZWIgU2FuZGVy
IE1hdGVvcyA8Y3NhbmRlckBwdXJlc3RvcmFnZS5jb20+OyBpby0NCj4gdXJpbmdAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQQVRDSCAx
LzVdIGlvX3VyaW5nL3JzcmM6IHNwbGl0IG91dCBpb19mcmVlX25vZGUoKSBoZWxwZXINCj4gDQo+
IFNwbGl0IHRoZSBmcmVlaW5nIG9mIHRoZSBpb19yc3JjX25vZGUgZnJvbSBpb19mcmVlX3JzcmNf
bm9kZSgpLCBmb3IgdXNlIHdpdGgNCj4gbm9kZXMgdGhhdCBoYXZlbid0IGJlZW4gZnVsbHkgaW5p
dGlhbGl6ZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYWxlYiBTYW5kZXIgTWF0ZW9zIDxjc2Fu
ZGVyQHB1cmVzdG9yYWdlLmNvbT4NCj4gLS0tDQo+ICBpb191cmluZy9yc3JjLmMgfCA5ICsrKysr
KystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9pb191cmluZy9yc3JjLmMgYi9pb191cmluZy9yc3JjLmMgaW5k
ZXggNDViZmIzN2JjYTFlLi5kOTQxMjU2ZjBkOGMNCj4gMTAwNjQ0DQo+IC0tLSBhL2lvX3VyaW5n
L3JzcmMuYw0KPiArKysgYi9pb191cmluZy9yc3JjLmMNCj4gQEAgLTQ4NSwxMCArNDg1LDE2IEBA
IGludCBpb19maWxlc191cGRhdGUoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkIGludA0K
PiBpc3N1ZV9mbGFncykNCj4gIAkJcmVxX3NldF9mYWlsKHJlcSk7DQo+ICAJaW9fcmVxX3NldF9y
ZXMocmVxLCByZXQsIDApOw0KPiAgCXJldHVybiBJT1VfT0s7DQo+ICB9DQo+IA0KPiArc3RhdGlj
IHZvaWQgaW9fZnJlZV9ub2RlKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4LCBzdHJ1Y3QgaW9fcnNy
Y19ub2RlDQo+ICsqbm9kZSkgew0KDQpXb3VsZCBpdCBiZSBiZXR0ZXIgdG8gdGFrZSBhIGlvX2Fs
bG9jX2NhY2hlIGFzIHBhcmFtZXRlciBhbmQgcHV0IGl0IGludG8gYWxsb2NfY2FjaGUuaCANCmFz
IGEgZ2VuZXJhbCBmdW5jdGlvbiwgc28gb3RoZXIgbW9kdWxlcyBjYW4gdXNlIGl0IHRvbywganVz
dCBsaWtlIGlvX3VyaW5nL2Z1dGV4Lg0KDQo+ICsJaWYgKCFpb19hbGxvY19jYWNoZV9wdXQoJmN0
eC0+bm9kZV9jYWNoZSwgbm9kZSkpDQo+ICsJCWt2ZnJlZShub2RlKTsNCj4gK30NCj4gKw0KPiAg
dm9pZCBpb19mcmVlX3JzcmNfbm9kZShzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCwgc3RydWN0IGlv
X3JzcmNfbm9kZSAqbm9kZSkgIHsNCj4gIAlpZiAobm9kZS0+dGFnKQ0KPiAgCQlpb19wb3N0X2F1
eF9jcWUoY3R4LCBub2RlLT50YWcsIDAsIDApOw0KPiANCj4gQEAgLTUwNCwxMiArNTEwLDExIEBA
IHZvaWQgaW9fZnJlZV9yc3JjX25vZGUoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsDQo+IHN0cnVj
dCBpb19yc3JjX25vZGUgKm5vZGUpDQo+ICAJZGVmYXVsdDoNCj4gIAkJV0FSTl9PTl9PTkNFKDEp
Ow0KPiAgCQlicmVhazsNCj4gIAl9DQo+IA0KPiAtCWlmICghaW9fYWxsb2NfY2FjaGVfcHV0KCZj
dHgtPm5vZGVfY2FjaGUsIG5vZGUpKQ0KPiAtCQlrdmZyZWUobm9kZSk7DQo+ICsJaW9fZnJlZV9u
b2RlKGN0eCwgbm9kZSk7DQo+ICB9DQo+IA0KPiAgaW50IGlvX3NxZV9maWxlc191bnJlZ2lzdGVy
KHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4KSAgew0KPiAgCWlmICghY3R4LT5maWxlX3RhYmxlLmRh
dGEubnIpDQo+IC0tDQo+IDIuNDUuMg0KPiANCg0KLS0tDQpMaSBaZXRhbw0KDQo=


