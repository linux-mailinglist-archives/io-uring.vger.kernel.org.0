Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8EB3EF2FB
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 22:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhHQUAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 16:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhHQUAa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 16:00:30 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70B3C0613CF
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 12:59:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e15so286066plh.8
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 12:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YCnH7wri8A6gFqECGkimfx1ed8a4h8yMk5Vm8xazQvs=;
        b=nI4PvMPvMnvKjr2nAJKkODyq6WiYPG2iE7OWohesnqxngEtPAsvmKfIpMYPX9fe1OA
         eAjeEGnx6kSp6nWBcfSeJqAfAhKcDqWoE6V5LSDLI2TIkY/ZTcE08w35DSsluZNGZEDg
         tiUvXy/084wz+7hFBNkOFKu2ouTVMF2qy8hLXbqooM+kAbSNStURYVOVFBu+Lu215ONH
         tdvNSg/TD0U3hTHdOhgfw9NHjfWHjRePthCGAU6VvcK51D0Ezo5npQo1kLYiHRaa6r9W
         mZU+YJD4hN2BGg7gK1YI/SMlpJkJ6STFRFNAyBHD/YWbXB6OaXFp/DAkaB1fowv8H8/U
         M1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YCnH7wri8A6gFqECGkimfx1ed8a4h8yMk5Vm8xazQvs=;
        b=ruIScW9eE5w9SsOWTb7gF1jClAGU2rdALG8RfHhQ+xzAzdnsihKaalTW87rhITAHqE
         g0u05fpFg5PdlMvW/yjfBWB6N2ZpuIzS6SpjOHpzHd1Nx1Q/kJ1oG/UmDgfeaJ7ve9yf
         gBbNIQqcjtEv9zVLCHro8u0BeT4yoz+0nwnzN/s+fdT5zW6CgbiEL2E1b7mn/n9HZT6b
         3hugra7qIHONVFYUNaprqBXkJYbayd+tfGKbk1i5pNz0RKd9ley1bTD3eptpZb2ZWa7M
         3dIze4b/zQSOqFfDAgP7CP4XxIpf5bCBBr7InKDxKQlIpvCidh4/bV9miJiD0oeD/gla
         u/gg==
X-Gm-Message-State: AOAM530ikCUpliG8kOTTI/LvL1Ek86UqGed30sAeTrsW2FiQGc8C+sZz
        4QyQwnd7vpHxHYpakuDSu1lZrA==
X-Google-Smtp-Source: ABdhPJzSp0orehkN5BzAPPfc1O23yXzXGOwbwnrGmYKz1PmxIelrFdA1gda52sdVbhgC569/T0gVQg==
X-Received: by 2002:a17:902:7681:b0:12d:8f52:3d55 with SMTP id m1-20020a170902768100b0012d8f523d55mr4040763pll.70.1629230396092;
        Tue, 17 Aug 2021 12:59:56 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y12sm4398483pgl.65.2021.08.17.12.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 12:59:55 -0700 (PDT)
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
To:     Tony Battersby <tonyb@cybernetics.com>,
        Olivier Langlois <olivier@trillion01.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
 <87eeda7nqe.fsf@disp2133>
 <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
 <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
 <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
 <87y2bh4jg5.fsf@disp2133>
 <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
 <87sg1p4h0g.fsf_-_@disp2133> <20210614141032.GA13677@redhat.com>
 <87pmwmn5m0.fsf@disp2133>
 <4d93d0600e4a9590a48d320c5a7dd4c54d66f095.camel@trillion01.com>
 <8af373ec-9609-35a4-f185-f9bdc63d39b7@cybernetics.com>
 <9d194813-ecb1-2fe4-70aa-75faf4e144ad@kernel.dk>
 <b36eb4a26b6aff564c6ef850a3508c5b40141d46.camel@trillion01.com>
 <0bc38b13-5a7e-8620-6dce-18731f15467e@kernel.dk>
 <24c795c6-4ec4-518e-bf9b-860207eee8c7@kernel.dk>
 <05c0cadc-029e-78af-795d-e09cf3e80087@cybernetics.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b5ab8ca0-cef5-c9b7-e47f-21c0d395f82e@kernel.dk>
Date:   Tue, 17 Aug 2021 13:59:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <05c0cadc-029e-78af-795d-e09cf3e80087@cybernetics.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/21 1:29 PM, Tony Battersby wrote:
> On 8/17/21 2:24 PM, Jens Axboe wrote:
>> On 8/17/21 12:15 PM, Jens Axboe wrote:
>>> On 8/15/21 2:42 PM, Olivier Langlois wrote:
>>>> On Wed, 2021-08-11 at 19:55 -0600, Jens Axboe wrote:
>>>>> On 8/10/21 3:48 PM, Tony Battersby wrote:
>>>>>> On 8/5/21 9:06 AM, Olivier Langlois wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> I didn't forgot about this remaining issue and I have kept thinking
>>>>>>> about it on and off.
>>>>>>>
>>>>>>> I did try the following on 5.12.19:
>>>>>>>
>>>>>>> diff --git a/fs/coredump.c b/fs/coredump.c
>>>>>>> index 07afb5ddb1c4..614fe7a54c1a 100644
>>>>>>> --- a/fs/coredump.c
>>>>>>> +++ b/fs/coredump.c
>>>>>>> @@ -41,6 +41,7 @@
>>>>>>>  #include <linux/fs.h>
>>>>>>>  #include <linux/path.h>
>>>>>>>  #include <linux/timekeeping.h>
>>>>>>> +#include <linux/io_uring.h>
>>>>>>>  
>>>>>>>  #include <linux/uaccess.h>
>>>>>>>  #include <asm/mmu_context.h>
>>>>>>> @@ -625,6 +626,8 @@ void do_coredump(const kernel_siginfo_t
>>>>>>> *siginfo)
>>>>>>>                 need_suid_safe = true;
>>>>>>>         }
>>>>>>>  
>>>>>>> +       io_uring_files_cancel(current->files);
>>>>>>> +
>>>>>>>         retval = coredump_wait(siginfo->si_signo, &core_state);
>>>>>>>         if (retval < 0)
>>>>>>>                 goto fail_creds;
>>>>>>> --
>>>>>>> 2.32.0
>>>>>>>
>>>>>>> with my current understanding, io_uring_files_cancel is supposed to
>>>>>>> cancel everything that might set the TIF_NOTIFY_SIGNAL.
>>>>>>>
>>>>>>> I must report that in my testing with generating a core dump
>>>>>>> through a
>>>>>>> pipe with the modif above, I still get truncated core dumps.
>>>>>>>
>>>>>>> systemd is having a weird error:
>>>>>>> [ 2577.870742] systemd-coredump[4056]: Failed to get COMM: No such
>>>>>>> process
>>>>>>>
>>>>>>> and nothing is captured
>>>>>>>
>>>>>>> so I have replaced it with a very simple shell:
>>>>>>> $ cat /proc/sys/kernel/core_pattern 
>>>>>>>> /home/lano1106/bin/pipe_core.sh %e %p
>>>>>>> ~/bin $ cat pipe_core.sh 
>>>>>>> #!/bin/sh
>>>>>>>
>>>>>>> cat > /home/lano1106/core/core.$1.$2
>>>>>>>
>>>>>>> BFD: warning: /home/lano1106/core/core.test.10886 is truncated:
>>>>>>> expected core file size >= 24129536, found: 61440
>>>>>>>
>>>>>>> I conclude from my attempt that maybe io_uring_files_cancel is not
>>>>>>> 100%
>>>>>>> cleaning everything that it should clean.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>> I just ran into this problem also - coredumps from an io_uring
>>>>>> program
>>>>>> to a pipe are truncated.  But I am using kernel 5.10.57, which does
>>>>>> NOT
>>>>>> have commit 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
>>>>>> or
>>>>>> commit 06af8679449d ("coredump: Limit what can interrupt coredumps").
>>>>>> Kernel 5.4 works though, so I bisected the problem to commit
>>>>>> f38c7e3abfba ("io_uring: ensure async buffered read-retry is setup
>>>>>> properly") in kernel 5.9.  Note that my io_uring program uses only
>>>>>> async
>>>>>> buffered reads, which may be why this particular commit makes a
>>>>>> difference to my program.
>>>>>>
>>>>>> My io_uring program is a multi-purpose long-running program with many
>>>>>> threads.  Most threads don't use io_uring but a few of them do. 
>>>>>> Normally, my core dumps are piped to a program so that they can be
>>>>>> compressed before being written to disk, but I can also test writing
>>>>>> the
>>>>>> core dumps directly to disk.  This is what I have found:
>>>>>>
>>>>>> *) Unpatched 5.10.57: if a thread that doesn't use io_uring triggers
>>>>>> a
>>>>>> coredump, the core file is written correctly, whether it is written
>>>>>> to
>>>>>> disk or piped to a program, even if another thread is using io_uring
>>>>>> at
>>>>>> the same time.
>>>>>>
>>>>>> *) Unpatched 5.10.57: if a thread that uses io_uring triggers a
>>>>>> coredump, the core file is truncated, whether written directly to
>>>>>> disk
>>>>>> or piped to a program.
>>>>>>
>>>>>> *) 5.10.57+backport 06af8679449d: if a thread that uses io_uring
>>>>>> triggers a coredump, and the core is written directly to disk, then
>>>>>> it
>>>>>> is written correctly.
>>>>>>
>>>>>> *) 5.10.57+backport 06af8679449d: if a thread that uses io_uring
>>>>>> triggers a coredump, and the core is piped to a program, then it is
>>>>>> truncated.
>>>>>>
>>>>>> *) 5.10.57+revert f38c7e3abfba: core dumps are written correctly,
>>>>>> whether written directly to disk or piped to a program.
>>>>> That is very interesting. Like Olivier mentioned, it's not that actual
>>>>> commit, but rather the change of behavior implemented by it. Before
>>>>> that
>>>>> commit, we'd hit the async workers more often, whereas after we do the
>>>>> correct retry method where it's driven by the wakeup when the page is
>>>>> unlocked. This is purely speculation, but perhaps the fact that the
>>>>> process changes state potentially mid dump is why the dump ends up
>>>>> being
>>>>> truncated?
>>>>>
>>>>> I'd love to dive into this and try and figure it out. Absent a test
>>>>> case, at least the above gives me an idea of what to try out. I'll see
>>>>> if it makes it easier for me to create a case that does result in a
>>>>> truncated core dump.
>>>>>
>>>> Jens,
>>>>
>>>> When I have first encountered the issue, the very first thing that I
>>>> did try was to create a simple test program that would synthetize the
>>>> problem.
>>>>
>>>> After few time consumming failed attempts, I just gave up the idea and
>>>> simply settle to my prod program that showcase systematically the
>>>> problem every time that I kill the process with a SEGV signal.
>>>>
>>>> In a nutshell, all the program does is to issue read operations with
>>>> io_uring on a TCP socket on which there is a constant data stream.
>>>>
>>>> Now that I have a better understanding of what is going on, I think
>>>> that one way that could reproduce the problem consistently could be
>>>> along those lines:
>>>>
>>>> 1. Create a pipe
>>>> 2. fork a child
>>>> 3. Initiate a read operation on the pipe with io_uring from the child
>>>> 4. Let the parent kill its child with a core dump generating signal.
>>>> 5. Write something in the pipe from the parent so that the io_uring
>>>> read operation completes while the core dump is generated.
>>>>
>>>> I guess that I'll end up doing that if I cannot fix the issue with my
>>>> current setup but here is what I have attempted so far:
>>>>
>>>> 1. Call io_uring_files_cancel from do_coredump
>>>> 2. Same as #1 but also make sure that TIF_NOTIFY_SIGNAL is cleared on
>>>> returning from io_uring_files_cancel
>>>>
>>>> Those attempts didn't work but lurking in the io_uring dev mailing list
>>>> is starting to pay off. I thought that I did reach the bottom of the
>>>> rabbit hole in my journey of understanding io_uring but the recent
>>>> patch set sent by Hao Xu
>>>>
>>>> https://lore.kernel.org/io-uring/90fce498-968e-6812-7b6a-fdf8520ea8d9@kernel.dk/T/#t
>>>>
>>>> made me realize that I still haven't assimilated all the small io_uring
>>>> nuances...
>>>>
>>>> Here is my feedback. From my casual io_uring code reader point of view,
>>>> it is not 100% obvious what the difference is between
>>>> io_uring_files_cancel and io_uring_task_cancel
>>>>
>>>> It seems like io_uring_files_cancel is cancelling polls only if they
>>>> have the REQ_F_INFLIGHT flag set.
>>>>
>>>> I have no idea what an inflight request means and why someone would
>>>> want to call io_uring_files_cancel over io_uring_task_cancel.
>>>>
>>>> I guess that if I was to meditate on the question for few hours, I
>>>> would at some point get some illumination strike me but I believe that
>>>> it could be a good idea to document in the code those concepts for
>>>> helping casual readers...
>>>>
>>>> Bottomline, I now understand that io_uring_files_cancel does not cancel
>>>> all the requests. Therefore, without fully understanding what I am
>>>> doing, I am going to replace my call to io_uring_files_cancel from
>>>> do_coredump with io_uring_task_cancel and see if this finally fix the
>>>> issue for good.
>>>>
>>>> What I am trying to do is to cancel pending io_uring requests to make
>>>> sure that TIF_NOTIFY_SIGNAL isn't set while core dump is generated.
>>>>
>>>> Maybe another solution would simply be to modify __dump_emit to make it
>>>> resilient to TIF_NOTIFY_SIGNAL as Eric W. Biederman originally
>>>> suggested.
>>>>
>>>> or maybe do both...
>>>>
>>>> Not sure which approach is best. If someone has an opinion, I would be
>>>> curious to hear it.
>>> It does indeed sound like it's TIF_NOTIFY_SIGNAL that will trigger some
>>> signal_pending() and cause an interruption of the core dump. Just out of
>>> curiosity, what is your /proc/sys/kernel/core_pattern set to? If it's
>>> set to some piped process, can you try and set it to 'core' and see if
>>> that eliminates the truncation of the core dumps for your case?
>> And assuming that works, then I suspect this one would fix your issue
>> even with a piped core dump:
>>
>> diff --git a/fs/coredump.c b/fs/coredump.c
>> index 07afb5ddb1c4..852737a9ccbf 100644
>> --- a/fs/coredump.c
>> +++ b/fs/coredump.c
>> @@ -41,6 +41,7 @@
>>  #include <linux/fs.h>
>>  #include <linux/path.h>
>>  #include <linux/timekeeping.h>
>> +#include <linux/io_uring.h>
>>  
>>  #include <linux/uaccess.h>
>>  #include <asm/mmu_context.h>
>> @@ -603,6 +604,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
>>  	};
>>  
>>  	audit_core_dumps(siginfo->si_signo);
>> +	io_uring_task_cancel();
>>  
>>  	binfmt = mm->binfmt;
>>  	if (!binfmt || !binfmt->core_dump)
>>
> FYI, I tested kernel 5.10.59 + backport 06af8679449d + the patch above
> with my io_uring program.  The coredump locked up even when writing the
> core file directly to disk; the zombie process could not be killed with
> "kill -9".  Unfortunately I can't test with newer kernels without
> spending some time on it, and I am too busy with other stuff right now.

That sounds like 5.10-stable is missing some of the cancelation
backports, and your setup makes the cancelation stall because of that.
Need to go over the 11/12/13 fixes and ensure that we've got everything
we need for those stable versions, particularly 5.10.

> My io_uring program does async buffered reads
> (io_uring_prep_read()/io_uring_prep_readv()) from a raw disk partition
> (no filesystem).  One thread submits I/Os while another thread calls
> io_uring_wait_cqe() and processes the completions.  To trigger the
> coredump, I added an intentional abort() in the thread that submits I/Os
> after running for a second.

OK, so that one is also using task_work for the retry based async
buffered reads, so it makes sense.

Maybe a temporary work-around is to use 06af8679449d and eliminate the
pipe based coredump?

-- 
Jens Axboe

