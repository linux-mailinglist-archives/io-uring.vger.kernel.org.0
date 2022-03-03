Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CB14CC2D3
	for <lists+io-uring@lfdr.de>; Thu,  3 Mar 2022 17:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbiCCQc0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 11:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiCCQcZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 11:32:25 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7A119D60C
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 08:31:39 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id q4so4480961ilt.0
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 08:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=B99Qor5NBNaDHHFFqhnqvCq9Z8A+m+mSM67Na/eYOnw=;
        b=sMYjRlq9t7jBCWMElRMWRfcX5zj6WzsLvqqy2OenTbQX70XDzlODI56TMPy7HGbc4A
         NNDjThSV3F307wMirKaigU3RiC2NpS8+mc/X8CcgZ0TadBGsBKWG64OnTW3CXGBHdU2D
         NSfMD/IMGJqrvJl+3Y5ZVXJvp5/d9GOtuaPX9c8y2+j8QQP7vUBNzkAWaOL8a2SHI1Vw
         m28vrydmlKKDl18L/YvXpKeDAMlWRRDR3ixak914Q17MWtg6IFdNUPURqNP5o+6zdW3e
         laR6ni6dehYuMgvb49DKsLuTROs2Vg/Q+njxWVHly0dRG20GFxw0Z5Oet33io8WVh4sR
         DGCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=B99Qor5NBNaDHHFFqhnqvCq9Z8A+m+mSM67Na/eYOnw=;
        b=IhUSSHtwykmcX/RbSTIAMZR7cLcCvdYt4zOGAolHWG55lfR3bxk/QAEUogcOao5yt7
         70HDbOMm50FSzEipxWKqL56X6Qcv24j3rWm4JCvn257T0mv0EPb+B2elyytiQXEHlqRA
         sp0g0gjL2Z8syNva15zEb5OepWMJabYfZ/89yIlmDBBCgWyfctU5RRKODOKnpboBvHse
         hzgFuFbxYqUgGxw8DnfaXLYt3wo+Kxn/BeWFwaP9OWr7wCjIutwYg9Yt2wen6KAPJWnr
         qCkh2KVr5GdorHbQSAqdGgDRN0dRdF31MsFON47XPRZQn8CdLoUgUZSwfkl1plD01aye
         tTfw==
X-Gm-Message-State: AOAM532rxAWk1xLqAWiJSUneMOqZAEICP00eYMmRkPUkhN48cuaaZSKT
        VqqcPiNZGZERDhpQkA/oxU3ebNejhO4q1A==
X-Google-Smtp-Source: ABdhPJwgeRjEEDz+ZH6zsqzLrXO46CJKMvwFi7vD37ugtMj1cX28hEV9q4CVOzVEP8lyGzgGSC37bg==
X-Received: by 2002:a05:6e02:190c:b0:2c2:6851:bce3 with SMTP id w12-20020a056e02190c00b002c26851bce3mr32043317ilu.28.1646325098882;
        Thu, 03 Mar 2022 08:31:38 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t8-20020a92cc48000000b002be3e8ef453sm2510772ilq.16.2022.03.03.08.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 08:31:38 -0800 (PST)
Message-ID: <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
Date:   Thu, 3 Mar 2022 09:31:36 -0700
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
In-Reply-To: <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
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

On 3/3/22 7:40 AM, Jens Axboe wrote:
> On 3/3/22 7:36 AM, Jens Axboe wrote:
>> The only potential oddity here is that the fd passed back is not a
>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
>> that could cause some confusion even if I don't think anyone actually
>> does poll(2) on io_uring.
> 
> Side note - the only implication here is that we then likely can't make
> the optimized behavior the default, it has to be an IORING_SETUP_REG
> flag which tells us that the application is aware of this limitation.
> Though I guess close(2) might mess with that too... Hmm.

Not sure I can find a good approach for that. Tried out your patch and
made some fixes:

- Missing free on final tctx free
- Rename registered_files to registered_rings
- Fix off-by-ones in checking max registration count
- Use kcalloc
- Rename ENTER_FIXED_FILE -> ENTER_REGISTERED_RING
- Don't pass in tctx to io_uring_unreg_ringfd()
- Get rid of forward declaration for adding tctx node
- Get rid of extra file pointer in io_uring_enter()
- Fix deadlock in io_ringfd_register()
- Use io_uring_rsrc_update rather than add a new struct type

Patch I ran below.

Ran some testing here, and on my laptop, running:

axboe@m1pro-kvm ~/g/fio (master)> t/io_uring -N1 -s1 -f0
polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
submitter=0, tid=673
IOPS=6627K, IOS/call=1/1, inflight=()
IOPS=6995K, IOS/call=1/1, inflight=()
IOPS=6992K, IOS/call=1/1, inflight=()
IOPS=7005K, IOS/call=1/1, inflight=()
IOPS=6999K, IOS/call=1/1, inflight=()

and with registered ring

axboe@m1pro-kvm ~/g/fio (master)> t/io_uring -N1 -s1 -f1
polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
submitter=0, tid=687
ring register 0
IOPS=7714K, IOS/call=1/1, inflight=()
IOPS=8030K, IOS/call=1/1, inflight=()
IOPS=8025K, IOS/call=1/1, inflight=()
IOPS=8015K, IOS/call=1/1, inflight=()
IOPS=8037K, IOS/call=1/1, inflight=()

which is about a 15% improvement, pretty massive...

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ad3e0b0ab3b9..8a1f97054b71 100644
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
@@ -10061,6 +10074,68 @@ void __io_uring_cancel(bool cancel_all)
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
+static int io_ringfd_register(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_uring_rsrc_update reg;
+	struct io_uring_task *tctx;
+	struct file *file;
+	int ret;
+
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+	if (reg.offset >= IO_RINGFD_REG_MAX)
+		return -EINVAL;
+
+	mutex_unlock(&ctx->uring_lock);
+	ret = io_uring_add_tctx_node(ctx);
+	mutex_lock(&ctx->uring_lock);
+	if (unlikely(ret))
+		return ret;
+
+	tctx = current->io_uring;
+	if (tctx->registered_rings[reg.offset])
+		return -EBUSY;
+	file = fget(reg.data);
+	if (unlikely(!file))
+		return -EBADF;
+	tctx->registered_rings[reg.offset] = file;
+	return 0;
+}
+
+static int io_ringfd_unregister(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	__u32 offset;
+
+	if (!tctx)
+		return 0;
+
+	if (copy_from_user(&offset, arg, sizeof(__u32)))
+		return -EFAULT;
+	if (offset >= IO_RINGFD_REG_MAX)
+		return -EINVAL;
+
+	if (tctx->registered_rings[offset]) {
+		fput(tctx->registered_rings[offset]);
+		tctx->registered_rings[offset] = NULL;
+	}
+
+	return 0;
+}
+
 static void *io_uring_validate_mmap_request(struct file *file,
 					    loff_t pgoff, size_t sz)
 {
@@ -10191,12 +10266,23 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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
@@ -10270,7 +10356,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 out:
 	percpu_ref_put(&ctx->refs);
 out_fput:
-	fdput(f);
+	if (!(flags & IORING_ENTER_REGISTERED_RING))
+		fdput(f);
 	return submitted ? submitted : ret;
 }
 
@@ -11160,6 +11247,18 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_iowq_max_workers(ctx, arg);
 		break;
+	case IORING_REGISTER_IORINGFD:
+		ret = -EINVAL;
+		if (nr_args != 1)
+			break;
+		ret = io_ringfd_register(ctx, arg);
+		break;
+	case IORING_UNREGISTER_IORINGFD:
+		ret = -EINVAL;
+		if (nr_args != 1)
+			break;
+		ret = io_ringfd_unregister(ctx, arg);
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

