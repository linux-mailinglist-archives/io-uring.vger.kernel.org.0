Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB0A507B89
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 22:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355486AbiDSVBS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 17:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357867AbiDSVBR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 17:01:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628EC4132B
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:34 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23JGdlvh021223
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kAFnRzlvdrj5aTT2statZcE7VhulC77d3lNV8s9tI8g=;
 b=HXhxTBGclU1qNiyYmDGtCiHdLU7kuQHk1UAdJXBgMO3JSDYplDYzEz7K8qz2zVKo1k4e
 BYPnRjve7o+rIm91WkU80AUo+kHJM8VSBqLfQlpqFBx94jb9Di3DzcI2CgITwdiwjsLs
 fsyz0dffYDjEchBDVwwLIpuhG5XflXqC/uM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fhn4hwt45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 13:58:33 -0700
Received: from twshared10896.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 13:58:32 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 6FF45DD46121; Tue, 19 Apr 2022 13:58:26 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 6/6] liburing: Test all configurations with NOP test
Date:   Tue, 19 Apr 2022 13:58:17 -0700
Message-ID: <20220419205817.1551377-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419205817.1551377-1-shr@fb.com>
References: <20220419205817.1551377-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 2UgxKf-_cSyi3eJdusrJW3www1Sr_vkF
X-Proofpoint-ORIG-GUID: 2UgxKf-_cSyi3eJdusrJW3www1Sr_vkF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_07,2022-04-15_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

