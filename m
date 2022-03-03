Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5EA4CC38E
	for <lists+io-uring@lfdr.de>; Thu,  3 Mar 2022 18:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbiCCRTC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 12:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiCCRTB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 12:19:01 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7840DDF488
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 09:18:14 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id w4so4563633ilj.5
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 09:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=t+Zzwf9xU/NfWk7moQbHdu4OeT0cXa8C1pDV8nUi2PE=;
        b=N9UYMil9P0nwDs60s6vKTlxzQguImG4fD/Wu4sjqOkvXZSKwaRbrb+JG5Wh7HNPi0e
         yPUvDFWyTKXynydmUF+aMapcMSIqe+laek6ZoZbOmbszwfBwf2C/1TJOpCXw30qvRU1n
         OXpkpHQqblgJvZLe2tM/Nmm4/FMXSXCbgGEWddYAKHlLFuWNMv3GvitlTvrt1sMR3+22
         +pAED74Ibpru8N1fEOEDoEXsKMOJZ6z30TrSFGTGepQRBglkIqddTwFwBoOgcxz4jIri
         MABcN1rYWlnf8LWp+a1FTmVQkc76Vfr4+jpTHrXUg0+wnRb+lcYn+6ByISJM277jewr/
         gqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=t+Zzwf9xU/NfWk7moQbHdu4OeT0cXa8C1pDV8nUi2PE=;
        b=k8fUOxDgpczE+p5qCaLd/qBbjz7KeTfZjv5ZtGbjmuirdk1YRt10DXwnUERGAHEJCV
         kCyFWglGO1051tg7gPFvIXwrOYoWvlbV8I5C1XDjje9m1McAGAkmIUVfgd8g47glKMBP
         tbmf5WUf+lNK5PLvg0ysEml+e5m/RgHUFRXLdivsFO/9k81hxkmSQuxAHcObL2hmnBqf
         /nJ+UMTGyRWvhzclvnML4vG5T0hrvwXkl/AUUVuiMlBH6kE1yiMSRbWTJayn1d3VQ8FK
         C6SgG9xzIjkvcG46c0UshmKemjGjYt9BR3Q7G7k6Vy1ywK5ctqxU9hgvMwUxPJTRO++E
         5+fA==
X-Gm-Message-State: AOAM533CUDIUS1zprqmLSra9Zwlk/nN/WgFS0myxbENXlXs1VGV7X6VA
        iLEXjLOHlfmh0FgL8hFJ6ob0VA==
X-Google-Smtp-Source: ABdhPJxAltOFVm6QKsElu9I92NMUeTIKsyLmi2PBYbvJ30FvhULyOFlL0PjTFbdeylFhBgRGWzH5BQ==
X-Received: by 2002:a92:b501:0:b0:2c2:5e63:ddae with SMTP id f1-20020a92b501000000b002c25e63ddaemr31958552ile.311.1646327893708;
        Thu, 03 Mar 2022 09:18:13 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k15-20020a92c24f000000b002c2e03c5925sm3164416ilo.8.2022.03.03.09.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 09:18:13 -0800 (PST)
Message-ID: <66bfc962-b983-e737-7c36-85784c52b7fa@kernel.dk>
Date:   Thu, 3 Mar 2022 10:18:12 -0700
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
In-Reply-To: <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
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

On 3/3/22 9:31 AM, Jens Axboe wrote:
> On 3/3/22 7:40 AM, Jens Axboe wrote:
>> On 3/3/22 7:36 AM, Jens Axboe wrote:
>>> The only potential oddity here is that the fd passed back is not a
>>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
>>> that could cause some confusion even if I don't think anyone actually
>>> does poll(2) on io_uring.
>>
>> Side note - the only implication here is that we then likely can't make
>> the optimized behavior the default, it has to be an IORING_SETUP_REG
>> flag which tells us that the application is aware of this limitation.
>> Though I guess close(2) might mess with that too... Hmm.
> 
> Not sure I can find a good approach for that. Tried out your patch and
> made some fixes:
> 
> - Missing free on final tctx free
> - Rename registered_files to registered_rings
> - Fix off-by-ones in checking max registration count
> - Use kcalloc
> - Rename ENTER_FIXED_FILE -> ENTER_REGISTERED_RING
> - Don't pass in tctx to io_uring_unreg_ringfd()
> - Get rid of forward declaration for adding tctx node
> - Get rid of extra file pointer in io_uring_enter()
> - Fix deadlock in io_ringfd_register()
> - Use io_uring_rsrc_update rather than add a new struct type

- Allow multiple register/unregister instead of enforcing just 1 at the
  time
- Check for it really being a ring fd when registering

For different batch counts, nice improvements are seen. Roughly:

Batch==1	15% faster
Batch==2	13% faster
Batch==4	11% faster

This is just in microbenchmarks where the fdget/fdput play a bigger
factor, but it will certainly help with real world situations where
batching is more limited than in benchmarks.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ad3e0b0ab3b9..452e68b73e1f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -466,6 +466,8 @@ struct io_ring_ctx {
 	};
 };
 
+#define IO_RINGFD_REG_MAX 16
+
 struct io_uring_task {
 	/* submission side */
 	int			cached_refs;
@@ -481,6 +483,7 @@ struct io_uring_task {
 	struct io_wq_work_list	task_list;
 	struct io_wq_work_list	prior_task_list;
 	struct callback_head	task_work;
+	struct file		**registered_rings;
 	bool			task_running;
 };
 
@@ -8806,8 +8809,16 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
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
@@ -8816,6 +8827,7 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	if (IS_ERR(tctx->io_wq)) {
 		ret = PTR_ERR(tctx->io_wq);
 		percpu_counter_destroy(&tctx->inflight);
+		kfree(tctx->registered_rings);
 		kfree(tctx);
 		return ret;
 	}
@@ -8840,6 +8852,7 @@ void __io_uring_free(struct task_struct *tsk)
 	WARN_ON_ONCE(tctx->io_wq);
 	WARN_ON_ONCE(tctx->cached_refs);
 
+	kfree(tctx->registered_rings);
 	percpu_counter_destroy(&tctx->inflight);
 	kfree(tctx);
 	tsk->io_uring = NULL;
@@ -10061,6 +10074,103 @@ void __io_uring_cancel(bool cancel_all)
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
+static int io_ringfd_register(struct io_ring_ctx *ctx, void __user *arg,
+			      unsigned nr_args)
+{
+	struct io_uring_rsrc_update reg;
+	struct io_uring_task *tctx;
+	struct file *file;
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
+		if (tctx->registered_rings[reg.offset]) {
+			ret = -EBUSY;
+			break;
+		}
+		file = fget(reg.data);
+		if (!file) {
+			ret = -EBADF;
+			break;
+		} else if (file->f_op != &io_uring_fops) {
+			ret = -EOPNOTSUPP;
+			fput(file);
+			break;
+		}
+
+		tctx->registered_rings[reg.offset] = file;
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
@@ -10191,12 +10301,23 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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
@@ -10270,7 +10391,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 out:
 	percpu_ref_put(&ctx->refs);
 out_fput:
-	fdput(f);
+	if (!(flags & IORING_ENTER_REGISTERED_RING))
+		fdput(f);
 	return submitted ? submitted : ret;
 }
 
@@ -11160,6 +11282,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_iowq_max_workers(ctx, arg);
 		break;
+	case IORING_REGISTER_IORINGFD:
+		ret = io_ringfd_register(ctx, arg, nr_args);
+		break;
+	case IORING_UNREGISTER_IORINGFD:
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
index 787f491f0d2a..a36d31f2cc66 100644
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
+	IORING_REGISTER_IORINGFD		= 20,
+	IORING_UNREGISTER_IORINGFD		= 21,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };

-- 
Jens Axboe

