Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F175A56582F
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 16:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbiGDOCR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 10:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbiGDOCQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 10:02:16 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53588DE95
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 07:02:15 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2643QaHu024051
        for <io-uring@vger.kernel.org>; Mon, 4 Jul 2022 07:02:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=jA7GnciVdaduYkRaFN7KPcPCLVqH0+itQqg7iLssVlA=;
 b=jQ52JbKXTE3QxMoqAIX0xj+pMF4Ka50XKQJeLNiE5qtg2ZPeSAFfGMYgX6WlAlvU1yM6
 rT8eeHt7kiRZGjoT7XBeRRLDfpcgDG1CXzl2fq4l0n4pgM8Fn07odOcxWMF6npMLqITF
 9vI8GsxFxvLoAljBnpiktK6i2tEAzSfeg18= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h2kuvsbh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 04 Jul 2022 07:02:14 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 4 Jul 2022 07:02:13 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 258D4288A725; Mon,  4 Jul 2022 07:02:09 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing] remove recvmsg_multishot
Date:   Mon, 4 Jul 2022 07:02:04 -0700
Message-ID: <20220704140204.204505-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 4iraA9AV8-5CkBqi6KbUw8n8L6RrMuuX
X-Proofpoint-ORIG-GUID: 4iraA9AV8-5CkBqi6KbUw8n8L6RrMuuX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_13,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This was not well thought out enough, and has some API concerns. Such as
how do names and control messages come back in a multishot way.

For now delete the recvmsg API until the kernel API is solid.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_prep_recvmsg.3           | 20 --------------------
 man/io_uring_prep_recvmsg_multishot.3 |  1 -
 src/include/liburing.h                |  8 --------
 test/recv-multishot.c                 | 19 +++++--------------
 4 files changed, 5 insertions(+), 43 deletions(-)
 delete mode 120000 man/io_uring_prep_recvmsg_multishot.3

diff --git a/man/io_uring_prep_recvmsg.3 b/man/io_uring_prep_recvmsg.3
index 24c68ce..8c49411 100644
--- a/man/io_uring_prep_recvmsg.3
+++ b/man/io_uring_prep_recvmsg.3
@@ -15,11 +15,6 @@ io_uring_prep_recvmsg \- prepare a recvmsg request
 .BI "                           int " fd ","
 .BI "                           struct msghdr *" msg ","
 .BI "                           unsigned " flags ");"
-.PP
-.BI "void io_uring_prep_recvmsg_multishot(struct io_uring_sqe *" sqe ","
-.BI "                                     int " fd ","
-.BI "                                     struct msghdr *" msg ","
-.BI "                                     unsigned " flags ");"
 .fi
 .SH DESCRIPTION
 .PP
@@ -42,21 +37,6 @@ This function prepares an async
 request. See that man page for details on the arguments specified to thi=
s
 prep helper.
=20
-The multishot version allows the application to issue a single receive r=
equest,
-which repeatedly posts a CQE when data is available. It requires length =
to be 0
-, the
-.B IOSQE_BUFFER_SELECT
-flag to be set and no
-.B MSG_WAITALL
-flag to be set.
-Therefore each CQE will take a buffer out of a provided buffer pool for =
receiving.
-The application should check the flags of each CQE, regardless of it's r=
esult.
-If a posted CQE does not have the
-.B IORING_CQE_F_MORE
-flag set then the multishot receive will be done and the application sho=
uld issue a
-new request.
-Multishot variants are available since kernel 5.20.
-
 After calling this function, additional io_uring internal modifier flags
 may be set in the SQE
 .I off
diff --git a/man/io_uring_prep_recvmsg_multishot.3 b/man/io_uring_prep_re=
cvmsg_multishot.3
deleted file mode 120000
index cd9566f..0000000
--- a/man/io_uring_prep_recvmsg_multishot.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_recvmsg.3
\ No newline at end of file
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 4df3139..d35bfa9 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -419,14 +419,6 @@ static inline void io_uring_prep_recvmsg(struct io_u=
ring_sqe *sqe, int fd,
 	sqe->msg_flags =3D flags;
 }
=20
-static inline void io_uring_prep_recvmsg_multishot(struct io_uring_sqe *=
sqe,
-						   int fd, struct msghdr *msg,
-						   unsigned flags)
-{
-	io_uring_prep_recvmsg(sqe, fd, msg, flags);
-	sqe->ioprio |=3D IORING_RECV_MULTISHOT;
-}
-
 static inline void io_uring_prep_sendmsg(struct io_uring_sqe *sqe, int f=
d,
 					 const struct msghdr *msg,
 					 unsigned flags)
diff --git a/test/recv-multishot.c b/test/recv-multishot.c
index f6d41c8..9df8184 100644
--- a/test/recv-multishot.c
+++ b/test/recv-multishot.c
@@ -25,7 +25,6 @@ enum early_error_t {
 };
=20
 struct args {
-	bool recvmsg;
 	bool stream;
 	bool wait_each;
 	enum early_error_t early_error;
@@ -48,7 +47,6 @@ static int test(struct args *args)
 	int recv_cqes =3D 0;
 	bool early_error =3D false;
 	bool early_error_started =3D false;
-	struct msghdr msg =3D { };
 	struct __kernel_timespec timeout =3D {
 		.tv_sec =3D 1,
 	};
@@ -101,13 +99,7 @@ static int test(struct args *args)
 	}
=20
 	sqe =3D io_uring_get_sqe(&ring);
-	if (args->recvmsg) {
-		memset(&msg, 0, sizeof(msg));
-		msg.msg_namelen =3D sizeof(struct sockaddr_in);
-		io_uring_prep_recvmsg_multishot(sqe, fds[0], &msg, 0);
-	} else {
-		io_uring_prep_recv_multishot(sqe, fds[0], NULL, 0, 0);
-	}
+	io_uring_prep_recv_multishot(sqe, fds[0], NULL, 0, 0);
 	sqe->flags |=3D IOSQE_BUFFER_SELECT;
 	sqe->buf_group =3D 7;
 	io_uring_sqe_set_data64(sqe, 1234);
@@ -328,19 +320,18 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return T_EXIT_SKIP;
=20
-	for (loop =3D 0; loop < 7; loop++) {
+	for (loop =3D 0; loop < 4; loop++) {
 		struct args a =3D {
 			.stream =3D loop & 0x01,
-			.recvmsg =3D loop & 0x02,
-			.wait_each =3D loop & 0x4,
+			.wait_each =3D loop & 0x2,
 		};
 		for (early_error =3D 0; early_error < ERROR_EARLY_LAST; early_error++)=
 {
 			a.early_error =3D (enum early_error_t)early_error;
 			ret =3D test(&a);
 			if (ret) {
 				fprintf(stderr,
-					"test stream=3D%d recvmsg=3D%d wait_each=3D%d early_error=3D%d fail=
ed\n",
-					a.stream, a.recvmsg, a.wait_each, a.early_error);
+					"test stream=3D%d wait_each=3D%d early_error=3D%d failed\n",
+					a.stream, a.wait_each, a.early_error);
 				return T_EXIT_FAIL;
 			}
 			if (no_recv_mshot)

base-commit: f8eb5f804288e10ae7ef442ef482e4dd8b18fee7
--=20
2.30.2

