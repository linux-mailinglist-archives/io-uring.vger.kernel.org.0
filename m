Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C090F59E662
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbiHWPvF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 11:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbiHWPuR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 11:50:17 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5B22BCEF8;
        Tue, 23 Aug 2022 04:53:56 -0700 (PDT)
Received: from localhost.localdomain (unknown [125.160.110.187])
        by gnuweeb.org (Postfix) with ESMTPSA id 3CA3080A7E;
        Tue, 23 Aug 2022 11:52:55 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661255578;
        bh=VJyE9REutvIuMm6YGiqQCpPDB9RyDQge1g/t3cN0oIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuywwZTO85ZGje1gZv0e4TsCgt8EMSAwvX7VnjIoZWjf4Q7l+ohpu0iP5AsUo6VOQ
         ZyHCSsvnYdK6y03t2/075m7RNBzDOyOAX9tGGPTUnpQzyI9t9Z6ma6HKaFaD08YZhA
         NfAbZXi/bA6sDBkR6HFoCmfX3K9x50P55wWmp9/fwpsppgwiJcJg6dhWRuKQ0kmR3W
         HCroAdPMWTrwiNqzlUxPzBDMHCGGF1w5/NjNkfVTweXLcqU3U6ZlNilroHYNIdKAgl
         avQ3PZr7DHKo/WQo2kvfuO5bLigHVlmIpGPfImNTYE/3JcMHAivt1PA7pWtF1FwHJk
         EH28bphceszOA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Kanna Scarlet <knscarlet@gnuweeb.org>
Subject: [PATCH 2/2] io_uring: uapi: Sync with the kernel
Date:   Tue, 23 Aug 2022 18:52:44 +0700
Message-Id: <20220823114813.2865890-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220823114813.2865890-1-ammar.faizi@intel.com>
References: <20220823114813.2865890-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

This is a full copy from the kernel tree without any modifition. Now
this header is fully in sync with the kernel. Next time when changing
this header from the kernel side, just copy the file directly to
liburing, no need manual modification.

Link: https://lore.kernel.org/io-uring/f1feef16-6ea2-0653-238f-4aaee35060b6@kernel.dk
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/include/liburing/io_uring.h | 66 ++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 18 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index c923f5c..9e0b5c8 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -10,6 +10,7 @@
 
 #include <linux/fs.h>
 #include <linux/types.h>
+#include <linux/time_types.h>
 
 #ifdef __cplusplus
 extern "C" {
@@ -54,6 +55,7 @@ struct io_uring_sqe {
 		__u32		unlink_flags;
 		__u32		hardlink_flags;
 		__u32		xattr_flags;
+		__u32		msg_ring_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -148,7 +150,6 @@ enum {
  * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
  */
 #define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
-
 #define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
 #define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
 /*
@@ -244,10 +245,13 @@ enum io_uring_op {
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
 
 /*
  * ASYNC_CANCEL flags.
@@ -256,10 +260,12 @@ enum io_uring_op {
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
 
 /*
  * send/sendmsg and recv/recvmsg flags (sqe->ioprio)
@@ -272,6 +278,12 @@ enum io_uring_op {
  * IORING_RECV_MULTISHOT	Multishot recv. Sets IORING_CQE_F_MORE if
  *				the handler will continue to report
  *				CQEs on behalf of the same SQE.
+ *
+ * IORING_RECVSEND_FIXED_BUF	Use registered buffers, the index is stored in
+ *				the buf_index field.
+ *
+ * IORING_RECVSEND_NOTIF_FLUSH	Flush a notification after a successful
+ *				successful. Only for zerocopy sends.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
@@ -283,6 +295,7 @@ enum io_uring_op {
  */
 #define IORING_ACCEPT_MULTISHOT	(1U << 0)
 
+
 /*
  * IORING_OP_RSRC_UPDATE flags
  */
@@ -291,6 +304,22 @@ enum {
 	IORING_RSRC_UPDATE_NOTIF,
 };
 
+/*
+ * IORING_OP_MSG_RING command types, stored in sqe->addr
+ */
+enum {
+	IORING_MSG_DATA,	/* pass sqe->len as 'res' and off as user_data */
+	IORING_MSG_SEND_FD,	/* send a registered fd to another ring */
+};
+
+/*
+ * IORING_OP_MSG_RING flags (sqe->msg_ring_flags)
+ *
+ * IORING_MSG_RING_CQE_SKIP	Don't post a CQE to the target ring. Not
+ *				applicable for IORING_MSG_DATA, obviously.
+ */
+#define IORING_MSG_RING_CQE_SKIP	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
@@ -456,6 +485,7 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	/* zerocopy notification API */
 	IORING_REGISTER_NOTIFIERS		= 26,
 	IORING_UNREGISTER_NOTIFIERS		= 27,
 
@@ -535,7 +565,7 @@ struct io_uring_probe {
 	__u8 ops_len;	/* length of ops[] array below */
 	__u16 resv;
 	__u32 resv2[3];
-	struct io_uring_probe_op ops[0];
+	struct io_uring_probe_op ops[];
 };
 
 struct io_uring_restriction {
@@ -581,15 +611,6 @@ struct io_uring_buf_reg {
 	__u64	resv[3];
 };
 
-/* argument for IORING_REGISTER_SYNC_CANCEL */
-struct io_uring_sync_cancel_reg {
-	__u64				addr;
-	__s32				fd;
-	__u32				flags;
-	struct __kernel_timespec	timeout;
-	__u64				pad[4];
-};
-
 /*
  * io_uring_restriction->opcode values
  */
@@ -616,8 +637,22 @@ struct io_uring_getevents_arg {
 	__u64	ts;
 };
 
+/*
+ * Argument for IORING_REGISTER_SYNC_CANCEL
+ */
+struct io_uring_sync_cancel_reg {
+	__u64				addr;
+	__s32				fd;
+	__u32				flags;
+	struct __kernel_timespec	timeout;
+	__u64				pad[4];
+};
+
+/*
+ * Argument for IORING_REGISTER_FILE_ALLOC_RANGE
+ * The range is specified as [off, off + len)
+ */
 struct io_uring_file_index_range {
-	/* [off, off + len) */
 	__u32	off;
 	__u32	len;
 	__u64	resv;
@@ -630,11 +665,6 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
 };
 
-/*
- * accept flags stored in sqe->ioprio
- */
-#define IORING_ACCEPT_MULTISHOT	(1U << 0)
-
 #ifdef __cplusplus
 }
 #endif
-- 
Ammar Faizi

