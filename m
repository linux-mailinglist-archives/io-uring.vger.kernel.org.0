Return-Path: <io-uring+bounces-3962-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE269AE86F
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:24:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 307FF2901C7
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 14:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58CF31F584D;
	Thu, 24 Oct 2024 14:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QzUBLXvQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39D61EBA0D
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 14:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729779503; cv=none; b=d4pTNdM/g7zzouUWoyPRLs4tYpFnO/OxLptL4Ep7XYbqgCv1YOLQq/UxLOhKGL8DmfnaiqWjpZrfmJ/MBN6HFqXRy/R+Z58iJ55Fd/BD3cL2DWZsldOT1x8vrijejQ7pcwpPTUDPspO57snRgiCMUiep9n+txZZfUU/Pv4km59c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729779503; c=relaxed/simple;
	bh=EEs+AedWjScRsnWEyKP2vW/r6UiLCZYYXo+i3/F9kvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rqsgj5P7M7xD02FwCyesSFn8qgJh+Egi5OVP5gKMg02lLcjmg5PBpoxSK9itqy8AJz4pdNdwLSWlOOASl43d2MDw5TYG9YIBQ3XR05XwNNwxZmkN+udXdEb+ML+PMZIkd66xArFNFqvusoacWNY3ePgQfsXYJZgIBPVI4bMLgOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QzUBLXvQ; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3a3b63596e0so3466225ab.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 07:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729779496; x=1730384296; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U4wlHhJnd8Y/ZGDkjYOyN0Iv+oWbVV4nDz2JzDjf0q8=;
        b=QzUBLXvQq5iLtsCsuo7FDDeR0RJWiVHj1q0mZYS4Yjp6WWr+blCh5143e4855r20Yg
         BHv/g4YZBxtuPHkkBCDweQJO4i28n/QlaK5TIjr/S8q30jZEVMYkOruo4g95CEzidLEq
         /MqDf6IdUuB4vdybUqJ/73S74k4XVtyyyk+2Vh7AXtIGtUBTG+FhQ0xed76zvbbgvOAt
         DvZmTgbV/GAFKjHBD2G/JvGwj6CY6lCdVMfoXGJ6mJuHTnp9tqrRHE2P+Z1pVEBdKnBZ
         bN/6GRv66PMx41l66PdhSKYLVn62rNYKTN1PEt7mRdk+qeOKgOhOrUG/4IrntgG7EMb/
         5pLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729779496; x=1730384296;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U4wlHhJnd8Y/ZGDkjYOyN0Iv+oWbVV4nDz2JzDjf0q8=;
        b=VH2ASIfuEAgs6mJpV0IJn5eaipEeVuOq22rG/ANQazNvw0yvjhjHqzwq0ixu3shbb1
         YYuIRADb9Px4aRCWtrJo73LCoFvfQP7945U6Y7DP9yD1thraW89rsEu1haLhkDK4uSCi
         klWN6DGf4XLCG/SN3E0Pm28CREYEb5iiNYrzqjPG9Z9zKCHDo2MnMseaSrobhj+EsytP
         BkWEMzjk5HRs46qjY2zqSVKsaM0qfWaUcuryU4OkHewQP0BT2jjpKOz7Aa+tEsjx9162
         gV4Ynr4hGw+JfjVlW/oaomxucnSF9clzvzucqYbkCEuJ0N8vrDR3DjO4WUE3S0SA5QEc
         zBOQ==
X-Gm-Message-State: AOJu0Yz7jIalZFINu6EUBVspWHs5erq20lKXGUsOCSODbN5iOzOu1Kaf
	huxSj3yOj7vmogaBFogdZ+CR7jn7eRSWAf0WJ+eucrr8hhh53LRqbkiWgkeCa1s=
X-Google-Smtp-Source: AGHT+IH4mimGQTRGFiEUREQ/wp8Yl4TyHaWRH3YEHTvGUZ9q4Gw0MTLcLu5cRekh8WOSjRAraubsdA==
X-Received: by 2002:a05:6e02:216d:b0:395:e85e:f2fa with SMTP id e9e14a558f8ab-3a4de701545mr16938425ab.1.1729779496286;
        Thu, 24 Oct 2024 07:18:16 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b9842asm30729235ab.86.2024.10.24.07.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 07:18:15 -0700 (PDT)
Message-ID: <9bc8f8c4-3415-48bb-9bd1-0996f2ef6669@kernel.dk>
Date: Thu, 24 Oct 2024 08:18:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] io_uring: releasing CPU resources when polling
To: hexue <xue01.he@samsung.com>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <293e5757-4160-4734-931c-9830df7c2f88@gmail.com>
 <CGME20241024023812epcas5p1e5798728def570cb57679eebdd742d7b@epcas5p1.samsung.com>
 <20241024023805.1082769-1-xue01.he@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241024023805.1082769-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/23/24 8:38 PM, hexue wrote:
> On 9/25/2024 12:12, Pavel Begunkov wrote:
>> I don't have a strong opinion on the feature, but the open question
>> we should get some decision on is whether it's really well applicable to
>> a good enough set of apps / workloads, if it'll even be useful in the
>> future and/or for other vendors, and if the merit outweighs extra
>> 8 bytes + 1 flag per io_kiocb and the overhead of 1-2 static key'able
>> checks in hot paths.
> 
> IMHO, releasing some of the CPU resources during the polling
> process may be appropriate for some performance bottlenecks
> due to CPU resource constraints, such as some database
> applications, in addition to completing IO operations, CPU
> also needs to peocess data, like compression and decompression.
> In a high-concurrency state, not only polling takes up a lot of
> CPU time, but also operations like calculation and processing
> also need to compete for CPU time. In this case, the performance
> of the application may be difficult to improve.
> 
> The MultiRead interface of Rocksdb has been adapted to io_uring,
> I used db_bench to construct a situation with high CPU pressure
> and compared the performance. The test configuration is as follows,
> 
> -------------------------------------------------------------------
> CPU Model 	Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz
> CPU Cores	8
> Memory		16G
> SSD			Samsung PM9A3
> -------------------------------------------------------------------
> 
> Test case?
> ./db_bench --benchmarks=multireadrandom,stats
> --duration=60
> --threads=4/8/16
> --use_direct_reads=true
> --db=/mnt/rocks/test_db
> --wal_dir=/mnt/rocks/test_db
> --key_size=4
> --value_size=4096
> -cache_size=0
> -use_existing_db=1
> -batch_size=256
> -multiread_batched=true
> -multiread_stride=0
> ------------------------------------------------------
> Test result?
> 			National	Optimization
> threads		ops/sec		ops/sec		CPU Utilization
> 16			139300		189075		100%*8
> 8			138639		133191		90%*8
> 4			71475		68361		90%*8
> ------------------------------------------------------
> 
> When the number of threads exceeds the number of CPU cores,the
> database throughput does not increase significantly. However,
> hybrid polling can releasing some CPU resources during the polling
> process, so that part of the CPU time can be used for frequent
> data processing and other operations, which speeds up the reading
> process, thereby improving throughput and optimizaing database
> performance.I tried different compression strategies and got
> results similar to the above table.(~30% throughput improvement)
> 
> As more database applications adapt to the io_uring engine, I think
> the application of hybrid poll may have potential in some scenarios.

Thanks for posting some numbers on that part, that's useful. I do
think the feature is useful as well, but I still have some issues
with the implementation. Below is an incremental patch on top of
yours to resolve some of those, potentially. Issues:

1) The patch still reads a bit like a hack, in that it doesn't seem to
   care about following the current style. This reads a bit lazy/sloppy
   or unfinished. I've fixed that up.

2) Appropriate member and function naming.

3) Same as above, it doesn't care about proper placement of additions to
   structs. Again this is a bit lazy and wasteful, attention should be
   paid to where additions are placed to not needlessly bloat
   structures, or place members in cache unfortunate locations. For
   example, available_time is just placed at the end of io_ring_ctx,
   why? It's a submission side member, and there's room with other
   related members. Not only is the placement now where you'd want it to
   be, memory wise, it also doesn't add 8 bytes to io_uring_ctx.

4) Like the above, the io_kiocb bloat is, by far, the worst. Seems to me
   that we can share space with the polling hash_node. This obviously
   needs careful vetting, haven't done that yet. IOPOLL setups should
   not be using poll at all. This needs extra checking. The poll_state
   can go with cancel_seq_set, as there's a hole there any. And just
   like that, rather than add 24b to io_kiocb, it doesn't take any extra
   space at all.

5) HY_POLL is a terrible name. It's associated with IOPOLL, and so let's
   please use a name related to that. And require IOPOLL being set with
   HYBRID_IOPOLL, as it's really a variant of that. Makes it clear that
   HYBRID_IOPOLL is really just a mode of operation for IOPOLL, and it
   can't exist without that.

Please take a look at this incremental and test it, and then post a v9
that looks a lot more finished. Caveat - I haven't tested this one at
all. Thanks!

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c79ee9fe86d4..6cf6a45835e5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -238,6 +238,8 @@ struct io_ring_ctx {
 		struct io_rings		*rings;
 		struct percpu_ref	refs;
 
+		u64			poll_available_time;
+
 		clockid_t		clockid;
 		enum tk_offsets		clock_offset;
 
@@ -433,9 +435,6 @@ struct io_ring_ctx {
 	struct page			**sqe_pages;
 
 	struct page			**cq_wait_page;
-
-	/* for io_uring hybrid poll*/
-	u64			available_time;
 };
 
 struct io_tw_state {
@@ -647,9 +646,22 @@ struct io_kiocb {
 
 	atomic_t			refs;
 	bool				cancel_seq_set;
+	bool				poll_state;
 	struct io_task_work		io_task_work;
-	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
-	struct hlist_node		hash_node;
+	union {
+		/*
+		 * for polled requests, i.e. IORING_OP_POLL_ADD and async armed
+		 * poll
+		 */
+		struct hlist_node	hash_node;
+		/*
+		 * For IOPOLL setup queues, with hybrid polling
+		 */
+		struct {
+			u64		iopoll_start;
+			u64		iopoll_end;
+		};
+	};
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
@@ -665,10 +677,6 @@ struct io_kiocb {
 		u64			extra1;
 		u64			extra2;
 	} big_cqe;
-    /* for io_uring hybrid iopoll */
-	bool		poll_state;
-	u64			iopoll_start;
-	u64			iopoll_end;
 };
 
 struct io_overflow_cqe {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 034997a1e507..5a290a56af6c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -199,7 +199,7 @@ enum io_uring_sqe_flags_bit {
  * Removes indirection through the SQ index array.
  */
 #define IORING_SETUP_NO_SQARRAY		(1U << 16)
-#define IORING_SETUP_HY_POLL	(1U << 17)
+#define IORING_SETUP_HYBRID_IOPOLL	(1U << 17)
 
 enum io_uring_op {
 	IORING_OP_NOP,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9631e10d681b..35071442fb70 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -307,7 +307,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
-	ctx->available_time = LLONG_MAX;
+	ctx->poll_available_time = LLONG_MAX;
 	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
@@ -3646,6 +3646,11 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ctx->clockid = CLOCK_MONOTONIC;
 	ctx->clock_offset = 0;
 
+	/* HYBRID_IOPOLL only valid with IOPOLL */
+	if ((ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_HYBRID_IOPOLL)) ==
+	    IORING_SETUP_HYBRID_IOPOLL)
+		return -EINVAL;
+
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		static_branch_inc(&io_key_has_sqarray);
 
@@ -3808,7 +3813,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
-			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HY_POLL))
+			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOPOLL))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index b86cef10ed72..6f7bf40df85a 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -782,13 +782,6 @@ static bool need_complete_io(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
-static void init_hybrid_poll(struct io_kiocb *req)
-{
-	/* make sure every req only block once*/
-	req->poll_state = false;
-	req->iopoll_start = ktime_get_ns();
-}
-
 static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -826,8 +819,11 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
-		if (ctx->flags & IORING_SETUP_HY_POLL)
-			init_hybrid_poll(req);
+		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
+			/* make sure every req only blocks once*/
+			req->poll_state = false;
+			req->iopoll_start = ktime_get_ns();
+		}
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
@@ -1126,27 +1122,24 @@ void io_rw_fail(struct io_kiocb *req)
 	io_req_set_res(req, res, req->cqe.flags);
 }
 
-static int io_uring_classic_poll(struct io_kiocb *req,
-		struct io_comp_batch *iob, unsigned int poll_flags)
+static int io_uring_classic_poll(struct io_kiocb *req, struct io_comp_batch *iob,
+				 unsigned int poll_flags)
 {
-	int ret;
 	struct file *file = req->file;
 
 	if (req->opcode == IORING_OP_URING_CMD) {
 		struct io_uring_cmd *ioucmd;
 
 		ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-		ret = file->f_op->uring_cmd_iopoll(ioucmd, iob,
-						poll_flags);
+		return file->f_op->uring_cmd_iopoll(ioucmd, iob, poll_flags);
 	} else {
 		struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
-		ret = file->f_op->iopoll(&rw->kiocb, iob, poll_flags);
+		return file->f_op->iopoll(&rw->kiocb, iob, poll_flags);
 	}
-	return ret;
 }
 
-static u64 io_delay(struct io_ring_ctx *ctx, struct io_kiocb *req)
+static u64 io_hybrid_iopoll_delay(struct io_ring_ctx *ctx, struct io_kiocb *req)
 {
 	struct hrtimer_sleeper timer;
 	enum hrtimer_mode mode;
@@ -1156,11 +1149,11 @@ static u64 io_delay(struct io_ring_ctx *ctx, struct io_kiocb *req)
 	if (req->poll_state)
 		return 0;
 
-	if (ctx->available_time == LLONG_MAX)
+	if (ctx->poll_available_time == LLONG_MAX)
 		return 0;
 
-	/* Using half running time to do schedul */
-	sleep_time = ctx->available_time / 2;
+	/* Use half the running time to do schedule */
+	sleep_time = ctx->poll_available_time / 2;
 
 	kt = ktime_set(0, sleep_time);
 	req->poll_state = true;
@@ -1177,7 +1170,6 @@ static u64 io_delay(struct io_ring_ctx *ctx, struct io_kiocb *req)
 	hrtimer_cancel(&timer.timer);
 	__set_current_state(TASK_RUNNING);
 	destroy_hrtimer_on_stack(&timer.timer);
-
 	return sleep_time;
 }
 
@@ -1185,19 +1177,21 @@ static int io_uring_hybrid_poll(struct io_kiocb *req,
 				struct io_comp_batch *iob, unsigned int poll_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	int ret;
 	u64 runtime, sleep_time;
+	int ret;
 
-	sleep_time = io_delay(ctx, req);
+	sleep_time = io_hybrid_iopoll_delay(ctx, req);
 	ret = io_uring_classic_poll(req, iob, poll_flags);
 	req->iopoll_end = ktime_get_ns();
 	runtime = req->iopoll_end - req->iopoll_start - sleep_time;
 
-	/* use minimize sleep time if there are different speed
-	 * drivers, it could get more completions from fast one
+	/*
+	 * Use minimum sleep time if we're polling devices with different
+	 * latencies. We could get more completions from the faster ones.
 	 */
-	if (ctx->available_time > runtime)
-		ctx->available_time = runtime;
+	if (ctx->poll_available_time > runtime)
+		ctx->poll_available_time = runtime;
+
 	return ret;
 }
 
@@ -1227,7 +1221,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (READ_ONCE(req->iopoll_completed))
 			break;
 
-		if (ctx->flags & IORING_SETUP_HY_POLL)
+		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL)
 			ret = io_uring_hybrid_poll(req, &iob, poll_flags);
 		else
 			ret = io_uring_classic_poll(req, &iob, poll_flags);

-- 
Jens Axboe

