Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E5F40C415
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 13:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhIOLGV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 07:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbhIOLGV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 07:06:21 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB702C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 04:05:02 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id w29so3211710wra.8
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 04:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GSn5bVYw+bdxN+Baum6A+bIQeYJFS0/094pVNh4FOF8=;
        b=dY0iTSAhqpsJ/Mz1b3l34lrqU8GM2QrtnuZ7Kiu2lVCATHJF4EAv8YLnWhVrv/+lW2
         Pc9+z9r7m1VKvOq6V9xUvt8wGBSLmUd6WGCJ3Ls3AdKzv3TO2EPoGeeovdKocG5BvSyO
         pqTAnWzGIio8dtqyM8DlkCr4K1GdjeUX2hjCcbOa0X9UJ5VBeFyMp3MKC/uaz5YnJoIY
         CUyc9PBVAJW2LIk5e3gEom9jXyij5HArZU2J4Al5h8G3CwnJ+jf2T5JTLTLrNV0g6u2J
         Bm17tAtVf7dRNMJPxOYnCe/3BQ+MhCXRFnNkniWtBruiE3cu90y66JxH9ZX+YRw/LLHr
         EsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GSn5bVYw+bdxN+Baum6A+bIQeYJFS0/094pVNh4FOF8=;
        b=VwOb10iC3DoOQneXXIWy9VE1XeH5ltJDnT92LWGq8YRqT+9rQYoSG0L6/MQATiLSMq
         z60wnDkB+beaBK8mrr0t2AK0aS8UvptMB/7s9yKrFimsm9T4P38hiOQSEPYyCz55j0ig
         gYz76VdQMxr2tXnePPhqvVNrbT1KASepSfOI+60Cby2u4xeK2w0VDMUu9SYARU7S5k68
         sELgLJRLRtWiVc/7fL3qvaK52/rCQ/34G8p5lMgAniYV9h8IUt2GWsGbUDyxCfLIiVlf
         DvAPBx9BCdidKVdhlnrt5R5IGRHd4RI2YMHQKkA+c9LjpqmtrXnLGXXLwyUUAMtcDDwn
         CyyQ==
X-Gm-Message-State: AOAM532kt7UZSWHzdfkvG03yC3u2Ow5QFAlUGieJlwk7Ei07bSU//an0
        hAIS2UTB3KxwPKXV1I8/H47rGBDM8iw=
X-Google-Smtp-Source: ABdhPJzgpU3VJOsjw+6f7pcxI465LZ2FkvEGjBjF4ZqKZ/9ZSrrhPOXiNd0ZCHq8gu7zHdNQq6IiBw==
X-Received: by 2002:a5d:4f91:: with SMTP id d17mr4325087wru.285.1631703901190;
        Wed, 15 Sep 2021 04:05:01 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.239])
        by smtp.gmail.com with ESMTPSA id z7sm16608753wre.72.2021.09.15.04.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 04:05:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next] io_uring: remove ctx referencing from complete_post
Date:   Wed, 15 Sep 2021 12:04:20 +0100
Message-Id: <60a0e96434c16ab4fe587651448290d61ec9a113.1631703756.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now completions are done from task context, that means that it's either
the task itself, task_work or io-wq worker. In all those cases the ctx
will be staying alive by mutexing, explicit referencing or req
references by iowq. Remove extra ctx pinning from
io_req_complete_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 511fb8052ae9..c23f3218d52b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1816,17 +1816,11 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		io_put_task(req->task, 1);
 		list_add(&req->inflight_entry, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
-	} else {
-		if (!percpu_ref_tryget(&ctx->refs))
-			req = NULL;
+		percpu_ref_put(&ctx->refs);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
-
-	if (req) {
-		io_cqring_ev_posted(ctx);
-		percpu_ref_put(&ctx->refs);
-	}
+	io_cqring_ev_posted(ctx);
 }
 
 static inline bool io_req_needs_clean(struct io_kiocb *req)
-- 
2.33.0

