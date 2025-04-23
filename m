Return-Path: <io-uring+bounces-7645-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5D8A97D32
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 05:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A699A7ACD67
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 03:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF75264A73;
	Wed, 23 Apr 2025 03:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MlRfvab0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C01E264624;
	Wed, 23 Apr 2025 03:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745377880; cv=none; b=bWIR7gPk3WuaQtcNjGSPMLM94o8saUWSnmrhDmmYxfjWT711QsNMaAkMPF4ervHDLb6x2LiDF84JjD4RQiKJRCLzdbXSo0YQhvczbgdJ2DGqddIFFg7d8yKpQlEY5ecGb+ch7KcLvobwUxugEOOAF/4EaRkjPAKrKlx2HGPc4Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745377880; c=relaxed/simple;
	bh=L/ocIZqkqUP7/h8Q2tRV+uYZ3YN4zHahAMFgcLz1LtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=peIqLTZO8DkzYjcCLj9TeJWw5jIKYYqtApsfNmOkS07YQ6aXtN+pWd1yfXCzYH+qCdeLg5LNZMAelXViVpezmlvZe8bTUbSqL7nTz7yIQzuqUgQQfKBlOGdGxej5akCXzwVM8VhUZz5yUC8xpJjbbkvqW5Q9SWv8JmDGkUN1VHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MlRfvab0; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6021e3daeabso2814550eaf.3;
        Tue, 22 Apr 2025 20:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745377877; x=1745982677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4jBp+fwprmCRWnqeM4OYLiFwbjAhmTD3F9R0kIY85Ks=;
        b=MlRfvab0EXufv9EjMxaMGthtarAyORvxApRq1w0W9vFRjyfsD4IiiY1JRABQ+BCHnl
         9HGI2E64YyjFmoAc5i1yCfx7VNGxCUpsmHsngj1XMRq6XefVkhSWJYP93z/rRisSEfC3
         /9HqMfoKtha73Pss+iOqYn5iX2cn4iOxCkjBIuVnxJN84uhdoQM9wfoDr6025J8m6vkj
         7QSyJNp7xO78YIO6lBDfEsPKSGO0YNveJrthQ/tHG0+DeC2kCFcOAW1kVL3oFjTZkBTY
         b/ha5lhX4hwJQpi1p+5r72HpHa+oTEQi/zhtab53dZhKXbvFTNWHB4HsF7GZtURk3q2V
         aOtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745377877; x=1745982677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4jBp+fwprmCRWnqeM4OYLiFwbjAhmTD3F9R0kIY85Ks=;
        b=lQB2Kml/M5Tg5tnWDj4cvjQiDRFA883rq7XWobdakaM4Bk/BmLcPefpxoJ9+INm5kF
         NqFqor6oVNmXL4pYvlaJPwM/0odagv1If5AWuR1e2GUxQI/JBJa43ofv2jFpEg0BGqPK
         pc3azakf877Nb4vE7HevEjbx2o4ncVrU7T6SLUvNXEcNSSYHPzBnuYpS9BrCoVsUJfhS
         wjH+/HI4/ExKhdQ1eCcDBtQlSMbUQRWzI1eOWPfVQ7BaQ/lOrdiZFTP+1i/pcDac10g+
         djRSJ6WAVN/o+awRnl1e44YPzgwnguh3mP4H1RUxuMuncoi2UBwO363ctPrw/w+hsUZM
         7sEw==
X-Forwarded-Encrypted: i=1; AJvYcCWU82wI1tLnbbmoGRJaPnDxIyhIMATKszAOtW17Cq55wakwPnVxuN9hUIkOoHZK9JvBh0i//dxcg9kOO2wkNA==@vger.kernel.org, AJvYcCXGRb27BtIaRHmegxraGPOMgNLVyO2q6tpIJ7goxKktrrT+T5OdFjKqJ7klePGSkmO6fAFciH1vNPtFSP4Y@vger.kernel.org, AJvYcCXjks8guBbPN2Mk/tCo5giQKqA/cyAa5zJt4nIcUAyx7Dn1L1y8F0R5maHajSMGjTlUfiIit1V98g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyC6G9vT2kA8WHIj/DEe+GR1xQVRkWWUojvd+uRd4NvS0ihBQ3x
	t4mrIcXinAz53XIYELxJu3W3VeUefD3gfyaGkE8EXBVNt01mCWZ3cFYqM8jAkq54aJKT4WRSHZY
	HOkCioDPrba5Xsr/VxGGoyEboaxI=
X-Gm-Gg: ASbGncsXSpxx36bbz+dxMu0BFpAu0wqeUXedIB/TmpYxFnoNGHegl/1gkAXpVl5QoS0
	uQyswqkOlZyag5Dzpieh3GvRF2f8++MX0nMRx48Ox3EKpIu9PQsuMglMVppSIQzPUXMgT3QfTbP
	pf5DGJeh6e+59WxLZC7AX91GU=
X-Google-Smtp-Source: AGHT+IELzBIxbwzrxSKgWxgBp2+NH4falm0g82duT4apLNDnkuLYcSVkfaHKnY3oZ7SblY08QlE+IohJ6BtB95Yo4wI=
X-Received: by 2002:a05:6870:8712:b0:2c1:5674:940e with SMTP id
 586e51a60fabf-2d526caec36mr9330467fac.21.1745377877500; Tue, 22 Apr 2025
 20:11:17 -0700 (PDT)
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
In-Reply-To: <CANHzP_tLV29_uk2gcRAjT9sJNVPH3rMyVuQP07q+c_TWWgsfDg@mail.gmail.com>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Wed, 23 Apr 2025 11:11:03 +0800
X-Gm-Features: ATxdqUGtAJ3HrRY5Dk-CtuzguF293eWWSLtqRp-4gDpO4y-dLDL8Qx9qyosAXgQ
Message-ID: <CANHzP_u3zN2a_t2O+BLwgV=KJZaXtANwXVq6VVD26TvF2hFL8Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault scenarios
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, I may have misunderstood. I thought your test case
was working correctly. In io_wq_worker_running() it will return
if in io worker context, that is different from common progress
context.I hope the graph above can help you understand.

On Wed, Apr 23, 2025 at 10:49=E2=80=AFAM =E5=A7=9C=E6=99=BA=E4=BC=9F <qq282=
012236@gmail.com> wrote:
>
> On Wed, Apr 23, 2025 at 1:33=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrot=
e:
> >
> > On 4/22/25 11:04 AM, ??? wrote:
> > > On Wed, Apr 23, 2025 at 12:32?AM Jens Axboe <axboe@kernel.dk> wrote:
> > >>
> > >> On 4/22/25 10:29 AM, Zhiwei Jiang wrote:
> > >>> diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
> > >>> index d4fb2940e435..8567a9c819db 100644
> > >>> --- a/io_uring/io-wq.h
> > >>> +++ b/io_uring/io-wq.h
> > >>> @@ -70,8 +70,10 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *=
wq, work_cancel_fn *cancel,
> > >>>                                       void *data, bool cancel_all);
> > >>>
> > >>>  #if defined(CONFIG_IO_WQ)
> > >>> -extern void io_wq_worker_sleeping(struct task_struct *);
> > >>> -extern void io_wq_worker_running(struct task_struct *);
> > >>> +extern void io_wq_worker_sleeping(struct task_struct *tsk);
> > >>> +extern void io_wq_worker_running(struct task_struct *tsk);
> > >>> +extern void set_userfault_flag_for_ioworker(void);
> > >>> +extern void clear_userfault_flag_for_ioworker(void);
> > >>>  #else
> > >>>  static inline void io_wq_worker_sleeping(struct task_struct *tsk)
> > >>>  {
> > >>> @@ -79,6 +81,12 @@ static inline void io_wq_worker_sleeping(struct =
task_struct *tsk)
> > >>>  static inline void io_wq_worker_running(struct task_struct *tsk)
> > >>>  {
> > >>>  }
> > >>> +static inline void set_userfault_flag_for_ioworker(void)
> > >>> +{
> > >>> +}
> > >>> +static inline void clear_userfault_flag_for_ioworker(void)
> > >>> +{
> > >>> +}
> > >>>  #endif
> > >>>
> > >>>  static inline bool io_wq_current_is_worker(void)
> > >>
> > >> This should go in include/linux/io_uring.h and then userfaultfd woul=
d
> > >> not have to include io_uring private headers.
> > >>
> > >> But that's beside the point, like I said we still need to get to the
> > >> bottom of what is going on here first, rather than try and paper aro=
und
> > >> it. So please don't post more versions of this before we have that
> > >> understanding.
> > >>
> > >> See previous emails on 6.8 and other kernel versions.
> > >>
> > >> --
> > >> Jens Axboe
> > > The issue did not involve creating new worker processes. Instead, the
> > > existing IOU worker kernel threads (about a dozen) associated with th=
e VM
> > > process were fully utilizing CPU without writing data, caused by a fa=
ult
> > > while reading user data pages in the fault_in_iov_iter_readable funct=
ion
> > > when pulling user memory into kernel space.
> >
> > OK that makes more sense, I can certainly reproduce a loop in this path=
:
> >
> > iou-wrk-726     729    36.910071:       9737 cycles:P:
> >         ffff800080456c44 handle_userfault+0x47c
> >         ffff800080381fc0 hugetlb_fault+0xb68
> >         ffff80008031fee4 handle_mm_fault+0x2fc
> >         ffff8000812ada6c do_page_fault+0x1e4
> >         ffff8000812ae024 do_translation_fault+0x9c
> >         ffff800080049a9c do_mem_abort+0x44
> >         ffff80008129bd78 el1_abort+0x38
> >         ffff80008129ceb4 el1h_64_sync_handler+0xd4
> >         ffff8000800112b4 el1h_64_sync+0x6c
> >         ffff80008030984c fault_in_readable+0x74
> >         ffff800080476f3c iomap_file_buffered_write+0x14c
> >         ffff8000809b1230 blkdev_write_iter+0x1a8
> >         ffff800080a1f378 io_write+0x188
> >         ffff800080a14f30 io_issue_sqe+0x68
> >         ffff800080a155d0 io_wq_submit_work+0xa8
> >         ffff800080a32afc io_worker_handle_work+0x1f4
> >         ffff800080a332b8 io_wq_worker+0x110
> >         ffff80008002dd38 ret_from_fork+0x10
> >
> > which seems to be expected, we'd continually try and fault in the
> > ranges, if the userfaultfd handler isn't filling them.
> >
> > I guess this is where I'm still confused, because I don't see how this
> > is different from if you have a normal write(2) syscall doing the same
> > thing - you'd get the same looping.
> >
> > ??
> >
> > > This issue occurs like during VM snapshot loading (which uses
> > > userfaultfd for on-demand memory loading), while the task in the gues=
t is
> > > writing data to disk.
> > >
> > > Normally, the VM first triggers a user fault to fill the page table.
> > > So in the IOU worker thread, the page tables are already filled,
> > > fault no chance happens when faulting in memory pages
> > > in fault_in_iov_iter_readable.
> > >
> > > I suspect that during snapshot loading, a memory access in the
> > > VM triggers an async page fault handled by the kernel thread,
> > > while the IOU worker's async kernel thread is also running.
> > > Maybe If the IOU worker's thread is scheduled first.
> > > I?m going to bed now.
> >
> > Ah ok, so what you're saying is that because we end up not sleeping
> > (because a signal is pending, it seems), then the fault will never get
> > filled and hence progress not made? And the signal is pending because
> > someone tried to create a net worker, and this work is not getting
> > processed.
> >
> > --
> > Jens Axboe
>         handle_userfault() {
>           hugetlb_vma_lock_read();
>           _raw_spin_lock_irq() {
>             __pv_queued_spin_lock_slowpath();
>           }
>           vma_mmu_pagesize() {
>             hugetlb_vm_op_pagesize();
>           }
>           huge_pte_offset();
>           hugetlb_vma_unlock_read();
>           up_read();
>           __wake_up() {
>             _raw_spin_lock_irqsave() {
>               __pv_queued_spin_lock_slowpath();
>             }
>             __wake_up_common();
>             _raw_spin_unlock_irqrestore();
>           }
>           schedule() {
>             io_wq_worker_sleeping() {
>               io_wq_dec_running();
>             }
>             rcu_note_context_switch();
>             raw_spin_rq_lock_nested() {
>               _raw_spin_lock();
>             }
>             update_rq_clock();
>             pick_next_task() {
>               pick_next_task_fair() {
>                 update_curr() {
>                   update_curr_se();
>                   __calc_delta.constprop.0();
>                   update_min_vruntime();
>                 }
>                 check_cfs_rq_runtime();
>                 pick_next_entity() {
>                   pick_eevdf();
>                 }
>                 update_curr() {
>                   update_curr_se();
>                   __calc_delta.constprop.0();
>                   update_min_vruntime();
>                 }
>                 check_cfs_rq_runtime();
>                 pick_next_entity() {
>                   pick_eevdf();
>                 }
>                 update_curr() {
>                   update_curr_se();
>                   update_min_vruntime();
>                   cpuacct_charge();
>                   __cgroup_account_cputime() {
>                     cgroup_rstat_updated();
>                   }
>                 }
>                 check_cfs_rq_runtime();
>                 pick_next_entity() {
>                   pick_eevdf();
>                 }
>               }
>             }
>             raw_spin_rq_unlock();
>             io_wq_worker_running();
>           }
>           _raw_spin_lock_irq() {
>             __pv_queued_spin_lock_slowpath();
>           }
>           userfaultfd_ctx_put();
>         }
>       }
> The execution flow above is the one that kept faulting
> repeatedly in the IOU worker during the issue. The entire fault path,
> including this final userfault handling code you're seeing, would be
> triggered in an infinite loop. That's why I traced and found that the
> io_wq_worker_running() function returns early, causing the flow to
> differ from a normal user fault, where it should be sleeping.
>
> However, your call stack appears to behave normally,
> which makes me curious about what's different about execution flow.
> Would you be able to share your test case code so I can study it
> and try to reproduce the behavior on my side?

