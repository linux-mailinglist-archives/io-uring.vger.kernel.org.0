Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D739349B83
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 22:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhCYVU7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 17:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhCYVUc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 17:20:32 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD5DC06174A;
        Thu, 25 Mar 2021 14:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=OQZA0jbq1xbHQCEY8TUlGEMjzZL7qZb9xcn3Kc+aiKs=; b=IEcX+TJ4DVViDj3tjQpKZypFLF
        Ab9NpeluhoG74Xlf6pso8kRjaglOxb+cT+GOp/qHs+Rb1tmFTFvIGhs82LdWAOtepfPKtRAM2LXV5
        QDkDeN467HKsZV2jzhXpRttGSNLIXbwFZbaOAb1W5jJaGfYRyKguLIfD8RNXS9PidrHSVoDYbIIRu
        Kcq1Gakgi9miP7Cbd4u6g+8UktT7NdrPQzxwXPagRs050JUc7rwYw3xuZsx1kLDZnFxWYqEPEiuPt
        j6JdmFKX2OnVDgoxckR4hvZwnEULi40WSgRw0VWxMFYoqF1xauZjpeeUdfjIXRnfXj6azY0f78/vk
        ejxawll8SChMOpgrj67rZcy0YX86RCYs3UG7/25BdtdlWjM8s7CgSS/B67QWXOlNpU5zO+4YOtVZ6
        heJ/pV5hfQMlSwsx7kwmZOnhUEcAPNmQq8G+nban+uofjRSsWZKabfAioSIN0kuOQwi84k3v+g5EU
        J8SvhJjffz3lDnIFhSthA0MU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPXOx-0003up-Qv; Thu, 25 Mar 2021 21:20:23 +0000
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210325164343.807498-1-axboe@kernel.dk>
 <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
 <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
 <CAHk-=wgUcVeaKhtBgJO3TfE69miJq-krtL8r_Wf_=LBTJw6WSg@mail.gmail.com>
 <20210325204430.GE28349@redhat.com> <m1im5fymva.fsf@fess.ebiederm.org>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
Message-ID: <b639606f-cc2f-44d8-c251-163a95289e30@samba.org>
Date:   Thu, 25 Mar 2021 22:20:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <m1im5fymva.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 25.03.21 um 21:55 schrieb Eric W. Biederman:
> Oleg Nesterov <oleg@redhat.com> writes:
> 
>> On 03/25, Linus Torvalds wrote:
>>>
>>> The whole "signals are very special for IO threads" thing has caused
>>> so many problems, that maybe the solution is simply to _not_ make them
>>> special?
>>
>> Or may be IO threads should not abuse CLONE_THREAD?
>>
>> Why does create_io_thread() abuse CLONE_THREAD ?
>>
>> One reason (I think) is that this implies SIGKILL when the process exits/execs,
>> anything else?
> 
> A lot.
> 
> The io workers perform work on behave of the ordinary userspace threads.
> Some of that work is opening files.  For things like rlimits to work
> properly you need to share the signal_struct.  But odds are if you find
> anything in signal_struct (not counting signals) there will be an
> io_uring code path that can exercise it as io_uring can traverse the
> filesystem, open files and read/write files.  So io_uring can exercise
> all of proc.
> 
> Using create_io_thread with CLONE_THREAD is the least problematic way
> (including all of the signal and ptrace problems we are looking at right
> now) to implement the io worker threads.
> 
> They _really_ are threads of the process that just never execute any
> code in userspace.

So they should look like a userspace thread sitting in something like
epoll_pwait() with all signals blocked, which will never return to userspace again?

I think that would be useful, but I also think that userspace should see:
- /proc/$tidofiothread/cmdline as empty (in order to let ps and top use [iou-wrk-$tidofuserspacethread])
- /proc/$tidofiothread/exe as symlink to that not exists
- all of /proc/$tidofiothread/ shows root.root as owner and group
  and things which still allow write access to /proc/$tidofiothread/comm similar things
  with rw permissions should still disallow modifications:

For the other kernel threads e.g. "[cryptd]" I see the following:

LANG=C ls -l /proc/653 | grep rw
ls: cannot read symbolic link '/proc/653/exe': No such file or directory
-rw-r--r--  1 root root 0 Mar 25 22:09 autogroup
-rw-r--r--  1 root root 0 Mar 25 22:09 comm
-rw-r--r--  1 root root 0 Mar 25 22:09 coredump_filter
lrwxrwxrwx  1 root root 0 Mar 25 22:09 cwd -> /
lrwxrwxrwx  1 root root 0 Mar 25 22:09 exe
-rw-r--r--  1 root root 0 Mar 25 22:09 gid_map
-rw-r--r--  1 root root 0 Mar 25 22:09 loginuid
-rw-------  1 root root 0 Mar 25 22:09 mem
-rw-r--r--  1 root root 0 Mar 25 22:09 oom_adj
-rw-r--r--  1 root root 0 Mar 25 22:09 oom_score_adj
-rw-r--r--  1 root root 0 Mar 25 22:09 projid_map
lrwxrwxrwx  1 root root 0 Mar 25 22:09 root -> /
-rw-r--r--  1 root root 0 Mar 25 22:09 sched
-rw-r--r--  1 root root 0 Mar 25 22:09 setgroups
-rw-r--r--  1 root root 0 Mar 25 22:09 timens_offsets
-rw-rw-rw-  1 root root 0 Mar 25 22:09 timerslack_ns
-rw-r--r--  1 root root 0 Mar 25 22:09 uid_map

And this:

LANG=C echo "bla" > /proc/653/comm
-bash: echo: write error: Invalid argument

LANG=C echo "bla" > /proc/653/gid_map
-bash: echo: write error: Operation not permitted

Can't we do the same for iothreads regarding /proc?
Just make things read only there and empty "cmdline"/"exe"?

Maybe I'm too naive, but that what I'd assume as a userspace developer/admin.

Does at least parts of it make any sense?

metze
