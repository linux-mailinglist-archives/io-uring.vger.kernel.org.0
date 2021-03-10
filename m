Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCB3334BD2
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhCJWon (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbhCJWoX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:23 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DB1C0613D7
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:23 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so8059968pjb.0
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EyJOO4ZiWR1gfY+86NaMeaickQiDs065ldklAj62U2A=;
        b=K/RQBf4Y8FeXU7PFWANppH9HdpTVaAsOaN1UdtYNw8YIQETNmdh6oBEB2ETBix4uX2
         rCZG6xvSkGw/2Fxzf6ynDQT5ZlTamfLS7GH/Ql4DGcDqrN8d8J1jUQ9wqoTCfZ4q4ucT
         EfQrkJUh+VU2euA9LhNlfbcNa732C+MGCUmcwpFtBRxd3cdWqOvqHEW3PAoT4/n6xprx
         V0lK+qvAJyH7uW36r1ews1u7PizFsRpeLdK507k2QvQq4t4ZSOr9JXPsoYOe+1FdXAz1
         P4E/lqbyULKIQORsJJeMHGJAPya+ywv8/OgGerBP6DZsZ/X1UJrIKcrboarzwnwzEOgJ
         svGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EyJOO4ZiWR1gfY+86NaMeaickQiDs065ldklAj62U2A=;
        b=LMqDSWjPPr4cC9s+ECy+omwIEJyLSoDhMzSzk47c5poTHjDCygfN5HtgxVaEbblW3e
         kqlbZlDUnBZxGvgjjZZK1nxHPEF4wT4t6cIP77WVsaA2N5/92qKbnuN0O7YY45bW6uV4
         YSj0G/UzjwB/h6r4C2d/t33YQMDo7t8RAfVqb0+JLYEVyqTkxnCW849wApjyr037SLUZ
         EiufE4Rlim2XLxv8TD0N4kjUfhKREbWxsBpUEwNcYu1l8r/WON8tHauIxS3da4ipWi2j
         QHhwkcjGE6StvVJ9X8/fb1g0OASLGfOS3C5fQOOtjvDJgJ9FqXKvDvAEgqB+TVG9+wGT
         S5rQ==
X-Gm-Message-State: AOAM532IwZOtlVsPh9sSGaeX+60Vxqjfk6GEGLu8ihYkKb66mGc0dycK
        jog9bCkoAeyb6eddjATQqy/vAYBZzXj5Kw==
X-Google-Smtp-Source: ABdhPJzIxfl0FNNEVI8zxFXijqRu3jtZFQC+0a2q3UC8NiDTUIRlcAxBa9DD7ujqMa9mqh+wxsQ48w==
X-Received: by 2002:a17:902:7682:b029:e6:2bc5:f005 with SMTP id m2-20020a1709027682b02900e62bc5f005mr4954827pll.32.1615416262453;
        Wed, 10 Mar 2021 14:44:22 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:22 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 18/27] io_uring: fix io_sq_offload_create error handling
Date:   Wed, 10 Mar 2021 15:43:49 -0700
Message-Id: <20210310224358.1494503-19-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Don't set IO_SQ_THREAD_SHOULD_STOP when io_sq_offload_create() has
failed on io_uring_alloc_task_context() but leave everything to
io_sq_thread_finish(), because currently io_sq_thread_finish()
hangs on trying to park it. That's great it stalls there, because
otherwise the following io_sq_thread_stop() would be skipped on
IO_SQ_THREAD_SHOULD_STOP check and the sqo would race for sqd with
freeing ctx.

A simple error injection gives something like this.

[  245.463955] INFO: task sqpoll-test-hang:523 blocked for more than 122 seconds.
[  245.463983] Call Trace:
[  245.463990]  __schedule+0x36b/0x950
[  245.464005]  schedule+0x68/0xe0
[  245.464013]  schedule_timeout+0x209/0x2a0
[  245.464032]  wait_for_completion+0x8b/0xf0
[  245.464043]  io_sq_thread_finish+0x44/0x1a0
[  245.464049]  io_uring_setup+0x9ea/0xc80
[  245.464058]  __x64_sys_io_uring_setup+0x16/0x20
[  245.464064]  do_syscall_64+0x38/0x50
[  245.464073]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 84eb499368a4..3299807894ec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7856,10 +7856,9 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			ret = PTR_ERR(tsk);
 			goto err;
 		}
-		ret = io_uring_alloc_task_context(tsk, ctx);
-		if (ret)
-			set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+
 		sqd->thread = tsk;
+		ret = io_uring_alloc_task_context(tsk, ctx);
 		wake_up_new_task(tsk);
 		if (ret)
 			goto err;
-- 
2.30.2

