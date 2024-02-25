Return-Path: <io-uring+bounces-718-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E7D862D17
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 22:11:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7431E1F21C0B
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 21:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E44D0D2FE;
	Sun, 25 Feb 2024 21:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VdkgtmVm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3631B94E
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 21:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708895475; cv=none; b=ug2nrOP1JsSr2S1V7zNyVvwluwXf734mMHdCbpHNbPUwZ/l4OD7w/mi802oNp7l+AAl2W0Qg6Tsbhw2Ldm9TASn9A3BWNYdtQ8lF2FazKjBlG7UtrEyhBsL705Ly6YpOTigs+Dn7C6g+TTx5c3agybxeF2+mx/p/afxu6kP9H9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708895475; c=relaxed/simple;
	bh=icFVk1X357ZIUUqrUwKTmrQp9iy4UheRNbNocKlSMrs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=gdyh0JYi5T/NdJuZ02R/Gga/ZfJlf3qf4voRzFK3dxBAUPF0GDrOxh0I4F5IRmH9pvieEsdI0rmHIs3GmGEmhTVUalTQloJZ1xHWpG5pfaZSdAalitBzh8eI5g/NAsphGNSN+6hKQBAY19ecMwK3jy83aQZ42WrA5S3LNyhQGFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VdkgtmVm; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5cfcf509fbdso1206256a12.1
        for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 13:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708895472; x=1709500272; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iTr0Gbdgx+BtwSCxnI/ao0pkJ1nzxz5w2RQZgj/CvsU=;
        b=VdkgtmVmwQNtAbdL1gy/gHw/+sLcWlaQGg33HK9L1ig4zd1jERENZ8fo+rt3jBaplp
         9WFpxfVOet9N2TrvjGNEZ63TFep5iGXbmY4EEW8E9etSaNOoyMYAKECiJVBwyIKtLa2+
         tZ1trve26+WRJPpFWAStqSM7wmG6ZRkD856GH+LWzQcHnS5PiKptrYXPrcPH72eTt/VR
         /6hoWMWhf+lQXRA9alLew5KnbDpZkaPsg3J/yl3VsMxW9R+x8GzE1QcpTIcj3L/tpneK
         Xn2PkBd7YfMqyDZ4FosjvurB4gdVW3a6EUlDsZ/3z9xzrDf3Y9xRgS+VKb83oyhufYqu
         68ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708895472; x=1709500272;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iTr0Gbdgx+BtwSCxnI/ao0pkJ1nzxz5w2RQZgj/CvsU=;
        b=dcpVqGlVUWViluaqcbAY23xZWdy+o7yWSauLkjyyviPBeJhixDs+5QfO4vrMp2NWej
         l2ij/IylgW8juoeWO+oIsZUf0YaeN1bDSMqfuda+JCiDPS5R0/YFqubKcwumKCjSXpTV
         XLF760EoZ60xjQGXgHGZIAOg+c44p3ET8fd7VlM895o1iA16qiN0gi2aK7iQ8ho8kufz
         F7tIwPuQn2e7fzGuuTekpShmkKLe8k6m8IrK7Id4MVFvMtyidgBvTHcti5GB12upifDX
         mJ94WRthDrHVlos/Md8+wJN8h5d0V8gQJgo7f1GaHDq7iKggLLkzJutGilffUBBYTfem
         +X5g==
X-Forwarded-Encrypted: i=1; AJvYcCXgsy2vraHervnxY7LQ6z8BK0diPxU4Ww5PpESyZvAgvsJtJM5bPCrNN2/8401YFdQK6Hege0tg2VEjL+o3TMCb5QQi9meCAgM=
X-Gm-Message-State: AOJu0Yw0sbA+2CjL+E9KN60mSEwZqFC5OT63lYPApRnGz31m1b0pDP7y
	LKQQMKNOvtYeq8EsQPkCuioL9kIlh+rnrORf9n4l3PbKQCXGHCTBr3jvzifsGLFokUNkAcI8syO
	V
X-Google-Smtp-Source: AGHT+IG26qpxWf3uhxm7CaLfD9HImrsskyDeurLrH3i+YV/8KnctlyTXHwmdkj3fX0vzLfFr68yHBg==
X-Received: by 2002:a05:6a21:6d9d:b0:1a0:f8b1:5d10 with SMTP id wl29-20020a056a216d9d00b001a0f8b15d10mr2804031pzb.2.1708895471672;
        Sun, 25 Feb 2024 13:11:11 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id s14-20020a056a00178e00b006e4e5ee9a75sm2697417pfg.191.2024.02.25.13.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Feb 2024 13:11:11 -0800 (PST)
Message-ID: <a19fc5fb-cbb3-4a61-bce2-d6cb52227c19@kernel.dk>
Date: Sun, 25 Feb 2024 14:11:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] io_uring: only account cqring wait time as iowait
 if enabled for a ring
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20240224050735.1759733-1-dw@davidwei.uk>
 <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
 <2106a112-35ca-4e02-a501-546f8d734103@davidwei.uk>
 <cf1f03ce-352b-4a61-a595-d595413bc831@kernel.dk>
 <8dc18842-bb1b-4565-ab98-427cbd07542b@gmail.com>
 <a5fc01ba-d023-4f02-acb1-fa1d3cfbff2d@kernel.dk>
In-Reply-To: <a5fc01ba-d023-4f02-acb1-fa1d3cfbff2d@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/25/24 9:43 AM, Jens Axboe wrote:
> If you are motivated, please dig into it. If not, I guess I will take a
> look this week. 

The straight forward approach - add a nr_short_wait and ->in_short_wait
and ensure that the idle governor factors that in. Not sure how
palatable it is, would be nice fold iowait under this, but doesn't
really work with how we pass back the previous state.

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index b96e3da0fedd..39f05d6062e1 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -119,7 +119,7 @@ struct menu_device {
 	int		interval_ptr;
 };
 
-static inline int which_bucket(u64 duration_ns, unsigned int nr_iowaiters)
+static inline int which_bucket(u64 duration_ns, unsigned int nr_short_waiters)
 {
 	int bucket = 0;
 
@@ -129,7 +129,7 @@ static inline int which_bucket(u64 duration_ns, unsigned int nr_iowaiters)
 	 * This allows us to calculate
 	 * E(duration)|iowait
 	 */
-	if (nr_iowaiters)
+	if (nr_short_waiters)
 		bucket = BUCKETS/2;
 
 	if (duration_ns < 10ULL * NSEC_PER_USEC)
@@ -152,10 +152,10 @@ static inline int which_bucket(u64 duration_ns, unsigned int nr_iowaiters)
  * to be, the higher this multiplier, and thus the higher
  * the barrier to go to an expensive C state.
  */
-static inline int performance_multiplier(unsigned int nr_iowaiters)
+static inline int performance_multiplier(unsigned int nr_short_waiters)
 {
 	/* for IO wait tasks (per cpu!) we add 10x each */
-	return 1 + 10 * nr_iowaiters;
+	return 1 + 10 * nr_short_waiters;
 }
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
@@ -266,7 +266,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	s64 latency_req = cpuidle_governor_latency_req(dev->cpu);
 	u64 predicted_ns;
 	u64 interactivity_req;
-	unsigned int nr_iowaiters;
+	unsigned int nr_short_waiters;
 	ktime_t delta, delta_tick;
 	int i, idx;
 
@@ -275,7 +275,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		data->needs_update = 0;
 	}
 
-	nr_iowaiters = nr_iowait_cpu(dev->cpu);
+	nr_short_waiters = nr_iowait_cpu(dev->cpu) + nr_short_wait_cpu(dev->cpu);
 
 	/* Find the shortest expected idle interval. */
 	predicted_ns = get_typical_interval(data) * NSEC_PER_USEC;
@@ -290,7 +290,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		}
 
 		data->next_timer_ns = delta;
-		data->bucket = which_bucket(data->next_timer_ns, nr_iowaiters);
+		data->bucket = which_bucket(data->next_timer_ns, nr_short_waiters);
 
 		/* Round up the result for half microseconds. */
 		timer_us = div_u64((RESOLUTION * DECAY * NSEC_PER_USEC) / 2 +
@@ -308,7 +308,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		 */
 		data->next_timer_ns = KTIME_MAX;
 		delta_tick = TICK_NSEC / 2;
-		data->bucket = which_bucket(KTIME_MAX, nr_iowaiters);
+		data->bucket = which_bucket(KTIME_MAX, nr_short_waiters);
 	}
 
 	if (unlikely(drv->state_count <= 1 || latency_req == 0) ||
@@ -341,7 +341,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		 * latency_req to determine the maximum exit latency.
 		 */
 		interactivity_req = div64_u64(predicted_ns,
-					      performance_multiplier(nr_iowaiters));
+					      performance_multiplier(nr_short_waiters));
 		if (latency_req > interactivity_req)
 			latency_req = interactivity_req;
 	}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ffe8f618ab86..b04c08cadf1f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -923,6 +923,7 @@ struct task_struct {
 	/* Bit to tell TOMOYO we're in execve(): */
 	unsigned			in_execve:1;
 	unsigned			in_iowait:1;
+	unsigned			in_short_wait:1;
 #ifndef TIF_RESTORE_SIGMASK
 	unsigned			restore_sigmask:1;
 #endif
diff --git a/include/linux/sched/stat.h b/include/linux/sched/stat.h
index 0108a38bb64d..12f5795c4c32 100644
--- a/include/linux/sched/stat.h
+++ b/include/linux/sched/stat.h
@@ -21,6 +21,7 @@ extern unsigned int nr_running(void);
 extern bool single_task_running(void);
 extern unsigned int nr_iowait(void);
 extern unsigned int nr_iowait_cpu(int cpu);
+unsigned int nr_short_wait_cpu(int cpu);
 
 static inline int sched_info_on(void)
 {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f6332fc56bed..024af44ead12 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2519,7 +2519,7 @@ static bool current_pending_io(void)
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq)
 {
-	int io_wait, ret;
+	int short_wait, ret;
 
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
@@ -2537,15 +2537,15 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 * can take into account that the task is waiting for IO - turns out
 	 * to be important for low QD IO.
 	 */
-	io_wait = current->in_iowait;
+	short_wait = current->in_short_wait;
 	if (current_pending_io())
-		current->in_iowait = 1;
+		current->in_short_wait = 1;
 	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
 	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
 		ret = -ETIME;
-	current->in_iowait = io_wait;
+	current->in_short_wait = short_wait;
 	return ret;
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9116bcc90346..dc7a08db8921 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3790,6 +3790,8 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags,
 	if (p->in_iowait) {
 		delayacct_blkio_end(p);
 		atomic_dec(&task_rq(p)->nr_iowait);
+	} else if (p->in_short_wait) {
+		atomic_dec(&task_rq(p)->nr_short_wait);
 	}
 
 	activate_task(rq, p, en_flags);
@@ -4356,6 +4358,8 @@ int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 			if (p->in_iowait) {
 				delayacct_blkio_end(p);
 				atomic_dec(&task_rq(p)->nr_iowait);
+			} else if (p->in_short_wait) {
+				atomic_dec(&task_rq(p)->nr_short_wait);
 			}
 
 			wake_flags |= WF_MIGRATED;
@@ -5506,6 +5510,11 @@ unsigned int nr_iowait(void)
 	return sum;
 }
 
+unsigned int nr_short_wait_cpu(int cpu)
+{
+	return atomic_read(&cpu_rq(cpu)->nr_short_wait);
+}
+
 #ifdef CONFIG_SMP
 
 /*
@@ -6683,6 +6692,8 @@ static void __sched notrace __schedule(unsigned int sched_mode)
 			if (prev->in_iowait) {
 				atomic_inc(&rq->nr_iowait);
 				delayacct_blkio_start();
+			} else if (prev->in_short_wait) {
+				atomic_inc(&rq->nr_short_wait);
 			}
 		}
 		switch_count = &prev->nvcsw;
@@ -10030,6 +10041,7 @@ void __init sched_init(void)
 #endif /* CONFIG_SMP */
 		hrtick_rq_init(rq);
 		atomic_set(&rq->nr_iowait, 0);
+		atomic_set(&rq->nr_short_wait, 0);
 
 #ifdef CONFIG_SCHED_CORE
 		rq->core = rq;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 533547e3c90a..9d4fc0b9de26 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6721,7 +6721,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	 * utilization updates, so do it here explicitly with the IOWAIT flag
 	 * passed.
 	 */
-	if (p->in_iowait)
+	if (p->in_iowait || p->in_short_wait)
 		cpufreq_update_util(rq, SCHED_CPUFREQ_IOWAIT);
 
 	for_each_sched_entity(se) {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 001fe047bd5d..0530e9e97ecb 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1050,6 +1050,7 @@ struct rq {
 #endif
 
 	atomic_t		nr_iowait;
+	atomic_t		nr_short_wait;
 
 #ifdef CONFIG_SCHED_DEBUG
 	u64 last_seen_need_resched_ns;

-- 
Jens Axboe


