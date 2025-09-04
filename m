Return-Path: <io-uring+bounces-9572-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D4D9CB4465A
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 21:27:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75FA41CC1263
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 19:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A7E271A94;
	Thu,  4 Sep 2025 19:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="udGwExCr"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A95525B1D2
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 19:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757014057; cv=none; b=q4uE4TbvjdeuQPlq8W2RmCUz7F3uk2v2nDkmJeXL/iI73hCy08WhWDO9RWNUkJHG5gCDflyZyGDNCz9PLbSHVzaCpZa1Hivc5/k3HIGrpw94sIcySV0WzzAeUJbxou0r8NFIELjaZ+xhQ9msJG+n90Q5UjYTKCFojcn9PIrWgjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757014057; c=relaxed/simple;
	bh=djQwJPsRhVGlB5xAp6UwqI/d/I2+XdZdgwWLQw3BqBE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V4Z0ZnyT+ocnNaj9o80dPZrDP2WQi0MKFjdX9bKwdR4MmN7rTUCPF2Urc5GK4VxVDbMtczgfURUwEaUxDdrghh7IVtdQ8ozwJDfhBy8GfPbtuUKChvrBaJluAqpbFaGBM3bYBhYlKEUreWWSa4QzRl8ekbR3mRvmRh3XCZBP71c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=udGwExCr; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 584J81wN2526811
	for <io-uring@vger.kernel.org>; Thu, 4 Sep 2025 12:27:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=uSQQVeuncBPRtUKh4SVzAUX3Vk/zTBc2utsCKViaP1U=; b=udGwExCrGYcj
	jN4CUzBlV/jgFfAHUN4W6hYoiR8QDlKOGgAvNOCbNSn59cUmqU37lC+2jveKktY7
	ycbd/qiZIdf7/qtnLxO/y6D9PYJfCaojo9SHtIdPygJ2Wek41464nMVioc7FnFG+
	621SAq/IFQQrNDNqprBlXsIut3QGFmcgmY7j2QJ8XomZFvWWZG1PsH/Alf4HUzWt
	FpfarGgQ9979fznFI+nioS88k30cuQJOALLgBbMsTMUtRkOEAGLSJPTtAcUFWNph
	ZIoLE2z2U5HZmI0Kw3KS9cH9h9xTbyr2hoesNxHRzG+66NaK+LnMJhhc+o6f5OFN
	SSyAXtGJYw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 48ydqcaacf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 12:27:34 -0700 (PDT)
Received: from twshared71707.17.frc2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 4 Sep 2025 19:27:31 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 9D68C1578788; Thu,  4 Sep 2025 12:27:22 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [RFC PATCHv2 2/3] Add nop testing for IORING_SETUP_SQE_MIXED
Date: Thu, 4 Sep 2025 12:27:15 -0700
Message-ID: <20250904192716.3064736-4-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE5MiBTYWx0ZWRfX2Yd1DFhxzVLr
 B7kowzAZhIHDPQQa1MHLzbsybNpDAP85rK9FEry8PCl/Cb8R1yeyHUYCMwGsAlpJWac2kIFyvmZ
 AIWQ4NUQxa8wvY0DfuW9IML3fQoABOcNluEF6SvFqwejkQdK7/a09wjJHZxBNn1+JU2ikXl71rH
 5h4xYL17viRTj/+hlkyZKtjUBpFBzqMYYg9ERKVBZH830c8bBx0W6927jla3GcCYCsWg9z8mJyo
 PuiX6JMdM22tUMFIbKZ7xANH+8jaFmXN1oXDAPZJWq2dEzOtBh2zZCPK36vBkpgOmFLojLnRg1Z
 8ePfl9rBw1ZmxT277obNzHfegujP7D+SG0C5eBERKCWZ+J9LsJe+QapH2H0TuE=
X-Proofpoint-GUID: vmBpT43WDsDnVvgwLRKsabJb-rRrYarL
X-Authority-Analysis: v=2.4 cv=HZMUTjE8 c=1 sm=1 tr=0 ts=68b9e826 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=cTxCplQNprFiquemU4IA:9
X-Proofpoint-ORIG-GUID: vmBpT43WDsDnVvgwLRKsabJb-rRrYarL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Add NOP testing for mixed sized SQEs.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 test/Makefile              |   2 +
 test/sqe-mixed-bad-wrap.c  | 121 +++++++++++++++++++++++++++++++++++++
 test/sqe-mixed-nop.c       | 104 +++++++++++++++++++++++++++++++
 test/sqe-mixed-uring_cmd.c |   0
 4 files changed, 227 insertions(+)
 create mode 100644 test/sqe-mixed-bad-wrap.c
 create mode 100644 test/sqe-mixed-nop.c
 create mode 100644 test/sqe-mixed-uring_cmd.c

diff --git a/test/Makefile b/test/Makefile
index 54251bf2..a36c70a4 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -232,6 +232,8 @@ test_srcs :=3D \
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
index 00000000..25764fff
--- /dev/null
+++ b/test/sqe-mixed-bad-wrap.c
@@ -0,0 +1,121 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: run various nop tests
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include "liburing.h"
+#include "helpers.h"
+#include "test.h"
+
+static int seq;
+
+static int test_single_nop(struct io_uring *ring, unsigned req_flags,
+			   bool should_fail)
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
+	if (should_fail && cqe->res =3D=3D 0) {
+		fprintf(stderr, "Unexpected success\n");
+		goto err;
+	}
+	if (!should_fail && cqe->res !=3D 0) {
+		fprintf(stderr, "Completion error:%d\n", cqe->res);
+		goto err;
+	}
+	if (cqe->res =3D=3D 0 && cqe->user_data !=3D seq) {
+		fprintf(stderr, "Unexpected user_data: %ld\n", (long) cqe->user_data);
+		goto err;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	return T_EXIT_PASS;
+err:
+	return T_EXIT_FAIL;
+}
+
+static int test_ring(unsigned flags)
+{
+	struct io_uring_params p =3D { };
+	struct io_uring ring;
+	int ret, i;
+
+	p.flags =3D flags;
+	ret =3D io_uring_queue_init_params(8, &ring, &p);
+	if (ret) {
+		if (ret =3D=3D -EINVAL)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	for (i =3D 0; i < 7; i++) {
+		ret =3D test_single_nop(&ring, 0, false);
+		if (ret)
+			goto err;
+	}
+
+	/* inserting a 128b sqe at the end should fail */
+	ret =3D test_single_nop(&ring, IOSQE_SQE_128B, true);
+	if (ret)
+		goto err;
+
+	/* proceeding from the bad wrap should succeed */
+	ret =3D test_single_nop(&ring, 0, false);
+	if (ret)
+		goto err;
+
+	io_uring_queue_exit(&ring);
+	return ret;
+err:
+	fprintf(stderr, "test_single_nop failed\n");
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret =3D test_ring(IORING_SETUP_SQE_MIXED);
+	if (ret =3D=3D T_EXIT_SKIP) {
+		return T_EXIT_SKIP;
+	} else if (ret !=3D T_EXIT_PASS) {
+		fprintf(stderr, "Mixed ring test failed\n");
+		return ret;
+	}
+
+	return T_EXIT_PASS;
+}
diff --git a/test/sqe-mixed-nop.c b/test/sqe-mixed-nop.c
new file mode 100644
index 00000000..91c1c795
--- /dev/null
+++ b/test/sqe-mixed-nop.c
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: run various nop tests
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include "liburing.h"
+#include "helpers.h"
+#include "test.h"
+
+static int seq;
+
+static int test_single_nop(struct io_uring *ring, unsigned req_flags, bo=
ol sqe128)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	if (sqe128)
+		sqe =3D io_uring_get_sqe128_mixed(ring);
+	else
+		sqe =3D io_uring_get_sqe(ring);
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
+static int test_ring(unsigned flags)
+{
+	struct io_uring_params p =3D { };
+	struct io_uring ring;
+	int ret, i;
+
+	p.flags =3D flags;
+	ret =3D io_uring_queue_init_params(8, &ring, &p);
+	if (ret) {
+		if (ret =3D=3D -EINVAL)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	/* alternate big and little sqe's */
+	for (i =3D 0; i < 32; i++) {
+		ret =3D test_single_nop(&ring, 0, i & 2);
+		if (ret) {
+			printf("fail off %d\n", i);
+			fprintf(stderr, "test_single_nop failed\n");
+			goto err;
+		}
+	}
+err:
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret =3D test_ring(IORING_SETUP_SQE_MIXED);
+	if (ret =3D=3D T_EXIT_SKIP) {
+		return T_EXIT_SKIP;
+	} else if (ret !=3D T_EXIT_PASS) {
+		fprintf(stderr, "Mixed ring test failed\n");
+		return ret;
+	}
+
+	return T_EXIT_PASS;
+}
diff --git a/test/sqe-mixed-uring_cmd.c b/test/sqe-mixed-uring_cmd.c
new file mode 100644
index 00000000..e69de29b
--=20
2.47.3


