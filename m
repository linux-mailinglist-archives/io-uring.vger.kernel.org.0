Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A61412F26
	for <lists+io-uring@lfdr.de>; Tue, 21 Sep 2021 09:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhIUHQo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Sep 2021 03:16:44 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:49206 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230026AbhIUHQk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Sep 2021 03:16:40 -0400
X-Greylist: delayed 2077 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2021 03:16:40 EDT
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 93C201009B41;
        Tue, 21 Sep 2021 16:40:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mSZSC-00EwYv-Bt; Tue, 21 Sep 2021 16:40:32 +1000
Date:   Tue, 21 Sep 2021 16:40:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [5.15-rc1 regression] io_uring: fsstress hangs in do_coredump() on
 exit
Message-ID: <20210921064032.GW2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=7-415B0cAAAA:8
        a=BnQZExpEWCbP54y3Tb4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

I updated all my trees from 5.14 to 5.15-rc2 this morning and
immediately had problems running the recoveryloop fstest group on
them. These tests have a typical pattern of "run load in the
background, shutdown the filesystem, kill load, unmount and test
recovery".

Whent eh load includes fsstress, and it gets killed after shutdown,
it hangs on exit like so:

# echo w > /proc/sysrq-trigger 
[  370.669482] sysrq: Show Blocked State
[  370.671732] task:fsstress        state:D stack:11088 pid: 9619 ppid:  9615 flags:0x00000000
[  370.675870] Call Trace:
[  370.677067]  __schedule+0x310/0x9f0
[  370.678564]  schedule+0x67/0xe0
[  370.679545]  schedule_timeout+0x114/0x160
[  370.682002]  __wait_for_common+0xc0/0x160
[  370.684274]  wait_for_completion+0x24/0x30
[  370.685471]  do_coredump+0x202/0x1150
[  370.690270]  get_signal+0x4c2/0x900
[  370.691305]  arch_do_signal_or_restart+0x106/0x7a0
[  370.693888]  exit_to_user_mode_prepare+0xfb/0x1d0
[  370.695241]  syscall_exit_to_user_mode+0x17/0x40
[  370.696572]  do_syscall_64+0x42/0x80
[  370.697620]  entry_SYSCALL_64_after_hwframe+0x44/0xae

It's 100% reproducable on one of my test machines, but only one of
them. That one machine is running fstests on pmem, so it has
synchronous storage. Every other test machine using normal async
storage (nvme, iscsi, etc) and none of them are hanging.

A quick troll of the commit history between 5.14 and 5.15-rc2
indicates a couple of potential candidates. The 5th kernel build
(instead of ~16 for a bisect) told me that commit 15e20db2e0ce
("io-wq: only exit on fatal signals") is the cause of the
regression. I've confirmed that this is the first commit where the
problem shows up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
