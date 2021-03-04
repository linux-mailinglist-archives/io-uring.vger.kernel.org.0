Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6EF32D9C6
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhCDS5X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbhCDS5K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:10 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37ADC061760
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:29 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id j2so15978215wrx.9
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/cRaahzEKpOla5OONawdVGoj1HbZ3KHsbIBIYIha5wQ=;
        b=iwUJu4Pi2VlWvj85VjfgU70K9UHTaQvLSH/rjVZ0wb/q+ZCeZiau5z6g7TqFxUSe87
         yW1grAH4h7Wp1BDAn5yJhzJM6E1XVdaSAJMJGMJ46ZCHIR2KZP0QZ7Nu8cRyNtV2PAPZ
         Rkz1V63yJELOv0WPxT3g/r4GZ3rCBAyEGjvSdVxoZh1VD4xPpIpznQJGj8POunE2vi4W
         vdbPtg6d0B1Hoqb5X4r9xbGd7PxL3WzCMbhx3SJ6V0H+YpEsjDH0gT0M49wu7bxQpuGk
         W5z1NYM9MktR7ARZL6/9MbatOEtKVNwTZppWZ5TQVur4gBqX6eZmwpPGuGBXE57TSLQY
         cN/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/cRaahzEKpOla5OONawdVGoj1HbZ3KHsbIBIYIha5wQ=;
        b=URCgPn4osFtwKdVnUgkwqApNb+21GQQPiRr/Jv8NgYtZ2ZL8OWMrprUnRerB8+1o/R
         MlGOmTyoF3kPEXLzVkdpVyJwr4x7BKsjQCNYI1yfZOSpfyeSOY3vLuTfJ8HgxtP+y1iC
         6TcJlRPYnV4M+rmVeKSGHgZdgkWD5kNjGBpR983cIQsJjNyB2ckZeoLVBx7X+BkcM5tB
         Yxj4DpxtpnoDkHVNopm+un5yvSIZh7TPRz54XAGugIcfCG0LwI54Yewt1uTf8pPxXY9i
         fYiFTZM2csnq27zNjC1WZGLVlXisxmRXVX8lyWm3m8yqUfENgRTS1H/LgJBjFbrSVQGx
         r/zA==
X-Gm-Message-State: AOAM532weeWE1kMADU2Sx6hlhFdNbltoBwSO5qT3KkoUj8E9cU+rw2/F
        1831w8ZZvThst98Tw3c/vi8NdvBq3o5d2w==
X-Google-Smtp-Source: ABdhPJxmCTdBarWhOOhyea2kbqpkPhKQsUaJ91aCKTOrv4YEp5i/CMzq78UMdZ8Q+OVZdp3VEfXZyQ==
X-Received: by 2002:a5d:4688:: with SMTP id u8mr5473120wrq.39.1614884188826;
        Thu, 04 Mar 2021 10:56:28 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id k11sm575800wmj.1.2021.03.04.10.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:56:28 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/11] io_uring: move setting tctx->sqpoll from hot path
Date:   Thu,  4 Mar 2021 18:52:17 +0000
Message-Id: <58c424b2ac57f0eb3b5197d05e0a373b1becf53c.1614883423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614883423.git.asml.silence@gmail.com>
References: <cover.1614883423.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We need to set tctx->sqpoll only when we add a new entry into ->xa, so
move it from the hot path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9175ab937e34..869e564ce713 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8709,18 +8709,19 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 				fput(file);
 				return ret;
 			}
+
+			/*
+			 * This is race safe in that the task itself is doing
+			 * this, hence it cannot be going through the exit/cancel
+			 * paths at the same time. This cannot be modified while
+			 * exit/cancel is running.
+			 */
+			if (ctx->flags & IORING_SETUP_SQPOLL)
+				tctx->sqpoll = true;
 		}
 		tctx->last = file;
 	}
 
-	/*
-	 * This is race safe in that the task itself is doing this, hence it
-	 * cannot be going through the exit/cancel paths at the same time.
-	 * This cannot be modified while exit/cancel is running.
-	 */
-	if (!tctx->sqpoll && (ctx->flags & IORING_SETUP_SQPOLL))
-		tctx->sqpoll = true;
-
 	return 0;
 }
 
-- 
2.24.0

