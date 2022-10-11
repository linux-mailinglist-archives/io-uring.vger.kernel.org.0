Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33745FA96A
	for <lists+io-uring@lfdr.de>; Tue, 11 Oct 2022 02:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiJKAkh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 20:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJKAkg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 20:40:36 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DCE90275EF;
        Mon, 10 Oct 2022 17:40:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 59BAE8ADA77;
        Tue, 11 Oct 2022 11:40:27 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oi3Jp-000VGk-OL; Tue, 11 Oct 2022 11:40:25 +1100
Date:   Tue, 11 Oct 2022 11:40:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     viro@zeniv.linux.org.uk
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Subject: Re: [regression, v6.0-rc0, io-uring?] filesystem freeze hangs on
 sb_wait_write()
Message-ID: <20221011004025.GE2703033@dread.disaster.area>
References: <20221010050319.GC2703033@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010050319.GC2703033@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6344bb7b
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=hGzw-44bAAAA:8
        a=7-415B0cAAAA:8 a=z9nWl1cGD-KcvAKTKL8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=HvKuF1_PTVFglORKqfwH:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Oct 10, 2022 at 04:03:19PM +1100, Dave Chinner wrote:
> Hi Al,
> 
> Just tried to run fstests on XFS on a current Linus kernel at commit
> 493ffd6605b2 ("Merge tag 'ucount-rlimits-cleanups-for-v5.19' of
> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace")
> and generic/068 hangs trying to freeze the filesystem like so:
> 
> [  163.957724] task:xfs_io          state:D stack:14680 pid: 4831 ppid:  4825 flags:0x00004000
> [  163.961425] Call Trace:
> [  163.962553]  <TASK>
> [  163.963497]  __schedule+0x2f9/0xa30
> [  163.965125]  ? percpu_down_write+0x60/0x190
> [  163.966888]  schedule+0x5a/0xc0
> [  163.968206]  percpu_down_write+0xe8/0x190
> [  163.969865]  freeze_super+0x78/0x170
> [  163.971247]  __x64_sys_ioctl+0x61/0xb0
> [  163.973947]  do_syscall_64+0x35/0x80
> [  163.975119]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  163.976781] RIP: 0033:0x7ff78910bb07
> [  163.978028] RSP: 002b:00007ffefe7279b8 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
> [  163.980734] RAX: ffffffffffffffda RBX: 000055a88c183ad0 RCX: 00007ff78910bb07
> [  163.983346] RDX: 00007ffefe7279cc RSI: ffffffffc0045877 RDI: 0000000000000003
> [  163.985864] RBP: 0000000000000008 R08: 00007ff7891d5ba0 R09: 00007ff7891d5c00
> [  163.988371] R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000001
> [  163.990704] R13: 000055a88c184270 R14: 000055a88c184fc0 R15: 000055a88c184fe0
> [  163.992964]  </TASK>
> [  163.993612] task:fsstress        state:D stack:12464 pid: 4832 ppid:  4822 flags:0x00000000
> [  163.996390] Call Trace:
> [  163.997310]  <TASK>
> [  163.998076]  __schedule+0x2f9/0xa30
> [  163.999323]  ? __smp_call_single_queue+0x23/0x40
> [  164.000685]  schedule+0x5a/0xc0
> [  164.001719]  ? percpu_rwsem_wait+0x123/0x150
> [  164.003139]  percpu_rwsem_wait+0x123/0x150
> [  164.004535]  ? __percpu_rwsem_trylock.part.0+0x50/0x50
> [  164.006202]  __percpu_down_read+0x5b/0x110
> [  164.007560]  mnt_want_write+0xa0/0xd0
> [  164.008816]  do_renameat2+0x17b/0x530
> [  164.010006]  ? xfs_can_free_eofblocks+0x39/0x1e0
> [  164.011558]  ? __might_fault+0x1e/0x20
> [  164.012870]  ? strncpy_from_user+0x1e/0x160
> [  164.014236]  __x64_sys_renameat2+0x4b/0x60
> [  164.015451]  do_syscall_64+0x35/0x80
> [  164.016576]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  164.018117] RIP: 0033:0x7f3c7fe97c0f
> [  164.019124] RSP: 002b:00007fff67cf26b8 EFLAGS: 00000202 ORIG_RAX: 000000000000013c
> [  164.021202] RAX: ffffffffffffffda RBX: 00007fff67cf2980 RCX: 00007f3c7fe97c0f
> [  164.023309] RDX: 00000000ffffff9c RSI: 000055fd446825a0 RDI: 00000000ffffff9c
> [  164.025479] RBP: 00007fff67cf2990 R08: 0000000000000002 R09: 00007fff67cf2960
> [  164.027655] R10: 000055fd44682f10 R11: 0000000000000202 R12: 0000000000000079
> [  164.029721] R13: 0000000000000002 R14: 000055fd446703a0 R15: 00000000ffffffff
> [  164.031937]  </TASK>
> [  164.032675] task:fsstress        state:D stack:14224 pid: 4833 ppid:  4822 flags:0x00000000
> [  164.035086] Call Trace:
> [  164.035803]  <TASK>
> [  164.036512]  __schedule+0x2f9/0xa30
> [  164.037661]  ? __smp_call_single_queue+0x23/0x40
> [  164.039048]  schedule+0x5a/0xc0
> [  164.040076]  ? percpu_rwsem_wait+0x123/0x150
> [  164.041315]  percpu_rwsem_wait+0x123/0x150
> [  164.042458]  ? __percpu_rwsem_trylock.part.0+0x50/0x50
> [  164.043888]  __percpu_down_read+0x5b/0x110
> [  164.045097]  mnt_want_write+0xa0/0xd0
> [  164.046117]  do_fchownat+0x78/0xe0
> [  164.047060]  __x64_sys_lchown+0x1f/0x30
> [  164.048210]  do_syscall_64+0x35/0x80
> [  164.049295]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  164.050775] RIP: 0033:0x7f3c7ff2df97
> [  164.051727] RSP: 002b:00007fff67cf2838 EFLAGS: 00000202 ORIG_RAX: 000000000000005e
> [  164.053803] RAX: ffffffffffffffda RBX: 00007fff67cf29a0 RCX: 00007f3c7ff2df97
> [  164.055773] RDX: 0000000000028dd3 RSI: 0000000000022124 RDI: 000055fd44672450
> [  164.057745] RBP: 0000000000022124 R08: 0000000000000064 R09: 00007fff67cf299c
> [  164.059668] R10: fffffffffffffb8b R11: 0000000000000202 R12: 0000000000000008
> [  164.061609] R13: 0000000000028dd3 R14: 0000000000022124 R15: 000055fd44660b50
> [  164.063578]  </TASK>
> 
> Eventually the hung task timer kicks in and reports all these
> blocked threads over and over again. The read locks look like
> sb_start_write() calls, and the freeze_super() call is waiting
> here:
> 
> 
>         sb->s_writers.frozen = SB_FREEZE_WRITE;
> 	/* Release s_umount to preserve sb_start_write -> s_umount ordering */
> 	up_write(&sb->s_umount);
> >>>>>>	sb_wait_write(sb, SB_FREEZE_WRITE);
> 	down_write(&sb->s_umount);
> 
> 
> Every test vm I ran this one failed in an identical manner. They all
> failed trying to freeze on the second iteration of the {freeze;thaw}
> loop, so whatever is going on should be easily reproducable:
> 
> # cat /tmp/9061.out
> # QA output created by 068
> *** init FS
> 
> *** iteration: 0
> *** freezing $SCRATCH_MNT
> *** thawing  $SCRATCH_MNT
> 
> *** iteration: 1
> *** freezing $SCRATCH_MNT
> #
> 
> I just tested ext4 and it hangs in an identical fashion, so whatever
> is going on is not specific to XFS - it smells like a
> mnt_want_write() or sb_want_write() imbalance somewhere in the
> generic code. I haven't had time to bisect it, so this heads-up is
> all I'll have until I get can back to this tomorrow....

Bisect points to the io-uring merge commit:

$ git bisect log
git bisect start '--' 'fs/'
# status: waiting for both good and bad commits
# bad: [cdc94798820e5cdc2fc314540ee3d28e1f2fea0e] Merge remote-tracking branch 'linux-xfs/for-next' into working
git bisect bad cdc94798820e5cdc2fc314540ee3d28e1f2fea0e
# status: waiting for good commit(s), bad commit known
# good: [4fe89d07dcc2804c8b562f6c7896a45643d34b2f] Linux 6.0
git bisect good 4fe89d07dcc2804c8b562f6c7896a45643d34b2f
# good: [cbddcc4fa3443fe8cfb2ff8e210deb1f6a0eea38] btrfs: set generation before calling btrfs_clean_tree_block in btrfs_init_new_buffer
git bisect good cbddcc4fa3443fe8cfb2ff8e210deb1f6a0eea38
# good: [7f198ba7ae9874c64ffe8cd3aa60cf5dab78ce3a] Merge tag 'affs-for-6.1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
git bisect good 7f198ba7ae9874c64ffe8cd3aa60cf5dab78ce3a
# good: [9f4b9beeb9cf46c4b172fca06de5bd6831108641] Merge tag '6.1-rc-ksmbd-fixes' of git://git.samba.org/ksmbd
git bisect good 9f4b9beeb9cf46c4b172fca06de5bd6831108641
# bad: [e8bc52cb8df80c31c73c726ab58ea9746e9ff734] Merge tag 'driver-core-6.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
git bisect bad e8bc52cb8df80c31c73c726ab58ea9746e9ff734
# bad: [513389809e138ae903b6ef43c1d5d2ffaf4dca17] Merge tag 'for-6.1/block-2022-10-03' of git://git.kernel.dk/linux
git bisect bad 513389809e138ae903b6ef43c1d5d2ffaf4dca17
# good: [191249f708897fc34c78f4494f7156896aaaeca9] quota: Add more checking after reading from quota file
git bisect good 191249f708897fc34c78f4494f7156896aaaeca9
# good: [188943a15638ceb91f960e072ed7609b2d7f2a55] Merge tag 'fs-for_v6.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
git bisect good 188943a15638ceb91f960e072ed7609b2d7f2a55
# good: [118f3663fbc658e9ad6165e129076981c7b685c5] block: remove PSI accounting from the bio layer
git bisect good 118f3663fbc658e9ad6165e129076981c7b685c5
# bad: [0a78a376ef3c2f3d397df48909f00cd75f92137a] Merge tag 'for-6.1/io_uring-2022-10-03' of git://git.kernel.dk/linux
git bisect bad 0a78a376ef3c2f3d397df48909f00cd75f92137a
# good: [9f0deaa12d832f488500a5afe9b912e9b3cfc432] eventfd: guard wake_up in eventfd fs calls as well
git bisect good 9f0deaa12d832f488500a5afe9b912e9b3cfc432
# first bad commit: [0a78a376ef3c2f3d397df48909f00cd75f92137a] Merge tag 'for-6.1/io_uring-2022-10-03' of git://git.kernel.dk/linux
$

I note that there are changes to the the io_uring IO path and write
IO end accounting in the io_uring stack that was merged, and there
was no doubt about the success/failure of the reproducer at each
step. Hence I think the bisect is good, and the problem is someone
in the io-uring changes.

Jens, over to you.

The reproducer - generic/068 - is 100% reliable here, io_uring is
being exercised by fsstress in the background whilst the filesystem
is being frozen and thawed repeatedly. Some path in the io-uring
code has an unbalanced sb_start_write()/sb_end_write() pair by the
look of it....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
