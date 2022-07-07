Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB6E56A52F
	for <lists+io-uring@lfdr.de>; Thu,  7 Jul 2022 16:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiGGOOY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 10:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbiGGOOX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 10:14:23 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB892F3A0
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 07:14:22 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z41so23360301ede.1
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 07:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6BtvDKTuBY2Sh4BYJQe6+DnANlvOqVlrRS4OpC6qmGA=;
        b=RkQZfvIniOzxxWntRZZIFvB6zauSh0kc00Uru5IYlYHdrlh7ZPEGLASEhengF0uHcm
         vYPGDYmg7XEXyIzaSqp7GBLIAz10xFl1HookPqnw4lJBnFJtewjjJRqfB5TwlO7VMsyM
         tcx47ZOtHwAHg+DljqOB1EHVCw/BC0y/D/nvJznTwX5y8V97eljuQwjOlHlYd1SpJqZt
         iYyICowevEXaYqVh5CYqoQFfDfq4WWjZO/ne2ILuHAs+cIfQ4S9wrqtadxmHm29L7gS/
         wAHNkr4yICVQHtUXtX0wnLlph+dMow++RdBUGB5XbUJpgVUw0lA0cO0ZRzPivBpOcXrX
         vW0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6BtvDKTuBY2Sh4BYJQe6+DnANlvOqVlrRS4OpC6qmGA=;
        b=yXlQ7Ycstbly5uwS7i06FMVEikr/oIOnZnDuhxKE2f7st4GFDDsbYhrdT1/Xhm3YLE
         vc5g3NJ/VahqiMiJsJnoQ1GU1i7VqT7IYEjt++EfHd6oYqao44CCqoz0u9kUs+0zGSnl
         oOYUv0MSZDoy5sNDphV9/uOSImTE2UQlUpEV512tys4r8v+5KAxyENlfvSOX2yRwNJOl
         OAvzpBNCSpqKT4nd4pvNoOhLuvRAhsUL8FDBVs6pDf/49r7R4qEIcldvLhc3KL3ccBIH
         SE1nCZYRpcsVZjVRlebtGFI2M5yX/8uN/eyDjf3Ftt9Q55rm01u+UoX/F2qGB6turgii
         GEXA==
X-Gm-Message-State: AJIora8FYmb4OaZDx87KktdnfzWRgvRkle71l1X0/uTwlvhPr3j3eNPd
        Iztipkoqz0zYsfLSlwpyxjxDKkZBOOwxoLr1
X-Google-Smtp-Source: AGRyM1uj9PyAPAmfQfCu36o2c3Taw8qejLfpNHezWHHpsXD0SiBgjShaKZWu7z52OpXvA0hVAfjH8w==
X-Received: by 2002:a50:eb89:0:b0:43a:1212:db8c with SMTP id y9-20020a50eb89000000b0043a1212db8cmr36013663edr.391.1657203259923;
        Thu, 07 Jul 2022 07:14:19 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:3fc3])
        by smtp.gmail.com with ESMTPSA id bq15-20020a056402214f00b00435a742e350sm28254125edb.75.2022.07.07.07.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:14:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/4] io_uring: consolidate hash_locked io-wq handling
Date:   Thu,  7 Jul 2022 15:13:17 +0100
Message-Id: <0ff0ffdfaa65b3d536131535c3dad3c63d9b7bb0.1657203020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657203020.git.asml.silence@gmail.com>
References: <cover.1657203020.git.asml.silence@gmail.com>
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

Don't duplicate code disabling REQ_F_HASH_LOCKED for IO_URING_F_UNLOCKED
(i.e. io-wq), move the handling into __io_arm_poll_handler().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 77b669b06046..76592063abe7 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -523,8 +523,12 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	 * io_poll_can_finish_inline() tries to deal with that.
 	 */
 	ipt->owning = issue_flags & IO_URING_F_UNLOCKED;
-
 	atomic_set(&req->poll_refs, (int)ipt->owning);
+
+	/* io-wq doesn't hold uring_lock */
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		req->flags &= ~REQ_F_HASH_LOCKED;
+
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
 
 	if (unlikely(ipt->error || !ipt->nr_entries)) {
@@ -618,8 +622,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	 * apoll requests already grab the mutex to complete in the tw handler,
 	 * so removal from the mutex-backed hash is free, use it by default.
 	 */
-	if (!(issue_flags & IO_URING_F_UNLOCKED))
-		req->flags |= REQ_F_HASH_LOCKED;
+	req->flags |= REQ_F_HASH_LOCKED;
 
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
@@ -876,8 +879,7 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	 * If sqpoll or single issuer, there is no contention for ->uring_lock
 	 * and we'll end up holding it in tw handlers anyway.
 	 */
-	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-	    (req->ctx->flags & (IORING_SETUP_SQPOLL | IORING_SETUP_SINGLE_ISSUER)))
+	if (req->ctx->flags & (IORING_SETUP_SQPOLL|IORING_SETUP_SINGLE_ISSUER))
 		req->flags |= REQ_F_HASH_LOCKED;
 
 	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events, issue_flags);
-- 
2.36.1

