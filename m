Return-Path: <io-uring+bounces-7906-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C66EAAF114
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 04:18:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D7087B9486
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 02:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1A9B7E792;
	Thu,  8 May 2025 02:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FPN0+1b/"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C007261E
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 02:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746670732; cv=none; b=pF8hnQCcl0Sb+Ff1EKHhCnjoV//awrny7pTPt0GaV7Y0xIlbSj8Y1ssPIL7kNkkm1NkNCYh1d1tDz3ChX+Nf17xsuCAurVnJmMSkfZ/y9zPYdaDM3sPFGOOUfB9KyeSWY7+/WVgyE+uf2NvCVuaeD6eTVE86PEgE3j5VXxJZYHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746670732; c=relaxed/simple;
	bh=T+RnXUQbmJFL55OKPYAmXI0OwHOkltjZSvcKzFwVsR8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=Eura2R0RujWJo90E3V6AI4XyTa8ab36/Fx8q3IpnYE42gMwc6xS9SKiGvnXdbrFmN5GOfM22JicqJGaHGU8FY6kzjFjx8Y811a1MF4lxgFikDNJCKVimhirFCZxmj48gcPP4nFUzPRKBIc7M6E078mfxSrwgM0YC+5LB4XBUtVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FPN0+1b/; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250508021842epoutp041b02cb540dc1b6d42973ad0631906b4d~9a8SMGaKt0532305323epoutp04S
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 02:18:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250508021842epoutp041b02cb540dc1b6d42973ad0631906b4d~9a8SMGaKt0532305323epoutp04S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746670722;
	bh=Xqd3gnZdKBz9lgx9DnnCblU1MVO/M3qzQIQBDCqbl94=;
	h=From:To:Cc:Subject:Date:References:From;
	b=FPN0+1b/jAR/3JyH8O9+/6L0kYWO9oGe+BRlNZpHcQywpUG9FubTu+IysQG4q69Aa
	 /PzXhAO3HWuH3Lb7yIBTYqrwrHqRZacRw2FStrJ2XHIEwHme3G6B5e6jfAcNXBTXDH
	 /bj7FaveRhMPVBowCdnefNceDeUzRMQPKIXJX4+U=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250508021841epcas5p316b5d6ee76c9179154a906fc24248e15~9a8RoKR6y0047300473epcas5p3L;
	Thu,  8 May 2025 02:18:41 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.177]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4ZtG5X3XsTz6B9m9; Thu,  8 May
	2025 02:18:40 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250508021828epcas5p21b9313ec7c9e0da2e7e49db36854aa22~9a8FJ4UrQ1802518025epcas5p2B;
	Thu,  8 May 2025 02:18:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250508021828epsmtrp142bfd6514d36904173d66915f5542bea~9a8FJJCzY3138131381epsmtrp1I;
	Thu,  8 May 2025 02:18:28 +0000 (GMT)
X-AuditID: b6c32a29-566fe7000000223e-73-681c1474c757
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B7.EC.08766.4741C186; Thu,  8 May 2025 11:18:28 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250508021827epsmtip165ed3cf3ae442efd71ea81fd23247178~9a8EMjRKL1333813338epsmtip1s;
	Thu,  8 May 2025 02:18:27 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peiwei.li@samsung.com, hexue <xue01.he@samsung.com>
Subject: [PATCH] Fix Hybrid Polling initialization issue
Date: Thu,  8 May 2025 10:18:22 +0800
Message-ID: <20250508021822.1781033-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsWy7bCSnG6JiEyGwZx2YYs5q7YxWqy+289m
	8a71HIvFr+67jBaXd81hs3i2l9Pi7IQPrBZdF06xOXB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ
	4rJJSc3JLEst0rdL4Mq4/e0Aa8Fntoqd53+yNTBeYu1i5OCQEDCR+HhCtIuRi0NIYDejxN8j
	P5m6GDmB4hISOx79YYWwhSVW/nvODlH0jVFi0o6dYAk2ASWJ/Vs+MILYIgKZEuffzQSzmQUs
	Je50nGABsYUFLCS+tDxgB7FZBFQlvs5eDbaAV8BaYvKVWYwQC+QlFu9YzgwRF5Q4OfMJC8Qc
	eYnmrbOZJzDyzUKSmoUktYCRaRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnCAamnu
	YNy+6oPeIUYmDsZDjBIczEoivEWN0hlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEecVf9KYICaQn
	lqRmp6YWpBbBZJk4OKUamCJm7wvdWHv4sffCiexfpvD7btkTt+fgbB/T9ilKHLfPX9iuPp1l
	Rqy4qyZblNK2lXOkbFc7bTJj+HjYq1i5fuGBjKd7efaf2+QeOTHetJ9dQer5drOtP45MuX70
	R+2uKeydYrcM/CXClSZ8ymKXn75ydXXCo10KJyc7PFbeuuie8YIykzDWxfOsPr/X3du1PeBi
	g5vjlL/Rnc2Sr7WP7ptQ0Fm+/2KJ05Wvm6J5ny6/WneuwNb8mNSR6dvKzCeG6J96/yXkEOM/
	pUt8//oOxua/v+85Y2dty9QrMaoxl0vuuL54zVPpXHTAM1k7Yjnr+xaP9daFMUc2ttoVJC+w
	ii62/dzB4NF+IO9PydGrDx4psRRnJBpqMRcVJwIAKtf6Ib8CAAA=
X-CMS-MailID: 20250508021828epcas5p21b9313ec7c9e0da2e7e49db36854aa22
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250508021828epcas5p21b9313ec7c9e0da2e7e49db36854aa22
References: <CGME20250508021828epcas5p21b9313ec7c9e0da2e7e49db36854aa22@epcas5p2.samsung.com>

Modify the defect that the timer is not initialized during IO transfer
when passthrough is used with hybrid polling to ensure that the program
can run normally.

Signed-off-by: hexue <xue01.he@samsung.com>
---
 io_uring/uring_cmd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e6701b7aa147..678a2f7d14ff 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -244,6 +244,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 			return -EOPNOTSUPP;
 		issue_flags |= IO_URING_F_IOPOLL;
 		req->iopoll_completed = 0;
+		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
+			/* make sure every req only blocks once */
+			req->flags &= ~REQ_F_IOPOLL_STATE;
+			req->iopoll_start = ktime_get_ns();
+		}
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
-- 
2.43.0


