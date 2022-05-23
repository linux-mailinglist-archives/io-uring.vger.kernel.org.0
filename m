Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B24530DD5
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 12:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiEWJqW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 05:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbiEWJoT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 05:44:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B3426120;
        Mon, 23 May 2022 02:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A9A0B80EB4;
        Mon, 23 May 2022 09:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A5CC385A9;
        Mon, 23 May 2022 09:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653299051;
        bh=TgGdvEK04PZs/jUtUxweLcxD0AcWsHTTlwIZMTMm1Cs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vEbU+D09oKvoJS2kIR+3majqe522hQvANvJVB7PWHUaGnsBnsY94lY+BeBeMTP5C7
         6Djp88WwGX2yslE2KNf8ZZz/aZ/2LfQcnbVN0jVFTHca4xARUXNXfD6pRoqNgZiOr6
         Ujh9zULYx8OpwyEvXNKrkTNpyIR0JRIba9NhNRSOKJvtwc7hqRi+K6/1zashD3/RDe
         /tZlonbr+Rg3PNJZuN+kdRHOBcWZvyHFINfLWhLRn5Bynulern81wJi99+24qUV250
         za3qlYfievawuIH7zSk5PnALw9iy3BktEmDPYdJ9bgly7cwtalnCOvtvvY0qkDWxyy
         6A9zewAMUBhig==
Date:   Mon, 23 May 2022 11:44:00 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 00/13] rename & split tests
Message-ID: <20220523094400.ljvhog3tfbxgvhri@wittgenstein>
References: <20220512165250.450989-1-brauner@kernel.org>
 <20220521231350.GY2306852@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220521231350.GY2306852@dread.disaster.area>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, May 22, 2022 at 09:13:50AM +1000, Dave Chinner wrote:
> [cc io_uring]
> 
> On Thu, May 12, 2022 at 06:52:37PM +0200, Christian Brauner wrote:
> > From: "Christian Brauner (Microsoft)" <brauner@kernel.org>
> > 
> > Hey everyone,
> > 
> > Please note that this patch series contains patches that will be
> > rejected by the fstests mailing list because of the amount of changes
> > they contain. So tools like b4 will not be able to find the whole patch
> > series on a mailing list. In case it's helpful I've added the
> > "fstests.vfstest.for-next" tag which can be pulled. Otherwise it's
> > possible to simply use the patch series as it appears in your inbox.
> > 
> > All vfstests pass:
> 
> [...]
> 
> > #### xfs ####
> > ubuntu@imp1-vm:~/src/git/xfstests$ sudo ./check -g idmapped
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 imp1-vm 5.18.0-rc4-fs-mnt-hold-writers-8a2e2350494f #107 SMP PREEMPT_DYNAMIC Mon May 9 12:12:34 UTC 2022
> > MKFS_OPTIONS  -- -f /dev/sda4
> > MOUNT_OPTIONS -- /dev/sda4 /mnt/scratch
> > 
> > generic/633 58s ...  58s
> > generic/644 62s ...  60s
> > generic/645 161s ...  161s
> > generic/656 62s ...  63s
> > xfs/152 133s ...  133s
> > xfs/153 94s ...  92s
> > Ran: generic/633 generic/644 generic/645 generic/656 xfs/152 xfs/153
> > Passed all 6 tests
> 
> I'm not sure if it's this series that has introduced a test bug or
> triggered a latent issue in the kernel, but I've started seeing
> generic/633 throw audit subsystem warnings on a single test machine
> as of late Friday:
> 
> [ 7285.015888] WARNING: CPU: 3 PID: 2147118 at kernel/auditsc.c:2035 __audit_syscall_entry+0x113/0x140
> [ 7285.019973] Modules linked in:
> [ 7285.021281] CPU: 3 PID: 2147118 Comm: vfstest Not tainted 5.18.0-rc7-dgc+ #1250
> [ 7285.024341] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> [ 7285.027782] RIP: 0010:__audit_syscall_entry+0x113/0x140
> [ 7285.029923] Code: 24 e8 c1 6b ff ff 48 8b 34 24 85 c0 48 8b 54 24 08 48 8b 4c 24 10 4c 8b 44 24 18 0f 84 72 ff ff ff 48 83 c4 20 5b 5d 41 5c c3 <0f> 0b 85 c0 75 14 48 83 c4 20 48 c7 c7 70 45 7f 82 5b 5d 41 5c e9
> [ 7285.037563] RSP: 0018:ffffc900012f7ed0 EFLAGS: 00010202
> [ 7285.039748] RAX: 0000000000000000 RBX: ffff8880aaf18800 RCX: 000000000000003c
> [ 7285.043126] RDX: 00000000000000e7 RSI: 0000000000000000 RDI: ffff888102104f00
> [ 7285.046120] RBP: 00000000000000e7 R08: fffffffffffffe2c R09: 0000000000000002
> [ 7285.049108] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
> [ 7285.052058] R13: ffffc900012f7f58 R14: 00000000000000e7 R15: 0000000000000000
> [ 7285.055030] FS:  00007f7906d6c740(0000) GS:ffff88813bd80000(0000) knlGS:0000000000000000
> [ 7285.058396] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 7285.060788] CR2: 00007f3ffa7e9bb8 CR3: 000000010bb00000 CR4: 00000000000006e0
> [ 7285.063735] Call Trace:
> [ 7285.064796]  <TASK>
> [ 7285.065759]  syscall_trace_enter.constprop.0+0x122/0x1a0
> [ 7285.067978]  do_syscall_64+0x16/0x80
> [ 7285.069497]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 7285.071590] RIP: 0033:0x7f7906e35f49
> [ 7285.073118] Code: 00 4c 8b 05 29 6f 10 00 be e7 00 00 00 ba 3c 00 00 00 eb 12 0f 1f 44 00 00 89 d0 0f 05 48 3d 00 f0 ff ff 77 1c f4 89 f0 0f 05 <48> 3d 00 f0 ff ff 76 e7 f7 d8 64 41 89 00 eb df 0f 1f 80 00 00 00
> [ 7285.078021] RSP: 002b:00007ffeee52db88 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> [ 7285.079995] RAX: ffffffffffffffda RBX: 00007f7906f39920 RCX: 00007f7906e35f49
> [ 7285.081869] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> [ 7285.083729] RBP: 0000000000000000 R08: ffffffffffffff88 R09: 0000000000000001
> [ 7285.085594] R10: fffffffffffffe2c R11: 0000000000000246 R12: 00007f7906f39920
> [ 7285.087457] R13: 0000000000000001 R14: 00007f7906f3ee28 R15: 0000000000000000
> [ 7285.089320]  </TASK>
> [ 7285.089949] ---[ end trace 0000000000000000 ]---
> [ 7285.091182] audit_panic: 22 callbacks suppressed
> [ 7285.091185] audit: unrecoverable error in audit_syscall_entry()
> 
> Adn faddr_to_line tells me it is this:
> 
> void __audit_syscall_entry(int major, unsigned long a1, unsigned long a2,
>                            unsigned long a3, unsigned long a4)
> {
>         struct audit_context *context = audit_context();
>         enum audit_state     state;
> 
>         if (!audit_enabled || !context)
>                 return;
> 
> >>>>>>  WARN_ON(context->context != AUDIT_CTX_UNUSED);  <<<<<<
>         WARN_ON(context->name_count);
>         if (context->context != AUDIT_CTX_UNUSED || context->name_count) {
>                 audit_panic("unrecoverable error in audit_syscall_entry()");
>                 return;
>         }
> .....
> 
> I have no clue how the audit subsystem works, I don't even know how
> to enable it, and I've never seen audit messages on the console of
> this test machine. I have other test machines that have audit
> enabled, and they do not dump warnings like this - the only thing I
> see in the logs for those machines is this:
> 
>  run xfstest generic/633
>  process 'vfstest' launched '/dev/fd/4/file1' with NULL argv: empty string added
>  XFS (pmem0): Unmounting Filesystem
>  XFS (pmem0): Mounting V5 Filesystem
>  XFS (pmem0): Ending clean mount
>  run xfstest generic/634
> 
> That's waht I was seeing from this test machine earlier in the week,
> too - I've been running 5.18-rc7 as the base kernel all week - so
> I'm not sure .....
> 
> Oooooohhhh.
> 
> /* The per-task audit context. */
> struct audit_context {
>         int                 dummy;      /* must be the first element */
>         enum {
>                 AUDIT_CTX_UNUSED,       /* audit_context is currently unused */
>                 AUDIT_CTX_SYSCALL,      /* in use by syscall */
>                 AUDIT_CTX_URING,        /* in use by io_uring */
>         } context;
> ....
> 
> And that reminded me of something. I commented on #xfs on Friday
> afternoon:
> 
> [20/5/22 15:04] <dchinner> so of the 3.5 hours run time on the machine that jsut completed, it looks like about a dozen tests are responsible for an hour of that runtime...
> [20/5/22 15:05] <dchinner> but it was a clean run with no failures in 1055 tests run.
> [20/5/22 15:06] <dchinner> But there's some WTFs like this in it:
> [20/5/22 15:06] <dchinner> generic/678     [not run] kernel does not support IO_URING
> [20/5/22 15:08] <dchinner> yet the same kernel on a different machine:
> [20/5/22 15:08] <dchinner> generic/678 11s ...  3s
> [20/5/22 15:08] <dchinner> and they have the same userspace, too....
> 
> Yeah, the machine that complained about "kernel does not support
> IO_URING" is the one that is throwing these warnings now. It wasn't
> that the kernel didn't support io-uring, it was that the machine was
> missing the liburing-dev library. I installed it and rebuilt
> fstests. These audit failures co-incide with the first test runs
> with io-uring enabled. And vfstest uses io_uring if fstests enables
> it.
> 
> Hence this now smells like a pre-existing issue -  either a test bug
> or an io_uring task audit context leak. Anyone got any ideas?

I see this is unrelated to the test thankfully and can be considered
fixed afaict.

Thanks for taking care of this everyone!
Christian
