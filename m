Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268FD1CE245
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2020 20:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbgEKSIx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 May 2020 14:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729564AbgEKSIx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 May 2020 14:08:53 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14279C061A0C
        for <io-uring@vger.kernel.org>; Mon, 11 May 2020 11:08:52 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s11so1424343pgv.13
        for <io-uring@vger.kernel.org>; Mon, 11 May 2020 11:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ddj9lf6ma2Qlx1QjgbEt1FhBF5ekcCdIXThqdzq78GU=;
        b=hU5Vj9PrbZGs22kNj9EjeYDSafxCaqBno70uHEp+NSXfmIpsB+VVrVi7C7JAi+il64
         BdGuEa78O43gZqK0H2ja0v2g0tD2Hu4g9YWVjOdCM6Bip0AX+M9FC1t9R9Z6PENUM4Mw
         ysJoigEl2nBAQ2znJQunE3dAW91p5PghQZgD/m0kMYJIL36ykrAvcjmkbI5VUeXUftGB
         s34sM0xz2pTHt59EdB8CANP2eQVh6QF3sdBn682fY4K/fHlkeec70KZs2Q5vliwS6K9y
         cnShc46YBZVw9+cNLC1DLZSdT6MZWk8va3yGY2M0TJ3QqunjritBuclCrI3z5fcvz1ME
         eCww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ddj9lf6ma2Qlx1QjgbEt1FhBF5ekcCdIXThqdzq78GU=;
        b=Sim2TAnmFSwtZBbribnNSj7Xczsectz8i+X1bHjsYPdN1gfxkGFEWQYp7nbN3B2dj7
         DXfinv4gdbq+H7zWN8uVkdp3sXDYgoixlYtJ19aHjTdrMSNN/hI+Tx/bW5AJfwof25t9
         VIYk0hVoh0foJSzS85XfxfWAaqZiJ74U/wgxaXLt+hmDmXUepVVWseKRgfAYMAvsfswr
         Csb1LN9wQNBkZPfIlAjcPSq0a//l1Ux5I4GWDYhC5Mga5f87DA/qBVs7hRRSC5RznqV3
         msX7hsWZqB2g4vKY/wSFjtk4rECxkG7QFVVvITpInwYoewqPHPAH1Bxq6MQvCPra+jHI
         yFMg==
X-Gm-Message-State: AGi0PuahcAOImQqDUAAo4D043vcAajRRyIDjvg4zGtHIPZz8i7PfJ9Cw
        Hn8Xwq+9gfzlZ74/NLCx1SmUTA==
X-Google-Smtp-Source: APiQypLrXYDDLw4jkoRM/oIwEIPa2qbMMtoy/SnoIx3HJpKH0VMbbDqfvplwASJuL82j4l5u7yDvaA==
X-Received: by 2002:a05:6a00:d:: with SMTP id h13mr17705134pfk.254.1589220531273;
        Mon, 11 May 2020 11:08:51 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:911f:9a95:56a4:6995? ([2605:e000:100e:8c61:911f:9a95:56a4:6995])
        by smtp.gmail.com with ESMTPSA id b7sm9675120pft.147.2020.05.11.11.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 11:08:50 -0700 (PDT)
Subject: Re: Is io_uring framework becoming bloated gradually? and introduces
 performace regression
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
References: <6132351e-75e6-9d4d-781b-d6a183d87846@linux.alibaba.com>
 <5828e2de-5976-20ae-e920-bf185c0bc52d@kernel.dk>
 <113c34c8-9f17-7890-d12a-e35c7922432e@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0a042320-c162-8d57-0506-471bf85c7d0f@kernel.dk>
Date:   Mon, 11 May 2020 12:08:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <113c34c8-9f17-7890-d12a-e35c7922432e@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/10/20 9:30 PM, Xiaoguang Wang wrote:
> hi£¬
> 
>> On 5/8/20 9:18 AM, Xiaoguang Wang wrote:
>>> hi,
>>>
>>> This issue was found when I tested IORING_FEAT_FAST_POLL feature, with
>>> the newest upstream codes, indeed I find that io_uring's performace
>>> improvement is not obvious compared to epoll in my test environment,
>>> most of the time they are similar.  Test cases basically comes from:
>>> https://github.com/frevib/io_uring-echo-server/blob/io-uring-feat-fast-poll/benchmarks/benchmarks.md.
>>> In above url, the author's test results shows that io_uring will get a
>>> big performace improvement compared to epoll. I'm still looking into
>>> why I don't get the big improvement, currently don't know why, but I
>>> find some obvious regression issue.
>>>
>>> I wrote a simple tool based io_uring nop operation to evaluate
>>> io_uring framework in v5.1 and 5.7.0-rc4+(jens's io_uring-5.7 branch),
>>> I see a obvious performace regression:
>>>
>>> v5.1 kernel:
>>>       $sudo taskset -c 60 ./io_uring_nop_stress -r 300 # run 300 seconds
>>>       total ios: 1832524960
>>>       IOPS:      6108416
>>> 5.7.0-rc4+
>>>       $sudo taskset -c 60 ./io_uring_nop_stress -r 300
>>>       total ios: 1597672304
>>>       IOPS:      5325574
>>> it's about 12% performance regression.
>>
>> For sure there's a bit more bloat in 5.7+ compared to the initial slim
>> version, and focus has been on features to a certain extent recently.
>> The poll rework for 5.7 will really improve performance for the
>> networked side though, so it's not like it's just piling on features
>> that add bloat.
>>
>> That said, I do think it's time for a revisit on overhead. It's been a
>> while since I've done my disk IO testing. The nop testing isn't _that_
>> interesting by itself, as a micro benchmark it does yield some results
>> though. Are you running on bare metal or in a VM?
> I run it on bare metal.
> 
>>
>>> Using perf can see many performance bottlenecks, for example,
>>> io_submit_sqes is one.  For now, I did't make many analysis yet, just
>>> have a look at io_submit_sqes(), there are many assignment operations
>>> in io_init_req(), but I'm not sure whether they are all needed when
>>> req is not needed to be punt to io-wq, for example,
>>> INIT_IO_WORK(&req->work, io_wq_submit_work); # a whole struct
>>> assignment from perf annotate tool, it's an expensive operation, I
>>> think reqs that use fast poll feature use task-work function, so the
>>> INIT_IO_WORK maybe not necessary.
>>
>> I'm sure there's some low hanging fruit there, and I'd love to take
>> patches for it.
> Ok, I'll try to improve it a bit, thanks.
> 
>>
>>> Above is just one issue, what I worry is that whether io_uring is
>>> becoming more bloated gradually, and will not that better to aio. In
>>> https://kernel.dk/io_uring.pdf, it says that io_uring will eliminate
>>> 104 bytes copy compared to aio, but see currenct io_init_req(),
>>> io_uring maybe copy more, introducing more overhead? Or does we need
>>> to carefully re-design struct io_kiocb, to reduce overhead as soon as
>>> possible.
>>
>> The copy refers to the data structures coming in and out, both io_uring
>> and io_uring inititalize their main io_kiocb/aio_kiocb structure as
>> well. The io_uring is slightly bigger, but not much, and it's the same
>> number of cachelines. So should not be a huge difference there. The
>> copying on the aio side is basically first the pointer copy, then the
>> user side kiocb structure. io_uring doesn't need to do that. The
>> completion side is also slimmer. We also don't need as many system calls
>> to do the same thing, for example.
>>
>> So no, we should always been substantially slimmer than aio, just by the
>> very nature of the API.
> Really thanks for detailed explanations, now I see, feel good:)
> 
>>
>> One major thing I've been thinking about for io_uring is io_kiocb
>> recycling. We're hitting the memory allocator for alloc+free for each
>> request, even though that can be somewhat amortized by doing batched
>> submissions, and polling for instance can also do batched frees. But I'm
>> pretty sure we can find some gains here by having some io_kiocb caching
>> that is persistent across operations.
> Yes, agree. From my above nop operation tests, using perf, it shows
> kmem_cache_free() and kmem_cache_alloc_bulk() introduce an considerable
> overhead.

Just did a quick'n dirty where we have a global per-cpu cache of
io_kiocbs, so we can recycle them.

I'm using my laptop for this testing, running in kvm. This isn't ideal,
as the spinlock/irq overhead is much larger there, but it's the same
across all runs.

Baseline performance, this is running your test app as-is, no changes:

# taskset -c 0 ./io_uring_nop_stress 
total ios: 294158288
IOPS:      9805276

Then I disabled the bulk alloc optimization, so we don't get any
benefits of allocating 16 requests at the time:

# taskset -c 0 ./io_uring_nop_stress 
total ios: 285341456
IOPS:      9511381

As expected, we're down a bit at that point, as we're allocating each
io_kiocb individually.

Then I tried with the quick'n dirty patch:

# taskset -c 0 ./io_uring_nop_stress 
total ios: 325797040
IOPS:      10859901

and it's quite a bit faster. This is cheating a little bit, since these
are just nops and we don't have to disable local irqs while grabbing a
recycled entry. But just adding that and it should be safe to use, and
probably won't make much of a difference on actual hardware.

The main concern for me is how to manage this cache. We could just limit
it to X entries per cpu or something like that, but it'd be nice to be
able to respond to memory pressure.

Quick'n dirty below.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4c2fe06ae20b..b6a6d0f0f4e5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -673,6 +673,13 @@ struct io_submit_state {
 	unsigned int		ios_left;
 };
 
+struct io_kiocb_cache {
+	struct list_head	list;
+	unsigned		nr_free;
+};
+
+static struct io_kiocb_cache *alloc_cache;
+
 struct io_op_def {
 	/* needs req->io allocated for deferral/async */
 	unsigned		async_ctx : 1;
@@ -1293,6 +1300,29 @@ static struct io_kiocb *io_get_fallback_req(struct io_ring_ctx *ctx)
 	return NULL;
 }
 
+static struct io_kiocb *io_cache_alloc(void)
+{
+	struct io_kiocb_cache *cache;
+	struct io_kiocb *req = NULL;
+
+	cache = this_cpu_ptr(alloc_cache);
+	if (!list_empty(&cache->list)) {
+		req = list_first_entry(&cache->list, struct io_kiocb, list);
+		list_del(&req->list);
+		return req;
+	}
+
+	return NULL;
+}
+
+static void io_cache_free(struct io_kiocb *req)
+{
+	struct io_kiocb_cache *cache;
+
+	cache = this_cpu_ptr(alloc_cache);
+	list_add(&req->list, &cache->list);
+}
+
 static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 				     struct io_submit_state *state)
 {
@@ -1300,6 +1330,9 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 	struct io_kiocb *req;
 
 	if (!state) {
+		req = io_cache_alloc();
+		if (req)
+			return req;
 		req = kmem_cache_alloc(req_cachep, gfp);
 		if (unlikely(!req))
 			goto fallback;
@@ -1372,7 +1405,7 @@ static void __io_free_req(struct io_kiocb *req)
 
 	percpu_ref_put(&req->ctx->refs);
 	if (likely(!io_is_fallback_req(req)))
-		kmem_cache_free(req_cachep, req);
+		io_cache_free(req);
 	else
 		clear_bit_unlock(0, (unsigned long *) &req->ctx->fallback_req);
 }
@@ -5842,7 +5875,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			  struct file *ring_file, int ring_fd, bool async)
 {
-	struct io_submit_state state, *statep = NULL;
+	//struct io_submit_state state, *statep = NULL;
 	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
 
@@ -5859,10 +5892,12 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
+#if 0
 	if (nr > IO_PLUG_THRESHOLD) {
 		io_submit_state_start(&state, nr);
 		statep = &state;
 	}
+#endif
 
 	ctx->ring_fd = ring_fd;
 	ctx->ring_file = ring_file;
@@ -5877,14 +5912,14 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			io_consume_sqe(ctx);
 			break;
 		}
-		req = io_alloc_req(ctx, statep);
+		req = io_alloc_req(ctx, NULL);
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
 			break;
 		}
 
-		err = io_init_req(ctx, req, sqe, statep, async);
+		err = io_init_req(ctx, req, sqe, NULL, async);
 		io_consume_sqe(ctx);
 		/* will complete beyond this point, count as submitted */
 		submitted++;
@@ -5898,7 +5933,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-		err = io_submit_sqe(req, sqe, statep, &link);
+		err = io_submit_sqe(req, sqe, NULL, &link);
 		if (err)
 			goto fail_req;
 	}
@@ -5910,8 +5945,10 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	}
 	if (link)
 		io_queue_link_head(link);
+#if 0
 	if (statep)
 		io_submit_state_end(&state);
+#endif
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
@@ -8108,6 +8145,8 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 
 static int __init io_uring_init(void)
 {
+	int cpu;
+
 #define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
 	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
 	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
@@ -8147,6 +8186,15 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+
+	alloc_cache = alloc_percpu(struct io_kiocb_cache);
+	for_each_possible_cpu(cpu) {
+		struct io_kiocb_cache *cache;
+
+		cache = per_cpu_ptr(alloc_cache, cpu);
+		INIT_LIST_HEAD(&cache->list);
+		cache->nr_free = 0;
+	}
 	return 0;
 };
 __initcall(io_uring_init);

-- 
Jens Axboe

