Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CE537FFD5
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 23:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhEMVc3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 May 2021 17:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbhEMVc3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 May 2021 17:32:29 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E5AC061574;
        Thu, 13 May 2021 14:31:16 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id z17so9107673wrq.7;
        Thu, 13 May 2021 14:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lxHw7TCKx2hb6boyZbIG+fYmxV77qEn49Hr1UVMTS54=;
        b=p6tSv+EobEgxpfTu7MOWPBpaPi+pAvB27G9OnWs1OJ7XAukfEAXkGogtlBEDpwXNYz
         GgKoln0EQ73SsHnTJEIbqxDe2GiMM/ncQubJM0EHEoIN+j4v4dkWd9m3CAas50g//PWz
         9RXSwRizHyD0EyvXX5MzGVw+4VUSDl0cwbvRBDRkqxRLTcQX7KJyL2QVzBhIVHRByz3x
         ZWH+Wc7TSwRdBHY404XxGm7lI7kkVjdSM8FeOekmBzCGspByyB2xeEyM88gdpRPCNg63
         g/kVTAzgaL24zxPtWHKpBeNjpHtG9uhxrVAsy6TPq8pReppgrgEWbDOKMPNQz/2mHio1
         PQ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lxHw7TCKx2hb6boyZbIG+fYmxV77qEn49Hr1UVMTS54=;
        b=ClPtA1kAyVLYJu9wTsvjPWXgv7bTeo+L8devvNNDGWIG2PoXHfhttXJdHxvpXYbXLd
         bjjqn3N3JJX47FzNHQTTxH63z0KWeRVTHTOE7J7+6ep2bPtfOtSFSdOE+wqaaDh5pd+N
         bf78dHW0lKd0dF2ucvZdkVo/EUaSOrXyQURDX3uE6ap4DCxa3p8llVESRjz+XIKbmWIq
         hzUlKXKpnOlk/2ainvxhEMqSKDuUa8bOotlLnf8jkfAT6eiqGJN8EuWHd01JpHoDDaeN
         C8A9auQq2lH96piVKbvpwSth7jl+pc1CRFWT9mw8O5lWqmtvJj3cBrO2KfarFhm+1ScM
         nLJg==
X-Gm-Message-State: AOAM533D9aMcNKlA6BrKSJd78FYwlfOwmZNic5F5xltuF7fVgTgngDrV
        NPClltd/muEUEQA99RcgD5Q=
X-Google-Smtp-Source: ABdhPJyHaWXXv3rRmpRSOfvbxLms2cUi+X/Rb8DeCy3tuDsAnGwpwo2NEx/cYuZaDSOeF1KWSJUmDQ==
X-Received: by 2002:adf:f751:: with SMTP id z17mr53177099wrp.175.1620941475211;
        Thu, 13 May 2021 14:31:15 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.196])
        by smtp.gmail.com with ESMTPSA id u5sm4219848wrt.38.2021.05.13.14.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 14:31:14 -0700 (PDT)
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Palash Oswal <oswalpalash@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+11bf59db879676f59e52@syzkaller.appspotmail.com
References: <0000000000000c97e505bdd1d60e@google.com>
 <cfa0f9b8-91ec-4772-a6c2-c5206f32373fn@googlegroups.com>
 <53a22ab4-7a2d-4ebd-802d-9d1b4ce4e087n@googlegroups.com>
 <CAGyP=7fpNBhbmczjDq-vpzbSDyqwCw2jS7xQo4XO=bxwsy2ddQ@mail.gmail.com>
 <d5844c03-fa61-d256-be0d-b40446414299@gmail.com>
 <CAGyP=7e-3QtS-Z3KoAyFAbvm4y+9=725WR_+PyADYDi8HYxMXA@mail.gmail.com>
 <af911546-72e4-5525-6b31-1ad1f555799e@gmail.com>
 <CAGyP=7eoSfh7z638PnP5UF4xVKcrG1jB_qmFo6uPZ7iWfu_2sQ@mail.gmail.com>
 <4127fb94-89d2-4e36-8835-514118cb1cce@gmail.com>
Message-ID: <7c993a83-392f-39d0-7a6f-c78f121f5ae2@gmail.com>
Date:   Thu, 13 May 2021 22:31:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4127fb94-89d2-4e36-8835-514118cb1cce@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/13/21 10:28 PM, Pavel Begunkov wrote:
> On 5/10/21 5:47 AM, Palash Oswal wrote:
>> On Mon, May 3, 2021 at 4:15 PM Pavel Begunkov <asml.silence@gmail.com>
>> wrote:
>>
>>> On 5/3/21 5:41 AM, Palash Oswal wrote:
>>>> On Mon, May 3, 2021 at 3:42 AM Pavel Begunkov <asml.silence@gmail.com>
>>> wrote:
>>>>> The test might be very useful. Would you send a patch to
>>>>> liburing? Or mind the repro being taken as a test?
>>>>
>>>> Pavel,
>>>>
>>>> I'm working on a PR for liburing with this test. Do you know how I can
>>>
>>> Perfect, thanks
>>>
>>>> address this behavior?
>>>
>>> As the hang is sqpoll cancellations, it's most probably
>>> fixed in 5.13 + again awaits to be taken for stable.
>>>
>>> Don't know about segfaults, but it was so for long, and
>>> syz reproducers are ofthen faults for me, and exit with 0
>>> in the end. So, I wouldn't worry about it.
>>>
>>>
>> Hey Pavel,
>> The bug actually fails to reproduce on 5.12 when the fork() call is made by
>> the runtests.sh script. This causes the program to end correctly, and the
>> hang does not occur. I verified this on 5.12 where the bug isn't patched.
>> Just running the `sqpoll-cancel-hang` triggers the bug; whereas running it
>> after being forked from runtests.sh does not trigger the bug.
> 
> I see. fyi, it's always good to wait for 5 minutes, because some useful
> logs are not generated immediately but do timeout based hang detection.
> 
> I'd think that may be due CLONE_IO and how to whom it binds workers,
> but can you try first:
> 
> 1) timeout -s INT -k $TIMEOUT $TIMEOUT ./sqpoll-cancel-hang

edit:

timeout -s INT -k 60 60 ./sqpoll-cancel-hang

And privileged, root/sudo

> 
> 2) remove timeout from <liburing>/tests/Makefile and run
> "./runtests.sh sqpoll-cancel-hang" again looking for faults?
> 
> diff --git a/test/runtests.sh b/test/runtests.sh
> index e8f4ae5..2b51dca 100755
> --- a/test/runtests.sh
> +++ b/test/runtests.sh
> @@ -91,7 +91,8 @@ run_test()
>  	fi
>  
>  	# Run the test
> -	timeout -s INT -k $TIMEOUT $TIMEOUT ./$test_name $dev
> +	# timeout -s INT -k $TIMEOUT $TIMEOUT ./$test_name $dev
> +	./$test_name $dev
>  	local status=$?
>  
>  	# Check test status
> 
> 
>>
>> The segfaults are benign, but notice the "All tests passed" in the previous
>> mail. It should not have passed, as the run was on 5.12. Therefore I wanted
>> to ask your input on how to address this odd behaviour, where the
>> involvement of runtests.sh actually mitigated the bug.
>>
>>
>>
>>>> root@syzkaller:~/liburing/test# ./runtests.sh sqpoll-cancel-hang
>>>> Running test sqp[   15.310997] Running test sqpoll-cancel-hang:
>>>> oll-cancel-hang:
>>>> [   15.333348] sqpoll-cancel-h[305]: segfault at 0 ip 000055ad00e265e3
>>> sp]
>>>> [   15.334940] Code: 89 d8 8d 34 90 8b 45 04 ba 03 00 00 00 c1 e0 04 03
>>> 46
>>>> All tests passed
>>>>
>>>> root@syzkaller:~/liburing/test# ./sqpoll-cancel-hang
>>>> [   13.572639] sqpoll-cancel-h[298]: segfault at 0 ip 00005634c4a455e3
>>> sp]
>>>> [   13.576506] Code: 89 d8 8d 34 90 8b 45 04 ba 03 00 00 00 c1 e0 04 03
>>> 46
>>>> [   23.350459] random: crng init done
>>>> [   23.352837] random: 7 urandom warning(s) missed due to ratelimiting
>>>> [  243.090865] INFO: task iou-sqp-298:299 blocked for more than 120
>>> secon.
>>>> [  243.095187]       Not tainted 5.12.0 #142
>>>> [  243.099800] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>> disable.
>>>> [  243.105928] task:iou-sqp-298     state:D stack:    0 pid:  299 ppid:
>>> 4
>>>> [  243.111044] Call Trace:
>>>> [  243.112855]  __schedule+0xb1d/0x1130
>>>> [  243.115549]  ? __sched_text_start+0x8/0x8
>>>> [  243.118328]  ? io_wq_worker_sleeping+0x145/0x500
>>>> [  243.121790]  schedule+0x131/0x1c0
>>>> [  243.123698]  io_uring_cancel_sqpoll+0x288/0x350
>>>> [  243.125977]  ? io_sq_thread_unpark+0xd0/0xd0
>>>> [  243.128966]  ? mutex_lock+0xbb/0x130
>>>> [  243.132572]  ? init_wait_entry+0xe0/0xe0
>>>> [  243.135429]  ? wait_for_completion_killable_timeout+0x20/0x20
>>>> [  243.138303]  io_sq_thread+0x174c/0x18c0
>>>> [  243.140162]  ? io_rsrc_put_work+0x380/0x380
>>>> [  243.141613]  ? init_wait_entry+0xe0/0xe0
>>>> [  243.143686]  ? _raw_spin_lock_irq+0xa5/0x180
>>>> [  243.145619]  ? _raw_spin_lock_irqsave+0x190/0x190
>>>> [  243.147671]  ? calculate_sigpending+0x6b/0xa0
>>>> [  243.149036]  ? io_rsrc_put_work+0x380/0x380
>>>> [  243.150694]  ret_from_fork+0x22/0x30
>>>>
>>>> Palash
>>>>
>>>
>>> --
>>> Pavel Begunkov
>>>
>>
> 

-- 
Pavel Begunkov
