Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1931E3EE8
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 12:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgE0KY7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 May 2020 06:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgE0KY7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 May 2020 06:24:59 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3B0C061A0F;
        Wed, 27 May 2020 03:24:58 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o15so6072296ejm.12;
        Wed, 27 May 2020 03:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cL2REwYbuiFQw9+7Sm4ybcaJkH87SCGRTJq5l7sNJ/M=;
        b=iaFdGMKGMz7aAp7G1jJxCPjb0Gv51q3YGSDlxlmJkrsD1vzbAYHRfvLl8x9l9L/I9s
         sVBIhuBi/9emvqE6GU71ZMQaAGnqX2LhkmLjOy//hCyqZ+CXfrE/GpDmn3JL5E7a+4LV
         a4hF20BGQS1cS+HwhCSEYhmFT8+03/ltaMV60OW8fjEkkqfjbbhunh0NHmBMoTBryGDZ
         RbKH61dh0TVD2eCevZtDYyXGmYzlhFSiAE2f67w7Hz08rCAa57p7wNMq4Bv3V8uJHCD7
         21llwM8BN6Ka01Hqowks9kMiqe4SPuiwE0De1gw8fjdtdWkzt5UL7XD0/TI8KfvN2CSd
         Os7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cL2REwYbuiFQw9+7Sm4ybcaJkH87SCGRTJq5l7sNJ/M=;
        b=DxhdJbWaA0r4JJVnCxv8K4ThFb2WlYjJh2d15ZUZA6LPvN2c0sbRD769CDm1qr62ho
         xMyCtdgzYi2JnCQQVuxK716UN1HHoSJVuZkWDlztI6j7aKh+9yeuQAUj8eWjui38dgfl
         oRCqDG5loklwSzBZqYw6KmpUmHxulTF4wbtUcimoC6j2U5DUWdPT5VGxZhgMkRSxFxI8
         SUXYK8UicVOUcaB6OhfZTgYJ5o/smEVv0PhcJJn+HW3+RUaU5+oaSqlasdC1DHxjgzKg
         74KK/xigESnasocEU6t5MOtz85OOI1mvZ/29W7LeSofwt+gN9H3l96s7eS+W+/l1Ukb/
         jj/Q==
X-Gm-Message-State: AOAM533YMxpcfceYPzLqw622jRotmA2njLE09LRD+eb7DOSHr0SrEkxI
        ZCtkfR484NQdqtUaFlLNEhA=
X-Google-Smtp-Source: ABdhPJy+ANuYRzBdhIovooVjPDuPCs0ZWfGw+3AoWhJM2BQGHx5HTBFyifvtaKMhWRjuZSlsHI795A==
X-Received: by 2002:a17:907:1189:: with SMTP id uz9mr5170829ejb.53.1590575096781;
        Wed, 27 May 2020 03:24:56 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id k27sm2407608eji.18.2020.05.27.03.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 03:24:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io_uring: fix overflowed reqs cancellation
Date:   Wed, 27 May 2020 13:23:33 +0300
Message-Id: <7acb1a15ee5a79103d71372d6330b19c5397a482.1590574948.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Overflowed requests in io_uring_cancel_files() should be shed only of
inflight and overflowed refs. All other left references are owned by
someone else. E.g. a submission ref owned by __io_queue_sqe() but not
yet reached the point of releasing it.

However, if an overflowed request in io_uring_cancel_files() had extra
refs, after refcount_sub_and_test(2) check fails, it

- tries to cancel the req, which is already going away. That's pointless,
just go for the next lap of inflight waiting.

- io_put_req() underflowing req->refs of a potentially freed request.

Fixes: 2ca10259b418 ("io_uring: prune request from overflow list on flush")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index de6547e68626..01851a74bb12 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7483,19 +7483,13 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
 
-			/*
-			 * Put inflight ref and overflow ref. If that's
-			 * all we had, then we're done with this request.
-			 */
-			if (refcount_sub_and_test(2, &cancel_req->refs)) {
-				io_free_req(cancel_req);
-				finish_wait(&ctx->inflight_wait, &wait);
-				continue;
-			}
+			/* Put inflight ref and overflow ref. */
+			io_double_put_req(cancel_req);
+		} else {
+			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
+			io_put_req(cancel_req);
 		}
 
-		io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
-		io_put_req(cancel_req);
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
-- 
2.24.0

