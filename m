Return-Path: <io-uring+bounces-9871-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3EF7B9A84C
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 17:14:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1F497B086D
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 15:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 470CD30BBBD;
	Wed, 24 Sep 2025 15:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="AhYgQuY0"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8AA30C113
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 15:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758726749; cv=none; b=mTK9jAQDnsQ62RrY3bT2phutJqKqCYo408yZxYecPE5aAs9LfbNzN25pyMUdgQlcWR0r9IF3KiTFPig4uoiekSL/vebAvs9Ex4pvA1Hpmwq9Gvfutm48n3ItdLYc13IHClZEkZzN5SChtOg8uWq2KCLSe0b96N92lwttSYnOKco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758726749; c=relaxed/simple;
	bh=hBi8gpF266uFn4lCl7tyPZpwxwRa9SlJuCVOu6C7eKQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JbyXT5XsWa07NLTZshBEodW2UR+FpXUt9dTcKi9C86ZK1MsC65/3KM/lGN0BBaQuK6pzukaZIxUJf1JNt70BhEryrNIfCCvVtojO02I6iIJub73dkuGCgp/9y4v7jrCNF3CLIfT6JQDmd2nbfsvRgd722hX6DXG/PMxIzVfBtCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=AhYgQuY0; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58O6O0BO865918
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 08:12:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=7hqs1U29ohVpLRPBxdes4e14ePStyZ0Zy7/2zkpzMaA=; b=AhYgQuY0btB/
	nHcH/XbWRS6bbfcZN9pOionCl3lE8WnJ0T563Fo5nkq+yYmdTNpzK56SkBOGEfi0
	vw/RCGWEADpApdWAy0kmVVLbF8n79t7IhvROhThyjXFtyJZ1uKHLE7idlUmlfViv
	qYXE5k0dYlbOIfEXnxdimkGYzIH5l6gUK6qFaaqGDseii8syT0SrEcfBt9YYoBJb
	i2ULyPfgGKbrEI+FXncVSvvliQUjCLY+lSBSFsPRYSQDHzl4nQvWHWq2cXa8F2TC
	UO0bUMRK14KF2VCC0/NoVuTxNavQBn1eCGDQVTmo/0WriDtwtH9fBjSRopZz3rnh
	fkKMg9RG/Q==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49cbbfk586-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 08:12:26 -0700 (PDT)
Received: from twshared25257.02.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 24 Sep 2025 15:12:19 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id F3FA2208B9DC; Wed, 24 Sep 2025 08:12:13 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <csander@purestorage.com>, <ming.lei@redhat.com>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCHv3 1/3] Add support IORING_SETUP_SQE_MIXED
Date: Wed, 24 Sep 2025 08:12:07 -0700
Message-ID: <20250924151210.619099-2-kbusch@meta.com>
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
X-Authority-Analysis: v=2.4 cv=Q4TS452a c=1 sm=1 tr=0 ts=68d40a5a cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=1a4LPVYmq5Ianoagd00A:9
X-Proofpoint-ORIG-GUID: hJ49BmIhRSObvhJYelZ4WlJiuUSI6u-Y
X-Proofpoint-GUID: hJ49BmIhRSObvhJYelZ4WlJiuUSI6u-Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI0MDEzMSBTYWx0ZWRfX+QoD5z0PvqVh
 SfxRLjj1+CDU4oE+kQ2waJy7vBgpSV1IxZ2BmslEvxaR5l4Ybm+zN/6pHI+IgiBpJkZV6j50ZhJ
 G9Z9CXYLXzdyv/WYGr2TmUHOwezmze9s4/s91XldvaWATxBVOcmtmEzDEhDyJ9P1WFNnNheFezo
 bJ7OZY2VOnVM1vn19K/AZMY39Zj/sN/8ezjVx5tmBrBTVFbtE3j9rtrH62DpTKpPiEu66N6eqPE
 RF1NgiKy290BC+FVKuJD0w5wgNIjvY1kixpAIT7InNo2xe+NUBYgCcb/Yoyhi+Mzkt7JhpYKT54
 vXwEbKkJJWZgrp48znHGEe7xs/L99Ukz65dbgVURkyZZrEenlZl44qQLTiJYKY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_03,2025-09-22_05,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

This adds core support for mixed sized SQEs in the same SQ ring. Before
this, SQEs were either 64b in size (the normal size), or 128b if
IORING_SETUP_SQE128 was set in the ring initialization. With the mixed
support, an SQE may be either 64b or 128b on the same SQ ring. If the
SQE is 128b in size, then a 128b opcode will be set in the sqe op. When
acquiring a large sqe at the end of the sq, the client may post a NOP
SQE with IOSQE_CQE_SKIP_SUCCESS set that the kernel should simply ignore
as it's just a pad filler that is posted when required.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 src/include/liburing.h          | 50 +++++++++++++++++++++++++++++++++
 src/include/liburing/io_uring.h | 11 ++++++++
 2 files changed, 61 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 052d6b56..66f1b990 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -575,6 +575,7 @@ IOURINGINLINE void io_uring_initialize_sqe(struct io_=
uring_sqe *sqe)
 	sqe->buf_index =3D 0;
 	sqe->personality =3D 0;
 	sqe->file_index =3D 0;
+	sqe->addr2 =3D 0;
 	sqe->addr3 =3D 0;
 	sqe->__pad2[0] =3D 0;
 }
@@ -799,6 +800,12 @@ IOURINGINLINE void io_uring_prep_nop(struct io_uring=
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
 					 struct __kernel_timespec *ts,
 					 unsigned count, unsigned flags)
@@ -1882,6 +1889,49 @@ IOURINGINLINE struct io_uring_sqe *_io_uring_get_s=
qe(struct io_uring *ring)
 	return sqe;
 }
=20
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
+IOURINGINLINE struct io_uring_sqe *io_uring_get_sqe128_mixed(struct io_u=
ring *ring)
+	LIBURING_NOEXCEPT
+{
+	struct io_uring_sq *sq =3D &ring->sq;
+	unsigned head =3D io_uring_load_sq_head(ring), tail =3D sq->sqe_tail;
+	struct io_uring_sqe *sqe;
+
+	if (!(ring->flags & IORING_SETUP_SQE_MIXED))
+		return NULL;
+
+	if (((tail + 1) & sq->ring_mask) =3D=3D 0) {
+		if ((tail + 2) - head >=3D sq->ring_entries)
+			return NULL;
+
+		sqe =3D _io_uring_get_sqe(ring);
+		if (!sqe)
+			return NULL;
+
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
+
+	return sqe;
+}
+
 /*
  * Return the appropriate mask for a buffer ring of size 'ring_entries'
  */
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index 31396057..1e0b6398 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -126,6 +126,7 @@ enum io_uring_sqe_flags_bit {
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
 	IOSQE_CQE_SKIP_SUCCESS_BIT,
+	IOSQE_SQE_128B_BIT,
 };
=20
 /*
@@ -145,6 +146,8 @@ enum io_uring_sqe_flags_bit {
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 /* don't post CQE if request succeeded */
 #define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
+/* this is a 128b/big-sqe posting */
+#define IOSQE_SQE_128B          (1U << IOSQE_SQE_128B_BIT)
=20
 /*
  * io_uring_setup() flags
@@ -211,6 +214,12 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_CQE_MIXED		(1U << 18)
=20
+/*
+ *  Allow both 64b and 128b SQEs. If a 128b SQE is posted, it will have
+ *  IOSQE_SQE_128B set in sqe->flags.
+ */
+#define IORING_SETUP_SQE_MIXED		(1U << 19)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
@@ -275,6 +284,8 @@ enum io_uring_op {
 	IORING_OP_READV_FIXED,
 	IORING_OP_WRITEV_FIXED,
 	IORING_OP_PIPE,
+	IORING_OP_NOP128,
+	IORING_OP_URING_CMD128,
=20
 	/* this goes last, obviously */
 	IORING_OP_LAST,
--=20
2.47.3


