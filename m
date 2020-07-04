Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6154421429F
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 03:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgGDBw7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 21:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgGDBw6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 21:52:58 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA255C061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 18:52:58 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mn17so1176049pjb.4
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 18:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=H60icxws3T1bu2tH7XgwkzK2y5o88k4mAaylwy8WZ3M=;
        b=mkqNRVzViZRYFW2Hf3QWzfKAE9mHobqutjCsTUxpbpxMMFkHHZC3qHD/ibvUrciXPf
         JSfvCKKhDrts46YCaE/mjAzBfGAqCyauSny0Xms5nWMIiYXtXZaa4sKt1cwSVbZWOmny
         /TbOMucuJ8TTNkBri44S6XL/XROvwGjNiz3nxa4bMu7lIJhfAaovoIuLAC/ns+3Ejo1A
         zF0qh+svBgWCF1p4r6P8JjFwSql43pF7krlDLSTLmCCqbdAbjPyO5loijvE78jpACo5n
         0dZOVjgaP480M1Sk0xh5+URPzj35Ns4AIXkHQPgS2HWtAD29Ew2uLxsQ/88jiaZ9yKwC
         0omw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H60icxws3T1bu2tH7XgwkzK2y5o88k4mAaylwy8WZ3M=;
        b=FCgROzM3mUL6FRvUiC/45taH/ouGwyRnxdO1FZwWl10xiQuYGYzp4CxL9YvdMrLAz9
         I2zzaADqFLbRQ10NFNRymKzjEZMc3mkFM/q3Hkyfi+Yb0RzmmzPCm+h77/aRtlbEb0uo
         1Qt2B2pnbQiECHacKmGjTdCQvam8BHwH4o5ISSaApMzP/mwxuq/LH9JQRRODMGj9bw2s
         GRMqbOnaTYjcbvuaUn4y/AGoONlTHe48oEaTqLrPl+gNFPDU3jsyg9+eq74ic9IjJQKM
         H6VC1F48uax4tCwoePtk8XuIAHtBOrWlWdLItYl2nIgdu5dC0v6ESEhS3q2LN1EaLCGY
         LeGA==
X-Gm-Message-State: AOAM531gQEwCpZYl8Afcyozl+sCZdzNfH8N94MqyHSnswHhN6QisbS6X
        5aw4sRGY4/m6cu+C1Tv8EwzGriuS8Exrjg==
X-Google-Smtp-Source: ABdhPJzVUIVazv98K9IpeRWELgOydP2W90O4csUArpdMLwRWG4V0boTOEuztJ7O9NPOmVHDXp6IDgA==
X-Received: by 2002:a17:902:c401:: with SMTP id k1mr11800846plk.202.1593827577818;
        Fri, 03 Jul 2020 18:52:57 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u20sm12797865pfk.91.2020.07.03.18.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 18:52:57 -0700 (PDT)
Subject: Re: signals not reliably interrupting io_uring_enter anymore
To:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org
References: <20200704000049.3elr2mralckeqmej@alap3.anarazel.de>
 <20200704001541.6isrwsr6ptvbykdq@alap3.anarazel.de>
 <70fb9308-2126-052b-730a-bc5adad552f9@kernel.dk>
 <7C9DC2D8-6FF5-477D-B539-3A9F5DE1B13B@anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f2620bef-4b4c-1a5d-a1e8-f97f445f78ef@kernel.dk>
Date:   Fri, 3 Jul 2020 19:52:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <7C9DC2D8-6FF5-477D-B539-3A9F5DE1B13B@anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/3/20 7:13 PM, Andres Freund wrote:
> Hi, 
> 
> On July 3, 2020 5:48:21 PM PDT, Jens Axboe <axboe@kernel.dk> wrote:
>> On 7/3/20 6:15 PM, Andres Freund wrote:
>>> Hi,
>>>
>>> On 2020-07-03 17:00:49 -0700, Andres Freund wrote:
>>>> I haven't yet fully analyzed the problem, but after updating to
>>>> cdd3bb54332f82295ed90cd0c09c78cd0c0ee822 io_uring using postgres
>> does
>>>> not work reliably anymore.
>>>>
>>>> The symptom is that io_uring_enter(IORING_ENTER_GETEVENTS) isn't
>>>> interrupted by signals anymore. The signal handler executes, but
>>>> afterwards the syscall is restarted. Previously io_uring_enter
>> reliably
>>>> returned EINTR in that case.
>>>>
>>>> Currently postgres relies on signals interrupting io_uring_enter().
>> We
>>>> probably can find a way to not do so, but it'd not be entirely
>> trivial.
>>>>
>>>> I suspect the issue is
>>>>
>>>> commit ce593a6c480a22acba08795be313c0c6d49dd35d (tag:
>> io_uring-5.8-2020-07-01, linux-block/io_uring-5.8)
>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>> Date:   2020-06-30 12:39:05 -0600
>>>>
>>>>     io_uring: use signal based task_work running
>>>>
>>>> as that appears to have changed the error returned by
>>>> io_uring_enter(GETEVENTS) after having been interrupted by a signal
>> from
>>>> EINTR to ERESTARTSYS.
>>>>
>>>>
>>>> I'll check to make sure that the issue doesn't exist before the
>> above
>>>> commit.
>>>
>>> Indeed, on cd77006e01b3198c75fb7819b3d0ff89709539bb the PG issue
>> doesn't
>>> exist, which pretty much confirms that the above commit is the issue.
>>>
>>> What was the reason for changing EINTR to ERESTARTSYS in the above
>>> commit? I assume trying to avoid returning spurious EINTRs to
>> userland?
>>
>> Yeah, for when it's running task_work. I wonder if something like the
>> below will do the trick?
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 700644a016a7..0efa73d78451 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -6197,11 +6197,11 @@ static int io_cqring_wait(struct io_ring_ctx
>> *ctx, int min_events,
>> 	do {
>> 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
>> 						TASK_INTERRUPTIBLE);
>> -		/* make sure we run task_work before checking for signals */
>> -		if (current->task_works)
>> -			task_work_run();
>> 		if (signal_pending(current)) {
>> -			ret = -ERESTARTSYS;
>> +			if (current->task_works)
>> +				ret = -ERESTARTSYS;
>> +			else
>> +				ret = -EINTR;
>> 			break;
>> 		}
>> 		if (io_should_wake(&iowq, false))
>> @@ -6210,7 +6210,7 @@ static int io_cqring_wait(struct io_ring_ctx
>> *ctx, int min_events,
>> 	} while (1);
>> 	finish_wait(&ctx->wait, &iowq.wq);
>>
>> -	restore_saved_sigmask_unless(ret == -ERESTARTSYS);
>> +	restore_saved_sigmask_unless(ret == -EINTR);
>>
>> 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret :
>> 0;
>> }
> 
> I'll try in a bit. Suspect however that there'd be trouble if there
> were both an actual signal and task work pending?

Yes, I have that worry too. We'd really need to check if we have an
actual signal pending - if we do, we still do -EINTR. If not, then we
just do -ERESTARTSYS and restart the system call after task_work has
been completed. Half-assed approach below, I suspect this won't _really_
work without appropriate locking. Which would be unfortunate.

Either that, or we'd need to know if an actual signal was delivered when
we get re-entered due to returning -ERESTARTSYS. If it was just
task_work being run, then we're fine. But if an actual signal was
pending, then we'd need to return -EINTR.

CC'ing Oleg to see if he has any good ideas here.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 700644a016a7..715d56144f15 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6197,11 +6197,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		/* make sure we run task_work before checking for signals */
-		if (current->task_works)
-			task_work_run();
 		if (signal_pending(current)) {
-			ret = -ERESTARTSYS;
+			if (has_pending_signal(current))
+				ret = -EINTR;
+			else
+				ret = -ERESTARTSYS;
 			break;
 		}
 		if (io_should_wake(&iowq, false))
@@ -6210,7 +6210,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
 
-	restore_saved_sigmask_unless(ret == -ERESTARTSYS);
+	restore_saved_sigmask_unless(ret == -EINTR);
 
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 6bb1a3f0258c..8ef23b0bb406 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -321,6 +321,7 @@ static inline void disallow_signal(int sig)
 extern struct kmem_cache *sighand_cachep;
 
 extern bool unhandled_signal(struct task_struct *tsk, int sig);
+extern bool has_pending_signal(struct task_struct *tsk);
 
 /*
  * In POSIX a signal is sent either to a specific thread (Linux task)
diff --git a/kernel/signal.c b/kernel/signal.c
index ee22ec78fd6d..8923872e5228 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -151,12 +151,16 @@ static inline bool has_pending_signals(sigset_t *signal, sigset_t *blocked)
 
 #define PENDING(p,b) has_pending_signals(&(p)->signal, (b))
 
+inline bool has_pending_signal(struct task_struct *t)
+{
+	return PENDING(&t->pending, &t->blocked) ||
+		PENDING(&t->signal->shared_pending, &t->blocked);
+}
+
 static bool recalc_sigpending_tsk(struct task_struct *t)
 {
 	if ((t->jobctl & (JOBCTL_PENDING_MASK | JOBCTL_TRAP_FREEZE)) ||
-	    PENDING(&t->pending, &t->blocked) ||
-	    PENDING(&t->signal->shared_pending, &t->blocked) ||
-	    cgroup_task_frozen(t)) {
+	    has_pending_signal(t) || cgroup_task_frozen(t)) {
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
 		return true;
 	}

-- 
Jens Axboe

