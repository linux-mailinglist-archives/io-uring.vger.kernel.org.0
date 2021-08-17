Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D66B3EF195
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 20:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbhHQSPj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 14:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhHQSPj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 14:15:39 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3161EC0613CF
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 11:15:06 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id v33-20020a0568300921b0290517cd06302dso13162261ott.13
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 11:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AVdaqCFH+UALpuVfO+b7JgwQXf9nnVhWLkRBb8EvjqA=;
        b=i8zMLfL/Uz1yWRkKL8ebwiwa3gjf6qYyQ9gAtF9wsEzN9SgsFUlTEiNFR/RO8Fdt+W
         TuvGICtLyE81yElj20y0Wy+bc4rRSa/dKhBvzW5v12t8eGB+MUANgCNa0zYJEZjqSpV9
         QjI3k5qC2icq6i+DqMO08AJftIQivb2apI1sMytjWXAh5EK03jX19MWVTG3tTXuONItR
         KQjRS3EQy9oOoFU+HzRBdgNBetmmWRcLAqY/f8kKDoHC1KmaN0qxC1om4ENQB1bi9Ulg
         QAVJWYINPYu6WfjXO6a4zCL+l4QOunD4+w9Ufd2Y0srGRwBqWLUJ/Ku1GSm4yBpevvEV
         g+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AVdaqCFH+UALpuVfO+b7JgwQXf9nnVhWLkRBb8EvjqA=;
        b=WHGvfe8l0Xwpba1JjUzyb3XtU/qzAG7WMO2g3dCStf1DFrJIRUsOeSHWtzN380QyAB
         9j/OAqwR+QerIIR+Zeln2PbL2FoggPK3No/6qs9/va+7qfEVXmeaGTn4o2KWn5FcLoTa
         NkZhRmOBfjC25q9tu88jbEuaG/84NzcKxH+lYtwygf0ghuE+6DrYD1WX5TV1HrYbeVI3
         DY2vyUyfrKpmLNArBBhRa29uAn76xULZfovBssF48VtDzlAqOCDMdGe7ln1IVYEp6ZFk
         Ux9nNSp3TVdRypwF86Y+iFc8sRdKRAwP3xXzNKL9D6nsEcmZH2FogU49CtFli9I+E3Av
         N+qA==
X-Gm-Message-State: AOAM531if99pAcsuocOTUPmEugnIUNIWuSmQAZk1/dGw8bZmPjePaZWt
        otDGMMjxU0SdEy3qzhvEn901YQ==
X-Google-Smtp-Source: ABdhPJwCNka9f7F+JOOl3DJYEZSFnaJX33sUdGts2IRPhP/mJBgEsGoNl6iNRaf3cj60zaBx+KXFFA==
X-Received: by 2002:a9d:70cc:: with SMTP id w12mr1630001otj.306.1629224105422;
        Tue, 17 Aug 2021 11:15:05 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x198sm570603ooa.43.2021.08.17.11.15.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 11:15:05 -0700 (PDT)
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
To:     Olivier Langlois <olivier@trillion01.com>,
        Tony Battersby <tonyb@cybernetics.com>,
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0bc38b13-5a7e-8620-6dce-18731f15467e@kernel.dk>
Date:   Tue, 17 Aug 2021 12:15:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b36eb4a26b6aff564c6ef850a3508c5b40141d46.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/21 2:42 PM, Olivier Langlois wrote:
> On Wed, 2021-08-11 at 19:55 -0600, Jens Axboe wrote:
>> On 8/10/21 3:48 PM, Tony Battersby wrote:
>>> On 8/5/21 9:06 AM, Olivier Langlois wrote:
>>>>
>>>> Hi all,
>>>>
>>>> I didn't forgot about this remaining issue and I have kept thinking
>>>> about it on and off.
>>>>
>>>> I did try the following on 5.12.19:
>>>>
>>>> diff --git a/fs/coredump.c b/fs/coredump.c
>>>> index 07afb5ddb1c4..614fe7a54c1a 100644
>>>> --- a/fs/coredump.c
>>>> +++ b/fs/coredump.c
>>>> @@ -41,6 +41,7 @@
>>>>  #include <linux/fs.h>
>>>>  #include <linux/path.h>
>>>>  #include <linux/timekeeping.h>
>>>> +#include <linux/io_uring.h>
>>>>  
>>>>  #include <linux/uaccess.h>
>>>>  #include <asm/mmu_context.h>
>>>> @@ -625,6 +626,8 @@ void do_coredump(const kernel_siginfo_t
>>>> *siginfo)
>>>>                 need_suid_safe = true;
>>>>         }
>>>>  
>>>> +       io_uring_files_cancel(current->files);
>>>> +
>>>>         retval = coredump_wait(siginfo->si_signo, &core_state);
>>>>         if (retval < 0)
>>>>                 goto fail_creds;
>>>> --
>>>> 2.32.0
>>>>
>>>> with my current understanding, io_uring_files_cancel is supposed to
>>>> cancel everything that might set the TIF_NOTIFY_SIGNAL.
>>>>
>>>> I must report that in my testing with generating a core dump
>>>> through a
>>>> pipe with the modif above, I still get truncated core dumps.
>>>>
>>>> systemd is having a weird error:
>>>> [ 2577.870742] systemd-coredump[4056]: Failed to get COMM: No such
>>>> process
>>>>
>>>> and nothing is captured
>>>>
>>>> so I have replaced it with a very simple shell:
>>>> $ cat /proc/sys/kernel/core_pattern 
>>>>> /home/lano1106/bin/pipe_core.sh %e %p
>>>>
>>>> ~/bin $ cat pipe_core.sh 
>>>> #!/bin/sh
>>>>
>>>> cat > /home/lano1106/core/core.$1.$2
>>>>
>>>> BFD: warning: /home/lano1106/core/core.test.10886 is truncated:
>>>> expected core file size >= 24129536, found: 61440
>>>>
>>>> I conclude from my attempt that maybe io_uring_files_cancel is not
>>>> 100%
>>>> cleaning everything that it should clean.
>>>>
>>>>
>>>>
>>> I just ran into this problem also - coredumps from an io_uring
>>> program
>>> to a pipe are truncated.  But I am using kernel 5.10.57, which does
>>> NOT
>>> have commit 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
>>> or
>>> commit 06af8679449d ("coredump: Limit what can interrupt coredumps").
>>> Kernel 5.4 works though, so I bisected the problem to commit
>>> f38c7e3abfba ("io_uring: ensure async buffered read-retry is setup
>>> properly") in kernel 5.9.  Note that my io_uring program uses only
>>> async
>>> buffered reads, which may be why this particular commit makes a
>>> difference to my program.
>>>
>>> My io_uring program is a multi-purpose long-running program with many
>>> threads.  Most threads don't use io_uring but a few of them do. 
>>> Normally, my core dumps are piped to a program so that they can be
>>> compressed before being written to disk, but I can also test writing
>>> the
>>> core dumps directly to disk.  This is what I have found:
>>>
>>> *) Unpatched 5.10.57: if a thread that doesn't use io_uring triggers
>>> a
>>> coredump, the core file is written correctly, whether it is written
>>> to
>>> disk or piped to a program, even if another thread is using io_uring
>>> at
>>> the same time.
>>>
>>> *) Unpatched 5.10.57: if a thread that uses io_uring triggers a
>>> coredump, the core file is truncated, whether written directly to
>>> disk
>>> or piped to a program.
>>>
>>> *) 5.10.57+backport 06af8679449d: if a thread that uses io_uring
>>> triggers a coredump, and the core is written directly to disk, then
>>> it
>>> is written correctly.
>>>
>>> *) 5.10.57+backport 06af8679449d: if a thread that uses io_uring
>>> triggers a coredump, and the core is piped to a program, then it is
>>> truncated.
>>>
>>> *) 5.10.57+revert f38c7e3abfba: core dumps are written correctly,
>>> whether written directly to disk or piped to a program.
>>
>> That is very interesting. Like Olivier mentioned, it's not that actual
>> commit, but rather the change of behavior implemented by it. Before
>> that
>> commit, we'd hit the async workers more often, whereas after we do the
>> correct retry method where it's driven by the wakeup when the page is
>> unlocked. This is purely speculation, but perhaps the fact that the
>> process changes state potentially mid dump is why the dump ends up
>> being
>> truncated?
>>
>> I'd love to dive into this and try and figure it out. Absent a test
>> case, at least the above gives me an idea of what to try out. I'll see
>> if it makes it easier for me to create a case that does result in a
>> truncated core dump.
>>
> Jens,
> 
> When I have first encountered the issue, the very first thing that I
> did try was to create a simple test program that would synthetize the
> problem.
> 
> After few time consumming failed attempts, I just gave up the idea and
> simply settle to my prod program that showcase systematically the
> problem every time that I kill the process with a SEGV signal.
> 
> In a nutshell, all the program does is to issue read operations with
> io_uring on a TCP socket on which there is a constant data stream.
> 
> Now that I have a better understanding of what is going on, I think
> that one way that could reproduce the problem consistently could be
> along those lines:
> 
> 1. Create a pipe
> 2. fork a child
> 3. Initiate a read operation on the pipe with io_uring from the child
> 4. Let the parent kill its child with a core dump generating signal.
> 5. Write something in the pipe from the parent so that the io_uring
> read operation completes while the core dump is generated.
> 
> I guess that I'll end up doing that if I cannot fix the issue with my
> current setup but here is what I have attempted so far:
> 
> 1. Call io_uring_files_cancel from do_coredump
> 2. Same as #1 but also make sure that TIF_NOTIFY_SIGNAL is cleared on
> returning from io_uring_files_cancel
> 
> Those attempts didn't work but lurking in the io_uring dev mailing list
> is starting to pay off. I thought that I did reach the bottom of the
> rabbit hole in my journey of understanding io_uring but the recent
> patch set sent by Hao Xu
> 
> https://lore.kernel.org/io-uring/90fce498-968e-6812-7b6a-fdf8520ea8d9@kernel.dk/T/#t
> 
> made me realize that I still haven't assimilated all the small io_uring
> nuances...
> 
> Here is my feedback. From my casual io_uring code reader point of view,
> it is not 100% obvious what the difference is between
> io_uring_files_cancel and io_uring_task_cancel
> 
> It seems like io_uring_files_cancel is cancelling polls only if they
> have the REQ_F_INFLIGHT flag set.
> 
> I have no idea what an inflight request means and why someone would
> want to call io_uring_files_cancel over io_uring_task_cancel.
> 
> I guess that if I was to meditate on the question for few hours, I
> would at some point get some illumination strike me but I believe that
> it could be a good idea to document in the code those concepts for
> helping casual readers...
> 
> Bottomline, I now understand that io_uring_files_cancel does not cancel
> all the requests. Therefore, without fully understanding what I am
> doing, I am going to replace my call to io_uring_files_cancel from
> do_coredump with io_uring_task_cancel and see if this finally fix the
> issue for good.
> 
> What I am trying to do is to cancel pending io_uring requests to make
> sure that TIF_NOTIFY_SIGNAL isn't set while core dump is generated.
> 
> Maybe another solution would simply be to modify __dump_emit to make it
> resilient to TIF_NOTIFY_SIGNAL as Eric W. Biederman originally
> suggested.
> 
> or maybe do both...
> 
> Not sure which approach is best. If someone has an opinion, I would be
> curious to hear it.

It does indeed sound like it's TIF_NOTIFY_SIGNAL that will trigger some
signal_pending() and cause an interruption of the core dump. Just out of
curiosity, what is your /proc/sys/kernel/core_pattern set to? If it's
set to some piped process, can you try and set it to 'core' and see if
that eliminates the truncation of the core dumps for your case?

-- 
Jens Axboe

