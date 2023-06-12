Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9823C72B5CB
	for <lists+io-uring@lfdr.de>; Mon, 12 Jun 2023 05:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjFLDOP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Jun 2023 23:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbjFLDOO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Jun 2023 23:14:14 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E50ABB
        for <io-uring@vger.kernel.org>; Sun, 11 Jun 2023 20:14:12 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-53f567979baso479131a12.0
        for <io-uring@vger.kernel.org>; Sun, 11 Jun 2023 20:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686539651; x=1689131651;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNcNFxNzXBwvVIy5+C+ygu2yj6aUUudAjVRfi7pJQK8=;
        b=IENDW/xsdhGkLeA5Io+kvnL78fMYy2PPy9cF/zLHc/9Bq/2Glykz+X7U77ObaQyXam
         HwDcrCOW4lpsZg2tr/7qkbJk8J+shE/9lSPd94SvM8+qK3qlauIMrFKr7sUEQt17POzo
         WQGdBTM1hGHgJZd7HeyK4Q+hYNkKttz4PCy7p3bIpqaxqTohwXSFHfbMgWZeMAg1ThW5
         6qbvCaYD4BrI1U5M1o2EFO+tfyJs0Yu0by2Xs3MMu81zCFiiOqTvoRUDApdHKs9h6DZB
         1AdEH7WZEtyGRalbkVBXijsnz1fqpZb9nfbA+Hkj6fpSdXJzB+T2tPJBtTcq4l8QYjhP
         pzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686539651; x=1689131651;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UNcNFxNzXBwvVIy5+C+ygu2yj6aUUudAjVRfi7pJQK8=;
        b=VFm7eVNRIrJpnhzAXB5eOxx4UVCxjv/qMjjqbHt8XOclYurGjk9zbgIuSk+TmXZfS2
         j9Aaly/y5Wa+G12/Q5kL7gYVLSHpseSKQyUef6PNBLTW/vaPE2huOtg3Z3Dmv3aaeCgH
         GhFFT4bXPJv5McObbHiL7l8cCtuzQ3HAoN3GRs11f+9ufoVdL3W/D7ozbKB79aFxC9A/
         HrWo2cqlGdaO+TYmX8fBDRLNP3hCYGLiVuJ687vUteekLjiGMkW+FI0nARLiiYZeXTF9
         BE5gYEzbxuNQ9Xre+aQYNHsn/V7CgFbPAHJe2O+nLdRhy0sWaRR59ngky5r7AHSFT6Si
         5QvA==
X-Gm-Message-State: AC+VfDwTLv+CssPiWIPBYKNBs2n2pKmihLVV9HVfGxmCG/Bq8bbsDDym
        iwOXzSkr3jqey8/OUzo7oNV3MMeA1QLwnTKcMHw=
X-Google-Smtp-Source: ACHHUZ7uBtN8VQTUU5e6ee5wU31F78K8Qqirws+pOdSiGFBgLq139e7EeJ4KlzzMLhNvK4ESZCjEWQ==
X-Received: by 2002:a05:6a00:14c9:b0:662:a9c3:7b84 with SMTP id w9-20020a056a0014c900b00662a9c37b84mr8637487pfu.2.1686539651299;
        Sun, 11 Jun 2023 20:14:11 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f26-20020aa78b1a000000b00662c4ca18ebsm4487530pfd.128.2023.06.11.20.14.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jun 2023 20:14:10 -0700 (PDT)
Message-ID: <b0e4aaef-7088-56ce-244c-976edeac0e66@kernel.dk>
Date:   Sun, 11 Jun 2023 21:14:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: wait interruptibly for request completions on exit
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

WHen the ring exits, cleanup is done and the final cancelation and
waiting on completions is done by io_ring_exit_work. That function is
invoked by kworker, which doesn't take any signals. Because of that, it
doesn't really matter if we wait for completions in TASK_INTERRUPTIBLE
or TASK_UNINTERRUPTIBLE state. However, it does matter to the hung task
detection checker!

Normally we expect cancelations and completions to happen rather
quickly. Some test cases, however, will exit the ring and park the
owning task stopped (eg via SIGSTOP). If the owning task needs to run
task_work to complete requests, then io_ring_exit_work won't make any
progress until the task is runnable again. Hence io_ring_exit_work can
trigger the hung task detection, which is particularly problematic if
panic-on-hung-task is enabled.

As the ring exit doesn't take signals to begin with, have it wait
interruptibly rather than uninterruptibly. io_uring has a separate
stuck-exit warning that triggers independently anyway, so we're not
really missing anything by making this switch.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a467064da1af..f181876e415b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3121,7 +3121,18 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			/* there is little hope left, don't run it too often */
 			interval = HZ * 60;
 		}
-	} while (!wait_for_completion_timeout(&ctx->ref_comp, interval));
+		/*
+		 * This is really an uninterruptible wait, as it has to be
+		 * complete. But it's also run from a kworker, which doesn't
+		 * take signals, so it's fine to make it interruptible. This
+		 * avoids scenarios where we knowingly can wait much longer
+		 * on completions, for example if someone does a SIGSTOP on
+		 * a task that needs to finish task_work to make this loop
+		 * complete. That's a synthetic situation that should not
+		 * cause a stuck task backtrace, and hence a potential panic
+		 * on stuck tasks if that is enabled.
+		 */
+	} while (!wait_for_completion_interruptible_timeout(&ctx->ref_comp, interval));
 
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
@@ -3145,7 +3156,12 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			continue;
 
 		mutex_unlock(&ctx->uring_lock);
-		wait_for_completion(&exit.completion);
+		/*
+		 * See comment above for
+		 * wait_for_completion_interruptible_timeout() on why this
+		 * wait is marked as interruptible.
+		 */
+		wait_for_completion_interruptible(&exit.completion);
 		mutex_lock(&ctx->uring_lock);
 	}
 	mutex_unlock(&ctx->uring_lock);

-- 
Jens Axboe

