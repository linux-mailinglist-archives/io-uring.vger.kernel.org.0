Return-Path: <io-uring+bounces-10377-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 950CEC33F6D
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 06:03:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5FA034EF9AC
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 05:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D26BF9EC;
	Wed,  5 Nov 2025 05:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lrzBSFHd"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59F92F29
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 05:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762318892; cv=none; b=GpCPZIHlsV0AJSs//fdSHosQUB5SDt9q+hirjzlJ1PfL0CnJd75pVoQ8SLFy2/2k1JInXAVrnyVlSs7dwE0iP6O4ml9EYyawPTRA2D1B2D0p3EtRW6dTZzav4j1mnAu9AHkhLukWnUzagRi25/bSsP+Zx/ZZ1m9jdIw3SThP9v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762318892; c=relaxed/simple;
	bh=G+KDfc3GfV38/gM90LfT+BN074bqutZqdSTzRTqCcxg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JePKwpWodrf0OBPjgaTPqAl6zkeIzY806c0oFRqOQCN9rltELT06qSv3VPtXucGzmVLlXC/KLkZdz9PAyokmMST/LwpK5C7Zm/0yB3Xew1Td7AkgB6Uk40PIndKQyzoGsPRjbXRNTto4I+yeiAA+9t+wdDEILrjbkyyrPrBnihw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lrzBSFHd; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A53GXkb023262;
	Wed, 5 Nov 2025 05:01:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=9RvLBLwZx2+d2ezDEW3lYaHinCPNU
	8DMt6e/EEqU9rQ=; b=lrzBSFHdO2zmaUvdIIBvto/9BTsZSG7xdM9bd6QOIwzcA
	90tK+ECjaLMPChJeqQ2+GJMhvbU2n6iTDkGJy2vzd2IunkJYIrwdeneIcSzFO7Nn
	PRx95vCP1KWjfUs85MHSOGsjCe2IvDv//R4Wkn95iFfEaqLZEm0viW32dOpfYp0a
	GP/c76M1CklWKGStGKOM7QkhZzZSZLwiwRzRBe3Fm/v1dlBpIowZuzPBHUifiHX8
	OSl+I2X0dGfZIHmk+TBlVGAKAjjH2TnQhofld0ffpelf01W31C/ut0ErzTYcCgDU
	CWO/ESRxrK91nJpjB8n0jHpLL4dsnEOAm1hkSKiew==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7xhdg48x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 05:01:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A524FcC024893;
	Wed, 5 Nov 2025 05:01:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ne2hmg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 05:01:27 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5A550ms0012767;
	Wed, 5 Nov 2025 05:01:27 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a58ne2hkf-1;
	Wed, 05 Nov 2025 05:01:27 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org
Cc: alok.a.tiwari@oracle.com, alok.a.tiwarilinux@gmail.com
Subject: [PATCH v2] io_uring: fix typos and comment wording
Date: Tue,  4 Nov 2025 21:01:09 -0800
Message-ID: <20251105050124.561575-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_02,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050032
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDAxOSBTYWx0ZWRfX8++F0Kw9Myl0
 Q15AetHnQytsUM/zMZqUVnfajGF1gPzYu3wK+tLQfgDixRB7jqIX4/UvKKHMjHlOT8U075M9e2o
 ZwDTV0Ag7c1dp6bR1nKr9MLOrcwewyNz8Df2XP8jaswrZCypYzuGxMkvOTytLncIZDZ+IMu4kfi
 V/8DFjzHy+3bRZV5m80V5NkWbQzskzF7RokP1DZ/UWusTCGyObvceX17a5ja3QHa+dLDP8321UF
 nEY0u4B8jvEYlu0YcsXE1Pb/4NHbzbFH71GA25grqlT4n2HJIttnqCc+RLtr6TEjmhPBRZWsTUB
 wWRxo2QpDbnBnwnLnsPkfWcReLZVhy4cEaqiTQ+rhiRNrO7fWPfHBOsfg2gukak0UVkXqlPOTYW
 LOHJ9vyedXt4c60hSZEbCNwGndhXZx/RKQJjNndPC3+UtSMmgDY=
X-Authority-Analysis: v=2.4 cv=ZpDg6t7G c=1 sm=1 tr=0 ts=690ada28 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=OoA25fW8meg1QJdt0t8A:9 cc=ntf awl=host:13657
X-Proofpoint-ORIG-GUID: m1w_XGTbt6UGwFiuxqjTuvur92t1TlOt
X-Proofpoint-GUID: m1w_XGTbt6UGwFiuxqjTuvur92t1TlOt

Corrected spelling mistakes in comments
 "reuqests" -> "requests", "noifications" -> "notifications",
 "seperately" -> "separately").

Fixed a small grammar issue ("then" -> "than").
Updated "flag" -> "flags" in fdinfo.c

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
v1 -> v2
rephase grammar in io_uring.c
---
 io_uring/fdinfo.c   | 2 +-
 io_uring/io_uring.c | 4 ++--
 io_uring/notif.c    | 2 +-
 io_uring/rw.c       | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 294c75a8a3bd..05c90aca483f 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -128,7 +128,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		cqe = &r->cqes[(cq_head & cq_mask)];
 		if (cqe->flags & IORING_CQE_F_32 || ctx->flags & IORING_SETUP_CQE32)
 			cqe32 = true;
-		seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x",
+		seq_printf(m, "%5u: user_data:%llu, res:%d, flags:%x",
 			   cq_head & cq_mask, cqe->user_data, cqe->res,
 			   cqe->flags);
 		if (cqe32)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 296667ba712c..335487c838bb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -915,7 +915,7 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 }
 
 /*
- * Must be called from inline task_work so we now a flush will happen later,
+ * Must be called from inline task_work so we know a flush will happen later,
  * and obviously with ctx->uring_lock held (tw always has that).
  */
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
@@ -1246,7 +1246,7 @@ static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
 
 	/*
-	 * We don't know how many reuqests is there in the link and whether
+	 * We don't know how many requests there are in the link and whether
 	 * they can even be queued lazily, fall back to non-lazy.
 	 */
 	if (req->flags & IO_REQ_LINK_FLAGS)
diff --git a/io_uring/notif.c b/io_uring/notif.c
index d8ba1165c949..853b597cae2d 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -92,7 +92,7 @@ static int io_link_skb(struct sk_buff *skb, struct ubuf_info *uarg)
 	prev_nd = container_of(prev_uarg, struct io_notif_data, uarg);
 	prev_notif = cmd_to_io_kiocb(prev_nd);
 
-	/* make sure all noifications can be finished in the same task_work */
+	/* make sure all notifications can be finished in the same task_work */
 	if (unlikely(notif->ctx != prev_notif->ctx ||
 		     notif->tctx != prev_notif->tctx))
 		return -EEXIST;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 5b2241a5813c..daf4deefdfb2 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -186,7 +186,7 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 	 * This is really a bug in the core code that does this, any issue
 	 * path should assume that a successful (or -EIOCBQUEUED) return can
 	 * mean that the underlying data can be gone at any time. But that
-	 * should be fixed seperately, and then this check could be killed.
+	 * should be fixed separately, and then this check could be killed.
 	 */
 	if (!(req->flags & (REQ_F_REISSUE | REQ_F_REFCOUNT))) {
 		req->flags &= ~REQ_F_NEED_CLEANUP;
@@ -349,7 +349,7 @@ static int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	/*
 	 * Have to do this validation here, as this is in io_read() rw->len
-	 * might have chanaged due to buffer selection
+	 * might have changed due to buffer selection
 	 */
 	return io_iov_buffer_select_prep(req);
 }
@@ -1019,7 +1019,7 @@ static int __io_read(struct io_kiocb *req, struct io_br_sel *sel,
 		iov_iter_restore(&io->iter, &io->iter_state);
 	} while (ret > 0);
 done:
-	/* it's faster to check here then delegate to kfree */
+	/* it's faster to check here than delegate to kfree */
 	return ret;
 }
 
-- 
2.50.1


