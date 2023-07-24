Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5737075FECC
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 20:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjGXSHf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 14:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjGXSHf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 14:07:35 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11610C0
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 11:07:34 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-34637e55d9dso3537955ab.1
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 11:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690222053; x=1690826853;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jO28P/+2NVROk2prJEYrniKIJnTiw2Z68h9YGxxOpas=;
        b=InxJUioR341MRDBLC12DqqtbMJNl7rnP3imlRPGkzmbtqhk+Gv499W8dBZc2DOgQLz
         Byot/gz83+qczCMuBeYu/vp+X10kwBd4tnw7m4PHXLVxer4QcqioxCVY4fpPm6vnfm0O
         s08kMuqt1KttPWB723BIJpgeXH3UVjHp0RWExP7VIILSl8Pl5VB6TLjbYdRWzNGhQMxA
         II1nWw+xNO7A6MIORT9Py/1iD8UTdqNq0osMcj9z0FIhQNQtqpTBqMfgLn6s5lvLcTGv
         2/elz/1WNLHc6tNzXgAiLGATNdawKwtJ0pa5K0cvf8d2xqJY0Gw0dVhVLmDBwigUbBdq
         vbNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690222053; x=1690826853;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jO28P/+2NVROk2prJEYrniKIJnTiw2Z68h9YGxxOpas=;
        b=hkGYAmPRrsne0StwQuINX0WAkRHY7usBTqS8V+dplZzdnk8F+rsO6FGc5dDtKF1MCx
         DGy9VXFLg0gIBA4tZSCcuF/xP6QmiyepqvC1Hai7NDycvjhY9EAtxV5cyq7nycxvDcPs
         12g2zb/8PfZz39f4EwUQoUUYHgC/8Bsw8YymFl7UIEh6FLfMP/pJZhEp/LmQvt1TS5nN
         1WxnAybMJ/PPujFVSlMpkY3pA1+ponT95dsd4pUDJLFVpxayQo7PZltmqzfSwVkNIK9/
         v6l57kidyFU7m3ZnqWlEnUiEKrLIncCyk4Ei8bwD/3WabvgBkEt4urTW6m+qg02kVrQg
         zogQ==
X-Gm-Message-State: ABy/qLbeYHatJ6aLkyM1piO5LndnxzjvuKp1/ZGo9rhlPHhH+tpxIvGm
        pK5d9A/fjJGNEhk6HCpGVxB+6+Tw+YTCVxufD/A=
X-Google-Smtp-Source: APBJJlGH0hqrt+xkbYD4NoodeV5V0GxeVE/ECA/fB6hWBXTQzDJhiitHnoujcpQ87Mx+Lj75EGnv6A==
X-Received: by 2002:a92:d785:0:b0:346:1919:7cb1 with SMTP id d5-20020a92d785000000b0034619197cb1mr6504921iln.2.1690222052878;
        Mon, 24 Jul 2023 11:07:32 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p18-20020a92c112000000b00348bfc1d93esm1919789ile.82.2023.07.24.11.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 11:07:32 -0700 (PDT)
Message-ID: <96d20c01-86fb-4c42-514b-7c38b95060a0@kernel.dk>
Date:   Mon, 24 Jul 2023 12:07:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: gate iowait schedule on having pending requests
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        Genes Lists <lists@sapience.com>,
        Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A previous commit made all cqring waits marked as iowait, as a way to
improve performance for short schedules with pending IO. However, for
use cases that have a special reaper thread that does nothing but
wait on events on the ring, this causes a cosmetic issue where we
know have one core marked as being "busy" with 100% iowait.

While this isn't a grave issue, it is confusing to users. Rather than
always mark us as being in iowait, gate setting of current->in_iowait
to 1 by whether or not the waiting task has pending requests.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/io-uring/CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com/
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217699
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217700
Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reported-by: Phil Elwell <phil@raspberrypi.com>
Tested-by: Andres Freund <andres@anarazel.de>
Fixes: 8a796565cec3 ("io_uring: Use io_schedule* in cqring wait")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 89a611541bc4..f4591b912ea8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2493,11 +2493,20 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 	return 0;
 }
 
+static bool current_pending_io(void)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (!tctx)
+		return false;
+	return percpu_counter_read_positive(&tctx->inflight);
+}
+
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq)
 {
-	int token, ret;
+	int io_wait, ret;
 
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
@@ -2511,17 +2520,19 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		return 0;
 
 	/*
-	 * Use io_schedule_prepare/finish, so cpufreq can take into account
-	 * that the task is waiting for IO - turns out to be important for low
-	 * QD IO.
+	 * Mark us as being in io_wait if we have pending requests, so cpufreq
+	 * can take into account that the task is waiting for IO - turns out
+	 * to be important for low QD IO.
 	 */
-	token = io_schedule_prepare();
+	io_wait = current->in_iowait;
+	if (current_pending_io())
+		current->in_iowait = 1;
 	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
 	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
 		ret = -ETIME;
-	io_schedule_finish(token);
+	current->in_iowait = io_wait;
 	return ret;
 }
 
-- 
Jens Axboe

