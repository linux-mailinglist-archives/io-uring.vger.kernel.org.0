Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072D55AAD47
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 13:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiIBLO6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 07:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbiIBLO4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 07:14:56 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BF712098
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 04:14:52 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id u17so1885720wrp.3
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 04:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ixN4fNCHp134Y/RfUCeJ08tVCq+qQTBygkI4LG6AIu0=;
        b=oq2DOldnf/0XASA3ucvPMRFgvbseRhCo7nO8g57byHRg6ynfNaTehpohkWvuGqnVOh
         gbScAlcCqbIwNSw0NvomfEtE13bLOM0Sj2atew2XofNhQYezzIaWRkX43/LoFkI6awvT
         tjWEXlm4Wd8kaGE92UVKevfe25GbUHdHYyBIxmX9paGWWXs+6m32LKdOD1IDm0neAuRb
         eVMWYO0G/tPjxWTxWoQd5yKlyKwcHQ4EJ0tx4My4v9ELLLgloGFgemz8G3svKu3nkKDm
         9uKaJCl3twViLTdHkF9d80jxCG4u40yfKkdVJbsHJBYBW/8f00UMEiHGAoHTjdbaaDoO
         Ta2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ixN4fNCHp134Y/RfUCeJ08tVCq+qQTBygkI4LG6AIu0=;
        b=zZgApZ2QwfYgQkQCYSn9TFuXSD2LrKzH1+xUskrK0oDV8KRuSdOuONGxG3E31vknjh
         YaBxNOdN5vuax+wMo/SbsiD9TqhOSR7XYawkfr+DgnZNCjOkznYxn4MOPUYKO6sLMUSG
         V3O5VasWyE+/m2JANH4BtjOXyjTTSo4tDirMw6mYBh/2Pk1T+DCpsoQgPW6p7kFcGe1V
         YboFRVAMd4QAyZhR4DnTACdd7iEFwy/6OFNyXvnIntoiQb97eumFvj6QvgVhRUC3n0QV
         lLpKkcJKz+ST7qtyjQviv++n5v+v6PnHGvqVD0VmYobGBfKuOMTgBUuBLOmuXQKqOujp
         XoGQ==
X-Gm-Message-State: ACgBeo3HyC6oZqpF1k5KWq7pC8+n65ma5APowPglEuVZs2/P08alMwND
        x9QrKdWxQtBXQVhf1rwgpmng729q/7Y=
X-Google-Smtp-Source: AA6agR7j1bz1cq6VvAV2ucOLdri4aPWGYBg6QQRBiRXovUcxlR1dTwP+NeMOIuVA+aIsR0HmP7FgXw==
X-Received: by 2002:a05:6000:191:b0:226:eb62:775d with SMTP id p17-20020a056000019100b00226eb62775dmr7074080wrx.687.1662117290017;
        Fri, 02 Sep 2022 04:14:50 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-225.dab.02.net. [82.132.230.225])
        by smtp.gmail.com with ESMTPSA id bg32-20020a05600c3ca000b003a536d5aa2esm2087379wmb.11.2022.09.02.04.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 04:14:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/4] zc: adjust sendzc to the simpler uapi
Date:   Fri,  2 Sep 2022 12:12:37 +0100
Message-Id: <f56ab1638b9704d5745082e4a8a4b610a784d62f.1662116617.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662116617.git.asml.silence@gmail.com>
References: <cover.1662116617.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We update the zerocopy API, reflect it in liburing, this includes
removing the whole notification story, updating headers and fixing
up tests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h          |  39 +-
 src/include/liburing/io_uring.h |  28 +-
 src/register.c                  |  20 --
 test/send-zerocopy.c            | 611 ++++----------------------------
 4 files changed, 91 insertions(+), 607 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 68a1646..c672440 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -199,10 +199,6 @@ int io_uring_register_sync_cancel(struct io_uring *ring,
 int io_uring_register_file_alloc_range(struct io_uring *ring,
 					unsigned off, unsigned len);
 
-int io_uring_register_notifications(struct io_uring *ring, unsigned nr,
-				    struct io_uring_notification_slot *slots);
-int io_uring_unregister_notifications(struct io_uring *ring);
-
 /*
  * io_uring syscalls.
  */
@@ -702,44 +698,23 @@ static inline void io_uring_prep_send(struct io_uring_sqe *sqe, int sockfd,
 	sqe->msg_flags = (__u32) flags;
 }
 
-static inline void io_uring_prep_sendzc(struct io_uring_sqe *sqe, int sockfd,
-				        const void *buf, size_t len, int flags,
-				        unsigned slot_idx, unsigned zc_flags)
+static inline void io_uring_prep_send_zc(struct io_uring_sqe *sqe, int sockfd,
+					 const void *buf, size_t len, int flags,
+					 unsigned zc_flags)
 {
-	io_uring_prep_rw(IORING_OP_SENDZC_NOTIF, sqe, sockfd, buf, (__u32) len, 0);
+	io_uring_prep_rw(IORING_OP_SEND_ZC, sqe, sockfd, buf, (__u32) len, 0);
 	sqe->msg_flags = (__u32) flags;
-	sqe->notification_idx = slot_idx;
 	sqe->ioprio = zc_flags;
 }
 
-static inline void io_uring_prep_sendzc_fixed(struct io_uring_sqe *sqe, int sockfd,
-					      const void *buf, size_t len,
-					      int flags, unsigned slot_idx,
-					      unsigned zc_flags, unsigned buf_idx)
-{
-	io_uring_prep_sendzc(sqe, sockfd, buf, len, flags, slot_idx, zc_flags);
-	sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
-	sqe->buf_index = buf_idx;
-}
-
-static inline void io_uring_prep_sendzc_set_addr(struct io_uring_sqe *sqe,
-						 const struct sockaddr *dest_addr,
-						 __u16 addr_len)
+static inline void io_uring_prep_send_set_addr(struct io_uring_sqe *sqe,
+						const struct sockaddr *dest_addr,
+						__u16 addr_len)
 {
 	sqe->addr2 = (unsigned long)(void *)dest_addr;
 	sqe->addr_len = addr_len;
 }
 
-static inline void io_uring_prep_notif_update(struct io_uring_sqe *sqe,
-					      __u64 new_tag, /* 0 to ignore */
-					      unsigned offset, unsigned nr)
-{
-	io_uring_prep_rw(IORING_OP_FILES_UPDATE, sqe, -1, 0, nr,
-			 (__u64)offset);
-	sqe->addr = new_tag;
-	sqe->ioprio = IORING_RSRC_UPDATE_NOTIF;
-}
-
 static inline void io_uring_prep_recv(struct io_uring_sqe *sqe, int sockfd,
 				      void *buf, size_t len, int flags)
 {
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 9e0b5c8..6b83177 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -71,8 +71,8 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 		struct {
-			__u16	notification_idx;
 			__u16	addr_len;
+			__u16	__pad3[1];
 		};
 	};
 	union {
@@ -178,8 +178,7 @@ enum io_uring_op {
 	IORING_OP_FALLOCATE,
 	IORING_OP_OPENAT,
 	IORING_OP_CLOSE,
-	IORING_OP_RSRC_UPDATE,
-	IORING_OP_FILES_UPDATE = IORING_OP_RSRC_UPDATE,
+	IORING_OP_FILES_UPDATE,
 	IORING_OP_STATX,
 	IORING_OP_READ,
 	IORING_OP_WRITE,
@@ -206,7 +205,7 @@ enum io_uring_op {
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
-	IORING_OP_SENDZC_NOTIF,
+	IORING_OP_SEND_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -228,7 +227,6 @@ enum io_uring_op {
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
-
 /*
  * sqe->splice_flags
  * extends splice(2) flags
@@ -281,29 +279,16 @@ enum io_uring_op {
  *
  * IORING_RECVSEND_FIXED_BUF	Use registered buffers, the index is stored in
  *				the buf_index field.
- *
- * IORING_RECVSEND_NOTIF_FLUSH	Flush a notification after a successful
- *				successful. Only for zerocopy sends.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
-#define IORING_RECVSEND_NOTIF_FLUSH	(1U << 3)
 
 /*
  * accept flags stored in sqe->ioprio
  */
 #define IORING_ACCEPT_MULTISHOT	(1U << 0)
 
-
-/*
- * IORING_OP_RSRC_UPDATE flags
- */
-enum {
-	IORING_RSRC_UPDATE_FILES,
-	IORING_RSRC_UPDATE_NOTIF,
-};
-
 /*
  * IORING_OP_MSG_RING command types, stored in sqe->addr
  */
@@ -341,10 +326,13 @@ struct io_uring_cqe {
  * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
  * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
  * IORING_CQE_F_SOCK_NONEMPTY	If set, more data to read after socket recv
+ * IORING_CQE_F_NOTIF	Set for notification CQEs. Can be used to distinct
+ * 			them from sends.
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
 #define IORING_CQE_F_MORE		(1U << 1)
 #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
+#define IORING_CQE_F_NOTIF		(1U << 3)
 
 enum {
 	IORING_CQE_BUFFER_SHIFT		= 16,
@@ -485,10 +473,6 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
-	/* zerocopy notification API */
-	IORING_REGISTER_NOTIFIERS		= 26,
-	IORING_UNREGISTER_NOTIFIERS		= 27,
-
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
diff --git a/src/register.c b/src/register.c
index 7482112..2b37e5f 100644
--- a/src/register.c
+++ b/src/register.c
@@ -364,23 +364,3 @@ int io_uring_register_file_alloc_range(struct io_uring *ring,
 				       IORING_REGISTER_FILE_ALLOC_RANGE, &range,
 				       0);
 }
-
-int io_uring_register_notifications(struct io_uring *ring, unsigned nr,
-				    struct io_uring_notification_slot *slots)
-{
-	struct io_uring_notification_register r = {
-		.nr_slots = nr,
-		.data = (unsigned long)slots,
-	};
-
-	return __sys_io_uring_register(ring->ring_fd,
-				       IORING_REGISTER_NOTIFIERS,
-				       &r, sizeof(r));
-}
-
-int io_uring_unregister_notifications(struct io_uring *ring)
-{
-	return __sys_io_uring_register(ring->ring_fd,
-				       IORING_UNREGISTER_NOTIFIERS,
-				       NULL, 0);
-}
diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 97727e3..7b58ae7 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -44,7 +44,6 @@
 #define HOST	"127.0.0.1"
 #define HOSTV6	"::1"
 
-#define NR_SLOTS 5
 #define ZC_TAG 10000
 #define BUFFER_OFFSET 41
 
@@ -52,15 +51,9 @@
 	#define ARRAY_SIZE(a) (sizeof(a)/sizeof((a)[0]))
 #endif
 
-static int seqs[NR_SLOTS];
 static char *tx_buffer, *rx_buffer;
 static struct iovec buffers_iov[3];
 
-static inline bool tag_userdata(__u64 user_data)
-{
-	return ZC_TAG <= user_data && user_data < ZC_TAG + NR_SLOTS;
-}
-
 static bool check_cq_empty(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe = NULL;
@@ -70,41 +63,18 @@ static bool check_cq_empty(struct io_uring *ring)
 	return ret == -EAGAIN;
 }
 
-static int register_notifications(struct io_uring *ring)
-{
-	struct io_uring_notification_slot slots[NR_SLOTS] = {};
-	int i;
-
-	memset(seqs, 0, sizeof(seqs));
-	for (i = 0; i < NR_SLOTS; i++)
-		slots[i].tag = ZC_TAG + i;
-	return io_uring_register_notifications(ring, NR_SLOTS, slots);
-}
-
-static int reregister_notifications(struct io_uring *ring)
-{
-	int ret;
-
-	ret = io_uring_unregister_notifications(ring);
-	if (ret) {
-		fprintf(stderr, "unreg notifiers failed %i\n", ret);
-		return ret;
-	}
-
-	return register_notifications(ring);
-}
-
-static int do_one(struct io_uring *ring, int sock_tx, int slot_idx)
+static int test_basic_send(struct io_uring *ring, int sock_tx, int sock_rx)
 {
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	int msg_flags = 0;
 	unsigned zc_flags = 0;
+	int payload_size = 100;
 	int ret;
 
 	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, 1, msg_flags,
-			     slot_idx, zc_flags);
+	io_uring_prep_send_zc(sqe, sock_tx, tx_buffer, payload_size,
+			      msg_flags, zc_flags);
 	sqe->user_data = 1;
 
 	ret = io_uring_submit(ring);
@@ -112,434 +82,61 @@ static int do_one(struct io_uring *ring, int sock_tx, int slot_idx)
 	ret = io_uring_wait_cqe(ring, &cqe);
 	assert(!ret);
 	assert(cqe->user_data == 1);
-	ret = cqe->res;
+	if (ret == -EINVAL) {
+		assert(!(cqe->flags & IORING_CQE_F_MORE));
+		return T_EXIT_SKIP;
+	}
+	assert(cqe->res == payload_size);
+	assert(cqe->flags & IORING_CQE_F_MORE);
 	io_uring_cqe_seen(ring, cqe);
-	assert(check_cq_empty(ring));
-	return ret;
-}
-
-static int test_invalid_slot(struct io_uring *ring, int sock_tx, int sock_rx)
-{
-	int ret;
-
-	ret = do_one(ring, sock_tx, NR_SLOTS);
-	assert(ret == -EINVAL);
-	return 0;
-}
-
-static int test_basic_send(struct io_uring *ring, int sock_tx, int sock_rx)
-{
-	struct io_uring_sqe *sqe;
-	struct io_uring_cqe *cqe;
-	int msg_flags = 0;
-	int slot_idx = 0;
-	unsigned zc_flags = 0;
-	int payload_size = 100;
-	int ret;
-
-	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, payload_size, msg_flags,
-			     slot_idx, zc_flags);
-	sqe->user_data = 1;
 
-	ret = io_uring_submit(ring);
-	assert(ret == 1);
 	ret = io_uring_wait_cqe(ring, &cqe);
 	assert(!ret);
-	assert(cqe->user_data == 1 && cqe->res >= 0);
+	assert(cqe->user_data == 1);
+	assert(cqe->flags & IORING_CQE_F_NOTIF);
+	assert(!(cqe->flags & IORING_CQE_F_MORE));
 	io_uring_cqe_seen(ring, cqe);
 	assert(check_cq_empty(ring));
 
 	ret = recv(sock_rx, rx_buffer, payload_size, MSG_TRUNC);
 	assert(ret == payload_size);
-	return 0;
+	return T_EXIT_PASS;
 }
 
-static int test_send_flush(struct io_uring *ring, int sock_tx, int sock_rx)
+static int test_send_faults(struct io_uring *ring, int sock_tx, int sock_rx)
 {
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	int msg_flags = 0;
-	int slot_idx = 0;
 	unsigned zc_flags = 0;
 	int payload_size = 100;
-	int ret, i, j;
-	int req_cqes, notif_cqes;
-
-	/* now do send+flush, do many times to verify seqs */
-	for (j = 0; j < NR_SLOTS * 5; j++) {
-		zc_flags = IORING_RECVSEND_NOTIF_FLUSH;
-		slot_idx = rand() % NR_SLOTS;
-		sqe = io_uring_get_sqe(ring);
-		io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, payload_size,
-				     msg_flags, slot_idx, zc_flags);
-		sqe->user_data = 1;
-
-		ret = io_uring_submit(ring);
-		assert(ret == 1);
-
-		req_cqes = notif_cqes = 1;
-		for (i = 0; i < 2; i ++) {
-			ret = io_uring_wait_cqe(ring, &cqe);
-			assert(!ret);
-
-			if (cqe->user_data == 1) {
-				assert(req_cqes > 0);
-				req_cqes--;
-				assert(cqe->res == payload_size);
-			} else if (cqe->user_data == ZC_TAG + slot_idx) {
-				assert(notif_cqes > 0);
-				notif_cqes--;
-				assert(cqe->res == 0 && cqe->flags == seqs[slot_idx]);
-				seqs[slot_idx]++;
-			} else {
-				fprintf(stderr, "invalid cqe %lu %i\n",
-					(unsigned long)cqe->user_data, cqe->res);
-				return -1;
-			}
-			io_uring_cqe_seen(ring, cqe);
-		}
-		assert(check_cq_empty(ring));
-
-		ret = recv(sock_rx, rx_buffer, payload_size, MSG_TRUNC);
-		assert(ret == payload_size);
-	}
-	return 0;
-}
-
-static int test_multireq_notif(struct io_uring *ring, int sock_tx, int sock_rx)
-{
-	bool slot_seen[NR_SLOTS] = {};
-	struct io_uring_sqe *sqe;
-	struct io_uring_cqe *cqe;
-	int msg_flags = 0;
-	int slot_idx = 0;
-	unsigned zc_flags = 0;
-	int payload_size = 1;
-	int ret, j, i = 0;
-	int nr = NR_SLOTS * 21;
-
-	while (i < nr) {
-		int nr_per_wave = 23;
-
-		for (j = 0; j < nr_per_wave && i < nr; j++, i++) {
-			slot_idx = rand() % NR_SLOTS;
-			sqe = io_uring_get_sqe(ring);
-			io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, payload_size,
-					     msg_flags, slot_idx, zc_flags);
-			sqe->user_data = i;
-		}
-		ret = io_uring_submit(ring);
-		assert(ret == j);
-	}
-
-	for (i = 0; i < nr; i++) {
-		ret = io_uring_wait_cqe(ring, &cqe);
-		assert(!ret);
-		assert(cqe->user_data < nr && cqe->res == payload_size);
-		io_uring_cqe_seen(ring, cqe);
-
-		ret = recv(sock_rx, rx_buffer, payload_size, MSG_TRUNC);
-		assert(ret == payload_size);
-	}
-	assert(check_cq_empty(ring));
-
-	zc_flags = IORING_RECVSEND_NOTIF_FLUSH;
-	for (slot_idx = 0; slot_idx < NR_SLOTS; slot_idx++) {
-		sqe = io_uring_get_sqe(ring);
-		io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, payload_size,
-				     msg_flags, slot_idx, zc_flags);
-		sqe->user_data = slot_idx;
-		/* just to simplify cqe handling */
-		sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
-	}
-	ret = io_uring_submit(ring);
-	assert(ret == NR_SLOTS);
-
-	for (i = 0; i < NR_SLOTS; i++) {
-		int slot_idx;
-
-		ret = io_uring_wait_cqe(ring, &cqe);
-		assert(!ret);
-		assert(tag_userdata(cqe->user_data));
-
-		slot_idx = cqe->user_data - ZC_TAG;
-		assert(!slot_seen[slot_idx]);
-		slot_seen[slot_idx] = true;
-
-		assert(cqe->res == 0 && cqe->flags == seqs[slot_idx]);
-		seqs[slot_idx]++;
-		io_uring_cqe_seen(ring, cqe);
-
-		ret = recv(sock_rx, rx_buffer, payload_size, MSG_TRUNC);
-		assert(ret == payload_size);
-	}
-	assert(check_cq_empty(ring));
-
-	for (i = 0; i < NR_SLOTS; i++)
-		assert(slot_seen[i]);
-	return 0;
-}
-
-static int test_multi_send_flushing(struct io_uring *ring, int sock_tx, int sock_rx)
-{
-	struct io_uring_sqe *sqe;
-	struct io_uring_cqe *cqe;
-	unsigned zc_flags = IORING_RECVSEND_NOTIF_FLUSH;
-	int msg_flags = 0, slot_idx = 0;
-	int payload_size = 1;
-	int ret, j, i = 0;
-	int nr = NR_SLOTS * 30;
-	unsigned long long check = 0, expected = 0;
-
-	while (i < nr) {
-		int nr_per_wave = 25;
-
-		for (j = 0; j < nr_per_wave && i < nr; j++, i++) {
-			sqe = io_uring_get_sqe(ring);
-			io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, payload_size,
-					     msg_flags, slot_idx, zc_flags);
-			sqe->user_data = 1;
-			sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
-		}
-		ret = io_uring_submit(ring);
-		assert(ret == j);
-	}
-
-	for (i = 0; i < nr; i++) {
-		int seq;
-
-		ret = io_uring_wait_cqe(ring, &cqe);
-		assert(!ret);
-		assert(!cqe->res);
-		assert(tag_userdata(cqe->user_data));
-
-		seq = cqe->flags;
-		check += seq * 100007UL;
-		io_uring_cqe_seen(ring, cqe);
-
-		ret = recv(sock_rx, rx_buffer, payload_size, MSG_TRUNC);
-		assert(ret == payload_size);
-	}
-	assert(check_cq_empty(ring));
-
-	for (i = 0; i < nr; i++)
-		expected += (i + seqs[slot_idx]) * 100007UL;
-	assert(check == expected);
-	seqs[slot_idx] += nr;
-	return 0;
-}
-
-static int do_one_fail_notif_flush(struct io_uring *ring, int off, int nr)
-{
-	struct io_uring_cqe *cqe;
-	struct io_uring_sqe *sqe;
-	int ret;
-
-	/* single out-of-bounds slot */
-	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_notif_update(sqe, 0, off, nr);
-	sqe->user_data = 1;
-	ret = io_uring_submit(ring);
-	assert(ret == 1);
-	ret = io_uring_wait_cqe(ring, &cqe);
-	assert(!ret && cqe->user_data == 1);
-	ret = cqe->res;
-	io_uring_cqe_seen(ring, cqe);
-	return ret;
-}
-
-static int test_update_flush_fail(struct io_uring *ring)
-{
-	int ret;
-
-	/* single out-of-bounds slot */
-	ret = do_one_fail_notif_flush(ring, NR_SLOTS, 1);
-	assert(ret == -EINVAL);
-
-	/* out-of-bounds range */
-	ret = do_one_fail_notif_flush(ring, 0, NR_SLOTS + 3);
-	assert(ret == -EINVAL);
-	ret = do_one_fail_notif_flush(ring, NR_SLOTS - 1, 2);
-	assert(ret == -EINVAL);
-
-	/* overflow checks, note it's u32 internally */
-	ret = do_one_fail_notif_flush(ring, ~(__u32)0, 1);
-	assert(ret == -EOVERFLOW);
-	ret = do_one_fail_notif_flush(ring, NR_SLOTS - 1, ~(__u32)0);
-	assert(ret == -EOVERFLOW);
-	return 0;
-}
-
-static void do_one_consume(struct io_uring *ring, int sock_tx, int sock_rx,
-			  int slot_idx)
-{
-	int ret;
-
-	ret = do_one(ring, sock_tx, slot_idx);
-	assert(ret == 1);
-
-	ret = recv(sock_rx, rx_buffer, 1, MSG_TRUNC);
-	assert(ret == 1);
-}
-
-static int test_update_flush(struct io_uring *ring, int sock_tx, int sock_rx)
-{
-	struct io_uring_sqe *sqe;
-	struct io_uring_cqe *cqe;
-	int offset = 1, nr_to_flush = 3;
-	int ret, i, slot_idx;
-
-	/*
-	 * Flush will be skipped for unused slots, so attached at least 1 req
-	 * to each active notifier / slot
-	 */
-	for (slot_idx = 0; slot_idx < NR_SLOTS; slot_idx++)
-		do_one_consume(ring, sock_tx, sock_rx, slot_idx);
-
-	assert(check_cq_empty(ring));
-
-	/* flush first */
-	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_notif_update(sqe, 0, 0, 1);
-	sqe->user_data = 1;
-	sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
-	ret = io_uring_submit(ring);
-	assert(ret == 1);
-
-	ret = io_uring_wait_cqe(ring, &cqe);
-	assert(!ret && !cqe->res && cqe->user_data == ZC_TAG);
-	assert(cqe->flags == seqs[0]);
-	seqs[0]++;
-	io_uring_cqe_seen(ring, cqe);
-	do_one_consume(ring, sock_tx, sock_rx, 0);
-	assert(check_cq_empty(ring));
+	int ret, i;
 
-	/* flush last */
 	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_notif_update(sqe, 0, NR_SLOTS - 1, 1);
+	io_uring_prep_send_zc(sqe, sock_tx, (void *)1UL, payload_size,
+			      msg_flags, zc_flags);
 	sqe->user_data = 1;
-	sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
-	ret = io_uring_submit(ring);
-	assert(ret == 1);
-
-	ret = io_uring_wait_cqe(ring, &cqe);
-	assert(!ret && !cqe->res && cqe->user_data == ZC_TAG + NR_SLOTS - 1);
-	assert(cqe->flags == seqs[NR_SLOTS - 1]);
-	seqs[NR_SLOTS - 1]++;
-	io_uring_cqe_seen(ring, cqe);
-	assert(check_cq_empty(ring));
 
-	/* we left the last slot without attached requests, flush should ignore it */
 	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_notif_update(sqe, 0, NR_SLOTS - 1, 1);
-	sqe->user_data = 1;
-	ret = io_uring_submit(ring);
-	assert(ret == 1);
-
-	ret = io_uring_wait_cqe(ring, &cqe);
-	assert(!ret && !cqe->res && cqe->user_data == 1);
-	io_uring_cqe_seen(ring, cqe);
-	assert(check_cq_empty(ring));
+	io_uring_prep_send_zc(sqe, sock_tx, (void *)1UL, payload_size,
+			      msg_flags, zc_flags);
+	sqe->user_data = 2;
+	io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)1UL,
+				    sizeof(struct sockaddr_in6));
 
-	/* flush range */
-	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_notif_update(sqe, 0, offset, nr_to_flush);
-	sqe->user_data = 1;
-	sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
 	ret = io_uring_submit(ring);
-	assert(ret == 1);
-
-	for (i = 0; i < nr_to_flush; i++) {
-		int slot_idx;
+	assert(ret == 2);
 
+	for (i = 0; i < 2; i++) {
 		ret = io_uring_wait_cqe(ring, &cqe);
-		assert(!ret && !cqe->res);
-		assert(ZC_TAG + offset <= cqe->user_data &&
-		       cqe->user_data < ZC_TAG + offset + nr_to_flush);
-		slot_idx = cqe->user_data - ZC_TAG;
-		assert(cqe->flags == seqs[slot_idx]);
-		seqs[slot_idx]++;
+		assert(!ret);
+		assert(cqe->user_data <= 2);
+		assert(cqe->res == -EFAULT);
+		assert(!(cqe->flags & IORING_CQE_F_MORE));
 		io_uring_cqe_seen(ring, cqe);
 	}
 	assert(check_cq_empty(ring));
-	return 0;
-}
-
-static int test_registration(int sock_tx, int sock_rx)
-{
-	struct io_uring_notification_slot slots[2] = {
-		{.tag = 1}, {.tag = 2},
-	};
-	void *invalid_slots = (void *)1UL;
-	struct io_uring ring;
-	int ret, i;
-
-	ret = io_uring_queue_init(4, &ring, 0);
-	if (ret) {
-		fprintf(stderr, "queue init failed: %d\n", ret);
-		return 1;
-	}
-
-	ret = io_uring_unregister_notifications(&ring);
-	if (ret != -ENXIO) {
-		fprintf(stderr, "unregister nothing: %d\n", ret);
-		return 1;
-	}
-
-	ret = io_uring_register_notifications(&ring, 2, slots);
-	if (ret) {
-		fprintf(stderr, "io_uring_register_notifications failed: %d\n", ret);
-		return 1;
-	}
-
-	ret = io_uring_register_notifications(&ring, 2, slots);
-	if (ret != -EBUSY) {
-		fprintf(stderr, "double register: %d\n", ret);
-		return 1;
-	}
-
-	ret = io_uring_unregister_notifications(&ring);
-	if (ret) {
-		fprintf(stderr, "unregister failed: %d\n", ret);
-		return 1;
-	}
-
-	ret = io_uring_register_notifications(&ring, 2, slots);
-	if (ret) {
-		fprintf(stderr, "second register failed: %d\n", ret);
-		return 1;
-	}
-
-	ret = test_invalid_slot(&ring, sock_tx, sock_rx);
-	if (ret) {
-		fprintf(stderr, "test_invalid_slot() failed\n");
-		return ret;
-	}
-
-	for (i = 0; i < 2; i++) {
-		ret = do_one(&ring, sock_tx, 0);
-		assert(ret == 1);
-
-		ret = recv(sock_rx, rx_buffer, 1, MSG_TRUNC);
-		assert(ret == 1);
-	}
-
-	io_uring_queue_exit(&ring);
-	ret = io_uring_queue_init(4, &ring, 0);
-	if (ret) {
-		fprintf(stderr, "queue init failed: %d\n", ret);
-		return 1;
-	}
-
-	ret = io_uring_register_notifications(&ring, 4, invalid_slots);
-	if (ret != -EFAULT) {
-		fprintf(stderr, "io_uring_register_notifications with invalid ptr: %d\n", ret);
-		return 1;
-	}
-
-	io_uring_queue_exit(&ring);
-	return 0;
+	return T_EXIT_PASS;
 }
 
 static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock_server,
@@ -644,12 +241,11 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 			     size_t send_size, bool cork, bool mix_register,
 			     int buf_idx)
 {
-	const unsigned slot_idx = 0;
 	const unsigned zc_flags = 0;
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	int nr_reqs = cork ? 5 : 1;
-	int i, ret;
+	int i, ret, nr_cqes;
 	size_t chunk_size = send_size / nr_reqs;
 	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
 	char *buf = buffers_iov[buf_idx].iov_base;
@@ -660,39 +256,35 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	memset(rx_buffer, 0, send_size);
 
 	for (i = 0; i < nr_reqs; i++) {
-		bool cur_fixed_buf = fixed_buf;
+		bool real_fixed_buf = fixed_buf;
 		size_t cur_size = chunk_size;
 		int msg_flags = MSG_WAITALL;
 
 		if (mix_register)
-			cur_fixed_buf = rand() & 1;
+			real_fixed_buf = rand() & 1;
 
 		if (cork && i != nr_reqs - 1)
-			msg_flags = MSG_MORE;
+			msg_flags |= MSG_MORE;
 		if (i == nr_reqs - 1)
 			cur_size = chunk_size_last;
 
 		sqe = io_uring_get_sqe(ring);
-		if (cur_fixed_buf)
-			io_uring_prep_sendzc_fixed(sqe, sock_client,
-					     buf + i * chunk_size,
-					     cur_size, msg_flags, slot_idx,
-					     zc_flags, buf_idx);
-		else
-			io_uring_prep_sendzc(sqe, sock_client,
-					     buf + i * chunk_size,
-					     cur_size, msg_flags, slot_idx,
-					     zc_flags);
+		io_uring_prep_send_zc(sqe, sock_client, buf + i * chunk_size,
+				      cur_size, msg_flags, zc_flags);
+		sqe->user_data = i;
 
+		if (real_fixed_buf) {
+			sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+			sqe->buf_index = buf_idx;
+		}
 		if (addr) {
 			sa_family_t fam = ((struct sockaddr_in *)addr)->sin_family;
 			int addr_len = fam == AF_INET ? sizeof(struct sockaddr_in) :
 							sizeof(struct sockaddr_in6);
 
-			io_uring_prep_sendzc_set_addr(sqe, (const struct sockaddr *)addr,
-						      addr_len);
+			io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)addr,
+						    addr_len);
 		}
-		sqe->user_data = i;
 	}
 
 	ret = io_uring_submit(ring);
@@ -705,9 +297,7 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	if (p == -1) {
 		fprintf(stderr, "fork() failed\n");
 		return 1;
-	}
-
-	if (p == 0) {
+	} else if (p == 0) {
 		size_t bytes_received = 0;
 
 		while (bytes_received != send_size) {
@@ -732,7 +322,8 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		exit(0);
 	}
 
-	for (i = 0; i < nr_reqs; i++) {
+	nr_cqes = 2 * nr_reqs;
+	for (i = 0; i < nr_cqes; i++) {
 		int expected = chunk_size;
 
 		ret = io_uring_wait_cqe(ring, &cqe);
@@ -744,11 +335,18 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 			fprintf(stderr, "invalid user_data\n");
 			return 1;
 		}
-		if (cqe->user_data == nr_reqs - 1)
-			expected = chunk_size_last;
-		if (cqe->res != expected) {
-			fprintf(stderr, "invalid cqe->res %d expected %d\n",
-					 cqe->res, expected);
+		if (!(cqe->flags & IORING_CQE_F_NOTIF)) {
+			if (cqe->user_data == nr_reqs - 1)
+				expected = chunk_size_last;
+			if (cqe->res != expected) {
+				fprintf(stderr, "invalid cqe->res %d expected %d\n",
+						 cqe->res, expected);
+				return 1;
+			}
+		}
+		if ((cqe->flags & IORING_CQE_F_MORE) ==
+		    (cqe->flags & IORING_CQE_F_NOTIF)) {
+			fprintf(stderr, "unexpected cflags %i\n", cqe->flags);
 			return 1;
 		}
 		io_uring_cqe_seen(ring, cqe);
@@ -845,6 +443,8 @@ static int test_async_addr(struct io_uring *ring)
 	struct __kernel_timespec ts;
 	int ret;
 
+	ts.tv_sec = 1;
+	ts.tv_nsec = 0;
 	ret = prepare_ip(&addr, &sock_tx, &sock_rx, true, false, false, false);
 	if (ret) {
 		fprintf(stderr, "sock prep failed %d\n", ret);
@@ -852,17 +452,15 @@ static int test_async_addr(struct io_uring *ring)
 	}
 
 	sqe = io_uring_get_sqe(ring);
-	ts.tv_sec = 1;
-	ts.tv_nsec = 0;
 	io_uring_prep_timeout(sqe, &ts, 0, IORING_TIMEOUT_ETIME_SUCCESS);
 	sqe->user_data = 1;
 	sqe->flags |= IOSQE_IO_LINK;
 
 	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, 1, 0, 0, 0);
+	io_uring_prep_send_zc(sqe, sock_tx, tx_buffer, 1, 0, 0);
 	sqe->user_data = 2;
-	io_uring_prep_sendzc_set_addr(sqe, (const struct sockaddr *)&addr,
-				      sizeof(struct sockaddr_in6));
+	io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)&addr,
+				    sizeof(struct sockaddr_in6));
 
 	ret = io_uring_submit(ring);
 	assert(ret == 2);
@@ -894,6 +492,14 @@ static int test_async_addr(struct io_uring *ring)
 	ret = recv(sock_rx, rx_buffer, 1, MSG_TRUNC);
 	assert(ret == 1);
 
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "io_uring_wait_cqe failed %i\n", ret);
+		return 1;
+	}
+	assert(cqe->flags & IORING_CQE_F_NOTIF);
+	io_uring_cqe_seen(ring, cqe);
+
 	close(sock_tx);
 	close(sock_rx);
 	return 0;
@@ -937,15 +543,6 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
-	ret = register_notifications(&ring);
-	if (ret == -EINVAL) {
-		printf("sendzc is not supported, skip\n");
-		return T_EXIT_SKIP;
-	} else if (ret) {
-		fprintf(stderr, "register notif failed %i\n", ret);
-		return T_EXIT_FAIL;
-	}
-
 	srand((unsigned)time(NULL));
 	for (i = 0; i < len; i++)
 		tx_buffer[i] = i;
@@ -956,70 +553,24 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
-	ret = test_registration(sp[0], sp[1]);
-	if (ret) {
-		fprintf(stderr, "test_registration() failed\n");
-		return ret;
-	}
-
-	ret = test_invalid_slot(&ring, sp[0], sp[1]);
-	if (ret) {
-		fprintf(stderr, "test_invalid_slot() failed\n");
-		return T_EXIT_FAIL;
-	}
-
 	ret = test_basic_send(&ring, sp[0], sp[1]);
+	if (ret == T_EXIT_SKIP)
+		return ret;
 	if (ret) {
 		fprintf(stderr, "test_basic_send() failed\n");
 		return T_EXIT_FAIL;
 	}
 
-	ret = test_send_flush(&ring, sp[0], sp[1]);
-	if (ret) {
-		fprintf(stderr, "test_send_flush() failed\n");
-		return T_EXIT_FAIL;
-	}
-
-	ret = test_multireq_notif(&ring, sp[0], sp[1]);
-	if (ret) {
-		fprintf(stderr, "test_multireq_notif() failed\n");
-		return T_EXIT_FAIL;
-	}
-
-	ret = reregister_notifications(&ring);
+	ret = test_send_faults(&ring, sp[0], sp[1]);
 	if (ret) {
-		fprintf(stderr, "reregister notifiers failed %i\n", ret);
-		return T_EXIT_FAIL;
-	}
-	/* retry a few tests after registering notifs */
-	ret = test_invalid_slot(&ring, sp[0], sp[1]);
-	if (ret) {
-		fprintf(stderr, "test_invalid_slot() failed\n");
+		fprintf(stderr, "test_send_faults() failed\n");
 		return T_EXIT_FAIL;
 	}
 
-	ret = test_multireq_notif(&ring, sp[0], sp[1]);
-	if (ret) {
-		fprintf(stderr, "test_multireq_notif2() failed\n");
-		return T_EXIT_FAIL;
-	}
-
-	ret = test_multi_send_flushing(&ring, sp[0], sp[1]);
-	if (ret) {
-		fprintf(stderr, "test_multi_send_flushing() failed\n");
-		return T_EXIT_FAIL;
-	}
-
-	ret = test_update_flush_fail(&ring);
-	if (ret) {
-		fprintf(stderr, "test_update_flush_fail() failed\n");
-		return T_EXIT_FAIL;
-	}
-
-	ret = test_update_flush(&ring, sp[0], sp[1]);
+	ret = test_async_addr(&ring);
 	if (ret) {
-		fprintf(stderr, "test_update_flush() failed\n");
-		return T_EXIT_FAIL;
+		fprintf(stderr, "test_async_addr() failed\n");
+		return ret;
 	}
 
 	ret = t_register_buffers(&ring, buffers_iov, ARRAY_SIZE(buffers_iov));
@@ -1036,12 +587,6 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "test_inet_send() failed\n");
 		return ret;
 	}
-
-	ret = test_async_addr(&ring);
-	if (ret) {
-		fprintf(stderr, "test_async_addr() failed\n");
-		return ret;
-	}
 out:
 	io_uring_queue_exit(&ring);
 	close(sp[0]);
-- 
2.37.2

