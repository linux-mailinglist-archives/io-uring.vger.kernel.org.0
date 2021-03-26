Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030BB349D85
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 01:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhCZAL7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 20:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhCZALh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 20:11:37 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F748C06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:11:37 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d8so46669plh.11
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q9S3+fI2D+2mI26/8bWMBz4t+NgZcdhnEUCCGVDX3aM=;
        b=SB5lUVPY9Bbxm+ta78VVnlcXkTJ1IfQQ5vAx5lk+EnCtO3Cvs7s8v9s5R2kS8IO2X3
         KHQ+OAo9bhSAQygsOVUxKn8GOxYZ5CZ+jYxSMZZ9L8fkH6qLVZsqozrVDfGckp3kmFqj
         nYts3fBEuKqQbn7bOT2RIE2f+A+I8mgFtN9kM9xaGbId2vGp/jlhikwRO6wiByDC2J1B
         BaYb14zKzzl+xVkJYIog4vbhndRQ0L73ZZ7q02Z3WyUx2rbVWxVO0+w3hYk6ULko2vox
         PI8OLHlgKOt367GzKSsqk2STrRV96XcINxhKOBThXu8/Hps4O3iYBeBDZzC3MzMVjiII
         KSCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q9S3+fI2D+2mI26/8bWMBz4t+NgZcdhnEUCCGVDX3aM=;
        b=Cgo9A2PLzRox4J0scd5B/K+VTYbniSRS4NFBHBrEsVsgmeMrc7MeLHyb66inv4oeuf
         qlUuPXM4zKd0pR+WGA7OwcrhM4WQD6NPs/KZkb7n6GQecAiVWlZNl3SJS2O3Ni4tZbUW
         k057Lh3jVzsSlxSVktoKZzUxMvhvLb98nMeDSddw14WR/ng+YSdMf8jr3z1rH41dFWRg
         svpNrqTHJTZ5vF9lh+YX/xDOsXBoP+a4Zdu4n4bq7LdZ3w0zF5JiafKpyQVxbocT+pKe
         Biaro32YoTvszTBNU/8kz0jFYy7XA6EerN5lwKwpoNo+YJVQmXis/K/0/DMKXeH4L5k4
         akOA==
X-Gm-Message-State: AOAM5330QqIDYP6DOp6hpAcJRt0YBwYYdTRsiiZFfhPsoSBa6RklkWLo
        EpAd+uHOnI/yiFCogMiWRybVYA==
X-Google-Smtp-Source: ABdhPJya0Kwkqr5Wt3+Q/EXDZ7yyn0sEDLVLnYX2MOK/IVmQTi1zmXp/rUZNotJv1r+3jKwDuevcSA==
X-Received: by 2002:a17:90a:2d88:: with SMTP id p8mr11301109pjd.159.1616717496476;
        Thu, 25 Mar 2021 17:11:36 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q10sm6668760pfc.190.2021.03.25.17.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 17:11:36 -0700 (PDT)
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
To:     Stefan Metzmacher <metze@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <20210325164343.807498-1-axboe@kernel.dk>
 <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
 <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
 <CAHk-=wgUcVeaKhtBgJO3TfE69miJq-krtL8r_Wf_=LBTJw6WSg@mail.gmail.com>
 <ad21da2b-01ea-e77c-70b2-0401059e322b@kernel.dk>
 <f9bc0bac-2ad9-827e-7360-099e1e310df5@kernel.dk>
 <5563d244-52c0-dafb-5839-e84990340765@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6a2c4fe3-a019-2744-2e17-34b6325967d7@kernel.dk>
Date:   Thu, 25 Mar 2021 18:11:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5563d244-52c0-dafb-5839-e84990340765@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/21 3:57 PM, Stefan Metzmacher wrote:
> 
> Am 25.03.21 um 22:44 schrieb Jens Axboe:
>> On 3/25/21 2:40 PM, Jens Axboe wrote:
>>> On 3/25/21 2:12 PM, Linus Torvalds wrote:
>>>> On Thu, Mar 25, 2021 at 12:42 PM Linus Torvalds
>>>> <torvalds@linux-foundation.org> wrote:
>>>>>
>>>>> On Thu, Mar 25, 2021 at 12:38 PM Linus Torvalds
>>>>> <torvalds@linux-foundation.org> wrote:
>>>>>>
>>>>>> I don't know what the gdb logic is, but maybe there's some other
>>>>>> option that makes gdb not react to them?
>>>>>
>>>>> .. maybe we could have a different name for them under the task/
>>>>> subdirectory, for example (not  just the pid)? Although that probably
>>>>> messes up 'ps' too..
>>>>
>>>> Actually, maybe the right model is to simply make all the io threads
>>>> take signals, and get rid of all the special cases.
>>>>
>>>> Sure, the signals will never be delivered to user space, but if we
>>>>
>>>>  - just made the thread loop do "get_signal()" when there are pending signals
>>>>
>>>>  - allowed ptrace_attach on them
>>>>
>>>> they'd look pretty much like regular threads that just never do the
>>>> user-space part of signal handling.
>>>>
>>>> The whole "signals are very special for IO threads" thing has caused
>>>> so many problems, that maybe the solution is simply to _not_ make them
>>>> special?
>>>
>>> Just to wrap up the previous one, yes it broke all sorts of things to
>>> make the 'tid' directory different. They just end up being hidden anyway
>>> through that, for both ps and top.
>>>
>>> Yes, I do think that maybe it's better to just embrace maybe just
>>> embrace the signals, and have everything just work by default. It's
>>> better than continually trying to make the threads special. I'll see
>>> if there are some demons lurking down that path.
>>
>> In the spirit of "let's just try it", I ran with the below patch. With
>> that, I can gdb attach just fine to a test case that creates an io_uring
>> and a regular thread with pthread_create(). The regular thread uses
>> the ring, so you end up with two iou-mgr threads. Attach:
>>
>> [root@archlinux ~]# gdb -p 360
>> [snip gdb noise]
>> Attaching to process 360
>> [New LWP 361]
>> [New LWP 362]
>> [New LWP 363]
>>
>> warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386
>>
>> warning: Architecture rejected target-supplied description
>> Error while reading shared library symbols for /usr/lib/libpthread.so.0:
>> Cannot find user-level thread for LWP 363: generic error
>> 0x00007f7aa526e125 in clock_nanosleep@GLIBC_2.2.5 () from /usr/lib/libc.so.6
>> (gdb) info threads
>>   Id   Target Id             Frame 
>> * 1    LWP 360 "io_uring"    0x00007f7aa526e125 in clock_nanosleep@GLIBC_2.2.5 ()
>>    from /usr/lib/libc.so.6
>>   2    LWP 361 "iou-mgr-360" 0x0000000000000000 in ?? ()
>>   3    LWP 362 "io_uring"    0x00007f7aa52a0a9d in syscall () from /usr/lib/libc.so.6
>>   4    LWP 363 "iou-mgr-362" 0x0000000000000000 in ?? ()
>> (gdb) thread 2
>> [Switching to thread 2 (LWP 361)]
>> #0  0x0000000000000000 in ?? ()
>> (gdb) bt
>> #0  0x0000000000000000 in ?? ()
>> Backtrace stopped: Cannot access memory at address 0x0
>> (gdb) cont
>> Continuing.
>> ^C
>> Thread 1 "io_uring" received signal SIGINT, Interrupt.
>> [Switching to LWP 360]
>> 0x00007f7aa526e125 in clock_nanosleep@GLIBC_2.2.5 () from /usr/lib/libc.so.6
>> (gdb) q
>> A debugging session is active.
>>
>> 	Inferior 1 [process 360] will be detached.
>>
>> Quit anyway? (y or n) y
>> Detaching from program: /root/git/fio/t/io_uring, process 360
>> [Inferior 1 (process 360) detached]
>>
>> The iou-mgr-x threads are stopped just fine, gdb obviously can't get any
>> real info out of them. But it works... Regular test cases work fine too,
>> just a sanity check. Didn't expect them not to.
> 
> I guess that's basically what I tried to describe when I said they
> should look like a userspace process that is blocked in a syscall
> forever.

Right, that's almost what they look like, in practice that is what they
look like.

>> Only thing that I dislike a bit, but I guess that's just a Linuxism, is
>> that if can now kill an io_uring owning task by sending a signal to one
>> of its IO thread workers.
> 
> Can't we just only allow SIGSTOP, which will be only delivered to
> the iothread itself? And also SIGKILL should not be allowed from userspace.

I don't think we can sanely block them, and we to cleanup and teardown
normally regardless of who gets the signal (owner or one of the
threads). So I'm not _too_ hung up on the "io thread gets signal goes to
owner" as that is what happens with normal threads too, though I would
prefer if that wasn't the case. But overall I feel better just embracing
the thread model, rather than having something that kinda sorta looks
like a thread, but differs in odd ways.

> And /proc/$iothread/ should be read only and owned by root with
> "cmdline" and "exe" being empty.

I know you brought this one up as part of your series, not sure I get
why you want it owned by root and read-only? cmdline and exe, yeah those
could be hidden, but is there really any point?

Maybe I'm missing something here, if so, do clue me in!

-- 
Jens Axboe

