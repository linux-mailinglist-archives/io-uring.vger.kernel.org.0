Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F5C4A789A
	for <lists+io-uring@lfdr.de>; Wed,  2 Feb 2022 20:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiBBTSx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Feb 2022 14:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiBBTSx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Feb 2022 14:18:53 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B49C06173B
        for <io-uring@vger.kernel.org>; Wed,  2 Feb 2022 11:18:53 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id 15so202611ilg.8
        for <io-uring@vger.kernel.org>; Wed, 02 Feb 2022 11:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FMc8JBKlrOYeYGw8dVwiSDRJ6LUzWB3sjdP9f0LPHxE=;
        b=g+wEKrFCRKneUWZCUs0NWd+3eHO6PIBp36MZ0cTmLzj7s8VAZIeM1j/rpCPNAQZgPQ
         pUghmrTyeg+0pr+p60D/otdrSUgdTWBCqjt0GOtxxTW2ilALlKg3BzoIsZ0fQo4nuv20
         plrkuwReX2pMs+56c1fZZgVEDeP+XP+9hFxYdjq2tND96fcX+iIy+5taBW3EObl2AARf
         L4+kl5KHE3cM9us/4zUSBP1Tbf5eK2vHQhGPGGmISvjZ1qp7kfH3Y2B5CxRqI6urT4u0
         l0lnXGENjxyIgHzpj6mrmOw9XmSFsNKu6JiZXZ7xzyM8XPcURcK7OzKINfHbSYCC907q
         4vjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FMc8JBKlrOYeYGw8dVwiSDRJ6LUzWB3sjdP9f0LPHxE=;
        b=Zh158MnHiyi8ls5OmEdd9KszXSQan6GjAn/sKPGYnf+I8E31mpyHkXpzOjKvFRlLV+
         MS/22/1wvRedgn9LIDpLSeu4ZDTUA++0AfioTp2iV6wPqje45cAIoSP8U/R2tg1T5Uoq
         cRVhJgjSyxOjxx1/D+tTfg2WbdF2quHRwaEFnu9adqUPN+YUiR8FRPisOSFddCYljUan
         xyZtnYWvMSXGHLWHvRRB/I3whZYqZYGbK2Ow+Htl8uz6wxO7d4ECkRvXeQVgRnEXhOAC
         SmZ6PPnIpKg19YXwJXYytM0NxZOaovLBreKxcBWkR3BgM/hgjJWl9IPvg4xYeP3B1/GO
         Xlvg==
X-Gm-Message-State: AOAM53142X3naYDYl9RVMIuww6lHqWN8h0on8xQmENicRNgiLvHOAPF6
        pW98iztmc8ZbuEIbpnBXC0da4hrr5/xM4g==
X-Google-Smtp-Source: ABdhPJzGQ+mJDhdnb2FQPKkXvqGRb5gdiycMvmioL4bSdbo/ND7uJ9Iz8jjyAgPW6wxZTk4pVjw7Ag==
X-Received: by 2002:a05:6e02:19cd:: with SMTP id r13mr6391531ill.76.1643829532296;
        Wed, 02 Feb 2022 11:18:52 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i3sm22279584ilu.28.2022.02.02.11.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 11:18:51 -0800 (PST)
Subject: Re: [RFC] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
From:   Jens Axboe <axboe@kernel.dk>
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220202155923.4117285-1-usama.arif@bytedance.com>
 <86ae792e-d138-112e-02bb-ab70e3c2a147@kernel.dk>
Message-ID: <7df1059c-6151-29c8-9ed5-0bc0726c362d@kernel.dk>
Date:   Wed, 2 Feb 2022 12:18:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <86ae792e-d138-112e-02bb-ab70e3c2a147@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/22 9:57 AM, Jens Axboe wrote:
> On 2/2/22 8:59 AM, Usama Arif wrote:
>> Acquire completion_lock at the start of __io_uring_register before
>> registering/unregistering eventfd and release it at the end. Hence
>> all calls to io_cqring_ev_posted which adds to the eventfd counter
>> will finish before acquiring the spin_lock in io_uring_register, and
>> all new calls will wait till the eventfd is registered. This avoids
>> ring quiesce which is much more expensive than acquiring the
>> spin_lock.
>>
>> On the system tested with this patch, io_uring_reigster with
>> IORING_REGISTER_EVENTFD takes less than 1ms, compared to 15ms before.
> 
> This seems like optimizing for the wrong thing, so I've got a few
> questions. Are you doing a lot of eventfd registrations (and
> unregister) in your workload? Or is it just the initial pain of
> registering one? In talking to Pavel, he suggested that RCU might be a
> good use case here, and I think so too. That would still remove the
> need to quiesce, and the posted side just needs a fairly cheap rcu
> read lock/unlock around it.

Totally untested, but perhaps can serve as a starting point or
inspiration.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 64c055421809..195752f4823f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -329,6 +329,12 @@ struct io_submit_state {
 	struct blk_plug		plug;
 };
 
+struct io_ev_fd {
+	struct eventfd_ctx	*cq_ev_fd;
+	struct io_ring_ctx	*ctx;
+	struct rcu_head		rcu;
+};
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
@@ -412,7 +418,7 @@ struct io_ring_ctx {
 	struct {
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
-		struct eventfd_ctx	*cq_ev_fd;
+		struct io_ev_fd		*io_ev_fd;
 		struct wait_queue_head	cq_wait;
 		unsigned		cq_extra;
 		atomic_t		cq_timeouts;
@@ -1741,13 +1747,27 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 
 static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 {
-	if (likely(!ctx->cq_ev_fd))
+	if (likely(!ctx->io_ev_fd))
 		return false;
 	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
 		return false;
 	return !ctx->eventfd_async || io_wq_current_is_worker();
 }
 
+static void io_eventfd_signal(struct io_ring_ctx *ctx)
+{
+	struct io_ev_fd *ev_fd;
+
+	if (!io_should_trigger_evfd(ctx))
+		return;
+
+	rcu_read_lock();
+	ev_fd = READ_ONCE(ctx->io_ev_fd);
+	if (ev_fd)
+		eventfd_signal(ev_fd->cq_ev_fd, 1);
+	rcu_read_unlock();
+}
+
 /*
  * This should only get called when at least one event has been posted.
  * Some applications rely on the eventfd notification count only changing
@@ -1764,8 +1784,7 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 	 */
 	if (wq_has_sleeper(&ctx->cq_wait))
 		wake_up_all(&ctx->cq_wait);
-	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
+	io_eventfd_signal(ctx);
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1777,8 +1796,7 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 		if (waitqueue_active(&ctx->cq_wait))
 			wake_up_all(&ctx->cq_wait);
 	}
-	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
+	io_eventfd_signal(ctx);
 }
 
 /* Returns true if there are no backlogged entries after the flush */
@@ -9569,31 +9587,49 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 
 static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 {
+	struct io_ev_fd *ev_fd;
 	__s32 __user *fds = arg;
 	int fd;
 
-	if (ctx->cq_ev_fd)
+	if (ctx->io_ev_fd)
 		return -EBUSY;
 
 	if (copy_from_user(&fd, fds, sizeof(*fds)))
 		return -EFAULT;
 
-	ctx->cq_ev_fd = eventfd_ctx_fdget(fd);
-	if (IS_ERR(ctx->cq_ev_fd)) {
-		int ret = PTR_ERR(ctx->cq_ev_fd);
+	ev_fd = kmalloc(sizeof(*ev_fd), GFP_KERNEL);
+	if (!ev_fd)
+		return -ENOMEM;
+
+	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
+	if (IS_ERR(ev_fd->cq_ev_fd)) {
+		int ret = PTR_ERR(ev_fd->cq_ev_fd);
 
-		ctx->cq_ev_fd = NULL;
+		kfree(ev_fd);
 		return ret;
 	}
 
+	ev_fd->ctx = ctx;
+	WRITE_ONCE(ctx->io_ev_fd, ev_fd);
 	return 0;
 }
 
+static void io_eventfd_put(struct rcu_head *rcu)
+{
+	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
+	struct io_ring_ctx *ctx = ev_fd->ctx;
+
+	eventfd_ctx_put(ev_fd->cq_ev_fd);
+	kfree(ev_fd);
+	WRITE_ONCE(ctx->io_ev_fd, NULL);
+}
+
 static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 {
-	if (ctx->cq_ev_fd) {
-		eventfd_ctx_put(ctx->cq_ev_fd);
-		ctx->cq_ev_fd = NULL;
+	struct io_ev_fd *ev_fd = ctx->io_ev_fd;
+
+	if (ev_fd) {
+		call_rcu(&ev_fd->rcu, io_eventfd_put);
 		return 0;
 	}
 
@@ -9659,7 +9695,10 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true);
 	mutex_unlock(&ctx->uring_lock);
-	io_eventfd_unregister(ctx);
+	if (ctx->io_ev_fd) {
+		eventfd_ctx_put(ctx->io_ev_fd->cq_ev_fd);
+		kfree(ctx->io_ev_fd);
+	}
 	io_destroy_buffers(ctx);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
@@ -11209,6 +11248,8 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_UNREGISTER_IOWQ_AFF:
 	case IORING_REGISTER_IOWQ_MAX_WORKERS:
 	case IORING_REGISTER_MAP_BUFFERS:
+	case IORING_REGISTER_EVENTFD:
+	case IORING_UNREGISTER_EVENTFD:
 		return false;
 	default:
 		return true;
@@ -11423,7 +11464,7 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	ret = __io_uring_register(ctx, opcode, arg, nr_args);
 	mutex_unlock(&ctx->uring_lock);
 	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs,
-							ctx->cq_ev_fd != NULL, ret);
+							ctx->io_ev_fd != NULL, ret);
 out_fput:
 	fdput(f);
 	return ret;

-- 
Jens Axboe

