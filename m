Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86A164FD90
	for <lists+io-uring@lfdr.de>; Sun, 18 Dec 2022 04:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiLRDhu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Dec 2022 22:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiLRDht (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Dec 2022 22:37:49 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AAA63A0
        for <io-uring@vger.kernel.org>; Sat, 17 Dec 2022 19:37:48 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id t2so6005648ply.2
        for <io-uring@vger.kernel.org>; Sat, 17 Dec 2022 19:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JPmdFVBSoUDHdzKu3vEBt3ct1YMR2xZ0PuL8XRBEkvk=;
        b=kaUNtbIGT0anW2ai69S0A6Y1oqKMf0ju4YuCzl6ZWxEr70QLF/XALj6ZSqv9+JZ7fZ
         0FX6v7+26ZRu5+KrEnwh44ZqUpebmjic43uW19NE+onCPr6iIyZ1fbCaBxheetW3tRQL
         ByzIlQBUhnt9fdZvYd6cyB5EIymcfJOiJ83Elrxo+RfuUC9ukTr5N+JGhsHvUc4OELHH
         N7G1M+XY37lQ2HuHuXmzf/wUJSDYT0H4HdTxBMtxo4G6ZqkPXjKdRBVDVkMWH2E+Ofmn
         ZKBBsVHk82MGpu7RVwqptEpZ0D1qp+u3+1WsWZw4en5yWX3fHtSCx0oUuTlo6G2iPR4W
         mt0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPmdFVBSoUDHdzKu3vEBt3ct1YMR2xZ0PuL8XRBEkvk=;
        b=PI1JeqsiVN7hiC1VYINVoGOVwEMQmUm4LGlY3lMrgwc856D3gQOB+5fJeiXKdmJkBs
         xQuzf13DkYU/ev1hZcRJlHFwDqoQg7DcV1zfdHG2PCj+jWCg6180k2Juq25c09T8NQdH
         Dj+82StOE+xOfIO9AVv9VJdeT3Aa7S7HTX1rnf9FQzB0b/6eOvwk1sOxqhXT3ABh6qS4
         JHu2kaSuwiPenis3eDmUZRLG3+vAXHzTODLN7F73ARy1Bm031z6OcsG6lWjECeXIvKKJ
         j+aZgPq/+4IntXKk/6E7y20tL2eP9Pn1Mx+fpBt6Yd37sxzeeKkJqZ7w13Nr5jUAYa8U
         cwIA==
X-Gm-Message-State: ANoB5pna42bA/JKtvqrfN7ZjQ2nZ6FFVcdAtl0xIC1TWDA3B9/rstxi7
        Qpfh+weUEICRQGGvGhqlWwEkSZwmv76K3JxxXlo=
X-Google-Smtp-Source: AA0mqf50gmOVvf+xYzPfiklaoYgbTu0lSAAmzosax6Z98Zs7O1WtfeMKHMdYdt4Ul4AJjkLFWxznWw==
X-Received: by 2002:a17:902:bb83:b0:18f:5749:cae9 with SMTP id m3-20020a170902bb8300b0018f5749cae9mr6233534pls.2.1671334666796;
        Sat, 17 Dec 2022 19:37:46 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ij23-20020a170902ab5700b00186b1bfbe79sm4267123plb.66.2022.12.17.19.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Dec 2022 19:37:46 -0800 (PST)
Message-ID: <6188336d-78c6-3e1a-5967-24b2afbaaf25@kernel.dk>
Date:   Sat, 17 Dec 2022 20:37:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: [PATCH v2 2/2] io_uring: include task_work run after scheduling in
 wait for events
To:     io-uring@vger.kernel.org
Cc:     dylany@meta.com, asml.silence@gmail.com
References: <20221217204840.45213-1-axboe@kernel.dk>
 <20221217204840.45213-3-axboe@kernel.dk>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221217204840.45213-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's quite possible that we got woken up because task_work was queued,
and we need to process this task_work to generate the events waited for.
If we return to the wait loop without running task_work, we'll end up
adding the task to the waitqueue again, only to call
io_cqring_wait_schedule() again which will run the task_work. This is
less efficient than it could be, as it requires adding to the cq_wait
queue again. It also triggers the wakeup path for completions as
cq_wait is now non-empty with the task itself, and it'll require another
lock grab and deletion to remove ourselves from the waitqueue.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: tweak return value so we don't potentially return early from
    waiting on events, if we had nothing to do post returning from
    schedule.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 16a323a9ff70..ff2bbac1a10f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2481,7 +2481,14 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	}
 	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
-	return 1;
+
+	/*
+	 * Run task_work after scheduling. If we got woken because of
+	 * task_work being processed, run it now rather than let the caller
+	 * do another wait loop.
+	 */
+	ret = io_run_task_work_sig(ctx);
+	return ret < 0 ? ret : 1;
 }
 
 /*
@@ -2546,6 +2553,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+		if (__io_cqring_events_user(ctx) >= min_events)
+			break;
 		cond_resched();
 	} while (ret > 0);

-- 
Jens Axboe

