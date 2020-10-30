Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA482A05F9
	for <lists+io-uring@lfdr.de>; Fri, 30 Oct 2020 13:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgJ3Mxv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Oct 2020 08:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbgJ3Mxu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Oct 2020 08:53:50 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6059BC0613D2
        for <io-uring@vger.kernel.org>; Fri, 30 Oct 2020 05:53:50 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k10so5008242wrw.13
        for <io-uring@vger.kernel.org>; Fri, 30 Oct 2020 05:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JdkJ47AfhzAV7AvHBHMWDnkl1FPTVCCbh/W1njCGpXw=;
        b=G6lIoL6byBZUKfkR0v03k8leiS9yCeAUp4ZhzF+n87tUC9ysrWJl7vDnecP86x8ykC
         XdIRvTYiudrdwKEyPlYY3uNUcdI9qv2W33klV0CQ/8dM8+fdvFelHJivtn+cOajKatzs
         T0KqDufcuv5poCD/MYrJqxebQPH15VynEwYflBebFm4qFuA0F/CPZN2jasexcjCq6/ht
         F5PeQ7myVKRBgDtD2BDU96yKHvlM+ctTfc21SltecdFTE/JX0bhy7vDv0cwYAHZ/GbGN
         c0FmmwnDml4Vsxq5vbKfbinVDcSVQVvLH0RWekxAPTUMHmeQ5W+r3MZMUPuNBd6FIC1L
         tokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=JdkJ47AfhzAV7AvHBHMWDnkl1FPTVCCbh/W1njCGpXw=;
        b=ipCugB9FeJPmZ5VyvbWYaJ4dlj/McoFkY6jdDv/rKlClVCCX78rwWb8J3tJnSYROTj
         WymCCJkYksEJLX8ERFRz1dDowiMGJ6rWWDha6lZVgfFo/N5UHYgQ5byIqaNhzZNSqDv4
         8GP/FoOM3bVw2xrZ07QEZDt2NXPL4PLMLx3O7qmMgNtgOMxJJ331PdtspxEaaB53g7Jn
         GI8beePeFEpoSNlVyS6zFqrk2FpAXMaV8GTfY931CpHrje14zwvkJnCPmCeRwLrqHHPw
         ersdxSpqFy8pGyDpFK+fEhBvnufD+fdXEA/yPRzxEDpKSG5yq0oVjJZrN+z+LhCv6Z+E
         gu4g==
X-Gm-Message-State: AOAM533qBksKiCQyvAHTrGYvuSA+w3pQ0JjNA/4ctFgsxr2hs3ixVemT
        4zENQ5r3iufVhAhz5jZaaVw=
X-Google-Smtp-Source: ABdhPJx2+UKyca+ZSZ+1h/mF462wAA5itWEQ8p3K79a55haf9wdIzaW18+L+U5BHDX2TqIXyKmN7jw==
X-Received: by 2002:adf:94e3:: with SMTP id 90mr2791527wrr.380.1604062429117;
        Fri, 30 Oct 2020 05:53:49 -0700 (PDT)
Received: from [192.168.1.203] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id l3sm5657525wmg.32.2020.10.30.05.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 05:53:48 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: add timeout support for io_uring_enter()
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, metze@samba.org
References: <1596533282-16791-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1311456d-6d12-03e4-3b3b-ff9ab48495d2@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <65e1658a-af29-2042-3235-d29fdf5857fe@gmail.com>
Date:   Fri, 30 Oct 2020 12:50:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1311456d-6d12-03e4-3b3b-ff9ab48495d2@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/08/2020 02:49, Jiufei Xue wrote:
> ping...
> 
> On 2020/8/4 下午5:28, Jiufei Xue wrote:
>> Now users who want to get woken when waiting for events should submit a
>> timeout command first. It is not safe for applications that split SQ and
>> CQ handling between two threads, such as mysql. Users should synchronize
>> the two threads explicitly to protect SQ and that will impact the
>> performance.
>>
>> This patch adds support for timeout to existing io_uring_enter(). To
>> avoid overloading arguments, it introduces a new parameter structure
>> which contains sigmask and timeout.
>>
>> I have tested the workloads with one thread submiting nop requests
>> while the other reaping the cqe with timeout. It shows 1.8~2x faster
>> when the iodepth is 16.

What happened with this? I thought there were enough people wanting
such a thing.

>>
>> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
>> ---
>>  fs/io_uring.c                 | 45 +++++++++++++++++++++++++++++++++++++------
>>  include/uapi/linux/io_uring.h |  7 +++++++
>>  2 files changed, 46 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 2a3af95..cdd89e4 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -6514,7 +6514,8 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>>   * application must reap them itself, as they reside on the shared cq ring.
>>   */
>>  static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>> -			  const sigset_t __user *sig, size_t sigsz)
>> +			  const sigset_t __user *sig, size_t sigsz,
>> +			  struct __kernel_timespec __user *uts)
>>  {
>>  	struct io_wait_queue iowq = {
>>  		.wq = {
>> @@ -6526,6 +6527,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>>  		.to_wait	= min_events,
>>  	};
>>  	struct io_rings *rings = ctx->rings;
>> +	struct timespec64 ts;
>> +	signed long timeout = 0;
>>  	int ret = 0;
>>  
>>  	do {
>> @@ -6548,6 +6551,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>>  			return ret;
>>  	}
>>  
>> +	if (uts) {
>> +		if (get_timespec64(&ts, uts))
>> +			return -EFAULT;
>> +		timeout = timespec64_to_jiffies(&ts);
>> +	}
>> +
>>  	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
>>  	trace_io_uring_cqring_wait(ctx, min_events);
>>  	do {
>> @@ -6569,7 +6578,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>>  		}
>>  		if (io_should_wake(&iowq, false))
>>  			break;
>> -		schedule();
>> +		if (uts) {
>> +			if ((timeout = schedule_timeout(timeout)) == 0) {
>> +				ret = -ETIME;
>> +				break;
>> +			}
>> +		} else {
>> +			schedule();
>> +		}
>>  	} while (1);
>>  	finish_wait(&ctx->wait, &iowq.wq);
>>  
>> @@ -7993,19 +8009,36 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
>>  #endif /* !CONFIG_MMU */
>>  
>>  SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>> -		u32, min_complete, u32, flags, const sigset_t __user *, sig,
>> +		u32, min_complete, u32, flags, const void __user *, argp,
>>  		size_t, sigsz)
>>  {
>>  	struct io_ring_ctx *ctx;
>>  	long ret = -EBADF;
>>  	int submitted = 0;
>>  	struct fd f;
>> +	const sigset_t __user *sig;
>> +	struct __kernel_timespec __user *ts;
>> +	struct io_uring_getevents_arg arg;
>>  
>>  	io_run_task_work();
>>  
>> -	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP))
>> +	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
>> +		      IORING_ENTER_GETEVENTS_TIMEOUT))
>>  		return -EINVAL;
>>  
>> +	/* deal with IORING_ENTER_GETEVENTS_TIMEOUT */
>> +	if (flags & IORING_ENTER_GETEVENTS_TIMEOUT) {
>> +		if (!(flags & IORING_ENTER_GETEVENTS))
>> +			return -EINVAL;
>> +		if (copy_from_user(&arg, argp, sizeof(arg)))
>> +			return -EFAULT;
>> +		sig = arg.sigmask;
>> +		ts = arg.ts;
>> +	} else {
>> +		sig = (const sigset_t __user *)argp;
>> +		ts = NULL;
>> +	}
>> +
>>  	f = fdget(fd);
>>  	if (!f.file)
>>  		return -EBADF;
>> @@ -8052,7 +8085,7 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
>>  		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
>>  			ret = io_iopoll_check(ctx, min_complete);
>>  		} else {
>> -			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
>> +			ret = io_cqring_wait(ctx, min_complete, sig, sigsz, ts);
>>  		}
>>  	}
>>  
>> @@ -8346,7 +8379,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>>  	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
>>  			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
>>  			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
>> -			IORING_FEAT_POLL_32BITS;
>> +			IORING_FEAT_POLL_32BITS | IORING_FEAT_GETEVENTS_TIMEOUT;
>>  
>>  	if (copy_to_user(params, p, sizeof(*p))) {
>>  		ret = -EFAULT;
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index d65fde7..70764d2 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -224,6 +224,7 @@ struct io_cqring_offsets {
>>   */
>>  #define IORING_ENTER_GETEVENTS	(1U << 0)
>>  #define IORING_ENTER_SQ_WAKEUP	(1U << 1)
>> +#define IORING_ENTER_GETEVENTS_TIMEOUT	(1U << 2)
>>  
>>  /*
>>   * Passed in for io_uring_setup(2). Copied back with updated info on success
>> @@ -251,6 +252,7 @@ struct io_uring_params {
>>  #define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
>>  #define IORING_FEAT_FAST_POLL		(1U << 5)
>>  #define IORING_FEAT_POLL_32BITS 	(1U << 6)
>> +#define IORING_FEAT_GETEVENTS_TIMEOUT	(1U << 7)
>>  
>>  /*
>>   * io_uring_register(2) opcodes and arguments
>> @@ -290,4 +292,9 @@ struct io_uring_probe {
>>  	struct io_uring_probe_op ops[0];
>>  };
>>  
>> +struct io_uring_getevents_arg {
>> +	sigset_t *sigmask;
>> +	struct __kernel_timespec *ts;
>> +};
>> +
>>  #endif
>>

-- 
Pavel Begunkov
