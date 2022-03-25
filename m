Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E1A4E7D90
	for <lists+io-uring@lfdr.de>; Sat, 26 Mar 2022 01:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbiCYWn5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 18:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbiCYWn4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 18:43:56 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CE520A3B8
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 15:42:00 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y6so7124466plg.2
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 15:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=nihN5BDVBEq8m2cIN165GkewzAwA6kcN/6wdBSSk+yU=;
        b=u/XSCkdBFbHokltrB27RuKU8wFZ4YR9I4OKHnlrO75kkMJEaZ1tqVTz67A6ggB81QD
         w6Rw9WVVaxKnu4flUgkGAcjtlpkpj3dEMUeMTz1RR/T8SkKQEUioAybCIjxW9ONUGGRA
         IxjR9W7ZJzCzzsQBAlp97QXmJwH9dr4Mz4n6tGIm7ur1AdVFOSZQNJa3CiBvKaj73u7h
         3ozTR8bQY60pKP6dgQHSn6NYCEMj7eBYwqK1sImMqkQ/xeCZiIXpFVG82hbEGU1lGNpo
         SnknouHL6yYbyaO7/+l4ZqNrdxrnzxGC/4EJax8RGcNGx0cTwRy/392/DW6EPLjHH9tM
         7w/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=nihN5BDVBEq8m2cIN165GkewzAwA6kcN/6wdBSSk+yU=;
        b=RBFD6yp8LtbFPruFMQUUm0LOQ6llLUF4+N4fO6hbEsfyZxi2+3f7RNWtoIDYx5gtyz
         HQpHLbA67t3MygF3SuVZfifMNAivBaXuPe6iSt0lQHYQHl/+3tCEmklyFWu+japl8101
         IXie9NG83IyphBpV/XdqGLT9qO0pyK6TEJXNu9H7KObi2+a5aP2jSmATEvBa6dQhm2cS
         BIadia1HbekmBnBxNdN6bBqsLcwAMmfm7wQivO6YBpkOWuDDZuNgpR7Rimfc79GkWCwP
         iU8bcdDG1nQm6H2F7ilEO1hGAzjdsZBlkH3ns0aaV36gdeW74xt9oF+UCBae9UAPJTJ+
         eh1A==
X-Gm-Message-State: AOAM533B3OFOcbaLvZb0dsu5DqmYyz0+hP+egDuRsyzGHX2XE2kgQ0MA
        K277sozrucCNBhp262csAIuohvNqjCLektr1
X-Google-Smtp-Source: ABdhPJwrn8jvvcMJ52/ngdkbQCDdTNeqi8n5OqijPlgTUtBriIxEVYPtGtmTkp8hU+hmHt90Qyyu8g==
X-Received: by 2002:a17:902:9041:b0:14f:1c23:1eb1 with SMTP id w1-20020a170902904100b0014f1c231eb1mr13719760plz.173.1648248119519;
        Fri, 25 Mar 2022 15:41:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y24-20020a056a00181800b004fac7d687easm7580620pfa.66.2022.03.25.15.41.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 15:41:59 -0700 (PDT)
Message-ID: <500b6713-5661-a260-ee24-69270fc4b0f8@kernel.dk>
Date:   Fri, 25 Mar 2022 16:41:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: move finish_wait() outside of loop in
 cqring_wait()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't need to call this for every loop. This is particularly
troublesome if we are task_work intensive, and get woken more often than
we desire due to that.

Just do it at the end, that's always safe as we initialize the waitqueue
list head anyway. This can save a considerable amount of hammering on
the waitqueue lock, which is also hot from the request completion side.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 25aafb17d1e2..a83e7a036343 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8359,10 +8359,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
-		finish_wait(&ctx->cq_wait, &iowq.wq);
 		cond_resched();
 	} while (ret > 0);
 
+	finish_wait(&ctx->cq_wait, &iowq.wq);
 	restore_saved_sigmask_unless(ret == -EINTR);
 
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;

-- 
Jens Axboe

