Return-Path: <io-uring+bounces-7676-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23389A995DA
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 18:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F08EE464DB4
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 16:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F7E289359;
	Wed, 23 Apr 2025 16:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fWdrsdcQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C87289342
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 16:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745427322; cv=none; b=PU29BRahMmei9ZWkPVt5er++2q5gH+YgVVnl5X8CA9tkx7voBVSBmTI5p4Up0ROvQlhQQAogZKv+MEKtw6lemnROhyxqLOLoTeX9yDuJ1x2KjM1V6tf/Cz1EIKhqNeFgbJS3HJ2YfsejjSf/WLrRpgtBFVcDkqNle1QlcBrDEdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745427322; c=relaxed/simple;
	bh=imJYhwO7GxhBaj6MLITcvkROp2tbHN21/pMsPqRGef4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:Content-Type:
	 References; b=SJHT1sEfrsW9WbmTEH5WBXkjGSi8HFfUh9Hnu67Zqn/ZQRqgXXrcPzL2I+4LCb3TgqpouOspRZ0yNHpmfG+1A+yNKh39FVfWZapDoHzChIIiPVSGhAWrzIvqfcD+GZUmmVwr1N3pvnRcehn+fQN1VJ2FIy3CO+jubmVFUYtAL60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fWdrsdcQ; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250423165517epoutp01411823620d77f5f40902545cd9bcbcdd~5AOXVgPV22297022970epoutp01V
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 16:55:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250423165517epoutp01411823620d77f5f40902545cd9bcbcdd~5AOXVgPV22297022970epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1745427317;
	bh=kX1rWIAmcHVPxvB+WwNSI0HLhXiBhT/G3tQQvosMoOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWdrsdcQhqVoJAsTz+FFwjEntywu5A5YgwkXlFKZ3tZ/h6hpHW2xnznGEKceJRkVC
	 keKX7mbpjfgT5NgKct/fDy/BHARDkwJfoilGl05TwiO9c6rfZCz2XqU8PgqkVfrZK/
	 E0HyeOdJfW9yd+WBykCseUJGU0sLebhiw2dmTHSE=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250423165517epcas5p2931a142c1abebcd8858a441c4b9e9022~5AOXB8dy40778607786epcas5p2t;
	Wed, 23 Apr 2025 16:55:17 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.182]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4ZjQFv3JM9z6B9m6; Wed, 23 Apr
	2025 16:55:15 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250423133642epcas5p1bef7e3af23bd8561f359ccc16fdaf980~49g_1buP02149821498epcas5p1O;
	Wed, 23 Apr 2025 13:36:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250423133642epsmtrp10ad7fbf6a7952da99708c9292e7c5a78~49g_05dxV1559715597epsmtrp1O;
	Wed, 23 Apr 2025 13:36:42 +0000 (GMT)
X-AuditID: b6c32a29-55afd7000000223e-f7-6808ecea0bd0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9B.F3.08766.AECE8086; Wed, 23 Apr 2025 22:36:42 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
	[107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250423133642epsmtip2fc34975cdbe3479221fe9a5ee900929c~49g_EcRSI0818308183epsmtip2T;
	Wed, 23 Apr 2025 13:36:41 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: io-uring@vger.kernel.org
Cc: gost.dev@samsung.com, nitheshshetty@gmail.com, Nitesh Shetty
	<nj.shetty@samsung.com>
Subject: [PATCH liburing 2/3] test/fixed-seg: verify the data read
Date: Wed, 23 Apr 2025 18:57:51 +0530
Message-Id: <20250423132752.15622-3-nj.shetty@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250423132752.15622-1-nj.shetty@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsWy7bCSvO6rNxwZBnt2GFrcPLCTyeJd6zkW
	ix1PGhkttv2ez+zA4rFz1l12j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mr4PWMPe8FtgYpH
	5/4wNjD28HYxcnJICJhI/N9+lrGLkYtDSGA3o0TDmxdMEAlJiWV/jzBD2MISK/89Z4coamaS
	uPNjE1sXIwcHm4C2xOn/HCA1IgIyEtNnLmIEsZkFYiROtkwFmyMs4CRx9uw1VhCbRUBVYt/k
	drCZvAJWEocOnYTaJS+xesMBsDingLXEy/3rwOYIAdUc6+hhm8DIt4CRYRWjZGpBcW56brFh
	gWFearlecWJucWleul5yfu4mRnAIaWnuYNy+6oPeIUYmDsZDjBIczEoivL/c2DOEeFMSK6tS
	i/Lji0pzUosPMUpzsCiJ84q/6E0REkhPLEnNTk0tSC2CyTJxcEo1ME1+dW+Bvm8Pi0RXwZuD
	TV7/Tt3XK+3O5Dcz+Tv1pk7AvqjJa+4aTOOeoPCbw0yZmUM0dcbPPz+64oKjI9W+ZW2/McX7
	P5f0jCYtA5njD+yfnzOz0Hs0OSHJNSendO3Zr+e9gluKTSyO2RzIe7Zuj0OX/rUDf7w+yNzR
	nZkTWHb7GufqR1sFJF9P+anRtaGuOOq8reu/pMgik6pYa+FpE56u4D4m2ZsqIxnZ/+RHqRzj
	4WJDLZPgGyHd35O97Y7MuX0/715LyXO/DjnDVbYSBh8/iHrn8H+cP3Fx4o4Pk5rqWdKmc6kq
	XvAzqrodtnid3N6lFnVbRBpkBRT7TF/uOrz/K/tCpntGFvNuzZptpcRSnJFoqMVcVJwIAPq+
	KW+QAgAA
X-CMS-MailID: 20250423133642epcas5p1bef7e3af23bd8561f359ccc16fdaf980
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250423133642epcas5p1bef7e3af23bd8561f359ccc16fdaf980
References: <20250423132752.15622-1-nj.shetty@samsung.com>
	<CGME20250423133642epcas5p1bef7e3af23bd8561f359ccc16fdaf980@epcas5p1.samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Write before reading the data. This written data
will be used for comparision later to verification.
To avoid running test on block device in use by system (e.g, mounted),
O_EXCL is added while opening file.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 test/fixed-seg.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/test/fixed-seg.c b/test/fixed-seg.c
index 83e4b13..ab1d359 100644
--- a/test/fixed-seg.c
+++ b/test/fixed-seg.c
@@ -12,7 +12,7 @@
 #include "liburing.h"
 #include "helpers.h"
 
-static struct iovec rvec;
+static struct iovec rvec, wvec;
 
 static int read_it(struct io_uring *ring, int fd, int len, int off)
 {
@@ -40,6 +40,12 @@ static int read_it(struct io_uring *ring, int fd, int len, int off)
 		return 1;
 	}
 	io_uring_cqe_seen(ring, cqe);
+
+	if (memcmp(wvec.iov_base, rvec.iov_base + off, len)) {
+		fprintf(stderr, "%d %d verify failed\n", len, off);
+		return 1;
+	}
+
 	return 0;
 }
 
@@ -81,7 +87,7 @@ int main(int argc, char *argv[])
 	struct io_uring ring;
 	const char *fname;
 	char buf[256];
-	int fd, ret;
+	int fd, rnd_fd, ret;
 
 	if (argc > 1) {
 		fname = argv[1];
@@ -93,12 +99,34 @@ int main(int argc, char *argv[])
 		t_create_file(fname, 128*1024);
 	}
 
-	fd = open(fname, O_RDONLY | O_DIRECT);
+	fd = open(fname, O_RDWR | O_DIRECT | O_EXCL);
 	if (fd < 0) {
 		perror("open");
 		return 1;
 	}
 
+	rnd_fd = open("/dev/urandom", O_RDONLY);
+	if (fd < 0) {
+		perror("urandom: open");
+		goto err;
+	}
+
+	if (posix_memalign(&wvec.iov_base, 4096, 512*1024))
+		goto err;
+	wvec.iov_len = 512*1024;
+
+	ret = read(rnd_fd, wvec.iov_base, wvec.iov_len);
+	if (ret != wvec.iov_len) {
+		fprintf(stderr, "Precondition, urandom read failed, ret: %d\n", ret);
+		goto err;
+	}
+
+	ret = write(fd, wvec.iov_base, wvec.iov_len);
+	if (ret != wvec.iov_len) {
+		fprintf(stderr, "Precondition, write failed, ret: %d\n", ret);
+		goto err;
+	}
+
 	if (posix_memalign(&rvec.iov_base, 4096, 512*1024))
 		goto err;
 	rvec.iov_len = 512*1024;
-- 
2.43.0


