Return-Path: <io-uring+bounces-9870-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B1CB9A8C4
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 17:15:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84D624E0CAB
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 15:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21FDA30C614;
	Wed, 24 Sep 2025 15:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="WkMCxxcn"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79573309EF4
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 15:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758726745; cv=none; b=GXG2GwVvoZ71S8rzgMBLylHmdFf52sYW5KfzwAUrV91Lu+tncsKpCcOprXNGKg/hAlBW/YqUnmpcEyIod8sqtNINRAmlIUw7cNejsUA7YXiGG8cfetASW4ee3Vllqi1eMGVsRcQkTk2dIEUV1qFertls+zt8sQzazTJVVeAClLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758726745; c=relaxed/simple;
	bh=2g/Ot2Ys9FkADNeCMs7lLKtSWaz1W5GXuEGZbjQFGss=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cF4sdkA9Ak9AFGrkb4VNciSoJs/by+F5/97Lf5tQ2CxKVr4J9ibUoNc8DMFYcSjchdHQ+CMpfRwYjZVcreDppjH1iRxzrqvGovZOuRTYjdacmbreAh8etsY8JaKhOhEciy6h9E26dACD958Wql8cStgxRu6muwQe/8rRFgBFF5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=WkMCxxcn; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58OEAWrB2958973
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 08:12:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=pj5AQFn4YkbUExoiq0qT0GjtV74UEsttaeyJ5MMXjco=; b=WkMCxxcnNNUr
	LJ/GGqhkzaw5pU/nK7zOmXF9xo5/e2i6NNMouNX/mbpY3cq1SFwsBcWVAqYv5aYc
	CapmLTZDC27PA1GNl9IadOvKXaNa9LUojuCdDZ6XM89qPsjyc6GqNC7kkV9OeQeJ
	sm+3BDzcljkZ2u4fgGyOh4Wo2RdZVzEEQHDGbypO8us4stagG5k/dcW/lDYzE6qy
	3vf2CBt0cQqtZZyIgMfeJFRbL2QCMAdZQBhTRbpnMQhMEHaOgui+QHtWJXvL9PBf
	tusrVBJJzmg1JDc8vUdNKVqKw4f6za5eg5Er5vnv3QI7Qwy7sUtzR/L8NxMC5O0c
	LgsqaWPmdQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49c7mxc861-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 08:12:22 -0700 (PDT)
Received: from twshared14631.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 24 Sep 2025 15:12:16 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 0A234208B9E2; Wed, 24 Sep 2025 08:12:14 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <csander@purestorage.com>, <ming.lei@redhat.com>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCHv3 3/3] Add mixed sqe test for uring commands
Date: Wed, 24 Sep 2025 08:12:10 -0700
Message-ID: <20250924151210.619099-5-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: i0lQCU7S80J78tH4YkVWv4ktjirSQCHi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI0MDEzMSBTYWx0ZWRfX5RqyH+fTOnXC
 sQpSfHZuX403vQiQWB4dAglyOAsg2aAe2GCmT7heW41qa6rl3f15SMUDqzaxjKXgNQf/IyssWHx
 F4LN6G+zqkLl/xH9WqxYgZp1sVb5H3E0VkpE2sKR7FgMegsALGDZsWICPjVIt9sXLgLZkDqt0nV
 2B4k/4zroNXeJF6n7BjXMDLmKC4bmKRrGkl1G3w1DI7jny18Kg3v6lxmE2KRcqEVfhTRJ4f3wdP
 7hPfe2lSXDWl/0kcQRcGxNLNr9nbqgVXfPKGHHsY1kmBTNf6D9wur3Oznm6CTGLaRpMpIt9zIbg
 784egTFv5mMeDXGUwsQotHo+41whZvIOVSdIktYKeV5cLTGsjyA9Vv1D8bsZwI=
X-Authority-Analysis: v=2.4 cv=ErPSrTcA c=1 sm=1 tr=0 ts=68d40a56 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=M6URQBIDleiIWeG3938A:9
X-Proofpoint-GUID: i0lQCU7S80J78tH4YkVWv4ktjirSQCHi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_03,2025-09-22_05,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 test/Makefile              |   1 +
 test/sqe-mixed-uring_cmd.c | 142 +++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+)

diff --git a/test/Makefile b/test/Makefile
index 2c250c81..2b2e3967 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -236,6 +236,7 @@ test_srcs :=3D \
 	sq-space_left.c \
 	sqe-mixed-nop.c \
 	sqe-mixed-bad-wrap.c \
+	sqe-mixed-uring_cmd.c \
 	sqwait.c \
 	stdout.c \
 	submit-and-wait.c \
diff --git a/test/sqe-mixed-uring_cmd.c b/test/sqe-mixed-uring_cmd.c
index e69de29b..4a6e7fd3 100644
--- a/test/sqe-mixed-uring_cmd.c
+++ b/test/sqe-mixed-uring_cmd.c
@@ -0,0 +1,142 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: mixed sqes utilizing basic nop and io_uring passthrough =
commands
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+
+#include "helpers.h"
+#include "liburing.h"
+#include "nvme.h"
+
+#define len 0x1000
+static unsigned char buf[len];
+static int seq;
+
+static int test_single_nop(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	sqe =3D io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	io_uring_prep_nop(sqe);
+	sqe->user_data =3D ++seq;
+
+	ret =3D io_uring_submit(ring);
+	if (ret <=3D 0) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0)
+		fprintf(stderr, "wait completion %d\n", ret);
+	else if (cqe->user_data !=3D seq)
+		fprintf(stderr, "Unexpected user_data: %ld\n", (long) cqe->user_data);
+	else {
+		io_uring_cqe_seen(ring, cqe);
+		return T_EXIT_PASS;
+	}
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
+	sqe =3D io_uring_get_sqe128_mixed(ring);
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	sqe->fd =3D fd;
+	sqe->user_data =3D ++seq;
+	sqe->opcode =3D IORING_OP_URING_CMD128;
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
+		return T_EXIT_FAIL;
+	}
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0)
+		fprintf(stderr, "wait completion %d\n", ret);
+	else if (cqe->res !=3D 0)
+		fprintf(stderr, "cqe res %d, wanted 0\n", cqe->res);
+	else if (cqe->user_data !=3D seq)
+		fprintf(stderr, "Unexpected user_data: %ld\n", (long) cqe->user_data);
+	else {
+		io_uring_cqe_seen(ring, cqe);
+		return T_EXIT_PASS;
+	}
+	return T_EXIT_FAIL;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int fd, ret, i;
+
+	if (argc < 2)
+		return T_EXIT_SKIP;
+
+	ret =3D nvme_get_info(argv[1]);
+	if (ret)
+		return T_EXIT_SKIP;
+
+	fd =3D open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		if (errno =3D=3D EACCES || errno =3D=3D EPERM)
+			return T_EXIT_SKIP;
+		perror("file open");
+		return T_EXIT_FAIL;
+	}
+
+	ret =3D io_uring_queue_init(8, &ring,
+		IORING_SETUP_CQE_MIXED | IORING_SETUP_SQE_MIXED);
+	if (ret) {
+		if (ret =3D=3D -EINVAL)
+			ret =3D T_EXIT_SKIP;
+		else {
+			fprintf(stderr, "ring setup failed: %d\n", ret);
+			ret =3D T_EXIT_FAIL;
+		}
+		goto close;
+	}
+
+	for (i =3D 0; i < 32; i++) {
+		if (i & 1)
+			ret =3D test_single_nvme_read(&ring, fd);
+		else
+			ret =3D test_single_nop(&ring);
+
+		if (ret)
+			break;
+	}
+
+	io_uring_queue_exit(&ring);
+close:
+	close(fd);
+	return ret;
+}
--=20
2.47.3


