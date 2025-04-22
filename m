Return-Path: <io-uring+bounces-7627-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A81FA9729D
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 18:26:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 647364429D8
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63DA12949EB;
	Tue, 22 Apr 2025 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BvlEaxhl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D767293B70
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 16:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745339061; cv=none; b=hmOc0bP4k5ZwmvyMJvsjy+Nsix9MqQgj5ULy+kRRDKe0ceVOXbaDaPN+ADknr0KMIp8uKm248d7ibXejLFcEyjnfdZn3wD/qHK8zr+HfyGSF5cnneMpodyMdl6liBFGzd7VUMMNJD4RCMmzQVs9XUOhcVY/DRMSyrEI/epxrFBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745339061; c=relaxed/simple;
	bh=tTPyvvktfcqDPnRBx86/RWSrX9I6vskownhbBGOPXww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NYDP+iwYkI4fB6kzGQ71aNkW7Zda101JWRk7IieajQ40YZFOU5CBxBqogHk49tP9viSMgA8dIEX/WTxzFpsKeboYcBzD4kWFgRxhHTYmJxJt+R/+71RM8B7SeNdkSnBxnJa2hNNE+4qKGMKB7ZY+YgYZAkkwmN8aBavWE1X7Bdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BvlEaxhl; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-8616987c261so159240339f.3
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 09:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745339056; x=1745943856; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j3O/04KOewEqYkmyH962BGKGCen1FWcqj/+4ibHpaNw=;
        b=BvlEaxhlQwMx4A2Gt0wqcpzMRbPARqjN8ny5hYgapd5ZlVVv2dt/PgTr1iRlQrd0uI
         H7cq7ITTo/v/ktrK/MKx7e33MpvUkx4uCk4heiMCVEY53L6N7H/3z9n/tgSiISjnk3kz
         waTsZ/Cpk36xHwHtChFpkd6FrllgTuEfLoRoHYmXvk51o42rfZz4OfJvTDjr3gctyrpw
         PhitvvHstStda4i/FTIxvcR7XEMWTF+gzve168eK5Uc+6oj9z2B5KEFzgyIVdAKxMXfh
         VpoFJ6BjcUy/b3ZbShZM9/C0x2YYQTlNDkB9qpMkrbT9WLVwu1/CRPC1j7ZfiM7cATwL
         ObJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745339056; x=1745943856;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j3O/04KOewEqYkmyH962BGKGCen1FWcqj/+4ibHpaNw=;
        b=mfNa9lkDSzaOk7yiXFDJHkyGYE/5DS5dGQMq6AICNbZbbS/ZJZQ2r8bCVXHBRf6FHq
         59QWBZkkQs8OOOxETrmNKw2mNilTUNL6eWOmOsk3LUhE6qKTCjMr6J2YZz5xw32eqZCe
         MGxLWKk7WQiB4k2THGNrWbI7dhfUuQBIUYXtKynffgsbFjKKoermkDU4hSgRG1vJaw1f
         39tDVaAZ1go9iXXVsUFR4FraBjrMKv0Uc1I4wB+e8UPQ7EoqtS3HnUx3NRymREev6Zq+
         HKydaqM+lJs6hZeWqtSyy86jSfEUfNqWm5wxwLba4wQA/ONJAS7qqkmyt5ov+AK35gw+
         wtZA==
X-Forwarded-Encrypted: i=1; AJvYcCVcneD+kbzoDVYh3aNDXrqZTQeORlfYTmqhqZqeFWcPji1kne55b6xSodT7/hnPZKh03K1/FFNk9g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPW0UeFgG8bQHba7b94tYunQqKh049COFjsZT/ZvxAOZNcuaOx
	8juM4tcFDsysUqcZpMNeFUHCDqGgTwbwTMDVirrTUCJrJ0QXeBJBlhjTA4m7+44=
X-Gm-Gg: ASbGncsI/66szoRMuSGKMOTZwi9EAf8meZpNykkO2Uz/k6kGDnR2GF3Lb+hPSUH9Lau
	LVv44s1yyAnTg1sH0hBIIRG85uquh4IgRj1VLXGOKcpTCqEaV0AuN+dOgckq/IS1lr0hIoZm60H
	245UA/4gn/tuQ61i9rCzdNFDs5LKz5oWY1owcY2IVAYmL/ldx69+jGJUGvGKOJmhxn2lWD9tsRz
	LIBfVSK75Ryl0RBDQXe8dRPj95MpckFMbPC3c5+hMK4Yx7i9qrnMyo1mbAJr36PmH2cqacCo4ls
	cUaDMbdMvRmkc/sC6vDVHJc/WQlU2X9HbkEkjQ==
X-Google-Smtp-Source: AGHT+IF+oA4Oa5RZl9BtxMoy39ZTJG2xZrFT/oMGu2VwciXmQf2r8GThv4QUlCvkUQXjdhpIKpVdcw==
X-Received: by 2002:a05:6602:7284:b0:85b:46b5:6fb5 with SMTP id ca18e2360f4ac-861dbeab8fcmr1637684939f.11.1745339056189;
        Tue, 22 Apr 2025 09:24:16 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a3933d59sm2410172173.94.2025.04.22.09.24.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 09:24:15 -0700 (PDT)
Message-ID: <0a9dfa29-62c9-4e47-aa4a-db36b61df3d1@kernel.dk>
Date: Tue, 22 Apr 2025 10:24:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Fix 100% CPU usage issue in IOU worker threads
To: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20250422104545.1199433-1-qq282012236@gmail.com>
 <bc68ea08-4add-4304-b66b-376ec488da63@kernel.dk>
 <CANHzP_tpNwcL45wQTb6yFwsTU7jUEnrERv8LSc677hm7RQkPuw@mail.gmail.com>
 <028b4791-b6fc-47e3-9220-907180967d3a@kernel.dk>
 <CANHzP_vD2a8O1TqTuVNVBOofnQs6ot+tDJCWQkeSifVF9pYxGg@mail.gmail.com>
 <da279d0f-d450-49ef-a64e-e3b551127ef5@kernel.dk>
 <b5a8dbda-8555-4b43-9a46-190d4f1c7519@kernel.dk>
 <CANHzP_u=a1U4pXtFoQ8Aw_OCUkxgfV9ZGaBr8kiuOReTGTY3=g@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANHzP_u=a1U4pXtFoQ8Aw_OCUkxgfV9ZGaBr8kiuOReTGTY3=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/22/25 10:14 AM, ??? wrote:
> On Tue, Apr 22, 2025 at 11:50?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/22/25 8:29 AM, Jens Axboe wrote:
>>> On 4/22/25 8:18 AM, ??? wrote:
>>>> On Tue, Apr 22, 2025 at 10:13?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 4/22/25 8:10 AM, ??? wrote:
>>>>>> On Tue, Apr 22, 2025 at 9:35?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>> On 4/22/25 4:45 AM, Zhiwei Jiang wrote:
>>>>>>>> In the Firecracker VM scenario, sporadically encountered threads with
>>>>>>>> the UN state in the following call stack:
>>>>>>>> [<0>] io_wq_put_and_exit+0xa1/0x210
>>>>>>>> [<0>] io_uring_clean_tctx+0x8e/0xd0
>>>>>>>> [<0>] io_uring_cancel_generic+0x19f/0x370
>>>>>>>> [<0>] __io_uring_cancel+0x14/0x20
>>>>>>>> [<0>] do_exit+0x17f/0x510
>>>>>>>> [<0>] do_group_exit+0x35/0x90
>>>>>>>> [<0>] get_signal+0x963/0x970
>>>>>>>> [<0>] arch_do_signal_or_restart+0x39/0x120
>>>>>>>> [<0>] syscall_exit_to_user_mode+0x206/0x260
>>>>>>>> [<0>] do_syscall_64+0x8d/0x170
>>>>>>>> [<0>] entry_SYSCALL_64_after_hwframe+0x78/0x80
>>>>>>>> The cause is a large number of IOU kernel threads saturating the CPU
>>>>>>>> and not exiting. When the issue occurs, CPU usage 100% and can only
>>>>>>>> be resolved by rebooting. Each thread's appears as follows:
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork_asm
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_worker_handle_work
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_submit_work
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_issue_sqe
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_write
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] blkdev_write_iter
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] iomap_file_buffered_write
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] iomap_write_iter
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_iov_iter_readable
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_readable
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] asm_exc_page_fault
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] exc_page_fault
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] do_user_addr_fault
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] handle_mm_fault
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_fault
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_no_page
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_handle_userfault
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] handle_userfault
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] schedule
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] __schedule
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] __raw_spin_unlock_irq
>>>>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker_sleeping
>>>>>>>>
>>>>>>>> I tracked the address that triggered the fault and the related function
>>>>>>>> graph, as well as the wake-up side of the user fault, and discovered this
>>>>>>>> : In the IOU worker, when fault in a user space page, this space is
>>>>>>>> associated with a userfault but does not sleep. This is because during
>>>>>>>> scheduling, the judgment in the IOU worker context leads to early return.
>>>>>>>> Meanwhile, the listener on the userfaultfd user side never performs a COPY
>>>>>>>> to respond, causing the page table entry to remain empty. However, due to
>>>>>>>> the early return, it does not sleep and wait to be awakened as in a normal
>>>>>>>> user fault, thus continuously faulting at the same address,so CPU loop.
>>>>>>>> Therefore, I believe it is necessary to specifically handle user faults by
>>>>>>>> setting a new flag to allow schedule function to continue in such cases,
>>>>>>>> make sure the thread to sleep.
>>>>>>>>
>>>>>>>> Patch 1  io_uring: Add new functions to handle user fault scenarios
>>>>>>>> Patch 2  userfaultfd: Set the corresponding flag in IOU worker context
>>>>>>>>
>>>>>>>>  fs/userfaultfd.c |  7 ++++++
>>>>>>>>  io_uring/io-wq.c | 57 +++++++++++++++---------------------------------
>>>>>>>>  io_uring/io-wq.h | 45 ++++++++++++++++++++++++++++++++++++--
>>>>>>>>  3 files changed, 68 insertions(+), 41 deletions(-)
>>>>>>>
>>>>>>> Do you have a test case for this? I don't think the proposed solution is
>>>>>>> very elegant, userfaultfd should not need to know about thread workers.
>>>>>>> I'll ponder this a bit...
>>>>>>>
>>>>>>> --
>>>>>>> Jens Axboe
>>>>>> Sorry,The issue occurs very infrequently, and I can't manually
>>>>>> reproduce it. It's not very elegant, but for corner cases, it seems
>>>>>> necessary to make some compromises.
>>>>>
>>>>> I'm going to see if I can create one. Not sure I fully understand the
>>>>> issue yet, but I'd be surprised if there isn't a more appropriate and
>>>>> elegant solution rather than exposing the io-wq guts and having
>>>>> userfaultfd manipulate them. That really should not be necessary.
>>>>>
>>>>> --
>>>>> Jens Axboe
>>>> Thanks.I'm looking forward to your good news.
>>>
>>> Well, let's hope there is! In any case, your patches could be
>>> considerably improved if you did:
>>>
>>> void set_userfault_flag_for_ioworker(void)
>>> {
>>>       struct io_worker *worker;
>>>       if (!(current->flags & PF_IO_WORKER))
>>>               return;
>>>       worker = current->worker_private;
>>>       set_bit(IO_WORKER_F_FAULT, &worker->flags);
>>> }
>>>
>>> void clear_userfault_flag_for_ioworker(void)
>>> {
>>>       struct io_worker *worker;
>>>       if (!(current->flags & PF_IO_WORKER))
>>>               return;
>>>       worker = current->worker_private;
>>>       clear_bit(IO_WORKER_F_FAULT, &worker->flags);
>>> }
>>>
>>> and then userfaultfd would not need any odd checking, or needing io-wq
>>> related structures public. That'd drastically cut down on the size of
>>> them, and make it a bit more palatable.
>>
>> Forgot to ask, what kernel are you running on?
>>
>> --
>> Jens Axboe
> Thanks Jens It is linux-image-6.8.0-1026-gcp

OK, that's ancient and unsupported in that no stable release is
happening for that kernel. Does it happen on newer kernels too?

FWIW, I haven't been able to reproduce anything odd so far. The io_uring
writes going via io-wq and hitting the userfaultfd path end up sleeping
in the schedule() in handle_userfault() - which is what I'd expect.

Do you know how many pending writes there are? I have a hard time
understanding your description of the problem, but it sounds like a ton
of workers are being created. But it's still not clear to me why that
would be, workers would only get created if there's more work to do, and
the current worker is going to sleep.

Puzzled...

-- 
Jens Axboe

