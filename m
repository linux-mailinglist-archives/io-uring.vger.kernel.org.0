Return-Path: <io-uring+bounces-6217-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCEFA25F18
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 16:45:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A333162A9B
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 15:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25C1204689;
	Mon,  3 Feb 2025 15:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="FimKk+Qj"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19EAC139
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 15:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738597533; cv=none; b=f92tVDGCHeP+4j4+mJT1XHoWLieaJHatgU+MBKEhVGIxIaIX1625MNaXV+e1OYfLeGs6tqoKOJKPmyzGKI7tHe1pcFsQ8uQIXlLk3xGxsBYuaGCkb5HL6w5WRvxDlZbwhYt8AwMHioCqdpKMRtoTey2GIamLjtpIop8tSJMVcic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738597533; c=relaxed/simple;
	bh=Ov93JObQzkv7Ys4Gy8NUThdP81jC20ES/diysyLYAGc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ALQBlpyOYGHYRDLBk2tN8/WJc2asciq989PiBJPAUQxXKNJjJ/5YdLVckB2wtiNUKhXsjDU2hPY7KDQWY5+JvMr+b63FQDNr9UZT8gffV00OCp05bT5TU73PMLw8ZIX00N3NN1ek8dWQ3zTw1x8+hgD4Z54HiDfgxBMXJGMlAp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=FimKk+Qj; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513Egrg7024327
	for <io-uring@vger.kernel.org>; Mon, 3 Feb 2025 07:45:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=ZZgR3KETJpb5BpwcfK
	GdQzF579xCEgMJ0Da7MRIVakg=; b=FimKk+QjHRBqndehAAEC10b+ZPHclS48tb
	ro//kxoXFbBlTE9QgxsY8YcgVK6S9sSwaZbmm+vRPS67gdHmnBYleqjxPE6/F49k
	1SPXvqQHT4ZI6CoVSwHvqmEk3uka4+yWslzP86Kk3Tv4ZtAqy1rwcX3FysNPkCb/
	XDkPF6azelTGVjTyh9mAu4vjcUGxAmjJXG/wTcuetQZtuDNVixqyfxE0Zk6kLSNe
	p+v2ROV1a8bsE7Fwp/fE2JpOCPAQ2urJnM9UfqpGhgItDz4nLgWiOmq+7uY6GzuY
	jjR7nLJEAz9gk08Fu6fSaejHhm+qkpRI/E6lqcOy+RDEuDVwWLGg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44jwu4s7r7-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 07:45:30 -0800 (PST)
Received: from twshared55211.03.ash8.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Feb 2025 15:45:27 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 14DAF179A9843; Mon,  3 Feb 2025 07:45:17 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <ming.lei@redhat.com>, <axboe@kernel.dk>, <asml.silence@gmail.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH 0/6] ublk zero-copy support
Date: Mon, 3 Feb 2025 07:45:11 -0800
Message-ID: <20250203154517.937623-1-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wBFMnuTFu9qcxaEHLhmj-trU0bp9iEdK
X-Proofpoint-GUID: wBFMnuTFu9qcxaEHLhmj-trU0bp9iEdK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_06,2025-01-31_02,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

This is a new look at supporting zero copy with ublk.

The previous version from Ming can be viewed here:

  https://lore.kernel.org/linux-block/20241107110149.890530-1-ming.lei@re=
dhat.com/

Based on the feedback from that thread, the desired io_uring interfaces
needed to be simpler, and the kernel registered resources need to behave
more similiar to user registered buffers.

This series introduces a new resource node type, KBUF, which, like the
BUFFER resource, needs to be installed into an io_uring buf_node table
in order for the user to access it in a fixed buffer command. The
new io_uring kernel API provides a way for a user to register a struct
request's bvec to a specific index, and a way to unregister it.

When the ublk server receives notification of a new command, it must
first select an index and register the zero copy buffer. It may use that
index for any number of fixed buffer commands, then it must unregister
the index when it's done. This can all be done in a single io_uring_enter
if desired, or it can be split into multiple enters if needed.

The io_uring instance that gets the zero copy registration doesn't
necessarily need to be the same ring that is receiving notifcations from
the ublk_drv module. This allows you to split frontend and backend rings
if desired.

At the end of this cover letter, I've provided a patch to the ublksrv to
demonstrate how to use this.

Jens Axboe (1):
  io_uring: use node for import

Keith Busch (5):
  block: const blk_rq_nr_phys_segments request
  io_uring: add support for kernel registered bvecs
  ublk: zc register/unregister bvec
  io_uring: add abstraction for buf_table rsrc data
  io_uring: cache nodes and mapped buffers

 drivers/block/ublk_drv.c       | 139 +++++++++++++-----
 include/linux/blk-mq.h         |   2 +-
 include/linux/io_uring.h       |   1 +
 include/linux/io_uring_types.h |  25 +++-
 include/uapi/linux/ublk_cmd.h  |   4 +
 io_uring/fdinfo.c              |   8 +-
 io_uring/filetable.c           |   2 +-
 io_uring/net.c                 |   5 +-
 io_uring/nop.c                 |   2 +-
 io_uring/register.c            |   2 +-
 io_uring/rsrc.c                | 259 ++++++++++++++++++++++++++-------
 io_uring/rsrc.h                |   8 +-
 io_uring/rw.c                  |   4 +-
 io_uring/uring_cmd.c           |   4 +-
 14 files changed, 351 insertions(+), 114 deletions(-)

--=20
2.43.5

ublksrv:

https://github.com/ublk-org/ublksrv

---
 include/ublk_cmd.h    |  4 +++
 include/ublksrv_tgt.h | 13 ++++++++
 lib/ublksrv.c         |  9 ++++++
 tgt_loop.cpp          | 74 +++++++++++++++++++++++++++++++++++++++++--
 ublksrv_tgt.cpp       |  2 +-
 5 files changed, 99 insertions(+), 3 deletions(-)

diff --git a/include/ublk_cmd.h b/include/ublk_cmd.h
index 0150003..07439be 100644
--- a/include/ublk_cmd.h
+++ b/include/ublk_cmd.h
@@ -94,6 +94,10 @@
 	_IOWR('u', UBLK_IO_COMMIT_AND_FETCH_REQ, struct ublksrv_io_cmd)
 #define	UBLK_U_IO_NEED_GET_DATA		\
 	_IOWR('u', UBLK_IO_NEED_GET_DATA, struct ublksrv_io_cmd)
+#define UBLK_U_IO_REGISTER_IO_BUF	\
+	_IOWR('u', 0x23, struct ublksrv_io_cmd)
+#define UBLK_U_IO_UNREGISTER_IO_BUF	\
+	_IOWR('u', 0x24, struct ublksrv_io_cmd)
=20
 /* only ABORT means that no re-fetch */
 #define UBLK_IO_RES_OK			0
diff --git a/include/ublksrv_tgt.h b/include/ublksrv_tgt.h
index 1deee2b..6291531 100644
--- a/include/ublksrv_tgt.h
+++ b/include/ublksrv_tgt.h
@@ -189,4 +189,17 @@ static inline void ublk_get_sqe_pair(struct io_uring=
 *r,
 		*sqe2 =3D io_uring_get_sqe(r);
 }
=20
+static inline void ublk_get_sqe_three(struct io_uring *r,
+		struct io_uring_sqe **sqe1, struct io_uring_sqe **sqe2,
+		struct io_uring_sqe **sqe3)
+{
+	unsigned left =3D io_uring_sq_space_left(r);
+
+	if (left < 3)
+		io_uring_submit(r);
+
+	*sqe1 =3D io_uring_get_sqe(r);
+	*sqe2 =3D io_uring_get_sqe(r);
+	*sqe3 =3D io_uring_get_sqe(r);
+}
 #endif
diff --git a/lib/ublksrv.c b/lib/ublksrv.c
index 16a9e13..7205247 100644
--- a/lib/ublksrv.c
+++ b/lib/ublksrv.c
@@ -619,6 +619,15 @@ skip_alloc_buf:
 		goto fail;
 	}
=20
+	if (ctrl_dev->dev_info.flags & UBLK_F_SUPPORT_ZERO_COPY) {
+		ret =3D io_uring_register_buffers_sparse(&q->ring, q->q_depth);
+		if (ret) {
+			ublk_err("ublk dev %d queue %d register spare buffers failed %d",
+					q->dev->ctrl_dev->dev_info.dev_id, q->q_id, ret);
+			goto fail;
+		}
+	}
+
 	io_uring_register_ring_fd(&q->ring);
=20
 	/*
diff --git a/tgt_loop.cpp b/tgt_loop.cpp
index 0f16676..ce44c7d 100644
--- a/tgt_loop.cpp
+++ b/tgt_loop.cpp
@@ -246,12 +246,62 @@ static inline int loop_fallocate_mode(const struct =
ublksrv_io_desc *iod)
        return mode;
 }
=20
+static inline void io_uring_prep_buf_register(struct io_uring_sqe *sqe,
+		int dev_fd, int tag, int q_id, __u64 index)
+{
+	struct ublksrv_io_cmd *cmd =3D (struct ublksrv_io_cmd *)sqe->cmd;
+
+	io_uring_prep_read(sqe, dev_fd, 0, 0, 0);
+	sqe->opcode		=3D IORING_OP_URING_CMD;
+	sqe->flags		|=3D IOSQE_CQE_SKIP_SUCCESS | IOSQE_FIXED_FILE;
+	sqe->cmd_op		=3D UBLK_U_IO_REGISTER_IO_BUF;
+
+	cmd->tag		=3D tag;
+	cmd->addr		=3D index;
+	cmd->q_id		=3D q_id;
+}
+
+static inline void io_uring_prep_buf_unregister(struct io_uring_sqe *sqe=
,
+		int dev_fd, int tag, int q_id, __u64 index)
+{
+	struct ublksrv_io_cmd *cmd =3D (struct ublksrv_io_cmd *)sqe->cmd;
+
+	io_uring_prep_read(sqe, dev_fd, 0, 0, 0);
+	sqe->opcode		=3D IORING_OP_URING_CMD;
+	sqe->flags		|=3D IOSQE_CQE_SKIP_SUCCESS | IOSQE_FIXED_FILE;
+	sqe->cmd_op		=3D UBLK_U_IO_UNREGISTER_IO_BUF;
+
+	cmd->tag		=3D tag;
+	cmd->addr		=3D index;
+	cmd->q_id		=3D q_id;
+}
+
 static void loop_queue_tgt_read(const struct ublksrv_queue *q,
 		const struct ublksrv_io_desc *iod, int tag)
 {
+	const struct ublksrv_ctrl_dev_info *info =3D
+		ublksrv_ctrl_get_dev_info(ublksrv_get_ctrl_dev(q->dev));
 	unsigned ublk_op =3D ublksrv_get_op(iod);
=20
-	if (user_copy) {
+	if (info->flags & UBLK_F_SUPPORT_ZERO_COPY) {
+		struct io_uring_sqe *reg;
+		struct io_uring_sqe *read;
+		struct io_uring_sqe *ureg;
+
+		ublk_get_sqe_three(q->ring_ptr, &reg, &read, &ureg);
+
+		io_uring_prep_buf_register(reg, 0, tag, q->q_id, tag);
+
+		io_uring_prep_read_fixed(read, 1 /*fds[1]*/,
+			0,
+			iod->nr_sectors << 9,
+			iod->start_sector << 9,
+			tag);
+		io_uring_sqe_set_flags(read, IOSQE_FIXED_FILE);
+		read->user_data =3D build_user_data(tag, ublk_op, 0, 1);
+
+		io_uring_prep_buf_unregister(ureg, 0, tag, q->q_id, tag);
+	} else if (user_copy) {
 		struct io_uring_sqe *sqe, *sqe2;
 		__u64 pos =3D ublk_pos(q->q_id, tag, 0);
 		void *buf =3D ublksrv_queue_get_io_buf(q, tag);
@@ -286,9 +336,29 @@ static void loop_queue_tgt_read(const struct ublksrv=
_queue *q,
 static void loop_queue_tgt_write(const struct ublksrv_queue *q,
 		const struct ublksrv_io_desc *iod, int tag)
 {
+	const struct ublksrv_ctrl_dev_info *info =3D
+		ublksrv_ctrl_get_dev_info(ublksrv_get_ctrl_dev(q->dev));
 	unsigned ublk_op =3D ublksrv_get_op(iod);
=20
-	if (user_copy) {
+	if (info->flags & UBLK_F_SUPPORT_ZERO_COPY) {
+		struct io_uring_sqe *reg;
+		struct io_uring_sqe *write;
+		struct io_uring_sqe *ureg;
+
+		ublk_get_sqe_three(q->ring_ptr, &reg, &write, &ureg);
+
+		io_uring_prep_buf_register(reg, 0, tag, q->q_id, tag);
+
+		io_uring_prep_write_fixed(write, 1 /*fds[1]*/,
+			0,
+			iod->nr_sectors << 9,
+			iod->start_sector << 9,
+			tag);
+		io_uring_sqe_set_flags(write, IOSQE_FIXED_FILE);
+		write->user_data =3D build_user_data(tag, ublk_op, 0, 1);
+
+		io_uring_prep_buf_unregister(ureg, 0, tag, q->q_id, tag);
+	} else if (user_copy) {
 		struct io_uring_sqe *sqe, *sqe2;
 		__u64 pos =3D ublk_pos(q->q_id, tag, 0);
 		void *buf =3D ublksrv_queue_get_io_buf(q, tag);
diff --git a/ublksrv_tgt.cpp b/ublksrv_tgt.cpp
index 8f9cf28..f3ebe14 100644
--- a/ublksrv_tgt.cpp
+++ b/ublksrv_tgt.cpp
@@ -723,7 +723,7 @@ static int cmd_dev_add(int argc, char *argv[])
 			data.tgt_type =3D optarg;
 			break;
 		case 'z':
-			data.flags |=3D UBLK_F_SUPPORT_ZERO_COPY;
+			data.flags |=3D UBLK_F_SUPPORT_ZERO_COPY | UBLK_F_USER_COPY;
 			break;
 		case 'q':
 			data.nr_hw_queues =3D strtol(optarg, NULL, 10);
--=20
2.43.5


