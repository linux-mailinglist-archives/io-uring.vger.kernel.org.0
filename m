Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE9E4B729F
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 17:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240129AbiBOPbe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Feb 2022 10:31:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240268AbiBOPar (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Feb 2022 10:30:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27731C24A6;
        Tue, 15 Feb 2022 07:29:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D394BB81AEA;
        Tue, 15 Feb 2022 15:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED63BC340EB;
        Tue, 15 Feb 2022 15:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938942;
        bh=KOo0Lc0CAVLi3RcvWm0aAT+pWN+D05lgre7KkXptlF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPDtRYALCJnZL+KCCcX8/Wt30zPzxZijJ90RqPy7DyHJkEAMzt+pzu5kWsUkAIacF
         wFj4pkUXbqxZJNxKN6H+mJCQczrGe4qNs8hR7wdUfHlr58lGi3pHNUa9BHEtt11k7+
         yhkLP9YbbMT1WmO238+ofQcuXWVls95FwQLwMZDjHJ5BsfPNvEhYJ1w1JlFjZ8TwJI
         KQDdZjFWlap0FiIw6KYTv/cAVdRZRKN0IEjbXGuopRJVR4pphNtCAkJXacJkQ/V6SX
         o0ILnASE0KUofhwYQn94atp6tvTC5PcwF19vxfW2LJEoQ+fV4hZQhf9x3CV7gI77Oq
         dwFGLJj1XLILQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shakeel Butt <shakeelb@google.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/33] mm: io_uring: allow oom-killer from io_uring_setup
Date:   Tue, 15 Feb 2022 10:28:15 -0500
Message-Id: <20220215152831.580780-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

[ Upstream commit 0a3f1e0beacf6cc8ae5f846b0641c1df476e83d6 ]

On an overcommitted system which is running multiple workloads of
varying priorities, it is preferred to trigger an oom-killer to kill a
low priority workload than to let the high priority workload receiving
ENOMEMs. On our memory overcommitted systems, we are seeing a lot of
ENOMEMs instead of oom-kills because io_uring_setup callchain is using
__GFP_NORETRY gfp flag which avoids the oom-killer. Let's remove it and
allow the oom-killer to kill a lower priority job.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Link: https://lore.kernel.org/r/20220125051736.2981459-1-shakeelb@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 993913c585fbf..21fc8ce9405d3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8820,10 +8820,9 @@ static void io_mem_free(void *ptr)
 
 static void *io_mem_alloc(size_t size)
 {
-	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP |
-				__GFP_NORETRY | __GFP_ACCOUNT;
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
 
-	return (void *) __get_free_pages(gfp_flags, get_order(size));
+	return (void *) __get_free_pages(gfp, get_order(size));
 }
 
 static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
-- 
2.34.1

