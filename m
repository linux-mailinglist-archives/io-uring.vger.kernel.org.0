Return-Path: <io-uring+bounces-7618-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96FB5A96E2F
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:19:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BEDB188A98E
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 14:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66669280A3B;
	Tue, 22 Apr 2025 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OcakFO2M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10CF2147F9;
	Tue, 22 Apr 2025 14:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745331536; cv=none; b=ZOttWLBWioGfuSlRiYFvqQXsMHiPqM0cd2BSru9X5xvNG4YAIbumyv+C4VoMZRvZKZt7ZrhOYLwCeE+bCJsCFapMsaV6Ydcw0BwWAGWd93wAyIPSVrg5aZVqE1ZNr6A6mn623Yl3Bdbcz2RaBUklfIHetLIWqiVO19M2AUgTvU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745331536; c=relaxed/simple;
	bh=p7cBAR716y73pklskD9H+ZxXq0DJTlQYOE6oG5jQ7No=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RWVeEnKWzAzA6actimZfc6dMQF1BE4bm1Ebc4nnyhYAu4JfIz/vXF54BsruPZhdKTn81NNkjLs424x9yfGEan2IBVx9WdW59Y+ZFRjl0ma4SsHhtDwRe/X3gM4pu3eqYG1HgqrDcqhMRD2CnrPnBzPnJSm4OmUU/g6waFz2yhfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OcakFO2M; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-2c6ed7efb1dso3203429fac.2;
        Tue, 22 Apr 2025 07:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745331532; x=1745936332; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a0z3rTEDjmdssEPqfKkSM3v8YROVWuTNE2YICwop5N0=;
        b=OcakFO2Md8Zs5RDUqR0XVYrAssUy7IC4nXfufkBHGlrZKYF9EwefR5z/aKWcSXBY2X
         xvQMrzCl0WvxF9HI9QJhP0frzLmQiO/z4IhOoWufiNj7w9iJ92IMcad+q5Div0PeEXSY
         nelgtTrP8TbOMkhiOnMS03sSZd/xU7yO2c6UaH9X5mcztuaTqd0SR07xvb0ukVeP1r42
         TfZzANnk5rxHyAupazc6rTTPgimeO+i/ZCFIKup/g3OIFSIx85KcLhFlTJ9OoT4NBkc5
         Qr5vuczIAO+OGG0yNzbsW4Cywmse1nJ8YR63rnnAoM4RjrUh3zaSVS0GZIjXF8wH4jbb
         Zb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745331532; x=1745936332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a0z3rTEDjmdssEPqfKkSM3v8YROVWuTNE2YICwop5N0=;
        b=l7mG2um/w7dy4/CMAOoJ/dc3+Wj1Y/yX+MGYPH+XO1jP3XB3BfSe/ct7Ka2PWR4+hH
         Bj9rXCItmMt76o9U27RAc2gTMDps/jFeQTi3agcAMnjoq5yYZlSLq54T1FwNmyitjPA0
         3XJUAP1iXi4EsHbunyMMBdsSwUuBBJkqgwHspLbxJRFU+1t14m/sNtepFvr58Ar5mXHq
         CAjYDEJuLx+6HVZGqYG3oT475VQVjwKMLC3vQROIz/JYo+dToR3Xgh6+vYKcGdZQU35t
         sVvH5nN5I0M5VNNKPho8yBZjbj81zLqlcwebN2rkNalz3nsMyN0aP/uu/6vBG1Ac35u5
         7W0w==
X-Forwarded-Encrypted: i=1; AJvYcCVFPPkSl4aK2KTRnXTDCxuWpHa0aakOv35xLn2RtvqI7ZaJeU6P1VrNelS0DkSmLEl89ieo+qfb3o43DcY9@vger.kernel.org, AJvYcCVlJOPJMcDkmgpXjJbUD3N0O0whQj8mohYKOkbveZ6pUvmnj7aymEtqRirom8bodaECbDzOGd1bvQ==@vger.kernel.org, AJvYcCXcZAGC0o9aBoNRoU2aL2LMmwOFQacJSnPt9Rl5LE4BuTLRI8jcx/2/Q/uG2XyMiuEVGjIbnCUUpgq9QVcANA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzzGs59QKdXBH2lm/GqQ/wKY6m6JE+WSUtaWHDcmbV2oWg4+Vwf
	Lm5zGrFrBR/XZH+xqFks5YlmpyBV7Z/dPhMs4+NHRLvXcQig+DNeqMjt7uc8/zaYzknBvCh20c+
	bDmmB1Qaq7bdw90IQuJKKmolirmo=
X-Gm-Gg: ASbGncuB1ckzDm2+QzL8z3/Rg6sM/2sikkxW290OcOqzZwp/0316COsL/NZMoO51PFt
	RpWqmXeKVaEQ9Y9zrqyUC4r+RAdcLUOfgcqKfrD38slHq+HiYBJfZAVidFExBaG104bRnJZuHHK
	VKDvpO7zPIdMHlFXEsls9FttI=
X-Google-Smtp-Source: AGHT+IHQ4xRkVRcN+dzr3ufuvBRvI4pE0dfDWETlkfgu2xcgXTXaui9+1u79Gxg+7c7ROQye1I3Xpbr8DAJ1/N+3b7M=
X-Received: by 2002:a05:6871:9d8a:b0:2a7:d345:c0bb with SMTP id
 586e51a60fabf-2d526d4ef34mr8097846fac.27.1745331532557; Tue, 22 Apr 2025
 07:18:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422104545.1199433-1-qq282012236@gmail.com>
 <bc68ea08-4add-4304-b66b-376ec488da63@kernel.dk> <CANHzP_tpNwcL45wQTb6yFwsTU7jUEnrERv8LSc677hm7RQkPuw@mail.gmail.com>
 <028b4791-b6fc-47e3-9220-907180967d3a@kernel.dk>
In-Reply-To: <028b4791-b6fc-47e3-9220-907180967d3a@kernel.dk>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Tue, 22 Apr 2025 22:18:39 +0800
X-Gm-Features: ATxdqUE-XD9kMd6IVuQPAjJXuJd3l_VqxZe--va4HHnXWQk5T8vC8UEEME9Gv_U
Message-ID: <CANHzP_vD2a8O1TqTuVNVBOofnQs6ot+tDJCWQkeSifVF9pYxGg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix 100% CPU usage issue in IOU worker threads
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 10:13=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 4/22/25 8:10 AM, ??? wrote:
> > On Tue, Apr 22, 2025 at 9:35?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 4/22/25 4:45 AM, Zhiwei Jiang wrote:
> >>> In the Firecracker VM scenario, sporadically encountered threads with
> >>> the UN state in the following call stack:
> >>> [<0>] io_wq_put_and_exit+0xa1/0x210
> >>> [<0>] io_uring_clean_tctx+0x8e/0xd0
> >>> [<0>] io_uring_cancel_generic+0x19f/0x370
> >>> [<0>] __io_uring_cancel+0x14/0x20
> >>> [<0>] do_exit+0x17f/0x510
> >>> [<0>] do_group_exit+0x35/0x90
> >>> [<0>] get_signal+0x963/0x970
> >>> [<0>] arch_do_signal_or_restart+0x39/0x120
> >>> [<0>] syscall_exit_to_user_mode+0x206/0x260
> >>> [<0>] do_syscall_64+0x8d/0x170
> >>> [<0>] entry_SYSCALL_64_after_hwframe+0x78/0x80
> >>> The cause is a large number of IOU kernel threads saturating the CPU
> >>> and not exiting. When the issue occurs, CPU usage 100% and can only
> >>> be resolved by rebooting. Each thread's appears as follows:
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork_asm
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] io_worker_handle_work
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_submit_work
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] io_issue_sqe
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] io_write
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] blkdev_write_iter
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] iomap_file_buffered_write
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] iomap_write_iter
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_iov_iter_readable
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_readable
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] asm_exc_page_fault
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] exc_page_fault
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] do_user_addr_fault
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] handle_mm_fault
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_fault
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_no_page
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_handle_userfault
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] handle_userfault
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] schedule
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] __schedule
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] __raw_spin_unlock_irq
> >>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker_sleeping
> >>>
> >>> I tracked the address that triggered the fault and the related functi=
on
> >>> graph, as well as the wake-up side of the user fault, and discovered =
this
> >>> : In the IOU worker, when fault in a user space page, this space is
> >>> associated with a userfault but does not sleep. This is because durin=
g
> >>> scheduling, the judgment in the IOU worker context leads to early ret=
urn.
> >>> Meanwhile, the listener on the userfaultfd user side never performs a=
 COPY
> >>> to respond, causing the page table entry to remain empty. However, du=
e to
> >>> the early return, it does not sleep and wait to be awakened as in a n=
ormal
> >>> user fault, thus continuously faulting at the same address,so CPU loo=
p.
> >>> Therefore, I believe it is necessary to specifically handle user faul=
ts by
> >>> setting a new flag to allow schedule function to continue in such cas=
es,
> >>> make sure the thread to sleep.
> >>>
> >>> Patch 1  io_uring: Add new functions to handle user fault scenarios
> >>> Patch 2  userfaultfd: Set the corresponding flag in IOU worker contex=
t
> >>>
> >>>  fs/userfaultfd.c |  7 ++++++
> >>>  io_uring/io-wq.c | 57 +++++++++++++++-------------------------------=
--
> >>>  io_uring/io-wq.h | 45 ++++++++++++++++++++++++++++++++++++--
> >>>  3 files changed, 68 insertions(+), 41 deletions(-)
> >>
> >> Do you have a test case for this? I don't think the proposed solution =
is
> >> very elegant, userfaultfd should not need to know about thread workers=
.
> >> I'll ponder this a bit...
> >>
> >> --
> >> Jens Axboe
> > Sorry,The issue occurs very infrequently, and I can't manually
> > reproduce it. It's not very elegant, but for corner cases, it seems
> > necessary to make some compromises.
>
> I'm going to see if I can create one. Not sure I fully understand the
> issue yet, but I'd be surprised if there isn't a more appropriate and
> elegant solution rather than exposing the io-wq guts and having
> userfaultfd manipulate them. That really should not be necessary.
>
> --
> Jens Axboe
Thanks.I'm looking forward to your good news.

