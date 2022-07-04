Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66871565A9C
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 18:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbiGDQGb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 12:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbiGDQGa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 12:06:30 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F325E0C2
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 09:06:30 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264103sZ014207
        for <io-uring@vger.kernel.org>; Mon, 4 Jul 2022 09:06:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=72zIe39/fY38BSJsrphn/Djs3h9ccxOriupdOVMdtv4=;
 b=FIp5FxtaTcCCH46VrfOVWyt4/lmohSR4Fphxdhk06J3DJQ6yphnRg5z7893EXHS1fohv
 nzyf/L8f4UQUIQPdi1GgQdQdIZUf3qDUa2pTsUA9HKG+20qxaYnCqWCeGrRYu0jm6LZU
 eLFUTktOmqLMHfKCGi37pEab/NUMQKxDt2Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h2j2njk89-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 04 Jul 2022 09:06:29 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 4 Jul 2022 09:06:29 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C5B78289B1EF; Mon,  4 Jul 2022 09:06:21 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing] fix test_buf_select_pipe on older kernels
Date:   Mon, 4 Jul 2022 09:06:14 -0700
Message-ID: <20220704160614.1033371-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: vrlHW2JVsZf2lgW17m2lX7gMMfCDGsvD
X-Proofpoint-ORIG-GUID: vrlHW2JVsZf2lgW17m2lX7gMMfCDGsvD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_16,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

timing issues might cause out of order completes on older kernels,
especially regarding selecting a buffer before queueing up IO (as it can
complete with ENOBUFS being queued).
Theres no reason to test ENOBUFS for this problem, so remove those checks=
.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/read-write.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/test/read-write.c b/test/read-write.c
index eadeb78..c5cc469 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -428,28 +428,25 @@ static int test_buf_select_short(const char *filena=
me, int nonvec)
 	return ret;
 }
=20
-static int provide_buffers_iovec(struct io_uring *ring, int bgid, int co=
unt)
+static int provide_buffers_iovec(struct io_uring *ring, int bgid)
 {
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	int i, ret;
=20
-	if (count <=3D 0)
-		count =3D BUFFERS;
-
-	for (i =3D 0; i < count; i++) {
+	for (i =3D 0; i < BUFFERS; i++) {
 		sqe =3D io_uring_get_sqe(ring);
 		io_uring_prep_provide_buffers(sqe, vecs[i].iov_base,
 						vecs[i].iov_len, 1, bgid, i);
 	}
=20
 	ret =3D io_uring_submit(ring);
-	if (ret !=3D count) {
+	if (ret !=3D BUFFERS) {
 		fprintf(stderr, "submit: %d\n", ret);
 		return -1;
 	}
=20
-	for (i =3D 0; i < count; i++) {
+	for (i =3D 0; i < BUFFERS; i++) {
 		ret =3D io_uring_wait_cqe(ring, &cqe);
 		if (ret) {
 			fprintf(stderr, "wait_cqe=3D%d\n", ret);
@@ -482,7 +479,7 @@ static int test_buf_select_pipe(void)
 		return 1;
 	}
=20
-	ret =3D provide_buffers_iovec(&ring, 0, 4);
+	ret =3D provide_buffers_iovec(&ring, 0);
 	if (ret) {
 		fprintf(stderr, "provide buffers failed: %d\n", ret);
 		return 1;
@@ -515,13 +512,6 @@ static int test_buf_select_pipe(void)
 			fprintf(stderr, "bad wait %d\n", i);
 			return 1;
 		}
-		if (i =3D=3D 4) {
-			if (cqe->res !=3D -ENOBUFS) {
-				fprintf(stderr, "expected failure %d\n", cqe->res);
-				return 1;
-			}
-			continue;
-		}
 		if (cqe->res !=3D 1) {
 			fprintf(stderr, "expected read %d\n", cqe->res);
 			return 1;
@@ -580,7 +570,7 @@ static int test_buf_select(const char *filename, int =
nonvec)
 	for (i =3D 0; i < BUFFERS; i++)
 		memset(vecs[i].iov_base, 0x55, vecs[i].iov_len);
=20
-	ret =3D provide_buffers_iovec(&ring, 1, -1);
+	ret =3D provide_buffers_iovec(&ring, 1);
 	if (ret)
 		return ret;
=20
@@ -606,7 +596,7 @@ static int test_rem_buf(int batch, int sqe_flags)
 		return 1;
 	}
=20
-	ret =3D provide_buffers_iovec(&ring, bgid, -1);
+	ret =3D provide_buffers_iovec(&ring, bgid);
 	if (ret)
 		return ret;
=20

base-commit: f8eb5f804288e10ae7ef442ef482e4dd8b18fee7
--=20
2.30.2

