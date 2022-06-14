Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6A654B0BE
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243296AbiFNMeY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243075AbiFNMdp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:45 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E01C4B42C
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:49 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m125-20020a1ca383000000b0039c63fe5f64so4731124wme.0
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lDOepxPFCtlbou3NV1mYJpDfthiiMh/+cWslKUPd3nw=;
        b=PaA2PEcaqpf8zNxLiRGz0FCKXMQrimxszEFMFv1ZWcvlPklkGW+pH9GgBF/72+w20O
         OBpTNccsAN3aTySKJacIZzU7ISAW/Yl850aQbzoc6OZCmOgfCs2yARxJz4DPRqfs2T4i
         yyO9CJwZY63/8RjYNs/LNkyCXnp3di8w+5d4IgmmgaSH+aQvXV15UZwctJjFtnoIFYPO
         uf/xjD0kAi6OaRu2Bhy3eq44E8GBjbFphgla0mhTWEZZOL7KjYdiDKkdMrKLFZGBT4cD
         E5Kt4kbVKJVQRtOA0Xpa/zh3oqYsWFKlmT5udgJqwE/FkUj2Ruy67qzcefSyv5f5G2wA
         /Fgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lDOepxPFCtlbou3NV1mYJpDfthiiMh/+cWslKUPd3nw=;
        b=ycMtj86AO+VotFw418BAEKXLuaStG2NzdZ1jWwFoT93U7ap1yQC09XEdLjaA55mGmC
         QExDqE0YVvIiSJwugSVVsbGD3MN1rIiwFHJGnx/cJmZeNIYhIzhCmAG4uOK2fNnxHzbH
         2anpTTssr1GdN9Ewi++YwxKUR+fytaBecdyWn2RYNXD4GLXHoQTLUFwBIzskhXziVMV7
         Avssf7okzAP50GO2PvMbBScrnCgkh5BwcI91fc6kp2nn/axY2w2tLKlYs2addphXLjdp
         4JIVeXzRNUclfzOKRRKtkmWO5X1SoCnDJ1ukP0Uss4nTbKqbMZKQ7+MbdnWbqfFn+8h0
         2sjA==
X-Gm-Message-State: AOAM530XSlMZyb6mQ6eIgg0US/v0S3Xq1wVCSF6XXMfwMEyEziRu0Lav
        M3vxzc2gs9e70DNWL2TDa6f4fqrlWoFoeQ==
X-Google-Smtp-Source: ABdhPJzLgy/Pu/rruOs2FlE0fqnwtTACFsKG3goLm24dssi3jaZJzFJwglc2IUWVBUs0pb26gOsdcA==
X-Received: by 2002:a7b:c3d1:0:b0:39c:64d0:b8c2 with SMTP id t17-20020a7bc3d1000000b0039c64d0b8c2mr3969898wmj.195.1655209847489;
        Tue, 14 Jun 2022 05:30:47 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 10/25] io_uring: kill REQ_F_COMPLETE_INLINE
Date:   Tue, 14 Jun 2022 13:29:48 +0100
Message-Id: <f278bf835b5a327e96bb48bb2924e88cfcd27618.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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
index 5156844ca2bb..6c48d0c6dcd5 100644
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
index 25e07c3f7b2a..3cf06f4a4d2e 100644
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

