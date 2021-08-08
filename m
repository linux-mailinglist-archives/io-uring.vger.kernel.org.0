Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742CE3E37A9
	for <lists+io-uring@lfdr.de>; Sun,  8 Aug 2021 02:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhHHAOz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Aug 2021 20:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbhHHAOz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Aug 2021 20:14:55 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34865C061760;
        Sat,  7 Aug 2021 17:14:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u5-20020a17090ae005b029017842fe8f82so14668646pjy.0;
        Sat, 07 Aug 2021 17:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9zf40Jnf+86YZUlaVlZu08PUV0Xulwt4xh3WJjE+NUg=;
        b=dxgswlAlXFWKOu2ir7S32EOuLPmT/RJ8H3ieAjEYgjaWMtGds2SEPSHkZ4QVefgG9W
         DPOxjGOUNCxOgQw4v28vSYo2GHuJKmSCCmsXbUKWOhRkT04lXkf//GVFk4ZGL9jxaDrU
         mXd7VafFkZTFwQL3xDbXkZk30wImKXgbz3++kEUQlI7br/BX8ZXvsDtcrAOYMzLJboxO
         TM2RDhmDCCxWsL6vU6GY06cfMbRo1pyHxXZiA75YpWpxmcC+CdE37wR6s5JLBWsNVPUX
         nY3vX+YuycFE2KU+Olh9f925Rx1o0PYjhdOEoznzP31EfhSxfMLqA/8xG/SL+0+cbzLV
         DYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9zf40Jnf+86YZUlaVlZu08PUV0Xulwt4xh3WJjE+NUg=;
        b=Rtxpf38u2fhxG6u5J2dgptCu6kdLyDaxBCU4MrSWkFC1DlfCTNK58M+ig3ID7AxfJg
         Mc7VT5Q5OeN3Mlwcw8klanGqHU9X1Ai1a2uRgrMMz7nb6aYseK7NNNmcoTb7OiZwlX97
         eBkgvS3FeRVVwIzBf7c6HqH/3D3khN6RlNh1yQ8DI/7wKUw/bB5V+4GAjM1YIOsrrgP1
         i23gp0k4Ava3KRooHs2bwPDdFHVUUPhP28PPV/yq5ZF58Vsiqaa03r7DCBluOBvs67KU
         /eQSHv0P0FT8nRoXlOBKepFujyqQdS36dY8adiPHwxUTxaoWzNBaXd73DKtDrCgkJMuz
         FuZQ==
X-Gm-Message-State: AOAM531qDwfuewX/X2BHIBi4kmFwynaGQuWpzu2TtomY/nIJ2kmmoagp
        IS20JNFIiAKMHYtXutZ4miQQKMCBhx8Fdg==
X-Google-Smtp-Source: ABdhPJwA1C9uXt3DgLF0DOtjGhzY8woU7BvUAQwG68K6ezOsxz9BIR6Mkd3beKEDcBAq3qkK6YWejg==
X-Received: by 2002:a17:90a:1b22:: with SMTP id q31mr17601881pjq.217.1628381676622;
        Sat, 07 Aug 2021 17:14:36 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id u3sm16624278pjr.2.2021.08.07.17.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 17:14:36 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@vmware.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/2] io_uring: Use WRITE_ONCE() when writing to sq_flags
Date:   Sat,  7 Aug 2021 17:13:42 -0700
Message-Id: <20210808001342.964634-3-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210808001342.964634-1-namit@vmware.com>
References: <20210808001342.964634-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

The compiler should be forbidden from any strange optimization for async
writes to user visible data-structures. Without proper protection, the
compiler can cause write-tearing or invent writes that would confuse the
userspace.

However, there are writes to sq_flags which are not protected by
WRITE_ONCE(). Use WRITE_ONCE() for these writes.

This is purely a theoretical issue. Presumably, any compiler is very
unlikely to do such optimizations.

Fixes: 75b28affdd6a ("io_uring: allocate the two rings together")
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/io_uring.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f39244d35f90..c78b487d5a80 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1491,7 +1491,8 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	all_flushed = list_empty(&ctx->cq_overflow_list);
 	if (all_flushed) {
 		clear_bit(0, &ctx->check_cq_overflow);
-		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
+		WRITE_ONCE(ctx->rings->sq_flags,
+			   ctx->rings->sq_flags & ~IORING_SQ_CQ_OVERFLOW);
 	}
 
 	if (posted)
@@ -1570,7 +1571,9 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	}
 	if (list_empty(&ctx->cq_overflow_list)) {
 		set_bit(0, &ctx->check_cq_overflow);
-		ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
+		WRITE_ONCE(ctx->rings->sq_flags,
+			   ctx->rings->sq_flags | IORING_SQ_CQ_OVERFLOW);
+
 	}
 	ocqe->cqe.user_data = user_data;
 	ocqe->cqe.res = res;
@@ -6780,14 +6783,16 @@ static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
 {
 	/* Tell userspace we may need a wakeup call */
 	spin_lock_irq(&ctx->completion_lock);
-	ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
+	WRITE_ONCE(ctx->rings->sq_flags,
+		   ctx->rings->sq_flags | IORING_SQ_NEED_WAKEUP);
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
 static inline void io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
 {
 	spin_lock_irq(&ctx->completion_lock);
-	ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
+	WRITE_ONCE(ctx->rings->sq_flags,
+		   ctx->rings->sq_flags & ~IORING_SQ_NEED_WAKEUP);
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
-- 
2.25.1

