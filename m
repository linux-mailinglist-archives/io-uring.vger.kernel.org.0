Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108B754B14A
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355711AbiFNMeZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243391AbiFNMdp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:45 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9734F4B439
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:50 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v14so11084548wra.5
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TB/1dEsnzFxD0vauIvqVRckM4LeY6dlF3gUvCxeBMs0=;
        b=WN6tZRLO0TM2yBLdd+enYfc89A9Y2ui3aSt2F1RIOufNkdN5iGXF+g6kOEDnr30I86
         OgGNu+s5pENC5psU3EWw+QQOzDf4gLUdqmFgbeNWwyjrzo0nMxXTUaWtzzQduAD+jdQH
         TEbMHdGTqnGxbu2YoyJW1MfKmDLfV5we8jlyvTNAtiru/ReJodyU9hToqtLVVDelz9/l
         F9l+0Q8r08SQCwW3Gye8RyGuN2KfNh4ZTrY8coxU823f6jArSJsn9aTI8R7HnUakpSoz
         zOeDOwNqxPw06uaGO90bzbD+NQ/UYILQD8df0A5LQVL4B4YoFLfuWRYX351CgpWvgG2B
         kf4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TB/1dEsnzFxD0vauIvqVRckM4LeY6dlF3gUvCxeBMs0=;
        b=T7LNgUGiyS+/3wYm886ctYGOyJdwKAzECQkIhH6OPlRWHvm6f3m6VfDGr9VUD9rePT
         NK8+GQV0/35KmpxrpwxsCKOcnjxJYgIu/rYNYYmLwAstULznCWyuLSiKx/ekhbI8fCQ4
         U62LzdR9zPvxIIa+JEftp6g7Ub1OWxMMnhbK1B4qKe95SVDFQYGmdrp4onvLGryevE5h
         hZZbzuwcIbym2IIQ0MzbrRF9bQafqN429WjRzEm5hoqh0dt/zMZV2INMoT2iXfR1keTA
         4KoRJf1GipQJ2/DCD4lVAsNQ7+RLrSh4+NBw89g+FPhwsJwl+vaLEXM3ueFG6/FPbMUg
         R85g==
X-Gm-Message-State: AJIora8OvJdCTk7y9Aw1UW5DHYf5OBjyOdzP7GmW87x+4XS97ES2VCIt
        kTFuCskFh+9v6Yb52S5QtfgHwwMuFBElNA==
X-Google-Smtp-Source: AGRyM1sVQrWiZ4+QZnlzgBbsvAvCe6JrYZXbrWAbjXiOtdkZMTYELKltc9Doon/2sWL0oOZCxYDPXQ==
X-Received: by 2002:adf:ecce:0:b0:219:e5a7:64a8 with SMTP id s14-20020adfecce000000b00219e5a764a8mr4787538wro.278.1655209848684;
        Tue, 14 Jun 2022 05:30:48 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 11/25] io_uring: refactor io_req_task_complete()
Date:   Tue, 14 Jun 2022 13:29:49 +0100
Message-Id: <517340728990899f3bdd23a2b18929409cae0718.1655209709.git.asml.silence@gmail.com>
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

Clean up io_req_task_complete() and deduplicate io_put_kbuf() calls.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6c48d0c6dcd5..f3cae98471b8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1857,15 +1857,19 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 
 	return ret;
 }
-inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
+
+void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
-	if (*locked) {
-		req->cqe.flags |= io_put_kbuf(req, 0);
+	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
+		unsigned issue_flags = *locked ? IO_URING_F_UNLOCKED : 0;
+
+		req->cqe.flags |= io_put_kbuf(req, issue_flags);
+	}
+
+	if (*locked)
 		io_req_add_compl_list(req);
-	} else {
-		req->cqe.flags |= io_put_kbuf(req, IO_URING_F_UNLOCKED);
+	else
 		io_req_complete_post(req);
-	}
 }
 
 /*
-- 
2.36.1

