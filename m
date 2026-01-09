Return-Path: <io-uring+bounces-11575-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F90D0C8B7
	for <lists+io-uring@lfdr.de>; Sat, 10 Jan 2026 00:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0AF903005F24
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 23:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4008D33986B;
	Fri,  9 Jan 2026 23:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ru4dph15"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com [209.85.167.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0272221F03
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 23:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768001271; cv=none; b=MlDyMUUV9gcz7ezhUTuvJLBHoUwms3zyMbQ7EULfDlNYpoHd9HvyGTTN8qNjVMAxpVOHLf5RQDUdTYiHmqTfEhsyFLT8o23olWFAal3UtJvLfJ3Or0FpWQGVQup0XAqDbsweguApX6oBg5kyAWAAaouTNwwooHyIckPBbi9ofq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768001271; c=relaxed/simple;
	bh=e8DDkpxEyyWVv7VSwcX1gZwlz737amrYaFcXBmvF0bM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u4BfD/46q729vnU8iTc/8Uc2Xs+8Hng2JyLl5bvSBCefI43cQI5um9wNXErqkZLThNSz6lJQsi9mGIh3DrZ/Bo2lo+mhIErT9quGh5zb8uIeBBUuhpnwegFv3tcCyXW2MQN940Ha3tN8N0V/YS9hOn1KMFBibzJsYsTzBQknH7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ru4dph15; arc=none smtp.client-ip=209.85.167.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f196.google.com with SMTP id 5614622812f47-455749af2e1so2355608b6e.1
        for <io-uring@vger.kernel.org>; Fri, 09 Jan 2026 15:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768001267; x=1768606067; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RwJGJOdZDQ+JgKt/ULkFCB3nH1Xo5nlwlIOoiTtZFRk=;
        b=ru4dph15NjbNI8oKwuyq3h87jeRyKjC9zQpvpKGJFP+dgmLtQmS7bxL/9NLAaLndAn
         eiizxLFqKXTomlbUyihJ1XryM/fp54BvlRs/XiZMFnVPrL7llMwDDbyRP7zklkOzbMbZ
         5dpQZlqkn5w5ztJAjkSXr7UfszK0LNVsk76yav8D9Pd7rqfraHhj5pnVxkiIUJoKE981
         bEGSjHsRH5VpS4H0i5Uno+d92nVl/P6dEXu6XJnPQ86rBJAeUoWhRzTUz7+ki0Gx+3L+
         6NFQCa919DdOJ523dc57fSLefKjfR+UP7WI6oLUEm6QVTkjYh4ZtbYagQJLEQRD0myMy
         29Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768001267; x=1768606067;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RwJGJOdZDQ+JgKt/ULkFCB3nH1Xo5nlwlIOoiTtZFRk=;
        b=uMkzSjFwdpxT75GH1jQxTHB+29fH3rx9LJmrCcP5xCJWDowTuVABU1CZAV6jcJIXhH
         5XoJdSw6MVQIhnzENFD8iBLV641v1RgGgDfAHETJRoyLPYvRT9PCJLl2Kdw/8JkB+isf
         1lSW2k99z/1WOFqF6JvLARmI4icVxia/He7zv2KhnUFsefJunUyoz3hAPsLXKsW+jimR
         BKHNlpbggvGvQQblQK+lt/bXGhHRnzzxuCr2xRDy+zBaEr+r44n/u5MPzo0N7od5u3Hr
         a9o+Oh2+Hmw2K2+Vj46RpwNqRyv1MCTxomwbPpPxUBAMm0ynuyB/t+hbuwC9T94DbQUk
         Ek8Q==
X-Forwarded-Encrypted: i=1; AJvYcCURtoX+QUS847K3i83m5a2uqNwZA2BTv7E43EFjxupuuP4BFGUOroKW19bQludodN8mIJZbfG886A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyA+UBmaj76jMmXPYpF4boO9NwHLCj3Qbx0z8qt/VEYGvJHmwzg
	LD7tSRMaKDKBWB0LB7/RQ1JZknZTV2B24Y+QSAB6yzDWbP6l4XiScHB00Sfz0bJrHxU=
X-Gm-Gg: AY/fxX5rE47qtMFi6UyjaAufsUZbeARFUpDilzU0cqjtE7boEhXKSfFNvTAqfXtXDvF
	p5sTtUdPaTciOHS8c82NxcExE/Hkxh3PPMd5c6PVsY7tBGhdsnLsjGryqtPcXDlwxGmfzPAxvJN
	EzXGKrSd8OCNzCldR4PV5QiALvdobuXF6mtWo6ostf8CAc1WzgdQYfeCRuVHU8Vo1JohLNBoDS7
	vQ6WRqTwEVb2RQ2/Xuw2S8TOMJu3M6xG9iOQD72wxsDol1RFeC3+lZ9GkTH85kXtYUM/cwoTJx7
	HHcq+ez1UypPqGE7V4JXRQ7Biny4cDSxfVrzMFQDhvZQaE6xRaVIaWHTapy1ZMBaTVqzbZQFSac
	UmiLic18LlhBS/QdZePOgrG0JPhwITrME/aCxeJMaMG6mVSwpOkh6kN66yrBx/n1gBOub99B8L4
	Lm0Ajm9FkS
X-Google-Smtp-Source: AGHT+IEAjxAmEvYCYjE0xzoKe3OhOuWbL8JiooofPLGZf6YxfwheZQJ8Cej9eY8RspJaW9xOKn2XVA==
X-Received: by 2002:a05:6808:11ca:b0:450:4164:141e with SMTP id 5614622812f47-45a6b875c83mr6013034b6e.33.1768001266653;
        Fri, 09 Jan 2026 15:27:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm5355091b6e.22.2026.01.09.15.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 15:27:45 -0800 (PST)
Message-ID: <9006a5ad-11c0-4b37-8c7c-ad20a09da081@kernel.dk>
Date: Fri, 9 Jan 2026 16:27:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
To: Diangang Li <lidiangang@bytedance.com>,
 Fengnan Chang <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
 <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
 <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
 <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk>
 <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com>
 <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk>
 <f987df2c-f9a7-4656-b725-7a30651b4d86@gmail.com>
 <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk>
 <f2836fb8-9ad7-4277-948b-430dcd24d1b6@bytedance.com>
 <9a8418d8-439f-4dd2-b3fe-33567129861e@kernel.dk>
 <e0dfa76c-c28a-4684-81b4-6ce784ee9a3c@bytedance.com>
 <c360b8bc-fcf9-4a36-8208-9451aaeb9f41@bytedance.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <c360b8bc-fcf9-4a36-8208-9451aaeb9f41@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/26 1:35 AM, Diangang Li wrote:
> On 2025/12/19 13:43, Diangang Li wrote:
>>
>>
>> On 2025/12/18 00:25, Jens Axboe wrote:
>>> On 12/17/25 5:34 AM, Diangang Li wrote:
>>>> Hi Jens,
>>>>
>>>> We?ve identified one critical panic issue here.
>>>>
>>>> [ 4504.422964] [  T63683] list_del corruption, ff2adc9b51d19a90->next is
>>>> LIST_POISON1 (dead000000000100)
>>>> [ 4504.422994] [  T63683] ------------[ cut here ]------------
>>>> [ 4504.422995] [  T63683] kernel BUG at lib/list_debug.c:56!
>>>> [ 4504.423006] [  T63683] Oops: invalid opcode: 0000 [#1] SMP NOPTI
>>>> [ 4504.423017] [  T63683] CPU: 38 UID: 0 PID: 63683 Comm: io_uring
>>>> Kdump: loaded Tainted: G S          E       6.19.0-rc1+ #1
>>>> PREEMPT(voluntary)
>>>> [ 4504.423032] [  T63683] Tainted: [S]=CPU_OUT_OF_SPEC, 
>>>> [E]=UNSIGNED_MODULE
>>>> [ 4504.423040] [  T63683] Hardware name: Inventec S520-A6/Nanping MLB,
>>>> BIOS 01.01.01.06.03 03/03/2023
>>>> [ 4504.423050] [  T63683] RIP:
>>>> 0010:__list_del_entry_valid_or_report+0x94/0x100
>>>> [ 4504.423064] [  T63683] Code: 89 fe 48 c7 c7 f0 78 87 b5 e8 38 07 ae
>>>> ff 0f 0b 48 89 ef e8 6e 40 cd ff 48 89 ea 48 89 de 48 c7 c7 20 79 87 b5
>>>> e8 1c 07 ae ff <0f> 0b 4c 89 e7 e8 52 40 cd ff 4c 89 e2 48 89 de 48 c7
>>>> c7 58 79 87
>>>> [ 4504.423085] [  T63683] RSP: 0018:ff4efd9f3838fdb0 EFLAGS: 00010246
>>>> [ 4504.423093] [  T63683] RAX: 000000000000004e RBX: ff2adc9b51d19a90
>>>> RCX: 0000000000000027
>>>> [ 4504.423103] [  T63683] RDX: 0000000000000000 RSI: 0000000000000001
>>>> RDI: ff2add151cf99580
>>>> [ 4504.423112] [  T63683] RBP: dead000000000100 R08: 0000000000000000
>>>> R09: 0000000000000003
>>>> [ 4504.423120] [  T63683] R10: ff4efd9f3838fc60 R11: ff2add151cdfffe8
>>>> R12: dead000000000122
>>>> [ 4504.423130] [  T63683] R13: ff2adc9b51d19a00 R14: 0000000000000000
>>>> R15: 0000000000000000
>>>> [ 4504.423139] [  T63683] FS:  00007fae4f7ff6c0(0000)
>>>> GS:ff2add15665f5000(0000) knlGS:0000000000000000
>>>> [ 4504.423148] [  T63683] CS:  0010 DS: 0000 ES: 0000 CR0: 
>>>> 0000000080050033
>>>> [ 4504.423157] [  T63683] CR2: 000055aa8afe5000 CR3: 00000083037ee006
>>>> CR4: 0000000000773ef0
>>>> [ 4504.423166] [  T63683] PKRU: 55555554
>>>> [ 4504.423171] [  T63683] Call Trace:
>>>> [ 4504.423178] [  T63683]  <TASK>
>>>> [ 4504.423184] [  T63683]  io_do_iopoll+0x298/0x330
>>>> [ 4504.423193] [  T63683]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
>>>> [ 4504.423204] [  T63683]  __do_sys_io_uring_enter+0x421/0x770
>>>> [ 4504.423214] [  T63683]  do_syscall_64+0x67/0xf00
>>>> [ 4504.423223] [  T63683]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>>> [ 4504.423232] [  T63683] RIP: 0033:0x55aa707e99c3
>>>>
>>>> It can be reproduced in three ways:
>>>> - Running iopoll tests while switching the block scheduler
>>>> - A split IO scenario in iopoll (e.g., bs=512k with max_sectors_kb=256k)
>>>> - Multi poll queues with multi threads
>>>>
>>>> All cases appear related to IO completions occurring outside the
>>>> io_do_iopoll() loop. The root cause remains unclear.
>>>
>>> Ah I see what it is - we can get multiple completions on the iopoll
>>> side, if you have multiple bio's per request. This didn't matter before
>>> the patch that uses a lockless list to collect them, as it just marked
>>> the request completed by writing to ->iopoll_complete and letting the
>>> reaper find them. But it matters with the llist change, as then we're
>>> adding the request to the llist more than once.
>>>
>>>
>>
>>  From e2f749299e3c76ef92d3edfd9f8f7fc9a029129a Mon Sep 17 00:00:00 2001
>> From: Diangang Li <lidiangang@bytedance.com>
>> Date: Fri, 19 Dec 2025 10:14:33 +0800
>> Subject: [PATCH] io_uring: fix race between adding to ctx->iopoll_list 
>> and ctx->iopoll_complete
>> MIME-Version: 1.0
>> Content-Type: text/plain; charset=UTF-8
>> Content-Transfer-Encoding: 8bit
>>
>> Since commit 316693eb8aed ("io_uring: be smarter about handling IOPOLL
>> completions") introduced ctx->iopoll_complete to cache polled 
>> completions, a request can be enqueued to ctx->iopoll_complete as part 
>> of a batched poll while it is still in the issuing path.
>>
>> If the IO was submitted via io_wq_submit_work(), it may still be stuck 
>> in io_iopoll_req_issued() waiting for ctx->uring_lock, which is held by
>> io_do_iopoll(). In this state, io_do_iopoll() may attempt to delete the
>> request from ctx->iopoll_list before it has ever been linked, leading to 
>> a list_del() corruption.
>>
>> Fix this by introducing an iopoll_state flag to mark whether the request
>> has been inserted into ctx->iopoll_list. When io_do_iopoll() tries to
>> unlink a request and the flag indicates it hasn?t been linked yet, skip
>> the list_del() and just requeue the completion to ctx->iopoll_complete 
>> for later reap.
>>
>> Signed-off-by: Diangang Li <lidiangang@bytedance.com>
>> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
>> ---
>>   include/linux/io_uring_types.h | 1 +
>>   io_uring/io_uring.c            | 1 +
>>   io_uring/rw.c                  | 7 +++++++
>>   io_uring/uring_cmd.c           | 1 +
>>   4 files changed, 10 insertions(+)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/ 
>> io_uring_types.h
>> index 0f619c37dce4..aaf26911badb 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -677,6 +677,7 @@ struct io_kiocb {
>>       };
>>
>>       u8                opcode;
>> +    u8                iopoll_state;
>>
>>       bool                cancel_seq_set;
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 5e503a0bfcfc..4eb206359d05 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1692,6 +1692,7 @@ static void io_iopoll_req_issued(struct io_kiocb 
>> *req, unsigned int issue_flags)
>>       }
>>
>>       list_add_tail(&req->iopoll_node, &ctx->iopoll_list);
>> +    smp_store_release(&req->iopoll_state, 1);
>>
>>       if (unlikely(needs_lock)) {
>>           /*
>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>> index ad481ca74a46..d1397739c58b 100644
>> --- a/io_uring/rw.c
>> +++ b/io_uring/rw.c
>> @@ -869,6 +869,7 @@ static int io_rw_init_file(struct io_kiocb *req, 
>> fmode_t mode, int rw_type)
>>               return -EOPNOTSUPP;
>>           kiocb->private = NULL;
>>           kiocb->ki_flags |= IOCB_HIPRI;
>> +        req->iopoll_state = 0;
>>           if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
>>               /* make sure every req only blocks once*/
>>               req->flags &= ~REQ_F_IOPOLL_STATE;
>> @@ -1355,6 +1356,12 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool 
>> force_nonspin)
>>           struct llist_node *next = node->next;
>>
>>           req = container_of(node, struct io_kiocb, iopoll_done_list);
>> +        if (!READ_ONCE(req->iopoll_state)) {
>> +            node->next = NULL;
>> +            llist_add(&req->iopoll_done_list, &ctx->iopoll_complete);
>> +            node = next;
>> +            continue;
>> +        }
>>           list_del(&req->iopoll_node);
>>           wq_list_add_tail(&req->comp_list, &ctx->submit_state.compl_reqs);
>>           nr_events++;
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index 0841fa541f5d..cf2eacea5be8 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -251,6 +251,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int 
>> issue_flags)
>>           if (!file->f_op->uring_cmd_iopoll)
>>               return -EOPNOTSUPP;
>>           issue_flags |= IO_URING_F_IOPOLL;
>> +        req->iopoll_state = 0;
>>           if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
>>               /* make sure every req only blocks once */
>>               req->flags &= ~REQ_F_IOPOLL_STATE;
> 
> Hi Jens,
> 
> Regarding the analysis of this list_del corruption issue and the fix 
> patch, do you have any other comments?

I just dropped the second part of the iopoll changes, so it's back to
just this one:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/commit/?h=for-7.0/io_uring&id=3c7d76d6128a0fef68e6540754bf85a44a29bb59

I didn't have an immediately good idea for solving it without doing more
locking and/or synchronization, and I wasn't convinced it was worth it.

I'll ponder it some more next week and pick it back up.

-- 
Jens Axboe

