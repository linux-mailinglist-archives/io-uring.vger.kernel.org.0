Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132F92142B2
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 04:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgGDC4T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 22:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgGDC4S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 22:56:18 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED59C061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 19:56:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 207so14456581pfu.3
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 19:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ArTHlNW5zERTy8q0Iqn9mIdCZF29/4kmJP3uLl5bCDI=;
        b=BFG7V2VPzKX1yHqMQXo8ocHTNkYg8I/IlJf4z3wzSd2JZGAM49eY2MF8BDbqNLMI3l
         /YFoxywDMmvpwn9RzvSlFLEfrv5+52sZ3n4jts0Kk25CrtKc1VhlhiTzsSV7TAlIUX/h
         9tznvOqK23Il2seEOq9KgFjDhShWW5wqTT1fo/ZY8XFVaxPvR+MH3XQijX00jYzUK9aJ
         wsGEK/e2EC17f4jW+ktr0JoE/O4lT+5rXcw7GpAJLmLd3MH09wXOxiFeYd9tyG8k2JUl
         GoGBdIsXz0y3wVORlSRfyeI4Dc+6uAZqBoGcRJ9VzH/WBFhUbwAtwBVANqSDuvV26IJB
         SLFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ArTHlNW5zERTy8q0Iqn9mIdCZF29/4kmJP3uLl5bCDI=;
        b=cRv3u8CHZ5XFQJ+HXAhbNrOzWht1pdsHC4/yJsDxSqOKwm9P1HvhWf5h734Ija7RZP
         BafHbgtq4SXymD3/6O/cFihJlnPOA8ZXkhKdz+Q2kEDK23ol84ZBcHyQksw65j8dE/vX
         zvMBezSfyjmnEcMUo4m2PBIXnX0b4/P+CBZkq+wdRQvW+mUTFs6tvIogcgQDkOXZYWe6
         JgjrWhBEjXTTD5VQU0V6Y2y6hxb9JY4QNy1xZSIe5BZicc/84wvx5zw4qT+hXAMfOXgX
         N3AzY40dB03eZJupRo6aYA2u3KR32NyZ8jpUIu+1sG0dfh6nHOAmsMO4TNoL/9KekK9T
         Rl/A==
X-Gm-Message-State: AOAM532iyaDuh9nkJEAvBezMmKKlW5AqYUpx24LC2TS+R6+Iyrw8r6nx
        fSmC7vbgVDRFgSjzKIA4sznp53fp+3xHZw==
X-Google-Smtp-Source: ABdhPJycSn+VqPmiE9yoQx6WniMPr62oejE4C5LWzvWPaLkSM2B4vsy2jTK8+AXRol/I+oNwwLT9MA==
X-Received: by 2002:a62:3301:: with SMTP id z1mr35635630pfz.324.1593831377445;
        Fri, 03 Jul 2020 19:56:17 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g13sm12676453pje.29.2020.07.03.19.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 19:56:16 -0700 (PDT)
Subject: Re: signals not reliably interrupting io_uring_enter anymore
From:   Jens Axboe <axboe@kernel.dk>
To:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org
References: <20200704000049.3elr2mralckeqmej@alap3.anarazel.de>
 <20200704001541.6isrwsr6ptvbykdq@alap3.anarazel.de>
 <70fb9308-2126-052b-730a-bc5adad552f9@kernel.dk>
 <7C9DC2D8-6FF5-477D-B539-3A9F5DE1B13B@anarazel.de>
 <f2620bef-4b4c-1a5d-a1e8-f97f445f78ef@kernel.dk>
 <c83cfb86-7b8e-550b-5c04-395c34415171@kernel.dk>
Cc:     Oleg Nesterov <oleg@redhat.com>
Message-ID: <624c0af9-886e-0c5f-0c35-dd245496b365@kernel.dk>
Date:   Fri, 3 Jul 2020 20:56:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <c83cfb86-7b8e-550b-5c04-395c34415171@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/3/20 8:08 PM, Jens Axboe wrote:
> On 7/3/20 7:52 PM, Jens Axboe wrote:
>> On 7/3/20 7:13 PM, Andres Freund wrote:
>>> Hi, 
>>>
>>> On July 3, 2020 5:48:21 PM PDT, Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 7/3/20 6:15 PM, Andres Freund wrote:
>>>>> Hi,
>>>>>
>>>>> On 2020-07-03 17:00:49 -0700, Andres Freund wrote:
>>>>>> I haven't yet fully analyzed the problem, but after updating to
>>>>>> cdd3bb54332f82295ed90cd0c09c78cd0c0ee822 io_uring using postgres
>>>> does
>>>>>> not work reliably anymore.
>>>>>>
>>>>>> The symptom is that io_uring_enter(IORING_ENTER_GETEVENTS) isn't
>>>>>> interrupted by signals anymore. The signal handler executes, but
>>>>>> afterwards the syscall is restarted. Previously io_uring_enter
>>>> reliably
>>>>>> returned EINTR in that case.
>>>>>>
>>>>>> Currently postgres relies on signals interrupting io_uring_enter().
>>>> We
>>>>>> probably can find a way to not do so, but it'd not be entirely
>>>> trivial.
>>>>>>
>>>>>> I suspect the issue is
>>>>>>
>>>>>> commit ce593a6c480a22acba08795be313c0c6d49dd35d (tag:
>>>> io_uring-5.8-2020-07-01, linux-block/io_uring-5.8)
>>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>>> Date:   2020-06-30 12:39:05 -0600
>>>>>>
>>>>>>     io_uring: use signal based task_work running
>>>>>>
>>>>>> as that appears to have changed the error returned by
>>>>>> io_uring_enter(GETEVENTS) after having been interrupted by a signal
>>>> from
>>>>>> EINTR to ERESTARTSYS.
>>>>>>
>>>>>>
>>>>>> I'll check to make sure that the issue doesn't exist before the
>>>> above
>>>>>> commit.
>>>>>
>>>>> Indeed, on cd77006e01b3198c75fb7819b3d0ff89709539bb the PG issue
>>>> doesn't
>>>>> exist, which pretty much confirms that the above commit is the issue.
>>>>>
>>>>> What was the reason for changing EINTR to ERESTARTSYS in the above
>>>>> commit? I assume trying to avoid returning spurious EINTRs to
>>>> userland?
>>>>
>>>> Yeah, for when it's running task_work. I wonder if something like the
>>>> below will do the trick?
>>>>
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 700644a016a7..0efa73d78451 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -6197,11 +6197,11 @@ static int io_cqring_wait(struct io_ring_ctx
>>>> *ctx, int min_events,
>>>> 	do {
>>>> 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
>>>> 						TASK_INTERRUPTIBLE);
>>>> -		/* make sure we run task_work before checking for signals */
>>>> -		if (current->task_works)
>>>> -			task_work_run();
>>>> 		if (signal_pending(current)) {
>>>> -			ret = -ERESTARTSYS;
>>>> +			if (current->task_works)
>>>> +				ret = -ERESTARTSYS;
>>>> +			else
>>>> +				ret = -EINTR;
>>>> 			break;
>>>> 		}
>>>> 		if (io_should_wake(&iowq, false))
>>>> @@ -6210,7 +6210,7 @@ static int io_cqring_wait(struct io_ring_ctx
>>>> *ctx, int min_events,
>>>> 	} while (1);
>>>> 	finish_wait(&ctx->wait, &iowq.wq);
>>>>
>>>> -	restore_saved_sigmask_unless(ret == -ERESTARTSYS);
>>>> +	restore_saved_sigmask_unless(ret == -EINTR);
>>>>
>>>> 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret :
>>>> 0;
>>>> }
>>>
>>> I'll try in a bit. Suspect however that there'd be trouble if there
>>> were both an actual signal and task work pending?
>>
>> Yes, I have that worry too. We'd really need to check if we have an
>> actual signal pending - if we do, we still do -EINTR. If not, then we
>> just do -ERESTARTSYS and restart the system call after task_work has
>> been completed. Half-assed approach below, I suspect this won't _really_
>> work without appropriate locking. Which would be unfortunate.
>>
>> Either that, or we'd need to know if an actual signal was delivered when
>> we get re-entered due to returning -ERESTARTSYS. If it was just
>> task_work being run, then we're fine. But if an actual signal was
>> pending, then we'd need to return -EINTR.
>>
>> CC'ing Oleg to see if he has any good ideas here.
> 
> This might be simpler:

Or... That's it for today, I'll check in after the weekend.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 700644a016a7..25a1877d3d84 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6197,11 +6197,18 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		/* make sure we run task_work before checking for signals */
-		if (current->task_works)
-			task_work_run();
 		if (signal_pending(current)) {
-			ret = -ERESTARTSYS;
+			if (current->jobctl & JOBCTL_TASK_WORK) {
+				spin_lock_irq(&current->sighand->siglock);
+				current->jobctl &= ~JOBCTL_TASK_WORK;
+				recalc_sigpending();
+				spin_unlock_irq(&current->sighand->siglock);
+				if (current->task_works) {
+					task_work_run();
+					continue;
+				}
+			}
+			ret = -EINTR;
 			break;
 		}
 		if (io_should_wake(&iowq, false))
@@ -6210,7 +6217,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
 
-	restore_saved_sigmask_unless(ret == -ERESTARTSYS);
+	restore_saved_sigmask_unless(ret == -EINTR);
 
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }

-- 
Jens Axboe

