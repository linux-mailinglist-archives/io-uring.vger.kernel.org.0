Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E98E3E4539
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbhHIMFf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbhHIMFd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:33 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D9FC061796
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:13 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h14so21061980wrx.10
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=d/ainzYIqr2AEsDsFByo+OJGXjhLoeYNzhpdZyqP+IM=;
        b=Glw/TzigX/7aJLvmYdHXvIu/ohVTW1h/pCodi+qfiGqqsFkJGTNyILISCXcxKwR1D7
         EFp3v0kzgLZOVN91jgaSbKQUAg3DF7VaCfWOouwuQeUxYWAIAtBH7h8Tej9/QwgRvPFw
         VPBP31ABxEsWu5Rre/03/wgdZju6FuaNMNqaowdl03ZdxPLnNW/OKZ9tg216iGc3B0o6
         MZRrFjzzLicDvXVWFxhwMdmRIAP7ycWOg6dw//gXi79HyMHlMIiS+LUvm89g7e3n5oaH
         GB1aKcAtw0cTSX/eydk3dUfh9nxqGvWs4AZjWn8LFudrzlX4gUaC4kTbO8VP23gEWh3q
         lE9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d/ainzYIqr2AEsDsFByo+OJGXjhLoeYNzhpdZyqP+IM=;
        b=AzskzC8+NoBev6OFBXwGaklRETG5K1ePUXIboXzZ0Pzwarp/lucrrQuD3RjL3FA4JP
         Mi5WwyGKmECOuzkwnHumm4eb9wgzcARAlx3nxewjkUAxQ0YARh5cRnph8g1JTuxrl396
         jrJBn92qVw7alMjiYLWE1hNSauci6waGg74SdxuIolloKLSYMxZfC9inz/FuCwzRPyth
         vP+OO9xEAiiM3naJlWTbN2FoEoJSYVrgr7BMcZe036idvjQ9iPt05hwbbKSb70EGonGB
         PbBRzlmOcmou+IqYohxCUXOLPUujNG8MXhMc3zQXIB9LXuHCAOHGgXjhTU+21zycYNYk
         1urA==
X-Gm-Message-State: AOAM532ibSLNLsJ7W/5eOkG7i0uLQ5Td85VobLjTRnTrYrX1dKH96p5d
        CAkqfe8NbaksGHtqt2v1fD8=
X-Google-Smtp-Source: ABdhPJwLST3ZNl2Nvubn9l1tSSpK55+wbT5kA5L4x2Hfm0h5upYpK4eJJhvpbItX0JV7uOF6alR+Og==
X-Received: by 2002:adf:cd92:: with SMTP id q18mr25033063wrj.18.1628510711885;
        Mon, 09 Aug 2021 05:05:11 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/28] io_uring: don't halt iopoll too early
Date:   Mon,  9 Aug 2021 13:04:09 +0100
Message-Id: <641a88f751623b6758303b3171f0a4141f06726e.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
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
index 80d7f79db911..911a223a90e1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2285,7 +2285,6 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
 	bool spin;
-	int ret;
 
 	/*
 	 * Only spin for completions if we don't have multiple devices hanging
@@ -2293,9 +2292,9 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	 */
 	spin = !ctx->poll_multi_queue && *nr_events < min;
 
-	ret = 0;
 	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, inflight_entry) {
 		struct kiocb *kiocb = &req->rw.kiocb;
+		int ret;
 
 		/*
 		 * Move completed and retryable entries to our local lists.
@@ -2310,22 +2309,20 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
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

