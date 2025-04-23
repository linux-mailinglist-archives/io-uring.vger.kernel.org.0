Return-Path: <io-uring+bounces-7656-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 906D3A97F12
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 08:22:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBA8117A7B6
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 06:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF42266B54;
	Wed, 23 Apr 2025 06:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lCDlIzZR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9631F4CAB;
	Wed, 23 Apr 2025 06:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745389366; cv=none; b=sE4kRSPyzKUzg5hzrrvnXYJzqN5cFU71vSpjwlMRUq+eXTJK5X1I3Zf2FuLqMpCyUzTZfvsHr9cnTGE7fvIO3GwSyAtsU6qkiGorNarig0beg/rKGNLGKL0iNZ6qCYGyPzyxOuh92qFoYZ2a9IgcxA7vNpTEWj8jOrRYIhlSzlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745389366; c=relaxed/simple;
	bh=2NaBC53CM93y+f0uWzLpQCvSdiBcf01JUdUYGMwIE8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hzDQd1ctMTp5+EJh+eYQ7j6Ebzz5aDBm/rqHSl3e7hmOerBiT8NJ6JLeY8M8VA72meAHhcQE8tuF6ZFZq72kZlVlsHKp5R/CPeCyBskBR+M2prtfFFBzJsJpeieDvJ8i3M07jBbLZo2oM/7uXJ2LW/cmj12ZJeTTI2af7jLFUg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lCDlIzZR; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-2c769da02b0so5239064fac.3;
        Tue, 22 Apr 2025 23:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745389364; x=1745994164; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVcK8cLkuGa6/rpVR1IXkRLxN4IwCjNUW/jXWmtnhB0=;
        b=lCDlIzZRIMSZSkrCcAxf0LLPm1JofGxDTqxz1aQhdE4Xn0mKwSSyQX9InMOFHdIuzU
         MMvXng8A1DdHwHgDb2Wji9qBhNssuBc1t4M12U7btJeKr4txELDMWISsvF4qGmSAepy4
         euw0SYO3Zy0XPO5HbWfAHTDQ2LUerdtJh8eEuUhHGh/Oxvd5cllTCx3ZJjmCHnAKIo8C
         cm4E+lWavxZzQ2scZGdMEktOiIJii0CC8OhxkkA0dEGQM6mvXCn6slOYHoMNz6s7KCZ9
         qWgUm8fJBvbcwE71Vu4Z4ZMFD2LL1aaGt8czUhKhAnUyxn8kBAnBVXNHQxKKb0mXLNSU
         5JYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745389364; x=1745994164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sVcK8cLkuGa6/rpVR1IXkRLxN4IwCjNUW/jXWmtnhB0=;
        b=UFMemhAjRgB/4476lbDtSKAwFZQGkNICH6cjp2ksdOU5qofRCEnJim2yRmQkjCbNeG
         mDPd04HS4dF+ohk5FDjjk9ErzYSxKV2H70Bnv7NeVhmWI/cesxBnAv0WXAxzNifPagB4
         eDbjLGcL5GhFhRRuTvLDPfq5Sz+9+GDDWqXsWRg23dh2x01GbzhL49ZcCnxKB8dd8DsU
         B1lJNpMCncholeS75tQZXusU4LLOsGLbfppbPl2e8yUlAfdD4zFV3+X0QTXLUdoZJfYr
         0NuX+/cxXbd9tYYdNuUSMG6/20nxE92aClMIiOfHoN7L1zOE/I4YMIi4nHgr9P6zmWaC
         dKYg==
X-Forwarded-Encrypted: i=1; AJvYcCUqau2jAs6IQfLk5nNdWz10PwHOYDq5BXGKdut7LXkLHOh8c2c0uZXJUZkFuokQ5B1CZIvCCNSKbzNSL19XgQ==@vger.kernel.org, AJvYcCVQitnr2c0NB9UTlxUdqD5mXYwJTv1QLf+P7kil4Ol9pvKUWchvLIM0M4gXWC4UW7e2Q/SdNQcAnA==@vger.kernel.org, AJvYcCWTgevcu7kn6QNpTsn/RwKvVPULvFhP7B5tmJd4IQZQmSg7/ebeMbVT61TTh+IMGTVk7MQa/ZMTyC1f84zu@vger.kernel.org
X-Gm-Message-State: AOJu0YyO34tOVRztusL6oBHeUnGMEJo46HukUNrGgAcyqoZEl/WCMM7z
	+fQPs6nxzD4FzB4LcuJLFjfjLIy2aP2lFuj3FR+9XR05mKtXcZp5UnWmlA5OkSqdlv6oCNZiaoK
	bBK/YVh4qstAX7GSDTEDk54u0j9I=
X-Gm-Gg: ASbGncsaYZryBqCDYB2ZXLIEmP3qCkiUe2FPU9v06zvfS/jE9Pu+zvSRMYYkJ4samIJ
	lrvFUzoNH+EwSQEIt0zUTxgK+25XnpyF1xZtoIpwJ2rDxe/Q1p584BNhfVDzX9qmPmqUWYAPGTF
	SS1vimFckx4FBbAOOCnjr3Kg==
X-Google-Smtp-Source: AGHT+IEf3Tx42zp6XYx0ZAYrVGRlkUyP8+/u5lxgWIosIHy0ODAGStT4FJNSvcHbhiDc4RgpkRie1Dcg/4szHJ7p9Eg=
X-Received: by 2002:a05:6870:eca2:b0:29e:2594:81e with SMTP id
 586e51a60fabf-2d526a2e955mr10065315fac.13.1745389363812; Tue, 22 Apr 2025
 23:22:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422162913.1242057-1-qq282012236@gmail.com>
 <20250422162913.1242057-2-qq282012236@gmail.com> <14195206-47b1-4483-996d-3315aa7c33aa@kernel.dk>
 <CANHzP_uW4+-M1yTg-GPdPzYWAmvqP5vh6+s1uBhrMZ3eBusLug@mail.gmail.com>
 <b61ac651-fafe-449a-82ed-7239123844e1@kernel.dk> <CANHzP_tLV29_uk2gcRAjT9sJNVPH3rMyVuQP07q+c_TWWgsfDg@mail.gmail.com>
 <CANHzP_u3zN2a_t2O+BLwgV=KJZaXtANwXVq6VVD26TvF2hFL8Q@mail.gmail.com>
In-Reply-To: <CANHzP_u3zN2a_t2O+BLwgV=KJZaXtANwXVq6VVD26TvF2hFL8Q@mail.gmail.com>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Wed, 23 Apr 2025 14:22:32 +0800
X-Gm-Features: ATxdqUGJyNAYeV6aJ6me5GIU6PLK9S3z-8u-6Awas1fIjW75tEfnK1ENgFfPhF0
Message-ID: <CANHzP_vsSQe2dRniHUFYCo6dkDA5UiGkkY+oXadebOoNkL0KFg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault scenarios
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025 at 11:11=E2=80=AFAM =E5=A7=9C=E6=99=BA=E4=BC=9F <qq282=
012236@gmail.com> wrote:
>
> Sorry, I may have misunderstood. I thought your test case
> was working correctly. In io_wq_worker_running() it will return
> if in io worker context, that is different from common progress
> context.I hope the graph above can help you understand.
>
> On Wed, Apr 23, 2025 at 10:49=E2=80=AFAM =E5=A7=9C=E6=99=BA=E4=BC=9F <qq2=
82012236@gmail.com> wrote:
> >
> > On Wed, Apr 23, 2025 at 1:33=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wr=
ote:
> > >
> > > On 4/22/25 11:04 AM, ??? wrote:
> > > > On Wed, Apr 23, 2025 at 12:32?AM Jens Axboe <axboe@kernel.dk> wrote=
:
> > > >>
> > > >> On 4/22/25 10:29 AM, Zhiwei Jiang wrote:
> > > >>> diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
> > > >>> index d4fb2940e435..8567a9c819db 100644
> > > >>> --- a/io_uring/io-wq.h
> > > >>> +++ b/io_uring/io-wq.h
> > > >>> @@ -70,8 +70,10 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq=
 *wq, work_cancel_fn *cancel,
> > > >>>                                       void *data, bool cancel_all=
);
> > > >>>
> > > >>>  #if defined(CONFIG_IO_WQ)
> > > >>> -extern void io_wq_worker_sleeping(struct task_struct *);
> > > >>> -extern void io_wq_worker_running(struct task_struct *);
> > > >>> +extern void io_wq_worker_sleeping(struct task_struct *tsk);
> > > >>> +extern void io_wq_worker_running(struct task_struct *tsk);
> > > >>> +extern void set_userfault_flag_for_ioworker(void);
> > > >>> +extern void clear_userfault_flag_for_ioworker(void);
> > > >>>  #else
> > > >>>  static inline void io_wq_worker_sleeping(struct task_struct *tsk=
)
> > > >>>  {
> > > >>> @@ -79,6 +81,12 @@ static inline void io_wq_worker_sleeping(struc=
t task_struct *tsk)
> > > >>>  static inline void io_wq_worker_running(struct task_struct *tsk)
> > > >>>  {
> > > >>>  }
> > > >>> +static inline void set_userfault_flag_for_ioworker(void)
> > > >>> +{
> > > >>> +}
> > > >>> +static inline void clear_userfault_flag_for_ioworker(void)
> > > >>> +{
> > > >>> +}
> > > >>>  #endif
> > > >>>
> > > >>>  static inline bool io_wq_current_is_worker(void)
> > > >>
> > > >> This should go in include/linux/io_uring.h and then userfaultfd wo=
uld
> > > >> not have to include io_uring private headers.
> > > >>
> > > >> But that's beside the point, like I said we still need to get to t=
he
> > > >> bottom of what is going on here first, rather than try and paper a=
round
> > > >> it. So please don't post more versions of this before we have that
> > > >> understanding.
> > > >>
> > > >> See previous emails on 6.8 and other kernel versions.
> > > >>
> > > >> --
> > > >> Jens Axboe
> > > > The issue did not involve creating new worker processes. Instead, t=
he
> > > > existing IOU worker kernel threads (about a dozen) associated with =
the VM
> > > > process were fully utilizing CPU without writing data, caused by a =
fault
> > > > while reading user data pages in the fault_in_iov_iter_readable fun=
ction
> > > > when pulling user memory into kernel space.
> > >
> > > OK that makes more sense, I can certainly reproduce a loop in this pa=
th:
> > >
> > > iou-wrk-726     729    36.910071:       9737 cycles:P:
> > >         ffff800080456c44 handle_userfault+0x47c
> > >         ffff800080381fc0 hugetlb_fault+0xb68
> > >         ffff80008031fee4 handle_mm_fault+0x2fc
> > >         ffff8000812ada6c do_page_fault+0x1e4
> > >         ffff8000812ae024 do_translation_fault+0x9c
> > >         ffff800080049a9c do_mem_abort+0x44
> > >         ffff80008129bd78 el1_abort+0x38
> > >         ffff80008129ceb4 el1h_64_sync_handler+0xd4
> > >         ffff8000800112b4 el1h_64_sync+0x6c
> > >         ffff80008030984c fault_in_readable+0x74
> > >         ffff800080476f3c iomap_file_buffered_write+0x14c
> > >         ffff8000809b1230 blkdev_write_iter+0x1a8
> > >         ffff800080a1f378 io_write+0x188
> > >         ffff800080a14f30 io_issue_sqe+0x68
> > >         ffff800080a155d0 io_wq_submit_work+0xa8
> > >         ffff800080a32afc io_worker_handle_work+0x1f4
> > >         ffff800080a332b8 io_wq_worker+0x110
> > >         ffff80008002dd38 ret_from_fork+0x10
> > >
> > > which seems to be expected, we'd continually try and fault in the
> > > ranges, if the userfaultfd handler isn't filling them.
> > >
> > > I guess this is where I'm still confused, because I don't see how thi=
s
> > > is different from if you have a normal write(2) syscall doing the sam=
e
> > > thing - you'd get the same looping.
> > >
> > > ??
> > >
> > > > This issue occurs like during VM snapshot loading (which uses
> > > > userfaultfd for on-demand memory loading), while the task in the gu=
est is
> > > > writing data to disk.
> > > >
> > > > Normally, the VM first triggers a user fault to fill the page table=
.
> > > > So in the IOU worker thread, the page tables are already filled,
> > > > fault no chance happens when faulting in memory pages
> > > > in fault_in_iov_iter_readable.
> > > >
> > > > I suspect that during snapshot loading, a memory access in the
> > > > VM triggers an async page fault handled by the kernel thread,
> > > > while the IOU worker's async kernel thread is also running.
> > > > Maybe If the IOU worker's thread is scheduled first.
> > > > I?m going to bed now.
> > >
> > > Ah ok, so what you're saying is that because we end up not sleeping
> > > (because a signal is pending, it seems), then the fault will never ge=
t
> > > filled and hence progress not made? And the signal is pending because
> > > someone tried to create a net worker, and this work is not getting
> > > processed.
> > >
> > > --
> > > Jens Axboe
> >         handle_userfault() {
> >           hugetlb_vma_lock_read();
> >           _raw_spin_lock_irq() {
> >             __pv_queued_spin_lock_slowpath();
> >           }
> >           vma_mmu_pagesize() {
> >             hugetlb_vm_op_pagesize();
> >           }
> >           huge_pte_offset();
> >           hugetlb_vma_unlock_read();
> >           up_read();
> >           __wake_up() {
> >             _raw_spin_lock_irqsave() {
> >               __pv_queued_spin_lock_slowpath();
> >             }
> >             __wake_up_common();
> >             _raw_spin_unlock_irqrestore();
> >           }
> >           schedule() {
> >             io_wq_worker_sleeping() {
> >               io_wq_dec_running();
> >             }
> >             rcu_note_context_switch();
> >             raw_spin_rq_lock_nested() {
> >               _raw_spin_lock();
> >             }
> >             update_rq_clock();
> >             pick_next_task() {
> >               pick_next_task_fair() {
> >                 update_curr() {
> >                   update_curr_se();
> >                   __calc_delta.constprop.0();
> >                   update_min_vruntime();
> >                 }
> >                 check_cfs_rq_runtime();
> >                 pick_next_entity() {
> >                   pick_eevdf();
> >                 }
> >                 update_curr() {
> >                   update_curr_se();
> >                   __calc_delta.constprop.0();
> >                   update_min_vruntime();
> >                 }
> >                 check_cfs_rq_runtime();
> >                 pick_next_entity() {
> >                   pick_eevdf();
> >                 }
> >                 update_curr() {
> >                   update_curr_se();
> >                   update_min_vruntime();
> >                   cpuacct_charge();
> >                   __cgroup_account_cputime() {
> >                     cgroup_rstat_updated();
> >                   }
> >                 }
> >                 check_cfs_rq_runtime();
> >                 pick_next_entity() {
> >                   pick_eevdf();
> >                 }
> >               }
> >             }
> >             raw_spin_rq_unlock();
> >             io_wq_worker_running();
> >           }
> >           _raw_spin_lock_irq() {
> >             __pv_queued_spin_lock_slowpath();
> >           }
> >           userfaultfd_ctx_put();
> >         }
> >       }
> > The execution flow above is the one that kept faulting
> > repeatedly in the IOU worker during the issue. The entire fault path,
> > including this final userfault handling code you're seeing, would be
> > triggered in an infinite loop. That's why I traced and found that the
> > io_wq_worker_running() function returns early, causing the flow to
> > differ from a normal user fault, where it should be sleeping.
> >
> > However, your call stack appears to behave normally,
> > which makes me curious about what's different about execution flow.
> > Would you be able to share your test case code so I can study it
> > and try to reproduce the behavior on my side?
Sorry, I may have misunderstood. I thought your test case
was working correctly. In io_wq_worker_running() it will return
if in io worker context, that is different from common progress
context.I hope the graph above can help you understand.

Also, regarding your initial suggestion to move the function into
include/linux/io_uring.h,I=E2=80=99m not sure that=E2=80=99s the best fit =
=E2=80=94 the
problematic context (io_wq_worker) and the function needing changes
 (io_wq_worker_running) are both heavily tied to the internals of io-wq.
I=E2=80=99m wondering if doing something like #include "../../io_uring/io-w=
q.h"
as in kernel/sched/core.c:96 might actually be a better choice here?

And I=E2=80=99d still really appreciate it if you could share your test cas=
e code
 it would help a lot. Thanks!

