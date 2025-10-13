Return-Path: <io-uring+bounces-9982-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1B03BD5A03
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 20:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC92218A636A
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 18:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14FE1D88A4;
	Mon, 13 Oct 2025 18:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ha9IHelH"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBB32D0611
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 18:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760378426; cv=none; b=kgnYWOMxiORQdLn2FlReqqdOUbw+hLUpjR5cvoOHQ01K0+zRcfzxBnhJ1386uZl7Ul34Hg4uH/WAa2yj3QZ2asWw0DquxM4krPg3IY6h4OkLUhBkcFNae7AOXRVSQqvdjz1yqXRPzyMtVS/P+TNfpB/6SNMO1NY9AyDHYINnEAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760378426; c=relaxed/simple;
	bh=F9ISa18te1SyPLrFXufRK699EkfeiA2EzvEyUAnUtpI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bABSsmjNYstnlj/3PjbHBWd8Mqov5pCjJQU1XGiKccDWthvufDSI6hvr/qYFeSW1dHEDNh9DmAG/04dMHF+YhJl7nzX5Tl1sTMoRFpzH/hyBDJdBYHG0lfR+LFwc9jrkhJWdvhRkDLx4b147gMTs/YsGJK5HPQfRkV8WDdbXR4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ha9IHelH; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59DEMkuD1942041
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=X+JODSJX8FYMMzrkyh0jLmtcBwFry+SZaIzTIAFWcCo=; b=ha9IHelHn3+4
	2Yh12wmJ9xyRn83M/88qiv5+TNNU6kuN77YCEoVzL3DHzP3Jmv19DzVssZu1epbX
	E8XzGCd39/AjkGrPL6rsw5Z+d7S7G7rbZtrFfIzLpXX38VSPYoidynJrK29OcxuK
	HuFbB7aanhXwbiJo4j7RztGbVYcEhk2e2vRVl0yjyIs+r3/pX0SoPPRzzQSbKaDX
	2ttuwUPoMU4C3/wpk9DBmrp50vXu0ILVQDk0NMKowmSaANkCaGpPcCQJS6M9cD35
	hlCpYOOJMXe/Ehn/YVJgEuP9G2u8DRlB6JQJ563tmez2sDbdLv3JrLN1gUadbhCd
	uIH6F3IRYQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49s34vt0a8-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:23 -0700 (PDT)
Received: from twshared42488.16.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 13 Oct 2025 18:00:18 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 8496A2AB3F7D; Mon, 13 Oct 2025 11:00:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 2/4] Add support IORING_SETUP_SQE_MIXED
Date: Mon, 13 Oct 2025 11:00:09 -0700
Message-ID: <20251013180011.134131-5-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEzMDA4MSBTYWx0ZWRfX+SjLGnY8hp8J
 tynmaE2VrrNwrfZdXcRkQW+wkforctIsrdOKd06kqno8E5y4YbjCTsyuoY+f7CvKv5rjl2v7kiS
 oWguQ5SLcWbHIVuLI2oGK2VCtfGEpNwES/p/xt1w3rB5W+PZwT+khpU9QdFjvO7PqQ54T/i5d1v
 XcElhomOZTkMePEOSrka1WsEXbs8NFnj1c9ZCSc20ZP9lFXdgITapyaquo6+iVBJxTq3ERYaYYS
 W0SG5AO03saA/NKLTomab8JvkXp7GSW7X8y+j9HIqzCwjj/nJVu0VtwI01JEA+S/7Zmglxc0JYz
 LjHB4YIqivDMMCYiLE8mK281NouD9l2gynaWrNk9XF+j/x9fj8CWXHkvT9jwV1fOEaex5rJl54R
 fBlEfMs+uRU1+dzlGT38iLXKndhNJg==
X-Proofpoint-GUID: QmwfDwWF2eNitplcZV-VvDSmBAHWJZzO
X-Authority-Analysis: v=2.4 cv=TMBIilla c=1 sm=1 tr=0 ts=68ed3e37 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=24meITpB106o302jmawA:9
X-Proofpoint-ORIG-GUID: QmwfDwWF2eNitplcZV-VvDSmBAHWJZzO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_06,2025-10-06_01,2025-03-28_01

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
 src/include/liburing.h          | 71 +++++++++++++++++++++++++++++++--
 src/include/liburing/io_uring.h |  8 ++++
 2 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index f7af20aa..d6a45cbb 100644
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
-					   int cmd_op,
-					   int fd)
+IOURINGINLINE void __io_uring_prep_uring_cmd(struct io_uring_sqe *sqe,
+					     int op,
+					     int cmd_op,
+					     int fd)
 	LIBURING_NOEXCEPT
 {
-	sqe->opcode =3D (__u8) IORING_OP_URING_CMD;
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
@@ -1894,6 +1917,46 @@ IOURINGINLINE struct io_uring_sqe *_io_uring_get_s=
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
index 31396057..f2388645 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -211,6 +211,12 @@ enum io_uring_sqe_flags_bit {
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
@@ -275,6 +281,8 @@ enum io_uring_op {
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


