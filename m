Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004C37450F8
	for <lists+io-uring@lfdr.de>; Sun,  2 Jul 2023 21:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjGBTno (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 Jul 2023 15:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbjGBTm5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 Jul 2023 15:42:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC9E1FCA;
        Sun,  2 Jul 2023 12:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73BD060CEB;
        Sun,  2 Jul 2023 19:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30240C433C9;
        Sun,  2 Jul 2023 19:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688326857;
        bh=JFeSh/oDK27uQvNlEL1wYsjP7uTVL3tAH3G0j5bfwqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oV4921w+tJysIXVgcgkX9UePKZ/Coyy6cZhALlCrgTMG6nu8PMl1bOc78V93/5kbe
         hQCH0g0hRzpfFf4eCX7JN2fBc5fkwdOEVm5Su/pFz+himFJXT7wa3Q3HA9qV7VLO85
         /UIr96kNyRuD0AjWljxequcJ7GpdqQf4+Y7x/JejMOybDedtJOONKZ2jJqeORHFeA8
         Jxof9t1KrdDG2X9FE/1Jr/eSJ0CyRqIXXHlTmvJq+toW8v8eI+42f7bHrdCjuX6I2y
         XNceUW7kIvJ74pbAkIqCEWWrCDFBxKNR64dQRw/Br6xiudoCIK0Kze4R+K+sKFQbq7
         +gCY0ZAR2oITA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 02/14] io_uring: annotate offset timeout races
Date:   Sun,  2 Jul 2023 15:40:41 -0400
Message-Id: <20230702194053.1777356-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230702194053.1777356-1-sashal@kernel.org>
References: <20230702194053.1777356-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.3.11
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
index 826a51bca3e49..495eeaebce0c0 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -543,7 +543,7 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 	timeout->target_seq = tail + off;
 
 	/* Update the last seq here in case io_flush_timeouts() hasn't.
-- 
2.39.2

