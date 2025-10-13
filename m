Return-Path: <io-uring+bounces-9980-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 17099BD5A00
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 20:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 535854E794E
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 18:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D74CD2C324E;
	Mon, 13 Oct 2025 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="E1GetRBO"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72AD2C324C
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760378421; cv=none; b=bgRCTUVamo3N6fMlmCSRHP3PsiU6o8G3Ph73EKpv7cUDLvkybcuqfWZoy2x+QjShr1K62OFSsdvk0twUfqaqDvx9fj44BovZB+HUizFPzSP0FxR++efxjI8ceyzvRY+E2SdSAMIMMzn3iRkZfTeSCZmet6o72lU62NHYYwFEO6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760378421; c=relaxed/simple;
	bh=dtO8ZmRTcvTYRYWdqkGUK3iWayOJAo2ACl0LGVpGzno=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mwd7NSlPJniM9nbCsNg5hjdBERssTQze3RkNW0DY2bkdoDy2P7MNmGJH2oL/HQHO1pAt+pVacJ7DTh9upggNX/buqb03Kl82/83+cC9FPrMq5oNxciuEF3U8HhK23k0oHdGDDnT66raSRG+6KapfZthDYIF8pIWyeioSb3ndNpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=E1GetRBO; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59DGoBTf3878821
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=L7k5lkgNxrofx00gZ4QzbwdNXSlxAhTumk8R4jng0wQ=; b=E1GetRBODUmY
	Ni0/kUSwGTHq1ZyxthZyJB89aM8Udqwzh0Vm+ClOOn5f32PfjcRPi7/9DUr+CYuM
	NvW4FtyQV4sLwOvrexH3hZ3lp73tQ56eQgTunu5tX4nZL9x7JuKSazLEzq9yiBu1
	dS0GDlUf/46iu/RRD9AHyZDs0+6ohitIMbXnD/ymYUiI8sTgbxP5Cgp6SHsyA/bH
	O7iaWTKKh36DGDl0jQ7qgGEs+muoQ8w+Qemr+JI6tPWu59rcC1B171GaY0BxdrxT
	hZtv+6L62kvTlAxx0nfuK79Z6Hsd1JobSUjVHzFumIcKX6oxst6fG84IEnAQRjQj
	BU/pJ/1Cuw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49s59s0mdg-15
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:17 -0700 (PDT)
Received: from twshared13080.31.frc3.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 13 Oct 2025 18:00:12 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 7AB662AB3F79; Mon, 13 Oct 2025 11:00:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
Date: Mon, 13 Oct 2025 11:00:07 -0700
Message-ID: <20251013180011.134131-3-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013180011.134131-1-kbusch@meta.com>
References: <20251013180011.134131-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEzMDA4MSBTYWx0ZWRfXx+ICAKWph4IV
 tq1/s6wAP3FwhJXmd11ikxAYRUnj8q8DMNOi5C55QUjkp9zV1Ybv5XsM/BaWCf9KmyBtVTt2+sp
 nwPkblDH1R1oqcUc5XfJ/zEZvL6pKhKf8kOS5x87v8DN3L7cqjTwtDuaIoR9zn8xta8I6xwpVwn
 9U/yH7UbBNuoabQEK8FEr7jwDa1oowA2NpaUELD8cJmq/L7C4VsLBw4QJx+PMNPIbMHbvi78gBC
 AL6pVyNycw1+Vv5g1OqnfAsdHhp9diMhEXLMByKTFhRM/4OKLKTQkSHQyZRkyflwGllG0aiEJa/
 Q0RTX0PVAWf+bt8IXGKhJw0IRldmcGr4ldxNuQLoOG793FNNHntv++vRwcORWK1/MJAAllzujRO
 +oPgAiyV40VWbm1TP3LnfzS+ZYHoBA==
X-Proofpoint-ORIG-GUID: vocqvXB2QVZlVRS8ezKneYWRQsU8B8Ep
X-Authority-Analysis: v=2.4 cv=LoSfC3dc c=1 sm=1 tr=0 ts=68ed3e31 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=7sPIkl_xP7LkQMU9_0AA:9
X-Proofpoint-GUID: vocqvXB2QVZlVRS8ezKneYWRQsU8B8Ep
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_06,2025-10-06_01,2025-03-28_01

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
from wrapping, and an attempt is made to get a 128b SQE. As SQEs must be
contiguous in the SQ ring, a 128b SQE cannot wrap the ring. For this
case, a single NOP SQE should be inserted with the SKIP_SUCCESS flag
set. The kernel will process this as a normal NOP and without posting a
CQE.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/uapi/linux/io_uring.h |  8 ++++++++
 io_uring/fdinfo.c             | 34 +++++++++++++++++++++++++++-------
 io_uring/io_uring.c           | 35 +++++++++++++++++++++++++++++++----
 io_uring/io_uring.h           | 14 ++------------
 io_uring/opdef.c              | 26 ++++++++++++++++++++++++++
 io_uring/opdef.h              |  2 ++
 io_uring/register.c           |  2 +-
 io_uring/uring_cmd.c          | 17 +++++++++++++++--
 8 files changed, 112 insertions(+), 26 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 263bed13473ef..04797a9b76bc2 100644
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
index 820ef05276667..cd84eb4f2d4ca 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2151,7 +2151,7 @@ static __cold int io_init_fail_req(struct io_kiocb =
*req, int err)
 }
=20
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
-		       const struct io_uring_sqe *sqe)
+		       const struct io_uring_sqe *sqe, unsigned int *left)
 	__must_hold(&ctx->uring_lock)
 {
 	const struct io_issue_def *def;
@@ -2177,6 +2177,22 @@ static int io_init_req(struct io_ring_ctx *ctx, st=
ruct io_kiocb *req,
 	opcode =3D array_index_nospec(opcode, IORING_OP_LAST);
=20
 	def =3D &io_issue_defs[opcode];
+	if (def->is_128 && !(ctx->flags & IORING_SETUP_SQE128)) {
+		/*
+		 * A 128b op on a non-128b SQ requires mixed SQE support as
+		 * well as 2 contiguous entries.
+		 */
+		if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 ||
+		    !(ctx->cached_sq_head & (ctx->sq_entries - 1)))
+			return io_init_fail_req(req, -EINVAL);
+		/*
+		 * A 128b operation on a mixed SQ uses two entries, so we have
+		 * to increment the head and decrement what's left.
+		 */
+		ctx->cached_sq_head++;
+		(*left)--;
+	}
+
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */
 		if (sqe_flags & ~SQE_VALID_FLAGS)
@@ -2286,13 +2302,13 @@ static __cold int io_submit_fail_init(const struc=
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
@@ -2444,7 +2460,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigne=
d int nr)
 		 * Continue submitting even for sqe failure if the
 		 * ring was setup with IORING_SETUP_SUBMIT_ALL
 		 */
-		if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
+		if (unlikely(io_submit_sqe(ctx, req, sqe, &left)) &&
 		    !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
 			left--;
 			break;
@@ -2789,6 +2805,10 @@ unsigned long rings_size(unsigned int flags, unsig=
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
@@ -3715,6 +3735,13 @@ static int io_uring_sanitise_params(struct io_urin=
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
index 46d9141d772a7..85ed8eb7df80c 100644
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
@@ -578,17 +579,6 @@ static inline void io_req_queue_tw_complete(struct i=
o_kiocb *req, s32 res)
 	io_req_task_work_add(req);
 }
=20
-/*
- * IORING_SETUP_SQE128 contexts allocate twice the normal SQE size for e=
ach
- * slot.
- */
-static inline size_t uring_sqe_size(struct io_ring_ctx *ctx)
-{
-	if (ctx->flags & IORING_SETUP_SQE128)
-		return 2 * sizeof(struct io_uring_sqe);
-	return sizeof(struct io_uring_sqe);
-}
-
 static inline bool io_file_can_poll(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_CAN_POLL)
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 932319633eac2..df52d760240e4 100644
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
+		.prep			=3D io_uring_cmd_prep,
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
index d1e3ba62ee8e8..a89b29cc5d199 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -216,6 +216,18 @@ int io_uring_cmd_prep(struct io_kiocb *req, const st=
ruct io_uring_sqe *sqe)
 	return 0;
 }
=20
+/*
+ * IORING_SETUP_SQE128 contexts allocate twice the normal SQE size for e=
ach
+ * slot.
+ */
+static inline size_t uring_sqe_size(struct io_kiocb *req)
+{
+	if (req->ctx->flags & IORING_SETUP_SQE128 ||
+	    req->opcode =3D=3D IORING_OP_URING_CMD128)
+		return 2 * sizeof(struct io_uring_sqe);
+	return sizeof(struct io_uring_sqe);
+}
+
 void io_uring_cmd_sqe_copy(struct io_kiocb *req)
 {
 	struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_uring_cm=
d);
@@ -224,7 +236,7 @@ void io_uring_cmd_sqe_copy(struct io_kiocb *req)
 	/* Should not happen, as REQ_F_SQE_COPIED covers this */
 	if (WARN_ON_ONCE(ioucmd->sqe =3D=3D ac->sqes))
 		return;
-	memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
+	memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req));
 	ioucmd->sqe =3D ac->sqes;
 }
=20
@@ -242,7 +254,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
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
--=20
2.47.3


