Return-Path: <io-uring+bounces-8050-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F9AFABEE12
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 10:37:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B02133BF7FD
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 08:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD5EB21ABB9;
	Wed, 21 May 2025 08:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="e2lcqH1Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B27231853
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 08:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747816672; cv=none; b=BglaK2TBo4hAOR4wvMhigNcZERjZ6ilwf66m9o1zQ18hFSTj9Vd4vf+cv3bbk946zMrvO60HZ7XYmDG4HLGBu/zLpDNI9jm0NI+xCxoZtBzXig3CWWnx9LW679ttWB3yozO4FQV8vFQdMdZLbHDQPw0l0xJBD00g7sgNMwPZzCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747816672; c=relaxed/simple;
	bh=PytspaYzDmRLhzTHrVM3PihMyMFFrB+1u0riWCA84TI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=P369tr5jV5l/mXMyfkOiW9gw+A7QYkbkuDaVPDqK1fhop7SD8HvwN8bkg4HA8ip3HA/cx2LFfZ4O8HPYJltcyUmExVsXA9KuS40PxuRVA2G5Ev0ZWM37ck/w+U2NfPqoaC8LgbdXkQxiGNesUDX8sG+d8jjabq3opVPQ2rVxk/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=e2lcqH1Q; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250521083747epoutp0414a74506c62a909979e7a1ee9e92d5bc~Bff_89nKf1956019560epoutp04m
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 08:37:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250521083747epoutp0414a74506c62a909979e7a1ee9e92d5bc~Bff_89nKf1956019560epoutp04m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1747816667;
	bh=VmNESYOs8EI0FFnu+5z6DPIpluUsRcqtTkhOzRuWQwE=;
	h=From:To:Cc:Subject:Date:References:From;
	b=e2lcqH1QECIehpuYU3i5jhTlIA8+LuHcDWKd0sA3pC1/BAOZpkKpbAZbQhDJ+ujh2
	 /Ow1+V95116COM3RePN+9v1UwJl2GMrZqnkw2wSADxaHMee2gASNscsAQCpy5LWtrE
	 t2E65MZvNAzzZCho4+/KioTgQhQqNfiML1KH4XPY=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250521083747epcas5p4a6f5b84a5cba4874bd54e12cd47a5bec~Bff_efeI21475114751epcas5p4-;
	Wed, 21 May 2025 08:37:47 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.175]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4b2Ptx5pLCz6B9mP; Wed, 21 May
	2025 08:37:45 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea~BffRWteOa3006530065epcas5p2w;
	Wed, 21 May 2025 08:36:58 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250521083658epsmtrp240471843503b3bbdcb2479c1626569f1~BffRWBD5Y1536115361epsmtrp2a;
	Wed, 21 May 2025 08:36:58 +0000 (GMT)
X-AuditID: b6c32a52-f0cb424000004c16-46-682d90aab804
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8D.B5.19478.AA09D286; Wed, 21 May 2025 17:36:58 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250521083657epsmtip2067e49940c08dcad3b15bcd14046f626~BffQPJS3Q2656026560epsmtip28;
	Wed, 21 May 2025 08:36:57 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: io-uring@vger.kernel.org, anuj1072538@gmail.com, axboe@kernel.dk,
	asml.silence@gmail.com
Cc: joshi.k@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH liburing] test/io_uring_passthrough: add test for vectored
 fixed-buffers
Date: Wed, 21 May 2025 13:49:49 +0530
Message-Id: <20250521081949.10497-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsWy7bCSvO6qCboZBiuWa1p8/PqbxaJpwl9m
	izmrtjFarL7bz2bxrvUci8XR/2/ZHNg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW
	6dslcGV8b+hiLZglXdFwcB5rA+MPkS5GTg4JAROJ1T+OsncxcnEICWxnlPi4bQ87REJC4tTL
	ZYwQtrDEyn/PoYo+MkpsW/GOGSTBJqAuceR5K1iRiECSxL8Ny1i7GDk4mAVsJC5cjgYJCwtE
	SCzefBOsnEVAVWLR31VsIDavgKXEwm8rWSDmy0vMvPSdHSIuKHFy5hOwODNQvHnrbOYJjHyz
	kKRmIUktYGRaxSiaWlCcm56bXGCoV5yYW1yal66XnJ+7iREchlpBOxiXrf+rd4iRiYPxEKME
	B7OSCG/sCp0MId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzKOZ0pQgLpiSWp2ampBalFMFkmDk6p
	BqaKb8KbDs27cfSNAv+7uj17dh0MD+V7mePpW3dLbNnk1uXRrCp3C0XuX5l2Nkjpi116zorz
	6gl8daKvX7hxrmsOEfBX+F5gpZzx0OuE0Qmry+dTDvhmfnVc5CPtonWs43ZBSKdIRp1raMze
	MtZtzG0Mec8kJD+2Peywf2Fvte3E7KaZPQJFh5/zRLCe++h60iT/QPf835U3/vmtdLV8dkTm
	TD/Djt1nixdf2hd719RS8+Y7jWc5NZ7PD34UvqIQ+vjBw4syrrkW3ZFypZeEmc5PXm5o8cGa
	UZO9yUtmaav/k2aZeMfg670H0zZ/2OZ8e9/pTS8mF5lu+/3Yz0OTZ2Kh4FEX1wMTHuX37V76
	3FSJpTgj0VCLuag4EQD0DMM4sgIAAA==
X-CMS-MailID: 20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea
References: <CGME20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea@epcas5p2.samsung.com>

This patch adds support for vectored fixed buffer I/O using io_uring
nvme passthrough, enabling broader testing of this path. Since older
kernels may return -EINVAL for this combination (fixed + vectored), the
test now detects this failure at runtime via a vec_fixed_supported flag.
Subsequent iterations skip only the unsupported combinations while
continuing to test all other valid variants.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 test/io_uring_passthrough.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index 66c97da..4a0ad73 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -20,6 +20,7 @@
 static void *meta_mem;
 static struct iovec *vecs;
 static int no_pt;
+static bool vec_fixed_supported = true;
 
 /*
  * Each offset in the file has the ((test_case / 2) * FILE_SIZE)
@@ -129,11 +130,15 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 				use_fd = 0;
 			if (fixed && (i & 1))
 				do_fixed = 0;
-			if (do_fixed) {
+			if (do_fixed && nonvec) {
 				io_uring_prep_read_fixed(sqe, use_fd, vecs[i].iov_base,
 								vecs[i].iov_len,
 								offset, i);
 				sqe->cmd_op = NVME_URING_CMD_IO;
+			} else if (do_fixed) {
+				io_uring_prep_readv_fixed(sqe, use_fd, &vecs[i],
+								1, offset, 0, i);
+				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
 			} else if (nonvec) {
 				io_uring_prep_read(sqe, use_fd, vecs[i].iov_base,
 							vecs[i].iov_len, offset);
@@ -152,11 +157,15 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 				use_fd = 0;
 			if (fixed && (i & 1))
 				do_fixed = 0;
-			if (do_fixed) {
+			if (do_fixed && nonvec) {
 				io_uring_prep_write_fixed(sqe, use_fd, vecs[i].iov_base,
 								vecs[i].iov_len,
 								offset, i);
 				sqe->cmd_op = NVME_URING_CMD_IO;
+			} else if (do_fixed) {
+				io_uring_prep_writev_fixed(sqe, use_fd, &vecs[i],
+								1, offset, 0, i);
+				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
 			} else if (nonvec) {
 				io_uring_prep_write(sqe, use_fd, vecs[i].iov_base,
 							vecs[i].iov_len, offset);
@@ -187,7 +196,7 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 		cmd->cdw11 = slba >> 32;
 		/* cdw12 represent number of lba's for read/write */
 		cmd->cdw12 = nlb;
-		if (do_fixed || nonvec) {
+		if (nonvec) {
 			cmd->addr = (__u64)(uintptr_t)vecs[i].iov_base;
 			cmd->data_len = vecs[i].iov_len;
 		} else {
@@ -218,6 +227,10 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 			goto err;
 		}
 		if (cqe->res != 0) {
+			if (cqe->res == -EINVAL && fixed && !nonvec) {
+				vec_fixed_supported = false;
+				goto cleanup_and_skip;
+			}
 			if (!no_pt) {
 				no_pt = 1;
 				goto skip;
@@ -236,6 +249,7 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 		}
 	}
 
+cleanup_and_skip:
 	if (fixed) {
 		ret = io_uring_unregister_buffers(ring);
 		if (ret) {
@@ -275,6 +289,9 @@ static int test_io(const char *file, int tc, int read, int sqthread,
 	if (hybrid)
 		ring_flags |= IORING_SETUP_IOPOLL | IORING_SETUP_HYBRID_IOPOLL;
 
+	if (fixed && (!vec_fixed_supported && !nonvec))
+		return 0;
+
 	ret = t_create_ring(64, &ring, ring_flags);
 	if (ret == T_SETUP_SKIP)
 		return 0;
-- 
2.25.1


