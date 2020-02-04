Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C4A152397
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 00:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbgBDXwA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Feb 2020 18:52:00 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:52124 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbgBDXwA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Feb 2020 18:52:00 -0500
Received: by mail-pj1-f68.google.com with SMTP id fa20so137822pjb.1
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2020 15:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=c1JNrD3fLaj2h0zL4XJH4eweWh5Y487rQMPT7kfPr4k=;
        b=rLfKdRHxqwPw2KSgPV4jXL21L2KY7tnM0DHHGJuqZonHUzYOO8zqNZQErVVgzs4c5G
         Rn8KevIY62SZxWIZiU/q+HlbCDAjhYEifYwB25mt2U82d7E+79ioaVBRD7KBrNeLpJjp
         fGz7tQxC1/NGPrADTxv3kP+4tMl2yqReyVefL1XxdQjYynEBC4Olpq4xkCKZxjtD1hq/
         MSANMz6mk3kDCIbh47drUFMpyhj3ZmqFVuFwN9NCfVAwd1eKIi/UK1BpQK4PF9xTnGaf
         G9/AINTnDSGk6nQPl/hmZRLD6s1dQFYOPrKpzIFafC9igZqZcGGZzhbFzWmyz/1Tnc2D
         ozoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=c1JNrD3fLaj2h0zL4XJH4eweWh5Y487rQMPT7kfPr4k=;
        b=eVitS7U5q47ceLqMYgqYB1eMunPFqsEL38GazGxvxbt53P6fRxFsS2YFbWzYrTuUcW
         3icMpW0KNU/PorVbcIF++EsiIaxHU90GY9eJEXLF3zbFm2caIicYt+8Jx4wawjivmZjT
         KuLaX0RD29xU71dbZsF04hRpIbLQf2DH5HHX52aZqRdTgnl4rv7DdzvF5PDRJJhgVnHK
         9+g6edv5/C6KfIJg6MXwcVGWk9AfabcHNHI7/YzDyoZWEa1cTLJB65RcWxBj7a5yzIYL
         wKo7HUK+Nu+ZwTwQGCeJahYSW9BFLNttpJjqCL883QbnB8JeRBwWgdX3bw86MS0zBk7+
         aPnA==
X-Gm-Message-State: APjAAAWYHYFNznN3Z1BiBfUszI8t76MUW7+UYdxJYjH/D9X057ePdCbM
        4V2gw2lKNH8X/QvLrWJGbYXKwPH8FJU=
X-Google-Smtp-Source: APXvYqzzaIVLF9v8+MYcz4pYlKDNRKUmjm8x0BfocH+0j0oxvP7IaiM3I63gANSnwy86emBtxWR4YQ==
X-Received: by 2002:a17:902:54f:: with SMTP id 73mr9681853plf.255.1580860319102;
        Tue, 04 Feb 2020 15:51:59 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id m128sm25969293pfm.183.2020.02.04.15.51.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 15:51:58 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: spin for sq thread to idle on shutdown
Message-ID: <9b6fab90-e512-f196-1fdb-918f9fee8c16@kernel.dk>
Date:   Tue, 4 Feb 2020 16:51:56 -0700
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

As part of io_uring shutdown, we cancel work that is pending and won't
necessarily complete on its own. That includes requests like poll
commands and timeouts.

If we're using SQPOLL for kernel side submission and we shutdown the
ring immediately after queueing such work, we can race with the sqthread
doing the submission. This means we may miss cancelling some work, which
results in the io_uring shutdown hanging forever.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index edb00ae2619b..87f8655656b5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5070,7 +5070,8 @@ static int io_sq_thread(void *data)
 			 * reap events and wake us up.
 			 */
 			if (inflight ||
-			    (!time_after(jiffies, timeout) && ret != -EBUSY)) {
+			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
+			    !percpu_ref_is_dying(&ctx->refs))) {
 				cond_resched();
 				continue;
 			}
@@ -6324,6 +6325,16 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	percpu_ref_kill(&ctx->refs);
 	mutex_unlock(&ctx->uring_lock);
 
+	/*
+	 * Wait for sq thread to idle, if we have one. It won't spin on new
+	 * work after we've killed the ctx ref above. This is important to do
+	 * before we cancel existing commands, as the thread could otherwise
+	 * be queueing new work post that. If that's work we need to cancel,
+	 * it could cause shutdown to hang.
+	 */
+	while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
+		cpu_relax();
+
 	io_kill_timeouts(ctx);
 	io_poll_remove_all(ctx);
 
-- 
Jens Axboe

