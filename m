Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E7D413CB9
	for <lists+io-uring@lfdr.de>; Tue, 21 Sep 2021 23:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhIUVmz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Sep 2021 17:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235637AbhIUVmx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Sep 2021 17:42:53 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BD1C061574
        for <io-uring@vger.kernel.org>; Tue, 21 Sep 2021 14:41:24 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id dw14so565676pjb.1
        for <io-uring@vger.kernel.org>; Tue, 21 Sep 2021 14:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5isRS/SJ+SHPb4tK2U4UlkgLDNu8yJEV2NUNOZKLHhE=;
        b=aq7tkQmkdyLO9HIv/wfKStKCvKppoyrPhboWuCg2PVBqW/teCyy8mU8UND90KA4D93
         bGLj1XluIDD0tkPj3QoDeE3cMHZNeukX0+L2teTND0YhAzrrILblWO3kXlpTcKdd+sWJ
         RDSsi9LBPFUq5IK6NYYTJLIuMkzxX45r0gA9QIryqWdjeJpPmnJIAS4Ky/Oj8aZzZA80
         lf+iKkg2Qy43qTk7qtSbVhyZJzuM22UAu+B9h3YMgtXU8tQ3qV/8IDI2tMSiNSFJee8L
         8D2qPvoqaRqc/rEZNiWNKX31kdPYvXBeSyCugRei3am10rYvrl0BiXgFFOzxL64/Wrf7
         Rarg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5isRS/SJ+SHPb4tK2U4UlkgLDNu8yJEV2NUNOZKLHhE=;
        b=GEiG9ipOgyk94IHlRAva0jTGh9AsFWBl+x99stVKxn3BZv0iK8Dr5JJM9usTzJ64s9
         G18ZM/eoNNs6Rpnk30+I57k1EJP//MMQ1atPkNumwH8LlghVl5NcJrPTu4DBDHdPQ4KC
         GhpvXeCqjOKt56N+pdXGeQDvIFeTL8oS5CrG57hQbaEwvQb8ScGVhyZ/iB8451apbxqk
         QeQL4P8eCD5vQ6NdzS8qBkG5MfiykUPNZv1URB/Q2x/rZjI8e4ZzNpP8Ezo5iYgb/cMk
         mjI1fEIVHsZpTr1044a5Y6UMbEs9Jl2Ze75I7CyP2h3BnhKg49z1f8mltPATrO379LKA
         qFxQ==
X-Gm-Message-State: AOAM533iw+GtbEMn7oYFcUlNLdgKtZcg+K6PYqM1xT8SI1B+YrsNVK/s
        lFlyXWoyw7U/7FhuSvTK+4JUSF5ksTlX7uHi
X-Google-Smtp-Source: ABdhPJx3T06t+P60628HcFn0eD3R4C2eCTcMXrdZY+XZJqrnVqpCGWbC47gwMibP0BovklBeBKeqdA==
X-Received: by 2002:a17:902:b205:b0:13d:b0a1:da90 with SMTP id t5-20020a170902b20500b0013db0a1da90mr11235712plr.26.1632260483527;
        Tue, 21 Sep 2021 14:41:23 -0700 (PDT)
Received: from ?IPv6:2600:380:7577:f451:85ed:5f4e:dcd2:ab75? ([2600:380:7577:f451:85ed:5f4e:dcd2:ab75])
        by smtp.gmail.com with ESMTPSA id p27sm102665pfq.164.2021.09.21.14.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 14:41:22 -0700 (PDT)
Subject: Re: [5.15-rc1 regression] io_uring: fsstress hangs in do_coredump()
 on exit
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20210921064032.GW2361455@dread.disaster.area>
 <d9d2255c-fbac-3259-243a-2934b7ed0293@kernel.dk>
 <c97707cf-c543-52cd-5066-76b639f4f087@kernel.dk>
 <20210921213552.GZ2361455@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6d46951b-a7b3-0feb-3af0-aaa8ec87b87a@kernel.dk>
Date:   Tue, 21 Sep 2021 15:41:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210921213552.GZ2361455@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/21/21 3:35 PM, Dave Chinner wrote:
> On Tue, Sep 21, 2021 at 08:19:53AM -0600, Jens Axboe wrote:
>> On 9/21/21 7:25 AM, Jens Axboe wrote:
>>> On 9/21/21 12:40 AM, Dave Chinner wrote:
>>>> Hi Jens,
>>>>
>>>> I updated all my trees from 5.14 to 5.15-rc2 this morning and
>>>> immediately had problems running the recoveryloop fstest group on
>>>> them. These tests have a typical pattern of "run load in the
>>>> background, shutdown the filesystem, kill load, unmount and test
>>>> recovery".
>>>>
>>>> Whent eh load includes fsstress, and it gets killed after shutdown,
>>>> it hangs on exit like so:
>>>>
>>>> # echo w > /proc/sysrq-trigger 
>>>> [  370.669482] sysrq: Show Blocked State
>>>> [  370.671732] task:fsstress        state:D stack:11088 pid: 9619 ppid:  9615 flags:0x00000000
>>>> [  370.675870] Call Trace:
>>>> [  370.677067]  __schedule+0x310/0x9f0
>>>> [  370.678564]  schedule+0x67/0xe0
>>>> [  370.679545]  schedule_timeout+0x114/0x160
>>>> [  370.682002]  __wait_for_common+0xc0/0x160
>>>> [  370.684274]  wait_for_completion+0x24/0x30
>>>> [  370.685471]  do_coredump+0x202/0x1150
>>>> [  370.690270]  get_signal+0x4c2/0x900
>>>> [  370.691305]  arch_do_signal_or_restart+0x106/0x7a0
>>>> [  370.693888]  exit_to_user_mode_prepare+0xfb/0x1d0
>>>> [  370.695241]  syscall_exit_to_user_mode+0x17/0x40
>>>> [  370.696572]  do_syscall_64+0x42/0x80
>>>> [  370.697620]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>
>>>> It's 100% reproducable on one of my test machines, but only one of
>>>> them. That one machine is running fstests on pmem, so it has
>>>> synchronous storage. Every other test machine using normal async
>>>> storage (nvme, iscsi, etc) and none of them are hanging.
>>>>
>>>> A quick troll of the commit history between 5.14 and 5.15-rc2
>>>> indicates a couple of potential candidates. The 5th kernel build
>>>> (instead of ~16 for a bisect) told me that commit 15e20db2e0ce
>>>> ("io-wq: only exit on fatal signals") is the cause of the
>>>> regression. I've confirmed that this is the first commit where the
>>>> problem shows up.
>>>
>>> Thanks for the report Dave, I'll take a look. Can you elaborate on
>>> exactly what is being run? And when killed, it's a non-fatal signal?
> 
> It's whatever kill/killall sends by default.  Typical behaviour that
> causes a hang is something like:
> 
> $FSSTRESS_PROG -n10000000 -p $PROCS -d $load_dir >> $seqres.full 2>&1 &
> ....
> sleep 5
> _scratch_shutdown
> $KILLALL_PROG -q $FSSTRESS_PROG
> wait
> 
> _shutdown_scratch is typically just an 'xfs_io -rx -c "shutdown"
> /mnt/scratch' command that shuts down the filesystem. Other tests in
> the recoveryloop group use DM targets to fail IO that trigger a
> shutdown, others inject errors that trigger shutdowns, etc. But the
> result is that all hang waiting for fsstress processes that have
> been using io_uring to exit.
> 
> Just run fstests with "./check -g recoveryloop" - there's only a
> handful of tests and it only takes about 5 minutes to run them all
> on a fake DRAM based pmem device..

I made a trivial reproducer just to verify.

>> Can you try with this patch?
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index b5fd015268d7..1e55a0a2a217 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -586,7 +586,8 @@ static int io_wqe_worker(void *data)
>>  
>>  			if (!get_signal(&ksig))
>>  				continue;
>> -			if (fatal_signal_pending(current))
>> +			if (fatal_signal_pending(current) ||
>> +			    signal_group_exit(current->signal)) {
>>  				break;
>>  			continue;
>>  		}
> 
> Cleaned up so it compiles and the tests run properly again. But
> playing whack-a-mole with signals seems kinda fragile. I was pointed
> to this patchset by another dev on #xfs overnight who saw the same
> hangs that also fixed the hang:

It seems sane to me - exit if there's a fatal signal, or doing core
dump. Don't think there should be other conditions.

> https://lore.kernel.org/lkml/cover.1629655338.git.olivier@trillion01.com/
> 
> It was posted about a month ago and I don't see any response to it
> on the lists...

That's been a long discussion, but it's a different topic really. Yes
it's signals, but it's not this particular issue. It'll happen to work
around this issue, as it cancels everything post core dumping.

-- 
Jens Axboe

