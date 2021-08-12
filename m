Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C1F3E9C17
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 03:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbhHLB4L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 21:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbhHLB4K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 21:56:10 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8851BC061765
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 18:55:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso7543236pjb.1
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 18:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AvmVfp9N9MzqpOduup5SUe14deW7P1+4cBwPLxHZyI0=;
        b=qIda0a4Y89WIe90e5r4pUE+NwvmkKtGRQtqay1+MwXoRGcqsb2AcnzKFkvrtPq2EIN
         zFgZCym+r0Cyt8Ibdqsjd+jHPtYLs0O/OA+PWULbPrFQK/4Wp/Fx8Y0vKtOHY84/Kdr2
         Gl/KF+A8hZO5xN96X1t+doKQiGKtY+VDi+YegrNm5THWT0T8z9ZELZZE4Y1F84zP9WFF
         qYTDHrs13FP5H42YMt+I6WnBH0FlwoVS6EulJLwvXAUbOYEiHvxs0IwQUD6PHdYOsvbn
         X9+ivLbUwiWkVhw6gAZwigIdKfUoQ0AoE0iW87q68tA5Z5Y2Ba69AzhZuZSRpvbBQx++
         eaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AvmVfp9N9MzqpOduup5SUe14deW7P1+4cBwPLxHZyI0=;
        b=Je4JNMkgFpQVrY8ZrQ2kTD3cZGdHo4ro0iCAHwGJRCvvL5mw8RcVX6ULNy5pl3yGrj
         Nh111lDK1XoqcI/yBFhFObolwIsBrRQ04GYrMX/xSp9EiZUlr+fnXGP1GwitTfSJKUDF
         6AhBsEODpm60jCj76Cit+2v654MZEXq5ghRfNEJyS6aobXLO3r38oFngG8Y7+vi/n1nW
         7xf0iupdqk27RXsog0PQKIGGuUjrTxV8OwERMFdIdDkBCkLx+OwQOrL9HdTCPttmqZ2K
         F/foSO+cpkGR4cJ2/kGQEHlB/BOZJsRvXMub238A3KFmbAD+nbOi4YVNmDI9iO6ZDoOt
         425w==
X-Gm-Message-State: AOAM530Zye7/HGYISPZprRZ020p48F/Ce+tY2NNpMkgAa5tJ8HbUCcam
        ePaCeW4skja0evuB25sfmxl2Zg==
X-Google-Smtp-Source: ABdhPJzSlg8XoSaxnKbdDitc17sMUu6ysUF9pCLIBR3zfnhLu6/NAumvK5Q/jrV8OPfz3THOTqxIxQ==
X-Received: by 2002:a65:67d5:: with SMTP id b21mr1529667pgs.315.1628733345972;
        Wed, 11 Aug 2021 18:55:45 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a17sm523242pff.30.2021.08.11.18.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 18:55:45 -0700 (PDT)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9d194813-ecb1-2fe4-70aa-75faf4e144ad@kernel.dk>
Date:   Wed, 11 Aug 2021 19:55:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8af373ec-9609-35a4-f185-f9bdc63d39b7@cybernetics.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 3:48 PM, Tony Battersby wrote:
> On 8/5/21 9:06 AM, Olivier Langlois wrote:
>> On Tue, 2021-06-15 at 17:08 -0500, Eric W. Biederman wrote:
>>> Oleg Nesterov <oleg@redhat.com> writes:
>>>
>>>>> --- a/fs/coredump.c
>>>>> +++ b/fs/coredump.c
>>>>> @@ -519,7 +519,7 @@ static bool dump_interrupted(void)
>>>>>          * but then we need to teach dump_write() to restart and
>>>>> clear
>>>>>          * TIF_SIGPENDING.
>>>>>          */
>>>>> -       return signal_pending(current);
>>>>> +       return fatal_signal_pending(current) || freezing(current);
>>>>>  }
>>>> Well yes, this is what the comment says.
>>>>
>>>> But note that there is another reason why dump_interrupted() returns
>>>> true
>>>> if signal_pending(), it assumes thagt __dump_emit()->__kernel_write()
>>>> may
>>>> fail anyway if signal_pending() is true. Say, pipe_write(), or iirc
>>>> nfs,
>>>> perhaps something else...
>>>>
>>>> That is why zap_threads() clears TIF_SIGPENDING. Perhaps it should
>>>> clear
>>>> TIF_NOTIFY_SIGNAL as well and we should change io-uring to not abuse
>>>> the
>>>> dumping threads?
>>>>
>>>> Or perhaps we should change __dump_emit() to clear signal_pending()
>>>> and
>>>> restart __kernel_write() if it fails or returns a short write.
>>>>
>>>> Otherwise the change above doesn't look like a full fix to me.
>>> Agreed.  The coredump to a pipe will still be short.  That needs
>>> something additional.
>>>
>>> The problem Olivier Langlois <olivier@trillion01.com> reported was
>>> core dumps coming up short because TIF_NOTIFY_SIGNAL was being
>>> set during a core dump.
>>>
>>> We can see this with pipe_write returning -ERESTARTSYS
>>> on a full pipe if signal_pending which includes TIF_NOTIFY_SIGNAL
>>> is true.
>>>
>>> Looking further if the thread that is core dumping initiated
>>> any io_uring work then io_ring_exit_work will use task_work_add
>>> to request that thread clean up it's io_uring state.
>>>
>>> Perhaps we can put a big comment in dump_emit and if we
>>> get back -ERESTARTSYS run tracework_notify_signal.  I am not
>>> seeing any locks held at that point in the coredump, so it
>>> should be safe.  The coredump is run inside of file_start_write
>>> which is the only potential complication.
>>>
>>>
>>>
>>> The code flow is complicated but it looks like the entire
>>> point of the exercise is to call io_uring_del_task_file
>>> on the originating thread.  I suppose that keeps the
>>> locking of the xarray in io_uring_task simple.
>>>
>>>
>>> Hmm.   All of this comes from io_uring_release.
>>> How do we get to io_uring_release?  The coredump should
>>> be catching everything in exit_mm before exit_files?
>>>
>>> Confused and hopeful someone can explain to me what is going on,
>>> and perhaps simplify it.
>>>
>>> Eric
>> Hi all,
>>
>> I didn't forgot about this remaining issue and I have kept thinking
>> about it on and off.
>>
>> I did try the following on 5.12.19:
>>
>> diff --git a/fs/coredump.c b/fs/coredump.c
>> index 07afb5ddb1c4..614fe7a54c1a 100644
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
>> @@ -625,6 +626,8 @@ void do_coredump(const kernel_siginfo_t *siginfo)
>>  		need_suid_safe = true;
>>  	}
>>  
>> +	io_uring_files_cancel(current->files);
>> +
>>  	retval = coredump_wait(siginfo->si_signo, &core_state);
>>  	if (retval < 0)
>>  		goto fail_creds;
>> --
>> 2.32.0
>>
>> with my current understanding, io_uring_files_cancel is supposed to
>> cancel everything that might set the TIF_NOTIFY_SIGNAL.
>>
>> I must report that in my testing with generating a core dump through a
>> pipe with the modif above, I still get truncated core dumps.
>>
>> systemd is having a weird error:
>> [ 2577.870742] systemd-coredump[4056]: Failed to get COMM: No such
>> process
>>
>> and nothing is captured
>>
>> so I have replaced it with a very simple shell:
>> $ cat /proc/sys/kernel/core_pattern 
>> |/home/lano1106/bin/pipe_core.sh %e %p
>>
>> ~/bin $ cat pipe_core.sh 
>> #!/bin/sh
>>
>> cat > /home/lano1106/core/core.$1.$2
>>
>> BFD: warning: /home/lano1106/core/core.test.10886 is truncated:
>> expected core file size >= 24129536, found: 61440
>>
>> I conclude from my attempt that maybe io_uring_files_cancel is not 100%
>> cleaning everything that it should clean.
>>
>>
>>
> I just ran into this problem also - coredumps from an io_uring program
> to a pipe are truncated.  But I am using kernel 5.10.57, which does NOT
> have commit 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL") or
> commit 06af8679449d ("coredump: Limit what can interrupt coredumps"). 
> Kernel 5.4 works though, so I bisected the problem to commit
> f38c7e3abfba ("io_uring: ensure async buffered read-retry is setup
> properly") in kernel 5.9.  Note that my io_uring program uses only async
> buffered reads, which may be why this particular commit makes a
> difference to my program.
> 
> My io_uring program is a multi-purpose long-running program with many
> threads.  Most threads don't use io_uring but a few of them do. 
> Normally, my core dumps are piped to a program so that they can be
> compressed before being written to disk, but I can also test writing the
> core dumps directly to disk.  This is what I have found:
> 
> *) Unpatched 5.10.57: if a thread that doesn't use io_uring triggers a
> coredump, the core file is written correctly, whether it is written to
> disk or piped to a program, even if another thread is using io_uring at
> the same time.
> 
> *) Unpatched 5.10.57: if a thread that uses io_uring triggers a
> coredump, the core file is truncated, whether written directly to disk
> or piped to a program.
> 
> *) 5.10.57+backport 06af8679449d: if a thread that uses io_uring
> triggers a coredump, and the core is written directly to disk, then it
> is written correctly.
> 
> *) 5.10.57+backport 06af8679449d: if a thread that uses io_uring
> triggers a coredump, and the core is piped to a program, then it is
> truncated.
> 
> *) 5.10.57+revert f38c7e3abfba: core dumps are written correctly,
> whether written directly to disk or piped to a program.

That is very interesting. Like Olivier mentioned, it's not that actual
commit, but rather the change of behavior implemented by it. Before that
commit, we'd hit the async workers more often, whereas after we do the
correct retry method where it's driven by the wakeup when the page is
unlocked. This is purely speculation, but perhaps the fact that the
process changes state potentially mid dump is why the dump ends up being
truncated?

I'd love to dive into this and try and figure it out. Absent a test
case, at least the above gives me an idea of what to try out. I'll see
if it makes it easier for me to create a case that does result in a
truncated core dump.

-- 
Jens Axboe

