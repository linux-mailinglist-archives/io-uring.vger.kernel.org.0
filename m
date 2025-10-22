Return-Path: <io-uring+bounces-10128-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2FF0BFD96F
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 260343BB951
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4A628489B;
	Wed, 22 Oct 2025 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="KIGBpllu"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EEA296BBA
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153685; cv=none; b=KMm1/vnwftMTXT+aKG4U2BzSQjy4yjgAYoAYi3cvzKNDxQ7+411AFSLaS0C8MDfXT3D69hPVKGzpHl9SSl/rnKNhIAVEH/hOc1DNl3l21jil5grlZiysCS49utvKzFXBS5WSql/82c4KWoNU/DwOGMRHV00VBvCBcm1KMz0xLJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153685; c=relaxed/simple;
	bh=xYty6kMnKBJzO6fJgCSm9qsHMY6MNt4Ud3trbZoLTnQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MDtkPLum/HYwzMdwmOKdzLi+uDwLz/YibEbV55LfkO99EXU6+Y693u+udvVTNP2JV7kf12hLZGpa7XZVl/09Tynwmo8e0iJfGlpzJp6r3mS5g7EXvvrwCfl2LaIdhrCYU9544+kl0XYRfLpvCnXTDCWwfWifk0VGwhrVn9oCDDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=KIGBpllu; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59ME9TQr3459161
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=v7f/LfZgq29SzdL+XvIompsM1wobsR0aFUU+YNwJXjs=; b=KIGBpllubLbR
	SLD4+SgfPuPefgvxrPf/yAE5+/0TmIxzvK6zQoS7zV2b/+qncRtFXhv8xPUaeV1x
	SjHcRZR/aLhmmKRCNcuXG75YvGDvv2em8hIH0C8YVuuQsetAxPEIZxSYD043QS+1
	N7G0k/3FtrdhsUT+JmEIZSNHL2zcg7X9r889DSdVtoHqccmk0h+u87/cbHIzE0Ui
	K1fON6PsFSBvPIH+0mIwwMS6jAmtbR3/KJKUVnmv1uoabu/Wk73M03xT7ILJamSG
	XNtTkBmv1+u9RTfC6E4MAKxlWmzpbaBXTNckmbCKSaA0cZAB0OeJpYogZ4zZcpt3
	jx+eTPi7Ow==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49y0sjssbr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:21 -0700 (PDT)
Received: from twshared0973.10.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 22 Oct 2025 17:21:18 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id E9B052F95CB6; Wed, 22 Oct 2025 10:21:04 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv6 4/6] test: add mixed sqe test for uring commands
Date: Wed, 22 Oct 2025 10:19:22 -0700
Message-ID: <20251022171924.2326863-5-kbusch@meta.com>
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
X-Proofpoint-GUID: BJIU8Y2dwzrttmOdvonr8rZ56T80HiDk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDE0MSBTYWx0ZWRfX3Wp4yFhBU43l
 6ZFgMvi7L41/HEviFJZHxKZ1y84LsJxCRX7ZLnpuoAo9O7eDoepCZGNi6eoGUFNyKZGbyanHpnJ
 dt/zes4ta9vqLzgpI21B58Ie79hMfbeJ3Zm8eB4cUfTKgRyyUFJpyXbgAfXpnWkvmWG70gtXZ3b
 1X/WQ/2/z+O6Lyxe2J/PCAvsTPPvPimLGHA3xXYG/IytUss0fm6WI5MOk9+1iSia/adyEz9/rf/
 UI9y73izjBfPbARPQCTAtpnJ6LNLMnaoyzMJVTjKVtPB9w4a4iFBOGTv2w7lDmA03WQTQF4mwc8
 OwYsl+f/3ZT7TG1NHHxf4/omytgVVOzpquf50I3cB7Oul+rRNGlyAPC/i06+PRoFWv0a2+TyxYg
 QFe1++6YVFQKEente77t+mKtUG/EUg==
X-Authority-Analysis: v=2.4 cv=AoLjHe9P c=1 sm=1 tr=0 ts=68f91291 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=w5sShh_0rNn-CcVtX0AA:9
X-Proofpoint-ORIG-GUID: BJIU8Y2dwzrttmOdvonr8rZ56T80HiDk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_07,2025-10-22_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 test/Makefile              |   1 +
 test/sqe-mixed-uring_cmd.c | 140 +++++++++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+)

diff --git a/test/Makefile b/test/Makefile
index ee1d492c..ee983680 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -239,6 +239,7 @@ test_srcs :=3D \
 	sq-space_left.c \
 	sqe-mixed-nop.c \
 	sqe-mixed-bad-wrap.c \
+	sqe-mixed-uring_cmd.c \
 	sqwait.c \
 	stdout.c \
 	submit-and-wait.c \
diff --git a/test/sqe-mixed-uring_cmd.c b/test/sqe-mixed-uring_cmd.c
index e69de29b..c3002e38 100644
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
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+	} else if (cqe->user_data !=3D seq) {
+		fprintf(stderr, "Unexpected user_data: %ld\n", (long) cqe->user_data);
+	} else {
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
+	sqe =3D io_uring_get_sqe128(ring);
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
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+	} else if (cqe->res !=3D 0) {
+		fprintf(stderr, "cqe res %d, wanted 0\n", cqe->res);
+	} else if (cqe->user_data !=3D seq) {
+		fprintf(stderr, "Unexpected user_data: %ld\n", (long) cqe->user_data);
+	} else {
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
+		if (ret =3D=3D -EINVAL) {
+			ret =3D T_EXIT_SKIP;
+		} else {
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


