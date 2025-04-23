Return-Path: <io-uring+bounces-7667-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD65A98D1F
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 16:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F124D165F18
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 14:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9730A27A108;
	Wed, 23 Apr 2025 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6Ivnf/p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E0817555;
	Wed, 23 Apr 2025 14:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745418596; cv=none; b=c91dsHs1IlQ/aXD8HHxXs8DfBI/T7VA46RhFo4wN0jXsIeobORC8pkXF0OqcNiz8xDurMzRo7rujMe8ECKiy3jql+IAue4ArO/CFDjAqnpsivaXDU+25adR8wMHaLeqQZ1QwVzpnbZ2z6DFL5C4WRrB+NjRUlY+BE9BDnsL00qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745418596; c=relaxed/simple;
	bh=r8jAqmLZbNO01NxVCNrFgFdl7VRLWQxQUMhZ7S/MX0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OSJSYDHRM6Kc90MXv+5JIhEBEuCR9Gi8z0/3ZuLD9qxPLEElFw6b2bl3/IjG9XcmZWm13XOEiXWJ7dfwfmeQYjA42HWbvK7QIW9JTHt8jWZz0RiPBU+kFLloM4sBjSh1SyOiPq36dm77e4gsPhcpm3CAitnX9FcolRyVvJrlsNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B6Ivnf/p; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-2d0e86cd5b1so3639286fac.3;
        Wed, 23 Apr 2025 07:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745418594; x=1746023394; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vAmiNRPfDylXI4p2I89n/el3RsJ4kbOsDdMQamDJ/lU=;
        b=B6Ivnf/pisUqm/TkWt8aIRDvYnRwFl3bup5yNk+/x595+hj+3ukkTpC1JUAcBAMpyf
         11Wl7XOabk/30Kq4sQemCywaI2BZl2fCKm/1mIGEoiNyfqH10IEAQMoz07uuQJEiERfp
         hilQ/MfxVBDBP+wzt79HUL4d4vjH81g8XFuwHgE2/f975hJdlSqXUeD+7fGrEHPUcZyS
         SjFt4G7h1ceWP82AGdKpCyyJrT0pLLAzqzYXszPGxri372skk+wkzKdOz9AIUDg0FCU2
         gBU6YgaSKmmJ8dSkY4OETObDJ4SZSVaauchU9vSLTKKuTq+6jC1r3tK9xvjWRbyPuDDO
         Sj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745418594; x=1746023394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vAmiNRPfDylXI4p2I89n/el3RsJ4kbOsDdMQamDJ/lU=;
        b=g7595jDhQ1BJbYHjL6CVEqG7Fse95PdHpayqov7cpJyPwCow8CBg+xjhTUA/Ah563u
         imNrnJmfTWv+l7gaeW83yy5AXuAx8laFgpOB7ZF6Fxg2IhxUmqqQp4unKwx+EyLT2EpY
         /wrUOltJe1bWifwcLg9WpxKf9qltN+3Mj8fCTyXJYELXXxuapIyJjWb9+nDiWGX1fNzC
         1KI5FV5n+TldaAokwLzulSMeEx2Bfurlojrf1cGLhKKRcD2aOjk9SPva+QcfaBiuAcwi
         2uSwlAkrnicaz0DBYUljkvdXUPsuJfiOLHWasQixanxbWTFf79wQP9M+PhC2PtzCQFBw
         1Dzw==
X-Forwarded-Encrypted: i=1; AJvYcCVjvuoc2GIMCT97nvl1uRWlsmZiLImd5Ofm1YQV1PUyV9bYqkhQmZ6AXMncigGQgvKmgH0q4ueNrjmqUdQYXw==@vger.kernel.org, AJvYcCXTZ4+l7GHaBZh+V8hAjqUgAKIbOBuNoN62PvYqn870m9IZr9jRxRU0HhQilvEhW/AqlKnMIZcYwg==@vger.kernel.org, AJvYcCXkexdDUcIPZ6K+3Ns/NPZxluL9gCvgkLlXCgpms1mkpbtRzooBU8b7esWuaBG2hwkqYAVYj8h5sgIycehD@vger.kernel.org
X-Gm-Message-State: AOJu0YxcVzdVIMFz5NpjrQRtifAbvVBVCDTFzUf8FZAaFIbj1oBU0L/d
	voNXWCaDMizQBfgqg2WB97Npn7E7KVpdP4yCY3BsbQ7pVmLi3yJIF0mRwABSjhk96/+58Kkgxmz
	38eQR2sB9b7mJXRnLBj46qAItu38=
X-Gm-Gg: ASbGncssZ5qotGKvHeWsYnqbXPfQwjcLJB9Ab/Yy9Nn8/an6NGLqKga0ZyIgi9xQi84
	rE5olfWMgBNWFQ0MAOzNTkc2G6Gsz0IrYV7oLmnJu/KxIDV6y5YNs1LRsfbtNo+T5CdQ2BszLua
	YD7cKiJ2wffMj0fg1pSsnkiJk=
X-Google-Smtp-Source: AGHT+IG/83Vm9P2qTMF2EymMFKDXet9s/AZitDACbuc3Nu8TMbhGwbGeWoz11uK69jP/+KGgtXg1R2c2Y0EWUlyBaZc=
X-Received: by 2002:a05:6871:400b:b0:2d4:d9d6:c8cf with SMTP id
 586e51a60fabf-2d526973ecamr11685729fac.5.1745418593659; Wed, 23 Apr 2025
 07:29:53 -0700 (PDT)
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
 <7bea9c74-7551-4312-bece-86c4ad5c982f@kernel.dk>
In-Reply-To: <7bea9c74-7551-4312-bece-86c4ad5c982f@kernel.dk>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Wed, 23 Apr 2025 22:29:39 +0800
X-Gm-Features: ATxdqUEhnCv--36VUKzk9XOpQWOK0vKQGChSsvOwX9Wb21JeSMSuWP0HeyDRE1U
Message-ID: <CANHzP_ui_TEPvr6wkWr42j46Sk5qHzZ+p0oo06BrNny52dPK9Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault scenarios
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2025=E5=B9=B44=E6=9C=8823=E6=97=A5=E5=
=91=A8=E4=B8=89 21:34=E5=86=99=E9=81=93=EF=BC=9A
>
> On 4/22/25 8:49 PM, ??? wrote:
> > On Wed, Apr 23, 2025 at 1:33?AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 4/22/25 11:04 AM, ??? wrote:
> >>> On Wed, Apr 23, 2025 at 12:32?AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 4/22/25 10:29 AM, Zhiwei Jiang wrote:
> >>>>> diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
> >>>>> index d4fb2940e435..8567a9c819db 100644
> >>>>> --- a/io_uring/io-wq.h
> >>>>> +++ b/io_uring/io-wq.h
> >>>>> @@ -70,8 +70,10 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *=
wq, work_cancel_fn *cancel,
> >>>>>                                       void *data, bool cancel_all);
> >>>>>
> >>>>>  #if defined(CONFIG_IO_WQ)
> >>>>> -extern void io_wq_worker_sleeping(struct task_struct *);
> >>>>> -extern void io_wq_worker_running(struct task_struct *);
> >>>>> +extern void io_wq_worker_sleeping(struct task_struct *tsk);
> >>>>> +extern void io_wq_worker_running(struct task_struct *tsk);
> >>>>> +extern void set_userfault_flag_for_ioworker(void);
> >>>>> +extern void clear_userfault_flag_for_ioworker(void);
> >>>>>  #else
> >>>>>  static inline void io_wq_worker_sleeping(struct task_struct *tsk)
> >>>>>  {
> >>>>> @@ -79,6 +81,12 @@ static inline void io_wq_worker_sleeping(struct =
task_struct *tsk)
> >>>>>  static inline void io_wq_worker_running(struct task_struct *tsk)
> >>>>>  {
> >>>>>  }
> >>>>> +static inline void set_userfault_flag_for_ioworker(void)
> >>>>> +{
> >>>>> +}
> >>>>> +static inline void clear_userfault_flag_for_ioworker(void)
> >>>>> +{
> >>>>> +}
> >>>>>  #endif
> >>>>>
> >>>>>  static inline bool io_wq_current_is_worker(void)
> >>>>
> >>>> This should go in include/linux/io_uring.h and then userfaultfd woul=
d
> >>>> not have to include io_uring private headers.
> >>>>
> >>>> But that's beside the point, like I said we still need to get to the
> >>>> bottom of what is going on here first, rather than try and paper aro=
und
> >>>> it. So please don't post more versions of this before we have that
> >>>> understanding.
> >>>>
> >>>> See previous emails on 6.8 and other kernel versions.
> >>>>
> >>>> --
> >>>> Jens Axboe
> >>> The issue did not involve creating new worker processes. Instead, the
> >>> existing IOU worker kernel threads (about a dozen) associated with th=
e VM
> >>> process were fully utilizing CPU without writing data, caused by a fa=
ult
> >>> while reading user data pages in the fault_in_iov_iter_readable funct=
ion
> >>> when pulling user memory into kernel space.
> >>
> >> OK that makes more sense, I can certainly reproduce a loop in this pat=
h:
> >>
> >> iou-wrk-726     729    36.910071:       9737 cycles:P:
> >>         ffff800080456c44 handle_userfault+0x47c
> >>         ffff800080381fc0 hugetlb_fault+0xb68
> >>         ffff80008031fee4 handle_mm_fault+0x2fc
> >>         ffff8000812ada6c do_page_fault+0x1e4
> >>         ffff8000812ae024 do_translation_fault+0x9c
> >>         ffff800080049a9c do_mem_abort+0x44
> >>         ffff80008129bd78 el1_abort+0x38
> >>         ffff80008129ceb4 el1h_64_sync_handler+0xd4
> >>         ffff8000800112b4 el1h_64_sync+0x6c
> >>         ffff80008030984c fault_in_readable+0x74
> >>         ffff800080476f3c iomap_file_buffered_write+0x14c
> >>         ffff8000809b1230 blkdev_write_iter+0x1a8
> >>         ffff800080a1f378 io_write+0x188
> >>         ffff800080a14f30 io_issue_sqe+0x68
> >>         ffff800080a155d0 io_wq_submit_work+0xa8
> >>         ffff800080a32afc io_worker_handle_work+0x1f4
> >>         ffff800080a332b8 io_wq_worker+0x110
> >>         ffff80008002dd38 ret_from_fork+0x10
> >>
> >> which seems to be expected, we'd continually try and fault in the
> >> ranges, if the userfaultfd handler isn't filling them.
> >>
> >> I guess this is where I'm still confused, because I don't see how this
> >> is different from if you have a normal write(2) syscall doing the same
> >> thing - you'd get the same looping.
> >>
> >> ??
> >>
> >>> This issue occurs like during VM snapshot loading (which uses
> >>> userfaultfd for on-demand memory loading), while the task in the gues=
t is
> >>> writing data to disk.
> >>>
> >>> Normally, the VM first triggers a user fault to fill the page table.
> >>> So in the IOU worker thread, the page tables are already filled,
> >>> fault no chance happens when faulting in memory pages
> >>> in fault_in_iov_iter_readable.
> >>>
> >>> I suspect that during snapshot loading, a memory access in the
> >>> VM triggers an async page fault handled by the kernel thread,
> >>> while the IOU worker's async kernel thread is also running.
> >>> Maybe If the IOU worker's thread is scheduled first.
> >>> I?m going to bed now.
> >>
> >> Ah ok, so what you're saying is that because we end up not sleeping
> >> (because a signal is pending, it seems), then the fault will never get
> >> filled and hence progress not made? And the signal is pending because
> >> someone tried to create a net worker, and this work is not getting
> >> processed.
> >>
> >> --
> >> Jens Axboe
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
>
> io_wq_worker_running() is called when the task is scheduled back in.
> There's no "returning early" here, it simply updates the accounting.
> Which is part of why your patch makes very little sense to me, we
> would've called both io_wq_worker_sleeping() and _running() from the
> userfaultfd path. The latter doesn't really do much, it simply just
> increments the running worker count, if the worker was previously marked
> as sleeping.
>
> And I strongly suspect that the latter is the issue, not the marking of
> running. The above loop is fine if we do go to sleep in schedule.
> However, if there's task_work (either TWA_SIGNAL or TWA_NOTIFY_SIGNAL
> based) pending, then schedule() will be a no-op and we're going to
> repeatedly go through that loop. This is because the expectation here is
> that the loop will be aborted if either of those is true, so that
> task_work can get run (or a signal handled, whatever), and then the
> operation retried.
>
> > However, your call stack appears to behave normally,
> > which makes me curious about what's different about execution flow.
> > Would you be able to share your test case code so I can study it
> > and try to reproduce the behavior on my side?
>
> It behaves normally for the initial attempt - we end up sleeping in
> schedule(). However, then a new worker gets created, or the ring
> shutdown, in which case schedule() ends up being a no-op because
> TWA_NOTIFY_SIGNAL is set, and then we just sit there in a loop running
> the same code again and again to no avail. So I do think my test case
> and your issue is the same, I just reproduce it by calling
> io_uring_queue_exit(), but the exact same thing would happen if worker
> creation is attempted while an io-wq worker is blocked
> handle_userfault().
>
> This is why I want to fully understand the issue rather than paper
> around it, as I don't think the fix is correct as-is. We really want to
> abort the loop and allow the task to handle whatever signaling is
> currently preventing proper sleeps.
>
> I'll dabble a bit more and send out the test case too, in case it'll
> help on your end.
>
> --
> Jens Axboe
I=E2=80=99m really looking forward to your test case. Also, I=E2=80=99d lik=
e to emphasize one
more point: the handle_userfault graph path I sent you, including the sched=
ule
function, is complete and unmodified. You can see that the schedule functio=
n
is very, very short. I understand your point about signal handling, but in =
this
very brief function graph, I haven=E2=80=99t yet seen any functions related=
 to signal
handling. Additionally, there is no context switch here, nor is it the situ=
ation
where the thread is being scheduled back in. Perhaps the scenario you=E2=80=
=99ve
reproduced is still different from the one I=E2=80=99ve encountered in some=
 subtle way?

void io_wq_worker_running(struct task_struct *tsk)
{
struct io_worker *worker =3D tsk->worker_private;

if (!worker)
return;
if (!test_bit(IO_WORKER_F_FAULT, &worker->flags)) {
if (!test_bit(IO_WORKER_F_UP, &worker->flags))
return;
if (test_bit(IO_WORKER_F_RUNNING, &worker->flags))
return;
set_bit(IO_WORKER_F_RUNNING, &worker->flags);
io_wq_inc_running(worker);
}
}
However, from my observation during the crash live memory analysis,
when this happens in the IOU worker thread, the
IO_WORKER_F_RUNNING flag is set. This is what I said "early return",
rather than just a simple accounting function.I look forward to your
deeper analysis and any corrections you may have.

