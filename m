Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D6950E8C1
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244639AbiDYSyx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244644AbiDYSyw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:54:52 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8E1B823E
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:51:47 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 23PHPIe2009660
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:51:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=GDW4aNDbenPbGZtHxOybftaWfYRvGiQ54NfqGcCvnyI=;
 b=aDuMabCgdqQWky6h1tfANfdsDi/vX7vaoYsrDElPO/EtLOBA4vgIg5SZqT9HcJU4P6la
 D85G+7idZNOFCaq2IbQCCJ11xPr5MYx9ddEoL9/+g8Icf063Tjg88jl8JeUE9rPk2JeQ
 mwEWXY/+/C9tDlKXKmREDoRLRLhsoQMAwEE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fmcy4vjdw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:51:46 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 11:51:45 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 2BDA5E1F5C8E; Mon, 25 Apr 2022 11:51:31 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>, <joshi.k@samsung.com>
Subject: [PATCH v4 5/6] liburing: add large CQE tests to nop test
Date:   Mon, 25 Apr 2022 11:51:27 -0700
Message-ID: <20220425185128.2537966-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425185128.2537966-1-shr@fb.com>
References: <20220425185128.2537966-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: TgnQL9Rc9D4TZzCxdiv8_9LhIqiaDQoO
X-Proofpoint-GUID: TgnQL9Rc9D4TZzCxdiv8_9LhIqiaDQoO
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

This adds two test cases for large CQE's:
- Single NOP test, which checks that the new extra1 and extra2 fields
  are set.
- Multiple NOP submission test which also checks for the new fields.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 test/nop.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/test/nop.c b/test/nop.c
index d477a1b..8656373 100644
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
+		if (cqe->big_cqe[0] !=3D 1234) {
+			fprintf(stderr, "Unexpected extra1\n");
+			goto err;
+
+		}
+		if (cqe->big_cqe[1] !=3D 5678) {
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
+			if (cqe->big_cqe[0] !=3D 1234) {
+				fprintf(stderr, "Unexpected extra1\n");
+				goto err;
+			}
+			if (cqe->big_cqe[1] !=3D 5678) {
+				fprintf(stderr, "Unexpected extra2\n");
+				goto err;
+			}
+		}
 		io_uring_cqe_seen(ring, cqe);
 	}
=20
--=20
2.30.2

