Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C0B652600
	for <lists+io-uring@lfdr.de>; Tue, 20 Dec 2022 19:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiLTSHZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Dec 2022 13:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiLTSHX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Dec 2022 13:07:23 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83965E2C
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 10:07:22 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id bg10so9375198wmb.1
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 10:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SVkMWfMGXHs6AMCmUCdK3NM355Q9/BeT9d4ctHay5Wk=;
        b=Ik4dJNWSel+hXcFE9v4267WltbCimOvY9m9c2Mgk+64+elmsAbmD6FKnTvfG7AG2kq
         nIoxwzAGUzkzrjVliZHUsElwpHF18LOSgZ4nFGcSp1cSyuTYPpMwzl7wNRXXl1rS9ohs
         DatczKosYX6Gm8NPnM4WUGSvT9NCfoHcLhKeYs9S5LqdpMPiArI2baozgdu2da++DwNX
         pScD+41SKZtqobjt2kqo8KiFokXdby53sAslru1sWo22gmc/m5vyMk9ZLuXS7IwijWMA
         vxZx5iyDX8Z684uCAX/I4Ti82zBHJQsk1WKPgeYOEya+Bh/X+9pB+X3Hz7/wItke/FAz
         nJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SVkMWfMGXHs6AMCmUCdK3NM355Q9/BeT9d4ctHay5Wk=;
        b=YmAPaGAezLNNmosYqud46Rd0TuP1bYL0a7aLs9Dfdp6XKBfiJTuzh+rGwQviNcpgMb
         v45dyTvgD6Oyznkvjed7GJhjGYElVyYpMsgb+qtucj69eIboud4rA/iSA3YflkZJnzK5
         AcS0Rhjj8h/0+M52GEQRy0MgHfSWB8F8/COzqVJHLzWwgGPd2wq/gQLdDbamt0R+WYQw
         jdVo9TPgKkpt+uOAiAhCGOFo8aeJ9a/juvYc8v9s3tUuitl3JtZi1jRgSOiLxk3ry0eS
         4r5pX78+v5a4sSEjy4wT936+neW/y8sUo2Ns/4KPT3bj0EgaadjI+GjANvhbn8yod8Tx
         x8SQ==
X-Gm-Message-State: AFqh2kpe0Jb1lqWtbahbyB0Kll4zCLonxQnYwuNOVOo3U8+pjjTif8TC
        MLOdO0zbnWiQEqT3pZVg/MhIGfgXjMY=
X-Google-Smtp-Source: AMrXdXsi2Qb/GXHJyAAoXtFLsFUIPry9jIpDvtP+jXnE18XBn+20+z8LatosQEjlYqs3w/of8IJvNQ==
X-Received: by 2002:a05:600c:3acd:b0:3d0:7415:c5a9 with SMTP id d13-20020a05600c3acd00b003d07415c5a9mr2342608wms.21.1671559640628;
        Tue, 20 Dec 2022 10:07:20 -0800 (PST)
Received: from [192.168.8.100] (188.28.109.17.threembb.co.uk. [188.28.109.17])
        by smtp.gmail.com with ESMTPSA id j16-20020a05600c1c1000b003d34faca949sm13091822wms.39.2022.12.20.10.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 10:07:20 -0800 (PST)
Message-ID: <7e983688-5fcf-a1fd-3422-4baed6a0cb89@gmail.com>
Date:   Tue, 20 Dec 2022 18:06:20 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC] io_uring: wake up optimisations
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <81104db1a04efbfcec90f5819081b4299542671a.1671559005.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <81104db1a04efbfcec90f5819081b4299542671a.1671559005.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/20/22 17:58, Pavel Begunkov wrote:
> NOT FOR INCLUSION, needs some ring poll workarounds
> 
> Flush completions is done either from the submit syscall or by the
> task_work, both are in the context of the submitter task, and when it
> goes for a single threaded rings like implied by ->task_complete, there
> won't be any waiters on ->cq_wait but the master task. That means that
> there can be no tasks sleeping on cq_wait while we run
> __io_submit_flush_completions() and so waking up can be skipped.

Not trivial to benchmark as we need something to emulate a task_work
coming in the middle of waiting. I used the diff below to complete nops
in tw and removed preliminary tw runs for the "in the middle of waiting"
part. IORING_SETUP_SKIP_CQWAKE controls whether we use optimisation or
not.

It gets around 15% more IOPS (6769526 -> 7803304), which correlates
to 10% of wakeup cost in profiles. Another interesting part is that
waitqueues are excessive for our purposes and we can replace cq_wait
with something less heavier, e.g. atomic bit set



diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9d4c4078e8d0..5a4f03a4ea40 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -164,6 +164,7 @@ enum {
   * try to do it just before it is needed.
   */
  #define IORING_SETUP_DEFER_TASKRUN	(1U << 13)
+#define IORING_SETUP_SKIP_CQWAKE	(1U << 14)
  
  enum io_uring_op {
  	IORING_OP_NOP,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a57b9008807c..68556dea060b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -631,7 +631,7 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
  	 * it will re-check the wakeup conditions once we return we can safely
  	 * skip waking it up.
  	 */
-	if (!ctx->task_complete) {
+	if (!(ctx->flags & IORING_SETUP_SKIP_CQWAKE)) {
  		smp_mb();
  		__io_cqring_wake(ctx);
  	}
@@ -2519,18 +2519,6 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
  	if (!io_allowed_run_tw(ctx))
  		return -EEXIST;
  
-	do {
-		/* always run at least 1 task work to process local work */
-		ret = io_run_task_work_ctx(ctx);
-		if (ret < 0)
-			return ret;
-		io_cqring_overflow_flush(ctx);
-
-		/* if user messes with these they will just get an early return */
-		if (__io_cqring_events_user(ctx) >= min_events)
-			return 0;
-	} while (ret > 0);
-
  	if (sig) {
  #ifdef CONFIG_COMPAT
  		if (in_compat_syscall())
@@ -3345,16 +3333,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
  			mutex_unlock(&ctx->uring_lock);
  			goto out;
  		}
-		if (flags & IORING_ENTER_GETEVENTS) {
-			if (ctx->syscall_iopoll)
-				goto iopoll_locked;
-			/*
-			 * Ignore errors, we'll soon call io_cqring_wait() and
-			 * it should handle ownership problems if any.
-			 */
-			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
-				(void)io_run_local_work_locked(ctx);
-		}
  		mutex_unlock(&ctx->uring_lock);
  	}
  
@@ -3721,7 +3699,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
  			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
  			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
  			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
-			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN))
+			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
+			IORING_SETUP_SKIP_CQWAKE))
  		return -EINVAL;
  
  	return io_uring_create(entries, &p, params);
diff --git a/io_uring/nop.c b/io_uring/nop.c
index d956599a3c1b..77c686de3eb2 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -20,6 +20,6 @@ int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
   */
  int io_nop(struct io_kiocb *req, unsigned int issue_flags)
  {
-	io_req_set_res(req, 0, 0);
-	return IOU_OK;
+	io_req_queue_tw_complete(req, 0);
+	return IOU_ISSUE_SKIP_COMPLETE;
  }

-- 
Pavel Begunkov
