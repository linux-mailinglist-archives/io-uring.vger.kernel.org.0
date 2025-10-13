Return-Path: <io-uring+bounces-9985-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FE55BD5A0C
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 20:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CC1AF4EA15A
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 18:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFFE2C21F6;
	Mon, 13 Oct 2025 18:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="jrYtJTx+"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9635925A642
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 18:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760378430; cv=none; b=aVGfA1mo9NGcYu6CGKnGSLgtZAtLTM4clMfJA1qGXcqhlUrxG3JwhBKn5eKNFcZG92zp+mbDypex3YGcTrP8h12g/Uy9++wCo+S4gax+ac2W9ooFl+4xULt+mufBjVnpgn6MANUWIGVLzQEF/6Y9gsBhWUqobM1f0PclQp9w9XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760378430; c=relaxed/simple;
	bh=lR2HypDOCDV+em35VG5pBFZajdAfR74vJ33e4hnocEk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M7H2HuGWYnDFQkId/zwO35jkL1uPzxa5Weap0+VsQke4Qm/2P62RVNjfBVhBHA3DN76BWRbGU1WrrsMhZPUxg4QSw0/uvc8UxooQG+ArChenz6DYwbPlVlnDrlvq9hbKuYPgGf1ViGGsOVvTjvP26nWKzObrBhJOIeWBiw3VsVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=jrYtJTx+; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59DEMkuK1942041
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=PoxYAmsV9m33R/q3ZMo+C+/vdUOx8esMgPo53qB3aOo=; b=jrYtJTx+qxhy
	pKQNjMheQQqobHpYIy+guOeH6mPfNV3LFeFJFW1X78wcUAB0cNjVL89TyDFijtia
	SRjIcuzsWP+dqrukNpg0I4ziTCKUXEogUiiCSQ50REfWW1KptrDWpAgp9/vYlzTS
	bL3qDnmpCbfBvPW0CpZ6hY6Og2NAKZLX1I92veKLPXH4JA6E4NDZ0YtvGreu6BRG
	WkVY4rWqcZtBCV9Fov+p5hBlyYP533ekB8RagSZUFBFlsrrqg9wYnKMjcdwvRkic
	34EjOhegmIwiaX3/fzNdQ8krekIKktyAY6Z+9aDFpMF4F+7Jnrw4aQZqq9LK5RRV
	o20PaM6xfA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49s34vt0a8-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:27 -0700 (PDT)
Received: from twshared28390.17.frc2.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 13 Oct 2025 18:00:20 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 8CC6A2AB3F7F; Mon, 13 Oct 2025 11:00:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 3/4] Add nop testing for IORING_SETUP_SQE_MIXED
Date: Mon, 13 Oct 2025 11:00:10 -0700
Message-ID: <20251013180011.134131-6-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEzMDA4MSBTYWx0ZWRfXwVzFkxZ7diZ7
 ijwCrN4qLDw0kqYXTnUsRje9qo+LVFbyY0GLBaRQvU+JF+frehyX19UnWIk93M17LmC0Ee9No6+
 AFzSb6h32tjBgJPwxuIh0fhqXGfhKrYTuWKdBG32P5Tal0cD5SGyJ0t+iuWG3/+8esaEtxEPLGH
 Rh5nKN1s4+t2ndYq8zytJCbqcaas3K+4La3VCDmOOkHD/7OBXJiYqa+LKy6GoHv6ZoQoIPvYyGW
 X+LSBGeVhsO3S6zGsrkI8HhFtVT0yZKO6cKv2PLmLamp5/TvgAI9U9NzH+SO7og4VFhXIcobn3f
 jFcHnIbT7rYdgUiD2V7e8Dj6okJJ+icrMJAuQ4jJIB3nrXmO2punjN0eVTryMPvHxI10vxqIv8w
 AMr0FpG+c1TbZ8ThaimyY6/y8yfhIw==
X-Proofpoint-GUID: fHVVXwx_RxHLytlO9C33rCUinWbl2VxW
X-Authority-Analysis: v=2.4 cv=TMBIilla c=1 sm=1 tr=0 ts=68ed3e3b cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=4oBl-Kg93MU8AgFfKNIA:9
X-Proofpoint-ORIG-GUID: fHVVXwx_RxHLytlO9C33rCUinWbl2VxW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_06,2025-10-06_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Test mixing 64 and 128 byte sqe entries on a queue.

Insert a bad 128b operation at the end of a mixed sqe to test the
kernel's invalid entry detection.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 test/Makefile              |  2 +
 test/sqe-mixed-bad-wrap.c  | 87 ++++++++++++++++++++++++++++++++++++++
 test/sqe-mixed-nop.c       | 82 +++++++++++++++++++++++++++++++++++
 test/sqe-mixed-uring_cmd.c |  0
 4 files changed, 171 insertions(+)
 create mode 100644 test/sqe-mixed-bad-wrap.c
 create mode 100644 test/sqe-mixed-nop.c
 create mode 100644 test/sqe-mixed-uring_cmd.c

diff --git a/test/Makefile b/test/Makefile
index 64d67a1e..2c250c81 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -234,6 +234,8 @@ test_srcs :=3D \
 	sq-poll-share.c \
 	sqpoll-sleep.c \
 	sq-space_left.c \
+	sqe-mixed-nop.c \
+	sqe-mixed-bad-wrap.c \
 	sqwait.c \
 	stdout.c \
 	submit-and-wait.c \
diff --git a/test/sqe-mixed-bad-wrap.c b/test/sqe-mixed-bad-wrap.c
new file mode 100644
index 00000000..d67f06c5
--- /dev/null
+++ b/test/sqe-mixed-bad-wrap.c
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: run various nop tests
+ *
+ */
+#include <stdio.h>
+
+#include "liburing.h"
+#include "helpers.h"
+#include "test.h"
+
+static int seq;
+
+static int test_single_nop(struct io_uring *ring, bool should_fail)
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
+	if (should_fail)
+		io_uring_prep_nop128(sqe);
+	else
+		io_uring_prep_nop(sqe);
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
+	else if (should_fail && cqe->res =3D=3D 0)
+		fprintf(stderr, "Unexpected success\n");
+	else if (!should_fail && cqe->res !=3D 0)
+		fprintf(stderr, "Completion error:%d\n", cqe->res);
+	else if (cqe->res =3D=3D 0 && cqe->user_data !=3D seq)
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
+	int ret, i;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_SQE_MIXED);
+	if (ret) {
+		if (ret =3D=3D -EINVAL)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	/* prime the sq to the last entry before wrapping */
+	for (i =3D 0; i < 7; i++) {
+		ret =3D test_single_nop(&ring, false);
+		if (ret !=3D T_EXIT_PASS)
+			goto done;
+	}
+
+	/* inserting a 128b sqe in the last entry should fail */
+	ret =3D test_single_nop(&ring, true);
+	if (ret !=3D T_EXIT_PASS)
+		goto done;
+
+	/* proceeding from the bad wrap should succeed */
+	ret =3D test_single_nop(&ring, false);
+done:
+	io_uring_queue_exit(&ring);
+	return ret;
+}
diff --git a/test/sqe-mixed-nop.c b/test/sqe-mixed-nop.c
new file mode 100644
index 00000000..88bd6ad2
--- /dev/null
+++ b/test/sqe-mixed-nop.c
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: run various nop tests
+ *
+ */
+#include <stdio.h>
+
+#include "liburing.h"
+#include "helpers.h"
+#include "test.h"
+
+static int seq;
+
+static int test_single_nop(struct io_uring *ring, bool sqe128)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	if (sqe128)
+		sqe =3D io_uring_get_sqe128_mixed(ring);
+	else
+		sqe =3D io_uring_get_sqe(ring);
+
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	if (sqe128)
+		io_uring_prep_nop128(sqe);
+	else
+		io_uring_prep_nop(sqe);
+
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
+	else if (cqe->res !=3D 0)
+		fprintf(stderr, "Completion error:%d\n", cqe->res);
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
+	int ret, i;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret =3D io_uring_queue_init(8, &ring, IORING_SETUP_SQE_MIXED);
+	if (ret) {
+		if (ret =3D=3D -EINVAL)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	/* alternate big and little sqe's */
+	for (i =3D 0; i < 32; i++) {
+		ret =3D test_single_nop(&ring, i & 1);
+		if (ret !=3D T_EXIT_PASS)
+			break;
+	}
+
+	io_uring_queue_exit(&ring);
+	return ret;
+}
diff --git a/test/sqe-mixed-uring_cmd.c b/test/sqe-mixed-uring_cmd.c
new file mode 100644
index 00000000..e69de29b
--=20
2.47.3


