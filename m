Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F096C50902E
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 21:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378958AbiDTTS1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 15:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381649AbiDTTSX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 15:18:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C429344C4
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:35 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23KILOBQ018240
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=n830fI7lXNK5/5Dmb1TecFkrm6YMrnHwPT7hczn5ZvY=;
 b=YyH9P/3fkdTztF8L3wKVr9Hwrgk74cj3TW93dlxSqXOp6SgFE7Zh0wDbRpJf+aaLwWBs
 3ZUTGu1be8AIq1q2gEHW41uCTvPcNFtlL2pOfN4YGKi9Vy8FehU6rZxEfjBz9O3aXutU
 IM06AnANsiAlSsUCYDzsBMV9puOQQhJEHxk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fhkk2cswp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 12:15:35 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Apr 2022 12:15:34 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 6B4C7DE0C4BB; Wed, 20 Apr 2022 12:15:27 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 5/6] liburing: add large CQE tests to nop test
Date:   Wed, 20 Apr 2022 12:15:23 -0700
Message-ID: <20220420191524.2906409-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420191524.2906409-1-shr@fb.com>
References: <20220420191524.2906409-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: sUxf7SeZFbUd_4kS3JmuhXUbON5DGIhT
X-Proofpoint-ORIG-GUID: sUxf7SeZFbUd_4kS3JmuhXUbON5DGIhT
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

This adds two test cases for large CQE's:
- Single NOP test, which checks that the new extra1 and extra2 fields
  are set.
- Multiple NOP submission test which also checks for the new fields.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 test/nop.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/test/nop.c b/test/nop.c
index d477a1b..0d9bb90 100644
--- a/test/nop.c
+++ b/test/nop.c
@@ -19,6 +19,7 @@ static int test_single_nop(struct io_uring *ring)
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	int ret;
+	bool cqe32 =3D (ring->flags & IORING_SETUP_CQE32);
=20
 	sqe =3D io_uring_get_sqe(ring);
 	if (!sqe) {
@@ -27,6 +28,10 @@ static int test_single_nop(struct io_uring *ring)
 	}
=20
 	io_uring_prep_nop(sqe);
+	if (cqe32) {
+		sqe->addr =3D 1234;
+		sqe->addr2 =3D 5678;
+	}
 	sqe->user_data =3D ++seq;
=20
 	ret =3D io_uring_submit(ring);
@@ -44,6 +49,17 @@ static int test_single_nop(struct io_uring *ring)
 		fprintf(stderr, "Unexpected 0 user_data\n");
 		goto err;
 	}
+	if (cqe32) {
+		if (cqe->b[0].extra1 !=3D 1234) {
+			fprintf(stderr, "Unexpected extra1\n");
+			goto err;
+
+		}
+		if (cqe->b[0].extra2 !=3D 5678) {
+			fprintf(stderr, "Unexpected extra2\n");
+			goto err;
+		}
+	}
 	io_uring_cqe_seen(ring, cqe);
 	return 0;
 err:
@@ -55,6 +71,7 @@ static int test_barrier_nop(struct io_uring *ring)
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	int ret, i;
+	bool cqe32 =3D (ring->flags & IORING_SETUP_CQE32);
=20
 	for (i =3D 0; i < 8; i++) {
 		sqe =3D io_uring_get_sqe(ring);
@@ -66,6 +83,10 @@ static int test_barrier_nop(struct io_uring *ring)
 		io_uring_prep_nop(sqe);
 		if (i =3D=3D 4)
 			sqe->flags =3D IOSQE_IO_DRAIN;
+		if (cqe32) {
+			sqe->addr =3D 1234;
+			sqe->addr2 =3D 5678;
+		}
 		sqe->user_data =3D ++seq;
 	}
=20
@@ -88,6 +109,16 @@ static int test_barrier_nop(struct io_uring *ring)
 			fprintf(stderr, "Unexpected 0 user_data\n");
 			goto err;
 		}
+		if (cqe32) {
+			if (cqe->b[0].extra1 !=3D 1234) {
+				fprintf(stderr, "Unexpected extra1\n");
+				goto err;
+			}
+			if (cqe->b[0].extra2 !=3D 5678) {
+				fprintf(stderr, "Unexpected extra2\n");
+				goto err;
+			}
+		}
 		io_uring_cqe_seen(ring, cqe);
 	}
=20
--=20
2.30.2

