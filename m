Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B4477AA3D
	for <lists+io-uring@lfdr.de>; Sun, 13 Aug 2023 19:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjHMRJk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Aug 2023 13:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjHMRJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Aug 2023 13:09:31 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FB9E6C
        for <io-uring@vger.kernel.org>; Sun, 13 Aug 2023 10:09:33 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-5657ca46a56so383669a12.0
        for <io-uring@vger.kernel.org>; Sun, 13 Aug 2023 10:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691946572; x=1692551372;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DEFRP7ttD5taPpHOtAgu63t2DGnGiUvJFMrH96PrvN0=;
        b=JjCAvtTXCltJtVYQGWYIt0eTKhYOD399Mbm2SdHfI5YvpYvkbU6vypakuDRUQvWqZ1
         KPbz0RAQxvpAYGkSC1FcqU6eukcIOWQinFE/yNRZj8FzqZ3Y3idWVoJ1GGK0DOSHRxVe
         gNQbPcM75f6Kv3t2UwHZ7GD39l1ELgI4F1EtU8IvMNGAamAWOJuCVgFPi7hSFwx3LwTD
         TgiT3qeRVwvsrjjuI6PWmkPHA+ybp1Oh6de5MNk3fp1hqdeiz4f4XbtyOmpGgI1Z5S+9
         QwN0Swdd5wa8sPdIcMv3VNW/kseslGywihmAAe0UjZSCeFp++FprNNAfbw8Y+4EUV+G6
         jjjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691946572; x=1692551372;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DEFRP7ttD5taPpHOtAgu63t2DGnGiUvJFMrH96PrvN0=;
        b=cMox/9JgNWY0yZqJ4kMa+7xvfdbcphG9kWKPmegxkZjnSQOKpWk4CxGBWsPPEfnZmF
         UBlFhGwk0hVTiAk+YiuxmTHHVWrUOkJ+6m87hiSRbReL9rhtJ8yIepuyFYPQWDaWukj9
         bSNdGmI+qhbz1HJ/SCtWJ4RtrcdI/mAfTzL5V29UWWot72lDuYfMO+w/s1y0aMreVAkf
         PWEGqqjn5a+ij6fqnLnsesCDW4LmZ2Ub7Bno+338OOJupAFIeA4dGjvbL7sIWfbIXHbq
         8AYw0W9JqFlTsWXbqWAQuGwi4sFR52TjSDehSqdSz+HL06fXCFF9CUDyYpFJSP5hffFs
         Odig==
X-Gm-Message-State: AOJu0YyJ8UmHVv7Ul1gd0maBD0i4JOeG5NocQBWDdNFbRmKEwprANbLp
        LgRWxU6oWHEMvrgZYADk7rl2Enl7+V+45S6H+fU=
X-Google-Smtp-Source: AGHT+IHE2CTHOdfFaMKZi96ohEZALtDhOiRrE3U75KSjo7SzLsuMRyGhIJ2KHX8FK2WEEnoknt+HEw==
X-Received: by 2002:a17:903:248:b0:1b8:9215:9163 with SMTP id j8-20020a170903024800b001b892159163mr9004136plh.6.1691946572115;
        Sun, 13 Aug 2023 10:09:32 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j2-20020a170902da8200b001bc7306d321sm7654931plx.282.2023.08.13.10.09.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Aug 2023 10:09:31 -0700 (PDT)
Message-ID: <6c1dd23b-83ad-48b7-baed-4cbbfb1b3236@kernel.dk>
Date:   Sun, 13 Aug 2023 11:09:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/sqpoll: fix io-wq affinity when IORING_SETUP_SQPOLL
 is used
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we setup the ring with SQPOLL, then that polling thread has its
own io-wq setup. This means that if the application uses
IORING_REGISTER_IOWQ_AFF to set the io-wq affinity, we should not be
setting it for the invoking task, but rather the sqpoll task.

Add an sqpoll helper that parks the thread and updates the affinity,
and use that one if we're using SQPOLL.

Cc: stable@vger.kernel.org # 5.10+
Link: https://github.com/axboe/liburing/discussions/884
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 93db3e4e7b68..4afee22b7bda 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4200,13 +4200,9 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
 				       void __user *arg, unsigned len)
 {
-	struct io_uring_task *tctx = current->io_uring;
 	cpumask_var_t new_mask;
 	int ret;
 
-	if (!tctx || !tctx->io_wq)
-		return -EINVAL;
-
 	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
 		return -ENOMEM;
 
@@ -4227,7 +4223,21 @@ static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	}
 
-	ret = io_wq_cpu_affinity(tctx->io_wq, new_mask);
+	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
+		struct io_uring_task *tctx = current->io_uring;
+
+		if (!tctx || !tctx->io_wq) {
+			free_cpumask_var(new_mask);
+			return -EINVAL;
+		}
+
+		ret = io_wq_cpu_affinity(tctx->io_wq, new_mask);
+	} else {
+		mutex_unlock(&ctx->uring_lock);
+		ret = io_sqpoll_wq_cpu_affinity(ctx, new_mask);
+		mutex_lock(&ctx->uring_lock);
+	}
+
 	free_cpumask_var(new_mask);
 	return ret;
 }
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 5e329e3cd470..79a41fdfb899 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -421,3 +421,21 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 	io_sq_thread_finish(ctx);
 	return ret;
 }
+
+__cold int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx,
+				     cpumask_var_t mask)
+{
+	struct io_sq_data *sqd = ctx->sq_data;
+	int ret = -EINVAL;
+
+	if (sqd) {
+		struct task_struct *task;
+
+		io_sq_thread_park(sqd);
+		task = sqd->thread;
+		ret = io_wq_cpu_affinity(task->io_uring->io_wq, mask);
+		io_sq_thread_unpark(sqd);
+	}
+
+	return ret;
+}
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index e1b8d508d22d..8df37e8c9149 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -27,3 +27,4 @@ void io_sq_thread_park(struct io_sq_data *sqd);
 void io_sq_thread_unpark(struct io_sq_data *sqd);
 void io_put_sq_data(struct io_sq_data *sqd);
 void io_sqpoll_wait_sq(struct io_ring_ctx *ctx);
+int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx, cpumask_var_t mask);

-- 
Jens Axboe

