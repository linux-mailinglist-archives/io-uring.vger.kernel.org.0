Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028B63616C3
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 02:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbhDPA1f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 20:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbhDPA1f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 20:27:35 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6112C061574
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 17:27:11 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n4-20020a05600c4f84b029013151278decso2091638wmq.4
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 17:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JEjKV2E/DNV/6q8bzNNyk4Pv3nQniL6PHPiqRJJa2Ag=;
        b=U5AP7E074jHqkneLf5/l/2EBvj4UVTYEakuxZd5SsOM2LO2b89++9+Qjt8gjQpVGy1
         6cHvwDbkSKa7CuyzMlD34mTIEFpdHfTJOrW8Ye1JIXH8oWGFy2K3fiP9xewI0LVePa64
         Y3w7myOKTbxNm4qnMBNHLBVcMHZjs77nUxtvTZc6x8wUnAYph0X+WJ/zGaQeL08QCBzr
         BJe/9XqckHwfMEuPeoXv1QeOvbLs0yOv+VfbSAvQ0W9R3FvIDH91fNVsMsKKv97M2pxn
         ffVqpNPnbSXFO+3Z4ktYLkrhX4i7oBnTR2oBCLaDaTyX9Bl2BISnh9pLM9ZZWBEJAN3P
         ty0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JEjKV2E/DNV/6q8bzNNyk4Pv3nQniL6PHPiqRJJa2Ag=;
        b=tIXcOsDny9EJjbK2zWNnzBXMEfLUaXEVzVHv4g9jz5QuIYZACLihAm1PLHJCqM+S0H
         VafQn6GI3q30n66I9KvxvGa40OjNruRzB3abJNCHyrbhHxE/bgNRmqXMWsIlv7lzouUY
         8XttMZQugbJ4Dhs+VS2GL57ToBQOtanWEahMs/MAH0Is/Ou5n58y6ogXMPQKdl2YcSgm
         wyCRRfEw5DObsgpV46HJkMMjFwtZaIzSo3VqOzG33mmhzcd98ArMCpfZDjOnJ6xc0X8A
         wq4/IXnbzDkjmA99+s4rzolT+PeyBGjWY+48t/E66Kp8Fh+Nw9lm9yD1LhGWgf7y45MV
         RA6g==
X-Gm-Message-State: AOAM532q+yUgViaESWDRtRURdKMerM6s+qw83O3F5U2domk0jNIvGjRT
        oi2zDs/QdPhwLqxzPb0TLFU=
X-Google-Smtp-Source: ABdhPJyY5C7RNHbiTvijq1Jaz7Kl+qLJ1CGWiHYX1sEl00IlNaYi3mK2J2b+/QM0fhIsSu3hR4bHHQ==
X-Received: by 2002:a1c:cc18:: with SMTP id h24mr5414635wmb.23.1618532830708;
        Thu, 15 Apr 2021 17:27:10 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id x15sm5611421wmi.41.2021.04.15.17.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 17:27:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Joakim Hassila <joj@mac.com>
Subject: [PATCH 2/2] io_uring: fix shared sqpoll cancellation hangs
Date:   Fri, 16 Apr 2021 01:22:52 +0100
Message-Id: <4a39b2a97bd2c34084d49531a1c71d480132fe05.1618532491.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618532491.git.asml.silence@gmail.com>
References: <cover.1618532491.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[  736.982891] INFO: task iou-sqp-4294:4295 blocked for more than 122 seconds.
[  736.982897] Call Trace:
[  736.982901]  schedule+0x68/0xe0
[  736.982903]  io_uring_cancel_sqpoll+0xdb/0x110
[  736.982908]  io_sqpoll_cancel_cb+0x24/0x30
[  736.982911]  io_run_task_work_head+0x28/0x50
[  736.982913]  io_sq_thread+0x4e3/0x720

We call io_uring_cancel_sqpoll() one by one for each ctx either in
sq_thread() itself or via task works, and it's intended to cancel all
requests of a specified context. However the function uses per-task
counters to track the number of inflight requests, so it counts more
requests than available via currect io_uring ctx and goes to sleep for
them to appear (e.g. from IRQ), that will never happen.

Reported-by: Joakim Hassila <joj@mac.com>
Reported-by: Jens Axboe <axboe@kernel.dk>
Fixes: 37d1e2e3642e2 ("io_uring: move SQPOLL thread io-wq forked worker")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dff34975d86b..c1c843b044c0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9000,10 +9000,11 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 
 	WARN_ON_ONCE(!sqd || ctx->sq_data->thread != current);
 
+	percpu_ref_switch_to_atomic_sync(&ctx->refs);
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx);
+		inflight = percpu_ref_atomic_count(&ctx->refs);
 		if (!inflight)
 			break;
 		io_uring_try_cancel_requests(ctx, current, NULL);
@@ -9014,7 +9015,7 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 		 * avoids a race where a completion comes in before we did
 		 * prepare_to_wait().
 		 */
-		if (inflight == tctx_inflight(tctx))
+		if (inflight == percpu_ref_atomic_count(&ctx->refs))
 			schedule();
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
-- 
2.24.0

