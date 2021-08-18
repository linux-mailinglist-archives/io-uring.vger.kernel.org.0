Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7563F08AB
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 18:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhHRQCz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 12:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhHRQCz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 12:02:55 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78F1C061764
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 09:02:20 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q11so4298762wrr.9
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 09:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TmvL98ZiFysPug2bjPMt1v/L9XJyTsU+C96IphyQFzo=;
        b=FJKY81lbeKi3iKEhWBwklFL1/beKG6kYNG7cSSXjqoUHg0d47IL/Q321Hf3UzVbRK3
         amQbGaQ4/h0t0AxIWfifsTFPa3iygm0ylAYspzgUrPvPx/nTQBuxPmCsX8j4QoG0K7FK
         hD98Q9KbnbZHh0RpuzZ9d2GeQMbBFM9wcHg3ZbPH2e0TtKawGqs/F5+04ofTZmMvmlCl
         s/mTfcMlEBT1m2LEWzyHYrLGiQ8GUofc5q/e5VN+q0QE0ozyUvNNU1+pMKZ5hooRvpSn
         dFqNit5XbK73HU2lpNLVunLjgCn3jZlcA03e2OgFuH8/PYytdLoHsp7a+68ytsABglBd
         EpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TmvL98ZiFysPug2bjPMt1v/L9XJyTsU+C96IphyQFzo=;
        b=uLZyVAypA4tC3FzfSlSVKLFgGz9xNOUk4Yvktipfcg004ccBozJtOBvVPRWAj9uUuY
         L+LVggf04bmqdDQWWkwwSVAtF01QRjORLJJI95AhYeco0+60oS9svLnu2Q15iSTe2uhv
         Xkc7E8tWrlN1gsIceUpeS0oIvD8O7e6PJvgX5vyYnQ13zJK/p7RMd2pCD88bU0offoj5
         c1SLAgd8nHIpg8bddKZhAh3TKcrhBIQqCy7r/3EcXizMu9QZoN+LwuRlLjgZAnjUXc5b
         zewLIrJj9SeA2/jbNVleUgBkrVUY/XZW4p3TJcC1rH9zEeg3GA461htBIa/i9s+nSqD3
         AozA==
X-Gm-Message-State: AOAM532cBAatx6XFCyqDp4h+9xAUzRocj2e/MePJGXUEhxmsmkIoIR8L
        7//Em0HjXd5t5mtHM92K3QydLrbYWPA=
X-Google-Smtp-Source: ABdhPJzGUezUg4INgdLNqeoXK/yTHlSi59IDrIFaxus0siwD8YC6Pdb+hNAf8UMMEgApUYh2mgK7vw==
X-Received: by 2002:a5d:678f:: with SMTP id v15mr11818307wru.196.1629302539362;
        Wed, 18 Aug 2021 09:02:19 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.2])
        by smtp.gmail.com with ESMTPSA id i9sm252676wre.36.2021.08.18.09.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 09:02:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next] io_uring: extend task put optimisations
Date:   Wed, 18 Aug 2021 17:01:43 +0100
Message-Id: <824a7cbd745ddeee4a0f3ff85c558a24fd005872.1629302453.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now with IRQ completions done via IRQ, almost all requests freeing
are done from the context of submitter task, so it makes sense to
extend task_put optimisation from io_req_free_batch_finish() to cover
all the cases including task_work by moving it into io_put_task().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ba087f395507..5e99473ad6fc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1628,10 +1628,14 @@ static inline void io_put_task(struct task_struct *task, int nr)
 {
 	struct io_uring_task *tctx = task->io_uring;
 
-	percpu_counter_sub(&tctx->inflight, nr);
-	if (unlikely(atomic_read(&tctx->in_idle)))
-		wake_up(&tctx->wait);
-	put_task_struct_many(task, nr);
+	if (likely(task == current)) {
+		tctx->cached_refs += nr;
+	} else {
+		percpu_counter_sub(&tctx->inflight, nr);
+		if (unlikely(atomic_read(&tctx->in_idle)))
+			wake_up(&tctx->wait);
+		put_task_struct_many(task, nr);
+	}
 }
 
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
@@ -2179,9 +2183,7 @@ static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 {
 	if (rb->ctx_refs)
 		percpu_ref_put_many(&ctx->refs, rb->ctx_refs);
-	if (rb->task == current)
-		current->io_uring->cached_refs += rb->task_refs;
-	else if (rb->task)
+	if (rb->task)
 		io_put_task(rb->task, rb->task_refs);
 }
 
-- 
2.32.0

