Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F6A77ADAB
	for <lists+io-uring@lfdr.de>; Sun, 13 Aug 2023 23:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjHMVuO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Aug 2023 17:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbjHMVtV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Aug 2023 17:49:21 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B88D1BE4
        for <io-uring@vger.kernel.org>; Sun, 13 Aug 2023 14:48:06 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b89b0c73d7so5415035ad.1
        for <io-uring@vger.kernel.org>; Sun, 13 Aug 2023 14:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691963285; x=1692568085;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+pSAcUAQukzbtXs4BtFKqDCQxu+IiOA/cERtavK/ZH0=;
        b=FYSS1v6dhSAmmOcA884es4EjP5SHHox36FEKP7az/YJqhuUj9+Z20SM4RfdcX9MIYY
         KqRdnIkfsU0DkntWWP8IDsOuSy+1bUwfbWCkn7VNuRq3109fTuI1pP6cgPMTuHF1MRkK
         yQzePnKmGNiRuOnGJUq1huS/0NqnqZEgI7OLSzSy++m3Eb0Crk0FHJN/FDuN7xEjE1sM
         Kvw5WalpJYWXkSnVSv9lp9dfA4Ie4KKfqLAOckbi/Nm0yAS3EuNdpzRdOReTaIZaPYWp
         pFoVhfdmLJwchFMg53x6gq+Ortk/U0+EaaPN8OehhkjUIcOJfEjKjzfQzY6CjqZtQCj/
         twyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691963285; x=1692568085;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+pSAcUAQukzbtXs4BtFKqDCQxu+IiOA/cERtavK/ZH0=;
        b=JACntoIJ2HHT5zDY19xKbBI+F+0GGGJnN7/u0vYcLZxpLJh4u5Ges7xkHtCpqrXpYh
         tvuj7dkXkeOOvfhxQIKPphrsqJBWFuhaTrIqzKQtLBBoHRY1Onc1X1Vb4r2oVZoeid+2
         WNJbwmYU8FuV4WfAqdnoA8rOCVEv9qUYbRpbKXnCvUxuC822wJyx4oqva92Ch4XFvJ/5
         5KkyTNis1ZDIfR4F+kgHL1ISQUxE8kJAmXty/zUx/sOb+lsy+V7JKrfGrQaCQUIu5+Vd
         td9dYlrA9z+IEGCLAWZfMdZyTYADm533by4npC84mriNKOtavlhiSWSrPRhstgEKo+tn
         xdRw==
X-Gm-Message-State: AOJu0YwOoJkxloGp7VqP4uH2nG363YelLCG6yC0t7Pcn6gxKRsfpwJoj
        H+Nz+3fbcESQlYh4d4ezGqO/BoCOvJj8Ie+ESXI=
X-Google-Smtp-Source: AGHT+IGYtyR+LkHQCP4rTW9NBkmITLgzf8XHIt2pxpPDnetvBgA0DIqaQQIkfAnfUfoZ9+VIKF6qlQ==
X-Received: by 2002:a17:903:190:b0:1b8:35fa:cdcc with SMTP id z16-20020a170903019000b001b835facdccmr9426794plg.5.1691963285246;
        Sun, 13 Aug 2023 14:48:05 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ij13-20020a170902ab4d00b001bb04755212sm7971730plb.228.2023.08.13.14.48.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Aug 2023 14:48:04 -0700 (PDT)
Message-ID: <9e9ab13d-5f23-48ee-b651-3d89c3da1691@kernel.dk>
Date:   Sun, 13 Aug 2023 15:48:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/sqpoll: fix io-wq affinity when
 IORING_SETUP_SQPOLL is used
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

Fixes: fe76421d1da1 ("io_uring: allow user configurable IO thread CPU affinity")
Cc: stable@vger.kernel.org # 5.10+
Link: https://github.com/axboe/liburing/discussions/884
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2:	- handle unregister too...
	- move the tctx/tctx->io_wq sanity checking into common code

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 2da0b1ba6a56..62f345587df5 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1306,13 +1306,16 @@ static int io_wq_cpu_offline(unsigned int cpu, struct hlist_node *node)
 	return __io_wq_cpu_online(wq, cpu, false);
 }
 
-int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
+int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask)
 {
+	if (!tctx || !tctx->io_wq)
+		return -EINVAL;
+
 	rcu_read_lock();
 	if (mask)
-		cpumask_copy(wq->cpu_mask, mask);
+		cpumask_copy(tctx->io_wq->cpu_mask, mask);
 	else
-		cpumask_copy(wq->cpu_mask, cpu_possible_mask);
+		cpumask_copy(tctx->io_wq->cpu_mask, cpu_possible_mask);
 	rcu_read_unlock();
 
 	return 0;
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 31228426d192..06d9ca90c577 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -50,7 +50,7 @@ void io_wq_put_and_exit(struct io_wq *wq);
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_hash_work(struct io_wq_work *work, void *val);
 
-int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
+int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask);
 int io_wq_max_workers(struct io_wq *wq, int *new_count);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c65575fb4643..c2e29d00d20e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4198,13 +4198,9 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
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
 
@@ -4225,19 +4221,31 @@ static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	}
 
-	ret = io_wq_cpu_affinity(tctx->io_wq, new_mask);
+	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
+		ret = io_wq_cpu_affinity(current->io_uring, new_mask);
+	} else {
+		mutex_unlock(&ctx->uring_lock);
+		ret = io_sqpoll_wq_cpu_affinity(ctx, new_mask);
+		mutex_lock(&ctx->uring_lock);
+	}
+
 	free_cpumask_var(new_mask);
 	return ret;
 }
 
 static __cold int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
 {
-	struct io_uring_task *tctx = current->io_uring;
+	int ret;
 
-	if (!tctx || !tctx->io_wq)
-		return -EINVAL;
+	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
+		ret = io_wq_cpu_affinity(current->io_uring, NULL);
+	} else {
+		mutex_unlock(&ctx->uring_lock);
+		ret = io_sqpoll_wq_cpu_affinity(ctx, NULL);
+		mutex_lock(&ctx->uring_lock);
+	}
 
-	return io_wq_cpu_affinity(tctx->io_wq, NULL);
+	return ret;
 }
 
 static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 4b4bfb0d432c..9cfb4a78cead 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -422,3 +422,18 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
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
+		io_sq_thread_park(sqd);
+		ret = io_wq_cpu_affinity(sqd->thread->io_uring, mask);
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

