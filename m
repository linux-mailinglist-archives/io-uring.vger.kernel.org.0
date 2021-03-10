Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EF8334BD6
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhCJWoo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbhCJWo3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:29 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A46C061764
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:28 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id a188so13165974pfb.4
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=11c4hQbge56fgpxsW/S8wL/eQWjuHReGxXoRhMSMHBk=;
        b=heIhJtbHKjvg7ccbHlFXDPJMgBq6qy+AlU9nPO6FO5lso+hzGBDecWGpxHPnrV/t+m
         BsJtWNXcGE4WUTrBIWMKhhfmWSMpWRRcSYu+xPRId/LQfkKqJH5BPknCyYrjcYB0y0Em
         o80I1jmPKUFZrMQcusvF2DSotQ+To6PLk0DDmuWgc+1lA1anxrtO7np98Lz3SuAsgNIG
         Bvr7euSEwfdh9xetmmk1cybpvDGcYb65vTeeR59uxs9fHRowFQ0+dpjcwRxCyNnawPgM
         KgobGnXRxncXEallhKDax5o/mLO+8zQp5+5OcQ79iBw3qlkPAXEjD3Qlfclm9iu9yAYx
         fQCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=11c4hQbge56fgpxsW/S8wL/eQWjuHReGxXoRhMSMHBk=;
        b=VJwTaut4qipl3/tiURGIoBlf9m1UFWAYNqidrj73QnBaEqjkUk1Kzs/bc/iiuEjyBb
         ZNAea5Cc/lzVH+7jWQXQTzsZyWIsNxZQ/nZSh9foxC0gjIQEGsyDaXKNCp3p1Fs7ChPE
         egDkclou9NC5m2Ur9fB/2pud/NpS21wlWT4nkiiGlSqsWBjcO+vuHtDXB5JWN4FNsU1b
         3n5h0IGlECv2n9aImudQykpEKGwQDznQdKmSCyGXRD7tLNIS5uB9VqG5JisSZURCtW8k
         SDA4JUbFAdpzFa5jYgGGAlUFsl2KBey9+BVYRkgiXXrPTsiAb2z+S6qtwVxjdnIjCNjo
         Nc5A==
X-Gm-Message-State: AOAM531NRraLA0af2dCBwQGmJqXV4PGi5dE9ufmqV68uYDX8NRON/kDn
        FYpLzZ6mTPv7vwtQa4k/2bGDX0QRhYHpMA==
X-Google-Smtp-Source: ABdhPJzHV4NnsIjJxuDveabXYvBxDeIKDhNAV/5eF+zYaVG3y2STDjQyCvt8X8F9kJcPBSGeApHaXg==
X-Received: by 2002:a65:64d3:: with SMTP id t19mr4728410pgv.208.1615416268225;
        Wed, 10 Mar 2021 14:44:28 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:27 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 24/27] io_uring: always wait for sqd exited when stopping SQPOLL thread
Date:   Wed, 10 Mar 2021 15:43:55 -0700
Message-Id: <20210310224358.1494503-25-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have a tiny race where io_put_sq_data() calls io_sq_thead_stop()
and finds the thread gone, but the thread has indeed not fully
exited or called complete() yet. Close it up by always having
io_sq_thread_stop() wait on completion of the exit event.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6325f32ef6a3..62f998bf2ce8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7079,12 +7079,9 @@ static void io_sq_thread_stop(struct io_sq_data *sqd)
 	if (test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state))
 		return;
 	down_write(&sqd->rw_lock);
-	if (!sqd->thread) {
-		up_write(&sqd->rw_lock);
-		return;
-	}
 	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
-	wake_up_process(sqd->thread);
+	if (sqd->thread)
+		wake_up_process(sqd->thread);
 	up_write(&sqd->rw_lock);
 	wait_for_completion(&sqd->exited);
 }
@@ -7849,9 +7846,9 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 			ret = -EINVAL;
 			if (cpu >= nr_cpu_ids)
-				goto err;
+				goto err_sqpoll;
 			if (!cpu_online(cpu))
-				goto err;
+				goto err_sqpoll;
 
 			sqd->sq_cpu = cpu;
 		} else {
@@ -7862,7 +7859,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
 		if (IS_ERR(tsk)) {
 			ret = PTR_ERR(tsk);
-			goto err;
+			goto err_sqpoll;
 		}
 
 		sqd->thread = tsk;
@@ -7881,6 +7878,9 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 err:
 	io_sq_thread_finish(ctx);
 	return ret;
+err_sqpoll:
+	complete(&ctx->sq_data->exited);
+	goto err;
 }
 
 static inline void __io_unaccount_mem(struct user_struct *user,
-- 
2.30.2

