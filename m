Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CEF50BC7D
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 18:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359210AbiDVQEy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 12:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354566AbiDVQEv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 12:04:51 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1E256C36
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:57 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23MF3dfC001361
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=dr6HdvLkyT5dS5Rp2QO3odA/+QpRCYukA/TYP0nZYV8=;
 b=NsS7Dyrb6I6px+dV0L3Qt3jak6lNTFOxopLKMGnM44hnIMOKy1maRx74A6cLqixvwI1C
 7YsruvCOzptwEFQfIDnkteys1dmvV7cMalYa/2rjZH5lB57AB7oGQ3aDoAzBL8TJDAZa
 gNob8N6HxN4ClDHaZqfXtj01H3RiO4WJt8g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fkd7rx3u9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:57 -0700
Received: from twshared8053.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Apr 2022 09:01:55 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 672B37E0154B; Fri, 22 Apr 2022 09:01:42 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 7/7] test: use remove_buffers instead of nop to generate error codes
Date:   Fri, 22 Apr 2022 09:01:32 -0700
Message-ID: <20220422160132.2891927-8-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220422160132.2891927-1-dylany@fb.com>
References: <20220422160132.2891927-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: uiQz2tJhd_ednOLq2pddG2cFx0ojaelr
X-Proofpoint-ORIG-GUID: uiQz2tJhd_ednOLq2pddG2cFx0ojaelr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_04,2022-04-22_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is in prep for allwoing NOP to be used in IOPOLL mode. remove_buffer=
s
will consistently return ENOENT if asked to remove buffers from a
nonexistent group, and so this is a suitable replacement. Other opcodes
return -EINVAL in IOPOLL from the prep stage, which has slightly differen=
t
behaviour.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/defer.c | 28 ++++++++++++++++++++--------
 test/link.c  |  6 +++---
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/test/defer.c b/test/defer.c
index 825b69f..68ee4b4 100644
--- a/test/defer.c
+++ b/test/defer.c
@@ -12,6 +12,10 @@
 #include "liburing.h"
=20
 #define RING_SIZE 128
+enum {
+	OP_NOP,
+	OP_REMOVE_BUFFERS
+};
=20
 struct test_context {
 	struct io_uring *ring;
@@ -27,7 +31,8 @@ static void free_context(struct test_context *ctx)
 	memset(ctx, 0, sizeof(*ctx));
 }
=20
-static int init_context(struct test_context *ctx, struct io_uring *ring,=
 int nr)
+static int init_context(struct test_context *ctx, struct io_uring *ring,=
 int nr,
+			int op)
 {
 	struct io_uring_sqe *sqe;
 	int i;
@@ -45,7 +50,14 @@ static int init_context(struct test_context *ctx, stru=
ct io_uring *ring, int nr)
 		sqe =3D io_uring_get_sqe(ring);
 		if (!sqe)
 			goto err;
-		io_uring_prep_nop(sqe);
+		switch (op) {
+		case OP_NOP:
+			io_uring_prep_nop(sqe);
+			break;
+		case OP_REMOVE_BUFFERS:
+			io_uring_prep_remove_buffers(sqe, 10, 1);
+			break;
+		};
 		sqe->user_data =3D i;
 		ctx->sqes[i] =3D sqe;
 	}
@@ -81,7 +93,7 @@ static int test_cancelled_userdata(struct io_uring *rin=
g)
 	struct test_context ctx;
 	int ret, i, nr =3D 100;
=20
-	if (init_context(&ctx, ring, nr))
+	if (init_context(&ctx, ring, nr, OP_NOP))
 		return 1;
=20
 	for (i =3D 0; i < nr; i++)
@@ -115,7 +127,7 @@ static int test_thread_link_cancel(struct io_uring *r=
ing)
 	struct test_context ctx;
 	int ret, i, nr =3D 100;
=20
-	if (init_context(&ctx, ring, nr))
+	if (init_context(&ctx, ring, nr, OP_REMOVE_BUFFERS))
 		return 1;
=20
 	for (i =3D 0; i < nr; i++)
@@ -134,12 +146,12 @@ static int test_thread_link_cancel(struct io_uring =
*ring)
 		bool fail =3D false;
=20
 		if (i =3D=3D 0)
-			fail =3D (ctx.cqes[i].res !=3D -EINVAL);
+			fail =3D (ctx.cqes[i].res !=3D -ENOENT);
 		else
 			fail =3D (ctx.cqes[i].res !=3D -ECANCELED);
=20
 		if (fail) {
-			printf("invalid status\n");
+			printf("invalid status %d\n", ctx.cqes[i].res);
 			goto err;
 		}
 	}
@@ -158,7 +170,7 @@ static int test_drain_with_linked_timeout(struct io_u=
ring *ring)
 	struct test_context ctx;
 	int ret, i;
=20
-	if (init_context(&ctx, ring, nr * 2))
+	if (init_context(&ctx, ring, nr * 2, OP_NOP))
 		return 1;
=20
 	for (i =3D 0; i < nr; i++) {
@@ -188,7 +200,7 @@ static int run_drained(struct io_uring *ring, int nr)
 	struct test_context ctx;
 	int ret, i;
=20
-	if (init_context(&ctx, ring, nr))
+	if (init_context(&ctx, ring, nr, OP_NOP))
 		return 1;
=20
 	for (i =3D 0; i < nr; i++)
diff --git a/test/link.c b/test/link.c
index c89d6b2..41d3899 100644
--- a/test/link.c
+++ b/test/link.c
@@ -178,7 +178,7 @@ static int test_single_link_fail(struct io_uring *rin=
g)
 		goto err;
 	}
=20
-	io_uring_prep_nop(sqe);
+	io_uring_prep_remove_buffers(sqe, 10, 1);
 	sqe->flags |=3D IOSQE_IO_LINK;
=20
 	sqe =3D io_uring_get_sqe(ring);
@@ -205,8 +205,8 @@ static int test_single_link_fail(struct io_uring *rin=
g)
 			printf("failed to get cqe\n");
 			goto err;
 		}
-		if (i =3D=3D 0 && cqe->res !=3D -EINVAL) {
-			printf("sqe0 failed with %d, wanted -EINVAL\n", cqe->res);
+		if (i =3D=3D 0 && cqe->res !=3D -ENOENT) {
+			printf("sqe0 failed with %d, wanted -ENOENT\n", cqe->res);
 			goto err;
 		}
 		if (i =3D=3D 1 && cqe->res !=3D -ECANCELED) {
--=20
2.30.2

