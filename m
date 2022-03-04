Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7679E4CD55E
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 14:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiCDNpV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Mar 2022 08:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCDNpU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Mar 2022 08:45:20 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C88F1B01B0
        for <io-uring@vger.kernel.org>; Fri,  4 Mar 2022 05:44:31 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso7281904pjb.0
        for <io-uring@vger.kernel.org>; Fri, 04 Mar 2022 05:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tCjDsA40RAFkve+ME7OTIEeymVxhSy2agGO74IT9kWY=;
        b=1WjDXh26P8XJooFqJaPZGOEnX700zzqGQpjmz6vIRl/yb/a586jNy9IA0KJmry+AmQ
         b/+DD2pRXKDgDurNgPZxnvYP3tk3bwy3yka4HyuVfExtq5Vrh9+EjTJXoOvBLZVdVck0
         tluOGb1xQroS1y6aymn2tygHrrJRs7MogLQlw3YgNn2zPakBodQJlZ0Ae4akY1NLepmB
         6s1d4nRsZqpo7EzZpd0qQQxINvmBXP3hCV29/cpaOUSvyC3F7eYqjv2QDs3Npxetw9lh
         4XG3sKah9KmmPPTtC0a3hbLKAS3YMx5/I5RDu+WrwgHF8Dmmc7I4017hqWJyupNrLmm1
         X2Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tCjDsA40RAFkve+ME7OTIEeymVxhSy2agGO74IT9kWY=;
        b=jBrNotifvmbgqN78CijHhHPN9VPH2qx6RTbBXZEuKSFRFCRgL7LoqhvKugUcK0hrOp
         mDDouo0XG5EbiAEE+aSiuZZutB3UH4yGddOccp6PfoBnY9j9GctP1iuSDWBIw8xeVJas
         YsOfOOWEi9iUCD1Yj3/fbND/ojt32EQj4dTQfz2B+GUrXQWuz9xHdAuj/eWEwcEPUq4A
         mfaMzbbWuvAW8iQfAPevFt+3TWIHXp0w9IAYrbS3chE2IsPYKpwFyNz5lvo+gJqlrsqE
         vMwJjIwAbPtF4aUxXqBYLUdC/kwqwwKbdTxKnHo9eTeVhVSg+Okc3MbN6vey55GRGZos
         Pxug==
X-Gm-Message-State: AOAM530qTR9No/4eLzbucpMvFRsShNIszIhnWASpXVMz3a5KwlMHGKci
        UFLUvaJaPBJXVLDoWheeey+ucf6LBCbmTg==
X-Google-Smtp-Source: ABdhPJxJFQm0TqqJWwe+Bv/iJTc2qHp3c2HABHb8MCzkd9QMypMwtFFxfMNMO7LF/61LJID7YNf1BQ==
X-Received: by 2002:a17:90a:de02:b0:1be:dbd6:b5a7 with SMTP id m2-20020a17090ade0200b001bedbd6b5a7mr10675046pjv.222.1646401470591;
        Fri, 04 Mar 2022 05:44:30 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j22-20020a17090a7e9600b001bc67215a52sm4742420pjl.56.2022.03.04.05.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 05:44:29 -0800 (PST)
Message-ID: <43e733d9-f62d-34b5-318c-e1abaf8cc4a3@kernel.dk>
Date:   Fri, 4 Mar 2022 06:44:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <66bfc962-b983-e737-7c36-85784c52b7fa@kernel.dk>
 <8466f91e-416e-d53e-8c24-47a0b20412ac@kernel.dk>
 <968510d6-6101-ca0f-95a0-f8cb8807b0da@kernel.dk>
 <6b1a48d5-7991-b686-06fa-22ac23650992@kernel.dk>
 <3a59a3e1-4aa8-6970-23b6-fd331fb2c75c@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3a59a3e1-4aa8-6970-23b6-fd331fb2c75c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/22 6:39 AM, Xiaoguang Wang wrote:
> hi,
> 
>> On 3/3/22 2:19 PM, Jens Axboe wrote:
>>> On 3/3/22 1:41 PM, Jens Axboe wrote:
>>>> On 3/3/22 10:18 AM, Jens Axboe wrote:
>>>>> On 3/3/22 9:31 AM, Jens Axboe wrote:
>>>>>> On 3/3/22 7:40 AM, Jens Axboe wrote:
>>>>>>> On 3/3/22 7:36 AM, Jens Axboe wrote:
>>>>>>>> The only potential oddity here is that the fd passed back is not a
>>>>>>>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
>>>>>>>> that could cause some confusion even if I don't think anyone actually
>>>>>>>> does poll(2) on io_uring.
>>>>>>> Side note - the only implication here is that we then likely can't make
>>>>>>> the optimized behavior the default, it has to be an IORING_SETUP_REG
>>>>>>> flag which tells us that the application is aware of this limitation.
>>>>>>> Though I guess close(2) might mess with that too... Hmm.
>>>>>> Not sure I can find a good approach for that. Tried out your patch and
>>>>>> made some fixes:
>>>>>>
>>>>>> - Missing free on final tctx free
>>>>>> - Rename registered_files to registered_rings
>>>>>> - Fix off-by-ones in checking max registration count
>>>>>> - Use kcalloc
>>>>>> - Rename ENTER_FIXED_FILE -> ENTER_REGISTERED_RING
>>>>>> - Don't pass in tctx to io_uring_unreg_ringfd()
>>>>>> - Get rid of forward declaration for adding tctx node
>>>>>> - Get rid of extra file pointer in io_uring_enter()
>>>>>> - Fix deadlock in io_ringfd_register()
>>>>>> - Use io_uring_rsrc_update rather than add a new struct type
>>>>> - Allow multiple register/unregister instead of enforcing just 1 at the
>>>>>    time
>>>>> - Check for it really being a ring fd when registering
>>>>>
>>>>> For different batch counts, nice improvements are seen. Roughly:
>>>>>
>>>>> Batch==1    15% faster
>>>>> Batch==2    13% faster
>>>>> Batch==4    11% faster
>>>>>
>>>>> This is just in microbenchmarks where the fdget/fdput play a bigger
>>>>> factor, but it will certainly help with real world situations where
>>>>> batching is more limited than in benchmarks.
>>>> In trying this out in applications, I think the better registration API
>>>> is to allow io_uring to pick the offset. The application doesn't care,
>>>> it's just a magic integer there. And if we allow io_uring to pick it,
>>>> then that makes things a lot easier to deal with.
>>>>
>>>> For registration, pass in an array of io_uring_rsrc_update structs, just
>>>> filling in the ring_fd in the data field. Return value is number of ring
>>>> fds registered, and up->offset now contains the chosen offset for each
>>>> of them.
>>>>
>>>> Unregister is the same struct, but just with offset filled in.
>>>>
>>>> For applications using io_uring, which is all of them as far as I'm
>>>> aware, we can also easily hide this. This means we can get the optimized
>>>> behavior by default.
>>> Only complication here is if the ring is shared across threads or
>>> processes. The thread one can be common, one thread doing submit and one
>>> doing completions. That one is a bit harder to handle. Without
>>> inheriting registered ring fds, not sure how it can be handled by
>>> default. Should probably just introduce a new queue init helper, but
>>> then that requires application changes to adopt...
>>>
>>> Ideas welcome!
>> Don't see a way to do it by default, so I think it'll have to be opt-in.
>> We could make it the default if you never shared a ring, which most
>> people don't do, but we can't easily do so if it's ever shared between
>> tasks or processes.

> Before sending this patch, I also have thought about whether we can
> make this enter_ring_fd be shared between threads and be default
> feature, and found that it's hard :)
>
>   1) first we need to ensure this ring fd registration always can be
>   unregistered, so this cache is tied to io_uring_task, then when
>   thread exits, we can ensure fput called correspondingly.
>
>   2) we may also implement a file cache shared between threads in a
>   process, but this may introduce extra overhead, at least need locks
>   to protect modifications to this cache. If this cache is per thread,
>   it doesn't need any synchronizations.
> 
> So I suggest to make it be just simple and opt-in, and the
> registration interface seems not complicated, a thread trying to
> submit sqes can adopt it easily.

Yes, I pretty much have come to that same conclusion myself...

>> With liburing, if you share, you share the io_uring struct as well. So
>> it's hard to maintain a new ->enter_ring_fd in there. It'd be doable if
>> we could reserve real fd == . Which is of course possible
>> using xarray or similar, but that'll add extra overhead.
>
> For liburing, we may need to add fixed file version for helpers which
> submit sqes or reap cqes, for example,  io_uring_submit_fixed(), which
> passes a enter_ring_fd.

I'll take a look at liburing and see what we need to do there. I think
the sanest thing to do here is say that using a registered ring fd means
you cannot share the ring, ever. And then just have a
ring->enter_ring_fd which is normally just set to ring_fd when the ring
is setup, and if you register the ring fd, then we set it to whatever
the registered value is. Everything calling io_uring_enter() then just
needs to be modified to use ->enter_ring_fd instead of ->ring_fd.

>> Anyway, current version below. Only real change here is allowing either
>> specific offset or generated offset, depending on what the
>> io_uring_rsrc_update->offset is set to. If set to -1U, then io_uring
>> will find a free offset. If set to anything else, io_uring will use that
>> index (as long as it's >=0 && < MAX).

> Seems you forgot to attach the newest version, and also don't see a
> patch attachment. Finally, thanks for your quick response and many
> code improvements, really appreciate it.

Oops, below now. How do you want to handle this patch? It's now a bit of
a mix of both of our stuff...


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8f26c4602384..9180f122ecd7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -466,6 +466,11 @@ struct io_ring_ctx {
 	};
 };
 
+/*
+ * Arbitrary limit, can be raised if need be
+ */
+#define IO_RINGFD_REG_MAX 16
+
 struct io_uring_task {
 	/* submission side */
 	int			cached_refs;
@@ -481,6 +486,7 @@ struct io_uring_task {
 	struct io_wq_work_list	task_list;
 	struct io_wq_work_list	prior_task_list;
 	struct callback_head	task_work;
+	struct file		**registered_rings;
 	bool			task_running;
 };
 
@@ -8779,8 +8785,16 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	if (unlikely(!tctx))
 		return -ENOMEM;
 
+	tctx->registered_rings = kcalloc(IO_RINGFD_REG_MAX,
+					 sizeof(struct file *), GFP_KERNEL);
+	if (unlikely(!tctx->registered_rings)) {
+		kfree(tctx);
+		return -ENOMEM;
+	}
+
 	ret = percpu_counter_init(&tctx->inflight, 0, GFP_KERNEL);
 	if (unlikely(ret)) {
+		kfree(tctx->registered_rings);
 		kfree(tctx);
 		return ret;
 	}
@@ -8789,6 +8803,7 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	if (IS_ERR(tctx->io_wq)) {
 		ret = PTR_ERR(tctx->io_wq);
 		percpu_counter_destroy(&tctx->inflight);
+		kfree(tctx->registered_rings);
 		kfree(tctx);
 		return ret;
 	}
@@ -8813,6 +8828,7 @@ void __io_uring_free(struct task_struct *tsk)
 	WARN_ON_ONCE(tctx->io_wq);
 	WARN_ON_ONCE(tctx->cached_refs);
 
+	kfree(tctx->registered_rings);
 	percpu_counter_destroy(&tctx->inflight);
 	kfree(tctx);
 	tsk->io_uring = NULL;
@@ -10035,6 +10051,139 @@ void __io_uring_cancel(bool cancel_all)
 	io_uring_cancel_generic(cancel_all, NULL);
 }
 
+void io_uring_unreg_ringfd(void)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	int i;
+
+	for (i = 0; i < IO_RINGFD_REG_MAX; i++) {
+		if (tctx->registered_rings[i]) {
+			fput(tctx->registered_rings[i]);
+			tctx->registered_rings[i] = NULL;
+		}
+	}
+}
+
+static int io_ring_add_registered_fd(struct io_uring_task *tctx, int fd,
+				     int start, int end)
+{
+	struct file *file;
+	int offset;
+
+	for (offset = start; offset < end; offset++) {
+		offset = array_index_nospec(offset, IO_RINGFD_REG_MAX);
+		if (tctx->registered_rings[offset])
+			continue;
+
+		file = fget(fd);
+		if (!file) {
+			return -EBADF;
+		} else if (file->f_op != &io_uring_fops) {
+			fput(file);
+			return -EOPNOTSUPP;
+		}
+		tctx->registered_rings[offset] = file;
+		return offset;
+	}
+
+	return -EBUSY;
+}
+
+/*
+ * Register a ring fd to avoid fdget/fdput for each io_uring_enter()
+ * invocation. User passes in an array of struct io_uring_rsrc_update
+ * with ->data set to the ring_fd, and ->offset given for the desired
+ * index. If no index is desired, application may set ->offset == -1U
+ * and we'll find an available index. Returns number of entries
+ * successfully processed, or < 0 on error if none were processed.
+ */
+static int io_ringfd_register(struct io_ring_ctx *ctx, void __user *__arg,
+			      unsigned nr_args)
+{
+	struct io_uring_rsrc_update __user *arg = __arg;
+	struct io_uring_rsrc_update reg;
+	struct io_uring_task *tctx;
+	int ret, i;
+
+	if (!nr_args || nr_args > IO_RINGFD_REG_MAX)
+		return -EINVAL;
+
+	mutex_unlock(&ctx->uring_lock);
+	ret = io_uring_add_tctx_node(ctx);
+	mutex_lock(&ctx->uring_lock);
+	if (ret)
+		return ret;
+
+	tctx = current->io_uring;
+	for (i = 0; i < nr_args; i++) {
+		int start, end;
+
+		if (copy_from_user(&reg, &arg[i], sizeof(reg))) {
+			ret = -EFAULT;
+			break;
+		}
+
+		if (reg.offset == -1U) {
+			start = 0;
+			end = IO_RINGFD_REG_MAX;
+		} else {
+			if (reg.offset >= IO_RINGFD_REG_MAX) {
+				ret = -EINVAL;
+				break;
+			}
+			start = reg.offset;
+			end = start + 1;
+		}
+
+		ret = io_ring_add_registered_fd(tctx, reg.data, start, end);
+		if (ret < 0)
+			break;
+
+		reg.offset = ret;
+		if (copy_to_user(&arg[i], &reg, sizeof(reg))) {
+			fput(tctx->registered_rings[reg.offset]);
+			tctx->registered_rings[reg.offset] = NULL;
+			ret = -EFAULT;
+			break;
+		}
+	}
+
+	return i ? i : ret;
+}
+
+static int io_ringfd_unregister(struct io_ring_ctx *ctx, void __user *__arg,
+				unsigned nr_args)
+{
+	struct io_uring_rsrc_update __user *arg = __arg;
+	struct io_uring_task *tctx = current->io_uring;
+	struct io_uring_rsrc_update reg;
+	int ret = 0, i;
+
+	if (!nr_args || nr_args > IO_RINGFD_REG_MAX)
+		return -EINVAL;
+	if (!tctx)
+		return 0;
+
+	for (i = 0; i < nr_args; i++) {
+		if (copy_from_user(&reg, &arg[i], sizeof(reg))) {
+			ret = -EFAULT;
+			break;
+		}
+		if (reg.offset >= IO_RINGFD_REG_MAX) {
+			ret = -EINVAL;
+			break;
+		}
+
+		reg.offset = array_index_nospec(reg.offset, IO_RINGFD_REG_MAX);
+		if (tctx->registered_rings[reg.offset]) {
+			fput(tctx->registered_rings[reg.offset]);
+			tctx->registered_rings[reg.offset] = NULL;
+		}
+	}
+
+	return i ? i : ret;
+}
+
 static void *io_uring_validate_mmap_request(struct file *file,
 					    loff_t pgoff, size_t sz)
 {
@@ -10165,12 +10314,28 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	io_run_task_work();
 
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
-			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
+			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
+			       IORING_ENTER_REGISTERED_RING)))
 		return -EINVAL;
 
-	f = fdget(fd);
-	if (unlikely(!f.file))
-		return -EBADF;
+	/*
+	 * Ring fd has been registered via IORING_REGISTER_RING_FDS, we
+	 * need only dereference our task private array to find it.
+	 */
+	if (flags & IORING_ENTER_REGISTERED_RING) {
+		struct io_uring_task *tctx = current->io_uring;
+
+		if (fd < 0 || fd >= IO_RINGFD_REG_MAX || !tctx)
+			return -EINVAL;
+		fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
+		f.file = tctx->registered_rings[fd];
+		if (unlikely(!f.file))
+			return -EBADF;
+	} else {
+		f = fdget(fd);
+		if (unlikely(!f.file))
+			return -EBADF;
+	}
 
 	ret = -EOPNOTSUPP;
 	if (unlikely(f.file->f_op != &io_uring_fops))
@@ -10244,7 +10409,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 out:
 	percpu_ref_put(&ctx->refs);
 out_fput:
-	fdput(f);
+	if (!(flags & IORING_ENTER_REGISTERED_RING))
+		fdput(f);
 	return submitted ? submitted : ret;
 }
 
@@ -11134,6 +11300,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_iowq_max_workers(ctx, arg);
 		break;
+	case IORING_REGISTER_RING_FDS:
+		ret = io_ringfd_register(ctx, arg, nr_args);
+		break;
+	case IORING_UNREGISTER_RING_FDS:
+		ret = io_ringfd_unregister(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 649a4d7c241b..1814e698d861 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -9,11 +9,14 @@
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
+void io_uring_unreg_ringfd(void);
 
 static inline void io_uring_files_cancel(void)
 {
-	if (current->io_uring)
+	if (current->io_uring) {
+		io_uring_unreg_ringfd();
 		__io_uring_cancel(false);
+	}
 }
 static inline void io_uring_task_cancel(void)
 {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 787f491f0d2a..42b2fe84dbcd 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -257,10 +257,11 @@ struct io_cqring_offsets {
 /*
  * io_uring_enter(2) flags
  */
-#define IORING_ENTER_GETEVENTS	(1U << 0)
-#define IORING_ENTER_SQ_WAKEUP	(1U << 1)
-#define IORING_ENTER_SQ_WAIT	(1U << 2)
-#define IORING_ENTER_EXT_ARG	(1U << 3)
+#define IORING_ENTER_GETEVENTS		(1U << 0)
+#define IORING_ENTER_SQ_WAKEUP		(1U << 1)
+#define IORING_ENTER_SQ_WAIT		(1U << 2)
+#define IORING_ENTER_EXT_ARG		(1U << 3)
+#define IORING_ENTER_REGISTERED_RING	(1U << 4)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -325,6 +326,10 @@ enum {
 	/* set/get max number of io-wq workers */
 	IORING_REGISTER_IOWQ_MAX_WORKERS	= 19,
 
+	/* register/unregister io_uring fd with the ring */
+	IORING_REGISTER_RING_FDS		= 20,
+	IORING_UNREGISTER_RING_FDS		= 21,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };

-- 
Jens Axboe

