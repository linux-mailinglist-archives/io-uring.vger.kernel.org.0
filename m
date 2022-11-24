Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9262637D9C
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 17:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiKXQ3Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 11:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiKXQ3X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 11:29:23 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FAB170277
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 08:29:22 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 838CF8164B;
        Thu, 24 Nov 2022 16:29:18 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669307362;
        bh=WNN4MSAzEnSdNPtHpyHl24nIGH/PyYRQzsAIHhjoQtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bK/PexH8up11U/oWlP8PXaTxgRhvnzDnYjrJ2LYiUtpiBXRoiei0E/Ccmlzg54Vz4
         nucKYLLS/VrjBuEz5gH+RhH5iyA2Xi3i4AACb36AOToTYJTnGZBvRRakJmSb0RnYBZ
         Jy9SKifV78EOsxJ3sbLzFb/HYD/yvnba0Q4ThyWYhcQ+xpnVkcj/2dvUpeRgdhMZo7
         VWj1/DIwJP8Ca4Snd8Vx/4stKZ+NUg56BMxS/O2IX88qae0oJ5Y4rij62h9pQ01AQN
         J6biKIUQC/tbnUV/gTgBB8zR3O7tUUFIMW80ec8GDFL+4i4z5I1FaKNd6s+YPcispg
         OU8YyjwB6Gchg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 2/8] queue: Mark `__io_uring_flush_sq()` as static
Date:   Thu, 24 Nov 2022 23:28:55 +0700
Message-Id: <20221124162633.3856761-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124162633.3856761-1-ammar.faizi@intel.com>
References: <20221124162633.3856761-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

This function is not exported, mark it as static. Clang says:

  queue.c:204:10: error: no previous prototype for function \
  '__io_uring_flush_sq' [-Werror,-Wmissing-prototypes] \
  unsigned __io_uring_flush_sq(struct io_uring *ring)
           ^
  queue.c:204:1: note: declare 'static' if the function is not intended \
  to be used outside of this translation unit \
  unsigned __io_uring_flush_sq(struct io_uring *ring)

Side note:
There was an attempt to export this function because it is used by
test/iopoll.c and test/io_uring_passthrough.c. But after a discussion
with Dylan and Jens, it's better to make a copy of this function for
those tests only instead of exporting it. Therefore, also create a
copy of this function in test/helpers.c.

Cc: Dylan Yudaken <dylany@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/io-uring/6491d7b5-0a52-e6d1-0f86-d36ec88bbc15@kernel.dk
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/queue.c                 |  2 +-
 test/helpers.c              | 33 +++++++++++++++++++++++++++++++++
 test/helpers.h              |  2 ++
 test/io_uring_passthrough.c |  2 --
 test/iopoll.c               |  2 --
 5 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index feea0ad..b784b10 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -201,7 +201,7 @@ again:
  * Sync internal state with kernel ring state on the SQ side. Returns the
  * number of pending items in the SQ ring, for the shared ring.
  */
-unsigned __io_uring_flush_sq(struct io_uring *ring)
+static unsigned __io_uring_flush_sq(struct io_uring *ring)
 {
 	struct io_uring_sq *sq = &ring->sq;
 	unsigned tail = sq->sqe_tail;
diff --git a/test/helpers.c b/test/helpers.c
index 8fb32b8..869e903 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -266,3 +266,36 @@ bool t_probe_defer_taskrun(void)
 	io_uring_queue_exit(&ring);
 	return true;
 }
+
+/*
+ * Sync internal state with kernel ring state on the SQ side. Returns the
+ * number of pending items in the SQ ring, for the shared ring.
+ */
+unsigned __io_uring_flush_sq(struct io_uring *ring)
+{
+	struct io_uring_sq *sq = &ring->sq;
+	unsigned tail = sq->sqe_tail;
+
+	if (sq->sqe_head != tail) {
+		sq->sqe_head = tail;
+		/*
+		 * Ensure kernel sees the SQE updates before the tail update.
+		 */
+		if (!(ring->flags & IORING_SETUP_SQPOLL))
+			IO_URING_WRITE_ONCE(*sq->ktail, tail);
+		else
+			io_uring_smp_store_release(sq->ktail, tail);
+	}
+	/*
+	 * This _may_ look problematic, as we're not supposed to be reading
+	 * SQ->head without acquire semantics. When we're in SQPOLL mode, the
+	 * kernel submitter could be updating this right now. For non-SQPOLL,
+	 * task itself does it, and there's no potential race. But even for
+	 * SQPOLL, the load is going to be potentially out-of-date the very
+	 * instant it's done, regardless or whether or not it's done
+	 * atomically. Worst case, we're going to be over-estimating what
+	 * we can submit. The point is, we need to be able to deal with this
+	 * situation regardless of any perceived atomicity.
+	 */
+	return tail - *sq->khead;
+}
diff --git a/test/helpers.h b/test/helpers.h
index 4375a9e..cb814ca 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -85,6 +85,8 @@ enum t_setup_ret t_register_buffers(struct io_uring *ring,
 
 bool t_probe_defer_taskrun(void);
 
+unsigned __io_uring_flush_sq(struct io_uring *ring);
+
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
 #ifdef __cplusplus
diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index ee9ab87..d8468c5 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -268,8 +268,6 @@ static int test_io(const char *file, int tc, int read, int sqthread,
 	return ret;
 }
 
-extern unsigned __io_uring_flush_sq(struct io_uring *ring);
-
 /*
  * Send a passthrough command that nvme will fail during submission.
  * This comes handy for testing error handling.
diff --git a/test/iopoll.c b/test/iopoll.c
index 20f91c7..f8ab1f1 100644
--- a/test/iopoll.c
+++ b/test/iopoll.c
@@ -201,8 +201,6 @@ err:
 	return 1;
 }
 
-extern unsigned __io_uring_flush_sq(struct io_uring *ring);
-
 /*
  * if we are polling io_uring_submit needs to always enter the
  * kernel to fetch events
-- 
Ammar Faizi

