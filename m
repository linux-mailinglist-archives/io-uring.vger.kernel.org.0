Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9594CC72B
	for <lists+io-uring@lfdr.de>; Thu,  3 Mar 2022 21:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiCCUml (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 15:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiCCUmk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 15:42:40 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6EA35273
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 12:41:53 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 195so5710919pgc.6
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 12:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=RCqAkicXjzX/C+1LzTwW3y3x0DD5WoMq8wJSeZ7ZZoE=;
        b=ZUhykbDL/FzTczi0cKBA58+isUH5eCP2hiUZnh20zlqDUg93qkzgkhs+cRsi5W44UV
         fOgj5E0o1qqf15hIboiTPeC8ZHlOGpV1Rrmp+jBsEDybyWO/UDoK8t3fLF7RccAq3ila
         zZ8wCDg0HSzPGKTEBGaObZjzCn4ozTTNJI8U13Xm0lwadSJXZMxpr0JkyfIy0qiStlr+
         3wy08hUGzhGjYOiK2EDzDlEP755LGI4x0CidhA5J25oFPS0nHyTN/4ADAOluNNcR6Du3
         kWJ46s43clqiOLLG0jGzk9FwbpQZWeydnY9F3bM8sgWptyTYGpusILxvd58iO+v2vaQ9
         TMJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=RCqAkicXjzX/C+1LzTwW3y3x0DD5WoMq8wJSeZ7ZZoE=;
        b=PQ6OK9bsJrwRMsOyT5nZjSbPM42pMW8VexgggPnitx2yKyyZmBiHCI29Ovy4/Ej93W
         i4x4GcasbIBlXqurvBcqpbijeMfgnlWWwRrmvKZ4JgDdaQbb09lJVYMr8/xyIBu0uxpv
         oCfUawiTmmQ1Bt7VjhWE+zlghNkbKuQxoM98UAMRZFgrqIXxWJl0oR+r2MYUGqPQkn2K
         hUsz+Pxk9hXg9eZbo8RL9MvePE9ct93jNtciutdUEOeTx1TUsM9EgahB3hhP5el2oMcM
         H/SaoKQbfHsPsJV6hRO9xB86A+7aPJ90rcuOFybA6KE6AyrGwdqd+kH2HZu7wXiIaXid
         D9JA==
X-Gm-Message-State: AOAM531A7X3QRAsIGtkqVQ/btrO9R9Hki0EAbQlitoV8XGlmnJw8WheO
        srfOeupHI7UNkiCePOwa75JKdQ==
X-Google-Smtp-Source: ABdhPJw25ShzQshUm8hSE5XsWUBbNzwAspW1SOuGtjwyQmR0CGkg2Ak7tP1IV2wMNCz9+Gb/bwOyfw==
X-Received: by 2002:a63:474f:0:b0:374:7607:e45 with SMTP id w15-20020a63474f000000b0037476070e45mr32268633pgk.234.1646340112802;
        Thu, 03 Mar 2022 12:41:52 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j5-20020a63cf05000000b00376c11ff251sm2660724pgg.66.2022.03.03.12.41.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 12:41:52 -0800 (PST)
Message-ID: <8466f91e-416e-d53e-8c24-47a0b20412ac@kernel.dk>
Date:   Thu, 3 Mar 2022 13:41:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <66bfc962-b983-e737-7c36-85784c52b7fa@kernel.dk>
In-Reply-To: <66bfc962-b983-e737-7c36-85784c52b7fa@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/22 10:18 AM, Jens Axboe wrote:
> On 3/3/22 9:31 AM, Jens Axboe wrote:
>> On 3/3/22 7:40 AM, Jens Axboe wrote:
>>> On 3/3/22 7:36 AM, Jens Axboe wrote:
>>>> The only potential oddity here is that the fd passed back is not a
>>>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
>>>> that could cause some confusion even if I don't think anyone actually
>>>> does poll(2) on io_uring.
>>>
>>> Side note - the only implication here is that we then likely can't make
>>> the optimized behavior the default, it has to be an IORING_SETUP_REG
>>> flag which tells us that the application is aware of this limitation.
>>> Though I guess close(2) might mess with that too... Hmm.
>>
>> Not sure I can find a good approach for that. Tried out your patch and
>> made some fixes:
>>
>> - Missing free on final tctx free
>> - Rename registered_files to registered_rings
>> - Fix off-by-ones in checking max registration count
>> - Use kcalloc
>> - Rename ENTER_FIXED_FILE -> ENTER_REGISTERED_RING
>> - Don't pass in tctx to io_uring_unreg_ringfd()
>> - Get rid of forward declaration for adding tctx node
>> - Get rid of extra file pointer in io_uring_enter()
>> - Fix deadlock in io_ringfd_register()
>> - Use io_uring_rsrc_update rather than add a new struct type
> 
> - Allow multiple register/unregister instead of enforcing just 1 at the
>   time
> - Check for it really being a ring fd when registering
> 
> For different batch counts, nice improvements are seen. Roughly:
> 
> Batch==1	15% faster
> Batch==2	13% faster
> Batch==4	11% faster
> 
> This is just in microbenchmarks where the fdget/fdput play a bigger
> factor, but it will certainly help with real world situations where
> batching is more limited than in benchmarks.

In trying this out in applications, I think the better registration API
is to allow io_uring to pick the offset. The application doesn't care,
it's just a magic integer there. And if we allow io_uring to pick it,
then that makes things a lot easier to deal with.

For registration, pass in an array of io_uring_rsrc_update structs, just
filling in the ring_fd in the data field. Return value is number of ring
fds registered, and up->offset now contains the chosen offset for each
of them.

Unregister is the same struct, but just with offset filled in.

For applications using io_uring, which is all of them as far as I'm
aware, we can also easily hide this. This means we can get the optimized
behavior by default.

What do you think?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index ad3e0b0ab3b9..e3be96e81164 100644
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
 
@@ -8806,8 +8812,16 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
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
@@ -8816,6 +8830,7 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	if (IS_ERR(tctx->io_wq)) {
 		ret = PTR_ERR(tctx->io_wq);
 		percpu_counter_destroy(&tctx->inflight);
+		kfree(tctx->registered_rings);
 		kfree(tctx);
 		return ret;
 	}
@@ -8840,6 +8855,7 @@ void __io_uring_free(struct task_struct *tsk)
 	WARN_ON_ONCE(tctx->io_wq);
 	WARN_ON_ONCE(tctx->cached_refs);
 
+	kfree(tctx->registered_rings);
 	percpu_counter_destroy(&tctx->inflight);
 	kfree(tctx);
 	tsk->io_uring = NULL;
@@ -10061,6 +10077,121 @@ void __io_uring_cancel(bool cancel_all)
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
+static int io_ring_add_registered_fd(struct io_uring_task *tctx, int fd)
+{
+	struct file *file;
+	int offset;
+
+	for (offset = 0; offset < IO_RINGFD_REG_MAX; offset++) {
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
+static int io_ringfd_register(struct io_ring_ctx *ctx, void __user *arg,
+			      unsigned nr_args)
+{
+	struct io_uring_rsrc_update reg;
+	struct io_uring_task *tctx;
+	int ret, nr, i;
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
+		if (copy_from_user(&reg, arg, sizeof(reg))) {
+			ret = -EFAULT;
+			break;
+		}
+		if (reg.offset >= IO_RINGFD_REG_MAX) {
+			ret = -EINVAL;
+			break;
+		}
+
+		ret = io_ring_add_registered_fd(tctx, reg.data);
+		if (ret < 0)
+			break;
+
+		reg.offset = ret;
+		if (copy_to_user(arg, &reg, sizeof(reg))) {
+			fput(tctx->registered_rings[reg.offset]);
+			tctx->registered_rings[reg.offset] = NULL;
+			ret = -EFAULT;
+			break;
+		}
+		arg += sizeof(reg);
+		nr++;
+	}
+
+	return nr ? nr : ret;
+}
+
+static int io_ringfd_unregister(struct io_ring_ctx *ctx, void __user *arg,
+				unsigned nr_args)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	struct io_uring_rsrc_update reg;
+	int ret, nr, i;
+
+	if (!nr_args || nr_args > IO_RINGFD_REG_MAX)
+		return -EINVAL;
+	if (!tctx)
+		return 0;
+
+	ret = nr = 0;
+	for (i = 0; i < nr_args; i++) {
+		if (copy_from_user(&reg, arg, sizeof(reg))) {
+			ret = -EFAULT;
+			break;
+		}
+		if (reg.offset >= IO_RINGFD_REG_MAX) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (tctx->registered_rings[reg.offset]) {
+			fput(tctx->registered_rings[reg.offset]);
+			tctx->registered_rings[reg.offset] = NULL;
+		}
+		arg += sizeof(reg);
+		nr++;
+	}
+
+	return nr ? nr : ret;
+}
+
 static void *io_uring_validate_mmap_request(struct file *file,
 					    loff_t pgoff, size_t sz)
 {
@@ -10191,12 +10322,23 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	io_run_task_work();
 
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
-			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
+			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
+			       IORING_ENTER_REGISTERED_RING)))
 		return -EINVAL;
 
-	f = fdget(fd);
-	if (unlikely(!f.file))
-		return -EBADF;
+	if (flags & IORING_ENTER_REGISTERED_RING) {
+		struct io_uring_task *tctx = current->io_uring;
+
+		if (fd >= IO_RINGFD_REG_MAX || !tctx)
+			return -EINVAL;
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
@@ -10270,7 +10412,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 out:
 	percpu_ref_put(&ctx->refs);
 out_fput:
-	fdput(f);
+	if (!(flags & IORING_ENTER_REGISTERED_RING))
+		fdput(f);
 	return submitted ? submitted : ret;
 }
 
@@ -11160,6 +11303,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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

