Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09EC54C79A
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 13:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344921AbiFOLh4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 07:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244420AbiFOLhx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 07:37:53 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA785DF52
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:37:52 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EMcxu9026826
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:37:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=AVjWiS5bok6GdHwvrHtDtEcPuI9GJl0o6PPco/WhOfM=;
 b=cMq2Y8/RV17S1LbaX3uzvTcUV8gbNsTS4Y7ZJpGYqYis7bfSa179pTxjAtDrEPAgaCZf
 7k1UUyQIczdP5iUOP21PAio3tWi9ox7FfpggqgrwZyGtjhONFoJawdaBM7bG/68VEDWK
 zi5laWHFjcL2minSxCS+MSHYwK6/SjeRMbw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gpgc2sht6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:37:52 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 15 Jun 2022 04:37:50 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 0B7C71B0FD23; Wed, 15 Jun 2022 04:37:41 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing] convert buf-ring nop test to use read
Date:   Wed, 15 Jun 2022 04:37:33 -0700
Message-ID: <20220615113733.1424472-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: cLUtBfIJdDiiCnqxtl3gmv3dRvZSN0Cy
X-Proofpoint-ORIG-GUID: cLUtBfIJdDiiCnqxtl3gmv3dRvZSN0Cy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_03,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The NOP support for IOSQE_BUFFER_SELECT has been reverted, so use a
supported function with read. This also allows verifying that the
correct data has actually been read.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/buf-ring.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/test/buf-ring.c b/test/buf-ring.c
index af1cac8..3d12ef6 100644
--- a/test/buf-ring.c
+++ b/test/buf-ring.c
@@ -206,7 +206,7 @@ static int test_reg_unreg(int bgid)
 	return 0;
 }
=20
-static int test_one_nop(int bgid, struct io_uring *ring)
+static int test_one_read(int fd, int bgid, struct io_uring *ring)
 {
 	int ret;
 	struct io_uring_cqe *cqe;
@@ -218,21 +218,19 @@ static int test_one_nop(int bgid, struct io_uring *=
ring)
 		return -1;
 	}
=20
-	io_uring_prep_nop(sqe);
+	io_uring_prep_read(sqe, fd, NULL, 1, 0);
 	sqe->flags |=3D IOSQE_BUFFER_SELECT;
 	sqe->buf_group =3D bgid;
 	ret =3D io_uring_submit(ring);
 	if (ret <=3D 0) {
 		fprintf(stderr, "sqe submit failed: %d\n", ret);
-		ret =3D -1;
-		goto out;
+		return -1;
 	}
=20
 	ret =3D io_uring_wait_cqe(ring, &cqe);
 	if (ret < 0) {
 		fprintf(stderr, "wait completion %d\n", ret);
-		ret =3D -1;
-		goto out;
+		return -1;
 	}
 	ret =3D cqe->res;
 	io_uring_cqe_seen(ring, cqe);
@@ -240,14 +238,12 @@ static int test_one_nop(int bgid, struct io_uring *=
ring)
 	if (ret =3D=3D -ENOBUFS)
 		return ret;
=20
-	if (ret !=3D 0) {
-		fprintf(stderr, "nop result %d\n", ret);
+	if (ret !=3D 1) {
+		fprintf(stderr, "read result %d\n", ret);
 		return -1;
 	}
=20
-	ret =3D cqe->flags >> 16;
-out:
-	return ret;
+	return cqe->flags >> 16;
 }
=20
 static int test_running(int bgid, int entries, int loops)
@@ -255,6 +251,7 @@ static int test_running(int bgid, int entries, int lo=
ops)
 	struct io_uring_buf_reg reg =3D { };
 	struct io_uring ring;
 	void *ptr;
+	char buffer[8];
 	int ret;
 	int ring_size =3D (entries * sizeof(struct io_uring_buf) + 4095) & (~40=
95);
 	int ring_mask =3D io_uring_buf_ring_mask(entries);
@@ -262,6 +259,7 @@ static int test_running(int bgid, int entries, int lo=
ops)
 	int loop, idx;
 	bool *buffers;
 	struct io_uring_buf_ring *br;
+	int read_fd;
=20
 	ret =3D t_create_ring(1, &ring, 0);
 	if (ret =3D=3D T_SETUP_SKIP)
@@ -279,6 +277,10 @@ static int test_running(int bgid, int entries, int l=
oops)
 	if (!buffers)
 		return 1;
=20
+	read_fd =3D open("/dev/zero", O_RDONLY);
+	if (read_fd < 0)
+		return 1;
+
 	reg.ring_addr =3D (unsigned long) ptr;
 	reg.ring_entries =3D entries;
 	reg.bgid =3D bgid;
@@ -293,11 +295,12 @@ static int test_running(int bgid, int entries, int =
loops)
 	for (loop =3D 0; loop < loops; loop++) {
 		memset(buffers, 0, sizeof(bool) * entries);
 		for (idx =3D 0; idx < entries; idx++)
-			io_uring_buf_ring_add(br, ptr, 1, idx, ring_mask, idx);
+			io_uring_buf_ring_add(br, buffer, sizeof(buffer), idx, ring_mask, idx=
);
 		io_uring_buf_ring_advance(br, entries);
=20
 		for (idx =3D 0; idx < entries; idx++) {
-			ret =3D test_one_nop(bgid, &ring);
+			memset(buffer, 1, sizeof(buffer));
+			ret =3D test_one_read(read_fd, bgid, &ring);
 			if (ret < 0) {
 				fprintf(stderr, "bad run %d/%d =3D %d\n", loop, idx, ret);
 				return ret;
@@ -306,9 +309,19 @@ static int test_running(int bgid, int entries, int l=
oops)
 				fprintf(stderr, "reused buffer %d/%d =3D %d!\n", loop, idx, ret);
 				return 1;
 			}
+			if (buffer[0] !=3D 0) {
+				fprintf(stderr, "unexpected read %d %d/%d =3D %d!\n",
+						(int)buffer[0], loop, idx, ret);
+				return 1;
+			}
+			if (buffer[1] !=3D 1) {
+				fprintf(stderr, "unexpected spilled read %d %d/%d =3D %d!\n",
+						(int)buffer[1], loop, idx, ret);
+				return 1;
+			}
 			buffers[ret] =3D true;
 		}
-		ret =3D test_one_nop(bgid, &ring);
+		ret =3D test_one_read(read_fd, bgid, &ring);
 		if (ret !=3D -ENOBUFS) {
 			fprintf(stderr, "expected enobufs run %d =3D %d\n", loop, ret);
 			return 1;
@@ -322,6 +335,7 @@ static int test_running(int bgid, int entries, int lo=
ops)
 		return 1;
 	}
=20
+	close(read_fd);
 	io_uring_queue_exit(&ring);
 	free(buffers);
 	return 0;

base-commit: d6f9e02f9c6a777010824341f14c994b11dfc8b1
--=20
2.30.2

