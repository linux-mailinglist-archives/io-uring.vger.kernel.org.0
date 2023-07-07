Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCE474B50D
	for <lists+io-uring@lfdr.de>; Fri,  7 Jul 2023 18:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbjGGQUO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Jul 2023 12:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjGGQUN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Jul 2023 12:20:13 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D21B1BEE;
        Fri,  7 Jul 2023 09:20:11 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B4A845C0151;
        Fri,  7 Jul 2023 12:20:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 07 Jul 2023 12:20:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1688746810; x=1688833210; bh=RM0mgP8xGV
        Q+Nh9DbRaHnprRjsG173RHiqAP1dmkn7c=; b=fzU62APvTW8+dgJYTmIYymrU/c
        LY+HivEwSTRkIC1LW8y8xnrkCKUtGQVsiZ0UUPwcQrqoJcpYgoBBoNziWePuvUPD
        1qlMr+gHSSz921QIi+sjfN5F4kT6MT5YhfxP/uyjcPoutAHfYoGdyBtO9iOXz3bO
        fZ6Y+ihOnPZm0qiCpgYm/eAGKzCtYTQTgx0kyOuD+QJbpm1IyXAWpKxIsYFLXOdY
        l1+NsKwHMBNv3bWlLjpPsk/U3GWcWnhZFD4gzqXuhxMUjWh9AwdmkIaLBdRpRfgC
        mTGGCYVTRGSVyV+N/4HhqNijVR++uWeeFInYkQ4ihKox1xqWEpkLruCEum6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1688746810; x=1688833210; bh=RM0mgP8xGVQ+N
        h9DbRaHnprRjsG173RHiqAP1dmkn7c=; b=ky5qLHzlOrBhd0QJ3x3ae+U2fCDEZ
        aWHzMKZYV+I39bYLCuZxu7dSH4JbWROejltB48WB0GmaVu+d/oRJHuMSp3/e8szu
        CJ+lqMxh8JpG9r7xTh/1+nH4tlwOC9Leq/x0gwWWR+hzFM8BxqQs6LnM7G4Adt1W
        gEbm87TREA3IjLtHjJ23hLoznXDkcB5tYP+8Jw55Jc5s8W2utj8KD3xq8z5zz5QV
        ftDU+D/PtMUEBMThl5xjE3H38CpUTXxHxabS60k5isXtTX0w/YcNQxTGCcskQtWf
        V1zJU/sxyzCZ+f7irAB7FTywjdiRvBX/7qi4e0/NdsdjL0SRoLT081Fng==
X-ME-Sender: <xms:OjuoZDbIKpEXC4P-YbU1j06D9MtE8eNGJVKmcXkvx9LptqygOLEbtw>
    <xme:OjuoZCbf1exYuY-qw-B5rTko61-JXnai9lDklcDMynue4lW2oUhoHaBbNq-b-VX6T
    KXz_CLGUOLTWQpGSA>
X-ME-Received: <xmr:OjuoZF9_9J8YDOfaykxPJgzC0W0lE8y4t_lxChiv3iBoSos-6fuRrixNVYgEppdHCswtutg-h9_pS4SgJRDS5OhnBKYwYwU56XyIIxAeviegDmB3aLP7TvqoFN6h>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrvddugdellecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeetnhgurhgvshcu
    hfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrghtth
    gvrhhnpeekieeigeekleeggfeugfehudeigeejfeehvefhleetgeeujeffvdegueefgedt
    veenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnh
    gurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:OjuoZJoBAdiUyIpBUZ2BD56SEsvmY-7FHyBvGnDqltL1E3jt5ZGBJA>
    <xmx:OjuoZOrOGSLkyuyj0Ar8dh0XUmuHDPx0XlqIEaB1iV96vGZwCRswuQ>
    <xmx:OjuoZPTxgeEmDQ02kI6z-09PrYxObfVwgqPlp06E9SwrpuLE1ZLM-Q>
    <xmx:OjuoZF0PdGem4KOLQqVXukXgoyI6x9yQ9bWD7nM0f6jlU70qo3m7xA>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Jul 2023 12:20:10 -0400 (EDT)
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1] io_uring: Use io_schedule* in cqring wait
Date:   Fri,  7 Jul 2023 09:20:07 -0700
Message-Id: <20230707162007.194068-1-andres@anarazel.de>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I observed poor performance of io_uring compared to synchronous IO. That
turns out to be caused by deeper CPU idle states entered with io_uring,
due to io_uring using plain schedule(), whereas synchronous IO uses
io_schedule().

The losses due to this are substantial. On my cascade lake workstation,
t/io_uring from the fio repository e.g. yields regressions between 20%
and 40% with the following command:
./t/io_uring -r 5 -X0 -d 1 -s 1 -c 1 -p 0 -S$use_sync -R 0 /mnt/t2/fio/write.0.0

This is repeatable with different filesystems, using raw block devices
and using different block devices.

Use io_schedule_prepare() / io_schedule_finish() in
io_cqring_wait_schedule() to address the difference.

After that using io_uring is on par or surpassing synchronous IO (using
registered files etc makes it reliably win, but arguably is a less fair
comparison).

There are other calls to schedule() in io_uring/, but none immediately
jump out to be similarly situated, so I did not touch them. Similarly,
it's possible that mutex_lock_io() should be used, but it's not clear if
there are cases where that matters.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Andres Freund <andres@anarazel.de>
---
 io_uring/io_uring.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3bca7a79efda..4661a39de716 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2575,6 +2575,9 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq)
 {
+	int ret;
+	int token;
+
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
 	if (unlikely(!llist_empty(&ctx->work_llist)))
@@ -2585,11 +2588,20 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		return -EINTR;
 	if (unlikely(io_should_wake(iowq)))
 		return 0;
+
+	/*
+	 * Use io_schedule_prepare/finish, so cpufreq can take into account
+	 * that the task is waiting for IO - turns out to be important for low
+	 * QD IO.
+	 */
+	token = io_schedule_prepare();
+	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
 	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
-		return -ETIME;
-	return 0;
+		ret = -ETIME;
+	io_schedule_finish(token);
+	return ret;
 }
 
 /*
-- 
2.38.0

