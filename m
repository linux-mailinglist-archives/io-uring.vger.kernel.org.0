Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4677A2A6C33
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 18:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbgKDRu6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 12:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKDRu6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 12:50:58 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD6CC0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 09:50:56 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id k1so20059826ilc.10
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 09:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=My/vdMJL2DOzqrdGARcIOVVrjE2z9y0FhYe6fFZddeY=;
        b=DjZS6vJv1a1+lWK7uuowZgDfmIa8QOO5fAsvt63DgeqKrzP71QBojpFTVu8GuajhJ6
         8GEOKnDn6Uqw5/+9HPJIi/lL9tbzKSEpnNreQDjrpzgWqyMvfMOq+56ba7DLGLpe/qvZ
         KWq5HHjr4yozEGDTU6R0TAyFj1ALVjG3lmq2oUZW+B9djy2uvBzAWTDNP1AjruK+hcJ6
         K7bqxj9h3M7RI2yqZfTm1IWgNm2f6vrrAyUUQ7DSkdmIYIKKXPJqCrN6taJAXDeBQhCl
         gfgeP5OOUaHGXUC4B98/o1A9hSrAjjHrdjyksNOrwWYAtKKPAeenz+W06yqreCxvSiEZ
         kB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=My/vdMJL2DOzqrdGARcIOVVrjE2z9y0FhYe6fFZddeY=;
        b=LRZSQx4lw5SxetOJnhSD5bbJPdHcxbvpVr8f8jJYpY8SB3U7rhv0seVbRLvQQARy7r
         Psyhktnk31fH3+QhKRpb3d3cCLaSt40Kpjj/2L+SbOC5OFEQy/IKhZwAd8UoSarHnAR4
         1jkZILUye0xjejIoIOW7YftRI4vFd5tcQszNwKSKaytraRlDjE89w/mmhz2AxMyInEqp
         kB2Lg+DgBqv2df0BVsWjQNCRxxLBT1gh9Rt85m9tcZEuqHcT2SLKVCxsFjevw6oolS9h
         bEYTnXEG5LZF1wjbkkC1DQUuhOp13ZnwVTxwW9pWFZKt1/OJjb8F8+1Pe0kb8NRq4K1z
         wGfQ==
X-Gm-Message-State: AOAM531cIXDC1v1lYarSxhrbocEcjZhel/vJfD6Ys9+WXjWLw66cB4kN
        xKFp/KTOEl6PR1dsCmxi6bJh7/9HGPq3SA==
X-Google-Smtp-Source: ABdhPJykiDfIW1EhmPotrHk1MOEclSGQoFfpZp1rLfRB1lU6dQcjlcNQoCIC6qJTT/ybcxKVUdH1Mw==
X-Received: by 2002:a92:540e:: with SMTP id i14mr20359556ilb.108.1604512256110;
        Wed, 04 Nov 2020 09:50:56 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p18sm1754278ile.72.2020.11.04.09.50.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 09:50:55 -0800 (PST)
Subject: Re: [PATCH v3 RESEND] io_uring: add timeout support for
 io_uring_enter()
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, metze@samba.org,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1604307047-50980-1-git-send-email-haoxu@linux.alibaba.com>
 <1604372077-179941-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c2ae5254-d558-a48f-fca2-0759781bf3e1@kernel.dk>
Date:   Wed, 4 Nov 2020 10:50:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1604372077-179941-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/2/20 7:54 PM, Hao Xu wrote:
> Now users who want to get woken when waiting for events should submit a
> timeout command first. It is not safe for applications that split SQ and
> CQ handling between two threads, such as mysql. Users should synchronize
> the two threads explicitly to protect SQ and that will impact the
> performance.
> 
> This patch adds support for timeout to existing io_uring_enter(). To
> avoid overloading arguments, it introduces a new parameter structure
> which contains sigmask and timeout.
> 
> I have tested the workloads with one thread submiting nop requests
> while the other reaping the cqe with timeout. It shows 1.8~2x faster
> when the iodepth is 16.

I have applied this one for 5.11 with a caveat - you generated it against
some older base, so some parts had to be hand applied. But the important
bit is that the values you chose for >IORING_ENTER_GETEVENTS_TIMEOUT and
IORING_FEAT_GETEVENTS_TIMEOUT are already in use in 5.10 (let alone
5.11 pending), so they had to be renumbered. Just something to keep in
mind if you have existing code/apps that rely on the value in your
patches.

It'd also be great if you could submit a liburing path for adding these
definitions, and with a test case as well. All new features should come
with a test case for liburing. This one in particular will enable
io_uring_wait_cqes() to work without queueing an internal timeout, so
it'll be a nice cleanup. I might just do this one myself, unless you
feel so inclined to tackle that one, too.


commit f84ccf564ee28205f87bea4f3925cf9a4c2ad0e3
Author: Hao Xu <haoxu@linux.alibaba.com>
Date:   Tue Nov 3 10:54:37 2020 +0800

    io_uring: add timeout support for io_uring_enter()
    
    Now users who want to get woken when waiting for events should submit a
    timeout command first. It is not safe for applications that split SQ and
    CQ handling between two threads, such as mysql. Users should synchronize
    the two threads explicitly to protect SQ and that will impact the
    performance.
    
    This patch adds support for timeout to existing io_uring_enter(). To
    avoid overloading arguments, it introduces a new parameter structure
    which contains sigmask and timeout.
    
    I have tested the workloads with one thread submiting nop requests
    while the other reaping the cqe with timeout. It shows 1.8~2x faster
    when the iodepth is 16.
    
    Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
    Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 864751d64097..9b9941e0b818 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7110,7 +7110,8 @@ static int io_run_task_work_sig(void)
  * application must reap them itself, as they reside on the shared cq ring.
  */
 static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
-			  const sigset_t __user *sig, size_t sigsz)
+			  const sigset_t __user *sig, size_t sigsz,
+			  struct __kernel_timespec __user *uts)
 {
 	struct io_wait_queue iowq = {
 		.wq = {
@@ -7122,6 +7123,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		.to_wait	= min_events,
 	};
 	struct io_rings *rings = ctx->rings;
+	struct timespec64 ts;
+	signed long timeout = 0;
 	int ret = 0;
 
 	do {
@@ -7144,6 +7147,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			return ret;
 	}
 
+	if (uts) {
+		if (get_timespec64(&ts, uts))
+			return -EFAULT;
+		timeout = timespec64_to_jiffies(&ts);
+	}
+
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
@@ -7157,7 +7166,15 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			break;
 		if (io_should_wake(&iowq, false))
 			break;
-		schedule();
+		if (uts) {
+			timeout = schedule_timeout(timeout);
+			if (timeout == 0) {
+				ret = -ETIME;
+				break;
+			}
+		} else {
+			schedule();
+		}
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
 
@@ -9130,20 +9147,38 @@ static void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 }
 
 SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
-		u32, min_complete, u32, flags, const sigset_t __user *, sig,
+		u32, min_complete, u32, flags, const void __user *, argp,
 		size_t, sigsz)
 {
 	struct io_ring_ctx *ctx;
 	long ret = -EBADF;
 	int submitted = 0;
 	struct fd f;
+	const sigset_t __user *sig;
+	struct __kernel_timespec __user *ts;
+	struct io_uring_getevents_arg arg;
 
 	io_run_task_work();
 
 	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
-			IORING_ENTER_SQ_WAIT))
+			IORING_ENTER_SQ_WAIT | IORING_ENTER_GETEVENTS_TIMEOUT))
 		return -EINVAL;
 
+	/* deal with IORING_ENTER_GETEVENTS_TIMEOUT */
+	if (flags & IORING_ENTER_GETEVENTS_TIMEOUT) {
+		if (!(flags & IORING_ENTER_GETEVENTS))
+			return -EINVAL;
+		if (sigsz != sizeof(arg))
+			return -EINVAL;
+		if (copy_from_user(&arg, argp, sizeof(arg)))
+			return -EFAULT;
+		sig = arg.sigmask;
+		ts = arg.ts;
+	} else {
+		sig = (const sigset_t __user *)argp;
+		ts = NULL;
+	}
+
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
@@ -9199,7 +9234,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
 			ret = io_iopoll_check(ctx, min_complete);
 		} else {
-			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
+			ret = io_cqring_wait(ctx, min_complete, sig, sigsz, ts);
 		}
 	}
 
@@ -9561,7 +9596,8 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
-			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED;
+			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
+			IORING_FEAT_GETEVENTS_TIMEOUT;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 557e7eae497f..fefee28c3ed8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -231,6 +231,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_GETEVENTS	(1U << 0)
 #define IORING_ENTER_SQ_WAKEUP	(1U << 1)
 #define IORING_ENTER_SQ_WAIT	(1U << 2)
+#define IORING_ENTER_GETEVENTS_TIMEOUT	(1U << 3)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -259,6 +260,7 @@ struct io_uring_params {
 #define IORING_FEAT_FAST_POLL		(1U << 5)
 #define IORING_FEAT_POLL_32BITS 	(1U << 6)
 #define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
+#define IORING_FEAT_GETEVENTS_TIMEOUT	(1U << 8)
 
 /*
  * io_uring_register(2) opcodes and arguments
@@ -335,4 +337,9 @@ enum {
 	IORING_RESTRICTION_LAST
 };
 
+struct io_uring_getevents_arg {
+	sigset_t *sigmask;
+	struct __kernel_timespec *ts;
+};
+
 #endif

-- 
Jens Axboe

