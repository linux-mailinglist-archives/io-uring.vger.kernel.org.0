Return-Path: <io-uring+bounces-9983-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E49BABD5A06
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 20:00:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 429D4402DF9
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 18:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58821CA84;
	Mon, 13 Oct 2025 18:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="YBvNLW0G"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B14626E704
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 18:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760378428; cv=none; b=ClPAz8jtzrbiTWhv5f6I/LgpAYsnmk4/oVpqX6v8Z1MzmKiyvoQvxoZfQWOrtU4osrJrvfvwzefYl/udYzjGGJ8XlFtr6qQRxYcitV1U6xqd4GU6TN4VRFvAuiGBMM2HHiiwDLdbxNEyxgEaPUf1skVOAKwGC7Ay8tInYEsyfIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760378428; c=relaxed/simple;
	bh=WMCvlmshSTPReOe2vuofjJITVpv/UxEe2UQlLmuK9y4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bnILn9lxbxNwxPWCuRNAHVSujUw3i6MeRDMprsy4kRvrf/CPeKy4XpCXloaoI/6+Qw/TiDU8d2usrPMOtfTs5Jn8pvBnMzjMpfCOQpvxGkkSkbzEkJHvzaxwWY8rxJO0or4U6qAjb0AVXRzAmc1xZqhhTZ1+rnVJFBpiTVQ2Pjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=YBvNLW0G; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59DEMkuH1942041
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=QC4DnoI0oNuBGASve23ivtvTr4fbhX1Nrc67z3Skp/k=; b=YBvNLW0Gmnu0
	2XchCPeN0VjZpVdXcSfpYn6OGzZZ9nkiCE3P/oWv1u57WiDizTCuVDSggSCXgwJg
	szEQL54CdlTDZ8L1cw5hPpsUSeO5gfn3hnHqkA73p+7VKLRc6YDRH+QQ/ral3BgG
	w6ruR9NSXXCm3bS1bj9STuIaBC1r1A6/VrYWoos0vEn7vL7KZzzTMhvz8066Tok0
	yMOyAZU5UTrz8ssWjC3Nc4vmH9ieOXmAhfMf+ycZXYE6yrHXP+UxBGuNYLmb58qr
	NURKH8fKAtmEru4bRy9ansxA8E3jXs9BK1+/h2g8QMeYXtwcf1lRWLZn3batwV+3
	k5avYx+rYA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49s34vt0a8-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:25 -0700 (PDT)
Received: from twshared28390.17.frc2.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 13 Oct 2025 18:00:20 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 7D9A92AB3F7B; Mon, 13 Oct 2025 11:00:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 1/4] liburing: provide uring_cmd prep function
Date: Mon, 13 Oct 2025 11:00:08 -0700
Message-ID: <20251013180011.134131-4-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEzMDA4MSBTYWx0ZWRfX4VRWYYDZo4wv
 Z+ddl02yfv0CDLI8eR5wFpQ2wb/CbWXaceHultArmvkFGyNuSG0g3UxGQELzMu4CdJWMGQRh+hN
 IwPnkDWlnuF9Qe7fFA1hSM3rU2JpHOQaiA3lkYVBxPrYpvNViBKcivs3Wt9mGHs9+AEhSTHKxlc
 RcJ82/xkY8dIRQ4iyKsjJBVXC6wNG19dOFXNPCXmTqE14Z5Gevg5uD8Rp8TTN+j/BoITjZpsFLL
 jfhN2m9q0MmgHJuRblebZEmF47S9U5x43hDavA0Ak5t6I97ZMUYiUa5a6EMRECkTvqySGJOH+l6
 8b0jcdHMLabpyT2LOOIkAZaSm6N0fUL5DIg1jmgyuCX4qNQkEOAxhh9F4ES1g0RLjuerI52wDxs
 +v4cxUtByKFfW8q6WLLhmIysaVI9jw==
X-Proofpoint-GUID: 2V0bMghX2bB21hsgx0RPUvf54OjxVt1p
X-Authority-Analysis: v=2.4 cv=TMBIilla c=1 sm=1 tr=0 ts=68ed3e3a cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=aRQpO6OA4R3Q5RuGowwA:9
X-Proofpoint-ORIG-GUID: 2V0bMghX2bB21hsgx0RPUvf54OjxVt1p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_06,2025-10-06_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

The rw prep doesn't clear __pad1, which is a reserved field for
uring_cmd. If a prior submission in that entry did use that field, the
uring_cmd will fail the kernel's checks.

Also, the nvme uring_cmd tests had a couple places setting the sqe addr
and length, which are unused fields for the nvme uring_cmds, so they
shouldn't have been doing that, though had been checking these, so it
didn't cause any errors.

Provide a helper function specific to the uring_cmd preparation.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 src/include/liburing.h      | 19 +++++++++++++++----
 test/io_uring_passthrough.c | 14 ++++----------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index c80bffd3..f7af20aa 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1517,6 +1517,19 @@ IOURINGINLINE void io_uring_prep_socket_direct_all=
oc(struct io_uring_sqe *sqe,
 	__io_uring_set_target_fixed_file(sqe, IORING_FILE_INDEX_ALLOC - 1);
 }
=20
+IOURINGINLINE void io_uring_prep_uring_cmd(struct io_uring_sqe *sqe,
+					   int cmd_op,
+					   int fd)
+	LIBURING_NOEXCEPT
+{
+	sqe->opcode =3D (__u8) IORING_OP_URING_CMD;
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
index beaa81ad..26051710 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -148,11 +148,9 @@ static int __test_io(const char *file, struct io_uri=
ng *ring, int tc, int read,
 		if (async)
 			sqe->flags |=3D IOSQE_ASYNC;
 		if (nonvec)
-			sqe->cmd_op =3D NVME_URING_CMD_IO;
+			io_uring_prep_uring_cmd(sqe, NVME_URING_CMD_IO, use_fd);
 		else
-			sqe->cmd_op =3D NVME_URING_CMD_IO_VEC;
-		sqe->fd =3D use_fd;
-		sqe->opcode =3D IORING_OP_URING_CMD;
+			io_uring_prep_uring_cmd(sqe, NVME_URING_CMD_IO_VEC, use_fd);
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


