Return-Path: <io-uring+bounces-7617-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC7FA96E10
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:13:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CF9C188E2A0
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 14:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0E2284B4E;
	Tue, 22 Apr 2025 14:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="v8weGwsr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B6A28368B
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 14:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745331206; cv=none; b=gOYakt9K2El0zJ2VCa9DDu5X5SsOb0FjAUu14Ie1ugnYNnu9hbcjVJpjy4dZE1iIZDOY4d3o1ROq6MrCFjGTVdekUOh24cYHiYBBu+2tlbd750kSsn4/Os5RC40CGUAvwmmO/qmj0QAtJMdctmA6XVkBxEQ4GtImyTCkWwyVHJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745331206; c=relaxed/simple;
	bh=qur72rcPg9p2Vj9qw82Z6e/LUgC0MBT3UTvpo0xOtp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KP2LyPzJIshrHiR0zrazGuPWXV0/LLr0aMV1aKsTpzmpCCYDcXYCAocE1tvgvZ7d1VOe33+EaQ+Yas2s0ITdMLW8TPOrgrdUsaLJMhcX7zUwVNoarte5P1+EQsq1f/QZFGM427Drp15G/W3AT6hnkMy0nocXq0XnP5Q7qDEfoHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=v8weGwsr; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d5e43e4725so10913425ab.1
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 07:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745331202; x=1745936002; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QR8zq+WeURJcQJZtbdR5JK1T9fRJKOc9/cP5khZOT8Q=;
        b=v8weGwsrTXSgGfCbkoui+IAADyzs4GpNn/BaPJ+2N+tsCo4rbgmYwktFMtrgD18mKX
         YgVrMQ75dm+BtbJv/jlMaE2T5pMXPVwgmOEJgtQm8DaNCiK6Zc0z/KberBOYwLY4VPGX
         84Ek8V2qsTcS8korQAab87dUnXi8P8LJy0yEcbjmzVu+WF6Gno16JFDsISzSH1CbBs69
         Q7O6hvZaUS8lTuxR+7dSLmittxZHOe11WZWiMDe9FZcx6iHjePvKJZ63ZwpLEpGDfNjd
         J3r7YQfcfPJjmNiPZxWJyJITeUaT921D10cDKCRrbCoBWOExXK2lPNP5ewP/l+NE2kSG
         q/tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745331202; x=1745936002;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QR8zq+WeURJcQJZtbdR5JK1T9fRJKOc9/cP5khZOT8Q=;
        b=s2A8umdZ3KPjUE7Lj0Qe4Q/pIGMWADIEmtEAtfrwvn3DjhYuHZlFy0DvsjWxOYwn9A
         NJPgWuuGDEu9F4TGLNiTtirjb7+soP8055ED/Y8eAQ9/iihMN4iD0zaeL6e8thcj8ARs
         uPUSD/XnXtCnJZ5XQMQJ8xRNcFAhJsAVPPlPYt+rh4bAdP/FvA5yNDr7MTIfwTMjKRbj
         Vhi1fb5huNRLzgS8RUQrAygPU54OqHhxAEusIJQLBTiBzhLI5f/iHwYou4CslNgW7lDv
         /LYpzgL+PR3c1sBgbjQVIPGs3xtn51aMSyQTz/QFPdPT/+GrVnKHhHECNbWaiZS+Qf6E
         SimQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzv4gPupN0oi7zzJ1VVb0mBVlCTeqMl2ouzIrPAN7PeWLV8YvKg7DMxmgxeswnDnm+KGzIIX1tzw==@vger.kernel.org
X-Gm-Message-State: AOJu0YySsEPTLKQdJDnhndD8wonoKBUqF0klwmkfE++vq5g343SOcqDC
	kSlYbynk9u6t1VO84sngvLpGQ6qZRnWr1t9/8zIuFtjyvsjZS4hVE8Lv/Gvx9Iw=
X-Gm-Gg: ASbGncseBwmoRw0qHhc7yVkpNEqtvR7hVQ/OxT/29uPEobScKy71k98rjJFn3cYbk/+
	AMCUt/A6n4XClQNeXiDQZsdOK4Z5C4Qf8jp0FYwqyTUHzY62x7t+IsCiTbdE/UwBjWk924iS9ll
	DN84e4wYG4r/nn9SC+nJ7T0npUGnBa5c5QBFRK8cqGgS4q2qPevoMaFeVINMwGEPR82szTm7o4r
	Ufyi75iZyceHGf0MdpFcU9EJL/4KjepD122ATOY+a9sQ1JANkKq2Utb3Iv+Pnrk+NDBSKjrHZ+Z
	M3iC0ztvnw44L1xyrKFX2pCZAvheQ9JEJlFOlA==
X-Google-Smtp-Source: AGHT+IHWzI0Wn75AyMi9DGxMOkS03WlRiBtxZ7rlcgm58ABO0oLpJVq/2ieK8hF5G5HQ2V0a9+w1wA==
X-Received: by 2002:a05:6e02:3183:b0:3d8:1d7c:e197 with SMTP id e9e14a558f8ab-3d88ed95743mr178064425ab.7.1745331202189;
        Tue, 22 Apr 2025 07:13:22 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a37cbb4fsm2354342173.16.2025.04.22.07.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 07:13:21 -0700 (PDT)
Message-ID: <028b4791-b6fc-47e3-9220-907180967d3a@kernel.dk>
Date: Tue, 22 Apr 2025 08:13:20 -0600
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
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CANHzP_tpNwcL45wQTb6yFwsTU7jUEnrERv8LSc677hm7RQkPuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/22/25 8:10 AM, ??? wrote:
> On Tue, Apr 22, 2025 at 9:35?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/22/25 4:45 AM, Zhiwei Jiang wrote:
>>> In the Firecracker VM scenario, sporadically encountered threads with
>>> the UN state in the following call stack:
>>> [<0>] io_wq_put_and_exit+0xa1/0x210
>>> [<0>] io_uring_clean_tctx+0x8e/0xd0
>>> [<0>] io_uring_cancel_generic+0x19f/0x370
>>> [<0>] __io_uring_cancel+0x14/0x20
>>> [<0>] do_exit+0x17f/0x510
>>> [<0>] do_group_exit+0x35/0x90
>>> [<0>] get_signal+0x963/0x970
>>> [<0>] arch_do_signal_or_restart+0x39/0x120
>>> [<0>] syscall_exit_to_user_mode+0x206/0x260
>>> [<0>] do_syscall_64+0x8d/0x170
>>> [<0>] entry_SYSCALL_64_after_hwframe+0x78/0x80
>>> The cause is a large number of IOU kernel threads saturating the CPU
>>> and not exiting. When the issue occurs, CPU usage 100% and can only
>>> be resolved by rebooting. Each thread's appears as follows:
>>> iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork_asm
>>> iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork
>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker
>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_worker_handle_work
>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_submit_work
>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_issue_sqe
>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_write
>>> iou-wrk-44588  [kernel.kallsyms]  [k] blkdev_write_iter
>>> iou-wrk-44588  [kernel.kallsyms]  [k] iomap_file_buffered_write
>>> iou-wrk-44588  [kernel.kallsyms]  [k] iomap_write_iter
>>> iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_iov_iter_readable
>>> iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_readable
>>> iou-wrk-44588  [kernel.kallsyms]  [k] asm_exc_page_fault
>>> iou-wrk-44588  [kernel.kallsyms]  [k] exc_page_fault
>>> iou-wrk-44588  [kernel.kallsyms]  [k] do_user_addr_fault
>>> iou-wrk-44588  [kernel.kallsyms]  [k] handle_mm_fault
>>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_fault
>>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_no_page
>>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_handle_userfault
>>> iou-wrk-44588  [kernel.kallsyms]  [k] handle_userfault
>>> iou-wrk-44588  [kernel.kallsyms]  [k] schedule
>>> iou-wrk-44588  [kernel.kallsyms]  [k] __schedule
>>> iou-wrk-44588  [kernel.kallsyms]  [k] __raw_spin_unlock_irq
>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker_sleeping
>>>
>>> I tracked the address that triggered the fault and the related function
>>> graph, as well as the wake-up side of the user fault, and discovered this
>>> : In the IOU worker, when fault in a user space page, this space is
>>> associated with a userfault but does not sleep. This is because during
>>> scheduling, the judgment in the IOU worker context leads to early return.
>>> Meanwhile, the listener on the userfaultfd user side never performs a COPY
>>> to respond, causing the page table entry to remain empty. However, due to
>>> the early return, it does not sleep and wait to be awakened as in a normal
>>> user fault, thus continuously faulting at the same address,so CPU loop.
>>> Therefore, I believe it is necessary to specifically handle user faults by
>>> setting a new flag to allow schedule function to continue in such cases,
>>> make sure the thread to sleep.
>>>
>>> Patch 1  io_uring: Add new functions to handle user fault scenarios
>>> Patch 2  userfaultfd: Set the corresponding flag in IOU worker context
>>>
>>>  fs/userfaultfd.c |  7 ++++++
>>>  io_uring/io-wq.c | 57 +++++++++++++++---------------------------------
>>>  io_uring/io-wq.h | 45 ++++++++++++++++++++++++++++++++++++--
>>>  3 files changed, 68 insertions(+), 41 deletions(-)
>>
>> Do you have a test case for this? I don't think the proposed solution is
>> very elegant, userfaultfd should not need to know about thread workers.
>> I'll ponder this a bit...
>>
>> --
>> Jens Axboe
> Sorry,The issue occurs very infrequently, and I can't manually
> reproduce it. It's not very elegant, but for corner cases, it seems
> necessary to make some compromises.

I'm going to see if I can create one. Not sure I fully understand the
issue yet, but I'd be surprised if there isn't a more appropriate and
elegant solution rather than exposing the io-wq guts and having
userfaultfd manipulate them. That really should not be necessary.

-- 
Jens Axboe

