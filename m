Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4081662FEB2
	for <lists+io-uring@lfdr.de>; Fri, 18 Nov 2022 21:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbiKRUVt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Nov 2022 15:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbiKRUVg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Nov 2022 15:21:36 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD4E53EDD
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 12:21:18 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id n21so15685711ejb.9
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 12:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ML7QyRbRZfvof6QgC9L7k1Jf+dWffgdZpHXAk5DYVQs=;
        b=go/pCnSGyNx/8dKBgyym+coCIRawJyglf2InTdUM9lXbFPDe/oW2eCocnhVRoKyLVe
         lBXyx4+vPBgdmdnnjurzEnKXJHKZ/2WuRnAZjnJC/pF/awJy24QwR5TyClfKnWkK6Li+
         QdmALUjQ6PK3w+IaauacLHn6R5qe2fwnxMyvdjV+EomL+Xedwp2dzx68l8eqUXOSq45J
         Pyi3wBavGXrBP58PBZpD2pXD60NEBvE40DLEe4MVWUd6TXr5E1lJu6ZpwZRqdE11GhwS
         Y9+Vn9IeUMbR80TVtDr/0x2hNQY8/2OakBFjMx710eGhrw+pzA7m45Job4iisaa14b4L
         aJ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ML7QyRbRZfvof6QgC9L7k1Jf+dWffgdZpHXAk5DYVQs=;
        b=ipLiTEJ5Fc2LRF1bCVyOi2rXUWUsfVcMCTjE0g5mCGG84xTHF6MaqyMrEPNq4sSidW
         TFt1gtqugwlY+IDJpCRjPQrsOGy7u8dr8hbuI44tL1WjnG0DflZsbtU8TIhfhzYMvixS
         7Ag7kZhSIo2YcUi6U7q3n1/1FlxYrcNNQXagoYkZM2pROLFbTBi1C+4Z301FDq3QfN2N
         6xs3DKwy0SrTr/SaM3wStSt08ClmvD1OR7Evexta+bf886HvfC78tTpjNs+EzQoiJI1r
         RePg+aJrQzdLGtpEw64e3tQpJeG4xgyllDpGevkYNJQdx4EI0BsYH39pe3ob6iGtzalB
         nAHQ==
X-Gm-Message-State: ANoB5pnnT1DGMcm8vOixiVQiCHx+XkJ2P1MdAmQGseID0c0zOTftpYiH
        0Et5JplSKepookItlGXR1ltIANh2fsQ=
X-Google-Smtp-Source: AA0mqf4+7asvqF/+nfk+g8CXf22bG+ehR3ZuSxaGsueKbtAPrBEwowjksaZVs80YCRkMS2A4yPwiBg==
X-Received: by 2002:a17:906:55c5:b0:78d:3862:4488 with SMTP id z5-20020a17090655c500b0078d38624488mr6986869ejp.683.1668802876401;
        Fri, 18 Nov 2022 12:21:16 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id q2-20020a17090676c200b007b43ef7c0basm87482ejn.134.2022.11.18.12.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 12:21:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Lin Horse <kylin.formalin@gmail.com>
Subject: [PATCH for-6.1 v2] io_uring: make poll refs more robust
Date:   Fri, 18 Nov 2022 20:20:29 +0000
Message-Id: <394b02d5ebf9d3f8ec0428bb512e6a8cd4a69d0f.1668802389.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

poll_refs carry two functions, the first is ownership over the request.
The second is notifying the io_poll_check_events() that there was an
event but wake up couldn't grab the ownership, so io_poll_check_events()
should retry.

We want to make poll_refs more robust against overflows. Instead of
always incrementing it, which covers two purposes with one atomic, check
if poll_refs is large and if so set a retry flag without attempts to
grab ownership. The gap between the bias check and following atomics may
seem racy, but we don't need it to be strict. Moreover there might only
be maximum 4 parallel updates: by the first and the second poll entries,
__io_arm_poll_handler() and cancellation. From those four, only poll wake
ups may be executed multiple times, but they're protected by a spin.

Cc: stable@vger.kernel.org
Reported-by: Lin Horse <kylin.formalin@gmail.com>
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: clear the retry flag before vfs_poll()

 io_uring/poll.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 055632e9092a..c831a7b6b468 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -40,7 +40,15 @@ struct io_poll_table {
 };
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_REF_MASK	GENMASK(30, 0)
+#define IO_POLL_RETRY_FLAG	BIT(30)
+#define IO_POLL_REF_MASK	GENMASK(29, 0)
+#define IO_POLL_RETRY_MASK	(IO_POLL_REF_MASK | IO_POLL_RETRY_FLAG)
+
+/*
+ * We usually have 1-2 refs taken, 128 is more than enough and we want to
+ * maximise the margin between this amount and the moment when it overflows.
+ */
+#define IO_POLL_REF_BIAS	128
 
 #define IO_WQE_F_DOUBLE		1
 
@@ -58,6 +66,21 @@ static inline bool wqe_is_double(struct wait_queue_entry *wqe)
 	return priv & IO_WQE_F_DOUBLE;
 }
 
+static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
+{
+	int v;
+
+	/*
+	 * poll_refs are already elevated and we don't have much hope for
+	 * grabbing the ownership. Instead of incrementing set a retry flag
+	 * to notify the loop that there might have been some change.
+	 */
+	v = atomic_fetch_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
+	if (!(v & IO_POLL_REF_MASK))
+		return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+	return false;
+}
+
 /*
  * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
  * bump it and acquire ownership. It's disallowed to modify requests while not
@@ -66,6 +89,8 @@ static inline bool wqe_is_double(struct wait_queue_entry *wqe)
  */
 static inline bool io_poll_get_ownership(struct io_kiocb *req)
 {
+	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+		return io_poll_get_ownership_slowpath(req);
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }
 
@@ -233,8 +258,17 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 		 * and all others are be lost. Redo vfs_poll() to get
 		 * up to date state.
 		 */
-		if ((v & IO_POLL_REF_MASK) != 1)
+		if ((v & IO_POLL_RETRY_MASK) != 1)
 			req->cqe.res = 0;
+		if (v & IO_POLL_RETRY_FLAG) {
+			/*
+			 * We won't find new events that came in between of
+			 * vfs_poll and the ref put unless we clear the flag
+			 * in advance.
+			 */
+			atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
+			v &= ~IO_POLL_RETRY_FLAG;
+		}
 
 		/* the mask was stashed in __io_poll_execute */
 		if (!req->cqe.res) {
@@ -274,7 +308,7 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
+	} while (atomic_sub_return(v & IO_POLL_RETRY_MASK, &req->poll_refs));
 
 	return IOU_POLL_NO_ACTION;
 }
@@ -590,7 +624,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		 * locked, kick it off for them.
 		 */
 		v = atomic_dec_return(&req->poll_refs);
-		if (unlikely(v & IO_POLL_REF_MASK))
+		if (unlikely(v & IO_POLL_RETRY_MASK))
 			__io_poll_execute(req, 0);
 	}
 	return 0;
-- 
2.38.1

