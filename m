Return-Path: <io-uring+bounces-10326-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 212E8C2DA32
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 19:19:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CA19189B69A
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 18:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700C12264A3;
	Mon,  3 Nov 2025 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ga+osrTV"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5BF288C2B
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 18:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762193972; cv=none; b=S23qgAoKYMuKwprqJQ6ktMiOHQI/2Axnfe9JQs8dD7vz/2cFPdsR+KxjDYp9IlnhX3J9RFdLMxV+DJn6OWuaBnPfeSzsdZNRdjqsVukMMiuW7AB2sVkhyQpwLAP3n31N6ua9tJbcPZBhq0qvivC4luKPzU89Mm3CeSh3TiuJXJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762193972; c=relaxed/simple;
	bh=7Iryk+Klr3WvxSMJGBR5CPzcKAHSi2sScbMDzzNdC+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iX2VBcbWS2eBsu+rf/V8zjVBf5e1iy+QvCGzJ8IKBY+ymafEAmPwGO3pO2LpAIUYfAo0E83HcyQXG/7WH/DyOONI3ZUPrGooYo+o/fLinOcBXpgcsVgAG5hv1PcROVICfyqnJJwVSWKjoyEN287Dg94qpIIiEp17qX1e34FGvns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ga+osrTV; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3IENEm012581;
	Mon, 3 Nov 2025 18:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=qat7/tqQNHt3pff9ioqv+0OkKjiLc
	aXMsitCrJ6nies=; b=Ga+osrTVki2wuTB4E183AgIm7AzNKhDdoV7O4ZCK7We4S
	z6iD8A7jAJulqYFuvYsJdxLjSC7NR2gfSn769BwAt2BYeHXcojbpXAyPrQFPxpL4
	kBKBYwb9aVoxBzTKgWZHUNBQkCy6fZh24ebaq6BrAGA4qcq4GAvqXJOZdg0tSdQP
	JjuWYm4VE5zQVdnY1dzWQFcxSFqmxdYHbwWkqp5cPfP4DlRFHVZ5bPoAp+Bp2LTZ
	ZIEE92cSdrHov55jssB0BpfmreT1LE2Jzk2OCcKFVmzaJgNr1JKM7LTBiT7vQs5x
	OYkg0izzpgNgjycFxVQuL8qSWl8OKjsqL3vWkwREg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a71gc80de-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 18:19:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3H8KJh015047;
	Mon, 3 Nov 2025 18:19:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n892mp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 18:19:27 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5A3IFkGx017584;
	Mon, 3 Nov 2025 18:19:26 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a58n892mb-1;
	Mon, 03 Nov 2025 18:19:26 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org
Cc: alok.a.tiwari@oracle.com, alok.a.tiwarilinux@gmail.com
Subject: [PATCH] io_uring: fix typos and comment wording
Date: Mon,  3 Nov 2025 10:19:06 -0800
Message-ID: <20251103181924.476422-1-alok.a.tiwari@oracle.com>
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
 definitions=2025-11-03_03,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030164
X-Authority-Analysis: v=2.4 cv=D45K6/Rj c=1 sm=1 tr=0 ts=6908f230 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=OoA25fW8meg1QJdt0t8A:9
X-Proofpoint-ORIG-GUID: 3lm0lB3XfWHj7yiDnycWlj9jw6rk5it5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDE2MyBTYWx0ZWRfX6gWFq+Kwiuj4
 okL8mXL2Tyuge8RwkR14IRgephooBtpxvJJQNs9dSAQ8xHITh0XwjXxfA1WIr152pS1QXOMj1Gf
 4a99NdOfm3q7W9zkKNz8USe3uNv2aCCVQ/BCPRXkK7eNmGTT86cChbCWnd+fINm338y6PdqLCei
 uXI5QIYqf63LZRIp164ABkK+juYjYEjPIbwxjdCeOUrXSdGCXa2b2VgnllJreR8LXFonoizV/iK
 7sPTaBMrnxZX9KiizTYBwfMcWxNqVjKQhojC3MXZRys7i6KFLvJKN39lNsZAMG3/y5vVJDBdAeV
 sgB0Wf0YkB7/TlIsIzxV3EO3AwYBnaxiYVlYUucdXvLpb1oeLVnzXkHT9fO9Z3epFMSJ4TUJfTz
 HMcuvpmg90mo2So4DZYUZg6eWwXKEA==
X-Proofpoint-GUID: 3lm0lB3XfWHj7yiDnycWlj9jw6rk5it5

Corrected spelling mistakes in comments
 "reuqests" -> "requests", "noifications" -> "notifications",
 "seperately" -> "separately").

Fixed a small grammar issue ("then" -> "than").
Updated "flag" -> "flags" in fdinfo.c

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
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
index 296667ba712c..59062db89ad6 100644
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
+	 * We don't know how many requests is there in the link and whether
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


