Return-Path: <io-uring+bounces-9573-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EECECB4465B
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 21:27:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2FC75A32DE
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 19:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 694712727F0;
	Thu,  4 Sep 2025 19:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="HwpEhhA7"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E4825B1D2
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 19:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757014061; cv=none; b=c1RjBQYlFIDvT1nBeS71Dw1+kyL9HxApT7p4GKE75+ya4PwEj9J6FVlf/u/zrfLCkJURKZgBsD1+a8ckEce6q0OAD4BZeKKCUdFjJkdyUvSDqxpUtqWwM1rjiny9sysKYny2XqD1vryI2jaCFVzXPP+3PQ7UTiMBvuSg8DWO288=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757014061; c=relaxed/simple;
	bh=wYU2AvroVk6I3D/Glfi00r2Ex1WG97IuAAp3xlHdi60=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mo0zuFryJMf5lgNaUkJ9b6p2x8/aMHA+k6oPSK9eMUSVK+6eevtQbDdZM78asCOArDHEPup+SW6Cfm/yyGR6TBC/Hj5Pkx6q0k2IN2XBa6p0IydUIetEzfzYejkANJw78erc3HZnmjFNwjrGM88C0QkSsAe2JWflZg7my0qm3Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=HwpEhhA7; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 584J82Dl2388241
	for <io-uring@vger.kernel.org>; Thu, 4 Sep 2025 12:27:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=Vy6WHpGQma5XDH5eaFcSu2qJzF8BTscwk8ym+hevZLc=; b=HwpEhhA7Ff6E
	Cp1EhoFuBhVKXAXiHYlsyrXeYOl/1uX/EHaYmrbEisaMl/45vjg32KwEWRcut5MZ
	X4rQE+qOhMo3TOiELTow0ivrlh2cdK+KgXtXY3bRhdnnAbHVVMuImo6p2/nRyeoN
	gTXUQH7Q6NJ9GQJHwpseNMPAl8bcSeuFm8WcC9zfA6b/kXyFDJ2QocgSenk4Zl04
	Cd90XhwaUrgm2e1u+KDMw61pLNipdrt0e8okGh5j8rxJAGa9mfAwkfBlwy0qCPeL
	H7j/R3ivwEfGJFUrkorFUxPTkWBUFcvX1IZUm665wLkWkHjJeLsJUDx7ieZCnNjI
	RVPH/SpIwQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 48ye06a6fn-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 12:27:37 -0700 (PDT)
Received: from twshared52133.15.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 4 Sep 2025 19:27:36 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 94BEA1578786; Thu,  4 Sep 2025 12:27:22 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [RFC PATCHv2 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
Date: Thu, 4 Sep 2025 12:27:14 -0700
Message-ID: <20250904192716.3064736-3-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250904192716.3064736-1-kbusch@meta.com>
References: <20250904192716.3064736-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 5DR6DPBQ6HcqEZywP--pcTg_loquLhwc
X-Proofpoint-GUID: 5DR6DPBQ6HcqEZywP--pcTg_loquLhwc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE5MiBTYWx0ZWRfX01rCv0a2G89y
 +42wUVPC0pAcRws5AAA1RvBAeAEuTHC+AFY/lNE4UFGpsEyEHpxDKfgWjOjsPpQeGbTMeETNl1K
 +KuckjEhLeFxM8W+fN54lFR4fDvOJig/ZgMXs9YWSZwYQWLEFbrC2+iUscZ71Co6j1ZbK1LuESu
 FOYP3cJk/hB46VdvTKz7WtjCtkUj6pNk/BE5+w0G7KcQzHpaB37xMZ1PewlZE0cZxy0t36JAufK
 0ybSqiOBo/G245WTsDfo879Y/ndTzHy2/wQN9DzHCHtjJqT4RGFlvk9sziXBNIsl1t5bdlAtQXb
 XTmYo3CW2S2eNSUjq0HBSoy8TePE1JwjIsJS2J5GO8NlehTggSDS2IcCSfmeKs=
X-Authority-Analysis: v=2.4 cv=IY+HWXqa c=1 sm=1 tr=0 ts=68b9e829 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=uQKsgqzGusPw8CW6dI4A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01

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
contiguous in the SQ ring, a 128b SQE cannot wrap the ring. For this
case, a single NOP SQE is posted with the SKIP flag set. The kernel
should simply ignore those.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring_types.h |  3 +++
 include/uapi/linux/io_uring.h  |  9 +++++++++
 io_uring/fdinfo.c              | 32 +++++++++++++++++++++++++-------
 io_uring/io_uring.c            | 20 +++++++++++++++++++-
 io_uring/register.c            |  2 +-
 io_uring/uring_cmd.c           |  4 +++-
 6 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index d1e25f3fe0b3a..d6e1c73400820 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -489,6 +489,7 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	=3D IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	=3D IOSQE_BUFFER_SELECT_BIT,
 	REQ_F_CQE_SKIP_BIT	=3D IOSQE_CQE_SKIP_SUCCESS_BIT,
+	REQ_F_SQE_128B_BIT	=3D IOSQE_SQE_128B_BIT,
=20
 	/* first byte is taken by user flags, shift it to not overlap */
 	REQ_F_FAIL_BIT		=3D 8,
@@ -547,6 +548,8 @@ enum {
 	REQ_F_BUFFER_SELECT	=3D IO_REQ_FLAG(REQ_F_BUFFER_SELECT_BIT),
 	/* IOSQE_CQE_SKIP_SUCCESS */
 	REQ_F_CQE_SKIP		=3D IO_REQ_FLAG(REQ_F_CQE_SKIP_BIT),
+	/* IOSQE_SQE_128B */
+	REQ_F_SQE_128B		=3D IO_REQ_FLAG(REQ_F_SQE_128B_BIT),
=20
 	/* fail rest of links */
 	REQ_F_FAIL		=3D IO_REQ_FLAG(REQ_F_FAIL_BIT),
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
index 5c73398387690..ef0d17876a7b9 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -66,7 +66,6 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *=
ctx, struct seq_file *m)
 	unsigned int cq_head =3D READ_ONCE(r->cq.head);
 	unsigned int cq_tail =3D READ_ONCE(r->cq.tail);
 	unsigned int sq_shift =3D 0;
-	unsigned int sq_entries;
 	int sq_pid =3D -1, sq_cpu =3D -1;
 	u64 sq_total_time =3D 0, sq_work_time =3D 0;
 	unsigned int i;
@@ -89,26 +88,44 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
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
+		u8 sqe_flags;
=20
 		if (ctx->flags & IORING_SETUP_NO_SQARRAY)
 			break;
-		sq_idx =3D READ_ONCE(ctx->sq_array[entry & sq_mask]);
+		sq_idx =3D READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
 		if (sq_idx > sq_mask)
 			continue;
 		sqe =3D &ctx->sq_sqes[sq_idx << sq_shift];
+		sqe_flags =3D READ_ONCE(sqe->flags);
+		if (sq_shift)
+			sqe128 =3D true;
+		else if (sqe_flags & IOSQE_SQE_128B) {
+			if (!(ctx->flags & IORING_SETUP_SQE_MIXED)) {
+				seq_printf(m,
+					"%5u: invalid sqe, 128B entry on non-mixed sq\n",
+					sq_idx);
+				break;
+			}
+			if ((++sq_head & sq_mask) =3D=3D 0) {
+				seq_printf(m,
+					"%5u: corrupted sqe, wrapping 128B entry\n",
+					sq_idx);
+				break;
+			}
+			sqe128 =3D true;
+		}
 		seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu, "
 			      "addr:0x%llx, rw_flags:0x%x, buf_index:%d "
 			      "user_data:%llu",
 			   sq_idx, io_uring_get_opcode(sqe->opcode), sqe->fd,
-			   sqe->flags, (unsigned long long) sqe->off,
+			   sqe_flags, (unsigned long long) sqe->off,
 			   (unsigned long long) sqe->addr, sqe->rw_flags,
 			   sqe->buf_index, sqe->user_data);
-		if (sq_shift) {
+		if (sqe128) {
 			u64 *sqeb =3D (void *) (sqe + 1);
 			int size =3D sizeof(struct io_uring_sqe) / sizeof(u64);
 			int j;
@@ -120,6 +137,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
 			}
 		}
 		seq_printf(m, "\n");
+		sq_head++;
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
 	while (cq_head < cq_tail) {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6c07efac977ce..78a81e882fce7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2180,6 +2180,13 @@ static int io_init_req(struct io_ring_ctx *ctx, st=
ruct io_kiocb *req,
 	}
 	opcode =3D array_index_nospec(opcode, IORING_OP_LAST);
=20
+	if (ctx->flags & IORING_SETUP_SQE_MIXED &&
+	    req->flags & REQ_F_SQE_128B) {
+		if ((ctx->cached_sq_head & (ctx->sq_entries - 1)) =3D=3D 0)
+			return io_init_fail_req(req, -EINVAL);
+		ctx->cached_sq_head++;
+	}
+
 	def =3D &io_issue_defs[opcode];
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */
@@ -2793,6 +2800,10 @@ unsigned long rings_size(unsigned int flags, unsig=
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
@@ -3724,6 +3735,13 @@ static int io_uring_sanitise_params(struct io_urin=
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
@@ -3952,7 +3970,7 @@ static long io_uring_setup(u32 entries, struct io_u=
ring_params __user *params)
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
 			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOPOLL |
-			IORING_SETUP_CQE_MIXED))
+			IORING_SETUP_CQE_MIXED | IORING_SETUP_SQE_MIXED))
 		return -EINVAL;
=20
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/register.c b/io_uring/register.c
index aa5f56ad83584..29aa7d3b4e820 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -397,7 +397,7 @@ static void io_register_free_rings(struct io_ring_ctx=
 *ctx,
 #define RESIZE_FLAGS	(IORING_SETUP_CQSIZE | IORING_SETUP_CLAMP)
 #define COPY_FLAGS	(IORING_SETUP_NO_SQARRAY | IORING_SETUP_SQE128 | \
 			 IORING_SETUP_CQE32 | IORING_SETUP_NO_MMAP | \
-			 IORING_SETUP_CQE_MIXED)
+			 IORING_SETUP_CQE_MIXED | IORING_SETUP_SQE_MIXED)
=20
 static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user=
 *arg)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 5562e8491c5bd..8dd409774fd87 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -239,7 +239,9 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
ssue_flags)
 	if (ret)
 		return ret;
=20
-	if (ctx->flags & IORING_SETUP_SQE128)
+	if (ctx->flags & IORING_SETUP_SQE128 ||
+	    (ctx->flags & IORING_SETUP_SQE_MIXED &&
+	     req->flags & REQ_F_SQE_128B))
 		issue_flags |=3D IO_URING_F_SQE128;
 	if (ctx->flags & (IORING_SETUP_CQE32 | IORING_SETUP_CQE_MIXED))
 		issue_flags |=3D IO_URING_F_CQE32;
--=20
2.47.3


