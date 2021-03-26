Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC7534B22B
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 23:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhCZWat (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 18:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhCZWaa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 18:30:30 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BFAC0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 15:30:30 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id m21-20020a9d7ad50000b02901b83efc84a0so6627703otn.10
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 15:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mNf1Gc57uaZep/ht1DCQvf+zklgVxefomfLeuA1WYCs=;
        b=iR4UKUX/i73h1mKJ1bYvaJ7WtfusCDdLVE5VqeE9jD4AgRhEjRZ0vWYdq0IIQLG9OH
         DB8AVYFrZMyMi49EhP3UO6QydGvpCVWszv0hjn6fsDGyTvLgKFgUwTYU8Ol7u89XOEO2
         LuQQAJcgHvUA8S4wh+3ZK62ftGcwduM2K6GgAOx2ByTaRBwfY7GrTq6wdpTRhrW2ycFQ
         3PgI9OzA2jk0eu5YVK5PTMQSkN/pcFxMu1EF6wCa3zJWf41GjHszCPpkA+UY29RWyfHl
         48z+mNSSbCfci61P4LYVDqPA32pIf4wXI2i3Z7igv7nyErf9JjP6zphHMrH8bfzVKYUc
         NigA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mNf1Gc57uaZep/ht1DCQvf+zklgVxefomfLeuA1WYCs=;
        b=rMQeBrVLxLbmJyWx9uEd39Cew6k1hWXoPhdpO9z2MLVppo/S3fSo/0Y+YWuijRmGIQ
         D6EqmlHgiNsbg2vagsl7EAFceI6PsNRn3VsvKc6AcdgFpsjfTLnQz5lT+tZmcND/MVBs
         kMaPsBPXH3+ZHXJm2DBQXwRqVwzXXhO50oArVhLQPQdgfozQWX3/dGnoYHJwHh7DctvT
         sFiA4iSpLWKnEU21sAEXwCSPeNccvLjVmfooexLhJk2K/w4ORk6rywOUUcaLRPyleHSR
         cTM2hy65ihVvB1Nz0pxh3vb1WIcE7p7l4suZimW0L1LKfGHOggMsxIhqDMuwh+IOJaTr
         WuQQ==
X-Gm-Message-State: AOAM530cf0MEavkdwsR0kLI2WJVb+OQWfDTiWeOsZrXeigq8z8cgRHjq
        HjQ3PEZBceXxsIK1CQW9uoYJow==
X-Google-Smtp-Source: ABdhPJwSLr1aVkVGPdABQhumm352NtlikXZANY0BWSOK5rGg2RsR4/4BjeO2fNJ/hvTHJfXYVxY69w==
X-Received: by 2002:a05:6830:1290:: with SMTP id z16mr12070106otp.122.1616797829716;
        Fri, 26 Mar 2021 15:30:29 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id h12sm2524872ote.75.2021.03.26.15.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 15:30:29 -0700 (PDT)
Subject: Re: [PATCH 2/7] io_uring: handle signals for IO threads like a normal
 thread
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326155128.1057078-1-axboe@kernel.dk>
 <20210326155128.1057078-3-axboe@kernel.dk> <m1wntty7yn.fsf@fess.ebiederm.org>
 <106a38d3-5a5f-17fd-41f7-890f5e9a3602@kernel.dk>
 <m1k0ptv9kj.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <01058178-dd66-1bff-4d74-5ff610817ed6@kernel.dk>
Date:   Fri, 26 Mar 2021 16:30:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m1k0ptv9kj.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 4:23 PM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 3/26/21 2:29 PM, Eric W. Biederman wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>> We go through various hoops to disallow signals for the IO threads, but
>>>> there's really no reason why we cannot just allow them. The IO threads
>>>> never return to userspace like a normal thread, and hence don't go through
>>>> normal signal processing. Instead, just check for a pending signal as part
>>>> of the work loop, and call get_signal() to handle it for us if anything
>>>> is pending.
>>>>
>>>> With that, we can support receiving signals, including special ones like
>>>> SIGSTOP.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>  fs/io-wq.c    | 24 +++++++++++++++++-------
>>>>  fs/io_uring.c | 12 ++++++++----
>>>>  2 files changed, 25 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>>> index b7c1fa932cb3..3e2f059a1737 100644
>>>> --- a/fs/io-wq.c
>>>> +++ b/fs/io-wq.c
>>>> @@ -16,7 +16,6 @@
>>>>  #include <linux/rculist_nulls.h>
>>>>  #include <linux/cpu.h>
>>>>  #include <linux/tracehook.h>
>>>> -#include <linux/freezer.h>
>>>>  
>>>>  #include "../kernel/sched/sched.h"
>>>>  #include "io-wq.h"
>>>> @@ -503,10 +502,16 @@ static int io_wqe_worker(void *data)
>>>>  		if (io_flush_signals())
>>>>  			continue;
>>>>  		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
>>>> -		if (try_to_freeze() || ret)
>>>> +		if (signal_pending(current)) {
>>>> +			struct ksignal ksig;
>>>> +
>>>> +			if (fatal_signal_pending(current))
>>>> +				break;
>>>> +			if (get_signal(&ksig))
>>>> +				continue;
>>>                         ^^^^^^^^^^^^^^^^^^^^^^
>>>
>>> That is wrong.  You are promising to deliver a signal to signal
>>> handler and them simply discarding it.  Perhaps:
>>>
>>> 			if (!get_signal(&ksig))
>>>                         	continue;
>>> 			WARN_ON(!sig_kernel_stop(ksig->sig));
>>>                         break;
>>
>> Thanks, updated.
> 
> Gah.  Kill the WARN_ON.
> 
> I was thinking "WARN_ON(!sig_kernel_fatal(ksig->sig));"
> The function sig_kernel_fatal does not exist.
> 
> Fatal is the state that is left when a signal is neither
> ignored nor a stop signal, and does not have a handler.
> 
> The rest of the logic still works.

I've just come to the same conclusion myself after testing it.
Of the 3 cases, most of them can do the continue, but doesn't
really matter with the way the loop is structured. Anyway, looks
like this now:


commit 769186e30cd437f5e1a000e7cf00286948779da4
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Mar 25 18:16:06 2021 -0600

    io_uring: handle signals for IO threads like a normal thread
    
    We go through various hoops to disallow signals for the IO threads, but
    there's really no reason why we cannot just allow them. The IO threads
    never return to userspace like a normal thread, and hence don't go through
    normal signal processing. Instead, just check for a pending signal as part
    of the work loop, and call get_signal() to handle it for us if anything
    is pending.
    
    With that, we can support receiving signals, including special ones like
    SIGSTOP.
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b7c1fa932cb3..7e5970c8b0be 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -16,7 +16,6 @@
 #include <linux/rculist_nulls.h>
 #include <linux/cpu.h>
 #include <linux/tracehook.h>
-#include <linux/freezer.h>
 
 #include "../kernel/sched/sched.h"
 #include "io-wq.h"
@@ -503,10 +502,16 @@ static int io_wqe_worker(void *data)
 		if (io_flush_signals())
 			continue;
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
-		if (try_to_freeze() || ret)
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (fatal_signal_pending(current))
+				break;
+			if (!get_signal(&ksig))
+				continue;
+		}
+		if (ret)
 			continue;
-		if (fatal_signal_pending(current))
-			break;
 		/* timed out, exit unless we're the fixed worker */
 		if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
 		    !(worker->flags & IO_WORKER_F_FIXED))
@@ -714,9 +719,15 @@ static int io_wq_manager(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 		io_wq_check_workers(wq);
 		schedule_timeout(HZ);
-		try_to_freeze();
-		if (fatal_signal_pending(current))
-			set_bit(IO_WQ_BIT_EXIT, &wq->state);
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (fatal_signal_pending(current)) {
+				set_bit(IO_WQ_BIT_EXIT, &wq->state);
+				continue;
+			}
+			get_signal(&ksig);
+		}
 	} while (!test_bit(IO_WQ_BIT_EXIT, &wq->state));
 
 	io_wq_check_workers(wq);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 54ea561db4a5..1c64e3f9b7a2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -78,7 +78,6 @@
 #include <linux/task_work.h>
 #include <linux/pagemap.h>
 #include <linux/io_uring.h>
-#include <linux/freezer.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -6765,8 +6764,14 @@ static int io_sq_thread(void *data)
 			timeout = jiffies + sqd->sq_thread_idle;
 			continue;
 		}
-		if (fatal_signal_pending(current))
-			break;
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (fatal_signal_pending(current))
+				break;
+			if (!get_signal(&ksig))
+				continue;
+		}
 		sqt_spin = false;
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
@@ -6809,7 +6814,6 @@ static int io_sq_thread(void *data)
 
 			mutex_unlock(&sqd->lock);
 			schedule();
-			try_to_freeze();
 			mutex_lock(&sqd->lock);
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_clear_wakeup_flag(ctx);

-- 
Jens Axboe

