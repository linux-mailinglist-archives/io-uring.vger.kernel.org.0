Return-Path: <io-uring+bounces-10127-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EB28BFD96C
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0E463BB814
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3965274B53;
	Wed, 22 Oct 2025 17:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="issQmhPL"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6087296BD8
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153681; cv=none; b=NPAkE/glo9hvVstK2DMzjzXmEMlfDry05c08HX03nx9aEMOanKiSoZrqEF8kFTz5fn5I4X7ztN6IXidQmAAMRcviQxxGegwVdKjHtb8l/O8pZapMBBgoxIphRYcF0M9LVT5Ez+8SnGOeVLlwgBnxxA6aEfjcqw6wj47qM1Z1lH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153681; c=relaxed/simple;
	bh=GYv0iYixDR650o0+6ky9c0cEe/iW5XqL0rNfxfV5mN8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kx8lk8UHMWJR1d7pYC6vOhZlxFpS7MGm+IWtQJdrJ1HI7+Nk9UZYxlsI9xnBHk3Tns2ksvJpY8dPw1uJj3B9S1LiDT4a/Wm3utt8U+H0CzYkLHOazbTkwJO0rnJRw4Eh7xNSARA4F9Ki/7g7SvATbAzi7wEOG9243el5WSyw7hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=issQmhPL; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59MEkf5G2949139
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=4aqCwgVyqH4VzjFmHJDMSxVAt0Y7yFQF2SP+BRx2VQs=; b=issQmhPLZE2R
	pLilU5He5rqIF30UmC0YGc8oouszeFD/buMdnKtto8ZC69OXwNO5Xirm1PLbeiAI
	Qdy2aKK/S50Gchv0XMxek4nqT8kgusCiQCa5m2f5cSJULc5bAT8M0rTFbPuKXcSD
	r8NalillJrzLRubWrxY8U9pNBw3vGDuG1C8uDK0X89ySwNw7AaeuQa1qsL8nDMF9
	X+vFTemJsi5cfmqLm7gTV0YMcMDG+FKeFjicZCFD0M4hnqxwSCsDgc+wEY5OCBzM
	YN7c4m/+RrKOF8qXkoSaCzbFW1wPB2uDW7H6BcT9gEXVIK5zFlKefMuMK/2d+Oxi
	2kmVP0CYEw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49y1b1sdrj-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:16 -0700 (PDT)
Received: from twshared28390.17.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 22 Oct 2025 17:21:12 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id DFF0C2F95CB4; Wed, 22 Oct 2025 10:21:04 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv6 3/6] test: add nop testing for IORING_SETUP_SQE_MIXED
Date: Wed, 22 Oct 2025 10:19:21 -0700
Message-ID: <20251022171924.2326863-4-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDE0MSBTYWx0ZWRfX0UVcLXhW6/zd
 20sbefRGTbz7i6czvLMI6ke71n8OfJpvshT6Dpp8Hhu7F23xNW9Acb9i+h0sFbjmy1Ju14X7efy
 MzvVWzeq0rZ+jchvg/BDiCZXae8Hm/W4XY9/t/fTbzHmxSxmDgDR44Ace8JV9CBh5pGxWnNNcdS
 KJ2GZN14ZExsmmSg8BYE+jgld67MrQuHPTewLOlVKWnlTrsj+zlWUm+ynJJKWdHo2Tyb+yDeBVw
 MkWY4euN7GnT6UJSRDoyB1gKib14Wa81C1Omttr5ZikEl+Jk5qcVs67xdeuiWzEv5gUy0t+lduq
 qf5gQ6HNivWTpNrbCg4CuqP3e08Gz5/ZkhHY/xwH9h1MbHNU8H0ZoW5NpN+TVU206xFoPU/tW9A
 7z4uqDTF9kV6GL9tlQwn1If+mtEPnw==
X-Proofpoint-ORIG-GUID: p7YZKOTSWUd44KWh2uGR4mC2YiZEIrRt
X-Authority-Analysis: v=2.4 cv=Xc2EDY55 c=1 sm=1 tr=0 ts=68f9128d cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=x8hzjm0sQ1bb8jhw__4A:9
X-Proofpoint-GUID: p7YZKOTSWUd44KWh2uGR4mC2YiZEIrRt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_07,2025-10-22_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Test mixing 64 and 128 byte sqe entries on a queue.

Also introduce a negative test case that inserts a bad 128b operation at
the end of a mixed sqe to test the kernel's invalid entry detection.

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
index b268cabf..ee1d492c 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -237,6 +237,8 @@ test_srcs :=3D \
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
index 00000000..ac0c8937
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
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+	} else if (should_fail && cqe->res =3D=3D 0) {
+		fprintf(stderr, "Unexpected success\n");
+	} else if (!should_fail && cqe->res !=3D 0) {
+		fprintf(stderr, "Completion error:%d\n", cqe->res);
+	} else if (cqe->res =3D=3D 0 && cqe->user_data !=3D seq) {
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
index 00000000..f8a232a7
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
+		sqe =3D io_uring_get_sqe128(ring);
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
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+	} else if (cqe->res !=3D 0) {
+		fprintf(stderr, "Completion error:%d\n", cqe->res);
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


