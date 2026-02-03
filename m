Return-Path: <io-uring+bounces-12031-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oKr1AGfCgWmFJgMAu9opvQ
	(envelope-from <io-uring+bounces-12031-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 10:39:51 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B84CDD6E84
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 10:39:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4DA1C3026082
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 09:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA160396D30;
	Tue,  3 Feb 2026 09:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AQfoS9HS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDD2396D1A
	for <io-uring@vger.kernel.org>; Tue,  3 Feb 2026 09:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770111579; cv=none; b=rqg186rWrRuIQtXI3ZzCyyLTvT3Mk9xS8V5rip+qUlfng+tBH3XwKWlsRRdKJTL3RCHlJ6lMn8G/y2UEo5W45FgHGwKrOHX7joN+lFYpZ87JNBRf2+i6kJy8G0brnaMLSTN3wqACDyZi9CQHSdo5PCozjYuPPyFds68aTTZyliw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770111579; c=relaxed/simple;
	bh=LpxeijDBG4t6PJTWf+A+CI6IG2cvGYrY4SR+epbpwSQ=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RKMxRwRu41HURQUgA6epFrq+QNt5RuGluK+x+HPbUh+/IBBRT8vTp5K3WG+retTNlXTZ8Ex93EebeWscQlA5T1rF+JazWZwhphFTLqVv2L6AFDOEg82dbtB2uiM/QZO7sV/pSp0W49uKFJi7+z8QGIMMAmhRPBQ8QcTe4/te4J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AQfoS9HS; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-649488dc7bdso4861578d50.0
        for <io-uring@vger.kernel.org>; Tue, 03 Feb 2026 01:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770111577; x=1770716377; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:msip_labels:content-language
         :accept-language:message-id:date:thread-index:thread-topic:subject
         :cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LpxeijDBG4t6PJTWf+A+CI6IG2cvGYrY4SR+epbpwSQ=;
        b=AQfoS9HS/4A8lsJ664tmJMcUAmJhVeYlgQNA46wSRyW7bjBdyVA/oB0d6a5ARxZ9cf
         e2NFk+2+nOObXHnAJymHKwUvVVP0LGVYS32oK34qDvYcwc/BPoXtyzYv3G47WhWrl91L
         abMKDBlMT8rt3Z5WldDpLObNsSx+Ha1OVUedQI8luEz6/X22rMEGE0T2r6fbi2ff2KZi
         URuEk0o/gIG84ybIeWnkB4DtYoMLMGKFlcsqgMWcRRZaVQQI+JtQVvaYj0ALfrfUVLg2
         Rb3/tp492q5iAk2Aw1WpkKZrZBKKQENSHG8aJu+zTmuzGgK+IGDQn2nOJywikBSuI4Bh
         NvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770111577; x=1770716377;
        h=mime-version:content-transfer-encoding:msip_labels:content-language
         :accept-language:message-id:date:thread-index:thread-topic:subject
         :cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpxeijDBG4t6PJTWf+A+CI6IG2cvGYrY4SR+epbpwSQ=;
        b=vjmJBAlfqrLtY+eQv2SPlJ0j7sQ2yQmZeMgGeL4IFrCEhj42YWhS74CP0kgyiZM9EV
         c5A+MyJ/ypE6qhLn2t0p4hPCAHyC7l7jlRXeL8oizCkRyb9jk1apgdNdmKKTTgNb9Rk3
         vQTN46iZ6hdjdidyBI0Y2n6Sr30AIS557ABW8IODOM0iltnR2n1JNeo0jBqu4yjynPq8
         VPXHqvg8u5//9kWiHUHz+CZlQxM53tvXoiGY2E4i06x+j4Gvc3Q3ccuHTWm/b8kw7Rho
         bNBSuJyontn5d7Nhkc/ek+4h+rmLlYhkj/I1r903aRbWeyJbkIFA9lufztzR557pV1i7
         MSPQ==
X-Gm-Message-State: AOJu0YyM9aC6ddZQNfDbgkZ19h4mf9arpONpDZvk45dUYq2627bvE0aH
	U0Nid98Za+R0VMH5Cfliz2yUq+Wxs1E36nAC8HZZ4DPS7JxLgoM3a4ED8ySJkQxZ
X-Gm-Gg: AZuq6aI3sTFTKHWS6jP2c3VnApiERYqyVJzrwuVC4Ba9FnebUZ05FwzHHzgTRyZEqeK
	DYw3Y2v7JaK9k8ltRwXHdE1CKuhnuWnEUtnMIc3BkDxoJUaxVd7njX0bi1FxdslrfBolqvqJf+q
	YUdNR1RMJn5GrmwChhi7Ni0i9UykNVUwAKSP7aGcw9MEpin0TPh4+FHeexq//uA4SVjhog/SUuQ
	H9diKwc4Y0vqM98eM+HRtI6+mnbDT6AUswruFB/fEwEQCEnj0s1n3DTZ7EaT0eGIWhUJsnj9TRs
	2GjBRMrLY25u7kl13ePJBlO00tZQ2b5lXNjY9WwJMwN/nc+TpWn1x4W9ZTo/vt7a8KctOqZR5RT
	IonkyhaEUwou/l0LDdK1OhmcfVF/9CUD5lH2S0n7QG/sRmHTQHIf22GiJmUsNH4EPK4JII4kgER
	WIFIHvwMdqJBJ9WKW64W3NbpULQ1fQty1Ok6tj0w==
X-Received: by 2002:a05:690e:b4a:b0:649:b943:2cc3 with SMTP id 956f58d0204a3-649b9432f6emr7748248d50.15.1770111577168;
        Tue, 03 Feb 2026 01:39:37 -0800 (PST)
Received: from PS1PPF7E1D7501F.apcprd02.prod.outlook.com ([2603:1046:a00:12::b])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-649960efd95sm11418836d50.18.2026.02.03.01.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 01:39:36 -0800 (PST)
From: =?gb2312?B?yseyzrLu?= <shicenci@gmail.com>
To: io-uring <io-uring@vger.kernel.org>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [BUG] soft lockup in seq_read while reading io_uring fdinfo
Thread-Topic: [BUG] soft lockup in seq_read while reading io_uring fdinfo
Thread-Index: AQHclPC0mHI7iiYkWESE6ihzUMhUtA==
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Tue, 3 Feb 2026 09:39:32 +0000
Message-ID:
	<PS1PPF7E1D7501FE5631002D242DD89403FAB9BA@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator:
X-MS-Exchange-Organization-RecordReviewCfmType: 0
msip_labels:
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.06 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12031-lists,io-uring=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shicenci@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pastebin.com:url,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,PS1PPF7E1D7501F.apcprd02.prod.outlook.com:mid]
X-Rspamd-Queue-Id: B84CDD6E84
X-Rspamd-Action: no action

SGksCgpJoa9tIHJlcG9ydGluZyBhIHJlcHJvZHVjaWJsZSBzb2Z0IGxvY2t1cCBvYnNlcnZlZCBp
biB0aGUgc2VxX2ZpbGUgcmVhZCBwYXRoIHdoZW4gcmVhZGluZyBpb191cmluZyBmZGluZm8gdmlh
IHByb2Nmcy4KClRoZSBsb2NrdXAgaXMgdHJpZ2dlcmVkIGJ5IGEgc3l6a2FsbGVyIEMgcmVwcm9k
dWNlciB0aGF0OgoKY3JlYXRlcyBhbiBpb191cmluZyBpbnN0YW5jZSB3aXRoIGEgbGFyZ2UgbnVt
YmVyIG9mIGVudHJpZXMsIGFuZCB0aGVuCgpyZWFkcyAvcHJvYy90aHJlYWQtc2VsZi9mZGluZm8v
PHVyaW5nX2ZkPi4KClRoZSB3YXRjaGRvZyByZXBvcnRzIGEgc29mdCBsb2NrdXAgd2l0aCBDUFUg
c3R1Y2sgaW4gX19zYW5pdGl6ZXJfY292X3RyYWNlX3BjKCkgd2hpbGUgdGhlIHRhc2sgaXMgZXhl
Y3V0aW5nIHNlcV9yZWFkKCkgLT4gaW9fdXJpbmdfc2hvd19mZGluZm8oKS4KCkFub3RoZXIgQ1BV
IGNvbmN1cnJlbnRseSBzaG93cyBhbiBOTUkgYmFja3RyYWNlIHN0dWNrIGluIEtGRU5DRaGvcyB0
b2dnbGVfYWxsb2NhdGlvbl9nYXRlKCkgcGF0aCwgZ29pbmcgdGhyb3VnaCBqdW1wX2xhYmVsX3Vw
ZGF0ZSgpIGFuZCBzbXBfdGV4dF9wb2tlX3N5bmNfZWFjaF9jcHUoKS4gVGhpcyBzdWdnZXN0cyBh
IHBvdGVudGlhbCBpbnRlcmFjdGlvbiBiZXR3ZWVuIGhlYXZ5IGZkaW5mbyBzZXFfcHJpbnRmIG91
dHB1dCB1bmRlciBLQ09WIGluc3RydW1lbnRhdGlvbiBhbmQgS0ZFTkNFoa9zIGp1bXBfbGFiZWwv
dGV4dF9wb2tlIHN5bmNocm9uaXphdGlvbi4KClJlcHJvZHVjZXI6CgpDIHJlcHJvZHVjZXI6IGh0
dHBzOi8vcGFzdGViaW4uY29tL3Jhdy9NeGtzaW1aaAoKY29uc29sZSBvdXRwdXQ6IGh0dHBzOi8v
cGFzdGViaW4uY29tL3Jhdy9aZ3dSTmVUYwoKa2VybmVsIGNvbmZpZzogaHR0cHM6Ly9wYXN0ZWJp
bi5jb20vcmF3L3FCWUd5VXpECgpLZXJuZWw6CgpIRUFEIGNvbW1pdDogNjM4MDRmZWQxNDlhNjc1
MGZmZDI4NjEwYzVjMWM5OGNjZTZiZDM3NwoKIGdpdCB0cmVlOiB0b3J2YWxkcy9saW51eCAgCgpr
ZXJuZWwgdmVyc2lvbjogNi4xOS4wLXJjNyAjMiBQUkVFTVBUKHZvbHVudGFyeSkgKFFFTVUgVWJ1
bnR1IDI0LjEwKQoKCndhdGNoZG9nOiBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzEgc3R1Y2sgZm9y
IDIycyEgW3N5ei4zLjE3OjEyMjZdCk1vZHVsZXMgbGlua2VkIGluOgpDUFU6IDEgVUlEOiAwIFBJ
RDogMTIyNiBDb21tOiBzeXouMy4xNyBOb3QgdGFpbnRlZCA2LjE5LjAtcmM3ICMyIFBSRUVNUFQo
dm9sdW50YXJ5KQpIYXJkd2FyZSBuYW1lOiBRRU1VIFVidW50dSAyNC4xMCBQQyAoaTQ0MEZYICsg
UElJWCwgMTk5NiksIEJJT1MgMS4xNi4zLWRlYmlhbi0xLjE2LjMtMiAwNC8wMS8yMDE0ClJJUDog
MDAxMDpfX3Nhbml0aXplcl9jb3ZfdHJhY2VfY29uc3RfY21wMSsweDgvMHgyMCBrZXJuZWwva2Nv
di5jOjMwMApDb2RlOiAwMCAwMCBmMyAwZiAxZSBmYSA0OCA4YiAwYyAyNCA0OCA4OSBmMiA0OCA4
OSBmZSBiZiAwNiAwMCAwMCAwMCBlOSAxOCBmZiBmZiBmZiAwZiAxZiA4NCAwMCAwMCAwMCAwMCAw
MCBmMyAwZiAxZSBmYSA0OCA4YiAwYyAyNCA8NDA+IDBmIGI2IGQ2IDQwIDBmIGI2IGY3IGJmIDAx
IDAwIDAwIDAwIGU5IGY2IGZlIGZmIGZmIDY2IDBmIDFmIDQ0ClJTUDogMDAxODpmZmZmYzkwMDA0
M2JmNzYwIEVGTEFHUzogMDAwMDAyNDYKUkFYOiAwMDAwMDAwMDNhNzM2NTAwIFJCWDogZmZmZmZm
ZmY4NTBhZmUyMSBSQ1g6IGZmZmZmZmZmODRjZDY5YjAKUkRYOiBmZmZmODg4MDBjOWEzYmMwIFJT
STogMDAwMDAwMDAwMDAwMDA3MyBSREk6IDAwMDAwMDAwMDAwMDAwMjUKUkJQOiBmZmZmYzkwMDA0
M2JmODEwIFIwODogMDAwMDAwMDAzYTczNjUwMCBSMDk6IGZmZmZmZmZmODRjZDY5YTMKUjEwOiAw
MDAwMDAwMDAwMDAwMDAxIFIxMTogZmZmZmM5MDA0OGM0ZDAzNyBSMTI6IGZmZmZjOTAwMDQzYmY4
YTAKUjEzOiBmZmZmZmZmZjg1MGFmZTFiIFIxNDogZGZmZmZjMDAwMDAwMDAwMCBSMTU6IDAwMDAw
MDAwMDAwMDAwNzMKRlM6IDAwMDA3ZjI0ZjkwZmU1MDAoMDAwMCkgR1M6ZmZmZjg4ODBlNWI1MjAw
MCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwCkNTOiAwMDEwIERTOiAwMDAwIEVTOiAwMDAw
IENSMDogMDAwMDAwMDA4MDA1MDAzMwpDUjI6IDAwMDA1NTkzZTE3M2QxMzAgQ1IzOiAwMDAwMDAw
MDBmNzE2MDAwIENSNDogMDAwMDAwMDAwMDM1MGVmMApDYWxsIFRyYWNlOgogPFRBU0s+CiBmb3Jt
YXRfZGVjb2RlKzB4MTkwLzB4YzgwIGxpYi92c3ByaW50Zi5jOjI2OTIKIHZzbnByaW50ZisweDE4
Ni8weDExNjAgbGliL3ZzcHJpbnRmLmM6Mjg4OQogc2VxX3ZwcmludGYrMHhlNi8weDFhMCBmcy9z
ZXFfZmlsZS5jOjM5MQogc2VxX3ByaW50ZisweGJlLzB4ZjAgZnMvc2VxX2ZpbGUuYzo0MDYKIF9f
aW9fdXJpbmdfc2hvd19mZGluZm8gaW9fdXJpbmcvZmRpbmZvLmM6MTU4IFtpbmxpbmVdCiBpb191
cmluZ19zaG93X2ZkaW5mbysweDlhNy8weDE5MjAgaW9fdXJpbmcvZmRpbmZvLmM6MjYxCiBzZXFf
c2hvdysweDQ2OS8weDczMCBmcy9wcm9jL2ZkLmM6NjgKIHNlcV9yZWFkX2l0ZXIrMHg0Y2MvMHgx
MWQwIGZzL3NlcV9maWxlLmM6MjMwCiBzZXFfcmVhZCsweDM5MS8weDU3MCBmcy9zZXFfZmlsZS5j
OjE2MgogdmZzX3JlYWQgZnMvcmVhZF93cml0ZS5jOjU3MCBbaW5saW5lXQogdmZzX3JlYWQrMHgx
ZjkvMHhjOTAgZnMvcmVhZF93cml0ZS5jOjU1Mgoga3N5c19yZWFkKzB4MTIxLzB4MjQwIGZzL3Jl
YWRfd3JpdGUuYzo3MTUKIGRvX3N5c2NhbGxfeDY0IGFyY2gveDg2L2VudHJ5L3N5c2NhbGxfNjQu
Yzo2MyBbaW5saW5lXQogZG9fc3lzY2FsbF82NCsweGFjLzB4M2IwIGFyY2gveDg2L2VudHJ5L3N5
c2NhbGxfNjQuYzo5NAogZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NGIvMHg1MwpS
SVA6IDAwMzM6MHg3ZjI0ZjgzOGViZTkKQ29kZTogZmYgZmYgYzMgNjYgMmUgMGYgMWYgODQgMDAg
MDAgMDAgMDAgMDAgMGYgMWYgNDAgMDAgNDggODkgZjggNDggODkgZjcgNDggODkgZDYgNDggODkg
Y2EgNGQgODkgYzIgNGQgODkgYzggNGMgOGIgNGMgMjQgMDggMGYgMDUgPDQ4PiAzZCAwMSBmMCBm
ZiBmZiA3MyAwMSBjMyA0OCBjNyBjMSBhOCBmZiBmZiBmZiBmNyBkOCA2NCA4OSAwMSA0OA==

