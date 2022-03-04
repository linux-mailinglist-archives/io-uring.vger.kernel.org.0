Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A694CD81F
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 16:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbiCDPlM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Mar 2022 10:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbiCDPlM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Mar 2022 10:41:12 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A045E6D396
        for <io-uring@vger.kernel.org>; Fri,  4 Mar 2022 07:40:24 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id z15so7909617pfe.7
        for <io-uring@vger.kernel.org>; Fri, 04 Mar 2022 07:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=6A9XHF+0kSb2ECpMi76xq7xWhcj0be+alkhN7c2S3N0=;
        b=5mYtY0lQg/xcjxRgb9Zk3ZpbmBvRblh5w1SM49qsrWKxzmF1KkprYrZMaAfLQh+KJl
         yhrJFe2361eNH8wphRZdI3FR1k8O6A2DpGFnQ32tZPBLqtHqSYi3hiwfDjuO4HQJZaUr
         HBq4SkVbv4LmriNKGW72H0pYmWfcvs2em58pUi0Gg3+PS5qtYBR4FYoV7osm2CDLd5wm
         14onz6YlpxmHZUSGvBG6nFlQn6SIQPz9E8+Qvdq8VMDJhbQIgwPjJXBdKTZdwZVfMIkW
         8T2z+eZlSo7vsX7D1KBdfWrR2WvQPv6QoLZGsfoZNIWHstxoC/HoBn97UQIc1Wxzg1Y9
         TFpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=6A9XHF+0kSb2ECpMi76xq7xWhcj0be+alkhN7c2S3N0=;
        b=qGNuPwYBI2DpQSKBeL1g/MUT06Z2p+suy1kOgzJmjlpod3pSLoezCrnZwdNZPJW3I4
         hpIPprNqq5/VpRP+doQZJQIgqUpdQunvWrM6eARfpJq3Sh0SuKl3KQjaafpJHvsTvcdX
         08nM1lPqR0XAFguNgP76g8lO3azfuclTFVgPLOy685a1HLKqvozQ//9iIbi+I1IIq2Vn
         D5A5kqF1BFXsZ0M2FHmnCj4wSyZ7p4pH08uDRfU3IggePhko4oMDzlUl9g6680YsmSEo
         GbDSZIgDbM2BlZHr0eEz45JQHU4OvFSAR2gd3SeIzlMNTaahlZ4lGOa+Y5qd0Um7YZAj
         znCA==
X-Gm-Message-State: AOAM532YfeAlj/VnZL+tvbxlrCygRgrWuLkY1w5sip6YWsl/Gsz/9Fsp
        kpQSO9PvjOcOBBKVNYZ9YHT6lc9KixNf0A==
X-Google-Smtp-Source: ABdhPJz0z9vwN9IYNUtuzrA1forpLEv5GAM35UJpPsWyv6QE8fqUHNhD8XIwRoMXIhzdX9+4QLHmIg==
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr43732946pfu.59.1646408423743;
        Fri, 04 Mar 2022 07:40:23 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t7-20020a17090a024700b001bf12386db4sm4413988pje.47.2022.03.04.07.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 07:40:23 -0800 (PST)
Message-ID: <d9006863-09a1-8da3-a5ab-b8639ae31621@kernel.dk>
Date:   Fri, 4 Mar 2022 08:40:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: add support for registering ring file descriptors
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Lots of workloads use multiple threads, in which case the file table is
shared between them. This makes getting and putting the ring file
descriptor for each io_uring_enter(2) system call more expensive, as it
involves an atomic get and put for each call.

Similarly to how we allow registering normal file descriptors to avoid
this overhead, add support for an io_uring_register(2) API that allows
to register the ring fds themselves:

1) IORING_REGISTER_RING_FDS - takes an array of io_uring_rsrc_update
   structs, and registers them with the task.
2) IORING_UNREGISTER_RING_FDS - takes an array of io_uring_src_update
   structs, and unregisters them.

When a ring fd is registered, it is internally represented by an offset.
This offset is returned to the application, and the application then
uses this offset and sets IORING_ENTER_REGISTERED_RING for the
io_uring_enter(2) system call. This works just like using a registered
file descriptor, rather than a real one, in an SQE, where
IOSQE_FIXED_FILE gets set to tell io_uring that we're using an internal
offset/descriptor rather than a real file descriptor.

In initial testing, this provides a nice bump in performance for
threaded applications in real world cases where the batch count (eg
number of requests submitted per io_uring_enter(2) invocation) is low.
In a microbenchmark, submitting NOP requests, we see the following
increases in performance:

Requests per syscall    Baseline        Registered      Increase
----------------------------------------------------------------
1                        ~7030K          ~8080K         +15%
2                       ~13120K         ~14800K         +13%
4                       ~22740K         ~25300K         +11%

Co-developed-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Also see the initial liburing support here:

https://git.kernel.dk/cgit/liburing/log/?h=registered-ring

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

