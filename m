Return-Path: <io-uring+bounces-10126-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34FC4BFD963
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DE0B3BB7D4
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E42286D56;
	Wed, 22 Oct 2025 17:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Bmf0CfuQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ECF299AB4
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153681; cv=none; b=Uzg3Kj2TCfZnalzy78R4xRrL/BDLCcD2p/UufnS801Mc8xsdfcRI51wYqVM4YPKTZGBxsUYYdO0450aESnkIfpSmi2EK/yOd3xDPYVEy+p2wET2PoQj9rhN0tURjzKp+daD9sUl29ERoSk0Wv3zfGc92bFCn0WoQlhCpmouODT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153681; c=relaxed/simple;
	bh=eM2BJcbjyiTNjS4WR6kkFFKLZ9/5xcsDihAYVj6mPm4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KJfKBYHU6D1TSjOPXiSDtGV0XsjArnsy+H8W0bF0i6MV/cUq01ilOPsw6l90c5rfaqIdtJVyTx2kPmm+2/z2ByKxwRvxsDnKxZi8I/yKhaleye8VFI5VadEeC3vBIn7UHiSS2ad1pAZh20MndxEcAbQ2NJoQ/LlatGVMHQtxiJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Bmf0CfuQ; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59MEkf5H2949139
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=vAgalRZLGj6mnNOp0x9Ff90PTd3lWD3IcKeKyheZi5Q=; b=Bmf0CfuQwcE+
	Q8AwFIIQ4OcBcEfGodYF+dt36641VQhrYIfoiZ2eSJYDiQaJpWU0r/Ak8eCN0hIA
	yPEHXTaKekryoVRDFUo6yoVW2PsPVRNPyeEgmhiJQmYfnr5LtcE1RMpv8KeSNMwR
	n2dHKYGttOSUq0nsEJgi0tZG3yhM1pz9nhuuohu21ht1QvzE1ad8PMq6cb8Nv+0d
	PB8YFMuNhpHLuQB/xpsGQ6n+eTj0cRpqr8fUKv23msSesik5LU3FNBw9JfnT04JC
	iNkuH+igUh4yfTBZ6rgTBU1oFKzm/KJKsIV7hC/gglOr/GFgx97eifRHZk1BeWY/
	i+nIk/i6ow==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49y1b1sdrj-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:17 -0700 (PDT)
Received: from twshared7571.34.frc3.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 22 Oct 2025 17:21:14 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id D994F2F95CB2; Wed, 22 Oct 2025 10:21:04 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv6 2/6] Add support IORING_SETUP_SQE_MIXED
Date: Wed, 22 Oct 2025 10:19:20 -0700
Message-ID: <20251022171924.2326863-3-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251022171924.2326863-1-kbusch@meta.com>
References: <20251022171924.2326863-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDE0MSBTYWx0ZWRfX8Y1ioQg3lIRY
 4CnWe4AC3zv/9q7rMF0w1Lj/Epguy7x3C7GZmOhHXUHSwsF/IikkgPaAyd1C6obodlcXcZnCmSA
 dpPLUk1UE7ZWP/W6M/AyjiKtcVtsApCMN1KXBWW3Fc1PQTRtnvZbu9YUGff6y5JoIRAuQ7kGRod
 znSfZL6GSF4ZQgLwZQNB72r95lUHKK3rMnxXpelFUMOdXVFoxzaC8KdxV9BwFRrY552ygqE1mRC
 8/+QverdoJJTYivmdfTZl/1cmzkPH/QU10mUs+C5lNivGkcjrFqUChrLalOMHhNcLM7Wel8QKtz
 d4TrH+RFgQ4jvcq/O+41dWubKQ8ZhzMvTnmKCLBm6k6+zTDe3BHvkPRNV1kcPBXBotRafaFzsM6
 /umDuJYU4GQzU+obnoxrffPgxZCJWA==
X-Proofpoint-ORIG-GUID: _UN9t_KbrsAz0aVMXT4MIWXiEobJDPJA
X-Authority-Analysis: v=2.4 cv=Xc2EDY55 c=1 sm=1 tr=0 ts=68f9128d cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=EMeYxfd_PNY5nN42izgA:9
X-Proofpoint-GUID: _UN9t_KbrsAz0aVMXT4MIWXiEobJDPJA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_07,2025-10-22_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

This adds core support for mixed sized SQEs in the same SQ ring. Before
this, SQEs were either 64b in size (the normal size), or 128b if
IORING_SETUP_SQE128 was set in the ring initialization. With the mixed
support, an SQE may be either 64b or 128b on the same SQ ring. If the
SQE is 128b in size, then a 128b opcode will be set in the sqe op. When
acquiring a large sqe at the end of the sq, the client may post a NOP
SQE with IOSQE_CQE_SKIP_SUCCESS set that the kernel will process and
skip posting a CQE.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 src/include/liburing.h          | 73 +++++++++++++++++++++++++++++++--
 src/include/liburing/io_uring.h |  8 ++++
 src/sanitize.c                  |  4 +-
 3 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 757c3057..83819eb7 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -800,6 +800,12 @@ IOURINGINLINE void io_uring_prep_nop(struct io_uring=
_sqe *sqe)
 	io_uring_prep_rw(IORING_OP_NOP, sqe, -1, NULL, 0, 0);
 }
=20
+IOURINGINLINE void io_uring_prep_nop128(struct io_uring_sqe *sqe)
+	LIBURING_NOEXCEPT
+{
+	io_uring_prep_rw(IORING_OP_NOP128, sqe, -1, NULL, 0, 0);
+}
+
 IOURINGINLINE void io_uring_prep_timeout(struct io_uring_sqe *sqe,
 					 const struct __kernel_timespec *ts,
 					 unsigned count, unsigned flags)
@@ -1517,12 +1523,13 @@ IOURINGINLINE void io_uring_prep_socket_direct_al=
loc(struct io_uring_sqe *sqe,
 	__io_uring_set_target_fixed_file(sqe, IORING_FILE_INDEX_ALLOC - 1);
 }
=20
-IOURINGINLINE void io_uring_prep_uring_cmd(struct io_uring_sqe *sqe,
-					   __u32 cmd_op,
-					   int fd)
+IOURINGINLINE void __io_uring_prep_uring_cmd(struct io_uring_sqe *sqe,
+					     int op,
+					     __u32 cmd_op,
+					     int fd)
 	LIBURING_NOEXCEPT
 {
-	sqe->opcode =3D IORING_OP_URING_CMD;
+	sqe->opcode =3D (__u8) op;
 	sqe->fd =3D fd;
 	sqe->cmd_op =3D cmd_op;
 	sqe->__pad1 =3D 0;
@@ -1530,6 +1537,22 @@ IOURINGINLINE void io_uring_prep_uring_cmd(struct =
io_uring_sqe *sqe,
 	sqe->len =3D 0;
 }
=20
+IOURINGINLINE void io_uring_prep_uring_cmd(struct io_uring_sqe *sqe,
+					   int cmd_op,
+					   int fd)
+	LIBURING_NOEXCEPT
+{
+	__io_uring_prep_uring_cmd(sqe, IORING_OP_URING_CMD, cmd_op, fd);
+}
+
+IOURINGINLINE void io_uring_prep_uring_cmd128(struct io_uring_sqe *sqe,
+					      int cmd_op,
+					      int fd)
+	LIBURING_NOEXCEPT
+{
+	__io_uring_prep_uring_cmd(sqe, IORING_OP_URING_CMD128, cmd_op, fd);
+}
+
 /*
  * Prepare commands for sockets
  */
@@ -2007,6 +2030,48 @@ IOURINGINLINE struct io_uring_sqe *io_uring_get_sq=
e(struct io_uring *ring)
 struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring);
 #endif
=20
+
+/*
+ * Return a 128B sqe to fill. Applications must later call io_uring_subm=
it()
+ * when it's ready to tell the kernel about it. The caller may call this
+ * function multiple times before calling io_uring_submit().
+ *
+ * Returns a vacant 128B sqe, or NULL if we're full. If the current tail=
 is the
+ * last entry in the ring, this function will insert a nop + skip comple=
te such
+ * that the 128b entry wraps back to the beginning of the queue for a
+ * contiguous big sq entry. It's up to the caller to use a 128b opcode i=
n order
+ * for the kernel to know how to advance its sq head pointer.
+ */
+IOURINGINLINE struct io_uring_sqe *io_uring_get_sqe128(struct io_uring *=
ring)
+	LIBURING_NOEXCEPT
+{
+	struct io_uring_sq *sq =3D &ring->sq;
+	unsigned head =3D io_uring_load_sq_head(ring), tail =3D sq->sqe_tail;
+	struct io_uring_sqe *sqe;
+
+	if (ring->flags & IORING_SETUP_SQE128)
+		return io_uring_get_sqe(ring);
+	if (!(ring->flags & IORING_SETUP_SQE_MIXED))
+		return NULL;
+
+	if (((tail + 1) & sq->ring_mask) =3D=3D 0) {
+		if ((tail + 2) - head >=3D sq->ring_entries)
+			return NULL;
+
+		sqe =3D _io_uring_get_sqe(ring);
+		io_uring_prep_nop(sqe);
+		sqe->flags |=3D IOSQE_CQE_SKIP_SUCCESS;
+		tail =3D sq->sqe_tail;
+	} else if ((tail + 1) - head >=3D sq->ring_entries) {
+		return NULL;
+	}
+
+	sqe =3D &sq->sqes[tail & sq->ring_mask];
+	sq->sqe_tail =3D tail + 2;
+	io_uring_initialize_sqe(sqe);
+	return sqe;
+}
+
 ssize_t io_uring_mlock_size(unsigned entries, unsigned flags)
 	LIBURING_NOEXCEPT;
 ssize_t io_uring_mlock_size_params(unsigned entries, struct io_uring_par=
ams *p)
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index 31396057..44ce8229 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -211,6 +211,12 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_CQE_MIXED		(1U << 18)
=20
+/*
+ *  Allow both 64b and 128b SQEs. If a 128b SQE is posted, it will use a=
 128b
+ *  opcode.
+ */
+#define IORING_SETUP_SQE_MIXED		(1U << 19)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
@@ -275,6 +281,8 @@ enum io_uring_op {
 	IORING_OP_READV_FIXED,
 	IORING_OP_WRITEV_FIXED,
 	IORING_OP_PIPE,
+	IORING_OP_NOP128,
+	IORING_OP_URING_CMD128,
=20
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/src/sanitize.c b/src/sanitize.c
index 383b7d64..6d8465a5 100644
--- a/src/sanitize.c
+++ b/src/sanitize.c
@@ -120,7 +120,9 @@ static inline void initialize_sanitize_handlers()
 	sanitize_handlers[IORING_OP_READV_FIXED] =3D sanitize_sqe_addr;
 	sanitize_handlers[IORING_OP_WRITEV_FIXED] =3D sanitize_sqe_addr;
 	sanitize_handlers[IORING_OP_PIPE] =3D sanitize_sqe_addr;
-	_Static_assert(IORING_OP_PIPE + 1 =3D=3D IORING_OP_LAST, "Need an imple=
mentation for all IORING_OP_* codes");
+	sanitize_handlers[IORING_OP_NOP128] =3D sanitize_sqe_nop;
+	sanitize_handlers[IORING_OP_URING_CMD128] =3D sanitize_sqe_optval;
+	_Static_assert(IORING_OP_URING_CMD128 + 1 =3D=3D IORING_OP_LAST, "Need =
an implementation for all IORING_OP_* codes");
 	sanitize_handlers_initialized =3D true;
 }
=20
--=20
2.47.3


