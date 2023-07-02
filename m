Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C63A7450E6
	for <lists+io-uring@lfdr.de>; Sun,  2 Jul 2023 21:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjGBTnM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 Jul 2023 15:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjGBTmu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 Jul 2023 15:42:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968111BFA;
        Sun,  2 Jul 2023 12:41:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD5C860D30;
        Sun,  2 Jul 2023 19:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8D5C433CA;
        Sun,  2 Jul 2023 19:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688326882;
        bh=YY8aSyiAnXjWZDAe2RJDMiwQaVSTAnL1mmuRePb29F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=as+HKF5wWhlqzYRaV23jSABmgbbdumhP0yfsQYrUkKuDXTRjWD1zsUyrLhmdEia9i
         7fhbCio94WLHyZzen8qycXZwrZalihKWfhNkIEYJYKWxFJr44XIW3MefDe7cKRkCnC
         FthjuK+BZ3278IdrfD3Gz8M2oJrbZK1QnlEezog4LYOYdAzrTovDDCiJWNIC8c8ZRl
         uPNr+8RV0MCmlSq4GYHwKIbOJo1c232/Hiyk/SSVZuiV9w3NsABNo6ZiMN6y1L1ghi
         xOS/CD3QH9VNIldpw+7ZLn3k5lJhbNmnAv1jCBbhqT4Z3NY+ZVkOK6k/bizWug69PN
         xLaA44GreKWQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 02/12] io_uring: annotate offset timeout races
Date:   Sun,  2 Jul 2023 15:41:07 -0400
Message-Id: <20230702194118.1777794-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230702194118.1777794-1-sashal@kernel.org>
References: <20230702194118.1777794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.37
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 5498bf28d8f2bd63a46ad40f4427518615fb793f ]

It's racy to read ->cached_cq_tail without taking proper measures
(usually grabbing ->completion_lock) as timeout requests with CQE
offsets do, however they have never had a good semantics for from
when they start counting. Annotate racy reads with data_race().

Reported-by: syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/4de3685e185832a92a572df2be2c735d2e21a83d.1684506056.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 4c6a5666541cf..b0cf05ebcbcc3 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -545,7 +545,7 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 	timeout->target_seq = tail + off;
 
 	/* Update the last seq here in case io_flush_timeouts() hasn't.
-- 
2.39.2

