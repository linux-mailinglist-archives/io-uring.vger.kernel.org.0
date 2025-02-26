Return-Path: <io-uring+bounces-6798-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF36A46910
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:11:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0E0B3A5381
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 18:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13D6235BF1;
	Wed, 26 Feb 2025 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="AStkGOTm"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB15235BEB
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593420; cv=none; b=VusReC/BpQSKOJ9j73jSqBsBjDOyBcKsEN/WQqy2ziOatv1nw5caW0JvUL5g7xw8/pz6xdIr4rZEwGGMsKiosSzKmFQfSUBYC7uVK5qqrHokDEDR+Sq1XXrQJ9jILHzxSCoO5qs0vQfQ2OgOV6r0fLdg6sc5G7M7eUn4ElF8WOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593420; c=relaxed/simple;
	bh=gxAd930mC7pPovdBPYRJjMVEkzVpGfpSvCYIEULbrHI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gJikrGKwEHyUcerpcho0ePu0ubhdhF6cwo2jqQNqoBW3ruRNR3sjwnYpn7NXSyQRR7AdDW0+HIUTsXkayjeIzTIxL1Xx+KIDPsoOH2T7Wy0Wy1LAGDgrN0Dwr/ZfvGzrk18/LHQmp5yP/byqzPxudbw2mTp4A1gVZpxE/WCn+qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=AStkGOTm; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 51QFa93A015227
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:10:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=PvFzXpTtdny48DHPNn
	OlSx78RVdEGozNe/onzuobVKE=; b=AStkGOTmyX9qwMPOkyJWinEIkhlbqViu3j
	P9WSdB5TLLcBiUYaM0HQHAKK0hoWI+YlEG9hXuesYWlCkZIHurbIoVtgDcUrnnN+
	VyIQ86v7Y/GKmHH8C1Gmw0ORqcKCCUIj5uYEu5qEoaqMwm09vNDbRhctLeJtkbUr
	Im1u0quClEKr/qLi+K+Z2HoSiyHITGdlfb5vyIwDk1ZN4982Bl1C0FfZ5Tew1rQp
	cD5ucVWFHQxYo5o0wwqTlPaRsp0Jt90SMuWU8+Hy6Dj2r2choWDuul4axOww2fkh
	VKRjM7hD/ptYcHhIB5tyZZiBwF4fgpX1Y+4dD6ITB3RX463O88KQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4525r796ku-15
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:10:17 -0800 (PST)
Received: from twshared8234.09.ash9.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 26 Feb 2025 18:10:04 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 468CC187C4ACD; Wed, 26 Feb 2025 10:10:02 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        <linux-nvme@lists.infradead.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv6 0/6] ublk zero copy support
Date: Wed, 26 Feb 2025 10:09:51 -0800
Message-ID: <20250226181002.2574148-1-kbusch@meta.com>
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
X-Proofpoint-GUID: _n20yWFSWfhWEhQxfjJNJV81h3GK-nMW
X-Proofpoint-ORIG-GUID: _n20yWFSWfhWEhQxfjJNJV81h3GK-nMW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Changes from v5:

  Merged up to latest block for-next tree

  Fixed up the io_uring read/write fixed prep to not set do_import, and
  actually use the issue_flags when importing the buffer node (Pavel,
  Caleb).

  Used unambigious names for the read/write permissions of registered
  kernel vectors, defined them using their symbolic names instead of
  literals, and added a BUILD_BUG_ON to ensure the flags fits in the
  type (Ming, Pavel).

  Limit the io cache size to 64 elements (Pavel).

  Enforce unpriveledged ublk dev can't use zero copy (Ming).

  Various cleanups.

  Added reviews

Keith Busch (5):
  io_uring/rw: move fixed buffer import to issue path
  io_uring: add support for kernel registered bvecs
  ublk: zc register/unregister bvec
  io_uring: add abstraction for buf_table rsrc data
  io_uring: cache nodes and mapped buffers

Xinyu Zhang (1):
  nvme: map uring_cmd data even if address is 0

 drivers/block/ublk_drv.c       | 119 +++++++++-----
 drivers/nvme/host/ioctl.c      |   2 +-
 include/linux/io_uring/cmd.h   |   7 +
 include/linux/io_uring_types.h |  24 +--
 include/uapi/linux/ublk_cmd.h  |   4 +
 io_uring/fdinfo.c              |   8 +-
 io_uring/filetable.c           |   2 +-
 io_uring/io_uring.c            |   3 +
 io_uring/nop.c                 |   2 +-
 io_uring/opdef.c               |   4 +-
 io_uring/register.c            |   2 +-
 io_uring/rsrc.c                | 280 ++++++++++++++++++++++++++-------
 io_uring/rsrc.h                |  10 +-
 io_uring/rw.c                  |  39 +++--
 io_uring/rw.h                  |   2 +
 15 files changed, 389 insertions(+), 119 deletions(-)

--=20
2.43.5

ublksrv reference implmementation using links:

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
index 1deee2b..c331963 100644
--- a/include/ublksrv_tgt.h
+++ b/include/ublksrv_tgt.h
@@ -99,6 +99,7 @@ struct ublk_io_tgt {
 	co_handle_type co;
 	const struct io_uring_cqe *tgt_io_cqe;
 	int queued_tgt_io;	/* obsolete */
+	bool needs_unregister;
 };
=20
 static inline struct ublk_io_tgt *__ublk_get_io_tgt_data(const struct ub=
lk_io_data *io)
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
index 0f16676..91f8c81 100644
--- a/tgt_loop.cpp
+++ b/tgt_loop.cpp
@@ -246,12 +246,70 @@ static inline int loop_fallocate_mode(const struct =
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
+	sqe->flags		|=3D IOSQE_IO_LINK | IOSQE_CQE_SKIP_SUCCESS | IOSQE_FIXED_F=
ILE;
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
+	sqe->opcode             =3D IORING_OP_URING_CMD;
+	sqe->flags              |=3D IOSQE_CQE_SKIP_SUCCESS | IOSQE_FIXED_FILE;
+	sqe->cmd_op             =3D UBLK_U_IO_UNREGISTER_IO_BUF;
+
+	cmd->tag                =3D tag;
+	cmd->addr               =3D index;
+	cmd->q_id               =3D q_id;
+}
+
+static void loop_unregister(const struct ublksrv_queue *q, int tag)
+{
+	struct io_uring_sqe *sqe;
+
+	ublk_get_sqe_pair(q->ring_ptr, &sqe, NULL);
+	io_uring_prep_buf_unregister(sqe, 0, tag, q->q_id, tag);
+}
+
 static void loop_queue_tgt_read(const struct ublksrv_queue *q,
-		const struct ublksrv_io_desc *iod, int tag)
+		const struct ublk_io_data *data, int tag)
 {
+	struct ublk_io_tgt *io =3D __ublk_get_io_tgt_data(data);
+	const struct ublksrv_io_desc *iod =3D data->iod;
+	const struct ublksrv_ctrl_dev_info *info =3D
+		ublksrv_ctrl_get_dev_info(ublksrv_get_ctrl_dev(q->dev));
 	unsigned ublk_op =3D ublksrv_get_op(iod);
=20
-	if (user_copy) {
+	if (info->flags & UBLK_F_SUPPORT_ZERO_COPY) {
+		struct io_uring_sqe *reg;
+		struct io_uring_sqe *read;
+
+		ublk_get_sqe_pair(q->ring_ptr, &reg, &read);
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
+		io->needs_unregister =3D true;
+	} else if (user_copy) {
 		struct io_uring_sqe *sqe, *sqe2;
 		__u64 pos =3D ublk_pos(q->q_id, tag, 0);
 		void *buf =3D ublksrv_queue_get_io_buf(q, tag);
@@ -284,11 +342,31 @@ static void loop_queue_tgt_read(const struct ublksr=
v_queue *q,
 }
=20
 static void loop_queue_tgt_write(const struct ublksrv_queue *q,
-		const struct ublksrv_io_desc *iod, int tag)
+		const struct ublk_io_data *data, int tag)
 {
+	const struct ublksrv_io_desc *iod =3D data->iod;
+	const struct ublksrv_ctrl_dev_info *info =3D
+		ublksrv_ctrl_get_dev_info(ublksrv_get_ctrl_dev(q->dev));
 	unsigned ublk_op =3D ublksrv_get_op(iod);
=20
-	if (user_copy) {
+	if (info->flags & UBLK_F_SUPPORT_ZERO_COPY) {
+		struct ublk_io_tgt *io =3D __ublk_get_io_tgt_data(data);
+		struct io_uring_sqe *reg;
+		struct io_uring_sqe *write;
+
+		ublk_get_sqe_pair(q->ring_ptr, &reg, &write);
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
+		io->needs_unregister =3D true;
+	} else if (user_copy) {
 		struct io_uring_sqe *sqe, *sqe2;
 		__u64 pos =3D ublk_pos(q->q_id, tag, 0);
 		void *buf =3D ublksrv_queue_get_io_buf(q, tag);
@@ -352,10 +430,10 @@ static int loop_queue_tgt_io(const struct ublksrv_q=
ueue *q,
 		sqe->user_data =3D build_user_data(tag, ublk_op, 0, 1);
 		break;
 	case UBLK_IO_OP_READ:
-		loop_queue_tgt_read(q, iod, tag);
+		loop_queue_tgt_read(q, data, tag);
 		break;
 	case UBLK_IO_OP_WRITE:
-		loop_queue_tgt_write(q, iod, tag);
+		loop_queue_tgt_write(q, data, tag);
 		break;
 	default:
 		return -EINVAL;
@@ -387,6 +465,10 @@ static co_io_job __loop_handle_io_async(const struct=
 ublksrv_queue *q,
 		if (io->tgt_io_cqe->res =3D=3D -EAGAIN)
 			goto again;
=20
+		if (io->needs_unregister) {
+			io->needs_unregister =3D false;
+			loop_unregister(q, tag);
+		}
 		ublksrv_complete_io(q, tag, io->tgt_io_cqe->res);
 	} else if (ret < 0) {
 		ublk_err( "fail to queue io %d, ret %d\n", tag, tag);
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

