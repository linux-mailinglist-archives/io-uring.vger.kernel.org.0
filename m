Return-Path: <io-uring+bounces-7644-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78632A97D04
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 04:50:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 505A2189C7CD
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 02:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47337263C8A;
	Wed, 23 Apr 2025 02:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SlBLS/vx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC084A06;
	Wed, 23 Apr 2025 02:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745376602; cv=none; b=ZK58Tr07EC9U7NW6MqJo9Nkri/M1Wd4sC73aa6/Ur+wdJKflsyaMHy54a5UqvP3Q8YogFUpQMHHNzNJuPWiJ/xWmodJtxUoGT5dGaNNALBucmHPitwOmJ1g1hONkRwN7h/zV02U9hCCcE0l52IAOj/TTdsfBvkVBbsuN3JFyLYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745376602; c=relaxed/simple;
	bh=NetMLvhwolF2S3mIJOhea42N51HYW+rhDqaQyyMWBek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Opk6CV1P54cLdew1wRX2qsH2Beg6BIhhNE0qvIjf0mX6YFe/Cp/lrVgDddAnpyQi33XN6vAeCpg9VrMq6F2H9k95mNwssT8p8VbKM+t8oI4ihA7TJ/J9rdDhq2bPZm5v7khkctBEPXqVT1+y5LHOqQEI/uDTNJnZXVTQJNGmf5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SlBLS/vx; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-601a8b6c133so262617eaf.1;
        Tue, 22 Apr 2025 19:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745376599; x=1745981399; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aSu+pf0KYpfeh0JO63IUt/4r9CyD732VsqOE26NueLI=;
        b=SlBLS/vxrPbyYsFfX5YmuQTCsRrUrqN9I6/9mN6RvVm9z4HW83PuU28MHv5aK3b3iZ
         rSOiRpOy5DE/vFTDxVzU9SM4t/f3d+6rEMfTzLHfPfiZ7HYy3wP3iYvBe7/9eSkmJlGb
         e+ZezHt3glHTTN81nPDxdeatrON9uRf1dQO/EDf+HrLy5YxzuUWauay4Zvv4N9773EBW
         ruTgQHBWjem6n0mqEnLG06ypuUnO+At9CqESQYwK7RrX9ATF9/OqgkEAN/uW5+ETFp4y
         U5Ca3UwmUlprt1JAYew9PdEY5fgBA8iOcXPcVeVPZDJn+nRuJfol/NTvnz1ZrcGtinp9
         ldkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745376599; x=1745981399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aSu+pf0KYpfeh0JO63IUt/4r9CyD732VsqOE26NueLI=;
        b=SuN2F4rTJpK1TqmVs5bFUWDAWjjjcUvFCNxdVZFVa4c7837B4vipsxMxeoZhRZhG6U
         b1ZiVtPxlC5bITt/Yl28VRClryEMpmXi67qRjpm26N9bhvC4aeSDNaLZO314HTOf5zr/
         ORAVmQUsNq6RYbjn0h5XkYUVHSPAPYyOija7aTVLS0rLzFjtqfFK4xlTj8GBxSNSc8yw
         zQOhGDcEf5V7wAvET5v5D0Ut4HwF6oLB7avw3LXqWtD1kctsMTa0tRLrO405IVRlwoYV
         z/0rBlATa5by8wEqYFh552h9/Ge3269DMXg7KxZ68eNV35/vpJkV6HWB+Z/BGkHqQhgE
         l5Kw==
X-Forwarded-Encrypted: i=1; AJvYcCUl/69ktDtbcDgjG3e23PveD/Uhu7G3EhAM9fp0mAF2a+pTKc7kLdvBHkuGFanPTDPH/BesgC0qh7v1D6cR@vger.kernel.org, AJvYcCVJHxzmWAE14qdrVxLOMrhBI8WM+/9uKnUJpaYOrkjUSyOkiJvt0etW2+V94//DS/vbtfdBJvzWeg==@vger.kernel.org, AJvYcCWwfLYqUugrYwB88ZBfv+E6O52dR9Ph9OZCqz+NZzZVxtwD9Zch3Whnv8W+/a3CN2uSe8gZ6ixlXyk5hkmKIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwR3m+xdfGYQEsnG8fH58nxL07tGpAQ/09z36BO26n3xpLYmpKR
	NI8cyT7K7vKosKCTTlI90AbDsFOVnfnl3mQudcxOK21aZthRnAJGyONRrEnCBDXLKxZWc9vfALw
	8QcgXsMD1MDIwcgYnih2m1RGBJ74=
X-Gm-Gg: ASbGncsm3QzYN0r588TnHCBJWayq8Je9fxA1LcwVqPm+hQK+meOd0QUfzRiv7APBh+Y
	ljV9BlO43+LyJEI/v64CqJLibSwcdC4CAMwZLQBjc3OAo5BLvpBeUXCNZIxwaNJ2inDsHMHqetM
	fNVIsDpT/vWCJFaK423oVV/bY=
X-Google-Smtp-Source: AGHT+IHnspHIf/BWSKvgnsUQ0frS+igiTjJx9QOaB5iml44SDzeGlHt+6vO4QDQnQ7ghczJ6JeKcS3CVhsd9vHdEBVw=
X-Received: by 2002:a05:6870:704b:10b0:2c1:4d18:383a with SMTP id
 586e51a60fabf-2d5f91394bfmr576794fac.3.1745376599286; Tue, 22 Apr 2025
 19:49:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422162913.1242057-1-qq282012236@gmail.com>
 <20250422162913.1242057-2-qq282012236@gmail.com> <14195206-47b1-4483-996d-3315aa7c33aa@kernel.dk>
 <CANHzP_uW4+-M1yTg-GPdPzYWAmvqP5vh6+s1uBhrMZ3eBusLug@mail.gmail.com> <b61ac651-fafe-449a-82ed-7239123844e1@kernel.dk>
In-Reply-To: <b61ac651-fafe-449a-82ed-7239123844e1@kernel.dk>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Wed, 23 Apr 2025 10:49:46 +0800
X-Gm-Features: ATxdqUE_qKZz54c5VFiqkyU5GhjetlCjpBX_oWwUivoDc1gIIcxTDbz0DUzXhj4
Message-ID: <CANHzP_tLV29_uk2gcRAjT9sJNVPH3rMyVuQP07q+c_TWWgsfDg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault scenarios
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025 at 1:33=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/22/25 11:04 AM, ??? wrote:
> > On Wed, Apr 23, 2025 at 12:32?AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 4/22/25 10:29 AM, Zhiwei Jiang wrote:
> >>> diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
> >>> index d4fb2940e435..8567a9c819db 100644
> >>> --- a/io_uring/io-wq.h
> >>> +++ b/io_uring/io-wq.h
> >>> @@ -70,8 +70,10 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq=
, work_cancel_fn *cancel,
> >>>                                       void *data, bool cancel_all);
> >>>
> >>>  #if defined(CONFIG_IO_WQ)
> >>> -extern void io_wq_worker_sleeping(struct task_struct *);
> >>> -extern void io_wq_worker_running(struct task_struct *);
> >>> +extern void io_wq_worker_sleeping(struct task_struct *tsk);
> >>> +extern void io_wq_worker_running(struct task_struct *tsk);
> >>> +extern void set_userfault_flag_for_ioworker(void);
> >>> +extern void clear_userfault_flag_for_ioworker(void);
> >>>  #else
> >>>  static inline void io_wq_worker_sleeping(struct task_struct *tsk)
> >>>  {
> >>> @@ -79,6 +81,12 @@ static inline void io_wq_worker_sleeping(struct ta=
sk_struct *tsk)
> >>>  static inline void io_wq_worker_running(struct task_struct *tsk)
> >>>  {
> >>>  }
> >>> +static inline void set_userfault_flag_for_ioworker(void)
> >>> +{
> >>> +}
> >>> +static inline void clear_userfault_flag_for_ioworker(void)
> >>> +{
> >>> +}
> >>>  #endif
> >>>
> >>>  static inline bool io_wq_current_is_worker(void)
> >>
> >> This should go in include/linux/io_uring.h and then userfaultfd would
> >> not have to include io_uring private headers.
> >>
> >> But that's beside the point, like I said we still need to get to the
> >> bottom of what is going on here first, rather than try and paper aroun=
d
> >> it. So please don't post more versions of this before we have that
> >> understanding.
> >>
> >> See previous emails on 6.8 and other kernel versions.
> >>
> >> --
> >> Jens Axboe
> > The issue did not involve creating new worker processes. Instead, the
> > existing IOU worker kernel threads (about a dozen) associated with the =
VM
> > process were fully utilizing CPU without writing data, caused by a faul=
t
> > while reading user data pages in the fault_in_iov_iter_readable functio=
n
> > when pulling user memory into kernel space.
>
> OK that makes more sense, I can certainly reproduce a loop in this path:
>
> iou-wrk-726     729    36.910071:       9737 cycles:P:
>         ffff800080456c44 handle_userfault+0x47c
>         ffff800080381fc0 hugetlb_fault+0xb68
>         ffff80008031fee4 handle_mm_fault+0x2fc
>         ffff8000812ada6c do_page_fault+0x1e4
>         ffff8000812ae024 do_translation_fault+0x9c
>         ffff800080049a9c do_mem_abort+0x44
>         ffff80008129bd78 el1_abort+0x38
>         ffff80008129ceb4 el1h_64_sync_handler+0xd4
>         ffff8000800112b4 el1h_64_sync+0x6c
>         ffff80008030984c fault_in_readable+0x74
>         ffff800080476f3c iomap_file_buffered_write+0x14c
>         ffff8000809b1230 blkdev_write_iter+0x1a8
>         ffff800080a1f378 io_write+0x188
>         ffff800080a14f30 io_issue_sqe+0x68
>         ffff800080a155d0 io_wq_submit_work+0xa8
>         ffff800080a32afc io_worker_handle_work+0x1f4
>         ffff800080a332b8 io_wq_worker+0x110
>         ffff80008002dd38 ret_from_fork+0x10
>
> which seems to be expected, we'd continually try and fault in the
> ranges, if the userfaultfd handler isn't filling them.
>
> I guess this is where I'm still confused, because I don't see how this
> is different from if you have a normal write(2) syscall doing the same
> thing - you'd get the same looping.
>
> ??
>
> > This issue occurs like during VM snapshot loading (which uses
> > userfaultfd for on-demand memory loading), while the task in the guest =
is
> > writing data to disk.
> >
> > Normally, the VM first triggers a user fault to fill the page table.
> > So in the IOU worker thread, the page tables are already filled,
> > fault no chance happens when faulting in memory pages
> > in fault_in_iov_iter_readable.
> >
> > I suspect that during snapshot loading, a memory access in the
> > VM triggers an async page fault handled by the kernel thread,
> > while the IOU worker's async kernel thread is also running.
> > Maybe If the IOU worker's thread is scheduled first.
> > I?m going to bed now.
>
> Ah ok, so what you're saying is that because we end up not sleeping
> (because a signal is pending, it seems), then the fault will never get
> filled and hence progress not made? And the signal is pending because
> someone tried to create a net worker, and this work is not getting
> processed.
>
> --
> Jens Axboe
        handle_userfault() {
          hugetlb_vma_lock_read();
          _raw_spin_lock_irq() {
            __pv_queued_spin_lock_slowpath();
          }
          vma_mmu_pagesize() {
            hugetlb_vm_op_pagesize();
          }
          huge_pte_offset();
          hugetlb_vma_unlock_read();
          up_read();
          __wake_up() {
            _raw_spin_lock_irqsave() {
              __pv_queued_spin_lock_slowpath();
            }
            __wake_up_common();
            _raw_spin_unlock_irqrestore();
          }
          schedule() {
            io_wq_worker_sleeping() {
              io_wq_dec_running();
            }
            rcu_note_context_switch();
            raw_spin_rq_lock_nested() {
              _raw_spin_lock();
            }
            update_rq_clock();
            pick_next_task() {
              pick_next_task_fair() {
                update_curr() {
                  update_curr_se();
                  __calc_delta.constprop.0();
                  update_min_vruntime();
                }
                check_cfs_rq_runtime();
                pick_next_entity() {
                  pick_eevdf();
                }
                update_curr() {
                  update_curr_se();
                  __calc_delta.constprop.0();
                  update_min_vruntime();
                }
                check_cfs_rq_runtime();
                pick_next_entity() {
                  pick_eevdf();
                }
                update_curr() {
                  update_curr_se();
                  update_min_vruntime();
                  cpuacct_charge();
                  __cgroup_account_cputime() {
                    cgroup_rstat_updated();
                  }
                }
                check_cfs_rq_runtime();
                pick_next_entity() {
                  pick_eevdf();
                }
              }
            }
            raw_spin_rq_unlock();
            io_wq_worker_running();
          }
          _raw_spin_lock_irq() {
            __pv_queued_spin_lock_slowpath();
          }
          userfaultfd_ctx_put();
        }
      }
The execution flow above is the one that kept faulting
repeatedly in the IOU worker during the issue. The entire fault path,
including this final userfault handling code you're seeing, would be
triggered in an infinite loop. That's why I traced and found that the
io_wq_worker_running() function returns early, causing the flow to
differ from a normal user fault, where it should be sleeping.

However, your call stack appears to behave normally,
which makes me curious about what's different about execution flow.
Would you be able to share your test case code so I can study it
and try to reproduce the behavior on my side?

