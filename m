Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213E13EF84B
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 04:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbhHRC6S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 22:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbhHRC6R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 22:58:17 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAF4C0613C1
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 19:57:43 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c17so939256plz.2
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 19:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+FnTWa+l0J/Bl11ZRox2L95R79IvwH5WB9vcb4noNjs=;
        b=B7HB1mDV7CuGO7lP+Un/UxtRcn54BH1L8fJa6vhsUG/WVAgq266Qa/MHgsvJzMjVi2
         qic9Ya/pe0TVCrPFoSRl5luDWXHbpAe3iNDCHEatCCIOsJDlJlT80QUR2kAqxpxzYaoc
         6NZvyWWwIUVWg8U1GswcAXvOJWl4GcX2W3w2BKkYjmeNH0LGpfBiMwQdl8St7Bq//Tsx
         3vNbUwgS2F25A4tR+n/2EIBo+acay0cUA/RjFiYhQuL0Ew9C2k3F885qcM22Tbe1+MnU
         bq3c9/OrDyAkDsKB9cTawmsxcRKRKF+yeh+st7TiOBhsKKjtd/XEd3cdH+QlLVsw1kPY
         48bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+FnTWa+l0J/Bl11ZRox2L95R79IvwH5WB9vcb4noNjs=;
        b=Gzrdxy8jjR8Q9K49Osg4Kco1ehmWhbSnbh4duKABOkuug8i4G0/P764pvBSxMPoswu
         Hwlap+VVPFq2Z7aK3CAoJSDRoz86b/8LTDEm1fXTixtn/k6o4/Bbgr5H7hV6m9tp0Bny
         m7ZZRiGGk9A4H3+XQhUftY4T8QNs1Ak3IU1H911oAs4fY0aDaHU4GF5Ch/1lY8UlwNz/
         ai7ndoybawzC06F7psaRzqlRGPj0ckASNp5N3byQ13H2zXk/P+VYzWO4O+SKTxO1e1c6
         del8je1+3a2G+jCKGsso52KkxzX98OMhSEGlKtir1lOUcOPHU7WNo/vKsDjw1Or0zf/l
         ddTQ==
X-Gm-Message-State: AOAM532KC8l4ig6iqiB8oVRwcG66Mut8hRzVBs2nDMoSScShqkU/1kqF
        9cmrnsRUIo1LlZV4iMOFvwCyVA==
X-Google-Smtp-Source: ABdhPJwEtiInYT5XxvRdo8LhR7kiY0srELIigo3G1h8H8pTRMBxLIvwqnTYKuEq2y+uoQdYlbBYqKA==
X-Received: by 2002:a17:90a:4b07:: with SMTP id g7mr6851261pjh.48.1629255462551;
        Tue, 17 Aug 2021 19:57:42 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id gz17sm3353668pjb.8.2021.08.17.19.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 19:57:42 -0700 (PDT)
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
From:   Jens Axboe <axboe@kernel.dk>
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
 <b5ab8ca0-cef5-c9b7-e47f-21c0d395f82e@kernel.dk>
 <84640f18-79ee-d8e4-5204-41a2c2330ed8@kernel.dk>
Message-ID: <c4578bef-a21a-2435-e75a-d11d13d42923@kernel.dk>
Date:   Tue, 17 Aug 2021 20:57:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <84640f18-79ee-d8e4-5204-41a2c2330ed8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/21 3:28 PM, Jens Axboe wrote:
> On 8/17/21 1:59 PM, Jens Axboe wrote:
>> On 8/17/21 1:29 PM, Tony Battersby wrote:
>>> On 8/17/21 2:24 PM, Jens Axboe wrote:
>>>> On 8/17/21 12:15 PM, Jens Axboe wrote:
>>>>> On 8/15/21 2:42 PM, Olivier Langlois wrote:
>>>>>> On Wed, 2021-08-11 at 19:55 -0600, Jens Axboe wrote:
>>>>>>> On 8/10/21 3:48 PM, Tony Battersby wrote:
>>>>>>>> On 8/5/21 9:06 AM, Olivier Langlois wrote:
>>>>>>>>> Hi all,
>>>>>>>>>
>>>>>>>>> I didn't forgot about this remaining issue and I have kept thinking
>>>>>>>>> about it on and off.
>>>>>>>>>
>>>>>>>>> I did try the following on 5.12.19:
>>>>>>>>>
>>>>>>>>> diff --git a/fs/coredump.c b/fs/coredump.c
>>>>>>>>> index 07afb5ddb1c4..614fe7a54c1a 100644
>>>>>>>>> --- a/fs/coredump.c
>>>>>>>>> +++ b/fs/coredump.c
>>>>>>>>> @@ -41,6 +41,7 @@
>>>>>>>>>  #include <linux/fs.h>
>>>>>>>>>  #include <linux/path.h>
>>>>>>>>>  #include <linux/timekeeping.h>
>>>>>>>>> +#include <linux/io_uring.h>
>>>>>>>>>  
>>>>>>>>>  #include <linux/uaccess.h>
>>>>>>>>>  #include <asm/mmu_context.h>
>>>>>>>>> @@ -625,6 +626,8 @@ void do_coredump(const kernel_siginfo_t
>>>>>>>>> *siginfo)
>>>>>>>>>                 need_suid_safe = true;
>>>>>>>>>         }
>>>>>>>>>  
>>>>>>>>> +       io_uring_files_cancel(current->files);
>>>>>>>>> +
>>>>>>>>>         retval = coredump_wait(siginfo->si_signo, &core_state);
>>>>>>>>>         if (retval < 0)
>>>>>>>>>                 goto fail_creds;
>>>>>>>>> --
>>>>>>>>> 2.32.0
>>>>>>>>>
>>>>>>>>> with my current understanding, io_uring_files_cancel is supposed to
>>>>>>>>> cancel everything that might set the TIF_NOTIFY_SIGNAL.
>>>>>>>>>
>>>>>>>>> I must report that in my testing with generating a core dump
>>>>>>>>> through a
>>>>>>>>> pipe with the modif above, I still get truncated core dumps.
>>>>>>>>>
>>>>>>>>> systemd is having a weird error:
>>>>>>>>> [ 2577.870742] systemd-coredump[4056]: Failed to get COMM: No such
>>>>>>>>> process
>>>>>>>>>
>>>>>>>>> and nothing is captured
>>>>>>>>>
>>>>>>>>> so I have replaced it with a very simple shell:
>>>>>>>>> $ cat /proc/sys/kernel/core_pattern 
>>>>>>>>>> /home/lano1106/bin/pipe_core.sh %e %p
>>>>>>>>> ~/bin $ cat pipe_core.sh 
>>>>>>>>> #!/bin/sh
>>>>>>>>>
>>>>>>>>> cat > /home/lano1106/core/core.$1.$2
>>>>>>>>>
>>>>>>>>> BFD: warning: /home/lano1106/core/core.test.10886 is truncated:
>>>>>>>>> expected core file size >= 24129536, found: 61440
>>>>>>>>>
>>>>>>>>> I conclude from my attempt that maybe io_uring_files_cancel is not
>>>>>>>>> 100%
>>>>>>>>> cleaning everything that it should clean.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>> I just ran into this problem also - coredumps from an io_uring
>>>>>>>> program
>>>>>>>> to a pipe are truncated.  But I am using kernel 5.10.57, which does
>>>>>>>> NOT
>>>>>>>> have commit 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
>>>>>>>> or
>>>>>>>> commit 06af8679449d ("coredump: Limit what can interrupt coredumps").
>>>>>>>> Kernel 5.4 works though, so I bisected the problem to commit
>>>>>>>> f38c7e3abfba ("io_uring: ensure async buffered read-retry is setup
>>>>>>>> properly") in kernel 5.9.  Note that my io_uring program uses only
>>>>>>>> async
>>>>>>>> buffered reads, which may be why this particular commit makes a
>>>>>>>> difference to my program.
>>>>>>>>
>>>>>>>> My io_uring program is a multi-purpose long-running program with many
>>>>>>>> threads.  Most threads don't use io_uring but a few of them do. 
>>>>>>>> Normally, my core dumps are piped to a program so that they can be
>>>>>>>> compressed before being written to disk, but I can also test writing
>>>>>>>> the
>>>>>>>> core dumps directly to disk.  This is what I have found:
>>>>>>>>
>>>>>>>> *) Unpatched 5.10.57: if a thread that doesn't use io_uring triggers
>>>>>>>> a
>>>>>>>> coredump, the core file is written correctly, whether it is written
>>>>>>>> to
>>>>>>>> disk or piped to a program, even if another thread is using io_uring
>>>>>>>> at
>>>>>>>> the same time.
>>>>>>>>
>>>>>>>> *) Unpatched 5.10.57: if a thread that uses io_uring triggers a
>>>>>>>> coredump, the core file is truncated, whether written directly to
>>>>>>>> disk
>>>>>>>> or piped to a program.
>>>>>>>>
>>>>>>>> *) 5.10.57+backport 06af8679449d: if a thread that uses io_uring
>>>>>>>> triggers a coredump, and the core is written directly to disk, then
>>>>>>>> it
>>>>>>>> is written correctly.
>>>>>>>>
>>>>>>>> *) 5.10.57+backport 06af8679449d: if a thread that uses io_uring
>>>>>>>> triggers a coredump, and the core is piped to a program, then it is
>>>>>>>> truncated.
>>>>>>>>
>>>>>>>> *) 5.10.57+revert f38c7e3abfba: core dumps are written correctly,
>>>>>>>> whether written directly to disk or piped to a program.
>>>>>>> That is very interesting. Like Olivier mentioned, it's not that actual
>>>>>>> commit, but rather the change of behavior implemented by it. Before
>>>>>>> that
>>>>>>> commit, we'd hit the async workers more often, whereas after we do the
>>>>>>> correct retry method where it's driven by the wakeup when the page is
>>>>>>> unlocked. This is purely speculation, but perhaps the fact that the
>>>>>>> process changes state potentially mid dump is why the dump ends up
>>>>>>> being
>>>>>>> truncated?
>>>>>>>
>>>>>>> I'd love to dive into this and try and figure it out. Absent a test
>>>>>>> case, at least the above gives me an idea of what to try out. I'll see
>>>>>>> if it makes it easier for me to create a case that does result in a
>>>>>>> truncated core dump.
>>>>>>>
>>>>>> Jens,
>>>>>>
>>>>>> When I have first encountered the issue, the very first thing that I
>>>>>> did try was to create a simple test program that would synthetize the
>>>>>> problem.
>>>>>>
>>>>>> After few time consumming failed attempts, I just gave up the idea and
>>>>>> simply settle to my prod program that showcase systematically the
>>>>>> problem every time that I kill the process with a SEGV signal.
>>>>>>
>>>>>> In a nutshell, all the program does is to issue read operations with
>>>>>> io_uring on a TCP socket on which there is a constant data stream.
>>>>>>
>>>>>> Now that I have a better understanding of what is going on, I think
>>>>>> that one way that could reproduce the problem consistently could be
>>>>>> along those lines:
>>>>>>
>>>>>> 1. Create a pipe
>>>>>> 2. fork a child
>>>>>> 3. Initiate a read operation on the pipe with io_uring from the child
>>>>>> 4. Let the parent kill its child with a core dump generating signal.
>>>>>> 5. Write something in the pipe from the parent so that the io_uring
>>>>>> read operation completes while the core dump is generated.
>>>>>>
>>>>>> I guess that I'll end up doing that if I cannot fix the issue with my
>>>>>> current setup but here is what I have attempted so far:
>>>>>>
>>>>>> 1. Call io_uring_files_cancel from do_coredump
>>>>>> 2. Same as #1 but also make sure that TIF_NOTIFY_SIGNAL is cleared on
>>>>>> returning from io_uring_files_cancel
>>>>>>
>>>>>> Those attempts didn't work but lurking in the io_uring dev mailing list
>>>>>> is starting to pay off. I thought that I did reach the bottom of the
>>>>>> rabbit hole in my journey of understanding io_uring but the recent
>>>>>> patch set sent by Hao Xu
>>>>>>
>>>>>> https://lore.kernel.org/io-uring/90fce498-968e-6812-7b6a-fdf8520ea8d9@kernel.dk/T/#t
>>>>>>
>>>>>> made me realize that I still haven't assimilated all the small io_uring
>>>>>> nuances...
>>>>>>
>>>>>> Here is my feedback. From my casual io_uring code reader point of view,
>>>>>> it is not 100% obvious what the difference is between
>>>>>> io_uring_files_cancel and io_uring_task_cancel
>>>>>>
>>>>>> It seems like io_uring_files_cancel is cancelling polls only if they
>>>>>> have the REQ_F_INFLIGHT flag set.
>>>>>>
>>>>>> I have no idea what an inflight request means and why someone would
>>>>>> want to call io_uring_files_cancel over io_uring_task_cancel.
>>>>>>
>>>>>> I guess that if I was to meditate on the question for few hours, I
>>>>>> would at some point get some illumination strike me but I believe that
>>>>>> it could be a good idea to document in the code those concepts for
>>>>>> helping casual readers...
>>>>>>
>>>>>> Bottomline, I now understand that io_uring_files_cancel does not cancel
>>>>>> all the requests. Therefore, without fully understanding what I am
>>>>>> doing, I am going to replace my call to io_uring_files_cancel from
>>>>>> do_coredump with io_uring_task_cancel and see if this finally fix the
>>>>>> issue for good.
>>>>>>
>>>>>> What I am trying to do is to cancel pending io_uring requests to make
>>>>>> sure that TIF_NOTIFY_SIGNAL isn't set while core dump is generated.
>>>>>>
>>>>>> Maybe another solution would simply be to modify __dump_emit to make it
>>>>>> resilient to TIF_NOTIFY_SIGNAL as Eric W. Biederman originally
>>>>>> suggested.
>>>>>>
>>>>>> or maybe do both...
>>>>>>
>>>>>> Not sure which approach is best. If someone has an opinion, I would be
>>>>>> curious to hear it.
>>>>> It does indeed sound like it's TIF_NOTIFY_SIGNAL that will trigger some
>>>>> signal_pending() and cause an interruption of the core dump. Just out of
>>>>> curiosity, what is your /proc/sys/kernel/core_pattern set to? If it's
>>>>> set to some piped process, can you try and set it to 'core' and see if
>>>>> that eliminates the truncation of the core dumps for your case?
>>>> And assuming that works, then I suspect this one would fix your issue
>>>> even with a piped core dump:
>>>>
>>>> diff --git a/fs/coredump.c b/fs/coredump.c
>>>> index 07afb5ddb1c4..852737a9ccbf 100644
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
>>>> @@ -603,6 +604,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
>>>>  	};
>>>>  
>>>>  	audit_core_dumps(siginfo->si_signo);
>>>> +	io_uring_task_cancel();
>>>>  
>>>>  	binfmt = mm->binfmt;
>>>>  	if (!binfmt || !binfmt->core_dump)
>>>>
>>> FYI, I tested kernel 5.10.59 + backport 06af8679449d + the patch above
>>> with my io_uring program.  The coredump locked up even when writing the
>>> core file directly to disk; the zombie process could not be killed with
>>> "kill -9".  Unfortunately I can't test with newer kernels without
>>> spending some time on it, and I am too busy with other stuff right now.
>>
>> That sounds like 5.10-stable is missing some of the cancelation
>> backports, and your setup makes the cancelation stall because of that.
>> Need to go over the 11/12/13 fixes and ensure that we've got everything
>> we need for those stable versions, particularly 5.10.
>>
>>> My io_uring program does async buffered reads
>>> (io_uring_prep_read()/io_uring_prep_readv()) from a raw disk partition
>>> (no filesystem).  One thread submits I/Os while another thread calls
>>> io_uring_wait_cqe() and processes the completions.  To trigger the
>>> coredump, I added an intentional abort() in the thread that submits I/Os
>>> after running for a second.
>>
>> OK, so that one is also using task_work for the retry based async
>> buffered reads, so it makes sense.
>>
>> Maybe a temporary work-around is to use 06af8679449d and eliminate the
>> pipe based coredump?
> 
> Another approach - don't allow TWA_SIGNAL task_work to get queued if
> PF_SIGNALED has been set on the task. This is similar to how we reject
> task_work_add() on process exit, and the callers must be able to handle
> that already.
> 
> Can you test this one on top of your 5.10-stable?
> 
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 07afb5ddb1c4..ca7c1ee44ada 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -602,6 +602,14 @@ void do_coredump(const kernel_siginfo_t *siginfo)
>  		.mm_flags = mm->flags,
>  	};
>  
> +	/*
> +	 * task_work_add() will refuse to add work after PF_SIGNALED has
> +	 * been set, ensure that we flush any pending TIF_NOTIFY_SIGNAL work
> +	 * if any was queued before that.
> +	 */
> +	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
> +		tracehook_notify_signal();
> +
>  	audit_core_dumps(siginfo->si_signo);
>  
>  	binfmt = mm->binfmt;
> diff --git a/kernel/task_work.c b/kernel/task_work.c
> index 1698fbe6f0e1..1ab28904adc4 100644
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -41,6 +41,12 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
>  		head = READ_ONCE(task->task_works);
>  		if (unlikely(head == &work_exited))
>  			return -ESRCH;
> +		/*
> +		 * TIF_NOTIFY_SIGNAL notifications will interfere with
> +		 * a core dump in progress, reject them.
> +		 */
> +		if ((task->flags & PF_SIGNALED) && notify == TWA_SIGNAL)
> +			return -ESRCH;
>  		work->next = head;
>  	} while (cmpxchg(&task->task_works, head, work) != head);
>  
> 

Olivier, I sent a 5.10 version for Nathan, any chance you can test this
one for the current kernels? Basically this one should work for 5.11+,
and the later 5.10 version is just for 5.10. I'm going to send it out
separately for review.

I do think this is the right solution, barring a tweak maybe on testing
notify == TWA_SIGNAL first before digging into the task struct. But the
principle is sound, and it'll work for other users of TWA_SIGNAL as
well. None right now as far as I can tell, but the live patching is
switching to TIF_NOTIFY_SIGNAL as well which will also cause issues with
coredumps potentially.

-- 
Jens Axboe

