Return-Path: <io-uring+bounces-9869-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF927B9A8BE
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 17:15:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78EA74E0ADA
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 15:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CECDB30BF63;
	Wed, 24 Sep 2025 15:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="fGx7ckGu"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75EF30C614
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 15:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758726743; cv=none; b=APqWcnTBzliTq2ttVnwtcq0jcbAlHsdto0LiSZvshfjmRPxYF7P6+tUhKTPmjkXriVcoSgZeVtptWGPBQNOc8PXVrGxqYf7YW6XJ97TlNbD9dqAJbfNYZ+V4J6+HUTFYMKwCuUKbgsJV3m6eySCc/aHYVAurIFNRd1y+QWBL5+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758726743; c=relaxed/simple;
	bh=gYfaUPvEOJRT4Pysvs9aJF5aQpFn6gb5rkIAD1ncooY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ny46EbnwNWAEHs8IrbBPBKhC8aBc5kvEgE6OWSpU+0r8e61wtMbZlmO54vAIN3yiFBWbA8JWOBcqp3jmLhGba6mVmdqlDDovXRp/1j586RcKhlLvCQsn1W8aV1+9RPeRbm55uzHxRnSQWacZEg8sOBQsIn5b95TyivkU9BOkB94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=fGx7ckGu; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 58O6fM6m278442
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 08:12:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=ZQg3SQ2/dSniDo2ggYAkSV3Bn72Ln4f1dwsjD99Lvcs=; b=fGx7ckGuONV4
	sJJFcQrtf5lqTQ7Ng7kpyhwnshYYmS0zRxx3zPSICe84ia1UiROB0vs0WlGChgpY
	C23/ulPKxm2FQG8c6etfEi4Hw3UUXb+Voqu/0aTBzbcidbbqdCtrjQHkR+/iadGS
	aUrE2FXx6X9nBRIqX+06bVk6MRpqnlnpW7UXRU+q5DqV2CS09jFAyMTJQacmQ+kv
	HoPMGj6L7Ds++sjWsTBCIx3AXvTT4b8D9tVMWGXVJfVtY4EpScBU3U6ZYS76Kkzo
	e8dA7jJCV2PcbCgQ7cY+Q/tdr1TTamUxcWL9//LEBE2KUTj1/61EI63UBtIFCIN2
	fUAPdOeX9w==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 49cbk432mm-18
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 08:12:20 -0700 (PDT)
Received: from twshared14631.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 24 Sep 2025 15:12:16 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 03A07208B9DE; Wed, 24 Sep 2025 08:12:14 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <csander@purestorage.com>, <ming.lei@redhat.com>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCHv3 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
Date: Wed, 24 Sep 2025 08:12:08 -0700
Message-ID: <20250924151210.619099-3-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924151210.619099-1-kbusch@meta.com>
References: <20250924151210.619099-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=K6oiHzWI c=1 sm=1 tr=0 ts=68d40a54 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=H4D1PEQwBaEVffTG0TkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI0MDEzMSBTYWx0ZWRfX1TstefPdinp6
 KBt92OcfIeYcxFQ4EBIBPdt1UcywnipB2un/yC/4Hkd8r39dAl/9R1GJdePvZ2gwiogf12KOtnh
 eG4597pcDGuowEb7XkLcf214Amei5gjGL2VKkRK5c6zLYVNBO84pEdfpaKwzE7UI7+MxOuuNQRP
 IQj75a9edk9IsAr7heDkad6vmGGWVKN9hkC173LbXTp4HK4NpvLwOwIHWop3lbHVl6uaGSP46OI
 m706JUwKKcdJqqMSKwz6+4ZDf6GlNR65lQaDInDgxzHdJNB/htUuP3ErV43tP1I8Gy7TdvG5KZ9
 a4uvhTszbObOXPt1zn23PmxdVtFgADO1t1cMuYjZaX/3mZHDO20tUa/f50qJZo=
X-Proofpoint-GUID: 4ty8OJYSN0HVvc9a37Xl9D10TyCMiG5V
X-Proofpoint-ORIG-GUID: 4ty8OJYSN0HVvc9a37Xl9D10TyCMiG5V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_03,2025-09-22_05,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Normal rings support 64b SQEs for posting submissions, while certain
features require the ring to be configured with IORING_SETUP_SQE128, as
they need to convey more information per submission. This, in turn,
makes ALL the SQEs be 128b in size. This is somewhat wasteful and
inefficient, particularly when only certain SQEs need to be of the
bigger variant.

This adds support for setting up a ring with mixed SQE sizes, using
IORING_SETUP_SQE_MIXED. When setup in this mode, SQEs posted to the ring
may be either 64b or 128b in size. If a SQE is 128b in size, then opcode
will be set to a variante to indicate that this is the case. Any other
non-128b opcode will assume the SQ's default size.

SQEs on these types of mixed rings may also utilize NOP with skip
success set.  This can happen if the ring is one (small) SQE entry away
from wrapping, and an attempt is made to post a 128b SQE. As SQEs must be
contiguous in the SQ ring, a 128b SQE cannot wrap the ring. For this
case, a single NOP SQE should be posted with the SKIP_SUCCESS flag set.
The kernel should simply ignore those.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/uapi/linux/io_uring.h |  8 ++++++++
 io_uring/fdinfo.c             | 34 +++++++++++++++++++++++++++-------
 io_uring/io_uring.c           | 27 +++++++++++++++++++++++----
 io_uring/io_uring.h           |  8 +++++---
 io_uring/opdef.c              | 26 ++++++++++++++++++++++++++
 io_uring/opdef.h              |  2 ++
 io_uring/register.c           |  2 +-
 io_uring/uring_cmd.c          | 12 ++++++++++--
 io_uring/uring_cmd.h          |  1 +
 9 files changed, 103 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index a0cc1cc0dd015..ce01f043fceec 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -231,6 +231,12 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_CQE_MIXED		(1U << 18)
=20
+/*
+ * Allow both 64b and 128b SQEs. If a 128b SQE is posted, it will have
+ * a 128b opcode.
+ */
+#define IORING_SETUP_SQE_MIXED		(1U << 19)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
@@ -295,6 +301,8 @@ enum io_uring_op {
 	IORING_OP_READV_FIXED,
 	IORING_OP_WRITEV_FIXED,
 	IORING_OP_PIPE,
+	IORING_OP_NOP128,
+	IORING_OP_URING_CMD128,
=20
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index ff3364531c77b..d14d2e983b623 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -14,6 +14,7 @@
 #include "fdinfo.h"
 #include "cancel.h"
 #include "rsrc.h"
+#include "opdef.h"
=20
 #ifdef CONFIG_NET_RX_BUSY_POLL
 static __cold void common_tracking_show_fdinfo(struct io_ring_ctx *ctx,
@@ -66,7 +67,6 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *=
ctx, struct seq_file *m)
 	unsigned int cq_head =3D READ_ONCE(r->cq.head);
 	unsigned int cq_tail =3D READ_ONCE(r->cq.tail);
 	unsigned int sq_shift =3D 0;
-	unsigned int sq_entries;
 	int sq_pid =3D -1, sq_cpu =3D -1;
 	u64 sq_total_time =3D 0, sq_work_time =3D 0;
 	unsigned int i;
@@ -89,26 +89,45 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
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
+		u8 opcode;
=20
 		if (ctx->flags & IORING_SETUP_NO_SQARRAY)
 			break;
-		sq_idx =3D READ_ONCE(ctx->sq_array[entry & sq_mask]);
+		sq_idx =3D READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
 		if (sq_idx > sq_mask)
 			continue;
+
+		opcode =3D READ_ONCE(sqe->opcode);
 		sqe =3D &ctx->sq_sqes[sq_idx << sq_shift];
+		if (sq_shift)
+			sqe128 =3D true;
+		else if (io_issue_defs[opcode].is_128) {
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
-			   sq_idx, io_uring_get_opcode(sqe->opcode), sqe->fd,
+			   sq_idx, io_uring_get_opcode(opcode), sqe->fd,
 			   sqe->flags, (unsigned long long) sqe->off,
 			   (unsigned long long) sqe->addr, sqe->rw_flags,
 			   sqe->buf_index, sqe->user_data);
-		if (sq_shift) {
+		if (sqe128) {
 			u64 *sqeb =3D (void *) (sqe + 1);
 			int size =3D sizeof(struct io_uring_sqe) / sizeof(u64);
 			int j;
@@ -120,6 +139,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
 			}
 		}
 		seq_printf(m, "\n");
+		sq_head++;
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
 	while (cq_head < cq_tail) {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1bfa124565f71..f9bc442bb4188 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2153,7 +2153,7 @@ static __cold int io_init_fail_req(struct io_kiocb =
*req, int err)
 }
=20
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
-		       const struct io_uring_sqe *sqe)
+		       const struct io_uring_sqe *sqe, unsigned int *left)
 	__must_hold(&ctx->uring_lock)
 {
 	const struct io_issue_def *def;
@@ -2179,6 +2179,14 @@ static int io_init_req(struct io_ring_ctx *ctx, st=
ruct io_kiocb *req,
 	opcode =3D array_index_nospec(opcode, IORING_OP_LAST);
=20
 	def =3D &io_issue_defs[opcode];
+	if (def->is_128) {
+		if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 ||
+		    (ctx->cached_sq_head & (ctx->sq_entries - 1)) =3D=3D 0)
+			return io_init_fail_req(req, -EINVAL);
+		ctx->cached_sq_head++;
+		(*left)--;
+	}
+
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */
 		if (sqe_flags & ~SQE_VALID_FLAGS)
@@ -2288,13 +2296,13 @@ static __cold int io_submit_fail_init(const struc=
t io_uring_sqe *sqe,
 }
=20
 static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb=
 *req,
-			 const struct io_uring_sqe *sqe)
+			 const struct io_uring_sqe *sqe, unsigned int *left)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_link *link =3D &ctx->submit_state.link;
 	int ret;
=20
-	ret =3D io_init_req(ctx, req, sqe);
+	ret =3D io_init_req(ctx, req, sqe, left);
 	if (unlikely(ret))
 		return io_submit_fail_init(sqe, req, ret);
=20
@@ -2446,7 +2454,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigne=
d int nr)
 		 * Continue submitting even for sqe failure if the
 		 * ring was setup with IORING_SETUP_SUBMIT_ALL
 		 */
-		if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
+		if (unlikely(io_submit_sqe(ctx, req, sqe, &left)) &&
 		    !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
 			left--;
 			break;
@@ -2791,6 +2799,10 @@ unsigned long rings_size(unsigned int flags, unsig=
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
@@ -3717,6 +3729,13 @@ static int io_uring_sanitise_params(struct io_urin=
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
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index af4c113106523..074908d5884e4 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -54,7 +54,8 @@
 			IORING_SETUP_REGISTERED_FD_ONLY |\
 			IORING_SETUP_NO_SQARRAY |\
 			IORING_SETUP_HYBRID_IOPOLL |\
-			IORING_SETUP_CQE_MIXED)
+			IORING_SETUP_CQE_MIXED |\
+			IORING_SETUP_SQE_MIXED)
=20
 #define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
 			IORING_ENTER_SQ_WAKEUP |\
@@ -582,9 +583,10 @@ static inline void io_req_queue_tw_complete(struct i=
o_kiocb *req, s32 res)
  * IORING_SETUP_SQE128 contexts allocate twice the normal SQE size for e=
ach
  * slot.
  */
-static inline size_t uring_sqe_size(struct io_ring_ctx *ctx)
+static inline size_t uring_sqe_size(struct io_kiocb *req)
 {
-	if (ctx->flags & IORING_SETUP_SQE128)
+	if (req->ctx->flags & IORING_SETUP_SQE128 ||
+	    req->opcode =3D=3D IORING_OP_URING_CMD128)
 		return 2 * sizeof(struct io_uring_sqe);
 	return sizeof(struct io_uring_sqe);
 }
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 932319633eac2..36feebcce3827 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -575,6 +575,24 @@ const struct io_issue_def io_issue_defs[] =3D {
 		.prep			=3D io_pipe_prep,
 		.issue			=3D io_pipe,
 	},
+	[IORING_OP_NOP128] =3D {
+		.audit_skip		=3D 1,
+		.iopoll			=3D 1,
+		.is_128			=3D 1,
+		.prep			=3D io_nop_prep,
+		.issue			=3D io_nop,
+	},
+	[IORING_OP_URING_CMD128] =3D {
+		.buffer_select		=3D 1,
+		.needs_file		=3D 1,
+		.plug			=3D 1,
+		.iopoll			=3D 1,
+		.iopoll_queue		=3D 1,
+		.is_128			=3D 1,
+		.async_size		=3D sizeof(struct io_async_cmd),
+		.prep			=3D io_uring_cmd128_prep,
+		.issue			=3D io_uring_cmd,
+	},
 };
=20
 const struct io_cold_def io_cold_defs[] =3D {
@@ -825,6 +843,14 @@ const struct io_cold_def io_cold_defs[] =3D {
 	[IORING_OP_PIPE] =3D {
 		.name			=3D "PIPE",
 	},
+	[IORING_OP_NOP128] =3D {
+		.name			=3D "NOP128",
+	},
+	[IORING_OP_URING_CMD128] =3D {
+		.name			=3D "URING_CMD128",
+		.sqe_copy		=3D io_uring_cmd_sqe_copy,
+		.cleanup		=3D io_uring_cmd_cleanup,
+	},
 };
=20
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index c2f0907ed78cc..aa37846880ffd 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -27,6 +27,8 @@ struct io_issue_def {
 	unsigned		iopoll_queue : 1;
 	/* vectored opcode, set if 1) vectored, and 2) handler needs to know */
 	unsigned		vectored : 1;
+	/* set to 1 if this opcode uses 128b sqes in a mixed sq */
+	unsigned		is_128 : 1;
=20
 	/* size of async data needed, if any */
 	unsigned short		async_size;
diff --git a/io_uring/register.c b/io_uring/register.c
index 43f04c47522c0..e97d9cbba7111 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -395,7 +395,7 @@ static void io_register_free_rings(struct io_ring_ctx=
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
index a688c9f1a21cd..5fa3c260bc142 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -216,6 +216,13 @@ int io_uring_cmd_prep(struct io_kiocb *req, const st=
ruct io_uring_sqe *sqe)
 	return 0;
 }
=20
+int io_uring_cmd128_prep(struct io_kiocb *req, const struct io_uring_sqe=
 *sqe)
+{
+	if (!(req->ctx->flags & IORING_SETUP_SQE_MIXED))
+		return -EINVAL;
+	return io_uring_cmd_prep(req, sqe);
+}
+
 void io_uring_cmd_sqe_copy(struct io_kiocb *req)
 {
 	struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_uring_cm=
d);
@@ -224,7 +231,7 @@ void io_uring_cmd_sqe_copy(struct io_kiocb *req)
 	/* Should not happen, as REQ_F_SQE_COPIED covers this */
 	if (WARN_ON_ONCE(ioucmd->sqe =3D=3D ac->sqes))
 		return;
-	memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
+	memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req));
 	ioucmd->sqe =3D ac->sqes;
 }
=20
@@ -242,7 +249,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
ssue_flags)
 	if (ret)
 		return ret;
=20
-	if (ctx->flags & IORING_SETUP_SQE128)
+	if (ctx->flags & IORING_SETUP_SQE128 ||
+	    req->opcode =3D=3D IORING_OP_URING_CMD128)
 		issue_flags |=3D IO_URING_F_SQE128;
 	if (ctx->flags & (IORING_SETUP_CQE32 | IORING_SETUP_CQE_MIXED))
 		issue_flags |=3D IO_URING_F_CQE32;
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index 041aef8a8aa3f..0d6068fba7d0d 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -10,6 +10,7 @@ struct io_async_cmd {
=20
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *s=
qe);
+int io_uring_cmd128_prep(struct io_kiocb *req, const struct io_uring_sqe=
 *sqe);
 void io_uring_cmd_sqe_copy(struct io_kiocb *req);
 void io_uring_cmd_cleanup(struct io_kiocb *req);
=20
--=20
2.47.3


