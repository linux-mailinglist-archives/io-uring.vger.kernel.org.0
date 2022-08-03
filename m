Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2BD588CD0
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 15:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236191AbiHCNQQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 09:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234836AbiHCNQP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 09:16:15 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAB22620
        for <io-uring@vger.kernel.org>; Wed,  3 Aug 2022 06:16:14 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id c20-20020a9d4814000000b0061cecd22af4so12111544otf.12
        for <io-uring@vger.kernel.org>; Wed, 03 Aug 2022 06:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=75c/vhgfgwtPaSPTZIQ1nQmAabAmAJZb+69obINC/dg=;
        b=cFH0wtURz57x5BNd0aYndz1RkpiNpoA3tV57uUKqVtm2xTlZaGsCJnUX0u9fIAwroZ
         E8gzehLhLbXFO/Af26SlTxo8Lhvib3iRfHtSToAKw8nrKqxd38NOI1fPjENQ5jE+rGhN
         Wh99bf7eb9+Jm8YoT5Z0Easx3yDYJMnTUUCzO8iwAzUOauHW3BcLW1QRtlkF+vlVe+I+
         YMg+ODSyWGxFkpFmkgEeMTpuer9sQ6EQiAaibdkXHZ8JGIULNCq8dKb7D3yZBUMKo09r
         APAdYMR4bpFQ7bD9XQ55yS+FV9HIIKWJ2dOmyerYGJR2gB+Z1z1blewa7sdAaVAe0rV5
         0Pvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=75c/vhgfgwtPaSPTZIQ1nQmAabAmAJZb+69obINC/dg=;
        b=27NurSpMy07JxpZNkWEHk9LKqqeM99LHRliqSgJW8tLPwNZRDzJdcbBqlyTKcYTKiP
         jVrnx/tkypLa30RpCMCJ8Vi4O10Pwefx78tsoguoTqodO/fBxf3f8Ac21Od7xQlttPyO
         qLlnnFzHp2AXvtBLhcytWR55MTr7bbeDyL0G9jbkqdd/FMkbYdaMKrMVWdAqMIepmmPR
         0A/Tb3Wse3R0RtDoKd/rxv1xYW+0FwP9biTkoVVaXAUXaDKGUa78FqEV2vh/XSsu9BF6
         MBvUS8Dhaxsezg0NVxvwQBCOFbq4OsRx3RXRv4JhAG72h2LAn6dnljCjNwomMxZGc+ey
         DcSQ==
X-Gm-Message-State: ACgBeo2wxuCiy3q7JKQnOWeprmU943P9YJokDVZAgxcYpaxdCvAuBLU/
        OeRYR/EAm5fOL2TzoRHtDKzTeNovgjA/ajIT67Hg
X-Google-Smtp-Source: AA6agR5lF2ezYGoL7L/iHQdgF1Vg48H+ggFEYzoBeBmSq6NiT4lioUEV4iA4SbxXpUT2T96zPEw9KwBVBPGOJ4sJ78U=
X-Received: by 2002:a9d:7a99:0:b0:629:805:bca4 with SMTP id
 l25-20020a9d7a99000000b006290805bca4mr5874553otn.26.1659532573884; Wed, 03
 Aug 2022 06:16:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220803050230.30152-1-yepeilin.cs@gmail.com>
In-Reply-To: <20220803050230.30152-1-yepeilin.cs@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 3 Aug 2022 09:16:02 -0400
Message-ID: <CAHC9VhRXypjNgDAwdARZz-md_DaSTs+9BpMik8AzWojG7ChexA@mail.gmail.com>
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

On Wed, Aug 3, 2022 at 1:03 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> From: Peilin Ye <peilin.ye@bytedance.com>
>
> Currently @audit_context is allocated twice for io_uring workers:
>
>   1. copy_process() calls audit_alloc();
>   2. io_sq_thread() or io_wqe_worker() calls audit_alloc_kernel() (which
>      is effectively audit_alloc()) and overwrites @audit_context,
>      causing:
>
>   BUG: memory leak
>   unreferenced object 0xffff888144547400 (size 1024):
> <...>
>     hex dump (first 32 bytes):
>       00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     backtrace:
>       [<ffffffff8135cfc3>] audit_alloc+0x133/0x210
>       [<ffffffff81239e63>] copy_process+0xcd3/0x2340
>       [<ffffffff8123b5f3>] create_io_thread+0x63/0x90
>       [<ffffffff81686604>] create_io_worker+0xb4/0x230
>       [<ffffffff81686f68>] io_wqe_enqueue+0x248/0x3b0
>       [<ffffffff8167663a>] io_queue_iowq+0xba/0x200
>       [<ffffffff816768b3>] io_queue_async+0x113/0x180
>       [<ffffffff816840df>] io_req_task_submit+0x18f/0x1a0
>       [<ffffffff816841cd>] io_apoll_task_func+0xdd/0x120
>       [<ffffffff8167d49f>] tctx_task_work+0x11f/0x570
>       [<ffffffff81272c4e>] task_work_run+0x7e/0xc0
>       [<ffffffff8125a688>] get_signal+0xc18/0xf10
>       [<ffffffff8111645b>] arch_do_signal_or_restart+0x2b/0x730
>       [<ffffffff812ea44e>] exit_to_user_mode_prepare+0x5e/0x180
>       [<ffffffff844ae1b2>] syscall_exit_to_user_mode+0x12/0x20
>       [<ffffffff844a7e80>] do_syscall_64+0x40/0x80
>
> Then,
>
>   3. io_sq_thread() or io_wqe_worker() frees @audit_context using
>      audit_free();
>   4. do_exit() eventually calls audit_free() again, which is okay
>      because audit_free() does a NULL check.
>
> Free the old @audit_context first in audit_alloc_kernel(), and delete
> the redundant calls to audit_free() for less confusion.
>
> Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
> Cc: stable@vger.kernel.org
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> ---
> Hi all,
>
> A better way to fix this memleak would probably be checking
> @args->io_thread in copy_process()?  Something like:
>
>     if (args->io_thread)
>         retval = audit_alloc_kernel();
>     else
>         retval = audit_alloc();
>
> But I didn't want to add another if to copy_process() for this bugfix.
> Please suggest, thanks!

Thanks for the report and patch!  I'll take a closer look at this
today and get back to you.

>  fs/io-wq.c       | 1 -
>  fs/io_uring.c    | 2 --
>  kernel/auditsc.c | 1 +
>  3 files changed, 1 insertion(+), 3 deletions(-)

-- 
paul-moore.com
