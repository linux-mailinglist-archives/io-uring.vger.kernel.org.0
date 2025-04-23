Return-Path: <io-uring+bounces-7675-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C20A995D8
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 18:55:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5A861B60B3D
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 16:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A952A284676;
	Wed, 23 Apr 2025 16:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="icc4+Rg0"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE5D28A1D8
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 16:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745427318; cv=none; b=qBypfKk54vIEKWhWG9hUcYVJT6cm98rdwcMfbcvpnEOfvHi/Bf3Ev5BaUmV5zLG8KSsgvVMRTN1NvqvCTQP9pX5gSF0Vw2DM+uH72GUMY8mOnhvhezvyFKq9CAA4FF327k4n+cd7b/YQAsSnvO8mjejNTo9mCVJ0sXYrkJSSMg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745427318; c=relaxed/simple;
	bh=PNL2xI+S9qrXSYNI6F3TaQ0qGyUG2W53mA1qBemHtrs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:Content-Type:
	 References; b=aFy8rBmVBC74CIysmjC1ukDZARsirYDwC69dKxfZm2mP01Zf8qsp0/t9b5pErFTd2BG7OqFxVFqQ9kK7lLR+MAL+wVUPqIR2EjsJk/Z20ZFAtsZ+JV7/kdeEwU2X+kKUbK2ouhCZUx7xD2hTYHzF5L7k/4y7NQFnkYqQ3NIgf3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=icc4+Rg0; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250423165513epoutp04da3f235430916dbdc97f2c9dc1b08c50~5AOT2MtmI0304503045epoutp043
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 16:55:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250423165513epoutp04da3f235430916dbdc97f2c9dc1b08c50~5AOT2MtmI0304503045epoutp043
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1745427314;
	bh=ldOlJbhzJMQkuSwX+sLNyPIB4ZJY63PlKhDhH8ukms8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icc4+Rg0QqAHsUxSWm+X9ENBrOT/DlVjlaiW+hraVAB7kN7CZP3Nbk/6aVBwa6VAP
	 ZvwVJ9ET0rmQhksm0Z29RBA2RjcVLDxjtTWYOmFsSx3UJWzL30R0N4k9gw5TDskzpk
	 mu39qmeEnJyPu63yLTZ9eH72T3v4MG3+153IJiUU=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250423165513epcas5p1fb8e09ca0e62ba0a95435f3af3fcdd76~5AOTnVxDb0405004050epcas5p10;
	Wed, 23 Apr 2025 16:55:13 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.179]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4ZjQFr2yCFz3hhT3; Wed, 23 Apr
	2025 16:55:12 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250423133638epcas5p34a9cf20f13387f7f604d9c2e2bf6976a~49g6yozZN0571005710epcas5p3h;
	Wed, 23 Apr 2025 13:36:38 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250423133638epsmtrp221b799bac1d8fafc20716b37207e3d1d~49g6yBKuD2861728617epsmtrp25;
	Wed, 23 Apr 2025 13:36:38 +0000 (GMT)
X-AuditID: b6c32a2a-d57fe70000002265-b5-6808ece645ba
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	58.2D.08805.6ECE8086; Wed, 23 Apr 2025 22:36:38 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
	[107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250423133637epsmtip289da8dc7eecc00408bde0c4cb5dc84c1~49g6EGUOo0818308183epsmtip2S;
	Wed, 23 Apr 2025 13:36:37 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: io-uring@vger.kernel.org
Cc: gost.dev@samsung.com, nitheshshetty@gmail.com, Nitesh Shetty
	<nj.shetty@samsung.com>
Subject: [PATCH liburing 1/3] test/fixed-seg: Prep patch, rename the vec to
 rvec.
Date: Wed, 23 Apr 2025 18:57:50 +0530
Message-Id: <20250423132752.15622-2-nj.shetty@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250423132752.15622-1-nj.shetty@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsWy7bCSvO6zNxwZBnsa5S1uHtjJZPGu9RyL
	xY4njYwW237PZ3Zg8dg56y67R9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGUcefOBsaCVu+Jx
	fyN7A+Njji5GTg4JAROJz1Nfs3cxcnEICexmlOi8MoUZIiEpsezvEShbWGLlv+dQRc1MEkdm
	P2HtYuTgYBPQljj9H2yQiICMxPSZixhBbGaBGImTLVOZQGxhgUCJX1Png9ksAqoSa44tBZvJ
	K2Alce7oVVaI+fISqzccAItzClhLvNy/DmyOEFDNsY4etgmMfAsYGVYxSqYWFOem5xYbFhjl
	pZbrFSfmFpfmpesl5+duYgSHkJbWDsY9qz7oHWJk4mA8xCjBwawkwvvLjT1DiDclsbIqtSg/
	vqg0J7X4EKM0B4uSOO+3170pQgLpiSWp2ampBalFMFkmDk6pBiY/HV1Dx4s+MS8CixI/FBy5
	dk/G4Uum7txAkWk/QvU6lyaZyceox086orH1q5b1Ds3/dTaZh5J+/SgM7jw8tWmC6SIt+Zn3
	e+I6M0sP/jPSiJYsP9TYZ55z89KcqdUlzMGa50veeJZPPua4Nv7gHka9mf4pV3xKVnkxiVgE
	rf3BGu01fcOsoh+/DnKk/jble/x1RpzlzxNmlzL+3Lrk9bHIIi9UzvxpY5jwuXsLMmxM45jl
	ubyj31dMu18moaaYsVH5WIjx1AvVeY8eft1woPBDieKZVusW7kxB6zSe5K23ZrjO2lUkbbi1
	rrCz5NiMlBtbnXpOvNu/lVf7xhmXrY8/7ZVebf/IKGXl+8dRzEosxRmJhlrMRcWJAD1Nw4KQ
	AgAA
X-CMS-MailID: 20250423133638epcas5p34a9cf20f13387f7f604d9c2e2bf6976a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250423133638epcas5p34a9cf20f13387f7f604d9c2e2bf6976a
References: <20250423132752.15622-1-nj.shetty@samsung.com>
	<CGME20250423133638epcas5p34a9cf20f13387f7f604d9c2e2bf6976a@epcas5p3.samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

No functional change introduced.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 test/fixed-seg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/test/fixed-seg.c b/test/fixed-seg.c
index f908cad..83e4b13 100644
--- a/test/fixed-seg.c
+++ b/test/fixed-seg.c
@@ -12,7 +12,7 @@
 #include "liburing.h"
 #include "helpers.h"
 
-static struct iovec vec;
+static struct iovec rvec;
 
 static int read_it(struct io_uring *ring, int fd, int len, int off)
 {
@@ -21,7 +21,7 @@ static int read_it(struct io_uring *ring, int fd, int len, int off)
 	int ret;
 
 	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_read_fixed(sqe, fd, vec.iov_base + off, len, 0, 0);
+	io_uring_prep_read_fixed(sqe, fd, rvec.iov_base + off, len, 0, 0);
 	sqe->user_data = 1;
 
 	io_uring_submit(ring);
@@ -45,7 +45,7 @@ static int read_it(struct io_uring *ring, int fd, int len, int off)
 
 static int test(struct io_uring *ring, int fd, int vec_off)
 {
-	struct iovec v = vec;
+	struct iovec v = rvec;
 	int ret;
 
 	v.iov_base += vec_off;
@@ -99,9 +99,9 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	if (posix_memalign(&vec.iov_base, 4096, 512*1024))
+	if (posix_memalign(&rvec.iov_base, 4096, 512*1024))
 		goto err;
-	vec.iov_len = 512*1024;
+	rvec.iov_len = 512*1024;
 
 	ret = io_uring_queue_init(8, &ring, 0);
 	if (ret) {
-- 
2.43.0


