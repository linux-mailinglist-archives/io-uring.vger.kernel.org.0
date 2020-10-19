Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22443292AD0
	for <lists+io-uring@lfdr.de>; Mon, 19 Oct 2020 17:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgJSPtC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Oct 2020 11:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730051AbgJSPtC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Oct 2020 11:49:02 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5553C0613CE
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 08:49:00 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e17so226358wru.12
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 08:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5T81z/3cAm80o4UwKPOrmzs5r7IMXl4VQfCj9124BXA=;
        b=SxbBK69OMdX2oDQ9fT3+UNflO6a0mPBDPVKgjdBRYMKnDwTdMO+XFclya27YdFjxaB
         SVDBOZ05+HtmP4j1nO3pYBJzuztlGgl1xaKM0yEGtAXVyLcPOsV9yj0CK4LAzLIVEUe9
         3eCuUXoKZ8wNs9DAvdB8egU+0yR4t3PDiVQIzlLBTxHtMajzruu4Vx4KwrRCqTtAw5ay
         7ggM4BKuPsEH1kvj2VSPMxjMS2al54EKPsnteAuN4qPgfLp016kPcf0SQzonvFnl2nLk
         MP6VReKmf7ghtSHc9+ZAzRew0hL030RtqEMnupolMVROjqTfGbZxp1iE96rGy+S2B5MA
         wDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5T81z/3cAm80o4UwKPOrmzs5r7IMXl4VQfCj9124BXA=;
        b=SDKtqzVT5EZx9JZN6hrk0GJRnLHOC+48oHVhhYTQiCW9Bo0L21lfDbZ8aH/JmWu0LU
         /0QtiRpLg/O0gGue5grmnq/TVfV0G260uAYIWfH5pfs6WPOnnIpYDxD1NZnTA5u+zZLE
         spP9ZWuKOPy6EDQTO1Ff6nYMqWxm99AJVy2VgnqVaYgHfL111EyMZQbj+eUpZNslI6ZO
         QAAQP+6Stlk7AFd/af2+kl02sA6GwCnmYgP4ZyBz023Bi6pqLsIxrvkvZSk/ycVe/aXe
         v7KNT+UJFFplmkWaolW8niY/KornRMbOo+1Bkb4f78e0UPXExbfc6ZE9/ibUydJW1acI
         NmHA==
X-Gm-Message-State: AOAM533hMZYq8ghObtldWqVoOzF5FkOP912GH5E4Y2VwWe8zJaSbSQ/Z
        JYgHjwmCunxrxVhrQ3sUeMahlE+6Ki3sCQ==
X-Google-Smtp-Source: ABdhPJz6biuGI5GSM/pSIzo0DAfDQNbAGwKXwullTJjyugD+igzBJgHA3++U1dD0BzzQ/NXHu6vh4w==
X-Received: by 2002:a5d:6a49:: with SMTP id t9mr198456wrw.194.1603122539668;
        Mon, 19 Oct 2020 08:48:59 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id a15sm115728wrp.90.2020.10.19.08.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 08:48:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-5.10] io_uring: remove req cancel in ->flush()
Date:   Mon, 19 Oct 2020 16:45:54 +0100
Message-Id: <21aca47e03c82a06e4ea1140b328a86d04d1f422.1603122023.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 95d2bb7069c6..6536e24eb44e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8748,16 +8748,12 @@ void __io_uring_task_cancel(void)
 
 static int io_uring_flush(struct file *file, void *data)
 {
-	struct io_ring_ctx *ctx = file->private_data;
+	bool exiting = !data;
 
-	/*
-	 * If the task is going away, cancel work it may have pending
-	 */
 	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
-		data = NULL;
+		exiting = true;
 
-	io_uring_cancel_task_requests(ctx, data);
-	io_uring_attempt_task_drop(file, !data);
+	io_uring_attempt_task_drop(file, exiting);
 	return 0;
 }
 
-- 
2.24.0

