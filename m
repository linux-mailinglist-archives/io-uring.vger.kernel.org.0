Return-Path: <io-uring+bounces-1087-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F90D87E26C
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 04:11:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24DC3280D72
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 03:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9111E866;
	Mon, 18 Mar 2024 03:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nkFM2F+e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD791E521
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 03:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710731492; cv=none; b=XU8pEqYjA75bhIwaFSe0m22aqo/NMQdW1u+wStWoJ6ICVUEcAzmRENLtbWSoln5qul8VkaFr61XapFXnZbz4JxX+Gd37W5nUKtzORuP6Ylwm9lDu1pTIucc8UstjEW9jSyJMf+YZzKkWhEx20aWc/7i1qHdw2m4j+w+MtvWg+cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710731492; c=relaxed/simple;
	bh=7ZYI8wWik8BAdI81doACjysjZCUOGRfaadhidEHiCF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rQ+2mIIFCvci6XajsS6Y8qHOdnzvBEaotvLXfGIGMMeTAwfmPIVBinetIFkm3TUXVILBbUpnHceDCZoMRLnqcUEMHdTE7CMjMUoLWFNqp1OBd7Jc5VEg6XN8gBFxG7KpYtM5m4dYBX8a4e9a6MRZvTJLcBW0Df3ldllrfC4ttHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nkFM2F+e; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-29c572d4b84so1424443a91.1
        for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 20:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710731489; x=1711336289; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TKOH4UOC+T62FuaSBnyxg28q/LaycVD0Ddsbk4tqUmY=;
        b=nkFM2F+eMrHoyKynWa9GXNF1ZaqFUIJngpeCe6piYNd9CWSlugWFdtu8jjSxZt2IpP
         f+mkCDbDr4/CV02p8bP6MzS30mriEa052JQlaVEzqDG7m5XYIPxrphB9xwYRkKNrcXhw
         a2tuH9rW90ly+kw+G1Svk5z3tntWVLcwm6rORSqvseMKWMZz0/+2AyoC1XbjQy+VXGzD
         Ist0dlivGhfAGtMzXpw+BTYq1hNI6Vv1XMlKzKLQ7jSlamLacGoOmS84PmPbiPymrNG5
         +a9C8VWRUjfIcpSiwTKAQQMZ1ESm9jlo0+whLLNpy1JuDxqMDwzhU6FHT+EQ4nwcXU/l
         NNQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710731489; x=1711336289;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TKOH4UOC+T62FuaSBnyxg28q/LaycVD0Ddsbk4tqUmY=;
        b=IH04RTEcxqxrOVF0KCbaL1gf5IwtxpITO0LM7SbUHauy9GQoKSBs6vpUcfqsGLshrR
         LHCT1Ww+DqqG//s6vbIoCNMib+2n7K3eMazrU4SVdV6NgRQDwuFqc+H3KnSVfzyfv7e1
         PHezjkc9+rFqcx6xhei+o+Ep82PGjr7UkiZ/t7speO6OKfZk3sCBFAxAhX4pZLFkR+Iq
         LTSPV3SCvP8fgcyvg3rXJdiRxkcpjgjW6U1/eY7RAWuI3z0ILDFsctjrrDEnKiRsvd8j
         mr0GiipUI9Pst3S/l4Qe5wPa63RHlkKDDS6H8C7WgUrjLpLcR2zsnPJP6sCXdU9qQle/
         F8UQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4IQDWp63bKU5HWqE02P0hw3rd/aP4losRLKhUiloVKtN43SOsR3EV3FGoZo6e49pGTJ/Gcky74grkwpxoTsOCRwSUjomgFMM=
X-Gm-Message-State: AOJu0YxxPmx7BD2dDxpYDC0agR9Frnwz/CET88xWj58u6kuji+mMl5rO
	kbQxddG84djPWtyjiDgkEs/fpGMpMreE9EEyPUAPy6xRQ35omPMyYADIbeA+8i8=
X-Google-Smtp-Source: AGHT+IHtXi1fd7fNTcTH2WvLlZd4ZCnbcBWHGOgNqZXYmnBvJ2yuJJvEVExzW9mXGPRdAY9OPZP/eA==
X-Received: by 2002:a05:6a21:3a4a:b0:1a1:67a6:511e with SMTP id zu10-20020a056a213a4a00b001a167a6511emr14205186pzb.2.1710731488765;
        Sun, 17 Mar 2024 20:11:28 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id g26-20020aa7875a000000b006e6750de82asm6888699pfo.1.2024.03.17.20.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 20:11:28 -0700 (PDT)
Message-ID: <ed73a4de-0b3b-4812-8345-40ea7fa39587@kernel.dk>
Date: Sun, 17 Mar 2024 21:11:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/14] io_uring/cmd: fix tw <-> issue_flags conversion
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <c48a7f3919eecbee0319020fd640e6b3d2e60e5f.1710720150.git.asml.silence@gmail.com>
 <Zfelt6mbVA0moyq6@fedora> <e987d48d-09c9-4b7d-9ddc-1d90f15a1bfe@kernel.dk>
 <e2167849-8034-4649-9d35-3ab266c8d0d5@gmail.com>
 <6291a6f9-61e0-4e3f-b070-b61e8764fb63@kernel.dk> <ZferOJCWcWoN2Qzf@fedora>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZferOJCWcWoN2Qzf@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/17/24 8:47 PM, Ming Lei wrote:
> On Sun, Mar 17, 2024 at 08:40:59PM -0600, Jens Axboe wrote:
>> On 3/17/24 8:32 PM, Pavel Begunkov wrote:
>>> On 3/18/24 02:25, Jens Axboe wrote:
>>>> On 3/17/24 8:23 PM, Ming Lei wrote:
>>>>> On Mon, Mar 18, 2024 at 12:41:47AM +0000, Pavel Begunkov wrote:
>>>>>> !IO_URING_F_UNLOCKED does not translate to availability of the deferred
>>>>>> completion infra, IO_URING_F_COMPLETE_DEFER does, that what we should
>>>>>> pass and look for to use io_req_complete_defer() and other variants.
>>>>>>
>>>>>> Luckily, it's not a real problem as two wrongs actually made it right,
>>>>>> at least as far as io_uring_cmd_work() goes.
>>>>>>
>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>> Link: https://lore.kernel.org/r/eb08e72e837106963bc7bc7dccfd93d646cc7f36.1710514702.git.asml.silence@gmail.com
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> oops, I should've removed all the signed-offs
>>>
>>>>>> ---
>>>>>>   io_uring/uring_cmd.c | 10 ++++++++--
>>>>>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>>>> index f197e8c22965..ec38a8d4836d 100644
>>>>>> --- a/io_uring/uring_cmd.c
>>>>>> +++ b/io_uring/uring_cmd.c
>>>>>> @@ -56,7 +56,11 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
>>>>>>   static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>>>>>>   {
>>>>>>       struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>>>>>> -    unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
>>>>>> +    unsigned issue_flags = IO_URING_F_UNLOCKED;
>>>>>> +
>>>>>> +    /* locked task_work executor checks the deffered list completion */
>>>>>> +    if (ts->locked)
>>>>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
>>>>>>         ioucmd->task_work_cb(ioucmd, issue_flags);
>>>>>>   }
>>>>>> @@ -100,7 +104,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
>>>>>>       if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>>>>>>           /* order with io_iopoll_req_issued() checking ->iopoll_complete */
>>>>>>           smp_store_release(&req->iopoll_completed, 1);
>>>>>> -    } else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
>>>>>> +    } else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
>>>>>> +        if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
>>>>>> +            return;
>>>>>>           io_req_complete_defer(req);
>>>>>>       } else {
>>>>>>           req->io_task_work.func = io_req_task_complete;
>>>>>
>>>>> 'git-bisect' shows the reported warning starts from this patch.
>>>
>>> Thanks Ming
>>>
>>>>
>>>> That does make sense, as probably:
>>>>
>>>> +    /* locked task_work executor checks the deffered list completion */
>>>> +    if (ts->locked)
>>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
>>>>
>>>> this assumption isn't true, and that would mess with the task management
>>>> (which is in your oops).
>>>
>>> I'm missing it, how it's not true?
>>>
>>>
>>> static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
>>> {
>>>     ...
>>>     if (ts->locked) {
>>>         io_submit_flush_completions(ctx);
>>>         ...
>>>     }
>>> }
>>>
>>> static __cold void io_fallback_req_func(struct work_struct *work)
>>> {
>>>     ...
>>>     mutex_lock(&ctx->uring_lock);
>>>     llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
>>>         req->io_task_work.func(req, &ts);
>>>     io_submit_flush_completions(ctx);
>>>     mutex_unlock(&ctx->uring_lock);
>>>     ...
>>> }
>>
>> I took a look too, and don't immediately see it. Those are also the two
>> only cases I found, and before the patches, looks fine too.
>>
>> So no immediate answer there... But I can confirm that before this
>> patch, test passes fine. With the patch, it goes boom pretty quick.
>> Either directly off putting the task, or an unrelated memory crash
>> instead.
> 
> In ublk, the translated 'issue_flags' is passed to io_uring_cmd_done()
> from ioucmd->task_work_cb()(__ublk_rq_task_work()). That might be
> related with the reason.

Or maybe ublk is doing multiple invocations of task_work completions? I
added this:

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a2cb8da3cc33..ba7641b380a9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -739,6 +739,7 @@ static void io_put_task_remote(struct task_struct *task)
 {
        struct io_uring_task *tctx = task->io_uring;
 
+       WARN_ON_ONCE(!percpu_counter_read(&tctx->inflight));
        percpu_counter_sub(&tctx->inflight, 1);
        if (unlikely(atomic_read(&tctx->in_cancel)))
                wake_up(&tctx->wait);

and hit this:

[   77.386845] ------------[ cut here ]------------
[   77.387128] WARNING: CPU: 5 PID: 109 at io_uring/io_uring.c:742
io_put_task_remote+0x164/0x1a8
[   77.387608] Modules linked in:
[   77.387784] CPU: 5 PID: 109 Comm: kworker/5:1 Not tainted
6.8.0-11436-g340741d86a53-dirty #5750
[   77.388277] Hardware name: linux,dummy-virt (DT)
[   77.388601] Workqueue: events io_fallback_req_func
[   77.388930] pstate: 81400005 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS
BTYPE=--)
[   77.389402] pc : io_put_task_remote+0x164/0x1a8
[   77.389711] lr : __io_submit_flush_completions+0x8b8/0x1308
[   77.390087] sp : ffff800087327a60
[   77.390317] x29: ffff800087327a60 x28: 1fffe0002040b329 x27:
1fffe0002040b32f
[   77.390817] x26: ffff000103c4e900 x25: ffff000102059900 x24:
ffff000104670000
[   77.391314] x23: ffff0000d2195000 x22: 00000000002ce20c x21:
ffff0000ced4fcc8
[   77.391787] x20: ffff0000ced4fc00 x19: ffff000103c4e900 x18:
0000000000000000
[   77.392209] x17: ffff8000814b0c34 x16: ffff8000814affac x15:
ffff8000814ac4a8
[   77.392633] x14: ffff80008069327c x13: ffff800080018c9c x12:
ffff600020789d26
[   77.393055] x11: 1fffe00020789d25 x10: ffff600020789d25 x9 :
dfff800000000000
[   77.393479] x8 : 00009fffdf8762db x7 : ffff000103c4e92b x6 :
0000000000000001
[   77.393904] x5 : ffff000103c4e928 x4 : ffff600020789d26 x3 :
1fffe0001a432a7a
[   77.394334] x2 : 1fffe00019da9f9a x1 : 0000000000000000 x0 :
0000000000000000
[   77.394761] Call trace:
[   77.394913]  io_put_task_remote+0x164/0x1a8
[   77.395168]  __io_submit_flush_completions+0x8b8/0x1308
[   77.395481]  io_fallback_req_func+0x138/0x1e8
[   77.395742]  process_one_work+0x538/0x1048
[   77.395992]  worker_thread+0x760/0xbd4
[   77.396221]  kthread+0x2dc/0x368
[   77.396417]  ret_from_fork+0x10/0x20
[   77.396634] ---[ end trace 0000000000000000 ]---
[   77.397706] ------------[ cut here ]------------

which is showing either an imbalance in the task references, or multiple
completions from the same io_uring request.

Anyway, I'll pop back in tomrrow, but hopefully the above is somewhat
useful at least. I'd suspect the __ublk_rq_task_work() abort check for
current != ubq->ubq_daemon and what happens off that.

-- 
Jens Axboe


