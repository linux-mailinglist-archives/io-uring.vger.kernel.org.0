Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316031A3D44
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2020 02:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgDJASZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Apr 2020 20:18:25 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52097 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgDJASZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Apr 2020 20:18:25 -0400
Received: by mail-pj1-f67.google.com with SMTP id n4so173489pjp.1
        for <io-uring@vger.kernel.org>; Thu, 09 Apr 2020 17:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=jIRg2XWI4Uk8zC36KiqUup6iMzOr8IcxxXVm8p8vsqg=;
        b=lSIYwrM6xUOkeG4zC8/XFLfLqkyLqSg6rn1iaBqpfCwVmCRkHXCsGfpfONBkengbTn
         FXeL08AiMUZ+oqeakLuJP9tCAY18Q/wLY4kwky5ErEmKib1DsxQCuSzlrWYbhOhqgfoU
         MvY7ElDKywtunh75QimR42Pc1S1RZZj5wS8DN8q5V2q3tnKcqm5hOeUKOIEKuqJ4+0L+
         0R8AxYGgA5SquEmu7Wl2weerTHUxN/uMzFtC4Lo3hM6degAc+2Vu06fd2AKZbBoTnQ6M
         1tu5RXPmhwCKvQalZQPUIDif52yTrERe4SPuY3MgiUgvT8ufBag7UBNTMdELdRfp8wfp
         11Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=jIRg2XWI4Uk8zC36KiqUup6iMzOr8IcxxXVm8p8vsqg=;
        b=clKcW34XLjMXlIMIdTg1zRV2OwlJu2P45j1L2EINmBCqt4cme5p3NVRHCgAicnqWp3
         fNL2ufKHqAVwgfWgnDutv7RZ5FHPekgioQ7UQZGhxgOqc+F22kkwshaMQ9GuVAv4hkui
         wsSzIJUbMAHR+2+wCSrxxOhuE7+iyAzoCo9BHXknGvnA1XELFDFmJ4PVJR8PJOOTVSup
         d1mSRKlLBCUUd/Sq6eCE348iifqzjJQGZackO8n09vTsJ7zVkhMrw0WFQ2YALSC2uu9v
         icMjcr/NmBw3+dSCfjmDX1CJg2KV2y4VU7j80XjKtFak2ThFc12073JcKrH892fYL9ii
         mDAg==
X-Gm-Message-State: AGi0Puaxd1ehLOSfduyyZ3dvpJn38FbxNWbhnm+GzArjCoWetXcFY4hK
        n6iuLzXS1YDThyokl/JhhiDPe7kpqW24CQ==
X-Google-Smtp-Source: APiQypJcmlfc2UFF5onePC92Amei0IW9wYTV9KREOK5G06G1Wzkg1IFW19vkpyTMwZ50BnDZa7EgZA==
X-Received: by 2002:a17:90b:3849:: with SMTP id nl9mr2245887pjb.86.1586477903574;
        Thu, 09 Apr 2020 17:18:23 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c8::13d1? ([2620:10d:c090:400::5:c2d])
        by smtp.gmail.com with ESMTPSA id f8sm227852pgc.75.2020.04.09.17.18.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 17:18:23 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: punt final io_ring_ctx wait-and-free to workqueue
Message-ID: <58c037cf-bd0b-cb10-d70a-1b23a6137850@kernel.dk>
Date:   Thu, 9 Apr 2020 17:18:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We can't reliably wait in io_ring_ctx_wait_and_kill(), since the
task_works list isn't ordered (in fact it's LIFO ordered). We could
either fix this with a separate task_works list for io_uring work, or
just punt the wait-and-free to async context. This ensures that
task_work that comes in while we're shutting down is processed
correctly. If we don't go async, we could have work past the fput()
work for the ring that depends on work that won't be executed until
after we're done with the wait-and-free. But as this operation is
blocking, it'll never get a chance to run.

This was reproduced with hundreds of thousands of sockets running
memcached, haven't been able to reproduce this synthetically.

Reported-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index be65eda059ac..6898b22f2323 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -326,6 +326,8 @@ struct io_ring_ctx {
 		spinlock_t		inflight_lock;
 		struct list_head	inflight_list;
 	} ____cacheline_aligned_in_smp;
+
+	struct work_struct		exit_work;
 };
 
 /*
@@ -862,6 +864,7 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		       int fd, struct file **out_file, bool fixed);
 static void __io_queue_sqe(struct io_kiocb *req,
 			   const struct io_uring_sqe *sqe);
+static void io_ring_exit_work(struct work_struct *work);
 
 static struct kmem_cache *req_cachep;
 
@@ -7271,6 +7274,17 @@ static int io_remove_personalities(int id, void *p, void *data)
 	return 0;
 }
 
+static void io_ring_exit_work(struct work_struct *work)
+{
+	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
+
+	if (ctx->rings)
+		io_cqring_overflow_flush(ctx, true);
+
+	wait_for_completion(&ctx->completions[0]);
+	io_ring_ctx_free(ctx);
+}
+
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
@@ -7298,8 +7312,8 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	if (ctx->rings)
 		io_cqring_overflow_flush(ctx, true);
 	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
-	wait_for_completion(&ctx->completions[0]);
-	io_ring_ctx_free(ctx);
+	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
+	queue_work(system_wq, &ctx->exit_work);
 }
 
 static int io_uring_release(struct inode *inode, struct file *file)

-- 
Jens Axboe

