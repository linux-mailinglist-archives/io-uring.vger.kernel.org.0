Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61AD561631
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbiF3JVZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbiF3JVR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:21:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C971833EA9
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:21:14 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25U0LXUK009461
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:21:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kwN9dS1xhM6SCKWqFGDi17BlRioTEFB/ozRN/PThJXM=;
 b=ais6d/3EpXv29nvJOzJ07WwXwEFeXltqaMHz+L4YOjq/xuYO4I5AAF5arijeZ5lvxoOr
 /IP/qaWne3vYfJZYyXH102AfWjET9rtz+7S5LsJPMG8sp37tZ4A6RCwmQb017BuHY85a
 d+JN2D6ok3tAKcDwgM4oVpQ8RET4AiOC5Tc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3h10tfjbvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:21:08 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub204.TheFacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:21:07 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:21:07 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id D6631259A05C; Thu, 30 Jun 2022 02:14:23 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 liburing 7/7] add accept with overflow test
Date:   Thu, 30 Jun 2022 02:14:22 -0700
Message-ID: <20220630091422.1463570-8-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091422.1463570-1-dylany@fb.com>
References: <20220630091422.1463570-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: yetBQQsOwIuPhjvBRHC2ruJN_CngLfce
X-Proofpoint-ORIG-GUID: yetBQQsOwIuPhjvBRHC2ruJN_CngLfce
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

add test to exercise the overflow codepath for multishot accept.
this doesn't actually fail previously, but does at least exerceise
the codepath and ensure that some invariants hold wrt flags and
IORING_CQE_F_MORE.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/accept.c | 129 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 101 insertions(+), 28 deletions(-)

diff --git a/test/accept.c b/test/accept.c
index 77e3ebc..0463173 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -24,6 +24,9 @@
 #include "liburing.h"
=20
 #define MAX_FDS 32
+#define NOP_USER_DATA (1LLU << 50)
+#define INITIAL_USER_DATA 1000
+
 static int no_accept;
 static int no_accept_multi;
=20
@@ -39,6 +42,7 @@ struct accept_test_args {
 	bool queue_accept_before_connect;
 	bool multishot;
 	int extra_loops;
+	bool overflow;
 };
=20
 static void close_fds(int fds[], int nr)
@@ -86,6 +90,24 @@ static void queue_recv(struct io_uring *ring, int fd, =
bool fixed)
 		sqe->flags |=3D IOSQE_FIXED_FILE;
 }
=20
+static void queue_accept_multishot(struct io_uring *ring, int fd,
+				   int idx, bool fixed)
+{
+	struct io_uring_sqe *sqe =3D io_uring_get_sqe(ring);
+	int ret;
+
+	if (fixed)
+		io_uring_prep_multishot_accept_direct(sqe, fd,
+						NULL, NULL,
+						0);
+	else
+		io_uring_prep_multishot_accept(sqe, fd, NULL, NULL, 0);
+
+	io_uring_sqe_set_data64(sqe, idx);
+	ret =3D io_uring_submit(ring);
+	assert(ret !=3D -1);
+}
+
 static void queue_accept_conn(struct io_uring *ring, int fd,
 			      struct accept_test_args args)
 {
@@ -93,40 +115,51 @@ static void queue_accept_conn(struct io_uring *ring,=
 int fd,
 	int ret;
 	int fixed_idx =3D args.fixed ? 0 : -1;
 	int count =3D 1 + args.extra_loops;
-	bool multishot =3D args.multishot;
+
+	if (args.multishot) {
+		queue_accept_multishot(ring, fd, INITIAL_USER_DATA, args.fixed);
+		return;
+	}
=20
 	while (count--) {
 		sqe =3D io_uring_get_sqe(ring);
 		if (fixed_idx < 0) {
-			if (!multishot)
-				io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
-			else
-				io_uring_prep_multishot_accept(sqe, fd, NULL,
-							       NULL, 0);
+			io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
 		} else {
-			if (!multishot)
-				io_uring_prep_accept_direct(sqe, fd, NULL, NULL,
-							    0, fixed_idx);
-			else
-				io_uring_prep_multishot_accept_direct(sqe, fd,
-								      NULL, NULL,
-								      0);
+			io_uring_prep_accept_direct(sqe, fd, NULL, NULL,
+						    0, fixed_idx);
 		}
-
 		ret =3D io_uring_submit(ring);
 		assert(ret !=3D -1);
 	}
 }
=20
-static int accept_conn(struct io_uring *ring, int fixed_idx, bool multis=
hot)
+static int accept_conn(struct io_uring *ring, int fixed_idx, int *multis=
hot, int fd)
 {
-	struct io_uring_cqe *cqe;
+	struct io_uring_cqe *pcqe;
+	struct io_uring_cqe cqe;
 	int ret;
=20
-	ret =3D io_uring_wait_cqe(ring, &cqe);
-	assert(!ret);
-	ret =3D cqe->res;
-	io_uring_cqe_seen(ring, cqe);
+	do {
+		ret =3D io_uring_wait_cqe(ring, &pcqe);
+		assert(!ret);
+		cqe =3D *pcqe;
+		io_uring_cqe_seen(ring, pcqe);
+	} while (cqe.user_data =3D=3D NOP_USER_DATA);
+
+	if (*multishot) {
+		if (!(cqe.flags & IORING_CQE_F_MORE)) {
+			(*multishot)++;
+			queue_accept_multishot(ring, fd, *multishot, fixed_idx =3D=3D 0);
+		} else {
+			if (cqe.user_data !=3D *multishot) {
+				fprintf(stderr, "received multishot after told done!\n");
+				return -ECANCELED;
+			}
+		}
+	}
+
+	ret =3D cqe.res;
=20
 	if (fixed_idx >=3D 0) {
 		if (ret > 0) {
@@ -203,6 +236,32 @@ static int set_client_fd(struct sockaddr_in *addr)
 	return fd;
 }
=20
+static void cause_overflow(struct io_uring *ring)
+{
+	int i, ret;
+
+	for (i =3D 0; i < *ring->cq.kring_entries; i++) {
+		struct io_uring_sqe *sqe =3D io_uring_get_sqe(ring);
+
+		io_uring_prep_nop(sqe);
+		io_uring_sqe_set_data64(sqe, NOP_USER_DATA);
+		ret =3D io_uring_submit(ring);
+		assert(ret !=3D -1);
+	}
+
+}
+
+static void clear_overflow(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+
+	while (!io_uring_peek_cqe(ring, &cqe)) {
+		if (cqe->user_data !=3D NOP_USER_DATA)
+			break;
+		io_uring_cqe_seen(ring, cqe);
+	}
+}
+
 static int test_loop(struct io_uring *ring,
 		     struct accept_test_args args,
 		     int recv_s0,
@@ -215,15 +274,22 @@ static int test_loop(struct io_uring *ring,
 	bool multishot =3D args.multishot;
 	uint32_t multishot_mask =3D 0;
 	int nr_fds =3D multishot ? MAX_FDS : 1;
+	int multishot_idx =3D multishot ? INITIAL_USER_DATA : 0;
=20
-	for (i =3D 0; i < nr_fds; i++)
+	if (args.overflow)
+		cause_overflow(ring);
+
+	for (i =3D 0; i < nr_fds; i++) {
 		c_fd[i] =3D set_client_fd(addr);
+		if (args.overflow && i =3D=3D nr_fds / 2)
+			clear_overflow(ring);
+	}
=20
 	if (!args.queue_accept_before_connect)
 		queue_accept_conn(ring, recv_s0, args);
=20
 	for (i =3D 0; i < nr_fds; i++) {
-		s_fd[i] =3D accept_conn(ring, fixed ? 0 : -1, multishot);
+		s_fd[i] =3D accept_conn(ring, fixed ? 0 : -1, &multishot_idx, recv_s0)=
;
 		if (s_fd[i] =3D=3D -EINVAL) {
 			if (args.accept_should_error)
 				goto out;
@@ -527,14 +593,15 @@ static int test_accept(int count, bool before)
 	return ret;
 }
=20
-static int test_multishot_accept(int count, bool before)
+static int test_multishot_accept(int count, bool before, bool overflow)
 {
 	struct io_uring m_io_uring;
 	int ret;
 	struct accept_test_args args =3D {
 		.queue_accept_before_connect =3D before,
 		.multishot =3D true,
-		.extra_loops =3D count - 1
+		.extra_loops =3D count - 1,
+		.overflow =3D overflow
 	};
=20
 	if (no_accept_multi)
@@ -779,15 +846,21 @@ int main(int argc, char *argv[])
 		return ret;
 	}
=20
-	ret =3D test_multishot_accept(1, false);
+	ret =3D test_multishot_accept(1, true, true);
+	if (ret) {
+		fprintf(stderr, "test_multishot_accept(1, false, true) failed\n");
+		return ret;
+	}
+
+	ret =3D test_multishot_accept(1, false, false);
 	if (ret) {
-		fprintf(stderr, "test_multishot_accept(1, false) failed\n");
+		fprintf(stderr, "test_multishot_accept(1, false, false) failed\n");
 		return ret;
 	}
=20
-	ret =3D test_multishot_accept(1, true);
+	ret =3D test_multishot_accept(1, true, false);
 	if (ret) {
-		fprintf(stderr, "test_multishot_accept(1, true) failed\n");
+		fprintf(stderr, "test_multishot_accept(1, true, false) failed\n");
 		return ret;
 	}
=20
--=20
2.30.2

