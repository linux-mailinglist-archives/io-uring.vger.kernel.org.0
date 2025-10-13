Return-Path: <io-uring+bounces-9979-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B2E5ABD59FA
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 20:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9590D4E4B57
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 18:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C17749659;
	Mon, 13 Oct 2025 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="efKfZm+0"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73282C324E
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 18:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760378421; cv=none; b=UXiNec5eBQXq1ZmbelgK5ia7H8xc2kjHzGGtRMDh2E26AiTkLCt7F/zEyNXhZ7aZY+FovlUkYC4XZQ788vC5Db+FAJYV6u5qdpQim2XqDDes2JM9BKlwPmJOqNnVqm+q3gXmi/exmhHSuEG7A0hEFwGCiP4vYoi/W7zfTFzVhWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760378421; c=relaxed/simple;
	bh=34QTmCLbLOP3psEEdfKeWa7t9vz1l6IlP1bVPDEJdkU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YFhqnBRBLT1tfS3E8Yr0Ph1Lhw+Yiste3F00ZzRApRNbYKBEtVtrbezqsm1wxjxEmpl5Xl2w9cc5PKUvIIkGhlRvlZ1BF2T+LQ5ljIfOdGmZuT1r3UxTikoW6mWKqdKTwVj/8HIahaiGxCeiG7E3vmovYtAvQWlEkbtJBiL4OgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=efKfZm+0; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59DGnhtS3878039
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=fR4GgeiwggC2Je31qKNMnP/dYZBgGxEiEjl5UkLSx8E=; b=efKfZm+0qk5v
	EE9ALiVGYXtYaIpXviap/5ifMldmw91tgEATykmjgXNHdIGrpyA6BvFVwtJYZb4b
	lsNBJ7GRKjqUAshDv3C+J+8e9a/Buk+zsT/xCMG7zUZqUC86ymMMbOHQWEtkAj9w
	Iah9DDCwHVs6SxDunTNL3i/I4hEaq1odMz4hbrSHNTx9LnRa9Ra5iaX/6l9xzIT3
	LNmFMC73sjPf+luStZLQrQeQWT/H8UUG3t5DHlqgobWn4zIgnOFMGwRUljOlAd71
	GR04sZwb5NE3yrCbqgiD4BAa90wef956TemkT4Xsy4K3WEgXsgaVfo8BAhF/PKhp
	ri1PM5TNyw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49s59s0mee-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:18 -0700 (PDT)
Received: from twshared25257.02.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 13 Oct 2025 18:00:15 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 947B82AB3F81; Mon, 13 Oct 2025 11:00:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 4/4] Add mixed sqe test for uring commands
Date: Mon, 13 Oct 2025 11:00:11 -0700
Message-ID: <20251013180011.134131-7-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEzMDA4MSBTYWx0ZWRfX8YOTJdeOUe7p
 /vL/mi+rMEqTses2IJeM4G5zHB5iuHfIhilYyroMhZWZ+jj/7TiDt1h+pzJfdi1pqhPkp+XhP5r
 8wD0+XhUBPw99PB4alowhG00Tn5enRzGET1HcLDlCXT8xegZ9ITvTKPN2Qn+c19H6XVekiLhCob
 9MIV3Yxk9ENOXruC2kvtpSkJuLf6vNukjJjck4KCyO7ULz2zkzRxafRcg2/S695MWNwf0Splbca
 qAdJKwIYowjEEuRKr87AjfkckN9rCpDXQ07UcqKOnPGGk0OVqFev1P/Kenu3aMdBVIVfc5Bq3HL
 U62cPaqqMw1jIrMfytA6lY2IvT50/buLitYrny5jsNOOKQ8KDzARBfEsneL4cKEs7Hlh0Cb2mMF
 VBAj7DebwogH3yadOnsYchKQAres4A==
X-Proofpoint-ORIG-GUID: q9N0iJ1OgksVVb8pRhrCC7mK7qRfaqfT
X-Authority-Analysis: v=2.4 cv=LoSfC3dc c=1 sm=1 tr=0 ts=68ed3e32 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=M6URQBIDleiIWeG3938A:9
X-Proofpoint-GUID: q9N0iJ1OgksVVb8pRhrCC7mK7qRfaqfT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_06,2025-10-06_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 test/Makefile              |   1 +
 test/sqe-mixed-uring_cmd.c | 140 +++++++++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+)

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
index e69de29b..7ac5f4ab 100644
--- a/test/sqe-mixed-uring_cmd.c
+++ b/test/sqe-mixed-uring_cmd.c
@@ -0,0 +1,140 @@
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
+	io_uring_prep_uring_cmd128(sqe, NVME_URING_CMD_IO, fd);
+	sqe->user_data =3D ++seq;
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


