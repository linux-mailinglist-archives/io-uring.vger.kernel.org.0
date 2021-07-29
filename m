Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07263DA712
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhG2PGc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237560AbhG2PGc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:32 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED431C0613CF
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:27 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id u15so3946933wmj.1
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MmzlOfOpIlY8BtwZTLeC1bRtLIx2vKVF0F0iLfFWmTw=;
        b=HYg8nfpRy5AmbyAiyvPyWk2X3v6HNW0tbPsZwsBrleVVPrZQI4OCLuZZc3+on49hmk
         E/11IqfkfTWWX//NT4zCZ9E72g+fPdpSqH/x8Ikoe6ARq9W2EXKFj7hYe30xfd9N08va
         ye2lzWopwHdRmnKM4CmwnKca/TgtB11veoEICPaBomY2ZnKL6Kg8+pw9oViGYQ63mBvY
         Twn0QtdKD35jNxI3l69FI/0/9hFYPzW32RqaEwl/B7+L/iR/RxXjNSj4+HS5s/jR/Qpd
         9ORmDDIKzCnJf1+geuOWjcIH6eOtHW0l/l5Jlz0Na6VQbbli5n7QpHB+5bR23vzxWret
         vBqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MmzlOfOpIlY8BtwZTLeC1bRtLIx2vKVF0F0iLfFWmTw=;
        b=Z0dylPV14os3YOBksdq5MNFJ35bQc+0dmTW85Q7xfTc89VHxLJk3sBhaZyF4JUz8H2
         9J1aWPoBJ/MKqO7+2KVo1+fGlNfPeifTRqpTV5RMUcz7SfsJT3xOr0GlGE9RHlDwFmMF
         YlT2v6NcrzTesfSNu/CxhBBA9VwI9TVNKW47ZjWUZ6sDOlzTK2RCWsf5sgm2Bl4efH+D
         vESBF8TeqKX5hHu+wXjwfanKPy7Ag/MsiY3yL8Ucg/p3ofZqZvom29y7y3EEi9z0n200
         AAFM6qOkkpZ9XWL3Kzai6BCwL8euDGvp9pj2DbZth+saVPu61etHrMgiyJnoDpiU4yR9
         5s1g==
X-Gm-Message-State: AOAM531c4m1u0ay66LsuOZJ0N9GgI7aURz76ZSddmBz5qjIgdbDObULD
        o0Y+BAdwIYqn7uDz/y8UNm4=
X-Google-Smtp-Source: ABdhPJz7r/HeiWZL3S0c2FLcRzcI9y4Fci472EZBsnUCXAmjQ6F0yibp8xKIhQJH9zfC+0J+GtQicQ==
X-Received: by 2002:a7b:c1d8:: with SMTP id a24mr13229475wmj.155.1627571186565;
        Thu, 29 Jul 2021 08:06:26 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/23] io_uring: don't halt iopoll too early
Date:   Thu, 29 Jul 2021 16:05:31 +0100
Message-Id: <1374e437cb34e758d048d34f615b24be219b6faa.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IOPOLL users should care more about getting completions for requests
they submitted, but not in "device did/completed something". Currently,
io_do_iopoll() may return a positive number, which will instruct
io_iopoll_check() to break the loop and end the syscall, even if there
is not enough CQEs or none at all.

Don't return positive numbers, so io_iopoll_check() exits only when it
gets an actual error, need reschedule or got enough CQEs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6dca33fdb012..87d9a5d54464 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2276,7 +2276,6 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
 	bool spin;
-	int ret;
 
 	/*
 	 * Only spin for completions if we don't have multiple devices hanging
@@ -2284,9 +2283,9 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	 */
 	spin = !ctx->poll_multi_queue && *nr_events < min;
 
-	ret = 0;
 	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, inflight_entry) {
 		struct kiocb *kiocb = &req->rw.kiocb;
+		int ret;
 
 		/*
 		 * Move completed and retryable entries to our local lists.
@@ -2301,22 +2300,20 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 			break;
 
 		ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
-		if (ret < 0)
-			break;
+		if (unlikely(ret < 0))
+			return ret;
+		else if (ret)
+			spin = false;
 
 		/* iopoll may have completed current req */
 		if (READ_ONCE(req->iopoll_completed))
 			list_move_tail(&req->inflight_entry, &done);
-
-		if (ret && spin)
-			spin = false;
-		ret = 0;
 	}
 
 	if (!list_empty(&done))
 		io_iopoll_complete(ctx, nr_events, &done, resubmit);
 
-	return ret;
+	return 0;
 }
 
 /*
-- 
2.32.0

