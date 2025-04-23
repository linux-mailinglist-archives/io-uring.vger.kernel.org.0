Return-Path: <io-uring+bounces-7681-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 612C1A9982E
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 20:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 002FE5A32AD
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 18:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9951428EA5E;
	Wed, 23 Apr 2025 18:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="x3YJ1sQt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0A221FF3D
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 18:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745434516; cv=none; b=B+lN8lfhIfH0cDfTwIpGaow3Di+hzna9G4+wtgJIzlj7smDp3tSDrWsSSnDshsD6hpkzVlUPB8WSQI0RfOdPP0fo3q5zHVaCcAIYppv9x8lhf6OHnmaFTJ7+ejtV0Y/RqpUpJyQPySUq5gQxqOaVAouIlcraR1jyYUkbl+/s7CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745434516; c=relaxed/simple;
	bh=7Cc1qPEIM2+wEuxI5WRTmzZQjflnb3MWFMvfdgIRMrw=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:Cc:
	 References:In-Reply-To; b=OZM9DIm/yEZnQT3lddEV7xykHYh7Sz7wYHB/lqnaz16tr3lwUy/3WMqxRGA3O3L9RruuXmNwZ1n5YiJUaDADQLDa3Vwy35n3qdW3r/HPpRDvTitzgdUEglLxXCC/V+5u9GIz6+YXSMaeznkz+Uj1APnomn15t2LnyhbYtfyBVR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=x3YJ1sQt; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d5eb0ec2bdso825575ab.2
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 11:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745434512; x=1746039312; darn=vger.kernel.org;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q45g8yIKt+XT6BYpPHcf4UUatZQhL10uBmB6c2Y20Z4=;
        b=x3YJ1sQtvrZFsCwGWzf/NwlttZY+f6tBMeY7b9ue9IKPoQerUfxgSLqJgyZ5NnNAfx
         2r9wif0XqdhO8cMeeen+LIsB46Gqi+j6AOCD7IIPYUJ0PoMhJtlVOfVpDFBk056WryWz
         Ljynu5xk8ohcjl+zaKhL5uyoNd5B8uNjkvINuCu8xTmww5AAp7DrIc6scXwH9eOVdlOf
         L5rm2NpBKSR0yjUPPuu318plV3obP5QtGUxR9UcXfYr4NhnUQx8Ra4PF6MLgW0nHg5Am
         IHQDdaN4cFDVE1RI0g0XgSVMeddC4TvNc0d9liL8kEpX9Fcoyz1eqZIS3gk23uqAFQtZ
         VOZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745434512; x=1746039312;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q45g8yIKt+XT6BYpPHcf4UUatZQhL10uBmB6c2Y20Z4=;
        b=krZB4D27IY2YRjR3cZmWvzaDw/I0VCMvmcF5GW4xfzNSe6kiZUbSXTB6/8nyHT50Ax
         Z7cYKm7hNrElzLzW9G4ZHYicek1U+ynpi365Wu8Z6lbQmEGyUrACfcJf95EG1FlnH4tl
         FRq5lHBNak9HW28UBAxK6ATLnLtwNqJqvHdwGt37giohQm3yevv5enCs1VNi1lzdjqiD
         7VZoFyR084qLRQ41NQTYan79pH2kEY4mHD++1KroMTwbNgj8nX6Aqr0Vox5fzCVnIP1K
         51aT2c1GVUin0/HxcNeRpc8dUC8an6bJ6J+gr2pmay37yb7f/rfHH6eR0ndaBPDKW9jw
         BJ7g==
X-Forwarded-Encrypted: i=1; AJvYcCWWzSa/0wza9/2BStAPFi3cx8JdN81avdd5P5dOqWlZ5KPNMs7ofM9n8PR6u3glXjvEUf0b5OB1BQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPavH+mb9EgDpgJgs8mfApjhb2YRbpWXkunLkauB3jNtraRjOF
	TNRJPnEApt/54PgQZYhi91Z7zbvbwFnlTJDeTbb3ki0s4MS6pVvlBcLWfX96n8Y=
X-Gm-Gg: ASbGncsDQA8vuJ2wezK8m+77QLh1Q+dXbATM3FU8bGTtStjxuW5OGZd+6svG05DLTKM
	hHfFuvBcQWXvysKbl7WXjFAZm60LBLEiu4Fs/m/AWY5ojbAnUOhdkDO6UoFDdmXLaa+Q1EWkH5a
	ZQVbAPOwNXpVtwGLcOKz5NqfdxwbpuOs3E/llOhZFz8Sv003+p/cr2RdtZn2Lazm/3XU4KzXAQY
	gNmszb2WFzNn3ox4ggRbmdG7jg8zQ9kQEo/nhlXGpEXBhmdLGJPyrdahISFp8xtkUUZ6DtdfohO
	NJ9m5cO35aZGTvmFaF+jtrFGjAZjTg+SdDHz
X-Google-Smtp-Source: AGHT+IE0ngYlwmKwtlrHafkxSZKBLR7SWbSU4ddU2IBv1qLhP9xxHKcjrwnzHLg3RpbBf9acB39Zkg==
X-Received: by 2002:a05:6e02:1b0b:b0:3d8:1d7c:e180 with SMTP id e9e14a558f8ab-3d88ed8e8e0mr209743185ab.6.1745434512449;
        Wed, 23 Apr 2025 11:55:12 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a3958edbsm2959247173.115.2025.04.23.11.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 11:55:11 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------Rtfq7maOjRQ8KE7c6kd7Vtad"
Message-ID: <3d4c5ca8-12f2-4525-8503-f34839ac7099@kernel.dk>
Date: Wed, 23 Apr 2025 12:55:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault
 scenarios
From: Jens Axboe <axboe@kernel.dk>
To: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20250422162913.1242057-1-qq282012236@gmail.com>
 <20250422162913.1242057-2-qq282012236@gmail.com>
 <14195206-47b1-4483-996d-3315aa7c33aa@kernel.dk>
 <CANHzP_uW4+-M1yTg-GPdPzYWAmvqP5vh6+s1uBhrMZ3eBusLug@mail.gmail.com>
 <b61ac651-fafe-449a-82ed-7239123844e1@kernel.dk>
 <CANHzP_tLV29_uk2gcRAjT9sJNVPH3rMyVuQP07q+c_TWWgsfDg@mail.gmail.com>
 <7bea9c74-7551-4312-bece-86c4ad5c982f@kernel.dk>
 <CANHzP_ui_TEPvr6wkWr42j46Sk5qHzZ+p0oo06BrNny52dPK9Q@mail.gmail.com>
 <bc80036e-2bca-481a-9901-c570d65ad960@kernel.dk>
Content-Language: en-US
In-Reply-To: <bc80036e-2bca-481a-9901-c570d65ad960@kernel.dk>

This is a multi-part message in MIME format.
--------------Rtfq7maOjRQ8KE7c6kd7Vtad
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/23/25 9:10 AM, Jens Axboe wrote:
> On 4/23/25 8:29 AM, ??? wrote:
>> Jens Axboe <axboe@kernel.dk> ?2025?4?23??? 21:34???
>>>
>>> On 4/22/25 8:49 PM, ??? wrote:
>>>> On Wed, Apr 23, 2025 at 1:33?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 4/22/25 11:04 AM, ??? wrote:
>>>>>> On Wed, Apr 23, 2025 at 12:32?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>> On 4/22/25 10:29 AM, Zhiwei Jiang wrote:
>>>>>>>> diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
>>>>>>>> index d4fb2940e435..8567a9c819db 100644
>>>>>>>> --- a/io_uring/io-wq.h
>>>>>>>> +++ b/io_uring/io-wq.h
>>>>>>>> @@ -70,8 +70,10 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
>>>>>>>>                                       void *data, bool cancel_all);
>>>>>>>>
>>>>>>>>  #if defined(CONFIG_IO_WQ)
>>>>>>>> -extern void io_wq_worker_sleeping(struct task_struct *);
>>>>>>>> -extern void io_wq_worker_running(struct task_struct *);
>>>>>>>> +extern void io_wq_worker_sleeping(struct task_struct *tsk);
>>>>>>>> +extern void io_wq_worker_running(struct task_struct *tsk);
>>>>>>>> +extern void set_userfault_flag_for_ioworker(void);
>>>>>>>> +extern void clear_userfault_flag_for_ioworker(void);
>>>>>>>>  #else
>>>>>>>>  static inline void io_wq_worker_sleeping(struct task_struct *tsk)
>>>>>>>>  {
>>>>>>>> @@ -79,6 +81,12 @@ static inline void io_wq_worker_sleeping(struct task_struct *tsk)
>>>>>>>>  static inline void io_wq_worker_running(struct task_struct *tsk)
>>>>>>>>  {
>>>>>>>>  }
>>>>>>>> +static inline void set_userfault_flag_for_ioworker(void)
>>>>>>>> +{
>>>>>>>> +}
>>>>>>>> +static inline void clear_userfault_flag_for_ioworker(void)
>>>>>>>> +{
>>>>>>>> +}
>>>>>>>>  #endif
>>>>>>>>
>>>>>>>>  static inline bool io_wq_current_is_worker(void)
>>>>>>>
>>>>>>> This should go in include/linux/io_uring.h and then userfaultfd would
>>>>>>> not have to include io_uring private headers.
>>>>>>>
>>>>>>> But that's beside the point, like I said we still need to get to the
>>>>>>> bottom of what is going on here first, rather than try and paper around
>>>>>>> it. So please don't post more versions of this before we have that
>>>>>>> understanding.
>>>>>>>
>>>>>>> See previous emails on 6.8 and other kernel versions.
>>>>>>>
>>>>>>> --
>>>>>>> Jens Axboe
>>>>>> The issue did not involve creating new worker processes. Instead, the
>>>>>> existing IOU worker kernel threads (about a dozen) associated with the VM
>>>>>> process were fully utilizing CPU without writing data, caused by a fault
>>>>>> while reading user data pages in the fault_in_iov_iter_readable function
>>>>>> when pulling user memory into kernel space.
>>>>>
>>>>> OK that makes more sense, I can certainly reproduce a loop in this path:
>>>>>
>>>>> iou-wrk-726     729    36.910071:       9737 cycles:P:
>>>>>         ffff800080456c44 handle_userfault+0x47c
>>>>>         ffff800080381fc0 hugetlb_fault+0xb68
>>>>>         ffff80008031fee4 handle_mm_fault+0x2fc
>>>>>         ffff8000812ada6c do_page_fault+0x1e4
>>>>>         ffff8000812ae024 do_translation_fault+0x9c
>>>>>         ffff800080049a9c do_mem_abort+0x44
>>>>>         ffff80008129bd78 el1_abort+0x38
>>>>>         ffff80008129ceb4 el1h_64_sync_handler+0xd4
>>>>>         ffff8000800112b4 el1h_64_sync+0x6c
>>>>>         ffff80008030984c fault_in_readable+0x74
>>>>>         ffff800080476f3c iomap_file_buffered_write+0x14c
>>>>>         ffff8000809b1230 blkdev_write_iter+0x1a8
>>>>>         ffff800080a1f378 io_write+0x188
>>>>>         ffff800080a14f30 io_issue_sqe+0x68
>>>>>         ffff800080a155d0 io_wq_submit_work+0xa8
>>>>>         ffff800080a32afc io_worker_handle_work+0x1f4
>>>>>         ffff800080a332b8 io_wq_worker+0x110
>>>>>         ffff80008002dd38 ret_from_fork+0x10
>>>>>
>>>>> which seems to be expected, we'd continually try and fault in the
>>>>> ranges, if the userfaultfd handler isn't filling them.
>>>>>
>>>>> I guess this is where I'm still confused, because I don't see how this
>>>>> is different from if you have a normal write(2) syscall doing the same
>>>>> thing - you'd get the same looping.
>>>>>
>>>>> ??
>>>>>
>>>>>> This issue occurs like during VM snapshot loading (which uses
>>>>>> userfaultfd for on-demand memory loading), while the task in the guest is
>>>>>> writing data to disk.
>>>>>>
>>>>>> Normally, the VM first triggers a user fault to fill the page table.
>>>>>> So in the IOU worker thread, the page tables are already filled,
>>>>>> fault no chance happens when faulting in memory pages
>>>>>> in fault_in_iov_iter_readable.
>>>>>>
>>>>>> I suspect that during snapshot loading, a memory access in the
>>>>>> VM triggers an async page fault handled by the kernel thread,
>>>>>> while the IOU worker's async kernel thread is also running.
>>>>>> Maybe If the IOU worker's thread is scheduled first.
>>>>>> I?m going to bed now.
>>>>>
>>>>> Ah ok, so what you're saying is that because we end up not sleeping
>>>>> (because a signal is pending, it seems), then the fault will never get
>>>>> filled and hence progress not made? And the signal is pending because
>>>>> someone tried to create a net worker, and this work is not getting
>>>>> processed.
>>>>>
>>>>> --
>>>>> Jens Axboe
>>>>         handle_userfault() {
>>>>           hugetlb_vma_lock_read();
>>>>           _raw_spin_lock_irq() {
>>>>             __pv_queued_spin_lock_slowpath();
>>>>           }
>>>>           vma_mmu_pagesize() {
>>>>             hugetlb_vm_op_pagesize();
>>>>           }
>>>>           huge_pte_offset();
>>>>           hugetlb_vma_unlock_read();
>>>>           up_read();
>>>>           __wake_up() {
>>>>             _raw_spin_lock_irqsave() {
>>>>               __pv_queued_spin_lock_slowpath();
>>>>             }
>>>>             __wake_up_common();
>>>>             _raw_spin_unlock_irqrestore();
>>>>           }
>>>>           schedule() {
>>>>             io_wq_worker_sleeping() {
>>>>               io_wq_dec_running();
>>>>             }
>>>>             rcu_note_context_switch();
>>>>             raw_spin_rq_lock_nested() {
>>>>               _raw_spin_lock();
>>>>             }
>>>>             update_rq_clock();
>>>>             pick_next_task() {
>>>>               pick_next_task_fair() {
>>>>                 update_curr() {
>>>>                   update_curr_se();
>>>>                   __calc_delta.constprop.0();
>>>>                   update_min_vruntime();
>>>>                 }
>>>>                 check_cfs_rq_runtime();
>>>>                 pick_next_entity() {
>>>>                   pick_eevdf();
>>>>                 }
>>>>                 update_curr() {
>>>>                   update_curr_se();
>>>>                   __calc_delta.constprop.0();
>>>>                   update_min_vruntime();
>>>>                 }
>>>>                 check_cfs_rq_runtime();
>>>>                 pick_next_entity() {
>>>>                   pick_eevdf();
>>>>                 }
>>>>                 update_curr() {
>>>>                   update_curr_se();
>>>>                   update_min_vruntime();
>>>>                   cpuacct_charge();
>>>>                   __cgroup_account_cputime() {
>>>>                     cgroup_rstat_updated();
>>>>                   }
>>>>                 }
>>>>                 check_cfs_rq_runtime();
>>>>                 pick_next_entity() {
>>>>                   pick_eevdf();
>>>>                 }
>>>>               }
>>>>             }
>>>>             raw_spin_rq_unlock();
>>>>             io_wq_worker_running();
>>>>           }
>>>>           _raw_spin_lock_irq() {
>>>>             __pv_queued_spin_lock_slowpath();
>>>>           }
>>>>           userfaultfd_ctx_put();
>>>>         }
>>>>       }
>>>> The execution flow above is the one that kept faulting
>>>> repeatedly in the IOU worker during the issue. The entire fault path,
>>>> including this final userfault handling code you're seeing, would be
>>>> triggered in an infinite loop. That's why I traced and found that the
>>>> io_wq_worker_running() function returns early, causing the flow to
>>>> differ from a normal user fault, where it should be sleeping.
>>>
>>> io_wq_worker_running() is called when the task is scheduled back in.
>>> There's no "returning early" here, it simply updates the accounting.
>>> Which is part of why your patch makes very little sense to me, we
>>> would've called both io_wq_worker_sleeping() and _running() from the
>>> userfaultfd path. The latter doesn't really do much, it simply just
>>> increments the running worker count, if the worker was previously marked
>>> as sleeping.
>>>
>>> And I strongly suspect that the latter is the issue, not the marking of
>>> running. The above loop is fine if we do go to sleep in schedule.
>>> However, if there's task_work (either TWA_SIGNAL or TWA_NOTIFY_SIGNAL
>>> based) pending, then schedule() will be a no-op and we're going to
>>> repeatedly go through that loop. This is because the expectation here is
>>> that the loop will be aborted if either of those is true, so that
>>> task_work can get run (or a signal handled, whatever), and then the
>>> operation retried.
>>>
>>>> However, your call stack appears to behave normally,
>>>> which makes me curious about what's different about execution flow.
>>>> Would you be able to share your test case code so I can study it
>>>> and try to reproduce the behavior on my side?
>>>
>>> It behaves normally for the initial attempt - we end up sleeping in
>>> schedule(). However, then a new worker gets created, or the ring
>>> shutdown, in which case schedule() ends up being a no-op because
>>> TWA_NOTIFY_SIGNAL is set, and then we just sit there in a loop running
>>> the same code again and again to no avail. So I do think my test case
>>> and your issue is the same, I just reproduce it by calling
>>> io_uring_queue_exit(), but the exact same thing would happen if worker
>>> creation is attempted while an io-wq worker is blocked
>>> handle_userfault().
>>>
>>> This is why I want to fully understand the issue rather than paper
>>> around it, as I don't think the fix is correct as-is. We really want to
>>> abort the loop and allow the task to handle whatever signaling is
>>> currently preventing proper sleeps.
>>>
>>> I'll dabble a bit more and send out the test case too, in case it'll
>>> help on your end.
>>>
>>> --
>>> Jens Axboe
>> I?m really looking forward to your test case. Also, I?d like to
>> emphasize one more point: the handle_userfault graph path I sent you,
>> including the schedule function, is complete and unmodified. You can
>> see that the schedule function is very, very short. I understand your
>> point about signal handling, but in this very brief function graph, I
>> haven?t yet seen any functions related to signal handling.
>> Additionally, there is no context switch here, nor is it the situation
>> where the thread is being scheduled back in. Perhaps the scenario
>> you?ve reproduced is still different from the one I?ve encountered in
>> some subtle way?
> 
> Ask yourself, why would schedule() return immediately rather than
> actually block? There's a few cases here:
> 
> 1) The task state is set to TASK_RUNNING - either because it was never
>    set to TASK_INTERRUPTIBLE/TASK_UNINTERRUPTIBLE, or because someone
>    raced and woke up the task after the initial check on whether it
>    should be sleeping or not.
> 
> 2) Some kind of notification or signal is pending. This is usually when
>    task_sigpending() returns true, or if TIF_NOTIFY_SIGNAL is set. Those
>    need clearing, and that's generally done on return to userspace.
> 
> #1 isn't the case here, but #2 looks highly plausible. The io-wq workers
> rely on running this kind of work manually, and retrying. If we loop
> further down with these conditions being true, then we're just busy
> looping at that point and will NEVER sleep. You don't see any functions
> related to signal handling etc EXACTLY because of that, there's nowhere
> it gets run.
> 
>> void io_wq_worker_running(struct task_struct *tsk)
>> {
>> struct io_worker *worker = tsk->worker_private;
>>
>> if (!worker)
>> return;
>> if (!test_bit(IO_WORKER_F_FAULT, &worker->flags)) {
>> if (!test_bit(IO_WORKER_F_UP, &worker->flags))
>> return;
>> if (test_bit(IO_WORKER_F_RUNNING, &worker->flags))
>> return;
>> set_bit(IO_WORKER_F_RUNNING, &worker->flags);
>> io_wq_inc_running(worker);
>> }
>> }
>> However, from my observation during the crash live memory analysis,
>> when this happens in the IOU worker thread, the
>> IO_WORKER_F_RUNNING flag is set. This is what I said "early return",
>> rather than just a simple accounting function.I look forward to your
>> deeper analysis and any corrections you may have.
> 
> It's set becase of what I outlined above. If schedule() would actually
> sleep, then io_wq_worker_sleeping() would've been called. The fact that
> you're getting io_wq_worker_running() called without WORKER_F_RUNNING
> cleared is because of that.
> 
> But you're too focused on the symptom here, not the underlying issue. It
> doesn't matter at all that io_wq_worker_running() is called when the
> task is already running, it'll just ignore that. It's explicitly tested.
> Your patch won't make a single difference for this case because of that,
> you're just wrapping what's esssentially a no-op call with another no-op
> call, as you've now nested RUNNING inside the FAULT flag. It won't
> change your outcome at all.

BTW, same thing can be observed without using io_uring at all - just
have a normal task do a write(2) as in my test case, and have the parent
send it a signal. We'll loop in page fault handling if userfaultfd is
used and it doesn't fill the fault. Example attached.

IOW, this is a generic "problem". I use quotes here as it's not _really_
a problem, it'll just loop excessively if a signal is pending. It can
still very much get killed or terminated, but it's not going to make
progress as the page fault isn't filled.

-- 
Jens Axboe
--------------Rtfq7maOjRQ8KE7c6kd7Vtad
Content-Type: text/x-csrc; charset=UTF-8; name="tufd.c"
Content-Disposition: attachment; filename="tufd.c"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHVuaXN0
ZC5oPgojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHN0cmluZy5oPgojaW5jbHVkZSA8
cG9sbC5oPgojaW5jbHVkZSA8c3lzL21tYW4uaD4KI2luY2x1ZGUgPHN5cy9pb2N0bC5oPgoj
aW5jbHVkZSA8c3lzL3dhaXQuaD4KI2luY2x1ZGUgPGxpbnV4L21tYW4uaD4KI2luY2x1ZGUg
PHN5cy91aW8uaD4KI2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxwdGhyZWFkLmg+CiNp
bmNsdWRlIDxzaWduYWwuaD4KI2luY2x1ZGUgPGxpbnV4L3VzZXJmYXVsdGZkLmg+CgojZGVm
aW5lIEhQX1NJWkUJCSgyICogMTAyNCAqIDEwMjRVTEwpCgojaWZuZGVmIE5SX3VzZXJmYXVs
dGZkCiNkZWZpbmUgTlJfdXNlcmZhdWx0ZmQJMjgyCiNlbmRpZgoKc3RydWN0IHRocmVhZF9k
YXRhIHsKCXB0aHJlYWRfdCB0aHJlYWQ7CglwdGhyZWFkX2JhcnJpZXJfdCBiYXJyaWVyOwoJ
aW50IHVmZmQ7Cn07CgpzdGF0aWMgdm9pZCAqZmF1bHRfaGFuZGxlcih2b2lkICpkYXRhKQp7
CglzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRkID0gZGF0YTsKCXN0cnVjdCB1ZmZkX21zZyBtc2c7
CglzdHJ1Y3QgcG9sbGZkIHBmZDsKCWludCByZXQsIG5yZWFkeTsKCglwdGhyZWFkX2JhcnJp
ZXJfd2FpdCgmdGQtPmJhcnJpZXIpOwoKCWRvIHsKCQlwZmQuZmQgPSB0ZC0+dWZmZDsKCQlw
ZmQuZXZlbnRzID0gUE9MTElOOwoJCW5yZWFkeSA9IHBvbGwoJnBmZCwgMSwgLTEpOwoJCWlm
IChucmVhZHkgPCAwKSB7CgkJCXBlcnJvcigicG9sbCIpOwoJCQlleGl0KDEpOwoJCX0KCgkJ
cmV0ID0gcmVhZCh0ZC0+dWZmZCwgJm1zZywgc2l6ZW9mKG1zZykpOwoJCWlmIChyZXQgPCAw
KSB7CgkJCWlmIChlcnJubyA9PSBFQUdBSU4pCgkJCQljb250aW51ZTsKCQkJcGVycm9yKCJy
ZWFkIik7CgkJCWV4aXQoMSk7CgkJfQoKCQlpZiAobXNnLmV2ZW50ICE9IFVGRkRfRVZFTlRf
UEFHRUZBVUxUKSB7CgkJCXByaW50ZigidW5zcGVjdGVkIGV2ZW50OiAleFxuIiwgbXNnLmV2
ZW50KTsKCQkJZXhpdCgxKTsKCQl9CgoJCXByaW50ZigiUGFnZSBmYXVsdFxuIik7CgkJcHJp
bnRmKCJmbGFncyA9ICVseDsgIiwgKGxvbmcpIG1zZy5hcmcucGFnZWZhdWx0LmZsYWdzKTsK
CQlwcmludGYoImFkZHJlc3MgPSAlbHhcbiIsIChsb25nKW1zZy5hcmcucGFnZWZhdWx0LmFk
ZHJlc3MpOwoJfSB3aGlsZSAoMSk7CgoJcmV0dXJuIE5VTEw7Cn0KCnN0YXRpYyB2b2lkICph
cm1fZmF1bHRfaGFuZGxlcihzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRkLCBzaXplX3QgbGVuKQp7
CglzdHJ1Y3QgdWZmZGlvX2FwaSBhcGkgPSB7IH07CglzdHJ1Y3QgdWZmZGlvX3JlZ2lzdGVy
IHJlZyA9IHsgfTsKCXZvaWQgKmJ1ZjsKCglidWYgPSBtbWFwKE5VTEwsIEhQX1NJWkUsIFBS
T1RfUkVBRHxQUk9UX1dSSVRFLAoJCQlNQVBfUFJJVkFURSB8IE1BUF9IVUdFVExCIHwgTUFQ
X0hVR0VfMk1CIHwgTUFQX0FOT05ZTU9VUywKCQkJLTEsIDApOwoJaWYgKGJ1ZiA9PSBNQVBf
RkFJTEVEKSB7CgkJcGVycm9yKCJtbWFwIik7CgkJcmV0dXJuIE5VTEw7Cgl9CglwcmludGYo
ImdvdCBidWYgJXBcbiIsIGJ1Zik7CgoJdGQtPnVmZmQgPSBzeXNjYWxsKE5SX3VzZXJmYXVs
dGZkLCBPX0NMT0VYRUMgfCBPX05PTkJMT0NLKTsKCWlmICh0ZC0+dWZmZCA8IDApIHsKCQlw
ZXJyb3IoInVzZXJmYXVsdGZkIik7CgkJcmV0dXJuIE5VTEw7Cgl9CgoJYXBpLmFwaSA9IFVG
RkRfQVBJOwoJaWYgKGlvY3RsKHRkLT51ZmZkLCBVRkZESU9fQVBJLCAmYXBpKSA8IDApIHsK
CQlwZXJyb3IoImlvY3RsIFVGRkRJT19BUEkiKTsKCQlyZXR1cm4gTlVMTDsKCX0KCglyZWcu
cmFuZ2Uuc3RhcnQgPSAodW5zaWduZWQgbG9uZykgYnVmOwoJcmVnLnJhbmdlLmxlbiA9IEhQ
X1NJWkU7CglyZWcubW9kZSA9IFVGRkRJT19SRUdJU1RFUl9NT0RFX01JU1NJTkc7CglpZiAo
aW9jdGwodGQtPnVmZmQsIFVGRkRJT19SRUdJU1RFUiwgJnJlZykgPCAwKSB7CgkJcGVycm9y
KCJpb2N0bCBVRkZESU9fUkVHSVNURVIiKTsKCQlyZXR1cm4gTlVMTDsKCX0KCglyZXR1cm4g
YnVmOwp9CgpzdGF0aWMgdm9pZCBzaWdfdXNyMShpbnQgc2lnKQp7Cn0KCnN0YXRpYyB2b2lk
IF9fZG9faW8oaW50IGZkLCB2b2lkICpidWYsIHNpemVfdCBsZW4pCnsKCXN0cnVjdCBzaWdh
Y3Rpb24gYWN0ID0geyB9OwoJaW50IHJldDsKCglhY3Quc2FfaGFuZGxlciA9IHNpZ191c3Ix
OwoJc2lnYWN0aW9uKFNJR1VTUjEsICZhY3QsIE5VTEwpOwoKCXByaW50ZigiY2hpbGQgd2ls
bCB3cml0ZVxuIik7CglyZXQgPSB3cml0ZShmZCwgYnVmLCBsZW4pOwoJcHJpbnRmKCJyZXQ9
JWRcbiIsIHJldCk7Cn0KCnN0YXRpYyB2b2lkIGRvX2lvKHN0cnVjdCB0aHJlYWRfZGF0YSAq
dGQsIHNpemVfdCBsZW4pCnsKCXZvaWQgKmJ1ZjsKCXBpZF90IHBpZDsKCWludCBmZDsKCglm
ZCA9IG9wZW4oIi9kZXYvbnZtZTBuMSIsIE9fUkRXUik7CglpZiAoZmQgPCAwKSB7CgkJcGVy
cm9yKCJvcGVuIGNyZWF0ZSIpOwoJCXJldHVybjsKCX0KCglwaWQgPSBmb3JrKCk7CglpZiAo
cGlkKSB7CgkJaW50IHdzdGF0OwoKCQlzbGVlcCgxKTsKCQlraWxsKHBpZCwgU0lHVVNSMSk7
CgkJcHJpbnRmKCJ3YWl0IG9uIGNoaWxkXG4iKTsKCQl3YWl0cGlkKHBpZCwgJndzdGF0LCAw
KTsKCX0gZWxzZSB7CgkJYnVmID0gYXJtX2ZhdWx0X2hhbmRsZXIodGQsIGxlbik7CgkJcHRo
cmVhZF9iYXJyaWVyX3dhaXQoJnRkLT5iYXJyaWVyKTsKCQlfX2RvX2lvKGZkLCBidWYsIGxl
bik7CgkJZXhpdCgwKTsKCX0KfQoKaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkK
ewoJc3RydWN0IHRocmVhZF9kYXRhIHRkID0geyB9OwoKCXB0aHJlYWRfYmFycmllcl9pbml0
KCZ0ZC5iYXJyaWVyLCBOVUxMLCAyKTsKCXB0aHJlYWRfY3JlYXRlKCZ0ZC50aHJlYWQsIE5V
TEwsIGZhdWx0X2hhbmRsZXIsICZ0ZCk7CgoJZG9faW8oJnRkLCBIUF9TSVpFKTsKCXJldHVy
biAwOwp9Cg==

--------------Rtfq7maOjRQ8KE7c6kd7Vtad--

