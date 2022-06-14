Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D63154B392
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243978AbiFNOiA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245372AbiFNOhx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:53 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC8BB7F2
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:52 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id w17so4075107wrg.7
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Peng1QhMzZQpZunkpzCR1eikF0YslET37BvOxslBf8s=;
        b=ZAv7y97dnw3gWNiOCLFesZAV8l9UNvFpGsoEn5i3j+IT9YUBzO+dg9smXaf1lNgTC3
         9BAdtmncq3vyP9HZd9+o0WlpJLYS1o0qDhQPlZ2gWu/1ygi7IeCWspIawGl1eA0X1Jbi
         CjqxYMZAgWAtv0HuUcDZLLNpWmkzuB4d5wNz6RhemXeHCugg8VIA4uFzS4JiKRyzEO1T
         V2t1klm/zbVx91BsrrB/5SHtFvkO+185EmLWficCglo8ESimnxPKclqZcKTaBkZ9i2O+
         GVPXTN60NeeTZlCD2WHnKVcI61V9KV+xa3QKzVsFVuhKOEDAvpOs0ZL3B3EIE7kN7gAt
         O0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Peng1QhMzZQpZunkpzCR1eikF0YslET37BvOxslBf8s=;
        b=JQcaPFwYF9ErXsYkUaKA3hivk9ZI8Yiwz54oIb5zXAejwv5hzOfHmoYNqTVfdKfpBe
         IuUAleh//xqLvJwBuak/L8rPgRy1Y9l+i8r/99tjMDfBxTVzjzOSFYEuUKMfKzRIUV4X
         EYlxbJVbFG2fHH9iH6SEHNYDd9rWsIaB3SIsnpFLO0DDIPGbIH0zb7vCwE+Soy2EVLH/
         z1lcs7xIaSmso/C+mlFMyG8YiyNeycNVYXf34W86ufF6K5xWCjw2J+n1nq7Ag+FchrRP
         XQsJlC4qg+uHWMHyzFkGtMs2jJRnrbITZX8T8+ti9BDM534gY9Oct2UegXpRpTX4EP7K
         GiWQ==
X-Gm-Message-State: AJIora9ptVed9PyalYZ0veqVoJgFzp+/zFp2Q+kS2Lipg4iYM5y3KHj+
        1f81Q8vwOhnmVX9aLn/zgct6q9aEKpV5Lw==
X-Google-Smtp-Source: AGRyM1v6s+5hvouYp0MrS6SpkdOWxTcMmX+fWDWYF6wR2iE/LTSx7T7mHJYJrx0+JUWzsL+PvQvbjw==
X-Received: by 2002:adf:e28a:0:b0:210:b31:722 with SMTP id v10-20020adfe28a000000b002100b310722mr5244274wri.65.1655217470330;
        Tue, 14 Jun 2022 07:37:50 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 10/25] io_uring: kill REQ_F_COMPLETE_INLINE
Date:   Tue, 14 Jun 2022 15:37:00 +0100
Message-Id: <378d3aba69ea2b6a8b14624810a551c2ae011791.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
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

REQ_F_COMPLETE_INLINE is only needed to delay queueing into the
completion list to io_queue_sqe() as __io_req_complete() is inlined and
we don't want to bloat the kernel.

As now we complete in a more centralised fashion in io_issue_sqe() we
can get rid of the flag and queue to the list directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c       | 20 ++++++++------------
 io_uring/io_uring.h       |  5 -----
 io_uring/io_uring_types.h |  3 ---
 3 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1fb93fdcfbab..fcee58c6c35e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1278,17 +1278,14 @@ static void io_req_complete_post32(struct io_kiocb *req, u64 extra1, u64 extra2)
 
 inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
 {
-	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
-		io_req_complete_state(req);
-	else
-		io_req_complete_post(req);
+	io_req_complete_post(req);
 }
 
 void __io_req_complete32(struct io_kiocb *req, unsigned int issue_flags,
 			 u64 extra1, u64 extra2)
 {
 	if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
-		io_req_complete_state(req);
+		io_req_add_compl_list(req);
 		req->extra1 = extra1;
 		req->extra2 = extra2;
 	} else {
@@ -2132,9 +2129,12 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if (creds)
 		revert_creds(creds);
 
-	if (ret == IOU_OK)
-		__io_req_complete(req, issue_flags);
-	else if (ret != IOU_ISSUE_SKIP_COMPLETE)
+	if (ret == IOU_OK) {
+		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
+			io_req_add_compl_list(req);
+		else
+			io_req_complete_post(req);
+	} else if (ret != IOU_ISSUE_SKIP_COMPLETE)
 		return ret;
 
 	/* If the op doesn't have a file, we're not polling for it */
@@ -2299,10 +2299,6 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
-	if (req->flags & REQ_F_COMPLETE_INLINE) {
-		io_req_add_compl_list(req);
-		return;
-	}
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 26b669746d61..2141519e995a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -193,11 +193,6 @@ static inline bool io_run_task_work(void)
 	return false;
 }
 
-static inline void io_req_complete_state(struct io_kiocb *req)
-{
-	req->flags |= REQ_F_COMPLETE_INLINE;
-}
-
 static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
 {
 	if (!*locked) {
diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index ca8e25992ece..3228872c199b 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -299,7 +299,6 @@ enum {
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_BUFFER_RING_BIT,
-	REQ_F_COMPLETE_INLINE_BIT,
 	REQ_F_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
 	REQ_F_REFCOUNT_BIT,
@@ -353,8 +352,6 @@ enum {
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 	/* buffer selected from ring, needs commit */
 	REQ_F_BUFFER_RING	= BIT(REQ_F_BUFFER_RING_BIT),
-	/* completion is deferred through io_comp_state */
-	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
 	/* caller should reissue async */
 	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
 	/* supports async reads/writes */
-- 
2.36.1

