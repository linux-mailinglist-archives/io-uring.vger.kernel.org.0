Return-Path: <io-uring+bounces-9575-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BBE6B4465D
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 21:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4ADE6561623
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 19:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF74825B1D2;
	Thu,  4 Sep 2025 19:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="bnKOCnYQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F34271A94
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 19:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757014081; cv=none; b=ikSAuP8O2SPKOWFn4VbwXqrimt6xvqvaskrY5WjIY5vjOs8fciIrq0cVjBcOE2yxR66iim/mqolchMOpjJcDyiTSkmlYIqC5Ik4WP53hK05o3E2FlZewbumRCYo/H0FdvdC/CTtrPPKMgPRjDueCISsqUuh6JUGWLFSP7OsjyfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757014081; c=relaxed/simple;
	bh=pl4oVy/TM+Q2YajrPawtIFbwkkDYwWut8Dk40NXudNM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iKVyTNFFkXYkSkrXCi1X3ha9Yjd2faZH4wp9dU32tERyG1igdaOI4YpWqqp9nt32G6VueMhC7kKSSXx7BBVhv6Y/XFWgAJeLj+mfyylhZNuTWpppQBkXnW2R2Nq0Fd9reZCJM/pZiz9SB/jA10bZHJwrm4uXaDf+n4fYk59HVRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=bnKOCnYQ; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 584J82On2388864
	for <io-uring@vger.kernel.org>; Thu, 4 Sep 2025 12:27:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=C1yU89lrkDvVXW8D0Ccthn1OWJmeEb6eXcKo+CG8W/c=; b=bnKOCnYQA8s5
	sHS2gNpe03LE9bwiB3MIWAQh5OhYL2Qpn2b/tQYUo/eHTqHJu48xkckq98eVKir2
	mvaNStZQ0VmngHZefx1keI16OG3wu09OwbM14oZirQXWrOOb8uIMIEt6gMBa76FR
	VYMWr2SvG5Jg13DkAKZ9emqei95Zgcgb+YX/STKUatLkApASpWkHWqzcQtcEA8Lm
	8hVJ6jXA27LZ4GeG1QWlO1Vbo4GTtoiTnL+xu3wgS2eRvAHFscvAuCZ8xJmQkbvw
	/lvcmZ4PNrRzs9T/5irkXztH2yfmkqr62S7jYHBTYzm5k/PqvNsqI5ZfQSFFMuGS
	EVtLYb3zkQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 48ye06a6h8-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 12:27:59 -0700 (PDT)
Received: from twshared42488.16.frc2.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 4 Sep 2025 19:27:25 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 9F7DE1578789; Thu,  4 Sep 2025 12:27:22 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [RFC PATCHv2 3/3] Add mixed sqe test for uring commands
Date: Thu, 4 Sep 2025 12:27:16 -0700
Message-ID: <20250904192716.3064736-5-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: MbrKx5GO7Ooow-d_gS8cMar6kKnGSnnH
X-Proofpoint-GUID: MbrKx5GO7Ooow-d_gS8cMar6kKnGSnnH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE5MiBTYWx0ZWRfXyFZ8yy1rCtML
 tciBKpheE3w81F6qe9QrQthiQ4EF5a24ryTFPqBPShRonTKQ6nF9MYyQuq6WxmYFB1iDmvQ6Ot4
 Je9ArPw0vqr0B8bEgcl7IiZNhWcn1NmJrvmeC7cpw3xs9J4Ex0eCutCg8ycNgglCCpxaDhIIaEx
 FVQMfwxW61HkDUzeLcB4eg7hskL9WlwlnbgQ+ShV7zMa6nhhrCzkq2UmZjRE07vorMSTKzeEc76
 ZIy7KZIoK6vTrUGTAIVKTReM6tsp1aVRJ6+UOX1NUyw4u9tlCS6O2dxxFR2+FRz1tGPuF7/sgV8
 kKapk7V0RoqfCnmYQPnaC2rOJzr04902ibZb9+UWTHK0fOBkBtjWfIWjz1E598=
X-Authority-Analysis: v=2.4 cv=IY+HWXqa c=1 sm=1 tr=0 ts=68b9e83f cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=pcUKOSzlLy4e-RmLerQA:9
 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 test/Makefile              |   1 +
 test/sqe-mixed-uring_cmd.c | 168 +++++++++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+)

diff --git a/test/Makefile b/test/Makefile
index a36c70a4..25af26a2 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -234,6 +234,7 @@ test_srcs :=3D \
 	sq-space_left.c \
 	sqe-mixed-nop.c \
 	sqe-mixed-bad-wrap.c \
+	sqe-mixed-uring_cmd.c \
 	sqwait.c \
 	stdout.c \
 	submit-and-wait.c \
diff --git a/test/sqe-mixed-uring_cmd.c b/test/sqe-mixed-uring_cmd.c
index e69de29b..b213270b 100644
--- a/test/sqe-mixed-uring_cmd.c
+++ b/test/sqe-mixed-uring_cmd.c
@@ -0,0 +1,168 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: mixed sqes utilizing basic nop and io_uring passthrough =
commands
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "helpers.h"
+#include "liburing.h"
+#include "../src/syscall.h"
+#include "nvme.h"
+
+#define min(a, b)	((a) < (b) ? (a) : (b))
+
+static int seq;
+
+static int test_single_nop(struct io_uring *ring, unsigned req_flags)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	sqe =3D io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		goto err;
+	}
+
+	io_uring_prep_nop(sqe);
+	sqe->user_data =3D ++seq;
+	sqe->flags |=3D req_flags;
+
+	ret =3D io_uring_submit(ring);
+	if (ret <=3D 0) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		goto err;
+	}
+	if (cqe->user_data !=3D seq) {
+		fprintf(stderr, "Unexpected user_data: %ld\n", (long) cqe->user_data);
+		goto err;
+	}
+	io_uring_cqe_seen(ring, cqe);
+	return T_EXIT_PASS;
+err:
+	return T_EXIT_FAIL;
+}
+
+static int test_single_nvme_read(struct io_uring *ring, int fd)
+{
+	struct nvme_uring_cmd *cmd;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	unsigned len =3D 0x1000;
+	unsigned char buf[0x1000] =3D {};
+
+	sqe =3D io_uring_get_sqe128_mixed(ring);
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		goto err;
+	}
+
+	sqe->fd =3D fd;
+	sqe->user_data =3D ++seq;
+	sqe->opcode =3D IORING_OP_URING_CMD;
+	sqe->cmd_op =3D NVME_URING_CMD_IO;
+
+	cmd =3D (struct nvme_uring_cmd *)sqe->cmd;
+	memset(cmd, 0, sizeof(struct nvme_uring_cmd));
+	cmd->opcode =3D nvme_cmd_read;
+	cmd->cdw12 =3D (len >> lba_shift) - 1;
+	cmd->addr =3D (__u64)(uintptr_t)buf;
+	cmd->data_len =3D len;
+	cmd->nsid =3D nsid;
+
+	ret =3D io_uring_submit(ring);
+	if (ret <=3D 0) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		goto err;
+	}
+	if (cqe->res !=3D 0) {
+		fprintf(stderr, "cqe res %d, wanted 0\n", cqe->res);
+		goto err;
+	}
+	if (cqe->user_data !=3D seq) {
+		fprintf(stderr, "Unexpected user_data: %ld\n", (long) cqe->user_data);
+		goto err;
+	}
+
+	io_uring_cqe_seen(ring, cqe);
+	return T_EXIT_PASS;
+err:
+	return T_EXIT_FAIL;
+}
+
+static int test_io(const char *file)
+{
+	struct io_uring_params p =3D { .flags =3D IORING_SETUP_SQE_MIXED };
+	struct io_uring ring;
+	int fd, ret, i;
+
+	fd =3D open(file, O_RDONLY);
+	if (fd < 0) {
+		if (errno =3D=3D EACCES || errno =3D=3D EPERM)
+			return T_EXIT_SKIP;
+		perror("file open");
+		goto err;
+	}
+
+	ret =3D io_uring_queue_init_params(8, &ring, &p);
+	if (ret) {
+		if (ret =3D=3D -EINVAL)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		goto close;
+	}
+
+	for (i =3D 0; i < 32; i++) {
+		if (i & 2)
+			ret =3D test_single_nvme_read(&ring, fd);
+		else
+			ret =3D test_single_nop(&ring, 0);
+
+		if (ret) {
+			fprintf(stderr, "test_single_nop failed\n");
+			goto exit;
+		}
+	}
+
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+exit:
+	io_uring_queue_exit(&ring);
+close:
+	close(fd);
+err:
+	return T_EXIT_FAIL;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc < 2)
+		return T_EXIT_SKIP;
+
+	ret =3D nvme_get_info(argv[1]);
+	if (ret)
+		return T_EXIT_SKIP;
+
+	return test_io(argv[1]);
+}
--=20
2.47.3


