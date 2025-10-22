Return-Path: <io-uring+bounces-10125-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C36BFD948
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:29:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FEA83AC397
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2C72989BF;
	Wed, 22 Oct 2025 17:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="aPzoy4Hl"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F05C29992A
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153678; cv=none; b=fz3HD79aDqY8dz329HolfL/cLfFA4tfnuZUgMUz8h2H/6uaLfx8EEw9X1c78Gio8gy8UcJm+GmnjzCB7x6t5J60b2wwrH3gl6IRTLaTYWkQKNKodgw7/BEW2ECZAHfJJmiMh1PT57uTqIViHNbjBvGhY70bAnRdf/oEoY2bthHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153678; c=relaxed/simple;
	bh=KPeh2FTcFZNd20wKL9Rbuw9D93BsdVMx02skW1Dp1P0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KTYXf2w/vRQ4ZZQ3HUveWNMzQvutWD9iNdPzqfGp76FnG5jhqcC317/0Ceszgc3A8v9KDX65Zwvt0YsjEjJWUzqyrasWPCXpDyeXpJc9OH1BL7biEGtwhCvGj+MNsBjxNQzeL9u4xNTSfNqlCvUUTKadZFVczIkFelMvky/OeDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=aPzoy4Hl; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59MEkkDE2949383
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=SmTMVgX8IrW4eF6HcSfwnD8l4wUzyE7jrJ/KSx83CJo=; b=aPzoy4Hlvzne
	V0wIy07yTmPk6JL6kvDxg3Byp7/Wd2C/PCQQJ+Ndk0YaVxFQcLzFunulr/QsWY+Z
	jKDHWLd4qgeez95DPAHBSzxIPcI9wQtjODEujT6srAf4vYHWGUiAimMjP/yu6lyd
	u5P5S3HoFMovO1FRd9FVsjDZnrcxXoZR/FCW3pWNsSvIyknLcc58afCXs8lz+7vI
	vNwHGWqu2CYDu0PplRXLyxMEu5ddF+sP+qA2aBe6H0Iuq8PqqstPYaQrjlD5LFat
	e/DTeR8ehhvPUKkCqIYC/ka3G0wY5sFcOA2EjtDu8b6KTtl7uCHh89/G8D/8xFs+
	a2Qy80IySQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49y1b1sdru-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:15 -0700 (PDT)
Received: from twshared51336.15.frc2.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 22 Oct 2025 17:21:13 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id D18A92F95CB0; Wed, 22 Oct 2025 10:21:04 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv6 1/6] liburing: provide uring_cmd prep function
Date: Wed, 22 Oct 2025 10:19:19 -0700
Message-ID: <20251022171924.2326863-2-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDE0MSBTYWx0ZWRfX8qerDW3e2v7Q
 YJQfUz9FjXlbYPeLUQNgJkXZNgi6KdvFAZUTst0TT9C+UjioLqETqvCChlCjlHVqbsYVmXMwXba
 ggjjrjEmoNpiqKfZ9gM5HvYKvL2fg8Kqi3+OG6TjI7NKQNDRKFDS4v/s1tXlWIiREmANohpOOTm
 c+qHVIUwaSeIMVFesdU8wVREdYIWwRGiF7fXdcVJ78xcl23VDCb/kLvQA/dqg3vlUibuebBIXu2
 40pt6n7vbWY4lyiN/xzY5eezt22H5sXe87oFqBacnxHtE+HNhJPYvqdAUX1/tUsnG33Nu2W5CTF
 //+qiNzNOG7m7uk9JDFNIF3ENeYiN65L0ldOk8Orel2DZajbDsVoyw0Eoe1kMsICBJtIMF7QiWz
 7KU9X1srkmHp3DicYFOnpK8/FAIEcQ==
X-Proofpoint-ORIG-GUID: X2NCA5DWpYp2yeI-wOvQ2ikF4jEhpbXl
X-Authority-Analysis: v=2.4 cv=Xc2EDY55 c=1 sm=1 tr=0 ts=68f9128b cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=6JnnVS7IdBdTtHBIKcYA:9
X-Proofpoint-GUID: X2NCA5DWpYp2yeI-wOvQ2ikF4jEhpbXl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_07,2025-10-22_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

The uring_cmd needs to ensure __pad1 is clear, which is a reserved field
for opcode. If a prior submission for a different opcode at that same
entry did use that field, the command would fail the kernel's checks if
the caller didn't explicity clear it. Provide an init helper for this
opcode.

Also, the nvme uring_cmd tests had a couple places setting the sqe addr
and length, which are unused fields, so they shouldn't have been doing
that, though it had been harmless to do so since the kernel isn't
checking these fields.

Provide a helper function specific to the uring_cmd preparation.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 src/include/liburing.h      | 19 +++++++++++++++----
 test/io_uring_passthrough.c | 18 ++++++------------
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index c80bffd3..757c3057 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1517,6 +1517,19 @@ IOURINGINLINE void io_uring_prep_socket_direct_all=
oc(struct io_uring_sqe *sqe,
 	__io_uring_set_target_fixed_file(sqe, IORING_FILE_INDEX_ALLOC - 1);
 }
=20
+IOURINGINLINE void io_uring_prep_uring_cmd(struct io_uring_sqe *sqe,
+					   __u32 cmd_op,
+					   int fd)
+	LIBURING_NOEXCEPT
+{
+	sqe->opcode =3D IORING_OP_URING_CMD;
+	sqe->fd =3D fd;
+	sqe->cmd_op =3D cmd_op;
+	sqe->__pad1 =3D 0;
+	sqe->addr =3D 0ul;
+	sqe->len =3D 0;
+}
+
 /*
  * Prepare commands for sockets
  */
@@ -1529,11 +1542,10 @@ IOURINGINLINE void io_uring_prep_cmd_sock(struct =
io_uring_sqe *sqe,
 					  int optlen)
 	LIBURING_NOEXCEPT
 {
-	io_uring_prep_rw(IORING_OP_URING_CMD, sqe, fd, NULL, 0, 0);
+	io_uring_prep_uring_cmd(sqe, cmd_op, fd);
 	sqe->optval =3D (unsigned long) (uintptr_t) optval;
 	sqe->optname =3D optname;
 	sqe->optlen =3D optlen;
-	sqe->cmd_op =3D cmd_op;
 	sqe->level =3D level;
 }
=20
@@ -1607,8 +1619,7 @@ IOURINGINLINE void io_uring_prep_cmd_discard(struct=
 io_uring_sqe *sqe,
 					     uint64_t offset, uint64_t nbytes)
 	LIBURING_NOEXCEPT
 {
-	io_uring_prep_rw(IORING_OP_URING_CMD, sqe, fd, 0, 0, 0);
-	sqe->cmd_op =3D BLOCK_URING_CMD_DISCARD;
+	io_uring_prep_uring_cmd(sqe, BLOCK_URING_CMD_DISCARD, fd);
 	sqe->addr =3D offset;
 	sqe->addr3 =3D nbytes;
 }
diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index beaa81ad..0442b3a3 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -141,18 +141,16 @@ static int __test_io(const char *file, struct io_ur=
ing *ring, int tc, int read,
=20
 		if (sqthread)
 			use_fd =3D 0;
+		if (nonvec)
+			io_uring_prep_uring_cmd(sqe, NVME_URING_CMD_IO, use_fd);
+		else
+			io_uring_prep_uring_cmd(sqe, NVME_URING_CMD_IO_VEC, use_fd);
 		if (fixed && (i & 1))
 			do_fixed =3D 0;
 		if (do_fixed)
 			sqe->buf_index =3D 0;
 		if (async)
 			sqe->flags |=3D IOSQE_ASYNC;
-		if (nonvec)
-			sqe->cmd_op =3D NVME_URING_CMD_IO;
-		else
-			sqe->cmd_op =3D NVME_URING_CMD_IO_VEC;
-		sqe->fd =3D use_fd;
-		sqe->opcode =3D IORING_OP_URING_CMD;
 		if (do_fixed)
 			sqe->uring_cmd_flags |=3D IORING_URING_CMD_FIXED;
 		sqe->user_data =3D ((uint64_t)offset << 32) | i;
@@ -328,9 +326,7 @@ static int test_invalid_passthru_submit(const char *f=
ile)
 	}
=20
 	sqe =3D io_uring_get_sqe(&ring);
-	io_uring_prep_read(sqe, fd, vecs[0].iov_base, vecs[0].iov_len, 0);
-	sqe->cmd_op =3D NVME_URING_CMD_IO;
-	sqe->opcode =3D IORING_OP_URING_CMD;
+	io_uring_prep_uring_cmd(sqe, NVME_URING_CMD_IO, fd);
 	sqe->user_data =3D 1;
 	cmd =3D (struct nvme_uring_cmd *)sqe->cmd;
 	memset(cmd, 0, sizeof(struct nvme_uring_cmd));
@@ -401,10 +397,8 @@ static int test_io_uring_submit_enters(const char *f=
ile)
 		__u32 nlb;
=20
 		sqe =3D io_uring_get_sqe(&ring);
-		io_uring_prep_readv(sqe, fd, &vecs[i], 1, offset);
+		io_uring_prep_uring_cmd(sqe, NVME_URING_CMD_IO, fd);
 		sqe->user_data =3D i;
-		sqe->opcode =3D IORING_OP_URING_CMD;
-		sqe->cmd_op =3D NVME_URING_CMD_IO;
 		cmd =3D (struct nvme_uring_cmd *)sqe->cmd;
 		memset(cmd, 0, sizeof(struct nvme_uring_cmd));
=20
--=20
2.47.3


