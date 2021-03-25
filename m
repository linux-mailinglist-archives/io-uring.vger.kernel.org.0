Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62434349993
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 19:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCYShA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 14:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhCYSgz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 14:36:55 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87C4C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:36:54 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id z6-20020a1c4c060000b029010f13694ba2so1724181wmf.5
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=STyFoEgLIZV4llLCtR7i3VRhGyBGcvRof1jll8munYc=;
        b=X7II6t7Nzdp9/DzHLbmS9uLXpSAyVqyXTvLDeDnqSWRdjwuCHWTG9pwsRN5SWfBVqb
         YiYqOaESTjBdgWT2yTZYfb+NxlR2s0fKoVwjpHg/7vVxRr1gWjQ00HnQ5pkb7zmqrbXb
         EYd0vKWhiLQNVbA7H1/Usju9omZn4kyudE2bwv8258pgsLNFT3myWpW2pwtOUXhO9yLv
         qKZHcejNeJwHzhWJa8PSwrelxr3plOsMHUbfdInNqQkHh81EX6i8g7d6qWeI8mqUdOY1
         hnA3J+99pr9lGTQG7vg2cSpbXXs8Klrc4j0S/hndeon0FSK8BEzOUFt2tsVgTPhc2UJB
         0tMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=STyFoEgLIZV4llLCtR7i3VRhGyBGcvRof1jll8munYc=;
        b=dbhYB9ehuT5FFMOrlJxvxmzbwBpWQkwJQOPQeyianmAkSe30Dos6dJIxsIdEMfgMS8
         zc23MPaT0D/N9+52OZZ5bJ4rWMNpy85KnDY9gVKIVoREZhy+A7QbhlapSRZPxlt0/NLS
         KvnetsYsFWYguupIB8IJKAsA5BjbnRiKnIsABrmiskvz7ezsokaugVFAzCEwaeCnKuns
         RIKRiFkIumpX+Nog8K2z8h5ac5L1Xcq7V5HOCvSRw12RTPnwj5ngO7MkkmmwZCFdzI0o
         MNvbGu9eiw5UE6R7z5aFuMbSKvxFp5n9nmMRqz85jhSfcYTVDs2Jm2wAhwmsQsW3W5j3
         3CXQ==
X-Gm-Message-State: AOAM532pZq8opvIaPidGCeG3bSByESwzuPIjqp+lYHovg/suWG0vgCf+
        Dxp1RMcTP7tQHvbxPFK7dUVxeLTzwyIQ+w==
X-Google-Smtp-Source: ABdhPJxi6gEFy1P+X6wi5efNrWvma9c/nbaBc37oDDtOL+3p+NkhrelTMbPQ8pPuVcbfxzzLWGlgDw==
X-Received: by 2002:a7b:c087:: with SMTP id r7mr9386513wmh.110.1616697413380;
        Thu, 25 Mar 2021 11:36:53 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id p27sm7876828wmi.12.2021.03.25.11.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:36:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: fix timeout cancel return code
Date:   Thu, 25 Mar 2021 18:32:42 +0000
Message-Id: <7b0ad1065e3bd1994722702bd0ba9e7bc9b0683b.1616696997.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616696997.git.asml.silence@gmail.com>
References: <cover.1616696997.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we cancel a timeout we should emit a sensible return code, like
-ECANCELED but not 0, otherwise it may trick users.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8c5789b96dbb..e4861095c4a7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1248,7 +1248,7 @@ static void io_queue_async_work(struct io_kiocb *req)
 		io_queue_linked_timeout(link);
 }
 
-static void io_kill_timeout(struct io_kiocb *req)
+static void io_kill_timeout(struct io_kiocb *req, int status)
 {
 	struct io_timeout_data *io = req->async_data;
 	int ret;
@@ -1258,7 +1258,7 @@ static void io_kill_timeout(struct io_kiocb *req)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_cqring_fill_event(req, 0);
+		io_cqring_fill_event(req, status);
 		io_put_req_deferred(req, 1);
 	}
 }
@@ -1275,7 +1275,7 @@ static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
 		if (io_match_task(req, tsk, files)) {
-			io_kill_timeout(req);
+			io_kill_timeout(req, -ECANCELED);
 			canceled++;
 		}
 	}
@@ -1327,7 +1327,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 			break;
 
 		list_del_init(&req->timeout.list);
-		io_kill_timeout(req);
+		io_kill_timeout(req, 0);
 	} while (!list_empty(&ctx->timeout_list));
 
 	ctx->cq_last_tm_flush = seq;
-- 
2.24.0

