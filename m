Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF9E4196E8
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 17:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhI0PBf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 11:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234963AbhI0PBd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 11:01:33 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E3DC061604
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 07:59:55 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id b78so17844940iof.2
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 07:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uLXlWxVGEkoWhWtKQL0nyVslfQuFadAOO6/YckqDSmY=;
        b=zal/SEuPxMu7abv5ndknD9pJ0ARnlDA6g3ryVyTtf6NX3OB0gJIRG5BMYh9pl2XQYg
         SBElco7jAItOFK6H00ur5pNOlzc3luqe0kiqdg+yeSqs1R7vIN2x9OIByxjWa9PCNGZ0
         ds5NomfpOQZjCJKT/npHgX2qDC+EBmd3N4rh8cgV0wxvwf0KlgRyPy8yt2LwnRaASAC+
         idWHwOOOYtzpiAwXFrHyMInBbd2yFcZtKPXfRNRGvuPAslYuduCqzwUJ2KumpKqFjpkB
         CLCZaxgHKE4452c3fNhXDsK45q33skuRMxbFcwIo6PkoLY80IfQs0Zy6aEhrk1iIBsO8
         Ne1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uLXlWxVGEkoWhWtKQL0nyVslfQuFadAOO6/YckqDSmY=;
        b=mxdDz4+prgMQIlDVJBUoMsQktgD82HFM7wIxdNnDAWW82aTSeMnAi3hwgC/cw259IM
         NiSqX8uh+LbaWi2nMFGe25NKmEQVpZ5LRRWoLSZ6Khkx5rMIM/fdFCpSEz79187r+aT1
         94bSxQl5L9rMNSHEOIWgkVGEB5531QhbG3D9H4fGG5WwyNyEBKGwQMBuqIwq4Ublz0Tm
         X5R+xue77WMtCXOV5bxUoFtG5e3bi19cT+vDqxV8uNrrbjwLSEU1bmRASwnCvaCTR5hO
         T1pZo946crqgwFn9zgSQvYdslnXxEAznKN4r5heDM6ERADjkj+qK74eigfa0Lg4CiaII
         CMOw==
X-Gm-Message-State: AOAM531V6ZUT2Kb0RpN7EqLWuKo9WPWH8Cm13TK2uw6vwifbjncETTYO
        iDJpx9zjQkFn1RiLajAOcY3EEgIl88eySCWKZcA=
X-Google-Smtp-Source: ABdhPJzonSZnI7uZROIUdxfxwL2NdQBUVpza4EcQdv+6Zxud55+HpFC2gT/RlzhvIRHbW7m+TAvoKg==
X-Received: by 2002:a6b:5114:: with SMTP id f20mr106360iob.97.1632754794726;
        Mon, 27 Sep 2021 07:59:54 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i8sm8971260ioi.29.2021.09.27.07.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 07:59:54 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring fixes for 5.15-rc3
From:   Jens Axboe <axboe@kernel.dk>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>
References: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
 <CAHk-=whi3UxvY1C1LQNCO9d2xzX5A69qfzNGbBVGpRE_6gv=9Q@mail.gmail.com>
 <0eeefd32-f322-1470-9bcf-0f415be517bd@kernel.dk> <87lf3iazyu.fsf@disp2133>
 <feb00062-647c-1c74-dbe1-a7729ca49d7d@kernel.dk>
Message-ID: <521162e9-c7e4-284e-e575-51c503c51793@kernel.dk>
Date:   Mon, 27 Sep 2021 08:59:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <feb00062-647c-1c74-dbe1-a7729ca49d7d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/27/21 8:29 AM, Jens Axboe wrote:
> On 9/27/21 7:51 AM, Eric W. Biederman wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>>
>>> On 9/25/21 5:05 PM, Linus Torvalds wrote:
>>>> On Sat, Sep 25, 2021 at 1:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> - io-wq core dump exit fix (me)
>>>>
>>>> Hmm.
>>>>
>>>> That one strikes me as odd.
>>>>
>>>> I get the feeling that if the io_uring thread needs to have that
>>>> signal_group_exit() test, something is wrong in signal-land.
>>>>
>>>> It's basically a "fatal signal has been sent to another thread", and I
>>>> really get the feeling that "fatal_signal_pending()" should just be
>>>> modified to handle that case too.
>>>
>>> It did surprise me as well, which is why that previous change ended up
>>> being broken for the coredump case... You could argue that the io-wq
>>> thread should just exit on signal_pending(), which is what we did
>>> before, but that really ends up sucking for workloads that do use
>>> signals for communication purposes. postgres was the reporter here.
>>
>> The primary function get_signal is to make signals not pending.  So I
>> don't understand any use of testing signal_pending after a call to
>> get_signal.
>>
>> My confusion doubles when I consider the fact io_uring threads should
>> only be dequeuing SIGSTOP and SIGKILL.
>>
>> I am concerned that an io_uring thread that dequeues SIGKILL won't call
>> signal_group_exit and thus kill the other threads in the thread group.
>>
>> What motivated removing the break and adding the fatal_signal_pending
>> test?
> 
> I played with this a bit this morning, and I agree it doesn't seem to be
> needed at all. The original issue was with postgres, I'll give that a
> whirl as well and see if we run into any unwarranted exits. My simpler
> test case did not.

Ran the postgres test, and we get tons of io-wq exiting on get_signal()
returning true. Took a closer look, and it actually looks very much
expected, as it's a SIGKILL to the original task.

So it looks like I was indeed wrong, and this probably masked the
original issue that was fixed in that series. I've been running with
this:

diff --git a/fs/io-wq.c b/fs/io-wq.c
index c2360cdc403d..afd1db8e000d 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -584,10 +584,9 @@ static int io_wqe_worker(void *data)
 
 			if (!get_signal(&ksig))
 				continue;
-			if (fatal_signal_pending(current) ||
-			    signal_group_exit(current->signal))
-				break;
-			continue;
+			if (ksig.sig != SIGKILL)
+				printk("exit on sig! fatal? %d, sig=%d\n", fatal_signal_pending(current), ksig.sig);
+			break;
 		}
 		last_timeout = !ret;
 	}

and it's running fine and, as expected, we don't generate any printk
activity as these are all fatal deliveries to the parent.

-- 
Jens Axboe

