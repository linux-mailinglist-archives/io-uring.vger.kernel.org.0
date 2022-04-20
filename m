Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDCE509030
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 21:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379219AbiDTTS1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 15:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358692AbiDTTS0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 15:18:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C2C1D0C1
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:39 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23KILRcX018343
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kAFnRzlvdrj5aTT2statZcE7VhulC77d3lNV8s9tI8g=;
 b=cTlOD/FfNk4noVGcqU6VjhD3XPmi5RCAbxJj21FZlYf6wht2XqbgejoQWp8n1xkMDwAO
 QGcFpGhqbbBSO/AvLB8oB9KEKdw8s1ksmK3JMKUqOQiogJFatghaAVFG4aFPrht92PSH
 A3RlRwaWCqer25babY7yKz6oc6vWhbdUaJQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhkk2csx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:39 -0700
Received: from twshared4937.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Apr 2022 12:15:37 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 7111FDE0C4BD; Wed, 20 Apr 2022 12:15:27 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 6/6] liburing: Test all configurations with NOP test
Date:   Wed, 20 Apr 2022 12:15:24 -0700
Message-ID: <20220420191524.2906409-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420191524.2906409-1-shr@fb.com>
References: <20220420191524.2906409-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: FRNfoKHmSMjknNefiQZ7kY-byf36Uf1Y
X-Proofpoint-ORIG-GUID: FRNfoKHmSMjknNefiQZ7kY-byf36Uf1Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_05,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
index 0d9bb90..7bd0e6c 100644
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

