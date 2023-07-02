Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090687450B8
	for <lists+io-uring@lfdr.de>; Sun,  2 Jul 2023 21:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjGBTlX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 Jul 2023 15:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbjGBTlB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 Jul 2023 15:41:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BDA1BD2;
        Sun,  2 Jul 2023 12:40:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 865BA60C8D;
        Sun,  2 Jul 2023 19:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4573AC433C9;
        Sun,  2 Jul 2023 19:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688326832;
        bh=pmq9JZD8yIqmj0mM5w5/RCcJ+BTdxiwpEgcufDWTT6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQki/MMrdl//CtUgjlb6u6dGjrcIwNJRZOXWdT0JOzXghHb5V085i8EoJBGA97xTb
         xkRXtAqKnsRGTpcQy69FyRpWp3JivubxbVHgYTZdbKLvncbD/6e2P572GLV4gJrrYr
         /RRanFv+B48At0kOqMzdokksF0oam4KPx8EHFNuo7Sw1AvELMRp6uBOA92FedAjcDx
         NOOt/W0MU07O0ldMuwc75eYTcT8I0LVJIzi2WKqhhDyqj+QZg98+dbdhVA1x7mvtq6
         aDJQYQ57wfBGgy/kqjAFMkMzpfJWlUeyfmY0K5b2qZP1c/RWhQZK/A4T2iAs9HLMqu
         Tnnv84lN4kZ1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.4 03/15] io_uring: annotate offset timeout races
Date:   Sun,  2 Jul 2023 15:40:08 -0400
Message-Id: <20230702194020.1776895-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230702194020.1776895-1-sashal@kernel.org>
References: <20230702194020.1776895-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.4.1
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index fc950177e2e1d..350eb830b4855 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -594,7 +594,7 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 	timeout->target_seq = tail + off;
 
 	/* Update the last seq here in case io_flush_timeouts() hasn't.
-- 
2.39.2

