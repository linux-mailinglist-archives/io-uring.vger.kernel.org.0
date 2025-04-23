Return-Path: <io-uring+bounces-7677-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25DA2A995DB
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 18:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47C35464E02
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 16:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F29289361;
	Wed, 23 Apr 2025 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mPzcQCG6"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DD6289365
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745427325; cv=none; b=DjgQRTpqRdKqC4kjXOn/GQ/YEvBITeRxBPzGwcV3XU8EEVSk9VOj5ZvK7Xkyyfh0eE3Ia72/bcmcqDWq+fe/6fDKumQg2ZBXihhbZYsITYbbHheE7p7vgqtfpAYKorLi3WQ5t3EYr9FV9vjHvsN7TRcmZRVs0LVcSQ5Zws6NqdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745427325; c=relaxed/simple;
	bh=A11/peS6kZX9tj2ElDQ1EA4SMXruAGjD5F6ZSeqVDQQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:Content-Type:
	 References; b=MKc9NITjcSKee9IC2CHWIKe7ZPQKkzzzBPaNpcRRFyvCEKDGGO912DS5Jof94JMfXq+Y8dM6QPpQ/D7F6j8CI5ngokIAx1EoHR7e+UmSa849qkm+9qDvR+KNZt1n3LXUeCNOuhP4iLJpYcW2l2jbT18QCrh3/LmAZO/a9DinoTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mPzcQCG6; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250423165521epoutp0372a42b28cbd1663a5771b37704cae1b5~5AObDg2Un2650226502epoutp03A
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 16:55:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250423165521epoutp0372a42b28cbd1663a5771b37704cae1b5~5AObDg2Un2650226502epoutp03A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1745427321;
	bh=Mr3kAylUOnNBLmfwrYt2uePnmGxpGlJl1HgmzmZ2U64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPzcQCG6zjjFn1orvLpnS8kFt/PJICTyLjIiPlc4rSa4CfgiaBB7Mn6PioJyKJCZm
	 ee7XoczPHhM3H4lSqQlNcLYggW6W9CKxa/jY8Thbj3mcYVwWPw2LGKzngCBXmTxgDL
	 kkq/xGP50bV938mWC7bpSxNfDlQxdEK4unhVINNE=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250423165520epcas5p3a277b6d20b8ebf8c0d56e5bbcdcb95d8~5AOaYGfd12151221512epcas5p3N;
	Wed, 23 Apr 2025 16:55:20 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.178]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4ZjQFz13Hwz3hhT7; Wed, 23 Apr
	2025 16:55:19 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250423133646epcas5p2e67808b13c6c85444b8a9f28995fe70b~49hB_XNJ62945129451epcas5p2U;
	Wed, 23 Apr 2025 13:36:46 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250423133646epsmtrp1e9b9d0dd33a1dfd06701c3fe3f32c29f~49hB92MtC1559715597epsmtrp1Q;
	Wed, 23 Apr 2025 13:36:46 +0000 (GMT)
X-AuditID: b6c32a28-460ee70000001e8a-aa-6808ecee62d5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AF.A1.07818.EECE8086; Wed, 23 Apr 2025 22:36:46 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
	[107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250423133645epsmtip29d82378bbe6daaaaa1227bd04343159c~49hBM6NFM0644506445epsmtip2h;
	Wed, 23 Apr 2025 13:36:45 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: io-uring@vger.kernel.org
Cc: gost.dev@samsung.com, nitheshshetty@gmail.com, Nitesh Shetty
	<nj.shetty@samsung.com>
Subject: [PATCH liburing 3/3] test/fixed-seg: Support non 512 LBA format
 devices.
Date: Wed, 23 Apr 2025 18:57:52 +0530
Message-Id: <20250423132752.15622-4-nj.shetty@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250423132752.15622-1-nj.shetty@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsWy7bCSvO67NxwZBt93clncPLCTyeJd6zkW
	ix1PGhkttv2ez+zA4rFz1l12j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MqYfOQhS8Ffroqz
	T5vYGxj3cXQxcnBICJhIzLkr2cXIxSEksJtRYvbXhyxdjJxAcUmJZX+PMEPYwhIr/z1nhyhq
	ZpKYduAzG0gzm4C2xOn/HCA1IgIyEtNnLmIEsZkFYiROtkxlArGFBQIlnvatBYuzCKhK7NgO
	YfMKWEl8a57IBDFfXmL1hgNguzgFrCVe7l8HViMEVHOso4dtAiPfAkaGVYySqQXFuem5yYYF
	hnmp5XrFibnFpXnpesn5uZsYwQGkpbGD8d23Jv1DjEwcjIcYJTiYlUR4f7mxZwjxpiRWVqUW
	5ccXleakFh9ilOZgURLnXWkYkS4kkJ5YkpqdmlqQWgSTZeLglGpgamTQWJGknW/1f/bf8xUZ
	zNP/vZjkd+j+q+AHh00EtC0KeffP/Xf85/0L15V6qiuMYgIcFC/lbX1w+S6P07uZ9VOzPZW+
	p9qevKzQJLFEoTz/smlMx/+tUbMX2m+9cpz7TTe3TUjn0RlpPLNX5xnI1eeUiadOTnot2WO8
	5yz3k3sz/B9NEciddGTT3S7/uUU9flc/iqRPe1f+9eH6k7POZdcv499Vnps5Kyx3hcAex9WW
	e/3MKk6cO2HUEZtfuW9RaPfVwN8GUw78urZKMunB2R9e1co7mb83OFo+D5vY1STMU+kd/ucW
	myK7+VXnMoeN+/eueRXj/J2Te/2WDp0XGcfeuFstUVB6KBu292PhTCWW4oxEQy3mouJEAH/I
	LXWPAgAA
X-CMS-MailID: 20250423133646epcas5p2e67808b13c6c85444b8a9f28995fe70b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250423133646epcas5p2e67808b13c6c85444b8a9f28995fe70b
References: <20250423132752.15622-1-nj.shetty@samsung.com>
	<CGME20250423133646epcas5p2e67808b13c6c85444b8a9f28995fe70b@epcas5p2.samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

At present test succeeds only for 512 LBA format device.
Now 4k LBA formatted device should also pass.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 test/fixed-seg.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/test/fixed-seg.c b/test/fixed-seg.c
index ab1d359..63b1cee 100644
--- a/test/fixed-seg.c
+++ b/test/fixed-seg.c
@@ -9,6 +9,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/time.h>
+#include <sys/ioctl.h>
 #include "liburing.h"
 #include "helpers.h"
 
@@ -87,7 +88,7 @@ int main(int argc, char *argv[])
 	struct io_uring ring;
 	const char *fname;
 	char buf[256];
-	int fd, rnd_fd, ret;
+	int fd, rnd_fd, ret, vec_off = 512;
 
 	if (argc > 1) {
 		fname = argv[1];
@@ -104,6 +105,7 @@ int main(int argc, char *argv[])
 		perror("open");
 		return 1;
 	}
+	ioctl(fd, BLKSSZGET, &vec_off);
 
 	rnd_fd = open("/dev/urandom", O_RDONLY);
 	if (fd < 0) {
@@ -143,14 +145,13 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
-	ret = test(&ring, fd, 512);
+	ret = test(&ring, fd, vec_off);
 	if (ret) {
-		fprintf(stderr, "test 512 failed\n");
+		fprintf(stderr, "test %d failed\n", vec_off);
 		goto err;
 	}
 
-	ret = test(&ring, fd, 3584);
-	if (ret) {
+	if ((vec_off == 512) && test(&ring, fd, 3584)) {
 		fprintf(stderr, "test 3584 failed\n");
 		goto err;
 	}
-- 
2.43.0


