Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDFC3274E8
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhB1WkC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhB1WkB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:40:01 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B1DC061756
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:20 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id v15so14155228wrx.4
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WTt3VON7ZDqi7ORckSotybVdbRRKseSnldK2UkY0ttc=;
        b=p9mrmX6j6Mh4hk9TDowijKahVaHLsM43L518EStTLxYz3gGz+rw7i66ZFWC4BdsZzd
         uNhVJbxFKSXYyMUVmn365N4NK5NylQpNxri0TuobLNP/cKgRdcfd88ZQDG3McaOiT9dz
         wPxivo0tWJ5o4Qf9nwmaMWrcgLC0oNYPOcWqqjoXbgr61RcfHCHMKQYa9D6JD7RAVVvY
         Q2IDJjpJQ5hhiBEyeNHj1fhqGr9ZAkac7iwgzRZqtYq0Y+SRhrE6900b8oZ3K98Ev3J3
         Jr6Resnb9TxSceku9/Bj35ZZtB8A5u378BTZHIZK57qqUFpOP7+GGCDAuArlD7Y26g6k
         LdDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WTt3VON7ZDqi7ORckSotybVdbRRKseSnldK2UkY0ttc=;
        b=cnKr366mLuVRnYryqT7iR6kE43V5xmhCmgitHIdydzevxS7cOu8C9N27sp0alOFV97
         YPgugc6/l5mEtbeMm7vYdsUBerMxPtOWnU/Q8l6fK0ymKLq67F6kfSWHkElD6KWt0ESw
         nxdYj9EaJSDJ0/qqR5e5nVbIZqd88G4mM0JRLfNSSh1cdRE2piTjz0tJ1iZmGrSxmf0J
         /dz4mtOFq83nfGX/J+eUtJnmECOx/Khh1Jd8uMssLcqwiWUNXNHGhAG+c+xu1YV1zLUf
         9BPiqgZLGcm/lPRK4mfQqERhQl5hucc2vD3aOGAZuDR5zWnhai3/oI7Lf9Y5uYt4boIQ
         OCbQ==
X-Gm-Message-State: AOAM530Hc7Ko7reP9r3+vlVXk3Rjd3I0yPzcZPMVsScGBAkuayti9QPs
        9e/r+O4hp9Mcei8w/+L89sw=
X-Google-Smtp-Source: ABdhPJzv/k+v8lifYSgtABuPVjZy8RopPnhQcjMvzNCAlFji2ABmU0sKm7GAyFgBxuEfoEKJjVoUQg==
X-Received: by 2002:adf:9bca:: with SMTP id e10mr13787214wrc.364.1614551959603;
        Sun, 28 Feb 2021 14:39:19 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id y62sm22832576wmy.9.2021.02.28.14.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:39:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/12] io_uring: avoid taking ctx refs for task-cancel
Date:   Sun, 28 Feb 2021 22:35:09 +0000
Message-Id: <b1fd100a7940e9d2eb96de0bc559a59685bd4d4c.1614551467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614551467.git.asml.silence@gmail.com>
References: <cover.1614551467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't bother to take a ctx->refs for io_req_task_cancel() because it
take uring_lock before putting a request, and the context is promised to
stay alive until unlock happens.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 42b675939582..ad2ddbd22d62 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1960,10 +1960,10 @@ static void io_req_task_cancel(struct callback_head *cb)
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/* ctx is guaranteed to stay alive while we hold uring_lock */
 	mutex_lock(&ctx->uring_lock);
 	__io_req_task_cancel(req, req->result);
 	mutex_unlock(&ctx->uring_lock);
-	percpu_ref_put(&ctx->refs);
 }
 
 static void __io_req_task_submit(struct io_kiocb *req)
@@ -1994,14 +1994,12 @@ static void io_req_task_queue(struct io_kiocb *req)
 	ret = io_req_task_work_add(req);
 	if (unlikely(ret)) {
 		req->result = -ECANCELED;
-		percpu_ref_get(&req->ctx->refs);
 		io_req_task_work_add_fallback(req, io_req_task_cancel);
 	}
 }
 
 static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
-	percpu_ref_get(&req->ctx->refs);
 	req->result = ret;
 	req->task_work.func = io_req_task_cancel;
 
-- 
2.24.0

