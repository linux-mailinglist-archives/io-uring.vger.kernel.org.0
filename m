Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A092961CD
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 17:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901462AbgJVPlf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 11:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504625AbgJVPlf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 11:41:35 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA23FC0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:41:34 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 13so2633030wmf.0
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ItfjANS0H1xZcVvgNJduTvl7BpBcDZrBT5tEdOHCQD8=;
        b=H5stjY3THbWtSJ//QNeWTSBTST7oCvHwPhU8cM/is9Oo5I02bUuF6FVU/WBWUjDOul
         k34HR6Pa3p2TUk/kAz99LD85w9nxgMGk/oJN2kH/TU9Bhr/2d9oOiMACoi30ERUKXlKh
         rcIDbsyo78evujvU4vfe8LQO2qM5PZPK0cAJGe7MF68aliP3XIQeWjbzWc3MOPOvB/Yi
         rMM765lxmoJYOkb+xlfjU4D17i4Mu7QYEj+hwIY0KGJKLCbWx7xfU5e5ggPz0z179pYw
         7H3KrWx1czppGswA6d6Dz6HaCZWs1RLsqpRfyN0VqEWiMfIMaNPI4hBPCxu+qeUSDuJ5
         0G2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ItfjANS0H1xZcVvgNJduTvl7BpBcDZrBT5tEdOHCQD8=;
        b=nbq3ECKHFFGGgqo+mJlvsnxmRn/4MrTO/csM+VNjuF32bqvGjuHF/Wh4+puIT1JPrW
         3fb44yDGJff0osQMYGs3WbiML5Irj11VhLyw8JhjIBKewzom8+igsgco8XSBjPrZmOZo
         EI+QyxnDQi8UPQYwOuv7dml5UljiWfWZuzKkVy1RLsUfaAJbO2zM2qTOhwMcUFHBGhDi
         PAR2XxnTy8XfE5PzvD9Ua3mzCTGvoeCEF9BGov4QTuki9LkQ18eSCvcsT1qN4/Vzc7kG
         9VqkuxkKvUdlDGfH3drRCJEmw0oqQzj3YaftQYvlneZPcV2PL5Znv/c0AFJFd6WufEoL
         BatQ==
X-Gm-Message-State: AOAM533Die/tUOabiwR5POY/UaVJp5UlXBtsZi7ncdLYpIe4KwzPagj8
        Eo7DmSp+ddQHWKLiV58RDSU=
X-Google-Smtp-Source: ABdhPJySRi7e/hGc+kYYqUh3vZKfO0B7Z84+vwKLK1GnLgvPCJN4jG7vo81cu8ca+DQFlTtiprYfgg==
X-Received: by 2002:a7b:cb98:: with SMTP id m24mr3327634wmi.133.1603381293656;
        Thu, 22 Oct 2020 08:41:33 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id x21sm3922990wmi.3.2020.10.22.08.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 08:41:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2] io_uring: remove req cancel in ->flush()
Date:   Thu, 22 Oct 2020 16:38:27 +0100
Message-Id: <6cffe73a8a44084289ac792e7b152e01498ea1ef.1603380957.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Every close(io_uring) causes cancellation of all inflight requests
carrying ->files. That's not nice but was neccessary up until recently.
Now task->files removal is handled in the core code, so that part of
flush can be removed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
v2: move exiting checks into io_uring_attempt_task_drop() (Jens)
    remove not needed __io_uring_attempt_task_drop()

 fs/io_uring.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 754363ff3ad6..29170bbdd708 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8668,19 +8668,11 @@ static void io_uring_del_task_file(struct file *file)
 		fput(file);
 }
 
-static void __io_uring_attempt_task_drop(struct file *file)
-{
-	struct file *old = xa_load(&current->io_uring->xa, (unsigned long)file);
-
-	if (old == file)
-		io_uring_del_task_file(file);
-}
-
 /*
  * Drop task note for this file if we're the only ones that hold it after
  * pending fput()
  */
-static void io_uring_attempt_task_drop(struct file *file, bool exiting)
+static void io_uring_attempt_task_drop(struct file *file)
 {
 	if (!current->io_uring)
 		return;
@@ -8688,10 +8680,9 @@ static void io_uring_attempt_task_drop(struct file *file, bool exiting)
 	 * fput() is pending, will be 2 if the only other ref is our potential
 	 * task file note. If the task is exiting, drop regardless of count.
 	 */
-	if (!exiting && atomic_long_read(&file->f_count) != 2)
-		return;
-
-	__io_uring_attempt_task_drop(file);
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING) ||
+	    atomic_long_read(&file->f_count) == 2)
+		io_uring_del_task_file(file);
 }
 
 void __io_uring_files_cancel(struct files_struct *files)
@@ -8749,16 +8740,7 @@ void __io_uring_task_cancel(void)
 
 static int io_uring_flush(struct file *file, void *data)
 {
-	struct io_ring_ctx *ctx = file->private_data;
-
-	/*
-	 * If the task is going away, cancel work it may have pending
-	 */
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
-		data = NULL;
-
-	io_uring_cancel_task_requests(ctx, data);
-	io_uring_attempt_task_drop(file, !data);
+	io_uring_attempt_task_drop(file);
 	return 0;
 }
 
-- 
2.24.0

