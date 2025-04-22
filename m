Return-Path: <io-uring+bounces-7616-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF6CDA96E05
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 081AB178BDF
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 14:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF033284682;
	Tue, 22 Apr 2025 14:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H9qoYkFb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E147227466;
	Tue, 22 Apr 2025 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745331060; cv=none; b=MEEq97joTn+JOoqHOmlUBhI2nDNTyoN2j5LsJKFxZKs3cm8MTmTgsaVal5gWp69JInKyxqsxK6DOdFH+c6pSr/uJdPMf5pTdTsJmvEhdOEhB0NdkiL0l7jYthaXLoRLj142Im0xhszGosX/fK7xZV3uolopKJl/EiMe+/PBPIyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745331060; c=relaxed/simple;
	bh=7cq2RElW/yPZcpSilGEZH7dsfIfFz4V2MvZWxD/BDAY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mi3UctOMcXloEAMFb4i9YWleG4kVRnactdZbFJ26SoBvfEpmOwXEl14tXZl0gRfpAwDSJzz+5kTk/IR31eOdqW5G21aBNXHzNQ0342rYKZ/j0jLbaWK5is21N1aObvKC38chSLNCdCmNUpAJY5jE/gHUNWjB7SKR6Nf03kz4XDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H9qoYkFb; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7301c227512so1599282a34.2;
        Tue, 22 Apr 2025 07:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745331058; x=1745935858; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ENmNvcG+i4cA95dff7/W/R/4xtydjhp0oR96uzNkfLE=;
        b=H9qoYkFbR29vSO/z5YunUmc3snClsR4MmH8Ktnk4QzwH9HcrSleL5wjdkLxqWMTsaT
         9fvzH6FGtzdTkoMYX1ZN+OdyzptCpGnN3KLXEXXQnR3acf+YrxF2x3cCxsha6Wc1W0NL
         k8clb5bywyRA5OObs91utdHYbHrS5iB7aN/ha97wf9pSbojMg9ma/cO/KjmPYPNf817m
         zEJCXzhHzwH16iziaF2ByaUf+G4W/6gyHiB/ymDecAy6d4iLrv03a4Znce1rhs+1NY3v
         Xm0JzgbJgGxHzLEmK1U8twOjJWf0272KAaRXaBLv9lsldcFWZzzly2SQIOtREBEkv1uC
         OfJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745331058; x=1745935858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ENmNvcG+i4cA95dff7/W/R/4xtydjhp0oR96uzNkfLE=;
        b=qmVcTq5eDEO1Cz9Y+GAVwhgJBcr413VCv+AzZ/StcJBkWY07AUJXJpnutf4raQnfL0
         pij1TtG31hmjVmEU/3Ai0luyaO3A2br/95nJXctbU4zcvfTz3e6N3466pOS26w3F8Vnl
         3fyzt33UWQUULbTt8m3NJNdbqfG16X8nRqP0dcEipov2Y3pfTHmljNqj2zY0mqj/95mv
         KuPHc7cO5fs5A5XrHFac95hvRqg5cdP+NCDV5p7hfOn9zvhnRV4GH1+VZ+cE0iE0VNEg
         K6BrbUEWVoODs2RyEVW8UlmaLpCrB3VAtqP71TLo9CX4j5Y4+410D9oZKWXMmkxA0+2k
         NMcw==
X-Forwarded-Encrypted: i=1; AJvYcCVNfVJLhzNJNfYHOqasTmAPJXgojPT1BJkpLhhSSZWfscFnUhZlfTnyn0bteGVYtxP90MmNa7ECp0lZublb@vger.kernel.org, AJvYcCWHunBAZ47Oy5/gGHXUbbhUhhBqm0t8+DCH2cVELeHXt9K9V5ohLwy5IXR/13/dbPkAeAa/Qi6CyvYL2jFJHA==@vger.kernel.org, AJvYcCWmKLnLAXUeFsWxPiyjZqoUifmlHDvxyHSz6xX6lM/zgE/5NWxkhtqImdG4vK7v/jTl6Qwqo3KifA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyuPzcE6iACvcE842v5zi/V1sCnxlmezn2spj4WrAS5qli78dFV
	QrzpA8stCPkK2aBOpWwoYJsuvXqVhCuC4Db4bLG6/E1w2+iKQyuROvH8yAXYzYN5r0jdFl7672z
	EGShs8FtEN+2eC7Lw9PPq/rpTRtc=
X-Gm-Gg: ASbGncswBxMX7iZQNQquzh4WSs7ZTES4JLlHCKVaVO254PnB6iKJvQOY+yM3/+xnQC1
	uOyknR7lGwCy4teWEw7zOPCSviwz4c0CEsmyBc3csMRw2pvFVDuS+vkTWOEFAlJ89K8lojj0+u2
	MNQ6kta6it8ciTOjyTulkOMvE=
X-Google-Smtp-Source: AGHT+IHs52QH1e1EcEp6l4JLqsVOeDSJ3Ng/TlhNfJ91v6SCzBDysQnzdm5i0GiYHIM+K+KBtAUyFHpvlpyYlRyyIQM=
X-Received: by 2002:a05:6871:530d:b0:28c:8476:dd76 with SMTP id
 586e51a60fabf-2d526ee4ad6mr11088969fac.29.1745331057649; Tue, 22 Apr 2025
 07:10:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422104545.1199433-1-qq282012236@gmail.com> <bc68ea08-4add-4304-b66b-376ec488da63@kernel.dk>
In-Reply-To: <bc68ea08-4add-4304-b66b-376ec488da63@kernel.dk>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Tue, 22 Apr 2025 22:10:45 +0800
X-Gm-Features: ATxdqUFY0D9ZhIoPAnO4wqwO_j8l65R--mu-PkgmPt3dkQ_eilqKjmLgt8z5KSc
Message-ID: <CANHzP_tpNwcL45wQTb6yFwsTU7jUEnrERv8LSc677hm7RQkPuw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix 100% CPU usage issue in IOU worker threads
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 9:35=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/22/25 4:45 AM, Zhiwei Jiang wrote:
> > In the Firecracker VM scenario, sporadically encountered threads with
> > the UN state in the following call stack:
> > [<0>] io_wq_put_and_exit+0xa1/0x210
> > [<0>] io_uring_clean_tctx+0x8e/0xd0
> > [<0>] io_uring_cancel_generic+0x19f/0x370
> > [<0>] __io_uring_cancel+0x14/0x20
> > [<0>] do_exit+0x17f/0x510
> > [<0>] do_group_exit+0x35/0x90
> > [<0>] get_signal+0x963/0x970
> > [<0>] arch_do_signal_or_restart+0x39/0x120
> > [<0>] syscall_exit_to_user_mode+0x206/0x260
> > [<0>] do_syscall_64+0x8d/0x170
> > [<0>] entry_SYSCALL_64_after_hwframe+0x78/0x80
> > The cause is a large number of IOU kernel threads saturating the CPU
> > and not exiting. When the issue occurs, CPU usage 100% and can only
> > be resolved by rebooting. Each thread's appears as follows:
> > iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork_asm
> > iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork
> > iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker
> > iou-wrk-44588  [kernel.kallsyms]  [k] io_worker_handle_work
> > iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_submit_work
> > iou-wrk-44588  [kernel.kallsyms]  [k] io_issue_sqe
> > iou-wrk-44588  [kernel.kallsyms]  [k] io_write
> > iou-wrk-44588  [kernel.kallsyms]  [k] blkdev_write_iter
> > iou-wrk-44588  [kernel.kallsyms]  [k] iomap_file_buffered_write
> > iou-wrk-44588  [kernel.kallsyms]  [k] iomap_write_iter
> > iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_iov_iter_readable
> > iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_readable
> > iou-wrk-44588  [kernel.kallsyms]  [k] asm_exc_page_fault
> > iou-wrk-44588  [kernel.kallsyms]  [k] exc_page_fault
> > iou-wrk-44588  [kernel.kallsyms]  [k] do_user_addr_fault
> > iou-wrk-44588  [kernel.kallsyms]  [k] handle_mm_fault
> > iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_fault
> > iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_no_page
> > iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_handle_userfault
> > iou-wrk-44588  [kernel.kallsyms]  [k] handle_userfault
> > iou-wrk-44588  [kernel.kallsyms]  [k] schedule
> > iou-wrk-44588  [kernel.kallsyms]  [k] __schedule
> > iou-wrk-44588  [kernel.kallsyms]  [k] __raw_spin_unlock_irq
> > iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker_sleeping
> >
> > I tracked the address that triggered the fault and the related function
> > graph, as well as the wake-up side of the user fault, and discovered th=
is
> > : In the IOU worker, when fault in a user space page, this space is
> > associated with a userfault but does not sleep. This is because during
> > scheduling, the judgment in the IOU worker context leads to early retur=
n.
> > Meanwhile, the listener on the userfaultfd user side never performs a C=
OPY
> > to respond, causing the page table entry to remain empty. However, due =
to
> > the early return, it does not sleep and wait to be awakened as in a nor=
mal
> > user fault, thus continuously faulting at the same address,so CPU loop.
> > Therefore, I believe it is necessary to specifically handle user faults=
 by
> > setting a new flag to allow schedule function to continue in such cases=
,
> > make sure the thread to sleep.
> >
> > Patch 1  io_uring: Add new functions to handle user fault scenarios
> > Patch 2  userfaultfd: Set the corresponding flag in IOU worker context
> >
> >  fs/userfaultfd.c |  7 ++++++
> >  io_uring/io-wq.c | 57 +++++++++++++++---------------------------------
> >  io_uring/io-wq.h | 45 ++++++++++++++++++++++++++++++++++++--
> >  3 files changed, 68 insertions(+), 41 deletions(-)
>
> Do you have a test case for this? I don't think the proposed solution is
> very elegant, userfaultfd should not need to know about thread workers.
> I'll ponder this a bit...
>
> --
> Jens Axboe
Sorry,The issue occurs very infrequently, and I can't manually
reproduce it. It's not very elegant, but for corner cases, it seems
necessary to make some compromises.

