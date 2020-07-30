Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820172335F1
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 17:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgG3PqP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 11:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729853AbgG3PqO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 11:46:14 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35098C061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:46:14 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id bo3so5811163ejb.11
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dC1I48xO+E1RQhu0t1uMKKlog1dG7uFs2kogsgolFKo=;
        b=B+JiN5IIIls8VkTFAxsOw+RRCk0Fqnsai1HA/8c6VyzFvcs9B/rk8gM9rqllbOQWNf
         8MJTlmvAQG1Ta34ZFJau7/FyeHCy1Y4YluM23esM10tj4nCdRMl+ntn9ioRhIAmqBui4
         kedG53mGb+aVOaMHLsyC110bPYK3SfKr00zCMTJlC+NApo9TL/SkBAorOcp5CsuBNmbb
         3FZBNFyp3wxSn7d05nXwXxMy9SF7WjioJODRfx97ePbtA2blrKJC5I+t7LuJ3JqhtCu2
         /rnIozC36nEi7c6OqshWBRNNR2nt5JwJyNl0iKvrS9aQ5aRf0GvDCpGrqcfAMegaVJjE
         IbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dC1I48xO+E1RQhu0t1uMKKlog1dG7uFs2kogsgolFKo=;
        b=XkVGLhSlLNGrGZEL4dpSMbv5VBoRjL7O3rnhRsj6iQ4kkIkWKDyUr/XnPfhZnE+/Xp
         hqKmTsM9Ql3G9otrStupudn1SZHgT2kTCIvdK4Mf3RZ7zbeshbHD0oXMZCGpyzJ4URhy
         3+nm0sJ1AopySycOxd1RegGpRn9uvAYSYWL3JhTnc9el+AWdsfS+LANSOKY1fUaKm7Gj
         anHqjOwXT/1KxdS6KAdRN7FF34Sk4/cqU8unTl0vw5HfVwxZp8DHvfufs9QzhzMvzWGO
         4q1404BKqCgiW+z7vvOvpUUzE7uEJ7yPbHfEy4A9cPGZi1xdkVePrAgwon6B37ZKa+vN
         L0UQ==
X-Gm-Message-State: AOAM531YJOUCYBkajD5k77dK9R6SVvmfv9D/V8nwhVrh0hSw/W3Efhcl
        ubjcdBX2xEAgLYhQTsmyEA2JG14Z
X-Google-Smtp-Source: ABdhPJz6eFaP5xme+66bW4Deo/uHvxA/1Nt+DWyN13+Fg54Z7HvHSZfiYv/lzfjCd4vs4dZ3XJgVSQ==
X-Received: by 2002:a17:906:ecf7:: with SMTP id qt23mr3315524ejb.314.1596123972929;
        Thu, 30 Jul 2020 08:46:12 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id g25sm6740962edp.22.2020.07.30.08.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 08:46:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/6] io_uring: consolidate *_check_overflow accounting
Date:   Thu, 30 Jul 2020 18:43:49 +0300
Message-Id: <4a5758ed5a2a94408fa96beed2984772279e603d.1596123376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1596123376.git.asml.silence@gmail.com>
References: <cover.1596123376.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper to mark ctx->{cq,sq}_check_overflow to get rid of
duplicates, and it's clearer to check cq_overflow_list directly anyway.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 11c1abe8bd1a..efec290c6b08 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1303,6 +1303,15 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 		eventfd_signal(ctx->cq_ev_fd, 1);
 }
 
+static void io_cqring_mark_overflow(struct io_ring_ctx *ctx)
+{
+	if (list_empty(&ctx->cq_overflow_list)) {
+		clear_bit(0, &ctx->sq_check_overflow);
+		clear_bit(0, &ctx->cq_check_overflow);
+		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
+	}
+}
+
 /* Returns true if there are no backlogged entries after the flush */
 static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
@@ -1347,11 +1356,8 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	}
 
 	io_commit_cqring(ctx);
-	if (cqe) {
-		clear_bit(0, &ctx->sq_check_overflow);
-		clear_bit(0, &ctx->cq_check_overflow);
-		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
-	}
+	io_cqring_mark_overflow(ctx);
+
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
 
@@ -7842,11 +7848,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			spin_lock_irq(&ctx->completion_lock);
 			list_del(&cancel_req->compl.list);
 			cancel_req->flags &= ~REQ_F_OVERFLOW;
-			if (list_empty(&ctx->cq_overflow_list)) {
-				clear_bit(0, &ctx->sq_check_overflow);
-				clear_bit(0, &ctx->cq_check_overflow);
-				ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
-			}
+
+			io_cqring_mark_overflow(ctx);
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
 			io_commit_cqring(ctx);
-- 
2.24.0

