Return-Path: <io-uring+bounces-7626-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BDCEA97247
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 18:15:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 915BC1716EF
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B96290BBA;
	Tue, 22 Apr 2025 16:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dh5gKoo1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194B7290BB1;
	Tue, 22 Apr 2025 16:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745338488; cv=none; b=SpyewrYbAQ9tbUqY5Rx1BkyF36cZmwCIyWjpPzF5Jge/+zqL6X1v+syx86If/1s+JKhIh+Aiemqw36yj2BqMZy9k7dTVWtl2vmhQ1fRgH/pbjAu/Jdy1DiN+feo4wOFBoVITGfjooGOMFUIFrdiIhlADyb+OzsoxMVCMPpZOdQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745338488; c=relaxed/simple;
	bh=0Dl6b0XL8Xn73HwYpEOhV401ybP+E7Hc2aHg8lUA8d8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XrJjvq59ZMCUQodRBPTCU5xkFn4wkMkfB8Jlzwsqyry38cDAd/famOtUeU0MX6Z367uNv44H9l9xjUqDKrYwMeFboEgcosc5IMaxu3I07Qp91O2f2s3g6M1pDPSUj5BKG3HOXdoAhjlIziCAKt+EFUEVPc45gQpfaH00M6oAPsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dh5gKoo1; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2c6f27599abso1380941fac.2;
        Tue, 22 Apr 2025 09:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745338486; x=1745943286; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BjefU3lyqL7vf149hmDnxMZqNfL1VDpCFNsQB/0sEuk=;
        b=Dh5gKoo1L2fiZJkc6u4iY2pcDGac1ai6SPSXIbSOrHxfczPP1YOYcJ1FeawgCWqjq9
         ZmTu6W9ofxcqmnI8JStBAmleEqg52Lp2iqLgaY3HtbatfBSWZX6hS2goSsng9B5bIui+
         AJaUFrF5siEx2W4izaPHuTCNVLtECO8v4+w17F4lWyWoEV41WYLzcBCiPnArjCVjYg7k
         +T4AHTvsGwj/tltmmgrjyyPR6fvEG04TifokUPEos7Fv4YTVntKtuDZVBHsklQB7l4xB
         D5weM1WgPLINZSiGLGjAPbb5+eCLCYaQzuxb0zjEqeuuwATvR0THxowNbH60Yo10rAT6
         fiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745338486; x=1745943286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BjefU3lyqL7vf149hmDnxMZqNfL1VDpCFNsQB/0sEuk=;
        b=L4YLJrE9hYpD0Ta5nOqgLX5VHuA0JYyZEg0jJPXFxrXqaAj1TOy0kaKaFAIJk8dDsh
         HVaNLHJRPc0b3HvFBPVx7FfVT8gD2EYz3UEaXLfaeacu8/UtglXQ6drKpsWBSMZfefP9
         nUXEn2Q6rTXH4Xl5ftjTszJgQ4Y5httu3coNzJBGOeJcnxaMDSfaXIFaW5V6ZTwjV2M/
         QHV0VKPo0Le7X8zRv99h2cHf5FbVcfrp+KWJYgALX7g8F5/d1LQVSAFZ7VO3JdmicHW6
         lt8CCMZ9eBmfROd4mzN5pn5gQyHThZhJiosrkDCNDr4TnnxpjPK/JRFAycODMi7gPZVA
         R3dQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbI0AOidrSwURE25g6qej5Zxt2bOV87taZVrYmbxNBrLxeR24Y9RJhIdObjIK2uy9rbM1IJjnpSoTJuR8ueQ==@vger.kernel.org, AJvYcCUcEyKI9ZtFR4CRW9rEacdpOgooQPVQI0Ab3I2eOW7lebXA0F757c4p22afOoJfgR7yN/66hPG9cg==@vger.kernel.org, AJvYcCUk0gXJPvjylw0rtkOTuc3a/ueTX9nEjXG1TqkjlzEVIKHUgyYfBy/mQAIZh1yE/cB4pbyV2pOqeDJXuWKr@vger.kernel.org
X-Gm-Message-State: AOJu0YyKAOwnWL9frjHlaTkzaDfPTmzi32EGqPj8e0La7P5pk50J5j2P
	vHZ7VatghNhNBOU2+3HZ/MPZ4A5+3hfVcSU1XOaKlfCOLMjXcBQLFRNRLCA12e5TOt39ZQ5pnT8
	YqVn7ZJSsAr1diZC1nOzJe9luAPg=
X-Gm-Gg: ASbGncvWYuIm0ipiCUscegunHF3hwoYrFHM8Q1Qq8CLEnEewCMhx/1P4UsCpA4aWUUv
	iFZHThaYigGhq8Ox70iWnObCDm56+kdJKpDE1V2Hr40wtHnNoMnhlZrxQFw62nW7gUphYuymO+b
	GGV2bh5XSw7nkXshi6clXH6uE=
X-Google-Smtp-Source: AGHT+IF/s76yf6vIEoB/TsNYNjVeK16dsXTPRLz/ZPEfnN8E6sz6XFspieyAlrYHK2pmJxYIfwPQgbv0ptfPAUUJOn8=
X-Received: by 2002:a05:6870:b49f:b0:2d4:ce45:6994 with SMTP id
 586e51a60fabf-2d526d5507bmr9257755fac.24.1745338485866; Tue, 22 Apr 2025
 09:14:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422104545.1199433-1-qq282012236@gmail.com>
 <bc68ea08-4add-4304-b66b-376ec488da63@kernel.dk> <CANHzP_tpNwcL45wQTb6yFwsTU7jUEnrERv8LSc677hm7RQkPuw@mail.gmail.com>
 <028b4791-b6fc-47e3-9220-907180967d3a@kernel.dk> <CANHzP_vD2a8O1TqTuVNVBOofnQs6ot+tDJCWQkeSifVF9pYxGg@mail.gmail.com>
 <da279d0f-d450-49ef-a64e-e3b551127ef5@kernel.dk> <b5a8dbda-8555-4b43-9a46-190d4f1c7519@kernel.dk>
In-Reply-To: <b5a8dbda-8555-4b43-9a46-190d4f1c7519@kernel.dk>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Wed, 23 Apr 2025 00:14:33 +0800
X-Gm-Features: ATxdqUEn6MVVqneS6L3qL0mMa6qQnrGM8O7SLltyzrTiLhIfOaLIeBR49U4laJ8
Message-ID: <CANHzP_u=a1U4pXtFoQ8Aw_OCUkxgfV9ZGaBr8kiuOReTGTY3=g@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix 100% CPU usage issue in IOU worker threads
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 11:50=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 4/22/25 8:29 AM, Jens Axboe wrote:
> > On 4/22/25 8:18 AM, ??? wrote:
> >> On Tue, Apr 22, 2025 at 10:13?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> On 4/22/25 8:10 AM, ??? wrote:
> >>>> On Tue, Apr 22, 2025 at 9:35?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>
> >>>>> On 4/22/25 4:45 AM, Zhiwei Jiang wrote:
> >>>>>> In the Firecracker VM scenario, sporadically encountered threads w=
ith
> >>>>>> the UN state in the following call stack:
> >>>>>> [<0>] io_wq_put_and_exit+0xa1/0x210
> >>>>>> [<0>] io_uring_clean_tctx+0x8e/0xd0
> >>>>>> [<0>] io_uring_cancel_generic+0x19f/0x370
> >>>>>> [<0>] __io_uring_cancel+0x14/0x20
> >>>>>> [<0>] do_exit+0x17f/0x510
> >>>>>> [<0>] do_group_exit+0x35/0x90
> >>>>>> [<0>] get_signal+0x963/0x970
> >>>>>> [<0>] arch_do_signal_or_restart+0x39/0x120
> >>>>>> [<0>] syscall_exit_to_user_mode+0x206/0x260
> >>>>>> [<0>] do_syscall_64+0x8d/0x170
> >>>>>> [<0>] entry_SYSCALL_64_after_hwframe+0x78/0x80
> >>>>>> The cause is a large number of IOU kernel threads saturating the C=
PU
> >>>>>> and not exiting. When the issue occurs, CPU usage 100% and can onl=
y
> >>>>>> be resolved by rebooting. Each thread's appears as follows:
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork_asm
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_worker_handle_work
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_submit_work
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_issue_sqe
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_write
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] blkdev_write_iter
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] iomap_file_buffered_write
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] iomap_write_iter
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_iov_iter_readable
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_readable
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] asm_exc_page_fault
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] exc_page_fault
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] do_user_addr_fault
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] handle_mm_fault
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_fault
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_no_page
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_handle_userfault
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] handle_userfault
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] schedule
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] __schedule
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] __raw_spin_unlock_irq
> >>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker_sleeping
> >>>>>>
> >>>>>> I tracked the address that triggered the fault and the related fun=
ction
> >>>>>> graph, as well as the wake-up side of the user fault, and discover=
ed this
> >>>>>> : In the IOU worker, when fault in a user space page, this space i=
s
> >>>>>> associated with a userfault but does not sleep. This is because du=
ring
> >>>>>> scheduling, the judgment in the IOU worker context leads to early =
return.
> >>>>>> Meanwhile, the listener on the userfaultfd user side never perform=
s a COPY
> >>>>>> to respond, causing the page table entry to remain empty. However,=
 due to
> >>>>>> the early return, it does not sleep and wait to be awakened as in =
a normal
> >>>>>> user fault, thus continuously faulting at the same address,so CPU =
loop.
> >>>>>> Therefore, I believe it is necessary to specifically handle user f=
aults by
> >>>>>> setting a new flag to allow schedule function to continue in such =
cases,
> >>>>>> make sure the thread to sleep.
> >>>>>>
> >>>>>> Patch 1  io_uring: Add new functions to handle user fault scenario=
s
> >>>>>> Patch 2  userfaultfd: Set the corresponding flag in IOU worker con=
text
> >>>>>>
> >>>>>>  fs/userfaultfd.c |  7 ++++++
> >>>>>>  io_uring/io-wq.c | 57 +++++++++++++++----------------------------=
-----
> >>>>>>  io_uring/io-wq.h | 45 ++++++++++++++++++++++++++++++++++++--
> >>>>>>  3 files changed, 68 insertions(+), 41 deletions(-)
> >>>>>
> >>>>> Do you have a test case for this? I don't think the proposed soluti=
on is
> >>>>> very elegant, userfaultfd should not need to know about thread work=
ers.
> >>>>> I'll ponder this a bit...
> >>>>>
> >>>>> --
> >>>>> Jens Axboe
> >>>> Sorry,The issue occurs very infrequently, and I can't manually
> >>>> reproduce it. It's not very elegant, but for corner cases, it seems
> >>>> necessary to make some compromises.
> >>>
> >>> I'm going to see if I can create one. Not sure I fully understand the
> >>> issue yet, but I'd be surprised if there isn't a more appropriate and
> >>> elegant solution rather than exposing the io-wq guts and having
> >>> userfaultfd manipulate them. That really should not be necessary.
> >>>
> >>> --
> >>> Jens Axboe
> >> Thanks.I'm looking forward to your good news.
> >
> > Well, let's hope there is! In any case, your patches could be
> > considerably improved if you did:
> >
> > void set_userfault_flag_for_ioworker(void)
> > {
> >       struct io_worker *worker;
> >       if (!(current->flags & PF_IO_WORKER))
> >               return;
> >       worker =3D current->worker_private;
> >       set_bit(IO_WORKER_F_FAULT, &worker->flags);
> > }
> >
> > void clear_userfault_flag_for_ioworker(void)
> > {
> >       struct io_worker *worker;
> >       if (!(current->flags & PF_IO_WORKER))
> >               return;
> >       worker =3D current->worker_private;
> >       clear_bit(IO_WORKER_F_FAULT, &worker->flags);
> > }
> >
> > and then userfaultfd would not need any odd checking, or needing io-wq
> > related structures public. That'd drastically cut down on the size of
> > them, and make it a bit more palatable.
>
> Forgot to ask, what kernel are you running on?
>
> --
> Jens Axboe
Thanks Jens It is linux-image-6.8.0-1026-gcp

