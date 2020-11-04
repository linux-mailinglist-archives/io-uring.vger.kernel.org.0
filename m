Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9982A6F2A
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 21:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbgKDUuK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 15:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbgKDUuK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 15:50:10 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3A7C0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 12:50:09 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id z3so2884409pfb.10
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 12:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i1JFm8qOWFHllo5nT1UdXgsGfxGJEMv9j/jTFGGxVYw=;
        b=OQJCeLRjLiBRGa8eiLO6K9ZF8lwxbb3pK0MYmodzaXuuT9fA2gs7DScT8bTwDWZo9O
         WZqQj5mvZlK4dUXFkQp1cgHp+56iHBwRMsFXRs+LDoj05NlvUHqmvZHiBkwPK3HNbQq/
         6X+PNCqwWztIbFtEzUBKX7lBdSSFDofP6B9ts4vSA04AkafVyQH5kaoIL4gXdc1FLwEc
         2L8S9u0Q54dvdoJlVJRm6kCN4ZARMvn6Rb5CQRL+9MEDDDGmx43jn7wJKMh3FBAdSjPO
         pOrMcBYvH/cLGvrfcYGtf460OwG6z95WzN5jwsv/I800Sx6rzCy8Xt59jIcn0UeAO4d4
         nKVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i1JFm8qOWFHllo5nT1UdXgsGfxGJEMv9j/jTFGGxVYw=;
        b=K6ZQzSeRBRpupOu6VjOUPw0UblzTlHS1kxJsI0TXsr5mmyLQKpQhjZ8Da8T8YyM+4Y
         8KUAxSkU3xSJiXElJLw6iAQor1pfBhSjftNzfsGFZKLSeNIepw15LfFNum+J5IOxXk7q
         Mp7o50fWbW4QrMRUW+1H2jwD0pdp33U+FKeS2CTCVskf0090tsp+2SU7moL/Q+1OataM
         RpFajazaJ3+zveQBkntTTqRsoraMAVwh4RGMolDI6LetMcATNF2QutMnJr/mfKIlO4zK
         D+9nFxmubaWYg96dZ5Smt/ByhjA8t+6AEMrJ4lGiz/2tNOQrKaONPNptSUddfzV0/zRp
         sZsQ==
X-Gm-Message-State: AOAM53205z3clLogRTuWvInyBHE5gJ/8OT1Gd3LYT6LY2/oJTqFb4RWP
        cLLmtOyXmlkWzPmyXVbTqU2yQg==
X-Google-Smtp-Source: ABdhPJwXcIK80KUGMMHaQFm2WTCTkDx2k/4g/a5D+ymJcGZNe/ZYLhUMoIEFkVaY6SbzpcSZJU/ACQ==
X-Received: by 2002:a63:e40b:: with SMTP id a11mr9807778pgi.26.1604523008355;
        Wed, 04 Nov 2020 12:50:08 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u7sm106104pjm.43.2020.11.04.12.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 12:50:07 -0800 (PST)
Subject: Re: [PATCH v3 RESEND] io_uring: add timeout support for
 io_uring_enter()
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, metze@samba.org,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1604307047-50980-1-git-send-email-haoxu@linux.alibaba.com>
 <1604372077-179941-1-git-send-email-haoxu@linux.alibaba.com>
 <c2ae5254-d558-a48f-fca2-0759781bf3e1@kernel.dk>
 <052a2b54-017f-8617-5d1a-074408d164fd@kernel.dk>
 <fa632df8-28c8-a63f-e79a-5996344b8226@gmail.com>
 <b6db7a64-aa37-cdfc-dae3-d8d1d8fa6a7f@kernel.dk>
 <13c05478-5363-cfae-69b1-8022b9736088@gmail.com>
 <1d7cbae3-c284-e01d-7f7d-2ae2ab9cbb54@kernel.dk>
Message-ID: <c2715d7b-045b-42f3-2d83-125ef408cf33@kernel.dk>
Date:   Wed, 4 Nov 2020 13:50:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1d7cbae3-c284-e01d-7f7d-2ae2ab9cbb54@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/20 1:28 PM, Jens Axboe wrote:
> On 11/4/20 1:16 PM, Pavel Begunkov wrote:
>> On 04/11/2020 19:34, Jens Axboe wrote:
>>> On 11/4/20 12:27 PM, Pavel Begunkov wrote:
>>>> On 04/11/2020 18:32, Jens Axboe wrote:
>>>>> On 11/4/20 10:50 AM, Jens Axboe wrote:
>>>>>> +struct io_uring_getevents_arg {
>>>>>> +	sigset_t *sigmask;
>>>>>> +	struct __kernel_timespec *ts;
>>>>>> +};
>>>>>> +
>>>>>
>>>>> I missed that this is still not right, I did bring it up in your last
>>>>> posting though - you can't have pointers as a user API, since the size
>>>>> of the pointer will vary depending on whether this is a 32-bit or 64-bit
>>>>> arch (or 32-bit app running on 64-bit kernel).
>>>>
>>>> Maybe it would be better 
>>>>
>>>> 1) to kill this extra indirection?
>>>>
>>>> struct io_uring_getevents_arg {
>>>> -	sigset_t *sigmask;
>>>> -	struct __kernel_timespec *ts;
>>>> +	sigset_t sigmask;
>>>> +	struct __kernel_timespec ts;
>>>> };
>>>>
>>>> then,
>>>>
>>>> sigset_t *sig = (...)arg;
>>>> __kernel_timespec* ts = (...)(arg + offset);
>>>
>>> But then it's kind of hard to know which, if any, of them are set... I
>>> did think about this, and any solution seemed worse than just having the
>>> extra indirection.
>>
>> struct io_uring_getevents_arg {
>> 	sigset_t sigmask;
>> 	u32 mask;
>> 	struct __kernel_timespec ts;
>> };
>>
>> if size > sizeof(sigmask), then use mask to determine that.
>> Though, not sure how horrid the rest of the code would be.
> 
> I'm not saying it's not possible, just that I think the end result would
> be worse in terms of both kernel code and how the user applications (or
> liburing) would need to use it. I'd rather sacrifice an extra copy for
> something that's straight forward (and logical) to use, rather than
> needing weird setups or hoops to jump through. And this mask vs
> sizeof(mask) thing seems pretty horrendeous to me :-)
> 
>>> Yeah, not doing the extra indirection would save a copy, but don't think
>>> it's worth it for this path.
>>
>> I much more don't like branching like IORING_ENTER_GETEVENTS_TIMEOUT,
>> from conceptual point. I may try it out to see how it looks like while
>> it's still for-next.
> 
> One thing I think we should change is the name,
> IORING_ENTER_GETEVENTS_TIMEOUT will quickly be a bad name if we end up
> adding just one more thing to the struct. Would be better to call it
> IORING_ENTER_EXTRA_DATA or something, meaning that the sigmask pointer
> is a pointer to the aux data instead of a sigmask. Better name
> suggestions welcome...

I'd be inclined to do something like the below:

- Rename it to IORING_ENTER_SIG_IS_DATA, which I think is more future
  proof and explains it too. Ditto for the feature flag.

- Move the checking and getting to under GETEVENTS. This removes a weird
  case where you'd get EINVAL if IORING_ENTER_SIG_IS_DATA is set but
  IORING_ENTER_GETEVENTS isn't. We didn't previously fail a
  non-getevents call if eg sigmask was set, so don't think we should add
  this case. Only downside here is that if we fail the validation, we'll
  only submit and return the submit count. Should be fine, as we'd end
  up with another enter and return the error there.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8439cda54e21..694a87807ea1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9146,6 +9146,29 @@ static void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 	finish_wait(&ctx->sqo_sq_wait, &wait);
 }
 
+static int io_get_sig_is_data(unsigned flags, const void __user *argp,
+			      struct __kernel_timespec __user **ts,
+			      const sigset_t __user **sig, size_t *sigsz)
+{
+	struct io_uring_getevents_arg arg;
+
+	/* deal with IORING_ENTER_SIG_IS_DATA */
+	if (flags & IORING_ENTER_SIG_IS_DATA) {
+		if (*sigsz != sizeof(arg))
+			return -EINVAL;
+		if (copy_from_user(&arg, argp, sizeof(arg)))
+			return -EFAULT;
+		*sig = u64_to_user_ptr(arg.sigmask);
+		*sigsz = arg.sigmask_sz;
+		*ts = u64_to_user_ptr(arg.ts);
+	} else {
+		*sig = (const sigset_t __user *) argp;
+		*ts = NULL;
+	}
+
+	return 0;
+}
+
 SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		u32, min_complete, u32, flags, const void __user *, argp,
 		size_t, sigsz)
@@ -9154,32 +9177,13 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	long ret = -EBADF;
 	int submitted = 0;
 	struct fd f;
-	const sigset_t __user *sig;
-	struct __kernel_timespec __user *ts;
-	struct io_uring_getevents_arg arg;
 
 	io_run_task_work();
 
 	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
-			IORING_ENTER_SQ_WAIT | IORING_ENTER_GETEVENTS_TIMEOUT))
+			IORING_ENTER_SQ_WAIT | IORING_ENTER_SIG_IS_DATA))
 		return -EINVAL;
 
-	/* deal with IORING_ENTER_GETEVENTS_TIMEOUT */
-	if (flags & IORING_ENTER_GETEVENTS_TIMEOUT) {
-		if (!(flags & IORING_ENTER_GETEVENTS))
-			return -EINVAL;
-		if (sigsz != sizeof(arg))
-			return -EINVAL;
-		if (copy_from_user(&arg, argp, sizeof(arg)))
-			return -EFAULT;
-		sig = u64_to_user_ptr(arg.sigmask);
-		sigsz = arg.sigmask_sz;
-		ts = u64_to_user_ptr(arg.ts);
-	} else {
-		sig = (const sigset_t __user *)argp;
-		ts = NULL;
-	}
-
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
@@ -9223,6 +9227,13 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			goto out;
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
+		const sigset_t __user *sig;
+		struct __kernel_timespec __user *ts;
+
+		ret = io_get_sig_is_data(flags, argp, &ts, &sig, &sigsz);
+		if (unlikely(ret))
+			goto out;
+
 		min_complete = min(min_complete, ctx->cq_entries);
 
 		/*
@@ -9598,7 +9609,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
-			IORING_FEAT_GETEVENTS_TIMEOUT;
+			IORING_FEAT_SIG_IS_DATA;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 37bea07c12f2..0fa095347fb6 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -317,7 +317,7 @@ asmlinkage long sys_io_uring_setup(u32 entries,
 				struct io_uring_params __user *p);
 asmlinkage long sys_io_uring_enter(unsigned int fd, u32 to_submit,
 				u32 min_complete, u32 flags,
-				const sigset_t __user *sig, size_t sigsz);
+				const void __user *argp, size_t sigsz);
 asmlinkage long sys_io_uring_register(unsigned int fd, unsigned int op,
 				void __user *arg, unsigned int nr_args);
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1a92985a9ee8..4832addccfa6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -231,7 +231,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_GETEVENTS	(1U << 0)
 #define IORING_ENTER_SQ_WAKEUP	(1U << 1)
 #define IORING_ENTER_SQ_WAIT	(1U << 2)
-#define IORING_ENTER_GETEVENTS_TIMEOUT	(1U << 3)
+#define IORING_ENTER_SIG_IS_DATA	(1U << 3)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -260,7 +260,7 @@ struct io_uring_params {
 #define IORING_FEAT_FAST_POLL		(1U << 5)
 #define IORING_FEAT_POLL_32BITS 	(1U << 6)
 #define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
-#define IORING_FEAT_GETEVENTS_TIMEOUT	(1U << 8)
+#define IORING_FEAT_SIG_IS_DATA		(1U << 8)
 
 /*
  * io_uring_register(2) opcodes and arguments

-- 
Jens Axboe

