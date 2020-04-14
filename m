Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807241A8DDA
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 23:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgDNVlU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Apr 2020 17:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2633995AbgDNVlH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Apr 2020 17:41:07 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9090EC061A41;
        Tue, 14 Apr 2020 14:41:05 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g12so8304603wmh.3;
        Tue, 14 Apr 2020 14:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LexY/8BkQGazriLf0psZ7DeyQewlX7Ab9KNwtacJmiQ=;
        b=P4xP160eFBjlNhTd+TiUVylyJSpqz2Cr8NlWGkZS494t8JCK2wEwl1m1APjVDNUkyM
         7O9e6nFu536guB8Yz7uAm8/vksT0x3AXC5jBxDCwAG1W/gYlbUI6k6CZDeE3Q2v/dvvI
         IRJJ/2mZbca0KZHoMublQlvqTRoQFKtSSZtRyBV6ZWhRMC5h0U8iiNQJ36Y+PbHlJKZT
         WxkiPm5euNvA10UdFqo3yEQ02U3InKJhOC5XlkqHWSC8ARa24I3bjWZbAmo8KKj5JO4x
         Eq2x9dgxAgCDMPbaRR3V93J6t18bv9kji0XuuR8Y34QrHVVCvkqCoK0uVy4Yng/LbYDC
         DTVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LexY/8BkQGazriLf0psZ7DeyQewlX7Ab9KNwtacJmiQ=;
        b=e9PI6DYaKRX9puANf9Bf4qZBEccdU+VIncKJu0dH7suWBX6zSIjpmxvQpvJhmOCr7o
         duBLX7EEnsUJ6i3LO71Ei0GLUdJN9tCtG8gyf3fArAdCcdRknUTTNCkkjeudhTbZTjeE
         PcvoFYXV0lFyXZHN+DHeIKR3+bR5qX8mYUg3GARVzujCkk5LVbyT6erl8jq5AtOJuxgs
         zq1esGfRrurMQMq1hzmpQ2f6pbTaUTPJnM7nzc9+xiXyeDGbxvPHUBQiJpuvdoOWcq6o
         nROoEj6OYk1Vg2CjTyEmcn28h5EoPZ+8uPLA4j4TExZ8u5jvhzyVQmW8YiHGn3Uh9ezP
         iFeQ==
X-Gm-Message-State: AGi0PuYrjkoq1ykm3q9A1aT/bwZDHzebgWE2klZ1RL3OCmAVhFaHQYcY
        TQzaaTG0UxijdnIcZIQYE6/uDhAc
X-Google-Smtp-Source: APiQypLmSfkcPUQwiPECoGowLwg4o6j5b+ycX3vWoqAt8ApoYqkZ8Qe0psyJneawqSai8F/2vgS7oQ==
X-Received: by 2002:a1c:6787:: with SMTP id b129mr1910653wmc.165.1586900464249;
        Tue, 14 Apr 2020 14:41:04 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id l185sm20320540wml.44.2020.04.14.14.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 14:41:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] io_uring: don't count rqs failed after current one
Date:   Wed, 15 Apr 2020 00:39:50 +0300
Message-Id: <d09d7f52f0d80c3af7df600b45a9fa65717d641e.1586899625.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1586899625.git.asml.silence@gmail.com>
References: <cover.1586899625.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When checking for draining with __req_need_defer(), it tries to match
how many requests were sent before a current one with number of already
completed. Dropped SQEs are included in req->sequence, and they won't
ever appear in CQ. To compensate for that, __req_need_defer() substracts
ctx->cached_sq_dropped.
However, what it should really use is number of SQEs dropped __before__
the current one. In other words, any submitted request shouldn't
shouldn't affect dequeueing from the drain queue of previously submitted
ones.

Instead of saving proper ctx->cached_sq_dropped in each request,
substract from req->sequence it at initialisation, so it includes number
of properly submitted requests.

note: it also changes behaviour of timeouts, but
1. it's already diverge from the description because of using SQ
2. the description is ambiguous regarding dropped SQEs

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e69cb70c11d4..8ee7b4f72b8f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -957,8 +957,8 @@ static inline bool __req_need_defer(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	return req->sequence != ctx->cached_cq_tail + ctx->cached_sq_dropped
-					+ atomic_read(&ctx->cached_cq_overflow);
+	return req->sequence != ctx->cached_cq_tail
+				+ atomic_read(&ctx->cached_cq_overflow);
 }
 
 static inline bool req_need_defer(struct io_kiocb *req)
@@ -5760,7 +5760,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * it can be used to mark the position of the first IO in the
 	 * link list.
 	 */
-	req->sequence = ctx->cached_sq_head;
+	req->sequence = ctx->cached_sq_head - ctx->cached_sq_dropped;
 	req->opcode = READ_ONCE(sqe->opcode);
 	req->user_data = READ_ONCE(sqe->user_data);
 	req->io = NULL;
-- 
2.24.0

