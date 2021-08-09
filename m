Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AC43E4CF2
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 21:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235934AbhHITTY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 15:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbhHITTV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 15:19:21 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810F6C06179B
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 12:18:56 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id w21-20020a7bc1150000b02902e69ba66ce6so765466wmi.1
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 12:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3CgX7VXHng53Ij6T0dwdhCdn3NWcuyr9E3R+W1ROJUc=;
        b=SRTy+qRZ4okj+YR+L7y+yRp+w625OlzcCAMX7JmD4CEjAYFadAOWSFlhycbgr2goen
         R4wuAhWwURGYWKFz5efOghIc+rQRbyKQXtj+LMn9TLTlLDyK9MfH5iGwelgpwa5PAtkb
         U0zIa0JcgTJoQonPeqORASS7+hz9nfqjC/AZWX3nn5nGxHGa3XQ8B0VaALCDIq0bHo6r
         0YTHlN+cQdsX6EClun6WIFV+cfS21FZhBAUEc6nQRKSBVCVskCuhlLrWw60Yi9e09VXA
         j9ZLHUudjhYHqQRTzYgjINZqr3i7oDLctgjjsrX7efdyodhWHQvSC0ICwEB/sDD4iRbZ
         8PNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3CgX7VXHng53Ij6T0dwdhCdn3NWcuyr9E3R+W1ROJUc=;
        b=Y1zd0NBazLL5LxH5xhNJ/NfeLPLbkhE5iswb0CzSziH2vUKGJqEkpFvUbYfVOCYk6s
         wZUyDZthNGWin91XnEHOetPUaFHgG038Fpv1wn8cwtndiAwuX9POLEZ1XU02o63Pp1SL
         EETRlvUoSRtR9XMUK/LqftwiVJEZQeLaf6ggD4+3VHnfAiukk87m+bgTNlUOm7/ztlPG
         oT7mfxLA5dYGi5cwzawTRuO6xFT64TNuxkyIaaj2HeYV2iddET5oJt7EpY6ah+r35wPt
         itOt5CVm2BlzpZTE54F/ap+fPSMHJVkXJePQ3vqNxOOTZkN86pw7Z5FxGP0d81F+5tRw
         TOsg==
X-Gm-Message-State: AOAM532peHL1rE3UxroGQbva6Xqh1us1cygW5PLOTdFi5V47J5Q0ezpk
        TBQyRo8c8tvqTDfHMOIayVM=
X-Google-Smtp-Source: ABdhPJyUcOnkgVrWvdJXnOEjpxjT8WxoGfjhb0mBQWxxx63f96apzuUAmO3K9ZMTeYQYa/eg/LKG/g==
X-Received: by 2002:a05:600c:350c:: with SMTP id h12mr14078521wmq.17.1628536735031;
        Mon, 09 Aug 2021 12:18:55 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id h11sm13283074wrq.64.2021.08.09.12.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 12:18:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 7/7] io_uring: inline io_poll_remove_waitqs
Date:   Mon,  9 Aug 2021 20:18:13 +0100
Message-Id: <2f1a91a19ffcd591531dc4c61e2f11c64a2d6a6d.1628536684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628536684.git.asml.silence@gmail.com>
References: <cover.1628536684.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_poll_remove_waitqs() into its only user and clean it up.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 56ac7ded1615..fecd65cb23e9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1058,7 +1058,6 @@ static void io_rsrc_put_work(struct work_struct *work);
 
 static void io_req_task_queue(struct io_kiocb *req);
 static void io_submit_flush_completions(struct io_ring_ctx *ctx);
-static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
@@ -5246,34 +5245,24 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 	return do_complete;
 }
 
-static bool io_poll_remove_waitqs(struct io_kiocb *req)
+static bool io_poll_remove_one(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
+	int refs;
 	bool do_complete;
 
 	io_poll_remove_double(req);
 	do_complete = __io_poll_remove_one(req, io_poll_get_single(req), true);
 
-	if (req->opcode != IORING_OP_POLL_ADD && do_complete) {
-		/* non-poll requests have submit ref still */
-		req_ref_put(req);
-	}
-	return do_complete;
-}
-
-static bool io_poll_remove_one(struct io_kiocb *req)
-	__must_hold(&req->ctx->completion_lock)
-{
-	bool do_complete;
-
-	do_complete = io_poll_remove_waitqs(req);
 	if (do_complete) {
 		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
 		io_commit_cqring(req->ctx);
 		req_set_fail(req);
-		io_put_req_deferred(req, 1);
-	}
 
+		/* non-poll requests have submit ref still */
+		refs = 1 + (req->opcode != IORING_OP_POLL_ADD);
+		io_put_req_deferred(req, refs);
+	}
 	return do_complete;
 }
 
-- 
2.32.0

