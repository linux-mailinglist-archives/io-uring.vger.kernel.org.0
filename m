Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCBD250A1E
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 22:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgHXUiM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 16:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgHXUiJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 16:38:09 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8701CC061755
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 13:38:09 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l2so7588980eji.3
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 13:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=udbXB0cqc6FeDI1dwpJcz5FAtXPFWwVOxIeJtbziwu4=;
        b=kP1KO/MrCa/hXCjusNYPsIbZ2h2/ZHMj68ZOJha1in6PLt6VVZ0z6lRUfHGCs6Q9Re
         aOc2WgzEaDkqq561RYtU7YLHwFrUl4/sOMJYo1PC2JFW65ri8hZHj3RHn5LJ/EUWZCbM
         +vb100ubsK6Mk5ULOLX5Q5rjbVbzCXx0zH3rnCnOMKvWG0RCf6o7koHdSLSSHPn3ZzyO
         wDd99Ce4JOQTrgpJDtHr3bwJ/90CPbA2gCeB994n0SboNSrrVS6YAmT42UNHqbtc2s+h
         ucVuJtaXTJ7jqk0zueZCdmD6KAMCbUYEtRoMRD28geeScXrz9WePzaZJtqWCoEI1Kkqu
         rmLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=udbXB0cqc6FeDI1dwpJcz5FAtXPFWwVOxIeJtbziwu4=;
        b=pE5MQ6Y2VezKe5Y6S5XYqVgWV65M8EbHK19G3klq2biH4EN+OPSNCkZ0LYKUYy9GNw
         4yjKVeuNeJpefF6jk268sn+XzEiMJY8+WvbTeb4cIF2rJWbnaeEqLoFA9QpLorH7cmqm
         JKYupffA/OuUTqyAyWZ5p+GUB5WM6NnVFqa21jnywP9iMP6SXmpKdZ+lpHPiizgIv4L/
         ksHuIxAKi8pacZjaUW4gSxpslAGf6yerTTirhD7hbBzbmDNfk5JdsI1Iu0f/FAOa7M6P
         Eyye6B7QsRBmE48YC07CBhnplwjmZzT9XgVp31VqIjc9HN8oYsyjJxsmNyJKhjY56gFF
         vImA==
X-Gm-Message-State: AOAM532mQ9mCzrpigVjp3/ehtXC5rsw1YJrHckGULlZolXUl4EMPYD9K
        512aCAudXeRtIOO9X35IjHo=
X-Google-Smtp-Source: ABdhPJwhNkGoZJapFTusRnFM0Y5MdEHFBGpABfmQd7Gzi9ATUKIj9ifxqN9QSRXBJ/rsndR6/qVGHw==
X-Received: by 2002:a17:907:72c8:: with SMTP id du8mr7076289ejc.237.1598301488242;
        Mon, 24 Aug 2020 13:38:08 -0700 (PDT)
Received: from localhost.localdomain ([5.100.192.234])
        by smtp.gmail.com with ESMTPSA id y4sm2345538ejj.30.2020.08.24.13.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 13:38:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.8] io_uring: fix missing ->mm on exit
Date:   Mon, 24 Aug 2020 23:35:36 +0300
Message-Id: <25db35fc25aa7111f67a6747b1281c5151432f8f.1598300802.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

do_exit() first drops current->mm and then runs task_work, from where
io_sq_thread_acquire_mm() would try to set mm for a user dying process.

[  208.004249] WARNING: CPU: 2 PID: 1854 at
	kernel/kthread.c:1238 kthread_use_mm+0x244/0x270
[  208.004287]  kthread_use_mm+0x244/0x270
[  208.004288]  io_sq_thread_acquire_mm.part.0+0x54/0x80
[  208.004290]  io_async_task_func+0x258/0x2ac
[  208.004291]  task_work_run+0xc8/0x210
[  208.004294]  do_exit+0x1b8/0x430
[  208.004295]  do_group_exit+0x44/0xac
[  208.004296]  get_signal+0x164/0x69c
[  208.004298]  do_signal+0x94/0x1d0
[  208.004299]  do_notify_resume+0x18c/0x340
[  208.004300]  work_pending+0x8/0x3d4

Reported-by: Roman Gershman <>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 493e5047e67c..a8b3a608c553 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4313,7 +4313,8 @@ static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
 				   struct io_kiocb *req)
 {
 	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
-		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
+		if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL) ||
+			     !mmget_not_zero(ctx->sqo_mm)))
 			return -EFAULT;
 		kthread_use_mm(ctx->sqo_mm);
 	}
-- 
2.24.0

