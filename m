Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F39F718283
	for <lists+io-uring@lfdr.de>; Wed, 31 May 2023 15:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbjEaNnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 May 2023 09:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbjEaNnO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 May 2023 09:43:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6D3E7E;
        Wed, 31 May 2023 06:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9507863337;
        Wed, 31 May 2023 13:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442EAC4339B;
        Wed, 31 May 2023 13:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685540516;
        bh=v/K2K951N1AllIDWWWztB0U6RFdbO/hSvfoFqcqQKC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBeJKCnM5MretXiwRjJzFpPtFABcT+Xp6wAbtPoMCkSjsMKTcTkRpJuUkZg8GR32v
         NTVjM2Gp6GpU/GMNyB3Fzwuzw/FfpT95AV45Y6MBJvZKHEM1OpSpW/PAwShvWwYAOv
         CHuO48I3Nc1vkRcKtuk9SWkLEDfQ5xUgWSzA2KWJGjdFMyN5dxXrBoY0eWitGV+CrM
         iIARLnZtz6yXwM9M+Bw5FqN8+VPkCuzsQDPUvesPyVyk1P7iIude7cZHbNyrZ5wwZb
         YNv8W2eN9jCrD5pAHoD3eX9TtQ+GW64K+aQAKDWpCPcgfDLMnmgUAVrj5E0IsGe7Zj
         ToSelkuxvalKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Chen <wenwen.chen@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 36/37] io_uring: unlock sqd->lock before sq thread release CPU
Date:   Wed, 31 May 2023 09:40:18 -0400
Message-Id: <20230531134020.3383253-36-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230531134020.3383253-1-sashal@kernel.org>
References: <20230531134020.3383253-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Wenwen Chen <wenwen.chen@samsung.com>

[ Upstream commit 533ab73f5b5c95dcb4152b52d5482abcc824c690 ]

The sq thread actively releases CPU resources by calling the
cond_resched() and schedule() interfaces when it is idle. Therefore,
more resources are available for other threads to run.

There exists a problem in sq thread: it does not unlock sqd->lock before
releasing CPU resources every time. This makes other threads pending on
sqd->lock for a long time. For example, the following interfaces all
require sqd->lock: io_sq_offload_create(), io_register_iowq_max_workers()
and io_ring_exit_work().

Before the sq thread releases CPU resources, unlocking sqd->lock will
provide the user a better experience because it can respond quickly to
user requests.

Signed-off-by: Kanchan Joshi<joshi.k@samsung.com>
Signed-off-by: Wenwen Chen<wenwen.chen@samsung.com>
Link: https://lore.kernel.org/r/20230525082626.577862-1-wenwen.chen@samsung.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 9db4bc1f521a3..5e329e3cd4706 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -255,9 +255,13 @@ static int io_sq_thread(void *data)
 			sqt_spin = true;
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
-			cond_resched();
 			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
+			if (unlikely(need_resched())) {
+				mutex_unlock(&sqd->lock);
+				cond_resched();
+				mutex_lock(&sqd->lock);
+			}
 			continue;
 		}
 
-- 
2.39.2

