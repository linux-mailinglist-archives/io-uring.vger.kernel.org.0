Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014606C7417
	for <lists+io-uring@lfdr.de>; Fri, 24 Mar 2023 00:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjCWXgn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Mar 2023 19:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjCWXgm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Mar 2023 19:36:42 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2188241E3
        for <io-uring@vger.kernel.org>; Thu, 23 Mar 2023 16:36:40 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 32NLYovO025812
        for <io-uring@vger.kernel.org>; Thu, 23 Mar 2023 16:36:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=IGSnwiadsWgKjstdz5gb2nJjFPMcPHhXe0OsFJ8HCfo=;
 b=kDLgqKLC8bbBrWPhxzG29pTbke4kMDN8zAdT0dc0f+JqqGuIdxk5JwBy5SkQ7VFvfzGD
 nwWHwAXPPp3xWl1rCMcPgczwXRJnzsNx3NthPvj4G0OzkQb46+SJ4+6z8wYm1qN1Bz3P
 UUWXIOmgNxjnQHDRpLvdVFW2BFbtvQfwUhmDFi4gp/Z2U1wY1LKPFvyOVDGJJrLY6LDy
 SCFZhQaXCz5DOJ746WGt72+Obtz/FARqd9XFjAtk4KR/7B6VwqEEjGIjot6E3PjlKp8A
 Iq/fGCrOATvBLOnklwoD4rYkxrrbmJmLYoufu6VvCk/f+r69zdOaReVCo1lZXHGg0KSj lw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3pgxkrgms4-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 23 Mar 2023 16:36:39 -0700
Received: from twshared34471.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 23 Mar 2023 16:36:38 -0700
Received: by devbig023.atn6.facebook.com (Postfix, from userid 197530)
        id 5857D72192A6; Thu, 23 Mar 2023 16:36:36 -0700 (PDT)
From:   David Wei <davidhwei@meta.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     <io-uring@vger.kernel.org>, David Wei <davidhwei@meta.com>
Subject: [PATCH] liburing: add multishot timeout support
Date:   Thu, 23 Mar 2023 16:36:32 -0700
Message-ID: <20230323233632.2376374-1-davidhwei@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: YA5wGMj226afmTGYLkMplTQfTO9dz2hc
X-Proofpoint-GUID: YA5wGMj226afmTGYLkMplTQfTO9dz2hc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-23_13,2023-03-23_02,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
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
 test/timeout.c                  | 173 ++++++++++++++++++++++++++++++++
 2 files changed, 174 insertions(+)

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
index 8c43832..670ecfb 100644
--- a/test/timeout.c
+++ b/test/timeout.c
@@ -1327,6 +1327,159 @@ done:
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
 int main(int argc, char *argv[])
 {
 	struct io_uring ring, sqpoll_ring;
@@ -1419,6 +1572,26 @@ int main(int argc, char *argv[])
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
 	ret =3D test_single_timeout_wait(&ring, &p);
 	if (ret) {
 		fprintf(stderr, "test_single_timeout_wait failed\n");
--=20
2.34.1

