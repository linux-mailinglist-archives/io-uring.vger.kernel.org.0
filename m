Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F43834B24D
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 23:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhCZWuX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 18:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCZWtz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 18:49:55 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8556FC0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 15:49:55 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id k25so7235613oic.4
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 15:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WF2hlz+Ai/cjDbzWcWmpYPi5es4Hx8NEZ//VoJpE6zY=;
        b=v1sDuCpoqSChDI5/ibiue/oBxil3nTCJIB/+sanO8Pk7QbJ0OIHIiTxRkgUaJRLHTO
         P+mO9AzrDt/7oPGmKDygV755z2q66rAotsy21bsKVFlCwjdkdNB27Myww96DMgnYgwXK
         D1mR0Xl2hwaUHH/jySc8+nS4WjUn7FeLVrR1iLL44oAK1Hr9JOe2SZ0XbthbHbBWtUkV
         hsieo2beoFI4oAhfDWlGrgzSCfolzKpzorJeqyVKz9P8u+cT+Z0N3mCknJwFq7H3JSMe
         LCQABvWoFX1f13g8iG71WKP9IzDFCLmLz1nFUw15DpiMv73MZdaxZoaHG+ue37uBK9Yq
         pjsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WF2hlz+Ai/cjDbzWcWmpYPi5es4Hx8NEZ//VoJpE6zY=;
        b=uVrdv8lvSi29JZ+ls0LjaJOhaG/7Y+iAetvOhfXW7jGh5iP8pE7qEiYUyz53+bXCdk
         1SLHuE66xXtwgslONvh/6qLegCkG5+6ybRmeLblrNmUqrti0FtnEKHbxsWGU/eGWiCFT
         T1Y/hgPK+y5Sl19XqAz/G3l8ppnRCDNjVIIBPKmjJtBIf7X4ifdsQMklrSriHLowrFW3
         INq4WDguLUyAH0OM1QNJMumqZTSGWzsYSH1kmqNcDz4HLqVsjasNy1AUIHRdzbtuvG84
         dt87d9qt2ZR/9mKiGTFj2pfhBLmF9MaAwsg8xorf8i7WO6sDd2OzwohWD5oAMlDceG1y
         5aIg==
X-Gm-Message-State: AOAM531NjdtO/MuivtRMvjpmqKfHiXcMI3TtQp8y5wYDbsMnrvk/Q1Wy
        +F0FzDp3/GQYIr+Txor/yRjs2g==
X-Google-Smtp-Source: ABdhPJye2MDWxsj9FI6ETOl+AehWy4xg0wQLOrH3tnDM2tvun1bBpRfzD1P8t5QeDCBjfwE8aHhN1w==
X-Received: by 2002:a54:409a:: with SMTP id i26mr11386693oii.41.1616798994654;
        Fri, 26 Mar 2021 15:49:54 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id r22sm2389052otg.4.2021.03.26.15.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 15:49:54 -0700 (PDT)
Subject: Re: [PATCH 2/7] io_uring: handle signals for IO threads like a normal
 thread
From:   Jens Axboe <axboe@kernel.dk>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326155128.1057078-1-axboe@kernel.dk>
 <20210326155128.1057078-3-axboe@kernel.dk> <m1wntty7yn.fsf@fess.ebiederm.org>
 <106a38d3-5a5f-17fd-41f7-890f5e9a3602@kernel.dk>
 <m1k0ptv9kj.fsf@fess.ebiederm.org>
 <01058178-dd66-1bff-4d74-5ff610817ed6@kernel.dk>
 <m18s69v8zb.fsf@fess.ebiederm.org>
 <7a71da2f-ca39-6bbf-28c1-bcc2eec43943@kernel.dk>
Message-ID: <387feabb-e758-220a-fc34-9e9325eab3a6@kernel.dk>
Date:   Fri, 26 Mar 2021 16:49:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7a71da2f-ca39-6bbf-28c1-bcc2eec43943@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 4:38 PM, Jens Axboe wrote:
> On 3/26/21 4:35 PM, Eric W. Biederman wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>>
>>> On 3/26/21 4:23 PM, Eric W. Biederman wrote:
>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>
>>>>> On 3/26/21 2:29 PM, Eric W. Biederman wrote:
>>>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>>>
>>>>>>> We go through various hoops to disallow signals for the IO threads, but
>>>>>>> there's really no reason why we cannot just allow them. The IO threads
>>>>>>> never return to userspace like a normal thread, and hence don't go through
>>>>>>> normal signal processing. Instead, just check for a pending signal as part
>>>>>>> of the work loop, and call get_signal() to handle it for us if anything
>>>>>>> is pending.
>>>>>>>
>>>>>>> With that, we can support receiving signals, including special ones like
>>>>>>> SIGSTOP.
>>>>>>>
>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>> ---
>>>>>>>  fs/io-wq.c    | 24 +++++++++++++++++-------
>>>>>>>  fs/io_uring.c | 12 ++++++++----
>>>>>>>  2 files changed, 25 insertions(+), 11 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>>>>>> index b7c1fa932cb3..3e2f059a1737 100644
>>>>>>> --- a/fs/io-wq.c
>>>>>>> +++ b/fs/io-wq.c
>>>>>>> @@ -16,7 +16,6 @@
>>>>>>>  #include <linux/rculist_nulls.h>
>>>>>>>  #include <linux/cpu.h>
>>>>>>>  #include <linux/tracehook.h>
>>>>>>> -#include <linux/freezer.h>
>>>>>>>  
>>>>>>>  #include "../kernel/sched/sched.h"
>>>>>>>  #include "io-wq.h"
>>>>>>> @@ -503,10 +502,16 @@ static int io_wqe_worker(void *data)
>>>>>>>  		if (io_flush_signals())
>>>>>>>  			continue;
>>>>>>>  		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
>>>>>>> -		if (try_to_freeze() || ret)
>>>>>>> +		if (signal_pending(current)) {
>>>>>>> +			struct ksignal ksig;
>>>>>>> +
>>>>>>> +			if (fatal_signal_pending(current))
>>>>>>> +				break;
>>>>>>> +			if (get_signal(&ksig))
>>>>>>> +				continue;
>>>>>>                         ^^^^^^^^^^^^^^^^^^^^^^
>>>>>>
>>>>>> That is wrong.  You are promising to deliver a signal to signal
>>>>>> handler and them simply discarding it.  Perhaps:
>>>>>>
>>>>>> 			if (!get_signal(&ksig))
>>>>>>                         	continue;
>>>>>> 			WARN_ON(!sig_kernel_stop(ksig->sig));
>>>>>>                         break;
>>>>>
>>>>> Thanks, updated.
>>>>
>>>> Gah.  Kill the WARN_ON.
>>>>
>>>> I was thinking "WARN_ON(!sig_kernel_fatal(ksig->sig));"
>>>> The function sig_kernel_fatal does not exist.
>>>>
>>>> Fatal is the state that is left when a signal is neither
>>>> ignored nor a stop signal, and does not have a handler.
>>>>
>>>> The rest of the logic still works.
>>>
>>> I've just come to the same conclusion myself after testing it.
>>> Of the 3 cases, most of them can do the continue, but doesn't
>>> really matter with the way the loop is structured. Anyway, looks
>>> like this now:
>>
>> This idiom in the code:
>>> +		if (signal_pending(current)) {
>>> +			struct ksignal ksig;
>>> +
>>> +			if (fatal_signal_pending(current))
>>> +				break;
>>> +			if (!get_signal(&ksig))
>>> +				continue;
>>>  }
>>
>> Needs to be:
>>> +		if (signal_pending(current)) {
>>> +			struct ksignal ksig;
>>> +
>>> +			if (!get_signal(&ksig))
>>> +				continue;
>>> +			break;
>>>  }
>>
>> Because any signal returned from get_signal is fatal in this case.
>> It might make sense to "WARN_ON(ksig->ka.sa.sa_handler != SIG_DFL)".
>> As the io workers don't handle that case.
>>
>> It won't happen because you have everything blocked.
>>
>> The extra fatal_signal_pending(current) logic is just confusing in this
>> case.
> 
> OK good point, and follows the same logic even if it won't make a
> difference in my case. I'll make the change.

Made the suggested edits and ran the quick tests and the KILL/STOP
testing, and no ill effects observed. Kicked off the longer runs now.

Not a huge amount of changes from the posted series, but please peruse
here if you want to double check:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-5.12

And diff against v2 posted is below. Thanks!

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 3e2f059a1737..7434eb40ca8c 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -505,10 +505,9 @@ static int io_wqe_worker(void *data)
 		if (signal_pending(current)) {
 			struct ksignal ksig;
 
-			if (fatal_signal_pending(current))
-				break;
-			if (get_signal(&ksig))
+			if (!get_signal(&ksig))
 				continue;
+			break;
 		}
 		if (ret)
 			continue;
@@ -722,10 +721,9 @@ static int io_wq_manager(void *data)
 		if (signal_pending(current)) {
 			struct ksignal ksig;
 
-			if (fatal_signal_pending(current))
-				set_bit(IO_WQ_BIT_EXIT, &wq->state);
-			else if (get_signal(&ksig))
+			if (!get_signal(&ksig))
 				continue;
+			set_bit(IO_WQ_BIT_EXIT, &wq->state);
 		}
 	} while (!test_bit(IO_WQ_BIT_EXIT, &wq->state));
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 66ae46874d85..880abd8b6d31 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6746,10 +6746,9 @@ static int io_sq_thread(void *data)
 		if (signal_pending(current)) {
 			struct ksignal ksig;
 
-			if (fatal_signal_pending(current))
-				break;
-			if (get_signal(&ksig))
+			if (!get_signal(&ksig))
 				continue;
+			break;
 		}
 		sqt_spin = false;
 		cap_entries = !list_is_singular(&sqd->ctx_list);
diff --git a/kernel/signal.c b/kernel/signal.c
index 5b75fbe3d2d6..f2718350bf4b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2752,15 +2752,6 @@ bool get_signal(struct ksignal *ksig)
 		 */
 		current->flags |= PF_SIGNALED;
 
-		/*
-		 * PF_IO_WORKER threads will catch and exit on fatal signals
-		 * themselves. They have cleanup that must be performed, so
-		 * we cannot call do_exit() on their behalf. coredumps also
-		 * do not apply to them.
-		 */
-		if (current->flags & PF_IO_WORKER)
-			return false;
-
 		if (sig_kernel_coredump(signr)) {
 			if (print_fatal_signals)
 				print_fatal_signal(ksig->info.si_signo);
@@ -2776,6 +2767,14 @@ bool get_signal(struct ksignal *ksig)
 			do_coredump(&ksig->info);
 		}
 
+		/*
+		 * PF_IO_WORKER threads will catch and exit on fatal signals
+		 * themselves. They have cleanup that must be performed, so
+		 * we cannot call do_exit() on their behalf.
+		 */
+		if (current->flags & PF_IO_WORKER)
+			goto out;
+
 		/*
 		 * Death signals, no core dump.
 		 */
@@ -2783,7 +2782,7 @@ bool get_signal(struct ksignal *ksig)
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
-
+out:
 	ksig->sig = signr;
 
 	if (!(ksig->ka.sa.sa_flags & SA_EXPOSE_TAGBITS))

-- 
Jens Axboe

