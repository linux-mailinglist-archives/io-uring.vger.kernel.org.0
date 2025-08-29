Return-Path: <io-uring+bounces-9482-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 01AE9B3C33A
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 21:41:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFB061883AB1
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 19:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FBB924338F;
	Fri, 29 Aug 2025 19:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="BnL+n+e7"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2F42367C1
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 19:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496413; cv=none; b=N9FmGyZSb1qGmBtbxsEwNma+ND8bF8QcXarZpUNdExA/1m0f0Sbd6RYyFre/ab7MFA37//hTj0sI8rjJzv9U7mXJiCp4tmICEu79svrNuwAW4Elb/3N/1VyGPw9M5Mi+dHUvfV86GWgJvGZKKeJpe6zg7OfrYuucHCMpRN+AIMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496413; c=relaxed/simple;
	bh=4pKzTMcEthUYdFDcaffprinBOUQ13qJJ1hOkP8ym7kY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vjqjrawlj3Uwe1T9df7XMFjrgom+eLK0mI+/aPrjMMYOb1kDYbpYBLXd5IMXwIwPUuOqkMnaXomr0bLIvCrlumz6ovoWT5vxJPhA3ALlodVOaG4CU4vyk+QZM+YcHANm3fmD7KBVBOC35NzeyaBxl1ftHIGGW0Vu7CB9jYeTHlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=BnL+n+e7; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 57TFesn2251909
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 12:40:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=dWTiEnkifxJkKffHtK9V8i5yFhmU0VVhVJ3fNz5ElJA=; b=BnL+n+e7/KG4
	pTaRLrYr2i5jEZapfLvj8q2432wbzWOixMweWLJueQ5RZfth/8DhWaJfTRH1rwL2
	YT0Q1lbEgwceDPq/PBXKortIzY1cuOkWMRdkE8acTZwHTo1J14DxI+JmyoRsH2W0
	KuF1NH2w50Wcw2zsAoUQx1lqdwVncOcn6GWT4L5d7fqDxi6T+uyuIUXNocQDl77i
	p8zrsCn4jE2Pxrj3OY8xBiHirwZFJpY/kD2kBTVNyYZI8JczYqFSj0ZFgW1G3d4h
	2XxIhtA1jun6PkPOJ4ssWaBTw8JWI3D/mhr2BsUoCIJ+vt18UO9f8JayHNZs1kFY
	dyQylXwh8w==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 48uf2g1s0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 12:40:10 -0700 (PDT)
Received: from twshared14631.07.ash9.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.17; Fri, 29 Aug 2025 19:39:54 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id A8D01121EBB9; Fri, 29 Aug 2025 12:39:43 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <io-uring@vger.kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [RFC PATCH liburing 2/2] Add nop testing for IORING_SETUP_SQE_MIXED
Date: Fri, 29 Aug 2025 12:39:35 -0700
Message-ID: <20250829193935.1910175-4-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829193935.1910175-1-kbusch@meta.com>
References: <20250829193935.1910175-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=GZIXnRXL c=1 sm=1 tr=0 ts=68b2021a cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=SNxVTKBTcxwvBzQCkkQA:9
X-Proofpoint-GUID: kklYBRYpXGP_mJWJJoPXMhdkGo3X-r1P
X-Proofpoint-ORIG-GUID: kklYBRYpXGP_mJWJJoPXMhdkGo3X-r1P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI5MDE3NSBTYWx0ZWRfX6kfSypYMRdS1
 kW7VtINqJRWk8zyXqcPONBYcBLj5NEqOPcG+BhvouGkJEdTy1xMrJoP3S+tKFIIH6Cey1ha78jz
 HobCGbSzMmxx/fkBw+QjM7vDHoh+B1dd0OuAH3FGrG7NEVGNP3GJkf5Px40M8CGUof9klqjePnX
 MTeih0FRNhmSBX+GQFd5n5zKp1Pns1Bbcuo18YMWdgE6jvYIyaKzCVny6l3WkndZngmeIMc37I/
 Ahu7A+uovm9A9b/QF215eFwySfj+6UGrxGjiT6ad46rUJukyeXWevQYVvWrr2yv0Tl3AOh+N9br
 T19kF3W+z/CF8XiwrXtgqHwVpkAaszCnGCoc8JRMuu6sdDDWs1lgxZTuVxNgzA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_06,2025-08-28_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Add NOP testing for mixed sized SQEs.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 test/Makefile |   1 +
 test/nop128.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)
 create mode 100644 test/nop128.c

diff --git a/test/Makefile b/test/Makefile
index 54251bf2..b3a67393 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -150,6 +150,7 @@ test_srcs :=3D \
 	nop.c \
 	nop32.c \
 	nop32-overflow.c \
+	nop128.c \
 	ooo-file-unreg.c \
 	openat2.c \
 	open-close.c \
diff --git a/test/nop128.c b/test/nop128.c
new file mode 100644
index 00000000..f9a2dd93
--- /dev/null
+++ b/test/nop128.c
@@ -0,0 +1,105 @@
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
+		sqe =3D _io_uring_get_sqe128_mixed(ring);
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
+	struct io_uring ring;
+	struct io_uring_params p =3D { };
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
+	test_single_nop(&ring, 0, 0);
+
+	for (i =3D 0; i < 16; i++) {
+		ret =3D test_single_nop(&ring, 0, 1);
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
--=20
2.47.3


