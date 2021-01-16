Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E951A2F8BAB
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 06:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbhAPFgz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 00:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPFgy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 00:36:54 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B93C0613D3
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 21:36:14 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id 91so11298909wrj.7
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 21:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EApnHQR6YnwNYK52Z1b8mbJYIDMalOzZIB0hRAsjcKo=;
        b=k4nqB7HJJsDTGyvRVvlR3urbfJO6H9SjtwoneleVt94+jmhwEvHCM8BoPuqI0ndiCM
         E6/Oa9Z8c8Q1FSpVlfcJrexBXHTcqsZLIb1auM2E4hc6ISjjvrjrjRYfMWH6EkUK/9qv
         qR42XkKVgXYttPeZ0jq71UhxalpWj75nlDj9HFAq+GisZC1SBSaO7xeJOOj31xMvP8LS
         Mq20/DhOOeaeI/tuIVlO3j88FXuVioT0sGMWOdWEOozaLtxYIhl/nSgJu3cnczZB9M0J
         4hf5aAqtIvSLUV6sjr9/myl6SamnuozfP3vtpETKxNO+XeYObMWisSiZ2nhVpfk4ds4L
         SCCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EApnHQR6YnwNYK52Z1b8mbJYIDMalOzZIB0hRAsjcKo=;
        b=Q/zHry/4pqeDwi4azhn1TfhRa0DHKcJxpghi1cnwFyyZktlficb/0aPptF2jDbfVhf
         n2C18qCRhFfb6yQ87Jyl/GSg2VbQn9eUVa9PMIUSFL8GaJycwZkGrMq/OjRjIt89xmXD
         S04BjvPxQCtplZBwpJFgRQv6sfB0m5u8FLT82rtGF2vRYfNo2UZs6pgH8GknzR4Nb+ou
         1jnV7S+pwXngiGg/Q4ZclUDBe18ArvIAN4cmugixrlFoJAiRXcS6s7OYuMMmtAMuojkO
         K3w6VDhVLp9rgjAn3G2FH6dQ9b8PnQJ+ga8B0Z9+rz/X+dQIXvscYk+JWhJg6vsfgq6B
         0mCg==
X-Gm-Message-State: AOAM531I0EfLPwlzuVjTYv106lEeEO6CkXqfUfVtPBCubJUg1wwHAj9E
        s8712zVTCNbixtgJIiSQE0s=
X-Google-Smtp-Source: ABdhPJxllt3d5Z29v28Kx9jpNdCi2XIvF3eePkTWCRNENlHX5pR3/CX/GoI84MNRtd70jDyxKQbALw==
X-Received: by 2002:adf:fa0f:: with SMTP id m15mr16310464wrr.300.1610775373010;
        Fri, 15 Jan 2021 21:36:13 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id b132sm15348373wmh.21.2021.01.15.21.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 21:36:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com
Subject: [PATCH 1/2] io_uring: fix false positive sqo warning on flush
Date:   Sat, 16 Jan 2021 05:32:29 +0000
Message-Id: <99a4178f79b4ac35ce35111bafa0a49446b1757d.1610774936.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610774936.git.asml.silence@gmail.com>
References: <cover.1610774936.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: CPU: 1 PID: 9094 at fs/io_uring.c:8884
	io_disable_sqo_submit+0x106/0x130 fs/io_uring.c:8884
Call Trace:
 io_uring_flush+0x28b/0x3a0 fs/io_uring.c:9099
 filp_close+0xb4/0x170 fs/open.c:1280
 close_fd+0x5c/0x80 fs/file.c:626
 __do_sys_close fs/open.c:1299 [inline]
 __se_sys_close fs/open.c:1297 [inline]
 __x64_sys_close+0x2f/0xa0 fs/open.c:1297
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

io_uring's final close() may be triggered by any task not only the
creator. It's well handled by io_uring_flush() including SQPOLL case,
though a warning in io_disable_sqo_submit() will fallaciously fire by
moving this warning out to the only call site that matters.

Reported-by: syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 06cc79d39586..9a67da50ae25 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8914,8 +8914,6 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
 {
-	WARN_ON_ONCE(ctx->sqo_task != current);
-
 	mutex_lock(&ctx->uring_lock);
 	ctx->sqo_dead = 1;
 	mutex_unlock(&ctx->uring_lock);
@@ -8937,6 +8935,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		/* for SQPOLL only sqo_task has task notes */
+		WARN_ON_ONCE(ctx->sqo_task != current);
 		io_disable_sqo_submit(ctx);
 		task = ctx->sq_data->thread;
 		atomic_inc(&task->io_uring->in_idle);
-- 
2.24.0

