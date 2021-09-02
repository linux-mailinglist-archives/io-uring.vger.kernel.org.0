Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F2D3FF2E5
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 19:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346697AbhIBR5d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 13:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346676AbhIBR5d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 13:57:33 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0DAC061575
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 10:56:35 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id z2so2734232iln.0
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 10:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Aej4X/Mz9AsKtsIFafO84uPPNi2YA1A74zag18E3PgA=;
        b=M3IAgppVRvJq/IcBcK985XXSitsbXnlrjYFCGIth1hXuAsutHLK9Lf7TUD5xore4Ja
         wagTC+5T7Le+vgWcntBAWaRiMarXCiCWMOvI0mtIrGF+Loa+d1pOtDla9Y1DaZul6FUl
         YSPOR2V30iGT0YjUZwfe/9P7nEAXgQzv9Hv4Z7w23gjtHYOAsQNGjDaeXh8F8r3SQDta
         Pdfka+zSJR7r+eg8T9X2Yq1NDFlZPTw9QrSJ+K2E9hKwkvafGb2119EvWW6ZtnZw8Yhs
         pDUSX8BiCH4iAv5Ydi6zLOhHzWn9HhBfFD59hKuLMk9hhn3I6WWki8fMRiGzBZ9kIOky
         F+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Aej4X/Mz9AsKtsIFafO84uPPNi2YA1A74zag18E3PgA=;
        b=Qu4FF47OLLfLwP7f4ncplWGLoMQ5Sbbkras/4zPiIhMPLaZ38qvBa5FelpnQDHXqJZ
         XA6xeuAJ4NTZwPP1Kny5/SsgXAv3oaFpDhiaRvTFWFMxeWDbp14OrIhGgMbPTZlRUnf2
         usyAGDN2IuwsXEvaaIDXrwCn6IulgzklPMZlXzI4BGgGsVY92B7aeNwwi4ZWg6hq6ozc
         3iXwFQdlY+RMIBe0UnXgOaZhjpzfHO+OXSGB12SPkJmvZyteJ7wFbBqwugjHAdVKDJyY
         ZlB0ePC8mEVapyHMCorYFETfXn+cIbjNcvrnP8PZlRwj0QE5TvaummlhePs2OYORV/N/
         550g==
X-Gm-Message-State: AOAM533KvE01KgOGt67pVuoKZbDxDT5TCaxTrdSeuW+OjGUQ8m2d/566
        jhf62J7QjFnTEBQOkCjsPSBXqQwGjBQ9gw==
X-Google-Smtp-Source: ABdhPJz8W5C4NK9FIG5U4HPfz1o/pEh+nyjL1wIg5csPf7AeiSViWNUoxcft9SOgkMj0LLEC+Rwcjg==
X-Received: by 2002:a92:cb08:: with SMTP id s8mr3140766ilo.166.1630605394082;
        Thu, 02 Sep 2021 10:56:34 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r18sm1367678ioa.13.2021.09.02.10.56.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 10:56:33 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: trigger worker exit when ring is exiting
Message-ID: <045c35f3-fb30-8016-5a7e-fc0c26f2c400@kernel.dk>
Date:   Thu, 2 Sep 2021 11:56:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a task exits normally, then the teardown of async workers happens
quickly. But if it simply closes the ring fd, then the async teardown
ends up waiting for workers to timeout if they are sleeping, which can
then take up to 5 seconds (by default). This isn't a big issue as this
happens off the workqueue path, but let's be nicer and ensure that we
exit as quick as possible.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index d80e4a735677..60cd841c6c57 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1130,7 +1130,17 @@ static bool io_task_work_match(struct callback_head *cb, void *data)
 
 void io_wq_exit_start(struct io_wq *wq)
 {
+	int node;
+
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
+
+	rcu_read_lock();
+	for_each_node(node) {
+		struct io_wqe *wqe = wq->wqes[node];
+
+		io_wq_for_each_worker(wqe, io_wq_worker_wake, NULL);
+	}
+	rcu_read_unlock();
 }
 
 static void io_wq_exit_workers(struct io_wq *wq)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2bde732a1183..9936ebaa8180 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9158,6 +9158,7 @@ static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
+	struct io_uring_task *tctx = current->io_uring;
 	unsigned long index;
 	struct creds *creds;
 
@@ -9175,6 +9176,10 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/* if we failed setting up the ctx, we might not have any rings */
 	io_iopoll_try_reap_events(ctx);
 
+	/* trigger exit, if it hasn't been done already */
+	if (tctx->io_wq)
+		io_wq_exit_start(tctx->io_wq);
+
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
 	 * Use system_unbound_wq to avoid spawning tons of event kworkers

-- 
Jens Axboe

