Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C16349C02
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 22:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhCYV5t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 17:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhCYV5Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 17:57:25 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A00C06174A;
        Thu, 25 Mar 2021 14:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=IDpAs9wEl1yEu8zpBijztkagelVIfxWT3XTUCb+GvZA=; b=LFs0bI2j6o3XNd1CtGZojaNtxh
        a0sFS7srBfCsOY6wcgbdofnuLjMjcf1kvKGqOl5K3Src2b2s2lazSuIkR5JflMuxglKCsIktAgQR7
        d/ei1mJsy8nrAS/inKZIi9/ejskDqscdLcXBsrxeihmPL0gwrdd9SmXpiHlvM7faQu6yIGHCjCo9R
        n8HZxE7gMayBVkXr8b7LlE9YVwe3S69ZqZ90PgooSU+8W5SArSRbR09XJeFaq36JCTVzB6u8jc0Nq
        bwsBrHUgzrj1kmDGcqAGrzDuOg00JVAvSUHKaL1R7fDOSOH024cH85gLsHqmPw9xTk0e5veRpa7Kz
        K7ncD2GLWgphXBNPwv313ETrVU6rnhuEl12KWudjVIWiDvITH6jpm6B3PfrTcMcb81YbiheotzsK1
        KzqxmxK5vFwKHJz4DgrkqeimZ8etY4P53bIixFLQUj9w1v8XJePF1Iu07432laCQF5BOGc8oRQARE
        S6Yuaws1FSRaUHT97vuSQdos;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPXyk-000496-MY; Thu, 25 Mar 2021 21:57:22 +0000
To:     Jens Axboe <axboe@kernel.dk>,
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
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
Message-ID: <5563d244-52c0-dafb-5839-e84990340765@samba.org>
Date:   Thu, 25 Mar 2021 22:57:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f9bc0bac-2ad9-827e-7360-099e1e310df5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 25.03.21 um 22:44 schrieb Jens Axboe:
> On 3/25/21 2:40 PM, Jens Axboe wrote:
>> On 3/25/21 2:12 PM, Linus Torvalds wrote:
>>> On Thu, Mar 25, 2021 at 12:42 PM Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>>
>>>> On Thu, Mar 25, 2021 at 12:38 PM Linus Torvalds
>>>> <torvalds@linux-foundation.org> wrote:
>>>>>
>>>>> I don't know what the gdb logic is, but maybe there's some other
>>>>> option that makes gdb not react to them?
>>>>
>>>> .. maybe we could have a different name for them under the task/
>>>> subdirectory, for example (not  just the pid)? Although that probably
>>>> messes up 'ps' too..
>>>
>>> Actually, maybe the right model is to simply make all the io threads
>>> take signals, and get rid of all the special cases.
>>>
>>> Sure, the signals will never be delivered to user space, but if we
>>>
>>>  - just made the thread loop do "get_signal()" when there are pending signals
>>>
>>>  - allowed ptrace_attach on them
>>>
>>> they'd look pretty much like regular threads that just never do the
>>> user-space part of signal handling.
>>>
>>> The whole "signals are very special for IO threads" thing has caused
>>> so many problems, that maybe the solution is simply to _not_ make them
>>> special?
>>
>> Just to wrap up the previous one, yes it broke all sorts of things to
>> make the 'tid' directory different. They just end up being hidden anyway
>> through that, for both ps and top.
>>
>> Yes, I do think that maybe it's better to just embrace maybe just
>> embrace the signals, and have everything just work by default. It's
>> better than continually trying to make the threads special. I'll see
>> if there are some demons lurking down that path.
> 
> In the spirit of "let's just try it", I ran with the below patch. With
> that, I can gdb attach just fine to a test case that creates an io_uring
> and a regular thread with pthread_create(). The regular thread uses
> the ring, so you end up with two iou-mgr threads. Attach:
> 
> [root@archlinux ~]# gdb -p 360
> [snip gdb noise]
> Attaching to process 360
> [New LWP 361]
> [New LWP 362]
> [New LWP 363]
> 
> warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386
> 
> warning: Architecture rejected target-supplied description
> Error while reading shared library symbols for /usr/lib/libpthread.so.0:
> Cannot find user-level thread for LWP 363: generic error
> 0x00007f7aa526e125 in clock_nanosleep@GLIBC_2.2.5 () from /usr/lib/libc.so.6
> (gdb) info threads
>   Id   Target Id             Frame 
> * 1    LWP 360 "io_uring"    0x00007f7aa526e125 in clock_nanosleep@GLIBC_2.2.5 ()
>    from /usr/lib/libc.so.6
>   2    LWP 361 "iou-mgr-360" 0x0000000000000000 in ?? ()
>   3    LWP 362 "io_uring"    0x00007f7aa52a0a9d in syscall () from /usr/lib/libc.so.6
>   4    LWP 363 "iou-mgr-362" 0x0000000000000000 in ?? ()
> (gdb) thread 2
> [Switching to thread 2 (LWP 361)]
> #0  0x0000000000000000 in ?? ()
> (gdb) bt
> #0  0x0000000000000000 in ?? ()
> Backtrace stopped: Cannot access memory at address 0x0
> (gdb) cont
> Continuing.
> ^C
> Thread 1 "io_uring" received signal SIGINT, Interrupt.
> [Switching to LWP 360]
> 0x00007f7aa526e125 in clock_nanosleep@GLIBC_2.2.5 () from /usr/lib/libc.so.6
> (gdb) q
> A debugging session is active.
> 
> 	Inferior 1 [process 360] will be detached.
> 
> Quit anyway? (y or n) y
> Detaching from program: /root/git/fio/t/io_uring, process 360
> [Inferior 1 (process 360) detached]
> 
> The iou-mgr-x threads are stopped just fine, gdb obviously can't get any
> real info out of them. But it works... Regular test cases work fine too,
> just a sanity check. Didn't expect them not to.

I guess that's basically what I tried to describe when I said they should
look like a userspace process that is blocked in a syscall forever.

> Only thing that I dislike a bit, but I guess that's just a Linuxism, is
> that if can now kill an io_uring owning task by sending a signal to one
> of its IO thread workers.

Can't we just only allow SIGSTOP, which will be only delivered to
the iothread itself? And also SIGKILL should not be allowed from userspace.

And /proc/$iothread/ should be read only and owned by root with
"cmdline" and "exe" being empty.

Thanks!
metze
