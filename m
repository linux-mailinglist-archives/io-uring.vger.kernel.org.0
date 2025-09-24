Return-Path: <io-uring+bounces-9873-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA39B9A8CD
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 17:16:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EF4D4E124D
	for <lists+io-uring@lfdr.de>; Wed, 24 Sep 2025 15:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F11E30CB4F;
	Wed, 24 Sep 2025 15:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="HMFrvPsl"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB29430BB94
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758726750; cv=none; b=jP8/hAakIFhIhqs4gMNjWvAW4fBIwIPA4OkK5jXD+a5IQrfA4L4sBlUZvBXit9ZVHPH/LMIqIzISi4nyyLRyBNB3CrofIMg3YsjDmg1US0WTuAmMK5IcQTU4YIHMLtBjf0S96v1MUwJH/nuI87tRMa54k1zQsLpwpVrwIhH7gfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758726750; c=relaxed/simple;
	bh=A9lWGUHrM4qcm267U/k5laFfZ6R+rbUdjjKK2KahUv4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QPdd9RsXSzmLu/3Ff8LD9+IuFwG3ZQQj7uhmhD0R94oJ0NcwFg2X3ksgcXVmUxpBVPoNXBfP9ZK3dGVR3kfjJWY62Fra6Myrhx/C2ttAERgOMkT+0h+wr5d9zSBe4Bd48prt4AHGskLmlTA4Pwf95dt2pl/imrgqBCOHzji8RUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=HMFrvPsl; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58OEAWrP2958973
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 08:12:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=Y31kTR3MRkJqt/uz4S5yuQUc89AotQedGx/+Usqqt5U=; b=HMFrvPslZFty
	SbN58cQP8PnScov40f83ZKVYfcVIkqREyy6x6yTl10hMbMoImS64zHyO/R684uo4
	s/W49HHGP6DhrAvJN2nXt/x+dcxY2Y5LzCf89l1jE0xt2skfPpXr2S4ZmdNwDFEs
	xEqTbucAYpjtfGoDp+2UAVRGmLrsPSfu6p7FVFrVSMvPIazCsCnmMDbT617LWDwc
	GvdBzLHsNUThafKaNao/qYe2ZRQKyMvQ88+TPAfUnKCBWAM5sJnxCKE9mNZbbFsW
	7wqwJjOiB04oXaalh3X250xW4Ot7vhmVXGkfFVcE6iDesyQ337h/utLqZMLpL2IP
	vc2byztcvw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49c7mxc861-14
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 24 Sep 2025 08:12:27 -0700 (PDT)
Received: from twshared10560.01.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 24 Sep 2025 15:12:24 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 06C47208B9E0; Wed, 24 Sep 2025 08:12:14 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <csander@purestorage.com>, <ming.lei@redhat.com>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCHv3 2/3] Add nop testing for IORING_SETUP_SQE_MIXED
Date: Wed, 24 Sep 2025 08:12:09 -0700
Message-ID: <20250924151210.619099-4-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: QWMcfDcyrPqhYiIToCuHmuLMHZv_mODE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI0MDEzMSBTYWx0ZWRfX7vBT03qRCfFy
 +4a6j0xZ9dqMO3QEM1E/W4znAhB4kjLE6XsM+McS9F/CqHmRG8AYN4uKtbBHI7Gn5hjmQdl5ALe
 rYhyRIewJ9LXQ2FapFZG1WMDfZSnfQ/kg1Ut/7qVpG/glrXbmxb/oauJ8ixp82fl22xN9FmeEqX
 6wir6KiVwhFO6kajSEF+f+n9GxaVrNHoH10rNc4BG32DqF8k01NZpQaP6BKNAnIz1O7wHyemlJZ
 2pFe1TwETq4Fhod7R/n3GxUTGVnloE0p4UJZHQokjQ5i4cP/EGrXwdFeFz2xLz7Jw70cNKapF/M
 jAVrNa3eI2xCGpfSGH4ZoSna9BPWFKcC7n5Tq/CNJQb+B9I47+cH2k5/6rxqUE=
X-Authority-Analysis: v=2.4 cv=ErPSrTcA c=1 sm=1 tr=0 ts=68d40a5b cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=4oBl-Kg93MU8AgFfKNIA:9
X-Proofpoint-GUID: QWMcfDcyrPqhYiIToCuHmuLMHZv_mODE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_03,2025-09-22_05,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Test mixing 64 and 128 byte sqe entries on a queue.

Insert a bad 128b operation at the end of a mixed sqe to test the
kernel's invalid entry detection.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 test/Makefile              |  2 +
 test/sqe-mixed-bad-wrap.c  | 89 ++++++++++++++++++++++++++++++++++++++
 test/sqe-mixed-nop.c       | 82 +++++++++++++++++++++++++++++++++++
 test/sqe-mixed-uring_cmd.c |  0
 4 files changed, 173 insertions(+)
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
index 00000000..61f711da
--- /dev/null
+++ b/test/sqe-mixed-bad-wrap.c
@@ -0,0 +1,89 @@
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
+	io_uring_prep_nop(sqe);
+	sqe->user_data =3D ++seq;
+
+	if (should_fail)
+		io_uring_prep_nop128(sqe);
+	else
+		io_uring_prep_nop(sqe);
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


