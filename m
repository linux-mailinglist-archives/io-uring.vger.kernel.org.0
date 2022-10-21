Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B996071CF
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 10:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiJUIMa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 04:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiJUIM2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 04:12:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59C824AAE4
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 01:12:26 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29L193fI000780
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 01:12:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=nHIQPPlmlv4wqbz+l8cqctxe7JXXzihpFMTawj1y8CY=;
 b=BHNgBIKluNjnfvr/DjL4JitXRDIWJVFmI+vL5XrqSlizMdKcIVd2HUwcvy7po78sUXb1
 rgGn/K2hUkPGKW0/Pkg/okktMIMo5iAoKFcW5tmCehU9ZqqwZEpfIUMndgsfbNgqpcuh
 iAvy1RW/dLRrb9gEwxeNTkypl0us+sDlvsqKXPWptAKDouvPHgRUj4ofcdI4JAgzVJyu
 E94p596pcztrZIm007XfSHeMGKWk39pVsP49a8oogfmrfIecqKBn2o28phwzhX5lfQXm
 K6gnTibhYI4pyPXddg3pZgTzoyhq0UU24+FNyIRshsgQzo0bCmNUUd0eGZT/jeu9DUGY DA== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kbhgjagft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 01:12:26 -0700
Received: from twshared5252.09.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 01:12:24 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 7439080B4B91; Fri, 21 Oct 2022 01:12:10 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing] fix recv-multishot test skipping in 6.1
Date:   Fri, 21 Oct 2022 01:12:07 -0700
Message-ID: <20221021081207.2607808-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4srq4urqvEENbeAPJHSUpEqkOIh9gNrx
X-Proofpoint-GUID: 4srq4urqvEENbeAPJHSUpEqkOIh9gNrx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_03,2022-10-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This test was skipping in IORING_SETUP_DEFER_TASKRUN as it was not
flushing the work queue before checking for completions.

Additionally fix the test to only skip if it is the first loop.

Fixes: f91105d54955 ("update existing tests for defer taskrun")
Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 test/recv-multishot.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/test/recv-multishot.c b/test/recv-multishot.c
index 1a041f8e865a..e7c1a99dc0a6 100644
--- a/test/recv-multishot.c
+++ b/test/recv-multishot.c
@@ -13,7 +13,7 @@
 #include "liburing.h"
 #include "helpers.h"
=20
-static int no_recv_mshot;
+#define ENORECVMULTISHOT 9999
=20
 enum early_error_t {
 	ERROR_NONE  =3D 0,
@@ -139,6 +139,7 @@ static int test(struct args *args)
 		sqe =3D io_uring_get_sqe(&ring);
 		io_uring_prep_provide_buffers(sqe, recv_buffs[i],
 					buffer_size, 1, 7, i);
+		io_uring_sqe_set_data64(sqe, 0x999);
 		memset(recv_buffs[i], 0xcc, buffer_size);
 		if (io_uring_submit_and_wait_timeout(&ring, &cqe, 1, &timeout, NULL) !=
=3D 0) {
 			fprintf(stderr, "provide buffers failed: %d\n", ret);
@@ -186,13 +187,19 @@ static int test(struct args *args)
 			if (args->early_error =3D=3D ERROR_EARLY_CLOSE_RECEIVER) {
 				/* allow previous sends to complete */
 				usleep(1000);
+				io_uring_get_events(&ring);
=20
 				sqe =3D io_uring_get_sqe(&ring);
 				io_uring_prep_recv(sqe, fds[0], NULL, 0, 0);
 				io_uring_prep_cancel64(sqe, 1234, 0);
+				io_uring_sqe_set_data64(sqe, 0x888);
 				sqe->flags |=3D IOSQE_CQE_SKIP_SUCCESS;
 				io_uring_submit(&ring);
 				early_error_started =3D true;
+
+				/* allow the cancel to complete */
+				usleep(1000);
+				io_uring_get_events(&ring);
 			}
 			if (args->early_error =3D=3D ERROR_EARLY_CLOSE_SENDER) {
 				early_error_started =3D true;
@@ -246,12 +253,10 @@ static int test(struct args *args)
 	at =3D &send_buff[0];
 	if (recv_cqes < min_cqes) {
 		if (recv_cqes > 0 && recv_cqe[0].res =3D=3D -EINVAL) {
-			no_recv_mshot =3D 1;
-			return 0;
+			return -ENORECVMULTISHOT;
 		}
 		/* some kernels apparently don't check ->ioprio, skip */
-		ret =3D 0;
-		no_recv_mshot =3D 1;
+		ret =3D -ENORECVMULTISHOT;
 		goto cleanup;
 	}
 	for (i =3D 0; i < recv_cqes; i++) {
@@ -481,14 +486,18 @@ int main(int argc, char *argv[])
 			a.early_error =3D (enum early_error_t)early_error;
 			ret =3D test(&a);
 			if (ret) {
+				if (ret =3D=3D -ENORECVMULTISHOT) {
+					if (loop =3D=3D 0)
+						return T_EXIT_SKIP;
+					fprintf(stderr,
+						"ENORECVMULTISHOT received but loop>0\n");
+				}
 				fprintf(stderr,
 					"test stream=3D%d wait_each=3D%d recvmsg=3D%d early_error=3D%d "
 					" defer=3D%d failed\n",
 					a.stream, a.wait_each, a.recvmsg, a.early_error, a.defer);
 				return T_EXIT_FAIL;
 			}
-			if (no_recv_mshot)
-				return T_EXIT_SKIP;
 		}
 	}
=20

base-commit: 1ddd58dab67ea21b94463326ddfda0388ca21ca2
--=20
2.30.2

