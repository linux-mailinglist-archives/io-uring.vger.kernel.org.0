Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D602413C96
	for <lists+io-uring@lfdr.de>; Tue, 21 Sep 2021 23:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhIUVh2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Sep 2021 17:37:28 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:46673 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229531AbhIUVh1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Sep 2021 17:37:27 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 7D6DC1BC10F;
        Wed, 22 Sep 2021 07:35:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mSnQe-00FBH6-9q; Wed, 22 Sep 2021 07:35:52 +1000
Date:   Wed, 22 Sep 2021 07:35:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [5.15-rc1 regression] io_uring: fsstress hangs in do_coredump()
 on exit
Message-ID: <20210921213552.GZ2361455@dread.disaster.area>
References: <20210921064032.GW2361455@dread.disaster.area>
 <d9d2255c-fbac-3259-243a-2934b7ed0293@kernel.dk>
 <c97707cf-c543-52cd-5066-76b639f4f087@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c97707cf-c543-52cd-5066-76b639f4f087@kernel.dk>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=Guo9nE61AAAA:8
        a=7-415B0cAAAA:8 a=zV1LDxGQ-fZf8K7AXUgA:9 a=CjuIK1q_8ugA:10
        a=NWVoK91CQyQA:10 a=AjGcO6oz07-iQ99wixmX:22 a=Htop_0EVtpSIpAiKSa7Y:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 21, 2021 at 08:19:53AM -0600, Jens Axboe wrote:
> On 9/21/21 7:25 AM, Jens Axboe wrote:
> > On 9/21/21 12:40 AM, Dave Chinner wrote:
> >> Hi Jens,
> >>
> >> I updated all my trees from 5.14 to 5.15-rc2 this morning and
> >> immediately had problems running the recoveryloop fstest group on
> >> them. These tests have a typical pattern of "run load in the
> >> background, shutdown the filesystem, kill load, unmount and test
> >> recovery".
> >>
> >> Whent eh load includes fsstress, and it gets killed after shutdown,
> >> it hangs on exit like so:
> >>
> >> # echo w > /proc/sysrq-trigger 
> >> [  370.669482] sysrq: Show Blocked State
> >> [  370.671732] task:fsstress        state:D stack:11088 pid: 9619 ppid:  9615 flags:0x00000000
> >> [  370.675870] Call Trace:
> >> [  370.677067]  __schedule+0x310/0x9f0
> >> [  370.678564]  schedule+0x67/0xe0
> >> [  370.679545]  schedule_timeout+0x114/0x160
> >> [  370.682002]  __wait_for_common+0xc0/0x160
> >> [  370.684274]  wait_for_completion+0x24/0x30
> >> [  370.685471]  do_coredump+0x202/0x1150
> >> [  370.690270]  get_signal+0x4c2/0x900
> >> [  370.691305]  arch_do_signal_or_restart+0x106/0x7a0
> >> [  370.693888]  exit_to_user_mode_prepare+0xfb/0x1d0
> >> [  370.695241]  syscall_exit_to_user_mode+0x17/0x40
> >> [  370.696572]  do_syscall_64+0x42/0x80
> >> [  370.697620]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>
> >> It's 100% reproducable on one of my test machines, but only one of
> >> them. That one machine is running fstests on pmem, so it has
> >> synchronous storage. Every other test machine using normal async
> >> storage (nvme, iscsi, etc) and none of them are hanging.
> >>
> >> A quick troll of the commit history between 5.14 and 5.15-rc2
> >> indicates a couple of potential candidates. The 5th kernel build
> >> (instead of ~16 for a bisect) told me that commit 15e20db2e0ce
> >> ("io-wq: only exit on fatal signals") is the cause of the
> >> regression. I've confirmed that this is the first commit where the
> >> problem shows up.
> > 
> > Thanks for the report Dave, I'll take a look. Can you elaborate on
> > exactly what is being run? And when killed, it's a non-fatal signal?

It's whatever kill/killall sends by default.  Typical behaviour that
causes a hang is something like:

$FSSTRESS_PROG -n10000000 -p $PROCS -d $load_dir >> $seqres.full 2>&1 &
....
sleep 5
_scratch_shutdown
$KILLALL_PROG -q $FSSTRESS_PROG
wait

_shutdown_scratch is typically just an 'xfs_io -rx -c "shutdown"
/mnt/scratch' command that shuts down the filesystem. Other tests in
the recoveryloop group use DM targets to fail IO that trigger a
shutdown, others inject errors that trigger shutdowns, etc. But the
result is that all hang waiting for fsstress processes that have
been using io_uring to exit.

Just run fstests with "./check -g recoveryloop" - there's only a
handful of tests and it only takes about 5 minutes to run them all
on a fake DRAM based pmem device..

> Can you try with this patch?
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index b5fd015268d7..1e55a0a2a217 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -586,7 +586,8 @@ static int io_wqe_worker(void *data)
>  
>  			if (!get_signal(&ksig))
>  				continue;
> -			if (fatal_signal_pending(current))
> +			if (fatal_signal_pending(current) ||
> +			    signal_group_exit(current->signal)) {
>  				break;
>  			continue;
>  		}

Cleaned up so it compiles and the tests run properly again. But
playing whack-a-mole with signals seems kinda fragile. I was pointed
to this patchset by another dev on #xfs overnight who saw the same
hangs that also fixed the hang:

https://lore.kernel.org/lkml/cover.1629655338.git.olivier@trillion01.com/

It was posted about a month ago and I don't see any response to it
on the lists...

Cheers,

Dave,
-- 
Dave Chinner
david@fromorbit.com
