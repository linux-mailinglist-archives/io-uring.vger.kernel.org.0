Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641E75892C6
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 21:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238680AbiHCT3r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 15:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238690AbiHCT31 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 15:29:27 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465995B797
        for <io-uring@vger.kernel.org>; Wed,  3 Aug 2022 12:28:31 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id cb12-20020a056830618c00b00616b871cef3so12825554otb.5
        for <io-uring@vger.kernel.org>; Wed, 03 Aug 2022 12:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Ma+GO/hD9k5uL8nV2uPuPKZ6xfDbN3leVgMyW3x8EzM=;
        b=cU5Dz45nQxDCY+ew1N6b4BGoTz0YJ+6Hx1M/ps70yMybGUMYiHzX2ttWRTuko4dIVa
         We1IACBgxYr5wdas0wvD+oW2Da36FiWIQreawSglwLlOBQg6MR3XKvqelHsmvz/FHI7i
         PbvYADYL2xyD/g/O6E9fB+zwJgzjCAemvWo+1MVNg42j/mCzVervTproAE8q2cSRy8sj
         H6+QrGhUX5qsExHVuEXlggmxZQ5KpVFu5CzJ8dJQ9K+yHVojKkQc7PvEIWV1RAaGCO0i
         2b3Gn/lJ2z0l7w3DC6msInIGFEUXCNrx9AeOAQQd8fBPdb4mtIDRC8XjbMMXcN+LIgWz
         gLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Ma+GO/hD9k5uL8nV2uPuPKZ6xfDbN3leVgMyW3x8EzM=;
        b=wPhBVE/obE5Gxylrs175FVEpuNeixZifJ5ZBILfOPUFKbzpdQYan1ulusaNVDUim14
         kEFINt36EQOVc/Z1BpbQf2vn5ayxZX6Gw/BJTZWYkNdjpgEoDtpHgvG5tCe+XAdt9CEh
         P/akr2Xd86FY4H+OQybe1jLpYRXG2Oc7E5iP4CrIuBA1YUe+IIYHhW8cllOBqkqA0QB4
         wn5aHN+11S9ZveE7vMNHta2DOl+ITnQqrFxqlJeIV732A54Pw/vWwS9ep3/VjP8FycL7
         g3PAZSislXIEqD9LZL6p7LxP1pdc9jjJ9BaomZkW7ZE3uOxTJtoB8MtFew24yWytt8v5
         qypg==
X-Gm-Message-State: ACgBeo11W+oRXYq1gcfD8y/jnP1wrbhWvWGGuXYTnpF2O0wuvHExbTF1
        fZbhdkwFup8CZ0leetiCP59cBFqcq/2InBlrT0oB
X-Google-Smtp-Source: AA6agR65YbUsom0l8+z3HcAytfFP/DS8Hy63Nzjz/gN2pAojoVadBWhpqA+NfhwSgMPzKKw8l438M5lfkaYbM/gHSmU=
X-Received: by 2002:a05:6830:33e4:b0:636:732d:5a48 with SMTP id
 i4-20020a05683033e400b00636732d5a48mr2750250otu.69.1659554910465; Wed, 03 Aug
 2022 12:28:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220803050230.30152-1-yepeilin.cs@gmail.com> <CAHC9VhRXypjNgDAwdARZz-md_DaSTs+9BpMik8AzWojG7ChexA@mail.gmail.com>
In-Reply-To: <CAHC9VhRXypjNgDAwdARZz-md_DaSTs+9BpMik8AzWojG7ChexA@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 3 Aug 2022 15:28:19 -0400
Message-ID: <CAHC9VhRYGgCLiWx5LCoqgTj_RW_iQRLrzivWci7_UneN_=rwmw@mail.gmail.com>
Subject: Re: [PATCH] audit, io_uring, io-wq: Fix memory leak in io_sq_thread()
 and io_wqe_worker()
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Paris <eparis@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 3, 2022 at 9:16 AM Paul Moore <paul@paul-moore.com> wrote:
> On Wed, Aug 3, 2022 at 1:03 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> >
> > Currently @audit_context is allocated twice for io_uring workers:
> >
> >   1. copy_process() calls audit_alloc();
> >   2. io_sq_thread() or io_wqe_worker() calls audit_alloc_kernel() (which
> >      is effectively audit_alloc()) and overwrites @audit_context,
> >      causing:
> >
> >   BUG: memory leak
> >   unreferenced object 0xffff888144547400 (size 1024):
> > <...>
> >     hex dump (first 32 bytes):
> >       00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
> >       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     backtrace:
> >       [<ffffffff8135cfc3>] audit_alloc+0x133/0x210
> >       [<ffffffff81239e63>] copy_process+0xcd3/0x2340
> >       [<ffffffff8123b5f3>] create_io_thread+0x63/0x90
> >       [<ffffffff81686604>] create_io_worker+0xb4/0x230
> >       [<ffffffff81686f68>] io_wqe_enqueue+0x248/0x3b0
> >       [<ffffffff8167663a>] io_queue_iowq+0xba/0x200
> >       [<ffffffff816768b3>] io_queue_async+0x113/0x180
> >       [<ffffffff816840df>] io_req_task_submit+0x18f/0x1a0
> >       [<ffffffff816841cd>] io_apoll_task_func+0xdd/0x120
> >       [<ffffffff8167d49f>] tctx_task_work+0x11f/0x570
> >       [<ffffffff81272c4e>] task_work_run+0x7e/0xc0
> >       [<ffffffff8125a688>] get_signal+0xc18/0xf10
> >       [<ffffffff8111645b>] arch_do_signal_or_restart+0x2b/0x730
> >       [<ffffffff812ea44e>] exit_to_user_mode_prepare+0x5e/0x180
> >       [<ffffffff844ae1b2>] syscall_exit_to_user_mode+0x12/0x20
> >       [<ffffffff844a7e80>] do_syscall_64+0x40/0x80
> >
> > Then,
> >
> >   3. io_sq_thread() or io_wqe_worker() frees @audit_context using
> >      audit_free();
> >   4. do_exit() eventually calls audit_free() again, which is okay
> >      because audit_free() does a NULL check.
> >
> > Free the old @audit_context first in audit_alloc_kernel(), and delete
> > the redundant calls to audit_free() for less confusion.
> >
> > Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> > ---
> > Hi all,
> >
> > A better way to fix this memleak would probably be checking
> > @args->io_thread in copy_process()?  Something like:
> >
> >     if (args->io_thread)
> >         retval = audit_alloc_kernel();
> >     else
> >         retval = audit_alloc();
> >
> > But I didn't want to add another if to copy_process() for this bugfix.
> > Please suggest, thanks!
>
> Thanks for the report and patch!  I'll take a closer look at this
> today and get back to you.

I think the best solution to this is simply to remove the calls to
audit_alloc_kernel() in the io_uring and io-wq code, as well as the
audit_alloc_kernel() function itself.  As long as create_io_thread()
ends up calling copy_process to create the new kernel thread the
audit_context should be allocated correctly.  Peilin Ye, are you able
to draft a patch to do that and give it a test?

For those that may be wondering how this happened (I definitely was!),
it looks like when I first started working on the LSM/audit support
for io_uring it was before the v5.12-rc1 release when
create_io_thread() was introduced.  Prior to create_io_thread() it
appears that io_uring/io-wq wasn't calling into copy_process() and
thus was not getting an audit_context allocated in the kernel thread's
task_struct; the solution for those original development drafts was to
add a call to a new audit_alloc_kernel() which would handle the
audit_context allocation.  Unfortunately, I didn't notice the move to
create_io_thread() during development and the redundant
audit_alloc_kernel() calls remained :/

-- 
paul-moore.com
