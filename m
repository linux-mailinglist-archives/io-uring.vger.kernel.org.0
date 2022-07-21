Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEA557CDF0
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 16:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiGUOnC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 10:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGUOnA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 10:43:00 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235B7868B8
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:43:00 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26L3wqAI007214
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:43:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=uiK6OhNPMvjRjGEU/SXekliH2h4VS+5BDnEE57w2G8w=;
 b=kNnw5T5KgYooMPjEkpRYXuRMLLjVytG4ZPR3ysZ8XQfDnDvlpic7DFMnw3gwEH0bPbE/
 edKqS9mGUyDaLT+wJc4JOA8CdXiDVKozc9QoLaGbP4/5fiaJNyZ/d3zBIR+vM2L8uhW0
 KnjFQKvWPixMCEboHpF8CHzYrpcQIvFOepk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3heyc8ttdd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:42:59 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 07:42:58 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 7AD963593BAB; Thu, 21 Jul 2022 07:42:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 3/4] test: poll-mshot-overflow use proper return codes
Date:   Thu, 21 Jul 2022 07:42:28 -0700
Message-ID: <20220721144229.1224141-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220721144229.1224141-1-dylany@fb.com>
References: <20220721144229.1224141-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: cHaTyhRGk__YyxXCwE3oQ2TP8KF5KHjY
X-Proofpoint-ORIG-GUID: cHaTyhRGk__YyxXCwE3oQ2TP8KF5KHjY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This missed out on the refactor, so do it now in preparation for adding a
skip path.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/poll-mshot-overflow.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/test/poll-mshot-overflow.c b/test/poll-mshot-overflow.c
index 078df04294fc..17039f585a77 100644
--- a/test/poll-mshot-overflow.c
+++ b/test/poll-mshot-overflow.c
@@ -10,6 +10,7 @@
 #include <sys/wait.h>
=20
 #include "liburing.h"
+#include "helpers.h"
=20
 int check_final_cqe(struct io_uring *ring)
 {
@@ -22,23 +23,23 @@ int check_final_cqe(struct io_uring *ring)
 			count++;
 			if (signalled_no_more) {
 				fprintf(stderr, "signalled no more!\n");
-				return 1;
+				return T_EXIT_FAIL;
 			}
 			if (!(cqe->flags & IORING_CQE_F_MORE))
 				signalled_no_more =3D true;
 		} else if (cqe->user_data !=3D 3) {
 			fprintf(stderr, "%d: got unexpected %d\n", count, (int)cqe->user_data=
);
-			return 1;
+			return T_EXIT_FAIL;
 		}
 		io_uring_cqe_seen(ring, cqe);
 	}
=20
 	if (!count) {
 		fprintf(stderr, "no cqe\n");
-		return 1;
+		return T_EXIT_FAIL;
 	}
=20
-	return 0;
+	return T_EXIT_PASS;
 }
=20
 int main(int argc, char *argv[])
@@ -54,7 +55,7 @@ int main(int argc, char *argv[])
=20
 	if (pipe(pipe1) !=3D 0) {
 		perror("pipe");
-		return 1;
+		return T_EXIT_FAIL;
 	}
=20
 	struct io_uring_params params =3D {
@@ -65,20 +66,20 @@ int main(int argc, char *argv[])
 	ret =3D io_uring_queue_init_params(2, &ring, &params);
 	if (ret) {
 		fprintf(stderr, "ring setup failed: %d\n", ret);
-		return 1;
+		return T_EXIT_FAIL;
 	}
=20
 	sqe =3D io_uring_get_sqe(&ring);
 	if (!sqe) {
 		fprintf(stderr, "get sqe failed\n");
-		return 1;
+		return T_EXIT_FAIL;
 	}
 	io_uring_prep_poll_multishot(sqe, pipe1[0], POLLIN);
 	io_uring_sqe_set_data64(sqe, 1);
=20
 	if (io_uring_cq_ready(&ring)) {
 		fprintf(stderr, "unexpected cqe\n");
-		return 1;
+		return T_EXIT_FAIL;
 	}
=20
 	for (i =3D 0; i < 2; i++) {
@@ -95,18 +96,18 @@ int main(int argc, char *argv[])
=20
 	if (ret <=3D 0) {
 		fprintf(stderr, "write failed: %d\n", errno);
-		return 1;
+		return T_EXIT_FAIL;
 	}
=20
 	/* should have 2 cqe + 1 overflow now, so take out two cqes */
 	for (i =3D 0; i < 2; i++) {
 		if (io_uring_peek_cqe(&ring, &cqe)) {
 			fprintf(stderr, "unexpectedly no cqe\n");
-			return 1;
+			return T_EXIT_FAIL;
 		}
 		if (cqe->user_data !=3D 2) {
 			fprintf(stderr, "unexpected user_data\n");
-			return 1;
+			return T_EXIT_FAIL;
 		}
 		io_uring_cqe_seen(&ring, cqe);
 	}
@@ -119,7 +120,7 @@ int main(int argc, char *argv[])
=20
 	if (ret !=3D 1) {
 		fprintf(stderr, "bad poll remove\n");
-		return 1;
+		return T_EXIT_FAIL;
 	}
=20
 	ret =3D check_final_cqe(&ring);
--=20
2.30.2

