Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDB44EB35B
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 20:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240555AbiC2Sdb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 14:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240559AbiC2Sd3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 14:33:29 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394B017A2C8
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 11:31:46 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lr4so28453622ejb.11
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 11:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dOBTkOBwLLV4nt/DAdRDAOoHUD7zrhiv+dW/cowibGE=;
        b=NrvrIkQHa9t6kNTT5/H+8LZ8ZzkcK9yqPTet9XZm7bgAe+qWlcXdO/cI6Jt5i7RNap
         7RH2bTQNsnkrbPWFER+QwK4VJ/Cd+dzxU2LnREWSb5g/ft6KIaR7ids0x8+iRw1bkeSe
         LFnH87630nWX3nwS8GmBndXY+0vweCeEEB1G0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dOBTkOBwLLV4nt/DAdRDAOoHUD7zrhiv+dW/cowibGE=;
        b=Pi63DvueIAf5EphTnSe/LYVByAlp6RDIpJeVEZulTwJuii8k7SdVHMsxBIx5HYdcw8
         QmGyLkAn9dlYsPeUIr3/iY3frvPEdkYWplSZezKqLPM8nnFFxRWz3oI9Rav81XZ2aeGM
         LfaD9O8dNU4nuGJG6qqwy4eRbM8bLTeqdsd1uXuawoDSv6w5tkcmaEvJOChdAN0pFWk3
         KWLq8HQgZEfn2No5ye6KkPJLbzLySEMTN0cFhrv41sdcDTnvJyTgle9pJE8AySHnaoip
         p0UtWOuqCk8CB6DqXxYwZWUcqB+ZHNoocScV+MEwYmR/x6avmkO4syI10XbfhawtCxIh
         nhaQ==
X-Gm-Message-State: AOAM531GGd6Et54rSnb2g6xYO6Yqkdfh0KL87nydf8vWLWzGFIGcoaTU
        SH2UhvED+vkjVJM8gYfpE4En2j2toGwj72RFOiM/Z476JxX2cw==
X-Google-Smtp-Source: ABdhPJxHVqcbhKVv1lLhJXVI/NQBEsuCwtPSsDUfUGRWNgoAb34IIhsb+2C6XbjZqmN4qfbtkeh9807KMPvX3IzE6PI=
X-Received: by 2002:a17:906:7948:b0:6da:64ed:178e with SMTP id
 l8-20020a170906794800b006da64ed178emr36864571ejo.523.1648578704712; Tue, 29
 Mar 2022 11:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk> <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com> <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk>
In-Reply-To: <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 29 Mar 2022 20:31:33 +0200
Message-ID: <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
Subject: Re: io_uring_prep_openat_direct() and link/drain
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 29 Mar 2022 at 20:26, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/29/22 12:21 PM, Miklos Szeredi wrote:
> > On Tue, 29 Mar 2022 at 19:04, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 3/29/22 10:08 AM, Jens Axboe wrote:
> >>> On 3/29/22 7:20 AM, Miklos Szeredi wrote:
> >>>> Hi,
> >>>>
> >>>> I'm trying to read multiple files with io_uring and getting stuck,
> >>>> because the link and drain flags don't seem to do what they are
> >>>> documented to do.
> >>>>
> >>>> Kernel is v5.17 and liburing is compiled from the git tree at
> >>>> 7a3a27b6a384 ("add tests for nonblocking accept sockets").
> >>>>
> >>>> Without those flags the attached example works some of the time, but
> >>>> that's probably accidental since ordering is not ensured.
> >>>>
> >>>> Adding the drain or link flags make it even worse (fail in casese that
> >>>> the unordered one didn't).
> >>>>
> >>>> What am I missing?
> >>>
> >>> I don't think you're missing anything, it looks like a bug. What you
> >>> want here is:
> >>>
> >>> prep_open_direct(sqe);
> >>> sqe->flags |= IOSQE_IO_LINK;
> >>> ...
> >>> prep_read(sqe);
> >
> > So with the below merge this works.   But if instead I do
> >
> > prep_open_direct(sqe);
> >  ...
> > prep_read(sqe);
> > sqe->flags |= IOSQE_IO_DRAIN;
> >
> > than it doesn't.  Shouldn't drain have a stronger ordering guarantee than link?
>
> I didn't test that, but I bet it's running into the same kind of issue
> wrt prep. Are you getting -EBADF? The drain will indeed ensure that
> _execution_ doesn't start until the previous requests have completed,
> but it's still prepared before.
>
> For your use case, IO_LINK is what you want and that must work.
>
> I'll check the drain case just in case, it may in fact work if you just
> edit the code base you're running now and remove these two lines from
> io_init_req():
>
> if (unlikely(!req->file)) {
> -        if (!ctx->submit_state.link.head)
> -                return -EBADF;
>         req->result = fd;
>         req->flags |= REQ_F_DEFERRED_FILE;
> }
>
> to not make it dependent on link.head. Probably not a bad idea in
> general, as the rest of the handlers have been audited for req->file
> usage in prep.

Nope, that results in the following Oops:

BUG: kernel NULL pointer dereference, address: 0000000000000044
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 3 PID: 1126 Comm: readfiles Not tainted
5.17.0-00065-g3287b182c9c3-dirty #623
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-29-g6a62e0cb0dfe-prebuilt.qemu.org 04/01/2014
RIP: 0010:io_rw_init_file+0x15/0x170
Code: 00 6d 22 82 0f 95 c0 83 c0 02 c3 66 2e 0f 1f 84 00 00 00 00 00
0f 1f 44 00 00 41 55 41 54 55 53 4c 8b 2f 4c 8b 67 58 8b 6f 20 <41> 23
75 44 0f 84 28 01 00 00 48 89 fb f6 47 44 01 0f 84 08 01 00
RSP: 0018:ffffc9000108fba8 EFLAGS: 00010207
RAX: 0000000000000001 RBX: ffff888103ddd688 RCX: ffffc9000108fc18
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff888103ddd600
RBP: 0000000000000000 R08: ffffc9000108fbd8 R09: 00007ffffffff000
R10: 0000000000020000 R11: 000056012e2ce2e0 R12: ffff88810276b800
R13: 0000000000000000 R14: 0000000000000000 R15: ffff888103ddd600
FS:  00007f9058d72580(0000) GS:ffff888237d80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000044 CR3: 0000000100966004 CR4: 0000000000370ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_read+0x65/0x4d0
 ? select_task_rq_fair+0x602/0xf20
 ? newidle_balance.constprop.0+0x2ff/0x3a0
 io_issue_sqe+0xd86/0x21a0
 ? __schedule+0x228/0x610
 ? timerqueue_del+0x2a/0x40
 io_req_task_submit+0x26/0x100
 tctx_task_work+0x172/0x4b0
 task_work_run+0x5c/0x90
 io_cqring_wait+0x48d/0x790
 ? io_eventfd_put+0x20/0x20
 __do_sys_io_uring_enter+0x28d/0x5e0
 ? __cond_resched+0x16/0x40
 ? task_work_run+0x61/0x90
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x56012d87159c
Code: c2 41 8b 54 24 04 8b bd cc 00 00 00 41 83 ca 10 f6 85 d0 00 00
00 01 4d 8b 44 24 10 44 0f 44 d0 45 8b 4c 24 0c 44 89 f0 0f 05 <41> 89
c3 85 c0 0f 88 4a ff ff ff 41 29 04 24 bf 01 00 00 00 48 85
RSP: 002b:00007ffc8db5c550 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000056012d87159c
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007ffc8db5c620 R08: 0000000000000000 R09: 0000000000000008
R10: 0000000000000001 R11: 0000000000000246 R12: 00007ffc8db5c580
R13: 00007ffc8db5c618 R14: 00000000000001aa R15: 0000000000000000
 </TASK>
Modules linked in:
CR2: 0000000000000044
---[ end trace 0000000000000000 ]---
