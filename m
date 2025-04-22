Return-Path: <io-uring+bounces-7619-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BAF2A96EE8
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 912454432C3
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 14:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 264ED2857EF;
	Tue, 22 Apr 2025 14:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="L3nxsg7G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E70284B5C
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 14:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745332159; cv=none; b=IcN9K+XpSJ0fXOoE/b3FKakMLGaVNkslnl7SBgnrh59/ZPVEIYSifxpgU4oS4IheymwfaGTaXGNTb+v/tqbYAMeDzPHbtbu4/r+TFCwg/OtEY67Zspb25RkPB5NqFaxOZAwWoO2vwt9G/bKo2+ShfPhOJTxFPE0NEYyLJQI6gmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745332159; c=relaxed/simple;
	bh=iqAyjkTe8FJmSe36CfbeiEm/MnwVbc4LIHA3sVC2aYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YoxUKw3WqAua0Uf+5BuIWkJYlGx45CXEdxYb2Fraur8AqzEK31a6zGDb2URv6FESoDj3kfPLK6cpj8LfvsDVZVL5456XF5O/j/aCG1c3dBY4N2Og3F5tHtWEvXMNvgy6cf4VsfP6Wo0ENcct1aSBnb+sshShihpreeaW0L9MC0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=L3nxsg7G; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8616987c261so154444539f.3
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 07:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745332155; x=1745936955; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZItchBs+om2xlqnvEPsN/ABV3TFl0Qstvr2y/+6RJl0=;
        b=L3nxsg7G2u8mYYbtyhF8ENYr6QoVO3fQ/+KE32sLtod79XeY5nCRwonkvClFzBckfN
         1tjV5cImzhpUbHbfaveYozjmXddvezVsKGQ0bwyUfU9i2Yw3OIuEeb+50ZCfgnUyrecw
         ZSCcznsMBs9WsJ7cmM9/Ykddu/IwSs8Ll9gqW0M3s6z7IIpXvUgDdlJ9jtHPldDTFjmi
         O0YpHssNY/25fLhLleu6k6/N9AgpY8WEzydWyEMulyRk75N+uPUtlbcL/aQVNFTcATL2
         UXvapfLhgRPLmvxnnf68IHxkAn5n4CCTlJecMYTf+0detV/igYkK8g/BJ021ksrD1tUX
         IDTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745332155; x=1745936955;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZItchBs+om2xlqnvEPsN/ABV3TFl0Qstvr2y/+6RJl0=;
        b=GXVzGJb/JO//PEKuUD/hhCVx1HJIksGd36JMSaRif8hmjPpSKh3bWS0tMcQQ2WRWqo
         TkHYWa454vkmQl6ndtzKaKIwrJj3hFuNQCtb0mC60EcNi5e86fV1IKq007qrIwpPlOiN
         XMIC14HtR1+m1CsRrED2xAA6eeFsoCOlbOIL7SBgggD5sUuAMLEVsusaIz2JHHKnDyhW
         Ij5A8RTzJuNspOAbtqAhJ8rmx48GVDacD/Lyd7yPSLXrNAN54SCeM9d9zB0uRZW71FaE
         SsYbHTzdiSMShwee/xlslQSfK2P6AgdoSZPHv5p2UKzn90ErCYxQ78sYSVKvQWLN92Gz
         cAGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfvzMKc9OXX7Ki0AUqeDrdHqYDiOQBsRsGVbSaw8/Eo8zC0BCu+f6RbuDXWlXO17ZDQpW7L2qWMw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyboZFNs+0fcLf04OBLMoNcgnpVpZ3H5RW7O/qQqks5U7iGd5UA
	BLIwEijbhCSSfAkpehte6DWom5FMMWF2kWeqTtXVW9GHgjcVjx69frpyK00DAiY=
X-Gm-Gg: ASbGncsfYvS/ZvK+/bHcIprwoEO3e1fSZ5Ir61SYFRuXE8RLzlHFsuODlsWgQ0+8P2v
	PpenO8PxBxr5eQO+qTHohnQ4ONLvMdMAqbdP7IHGsv8COMOKf+8NGRVKa2Ckq3cWG6UuTrD33un
	D+9RzIofWHk/8keArQv55AKxRYMBAiA3YMaP5gu/B8vsmjx460j/ld9booXUVOrliVGbiPiW1X8
	0VXqpHS3FnRNWef5xyCCZbQqqG0LU6YFnzQzzPiCKri/lWJEdffSkkW6EuR4IuSvF+xYBVCN11U
	a/WoAW/Ll3LoHd11mbNh7I/+CQR2ls8JLtF+9g==
X-Google-Smtp-Source: AGHT+IFLV/+m8b6shyscF+FGI9c1u3BTJL9q26JyzZDFvicZ/3ujqlTuYIRRvE5h3xowrMyrH1jWVw==
X-Received: by 2002:a05:6602:360d:b0:85d:9e5d:efa9 with SMTP id ca18e2360f4ac-861dbeab815mr1478981639f.10.1745332154944;
        Tue, 22 Apr 2025 07:29:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a39554d1sm2320394173.111.2025.04.22.07.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 07:29:14 -0700 (PDT)
Message-ID: <da279d0f-d450-49ef-a64e-e3b551127ef5@kernel.dk>
Date: Tue, 22 Apr 2025 08:29:13 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANHzP_vD2a8O1TqTuVNVBOofnQs6ot+tDJCWQkeSifVF9pYxGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/22/25 8:18 AM, ??? wrote:
> On Tue, Apr 22, 2025 at 10:13?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/22/25 8:10 AM, ??? wrote:
>>> On Tue, Apr 22, 2025 at 9:35?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 4/22/25 4:45 AM, Zhiwei Jiang wrote:
>>>>> In the Firecracker VM scenario, sporadically encountered threads with
>>>>> the UN state in the following call stack:
>>>>> [<0>] io_wq_put_and_exit+0xa1/0x210
>>>>> [<0>] io_uring_clean_tctx+0x8e/0xd0
>>>>> [<0>] io_uring_cancel_generic+0x19f/0x370
>>>>> [<0>] __io_uring_cancel+0x14/0x20
>>>>> [<0>] do_exit+0x17f/0x510
>>>>> [<0>] do_group_exit+0x35/0x90
>>>>> [<0>] get_signal+0x963/0x970
>>>>> [<0>] arch_do_signal_or_restart+0x39/0x120
>>>>> [<0>] syscall_exit_to_user_mode+0x206/0x260
>>>>> [<0>] do_syscall_64+0x8d/0x170
>>>>> [<0>] entry_SYSCALL_64_after_hwframe+0x78/0x80
>>>>> The cause is a large number of IOU kernel threads saturating the CPU
>>>>> and not exiting. When the issue occurs, CPU usage 100% and can only
>>>>> be resolved by rebooting. Each thread's appears as follows:
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork_asm
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_worker_handle_work
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_submit_work
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_issue_sqe
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_write
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] blkdev_write_iter
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] iomap_file_buffered_write
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] iomap_write_iter
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_iov_iter_readable
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_readable
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] asm_exc_page_fault
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] exc_page_fault
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] do_user_addr_fault
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] handle_mm_fault
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_fault
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_no_page
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_handle_userfault
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] handle_userfault
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] schedule
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] __schedule
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] __raw_spin_unlock_irq
>>>>> iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker_sleeping
>>>>>
>>>>> I tracked the address that triggered the fault and the related function
>>>>> graph, as well as the wake-up side of the user fault, and discovered this
>>>>> : In the IOU worker, when fault in a user space page, this space is
>>>>> associated with a userfault but does not sleep. This is because during
>>>>> scheduling, the judgment in the IOU worker context leads to early return.
>>>>> Meanwhile, the listener on the userfaultfd user side never performs a COPY
>>>>> to respond, causing the page table entry to remain empty. However, due to
>>>>> the early return, it does not sleep and wait to be awakened as in a normal
>>>>> user fault, thus continuously faulting at the same address,so CPU loop.
>>>>> Therefore, I believe it is necessary to specifically handle user faults by
>>>>> setting a new flag to allow schedule function to continue in such cases,
>>>>> make sure the thread to sleep.
>>>>>
>>>>> Patch 1  io_uring: Add new functions to handle user fault scenarios
>>>>> Patch 2  userfaultfd: Set the corresponding flag in IOU worker context
>>>>>
>>>>>  fs/userfaultfd.c |  7 ++++++
>>>>>  io_uring/io-wq.c | 57 +++++++++++++++---------------------------------
>>>>>  io_uring/io-wq.h | 45 ++++++++++++++++++++++++++++++++++++--
>>>>>  3 files changed, 68 insertions(+), 41 deletions(-)
>>>>
>>>> Do you have a test case for this? I don't think the proposed solution is
>>>> very elegant, userfaultfd should not need to know about thread workers.
>>>> I'll ponder this a bit...
>>>>
>>>> --
>>>> Jens Axboe
>>> Sorry,The issue occurs very infrequently, and I can't manually
>>> reproduce it. It's not very elegant, but for corner cases, it seems
>>> necessary to make some compromises.
>>
>> I'm going to see if I can create one. Not sure I fully understand the
>> issue yet, but I'd be surprised if there isn't a more appropriate and
>> elegant solution rather than exposing the io-wq guts and having
>> userfaultfd manipulate them. That really should not be necessary.
>>
>> --
>> Jens Axboe
> Thanks.I'm looking forward to your good news.

Well, let's hope there is! In any case, your patches could be
considerably improved if you did:

void set_userfault_flag_for_ioworker(void)
{
	struct io_worker *worker;
	if (!(current->flags & PF_IO_WORKER))
		return;
	worker = current->worker_private;
	set_bit(IO_WORKER_F_FAULT, &worker->flags);
}

void clear_userfault_flag_for_ioworker(void)
{
	struct io_worker *worker;
	if (!(current->flags & PF_IO_WORKER))
		return;
	worker = current->worker_private;
	clear_bit(IO_WORKER_F_FAULT, &worker->flags);
}

and then userfaultfd would not need any odd checking, or needing io-wq
related structures public. That'd drastically cut down on the size of
them, and make it a bit more palatable.

-- 
Jens Axboe

