Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0C96E01D4
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 00:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDLW34 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Apr 2023 18:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLW3z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Apr 2023 18:29:55 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4426A40
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 15:29:54 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33CI95JQ009480
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 15:29:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=INOJHE3kpowUPtsSaHJ4xfxeFxlm6HVdib4Z7D4n1JQ=;
 b=BkS6Wg6L566c2NVsbV8PdsPDwj2oPxFJ0ftxq0UUCiDFATCuuy23z4/PQWVpOgliiVU+
 2gk3K+b76novFeUTNHvllSsHljfKkGlL+4NCOmVgIaiu8Ri8Ec4rzTjOHtds4Tlh08iV
 GJGpuj4KZel5gAVd6/BEt08cN1tTRaLe89OMmGbafJioCfedNb5V9IkEhnUBfisSj4xQ
 wLXSXe29ZoZRS7q7BSoDtnIW5sg1ktqo215Pb+HXezPlc9MJdWLyn9yABp4PJ2KyyZR/
 48NzXaiuIwrRnP4h2xEKJKP7ZSX7RMwhACFbt1m0tpemQi/hbsJXDvRtsnE4MtrQwk1k Bg== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3pwqws5a0p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 15:29:53 -0700
Received: from twshared35445.38.frc1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 12 Apr 2023 15:29:38 -0700
Received: by devbig023.atn6.facebook.com (Postfix, from userid 197530)
        id 358638C274BE; Wed, 12 Apr 2023 15:29:33 -0700 (PDT)
From:   David Wei <davidhwei@meta.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     <io-uring@vger.kernel.org>, David Wei <davidhwei@meta.com>
Subject: [PATCH v2] liburing: add multishot timeout support
Date:   Wed, 12 Apr 2023 15:29:31 -0700
Message-ID: <20230412222931.1635706-1-davidhwei@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: UQvL5RsdhJp2tJHmoGji2rGOVs439zHs
X-Proofpoint-ORIG-GUID: UQvL5RsdhJp2tJHmoGji2rGOVs439zHs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-12_12,2023-04-12_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Single change to sync the new IORING_TIMEOUT_MULTISHOT flag with kernel.

Mostly unit tests for multishot timeouts.

Signed-off-by: David Wei <davidhwei@meta.com>
---
 src/include/liburing/io_uring.h |   1 +
 test/timeout.c                  | 266 ++++++++++++++++++++++++++++++++
 2 files changed, 267 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index ec068d4..3d3a63b 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -250,6 +250,7 @@ enum io_uring_op {
 #define IORING_TIMEOUT_REALTIME		(1U << 3)
 #define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
+#define IORING_TIMEOUT_MULTISHOT	(1U << 6)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIME=
OUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_=
TIMEOUT_UPDATE)
 /*
diff --git a/test/timeout.c b/test/timeout.c
index 8c43832..cd1ece8 100644
--- a/test/timeout.c
+++ b/test/timeout.c
@@ -1327,6 +1327,238 @@ done:
 }
=20
=20
+static int test_timeout_multishot(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct __kernel_timespec ts;
+	int ret;
+
+	sqe =3D io_uring_get_sqe(ring);
+        if (!sqe) {
+                fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+                goto err;
+        }
+
+	msec_to_ts(&ts, TIMEOUT_MSEC);
+	io_uring_prep_timeout(sqe, &ts, 0, IORING_TIMEOUT_MULTISHOT);
+	io_uring_sqe_set_data(sqe, (void *) 1);
+
+	ret =3D io_uring_submit(ring);
+	if (ret <=3D 0) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	for (int i =3D 0; i < 2; i++) {
+		ret =3D io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+			goto err;
+		}
+
+		if (!(cqe->flags & IORING_CQE_F_MORE)) {
+			fprintf(stderr, "%s: flag not set in cqe\n", __FUNCTION__);
+			goto err;
+		}
+
+		ret =3D cqe->res;
+		if (ret !=3D -ETIME) {
+			fprintf(stderr, "%s: Timeout: %s\n", __FUNCTION__, strerror(-ret));
+			goto err;
+		}
+
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	sqe =3D io_uring_get_sqe(ring);
+        if (!sqe) {
+                fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+                goto err;
+        }
+
+	io_uring_prep_timeout_remove(sqe, 1, 0);
+	io_uring_sqe_set_data(sqe, (void *) 2);
+
+	ret =3D io_uring_submit(ring);
+	if (ret <=3D 0) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret =3D cqe->res;
+	if (ret < 0) {
+		fprintf(stderr, "%s: remove failed: %s\n", __FUNCTION__, strerror(-ret=
));
+		goto err;
+	}
+
+	io_uring_cqe_seen(ring, cqe);
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret =3D cqe->res;
+	if (ret !=3D -ECANCELED) {
+		fprintf(stderr, "%s: timeout canceled: %s %llu\n", __FUNCTION__, strer=
ror(-ret), cqe->user_data);
+		goto err;
+	}
+
+	io_uring_cqe_seen(ring, cqe);
+	return 0;
+err:
+	return 1;
+}
+
+
+static int test_timeout_multishot_nr(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct __kernel_timespec ts;
+	int ret;
+
+	sqe =3D io_uring_get_sqe(ring);
+        if (!sqe) {
+                fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+                goto err;
+        }
+
+	msec_to_ts(&ts, TIMEOUT_MSEC);
+	io_uring_prep_timeout(sqe, &ts, 3, IORING_TIMEOUT_MULTISHOT);
+	io_uring_sqe_set_data(sqe, (void *) 1);
+
+	ret =3D io_uring_submit(ring);
+	if (ret <=3D 0) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	for (int i =3D 0; i < 3; i++) {
+		ret =3D io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+			goto err;
+		}
+
+		if (i < 2 && !(cqe->flags & IORING_CQE_F_MORE)) {
+			fprintf(stderr, "%s: flag not set in cqe\n", __FUNCTION__);
+			goto err;
+		}
+		if (i =3D=3D 3 && (cqe->flags & IORING_CQE_F_MORE)) {
+			fprintf(stderr, "%s: flag set in cqe\n", __FUNCTION__);
+			goto err;
+		}
+
+		ret =3D cqe->res;
+		if (ret !=3D -ETIME) {
+			fprintf(stderr, "%s: Timeout: %s\n", __FUNCTION__, strerror(-ret));
+			goto err;
+		}
+
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	msec_to_ts(&ts, 2 * TIMEOUT_MSEC);
+	ret =3D io_uring_wait_cqe_timeout(ring, &cqe, &ts);
+	if (ret !=3D -ETIME) {
+		fprintf(stderr, "%s: wait completion timeout %s\n", __FUNCTION__, stre=
rror(-ret));
+		goto err;
+	}
+
+	return 0;
+err:
+	return 1;
+}
+
+
+static int test_timeout_multishot_overflow(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct __kernel_timespec ts;
+	int ret;
+
+	sqe =3D io_uring_get_sqe(ring);
+        if (!sqe) {
+                fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+                goto err;
+        }
+
+	msec_to_ts(&ts, 10);
+	io_uring_prep_timeout(sqe, &ts, 0, IORING_TIMEOUT_MULTISHOT);
+	io_uring_sqe_set_data(sqe, (void *) 1);
+
+	ret =3D io_uring_submit(ring);
+	if (ret <=3D 0) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret =3D cqe->res;
+	if (ret !=3D -ETIME) {
+		fprintf(stderr, "%s: Timeout: %s\n", __FUNCTION__, strerror(-ret));
+		goto err;
+	}
+
+	io_uring_cqe_seen(ring, cqe);
+	sleep(1);
+
+	// expect overflow
+	// go thru all CQEs
+
+	if (!((*ring->sq.kflags) & IORING_SQ_CQ_OVERFLOW)) {
+		goto err;
+	}
+
+	/* multishot timer should be gone */
+	sqe =3D io_uring_get_sqe(ring);
+        if (!sqe) {
+                fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+                goto err;
+        }
+
+	io_uring_prep_timeout_remove(sqe, 1, 0);
+
+	ret =3D io_uring_submit(ring);
+	if (ret <=3D 0) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret =3D io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "%s: wait completion %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	ret =3D cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	if (ret !=3D -ETIME) {
+		fprintf(stderr, "%s: remove failed: %d %s\n", __FUNCTION__, ret, strer=
ror(-ret));
+		goto err;
+	}
+
+	return 0;
+err:
+	return 1;
+}
+
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring, sqpoll_ring;
@@ -1419,6 +1651,40 @@ int main(int argc, char *argv[])
 		return ret;
 	}
=20
+	ret =3D test_timeout_multishot(&ring);
+	if (ret) {
+		fprintf(stderr, "test_timeout_multishot failed\n");
+		return ret;
+	}
+
+	ret =3D test_timeout_multishot_nr(&ring);
+	if (ret) {
+		fprintf(stderr, "test_timeout_multishot_nr failed\n");
+		return ret;
+	}
+
+	/* io_uring_wait_cqe_timeout() may have left a timeout, reinit ring */
+	io_uring_queue_exit(&ring);
+	ret =3D io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return 1;
+	}
+
+	ret =3D test_timeout_multishot_overflow(&ring);
+	if (ret) {
+		fprintf(stderr, "test_timeout_multishot_overflow failed\n");
+		return ret;
+	}
+
+	/* io_uring_wait_cqe_timeout() may have left a timeout, reinit ring */
+	io_uring_queue_exit(&ring);
+	ret =3D io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return 1;
+	}
+
 	ret =3D test_single_timeout_wait(&ring, &p);
 	if (ret) {
 		fprintf(stderr, "test_single_timeout_wait failed\n");
--=20
2.34.1

