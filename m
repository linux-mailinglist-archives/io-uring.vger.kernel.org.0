Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7222A6D86
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 20:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgKDTGw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 14:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgKDTGv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 14:06:51 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50C4C0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 11:06:49 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id r9so23306483ioo.7
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 11:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rdtT3CbZvObadPJfROOGX5xxWIqs7+0YI+78/y9bfqs=;
        b=IjJ4cSAtplWJ2pD3PyqmGbhPm/gytFx4NExC09JgSPbUPC8UEqy7WCMLY1iVD40ePC
         QXdJbYZXVmMrnuBAhnwH4zXEGejNSzWeSMkGgIXh2OX7N4u1SG5nvfAzy/kkKFBWifx/
         K/wGuLOhy8O1i5uIpLd/K/a2lR9EUfWP8xtU+z4Lqs+eUJ3cSKoCJYXRJTutPJQ86pjQ
         E1VXwnejUat7Cll3hywQuPEvlczDGH0gm/hDAdxGZYULw/pMcS9NYVsS7E1uJu1hEsCY
         H4D3aHe6GNeN8nDiAPJukz1eEiGzua1lb0Al9nqMUIT7u8V8EIjOqr0HD2+a7XqlNsGI
         zBnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rdtT3CbZvObadPJfROOGX5xxWIqs7+0YI+78/y9bfqs=;
        b=XSrcQVbTu9UiC6faEoxLqoff55BUis+/xgJy3/NBGHPf6suRYvtEqaqI2NnKoKrZHs
         u1SwYreAKSsmcJOO8mW8n/GdrV1xBfDWd2ozAnO9jSBh9fH0jnT30JdKB0CsrW+xkqz8
         UaaXzMLQ3ZubMEdGefgTJSQ5Erxt5JpJbIihKmZ7VHvCUCte7zVDyJfRdZkszXLxu6sn
         7LIkTQfuV7RC6Tl9hI8TiATBOfWg3FieQpaMZFaHfJ+hHLkLzal8T9q13wYf6hj1zDUt
         JeyjqzjUlTZT8aSQHHG+kzGvPS0ag90esEEqy8FaQBlKIp9YfVWfH+AsTTGN1y+o0bbN
         ENsg==
X-Gm-Message-State: AOAM533I63DAxUKU5yPi5LTV1nwy/qA8xQHX8NZfkj2VH+XtRTNux0JM
        v8w6VjyHtb9n5mzJ2NxYdxi/IBWuJDxvug==
X-Google-Smtp-Source: ABdhPJzfP8301iXdgylNGlcBkG74gbmoJiwqSvGPNYDHcgGDTcE+zP6PmU+ltLndRe8bAKP1WC5nrQ==
X-Received: by 2002:a5d:8487:: with SMTP id t7mr18891648iom.35.1604516808989;
        Wed, 04 Nov 2020 11:06:48 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m2sm1608433ion.44.2020.11.04.11.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 11:06:48 -0800 (PST)
Subject: Re: [PATCH v3 RESEND] io_uring: add timeout support for
 io_uring_enter()
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, metze@samba.org,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1604307047-50980-1-git-send-email-haoxu@linux.alibaba.com>
 <1604372077-179941-1-git-send-email-haoxu@linux.alibaba.com>
 <c2ae5254-d558-a48f-fca2-0759781bf3e1@kernel.dk>
 <052a2b54-017f-8617-5d1a-074408d164fd@kernel.dk>
Message-ID: <0a8ff168-2dcb-73d4-0196-a64e589d9228@kernel.dk>
Date:   Wed, 4 Nov 2020 12:06:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <052a2b54-017f-8617-5d1a-074408d164fd@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/20 11:32 AM, Jens Axboe wrote:
> On 11/4/20 10:50 AM, Jens Axboe wrote:
>> +struct io_uring_getevents_arg {
>> +	sigset_t *sigmask;
>> +	struct __kernel_timespec *ts;
>> +};
>> +
> 
> I missed that this is still not right, I did bring it up in your last
> posting though - you can't have pointers as a user API, since the size
> of the pointer will vary depending on whether this is a 32-bit or 64-bit
> arch (or 32-bit app running on 64-bit kernel).

You also made the sigmask size go away if we're using getevent_arg, we
need to include that. It'll break right now if you give both the sigmask
and a timeout, as you're passing in the total arg size for 'ts'.

Here's my (hopefully) final fixed version:


commit 1fda0f709ac2a51c7baa9899501dbf08883fa92c
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
index 864751d64097..8439cda54e21 100644
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
 
@@ -9130,20 +9147,39 @@ static void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
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
+		sig = u64_to_user_ptr(arg.sigmask);
+		sigsz = arg.sigmask_sz;
+		ts = u64_to_user_ptr(arg.ts);
+	} else {
+		sig = (const sigset_t __user *)argp;
+		ts = NULL;
+	}
+
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
@@ -9199,7 +9235,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
 			ret = io_iopoll_check(ctx, min_complete);
 		} else {
-			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
+			ret = io_cqring_wait(ctx, min_complete, sig, sigsz, ts);
 		}
 	}
 
@@ -9561,7 +9597,8 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
-			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED;
+			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
+			IORING_FEAT_GETEVENTS_TIMEOUT;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 557e7eae497f..1a92985a9ee8 100644
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
@@ -335,4 +337,11 @@ enum {
 	IORING_RESTRICTION_LAST
 };
 
+struct io_uring_getevents_arg {
+	__u64	sigmask;
+	__u32	sigmask_sz;
+	__u32	pad;
+	__u64	ts;
+};
+
 #endif

-- 
Jens Axboe

