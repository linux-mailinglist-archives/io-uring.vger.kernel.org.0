Return-Path: <io-uring+bounces-9480-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED2B0B3C33F
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 21:42:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FD463BC447
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 19:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 032FF2459FE;
	Fri, 29 Aug 2025 19:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="cl3gBE7c"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A303237172
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 19:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496399; cv=none; b=QuelubLH4DUtq3P1B4o+kVNVGFD6daVIlDqRLnjwbSojftSVHcFzPUmcpaaAtlBXUwFLgOpxcW2UQLp3O1UU/LcxaGgPoTPayy/bv85pOiEe9hyPhbYBCQyHqvoT+3M/SjwyAmcL/bc7EKnpmaCEGXHMC4HrR3cHaOK95NPFu0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496399; c=relaxed/simple;
	bh=j5yd09EfunnZOHs0P7zmNkRBnq60chCenMm6jr+Trpg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bhPBiMMfapQgwtwvesH3Un/bKTaWjTtFWVRkDczrup+sRz4JyfPtLnvDIZZ/IPAfoTh3xHVV0JgAtf4D4nyMY+C8+OrX7UxiI40WNRAIyMP+PgsC5jLHJnxPzF39fZXFGdWbGhUi86MPxpMV+Eh7IV7MMr364/nEwuuBWP0ro2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=cl3gBE7c; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 57TIOOWu605098
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 12:39:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=bFRMFT0rh/bWEcVkGGSY86n+tKurgTqenb32ojj9Rjg=; b=cl3gBE7cHSKM
	nFlkGRDPzV7qHAgpuWvNgWh5KA6lEbZsY0IiNZf8qJUDwqJl+cKPE5eT9/LVDEqS
	IA7Tu2bMu11JCzO5ZuGgkV+efMOFbeSRCcfaLWAG+cfZeXCoAOjrEatwnUWAJrIc
	GC2LTk1TkduZc4XThCB85jQ1JsPA65/FR/Df2E3qhsxHLitzZz80SIotwy1z9nY9
	iEfiuPyhi6A27QN4RbiL3XwWsY2Dy0xVWj9TmqgGEQnqEbdDRvpdiXuNN9w2qiXH
	JqLCM2izZN+DXaEFSbU+e2ud9IJHyTkh1wY2+QDX+tg3DJTEWAtDxIbvZoMtQYkS
	rWYUhGkOHA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 48uhf40hmg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 12:39:57 -0700 (PDT)
Received: from twshared42488.16.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.17; Fri, 29 Aug 2025 19:39:56 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id A79EB121EBB8; Fri, 29 Aug 2025 12:39:43 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <io-uring@vger.kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [RFC PATCH 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
Date: Fri, 29 Aug 2025 12:39:34 -0700
Message-ID: <20250829193935.1910175-3-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829193935.1910175-1-kbusch@meta.com>
References: <20250829193935.1910175-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=BqmdwZX5 c=1 sm=1 tr=0 ts=68b2020d cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=jMrDBvniJURtm_n5GbsA:9
X-Proofpoint-ORIG-GUID: S6b9sAJ_LFDfyUZpuQ9zwBNeMx_rZzKx
X-Proofpoint-GUID: S6b9sAJ_LFDfyUZpuQ9zwBNeMx_rZzKx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI5MDE3NSBTYWx0ZWRfX6hW9POdtzIbD
 tkWwo4GyCo5dt87i5N4CRll/+4DOuE0dH+XJDGzaX92m/uITDbmyrf2oG8Wuu/jL01VpWKzrrQR
 rzGPUwJ1nh1FxviJhEQ/j9AA3ZcuFNutFO897BMeNK8I7TFm7PsPKY0K1lHYgL/+t3HY7gbRAaC
 gc8aBzNYT3jW3FH9MfkKftSH6pDx9s2owQUok22Pz738zBf9/wGJXyMbs2lHofJlHf3ugPVWKz6
 E9rqRrKwTXZgacd07oOk/braniTnC2odhqzItNpCi2rb8t/dGN2e6bcNrRPjafLXmpmUYshoj+b
 AePttpeka6mIfjA/spDYnbO7Zt6udUxNL8Wj46Q/WRtAdCLzcXwsi04UJzp1ZM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_06,2025-08-28_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Normal rings support 64b SQEs for posting submissions, while certain
features require the ring to be configured with IORING_SETUP_SQE128, as
they need to convey more information per submission. This, in turn,
makes ALL the SQEs be 128b in size. This is somewhat wasteful and
inefficient, particularly when only certain SQEs need to be of the
bigger variant.

This adds support for setting up a ring with mixed SQE sizes, using
IORING_SETUP_SQE_MIXED. When setup in this mode, SQEs posted to the ring
may be either 64b or 128b in size. If a SQE is 128b in size, then
IOSQE_SQE_128B flag is set in the SQE flags to indicate that this is the
case. If this flag isn't set, the SQE is the normal 64b variant.

SQEs on these types of mixed rings may also utilize NOP with skip
success set.  This can happen if the ring is one (small) SQE entry away
from wrapping, and an attempt is made to post a 128b SQE. As SQEs must be
contigious in the SQ ring, a 128b SQE cannot wrap the ring. For this
case, a single NOP SQE is posted with the SKIP flag set. The kernel
should simply ignore those.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/uapi/linux/io_uring.h |  9 +++++++++
 io_uring/fdinfo.c             | 21 ++++++++++-----------
 io_uring/io_uring.c           | 15 ++++++++++++++-
 3 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 04ebff33d0e62..9cef9085f52ee 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -146,6 +146,7 @@ enum io_uring_sqe_flags_bit {
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
 	IOSQE_CQE_SKIP_SUCCESS_BIT,
+	IOSQE_SQE_128B_BIT,
 };
=20
 /*
@@ -165,6 +166,8 @@ enum io_uring_sqe_flags_bit {
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 /* don't post CQE if request succeeded */
 #define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
+/* this is a 128b/big-sqe posting */
+#define IOSQE_SQE_128B		(1U << IOSQE_SQE_128B_BIT)
=20
 /*
  * io_uring_setup() flags
@@ -231,6 +234,12 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_CQE_MIXED		(1U << 18)
=20
+/*
+ * Allow both 64b and 128b SQEs. If a 128b SQE is posted, it will have
+ * IOSQE_SQE_128B set in sqe->flags.
+ */
+#define IORING_SETUP_SQE_MIXED		(1U << 19)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 5c73398387690..4eb6dbb9807be 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -65,15 +65,10 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
 	unsigned int sq_tail =3D READ_ONCE(r->sq.tail);
 	unsigned int cq_head =3D READ_ONCE(r->cq.head);
 	unsigned int cq_tail =3D READ_ONCE(r->cq.tail);
-	unsigned int sq_shift =3D 0;
-	unsigned int sq_entries;
 	int sq_pid =3D -1, sq_cpu =3D -1;
 	u64 sq_total_time =3D 0, sq_work_time =3D 0;
 	unsigned int i;
=20
-	if (ctx->flags & IORING_SETUP_SQE128)
-		sq_shift =3D 1;
-
 	/*
 	 * we may get imprecise sqe and cqe info if uring is actively running
 	 * since we get cached_sq_head and cached_cq_tail without uring_lock
@@ -89,18 +84,19 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
 	seq_printf(m, "CqTail:\t%u\n", cq_tail);
 	seq_printf(m, "CachedCqTail:\t%u\n", data_race(ctx->cached_cq_tail));
 	seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
-	sq_entries =3D min(sq_tail - sq_head, ctx->sq_entries);
-	for (i =3D 0; i < sq_entries; i++) {
-		unsigned int entry =3D i + sq_head;
+	while (sq_head < sq_tail) {
 		struct io_uring_sqe *sqe;
 		unsigned int sq_idx;
+		bool sqe128 =3D false;
=20
 		if (ctx->flags & IORING_SETUP_NO_SQARRAY)
 			break;
-		sq_idx =3D READ_ONCE(ctx->sq_array[entry & sq_mask]);
+		sq_idx =3D READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
 		if (sq_idx > sq_mask)
 			continue;
-		sqe =3D &ctx->sq_sqes[sq_idx << sq_shift];
+		sqe =3D &ctx->sq_sqes[sq_idx];
+		if (sqe->flags & IOSQE_SQE_128B || ctx->flags & IORING_SETUP_SQE128)
+			sqe128 =3D true;
 		seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu, "
 			      "addr:0x%llx, rw_flags:0x%x, buf_index:%d "
 			      "user_data:%llu",
@@ -108,7 +104,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
 			   sqe->flags, (unsigned long long) sqe->off,
 			   (unsigned long long) sqe->addr, sqe->rw_flags,
 			   sqe->buf_index, sqe->user_data);
-		if (sq_shift) {
+		if (sqe128) {
 			u64 *sqeb =3D (void *) (sqe + 1);
 			int size =3D sizeof(struct io_uring_sqe) / sizeof(u64);
 			int j;
@@ -120,6 +116,9 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
 			}
 		}
 		seq_printf(m, "\n");
+		sq_head++;
+		if (sqe128)
+			sq_head++;
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
 	while (cq_head < cq_tail) {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6c07efac977ce..7788292be8560 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2416,6 +2416,8 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, con=
st struct io_uring_sqe **sqe)
 	if (ctx->flags & IORING_SETUP_SQE128)
 		head <<=3D 1;
 	*sqe =3D &ctx->sq_sqes[head];
+	if (ctx->flags & IORING_SETUP_SQE_MIXED && (*sqe)->flags & IOSQE_SQE_12=
8B)
+		ctx->cached_sq_head++;
 	return true;
 }
=20
@@ -2793,6 +2795,10 @@ unsigned long rings_size(unsigned int flags, unsig=
ned int sq_entries,
 		if (cq_entries < 2)
 			return SIZE_MAX;
 	}
+	if (flags & IORING_SETUP_SQE_MIXED) {
+		if (sq_entries < 2)
+			return SIZE_MAX;
+	}
=20
 #ifdef CONFIG_SMP
 	off =3D ALIGN(off, SMP_CACHE_BYTES);
@@ -3724,6 +3730,13 @@ static int io_uring_sanitise_params(struct io_urin=
g_params *p)
 	if ((flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)) =3D=3D
 	    (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED))
 		return -EINVAL;
+	/*
+	 * Nonsensical to ask for SQE128 and mixed SQE support, it's not
+	 * supported to post 64b SQEs on a ring setup with SQE128.
+	 */
+	if ((flags & (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED)) =3D=3D
+	    (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED))
+		return -EINVAL;
=20
 	return 0;
 }
@@ -3952,7 +3965,7 @@ static long io_uring_setup(u32 entries, struct io_u=
ring_params __user *params)
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
 			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOPOLL |
-			IORING_SETUP_CQE_MIXED))
+			IORING_SETUP_CQE_MIXED | IORING_SETUP_SQE_MIXED))
 		return -EINVAL;
=20
 	return io_uring_create(entries, &p, params);
--=20
2.47.3


