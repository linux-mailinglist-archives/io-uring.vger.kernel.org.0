Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA6621B951
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 17:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgGJPUW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 11:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbgGJPQH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 11:16:07 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE781C08C5CE
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2020 08:16:06 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id f23so6391921iof.6
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2020 08:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=H/trGt9KEM1ElRJQBjVEiIdJlJutnwgRbsT2hQmc9WI=;
        b=q4ERu6el+8+VA6VQsm6WJGjIMOMVCDffdzEiw4rFnj8RKB24oMZLCEfr8uzZtl/yf8
         uRlrrK3S90VFm6jNhi5bmiJ5xMwEed0JiyQNPaQq+yFx4AGAkXfWsmw2zzuGR2SsPDAu
         U/8ZkevfWray7DcJEIrbqXsyy5tdLWkz36KAKdGps2V9Ng6sYxMsBIfz6sQoMxHDS7Fq
         qDsFQi20Q1wI0CyTK0V5zcxr9KTkg8vYQV6eN6AZYEgmnBTk2LKEncQxiIvcPXd/T2Uq
         z/k66WZZBGqh2Ay11pBvSoKi77sWiH0csWuKdRvbl6pPbeEatwmM04jeDBtTfXfHXnwW
         kiAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=H/trGt9KEM1ElRJQBjVEiIdJlJutnwgRbsT2hQmc9WI=;
        b=tTf0bL4y2mTN9wVYL3CmOuM5VlQK7BkgDF5FbgGpVSWQAthRAylDU//e2Tiz4IV6al
         BNIDRiWJ9ne1uxUrQvBcDAVw0elil8nLg5J+fKdfvSVXgNQ7fKElOn64zQQiSGrParjc
         VMq5wo0+DAB/V+o8ajRDAd9df5IabCJ2znC7UuWP9G8Z/7WaSJShQ04ypJoxs4S8lQIp
         wmOnzwcFqVqSreu5Peivu1S1t50CysPdlr0G0Y7tI09r0JR6nB704ioI/zvV2En8O57P
         4rzAABLmCZhK6urJmY7l4WKzR+r1SE8lxfHoIXFQraqCWiYE0E0JyZgR9F4a2Lt7uyna
         43iQ==
X-Gm-Message-State: AOAM532QdkdpH98TpQgo+FNOHDfI+1rSNc7qLXdOmBKVui68wPVlvgqs
        3fnmsvH3pfZ8rJVjWQzWDzYy6e67dho8sQ==
X-Google-Smtp-Source: ABdhPJxNICfC1ct2xHZcX+emwcK9hukozJrBS95+VQcn0g54hs3KsZR9whUZx5LfkmMsElzMsKSI2g==
X-Received: by 2002:a5e:9309:: with SMTP id k9mr47021051iom.135.1594394165882;
        Fri, 10 Jul 2020 08:16:05 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c25sm3812272ioi.13.2020.07.10.08.16.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 08:16:05 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: account user memory freed when exit has been queued
Message-ID: <4697ab97-eea1-11b2-00a6-c612663eefed@kernel.dk>
Date:   Fri, 10 Jul 2020 09:16:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently account the memory after the exit work has been run, but
that leaves a gap where a process has closed its ring and until the
memory has been accounted as freed. If the memlocked ulimit is
borderline, then that can introduce spurious setup errors returning
-ENOMEM because the free work hasn't been run yet.

Account this as freed when we close the ring, as not to expose a tiny
gap where setting up a new ring can fail.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc07baf4392a..ca8abde48b6c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7351,9 +7351,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_mem_free(ctx->sq_sqes);
 
 	percpu_ref_exit(&ctx->refs);
-	if (ctx->account_mem)
-		io_unaccount_mem(ctx->user,
-				ring_pages(ctx->sq_entries, ctx->cq_entries));
 	free_uid(ctx->user);
 	put_cred(ctx->creds);
 	kfree(ctx->cancel_hash);
@@ -7438,6 +7435,16 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	if (ctx->rings)
 		io_cqring_overflow_flush(ctx, true);
 	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
+
+	/*
+	 * Do this upfront, so we won't have a grace period where the ring
+	 * is closed but resources aren't reaped yet. This can cause
+	 * spurious failure in setting up a new ring.
+	 */
+	if (ctx->account_mem)
+		io_unaccount_mem(ctx->user,
+				ring_pages(ctx->sq_entries, ctx->cq_entries));
+
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	queue_work(system_wq, &ctx->exit_work);
 }

-- 
Jens Axboe

