Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F45F2C36BB
	for <lists+io-uring@lfdr.de>; Wed, 25 Nov 2020 03:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgKYCWo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Nov 2020 21:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgKYCWn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Nov 2020 21:22:43 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14AFC0613D4
        for <io-uring@vger.kernel.org>; Tue, 24 Nov 2020 18:22:43 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 64so355353wra.11
        for <io-uring@vger.kernel.org>; Tue, 24 Nov 2020 18:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/64Ryqc4MZUFtYOlpAUcq5/xKenaNZyR3LHqLnz8aIQ=;
        b=XXnQp3pf9nhtL4FdCBirWTPRdrfqkQ1LTPy7pot3eeFT/ncrbnfFCJGk3XmaZh+B/R
         NrsnFks4bCYWAyneSHijPqP7tWfuP5CBC42iyufmwN0KTqrG1siUlK0K9gO4iIkld8+R
         KSfk0Kn2BOpyF0myTbvevUmHAlvdavIdsOM2snS+c5rS9ki3a0nM+pzPabUsixBVhgXK
         3+r8sYeQ4s5Kzz9ok5Dfn7Evcp+dQwGnj1SphkldhlUMOzNcshWVyfkskd2/7TTshXra
         sbYoZMdkn2sR0y8RDgRo0ss1616iK8QwOWsMq6OvCXCHP4W9N+NkXRMw41qCQ5Flgsjw
         8b0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/64Ryqc4MZUFtYOlpAUcq5/xKenaNZyR3LHqLnz8aIQ=;
        b=NOaMB8JjDG125me84majidHy5QL+ejX3S+GDy0LfJ4zlv4TYyubufefyv5G4/BU9nR
         oYykrQ9BrWZzsBUXUEpN/6mqIP0lvSc4Ngb2ovrUapbKU4HK1cRCuXesJ5hvhuSTDcHs
         SJwgTu2ag/cq/pYBHMWQpyWj/yUY4nTWuYXjoT9ZlOeFAAn5zYUyLLRTsuZuZF+EOX6M
         p27U07i7eT5gIV8wcabgbL2fCDHEyvPbTP8UU/5Shcc0EECDCRXF1nNUqIwqpnfLv/OF
         tnQzLkJXjhHn1ePpcsU0dnTJuM7K+X1teMbpPJ7AMnnyqFFgIjNDXZIjQET4mmlocWA/
         o3Mg==
X-Gm-Message-State: AOAM533A9QaVh0N/JSHmKjwbNC2wvdwjBPaEju9aYNYlKrHfQ1kyko1u
        5qIV8/Qd8Cy6z2ndkAJeKsi/bzTfzdSEEw==
X-Google-Smtp-Source: ABdhPJyQt8BIns4WTjtpG0skCr07zMVnqC5zBwfhgnow0Ag6tJTZHKhkClBZOgl0UqRUu7RSM31y5Q==
X-Received: by 2002:a5d:504f:: with SMTP id h15mr1380477wrt.402.1606270962355;
        Tue, 24 Nov 2020 18:22:42 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id h2sm1538943wrv.76.2020.11.24.18.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 18:22:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com
Subject: [PATCH 5.11] io_uring: fix files cancellation
Date:   Wed, 25 Nov 2020 02:19:23 +0000
Message-Id: <5c8308053ac64d0fc7df3610b4b05ac4ba1c6d2b.1606270482.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_cancel_files()'s task check condition mistakenly got flipped.

1. There can't be a request in the inflight list without
IO_WQ_WORK_FILES, kill this check to keep the whole condition simpler.
2. Also, don't call the function for files==NULL to not do such a check,
all that staff is already handled well by its counter part,
__io_uring_cancel_task_requests().

With that just flip the task check.

Also, it iowq-cancels all request of current task there, don't forget to
set right ->files into struct io_task_cancel.

Reported-by: syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com
Fixes: c1973b38bf639 ("io_uring: cancel only requests of current task")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7c1f255807f5..f11dc25d975c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8725,15 +8725,14 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
 	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_task_cancel cancel = { .task = task, .files = NULL, };
+		struct io_task_cancel cancel = { .task = task, .files = files };
 		struct io_kiocb *req;
 		DEFINE_WAIT(wait);
 		bool found = false;
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (req->task == task &&
-			    (req->work.flags & IO_WQ_WORK_FILES) &&
+			if (req->task != task ||
 			    req->work.identity->files != files)
 				continue;
 			found = true;
@@ -8805,10 +8804,11 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
-	io_uring_cancel_files(ctx, task, files);
 
 	if (!files)
 		__io_uring_cancel_task_requests(ctx, task);
+	else
+		io_uring_cancel_files(ctx, task, files);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);
-- 
2.24.0

