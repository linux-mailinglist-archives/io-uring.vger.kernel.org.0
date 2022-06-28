Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCE355E919
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347711AbiF1PE3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 11:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347731AbiF1PE2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 11:04:28 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2F92E0BE
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:04:28 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SAH5qc029521
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:04:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8Mee8IHxkdAsrr2iwmEsmfJoqoSYM222IcJA+jf8psQ=;
 b=U+ah0x+GR8t6U4Yteg1NBrxMgiqxyrWwNxE++nJp9EdFcXNnWt7lrRjfqgBHRfP9UcEQ
 Y9auB4UiJn7/mT197g7ea+tqdReyhIuTaPhuFnl3klaBWdPtjLJkZJ1c7gdnwmlMkjJt
 z011JNaQh5WbIUBexY6O4EBDz+5fMKzU3wI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gyg0af9sr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:04:27 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 28 Jun 2022 08:04:26 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id B8EC2244BD57; Tue, 28 Jun 2022 08:04:18 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 2/4] add IORING_RECV_MULTISHOT to io_uring.h
Date:   Tue, 28 Jun 2022 08:04:12 -0700
Message-ID: <20220628150414.1386435-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628150414.1386435-1-dylany@fb.com>
References: <20220628150414.1386435-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: y_cwi_tKQQLhzGI6a8V8HdUWRLjT93v8
X-Proofpoint-ORIG-GUID: y_cwi_tKQQLhzGI6a8V8HdUWRLjT93v8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_08,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

copy from include/uapi/linux/io_uring.h

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 src/include/liburing/io_uring.h | 53 ++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 14 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index 2f391c9..1e5bdb3 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -10,10 +10,7 @@
=20
 #include <linux/fs.h>
 #include <linux/types.h>
-
-#ifdef __cplusplus
-extern "C" {
-#endif
+#include <linux/time_types.h>
=20
 /*
  * IO submission data structure (Submission Queue Entry)
@@ -26,6 +23,7 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
+		__u32	cmd_op;
 	};
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
@@ -65,8 +63,17 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 	};
-	__u64	addr3;
-	__u64	__pad2[1];
+	union {
+		struct {
+			__u64	addr3;
+			__u64	__pad2[1];
+		};
+		/*
+		 * If the ring is initialized with IORING_SETUP_SQE128, then
+		 * this field is used for 80 bytes of arbitrary command data
+		 */
+		__u8	cmd[0];
+	};
 };
=20
 /*
@@ -131,9 +138,12 @@ enum {
  * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
  */
 #define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
-
 #define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
 #define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
+/*
+ * Only one task is allowed to submit requests
+ */
+#define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
=20
 enum io_uring_op {
 	IORING_OP_NOP,
@@ -220,10 +230,13 @@ enum io_uring_op {
  *
  * IORING_POLL_UPDATE		Update existing poll request, matching
  *				sqe->addr as the old user_data field.
+ *
+ * IORING_POLL_LEVEL		Level triggered poll.
  */
 #define IORING_POLL_ADD_MULTI	(1U << 0)
 #define IORING_POLL_UPDATE_EVENTS	(1U << 1)
 #define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
+#define IORING_POLL_ADD_LEVEL		(1U << 3)
=20
 /*
  * ASYNC_CANCEL flags.
@@ -232,10 +245,12 @@ enum io_uring_op {
  * IORING_ASYNC_CANCEL_FD	Key off 'fd' for cancelation rather than the
  *				request 'user_data'
  * IORING_ASYNC_CANCEL_ANY	Match any request
+ * IORING_ASYNC_CANCEL_FD_FIXED	'fd' passed in is a fixed descriptor
  */
 #define IORING_ASYNC_CANCEL_ALL	(1U << 0)
 #define IORING_ASYNC_CANCEL_FD	(1U << 1)
-#define IORING_ASYNC_CANCEL_ANY (1U << 2)
+#define IORING_ASYNC_CANCEL_ANY	(1U << 2)
+#define IORING_ASYNC_CANCEL_FD_FIXED	(1U << 3)
=20
 /*
  * send/sendmsg and recv/recvmsg flags (sqe->addr2)
@@ -244,8 +259,13 @@ enum io_uring_op {
  *				or receive and arm poll if that yields an
  *				-EAGAIN result, arm poll upfront and skip
  *				the initial transfer attempt.
+ *
+ * IORING_RECV_MULTISHOT	Multishot recv. Sets IORING_CQE_F_MORE if
+ *				the handler will continue to report
+ *				CQEs on behalf of the same SQE.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
+#define IORING_RECV_MULTISHOT	(1U << 1)
=20
 /*
  * accept flags stored in sqe->ioprio
@@ -411,6 +431,9 @@ enum {
 	IORING_REGISTER_PBUF_RING		=3D 22,
 	IORING_UNREGISTER_PBUF_RING		=3D 23,
=20
+	/* sync cancelation API */
+	IORING_REGISTER_SYNC_CANCEL		=3D 24,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -547,12 +570,14 @@ struct io_uring_getevents_arg {
 };
=20
 /*
- * accept flags stored in sqe->ioprio
+ * Argument for IORING_REGISTER_SYNC_CANCEL
  */
-#define IORING_ACCEPT_MULTISHOT	(1U << 0)
-
-#ifdef __cplusplus
-}
-#endif
+struct io_uring_sync_cancel_reg {
+	__u64				addr;
+	__s32				fd;
+	__u32				flags;
+	struct __kernel_timespec	timeout;
+	__u64				pad[4];
+};
=20
 #endif
--=20
2.30.2

