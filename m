Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE99550E8C5
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244653AbiDYSyt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244644AbiDYSys (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:54:48 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55205B7C4F
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:51:42 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PIVgZA009596
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:51:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5/q2fe3Yvx0BFx6bwzHDjmmTcDp5N/V1IIPBIAlzvVY=;
 b=hFhbG0mXiFmvJg9TGZxstg0YqHxLKh2/iS15qjFcK0Oejk38lTBmahWBU/queP+VFS/O
 V/4CbBamekaJ4/xMtoCOS9W9zP+6sKijxQzhai6xU1At5AvDhbJHxv4zoayM+k4tczcy
 74tHSEIlIeTfdCICWEcQ7KkfOWfZUkVOojY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fp10e864h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:51:41 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:51:39 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 315F9E1F5C92; Mon, 25 Apr 2022 11:51:31 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v4 6/6] liburing: Test all configurations with NOP test
Date:   Mon, 25 Apr 2022 11:51:28 -0700
Message-ID: <20220425185128.2537966-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425185128.2537966-1-shr@fb.com>
References: <20220425185128.2537966-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: mJmH07M1_wD1bhywkX_eLMMFdrqPG2lk
X-Proofpoint-ORIG-GUID: mJmH07M1_wD1bhywkX_eLMMFdrqPG2lk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_10,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This runs the NOP test with all four configurations:
- default SQE and CQE size
- large SQE size
- large CQE size
- large SQE and large CQE size

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 test/nop.c  | 43 +++++++++++++------------------------------
 test/test.h | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 30 deletions(-)
 create mode 100644 test/test.h

diff --git a/test/nop.c b/test/nop.c
index 8656373..59da22c 100644
--- a/test/nop.c
+++ b/test/nop.c
@@ -11,6 +11,7 @@
 #include <fcntl.h>
=20
 #include "liburing.h"
+#include "test.h"
=20
 static int seq;
=20
@@ -127,12 +128,14 @@ err:
 	return 1;
 }
=20
-static int test_p(struct io_uring_params *p)
+static int test_ring(unsigned flags)
 {
 	struct io_uring ring;
+	struct io_uring_params p =3D { };
 	int ret;
=20
-	ret =3D io_uring_queue_init_params(8, &ring, p);
+	p.flags =3D flags;
+	ret =3D io_uring_queue_init_params(8, &ring, &p);
 	if (ret) {
 		fprintf(stderr, "ring setup failed: %d\n", ret);
 		return 1;
@@ -150,29 +153,11 @@ static int test_p(struct io_uring_params *p)
 		goto err;
 	}
=20
-	io_uring_queue_exit(&ring);
-	return 0;
 err:
 	io_uring_queue_exit(&ring);
 	return ret;
 }
=20
-static int test_normal_ring(void)
-{
-	struct io_uring_params p =3D { };
-
-	return test_p(&p);
-}
-
-static int test_big_ring(void)
-{
-	struct io_uring_params p =3D { };
-
-	p.flags =3D IORING_SETUP_SQE128;
-	return test_p(&p);
-}
-
-
 int main(int argc, char *argv[])
 {
 	int ret;
@@ -180,17 +165,15 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return 0;
=20
-	ret =3D test_normal_ring();
-	if (ret) {
-		fprintf(stderr, "Normal ring test failed\n");
-		return ret;
-	}
-
-	ret =3D test_big_ring();
-	if (ret) {
-		fprintf(stderr, "Big ring test failed\n");
-		return ret;
+	FOR_ALL_TEST_CONFIGS {
+		fprintf(stderr, "Testing %s config\n", IORING_GET_TEST_CONFIG_DESCRIPT=
ION());
+		ret =3D test_ring(IORING_GET_TEST_CONFIG_FLAGS());
+		if (ret) {
+			fprintf(stderr, "Normal ring test failed\n");
+			return ret;
+		}
 	}
=20
+	fprintf(stderr, "PASS\n");
 	return 0;
 }
diff --git a/test/test.h b/test/test.h
new file mode 100644
index 0000000..3628163
--- /dev/null
+++ b/test/test.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: Test configs for tests.
+ */
+#ifndef LIBURING_TEST_H
+#define LIBURING_TEST_H
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+typedef struct io_uring_test_config {
+	unsigned int flags;
+	const char *description;
+} io_uring_test_config;
+
+io_uring_test_config io_uring_test_configs[] =3D {
+	{ 0, 						"default" },
+	{ IORING_SETUP_SQE128, 				"large SQE"},
+	{ IORING_SETUP_CQE32, 				"large CQE"},
+	{ IORING_SETUP_SQE128 | IORING_SETUP_CQE32, 	"large SQE/CQE" },
+};
+
+#define FOR_ALL_TEST_CONFIGS							\
+	for (int i =3D 0; i < sizeof(io_uring_test_configs) / sizeof(io_uring_t=
est_configs[0]); i++)
+
+#define IORING_GET_TEST_CONFIG_FLAGS() (io_uring_test_configs[i].flags)
+#define IORING_GET_TEST_CONFIG_DESCRIPTION() (io_uring_test_configs[i].d=
escription)
+
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
--=20
2.30.2

