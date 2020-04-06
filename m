Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97BC019FE6B
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2020 21:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgDFTtE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 15:49:04 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34897 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgDFTtE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Apr 2020 15:49:04 -0400
Received: by mail-pl1-f196.google.com with SMTP id c12so262250plz.2
        for <io-uring@vger.kernel.org>; Mon, 06 Apr 2020 12:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7NEzkIHpmifIAdJKIOyUKatCloaSvqetkF9dALnk3rM=;
        b=0FklYUsB4RVrTFxTCnfMjp/zQzFcZkZSUk7nv3CzFf0uDAkSd05ql2PwqbksDoEYKS
         aAnZd48nbzwwRKmqn5uCO/3UKQVrv9lAnfIhdebn/CMiULwVjf1l9IvfHb+JUIXoDVX6
         DUdRd0hdY2uZ3yiMW4efJpS92VOo71f75nw2i52B1hoKgDMPJiDPSvEHkVeP5dE43ZAH
         d0wWBS4KQQAWhGmSmB/Ls6UPmVBhvN5iYAiWBQAhHaezaRoN27TxIhprXkz5vxb4mAp9
         049vc9QInn3qgKMgsrjwUWp/briVYB+HveKHkbv+M3RZXAoUZjM7p9r8fH2S6MttHRbn
         0yHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7NEzkIHpmifIAdJKIOyUKatCloaSvqetkF9dALnk3rM=;
        b=R0g+fv16N+KQn/7D7ReIm4hcPaI02ZqrqbrBxIkTMGAD6X1bMs9Zkzjef+n+KSHymY
         ZR5qwSbmfUMToGKjCyTpiMS++ssj/85xM/o0WluVealMZU9+DPgQIlFgW3GBFplFuXya
         T7bTvH92bkKro0fObSBgFELV2cZ+rCU3PeKvmJCeY3+TG0bpikf+S+pbYyE+KsQ47s71
         oesRhW3ubkNX/MNXG7ETV+YL9zP9QCZzMEDV3vPQ1N5RjIUq+A/HWbKjucPlyYnpJOc9
         xxxnSxt/6USyhmidEhq8VcQpw/TTPnZI5aYqKwav/SQ7y/t2flNv0eF4vU7ABU2C20E4
         9ddQ==
X-Gm-Message-State: AGi0PuYNfcxdkNQXwSe9okDA67IuoutwtqAH3WLDb8e3ONKZD875JAHc
        5oY1T41/7vJTsu5H4wQ9OFTqAGfe2YEvPA==
X-Google-Smtp-Source: APiQypLuMb85mQMzFWfxJSBUrnPN2v6O6XqBmKpgbcU+NiFi8Co6/PNJIsWp6AxxS/+DBiMXIbotVg==
X-Received: by 2002:a17:902:784c:: with SMTP id e12mr21687548pln.191.1586202541141;
        Mon, 06 Apr 2020 12:49:01 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:7d7c:3a38:f0f8:3951])
        by smtp.gmail.com with ESMTPSA id g11sm362620pjs.17.2020.04.06.12.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 12:49:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     peterz@infradead.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: flush task work before waiting for ring exit
Date:   Mon,  6 Apr 2020 13:48:53 -0600
Message-Id: <20200406194853.9896-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200406194853.9896-1-axboe@kernel.dk>
References: <20200406194853.9896-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We could have triggered task work when we removed poll completions.
It's now safe to unconditionally call task_work_run() since it checks
for the exited task work, do so in case we have pending items there.
Ensure we do so before flushing the CQ ring overflow.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1579390c7c53..183bd28761e3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7295,10 +7295,13 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_wq_cancel_all(ctx->io_wq);
 
 	io_iopoll_reap_events(ctx);
+	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
+	task_work_run();
+
 	/* if we failed setting up the ctx, we might not have any rings */
 	if (ctx->rings)
 		io_cqring_overflow_flush(ctx, true);
-	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
+
 	wait_for_completion(&ctx->completions[0]);
 	io_ring_ctx_free(ctx);
 }
-- 
2.26.0

