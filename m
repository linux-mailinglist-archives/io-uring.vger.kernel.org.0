Return-Path: <io-uring+bounces-1088-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FFCC87E28E
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 04:26:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58FD01C20F18
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 03:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8959A20DD0;
	Mon, 18 Mar 2024 03:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VVHrqjzE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3FE20DC3;
	Mon, 18 Mar 2024 03:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710732364; cv=none; b=G7zp6kuu9YSVAmtKgiUJcNALgDrjXjO+dSVzBwmjoctvxGd6HPZ54gFT7vWdgfriFBoGenwiiiP4fvt8zDAaxC2OMl8Fpx9J66cQTpq42waTwS/MsetBSrrduiJhp20jb/EhoRpelSA7XDT0JZQvo2PeX082jXOFruYlCW8dqNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710732364; c=relaxed/simple;
	bh=/cMsv2ZtPmGzVqpIVkHMyPGLXsUYA3zvxnyw2OVs5Mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c3GUUowYdtWJwuQJNErAbxZHxcZWPv+itf5kZRHTte7vCERr3xI9y6sdMtJuCwJnasv3IdswezwwNBKhtvDrHdZZTz5J/3qiKYsutdql5jcbhhNVRKWNerK6et92liaN33EU2oJXu2IKjJRhqxaUDJuuXMjP2UMuGLy+5lcvgIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VVHrqjzE; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d47a92cfefso51455631fa.1;
        Sun, 17 Mar 2024 20:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710732360; x=1711337160; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k6XVOsoz7r7OZmMAXMyQP62xa+mpvjJfAhvz2Tw5NiA=;
        b=VVHrqjzElky25zeoWd9hGPN1izWVT80vBSqr+3mscLbjxf0XqyMzVXip97Jy6Ti3Hh
         Srt+9ThStPIQoYxLzScBucX69zVGdJqudN7KhJJnAmHz7XBCp8uqFPjYHvZSUAI8O0Az
         yTpZ2GzOnZz3uzaQ2ABX1TZ7iBPKcIeNPcocH76NAJuXxDAR7sIMBESrcdruCEZHX0vP
         cm+59XvqC8EONRZcdGAg8B96xdUEYmd8ZxWe7T7ev4iLWuxFV7F6DnK0MgauKd2QlK+0
         MtQvssno3jg3Eswdt3AinTWDeCjjieL2NIz0Adzv9iEeOxYykjWlsRC+xZckR8hAToXa
         FCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710732360; x=1711337160;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k6XVOsoz7r7OZmMAXMyQP62xa+mpvjJfAhvz2Tw5NiA=;
        b=SVNTeei4og0B5pzUbehF+NtWTbsaR93ScIS8h4is/av89Iqh3tUU2VXqaQ3Tmmcp/+
         xS+ibPpVRzVTQ1nT20scGSN/MrXHWVqY2CW0Mw3cvIfR2Us4Tsfrw7U71NjJfbJwNyZN
         BsH6NLGO5avYckHeUTYu1ivZ8ektino8x8D1gO5SktFoxT9hT2b3RkdtcqbfXA+IqJ5o
         FkAQIQ5X5MlTpSsoFvQP6/Hpx6Jw4zzH/kCbxUSpWlEmkd7p9WCWj/eYNIWJ/2ZC6OMg
         rB6iaDp0zAOBszpO12k+sHsxTijEoIK3sxYdOd5j6T6UTz6FVgCwCagaNfJl0V2coar0
         noHA==
X-Forwarded-Encrypted: i=1; AJvYcCUekO3oE7BCUVJJ4mehiUiLw3SuP1H792DVFivvLi4cCPV+k6yeyNhCkOm41wZzTz+KMs3zFtwl1oumzIMXXQ4z6lLFAX4eclODHDA=
X-Gm-Message-State: AOJu0YzDXkw0lV12VJZwGmPrV6Pt24ILPP8rbIuWhp8Hgs4eiGucf1M8
	gSPD2XbJ4gzYRqvXjlNtOqHjSd8ZjCMMfsuvnfimgxrvIQZjnd5g
X-Google-Smtp-Source: AGHT+IEzN2+Qq4jSx9d5ia4OPNQHgnQb8C+ur7Bf4zQCzUVo7juo1KML8KfZZCE0Me4zEQONIbnngA==
X-Received: by 2002:a2e:241a:0:b0:2d4:70e8:3630 with SMTP id k26-20020a2e241a000000b002d470e83630mr6282226ljk.48.1710732360259;
        Sun, 17 Mar 2024 20:26:00 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id f12-20020a056402194c00b00568fb58bc52sm802781edz.3.2024.03.17.20.25.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 20:25:59 -0700 (PDT)
Message-ID: <c5e3f169-aa9d-4612-83fc-e1a38f5669ec@gmail.com>
Date: Mon, 18 Mar 2024 03:24:39 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/14] io_uring/cmd: fix tw <-> issue_flags conversion
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <c48a7f3919eecbee0319020fd640e6b3d2e60e5f.1710720150.git.asml.silence@gmail.com>
 <Zfelt6mbVA0moyq6@fedora> <e987d48d-09c9-4b7d-9ddc-1d90f15a1bfe@kernel.dk>
 <e2167849-8034-4649-9d35-3ab266c8d0d5@gmail.com>
 <6291a6f9-61e0-4e3f-b070-b61e8764fb63@kernel.dk> <ZferOJCWcWoN2Qzf@fedora>
 <ed73a4de-0b3b-4812-8345-40ea7fa39587@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ed73a4de-0b3b-4812-8345-40ea7fa39587@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/24 03:11, Jens Axboe wrote:
> On 3/17/24 8:47 PM, Ming Lei wrote:
>> On Sun, Mar 17, 2024 at 08:40:59PM -0600, Jens Axboe wrote:
>>> On 3/17/24 8:32 PM, Pavel Begunkov wrote:
>>>> On 3/18/24 02:25, Jens Axboe wrote:
>>>>> On 3/17/24 8:23 PM, Ming Lei wrote:
>>>>>> On Mon, Mar 18, 2024 at 12:41:47AM +0000, Pavel Begunkov wrote:
>>>>>>> !IO_URING_F_UNLOCKED does not translate to availability of the deferred
>>>>>>> completion infra, IO_URING_F_COMPLETE_DEFER does, that what we should
>>>>>>> pass and look for to use io_req_complete_defer() and other variants.
>>>>>>>
>>>>>>> Luckily, it's not a real problem as two wrongs actually made it right,
>>>>>>> at least as far as io_uring_cmd_work() goes.
>>>>>>>
>>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>>> Link: https://lore.kernel.org/r/eb08e72e837106963bc7bc7dccfd93d646cc7f36.1710514702.git.asml.silence@gmail.com
>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> oops, I should've removed all the signed-offs
>>>>
>>>>>>> ---
>>>>>>>    io_uring/uring_cmd.c | 10 ++++++++--
>>>>>>>    1 file changed, 8 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>>>>> index f197e8c22965..ec38a8d4836d 100644
>>>>>>> --- a/io_uring/uring_cmd.c
>>>>>>> +++ b/io_uring/uring_cmd.c
>>>>>>> @@ -56,7 +56,11 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
>>>>>>>    static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>>>>>>>    {
>>>>>>>        struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>>>>>>> -    unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
>>>>>>> +    unsigned issue_flags = IO_URING_F_UNLOCKED;
>>>>>>> +
>>>>>>> +    /* locked task_work executor checks the deffered list completion */
>>>>>>> +    if (ts->locked)
>>>>>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
>>>>>>>          ioucmd->task_work_cb(ioucmd, issue_flags);
>>>>>>>    }
>>>>>>> @@ -100,7 +104,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
>>>>>>>        if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>>>>>>>            /* order with io_iopoll_req_issued() checking ->iopoll_complete */
>>>>>>>            smp_store_release(&req->iopoll_completed, 1);
>>>>>>> -    } else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
>>>>>>> +    } else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
>>>>>>> +        if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
>>>>>>> +            return;
>>>>>>>            io_req_complete_defer(req);
>>>>>>>        } else {
>>>>>>>            req->io_task_work.func = io_req_task_complete;
>>>>>>
>>>>>> 'git-bisect' shows the reported warning starts from this patch.
>>>>
>>>> Thanks Ming
>>>>
>>>>>
>>>>> That does make sense, as probably:
>>>>>
>>>>> +    /* locked task_work executor checks the deffered list completion */
>>>>> +    if (ts->locked)
>>>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
>>>>>
>>>>> this assumption isn't true, and that would mess with the task management
>>>>> (which is in your oops).
>>>>
>>>> I'm missing it, how it's not true?
>>>>
>>>>
>>>> static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
>>>> {
>>>>      ...
>>>>      if (ts->locked) {
>>>>          io_submit_flush_completions(ctx);
>>>>          ...
>>>>      }
>>>> }
>>>>
>>>> static __cold void io_fallback_req_func(struct work_struct *work)
>>>> {
>>>>      ...
>>>>      mutex_lock(&ctx->uring_lock);
>>>>      llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
>>>>          req->io_task_work.func(req, &ts);
>>>>      io_submit_flush_completions(ctx);
>>>>      mutex_unlock(&ctx->uring_lock);
>>>>      ...
>>>> }
>>>
>>> I took a look too, and don't immediately see it. Those are also the two
>>> only cases I found, and before the patches, looks fine too.
>>>
>>> So no immediate answer there... But I can confirm that before this
>>> patch, test passes fine. With the patch, it goes boom pretty quick.
>>> Either directly off putting the task, or an unrelated memory crash
>>> instead.
>>
>> In ublk, the translated 'issue_flags' is passed to io_uring_cmd_done()
>> from ioucmd->task_work_cb()(__ublk_rq_task_work()). That might be
>> related with the reason.
> 
> Or maybe ublk is doing multiple invocations of task_work completions? I
> added this:
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index a2cb8da3cc33..ba7641b380a9 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -739,6 +739,7 @@ static void io_put_task_remote(struct task_struct *task)
>   {
>          struct io_uring_task *tctx = task->io_uring;
>   
> +       WARN_ON_ONCE(!percpu_counter_read(&tctx->inflight));
>          percpu_counter_sub(&tctx->inflight, 1);
>          if (unlikely(atomic_read(&tctx->in_cancel)))
>                  wake_up(&tctx->wait);
> 
> and hit this:
> 
> [   77.386845] ------------[ cut here ]------------
> [   77.387128] WARNING: CPU: 5 PID: 109 at io_uring/io_uring.c:742
> io_put_task_remote+0x164/0x1a8
> [   77.387608] Modules linked in:
> [   77.387784] CPU: 5 PID: 109 Comm: kworker/5:1 Not tainted
> 6.8.0-11436-g340741d86a53-dirty #5750
> [   77.388277] Hardware name: linux,dummy-virt (DT)
> [   77.388601] Workqueue: events io_fallback_req_func
> [   77.388930] pstate: 81400005 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS
> BTYPE=--)
> [   77.389402] pc : io_put_task_remote+0x164/0x1a8
> [   77.389711] lr : __io_submit_flush_completions+0x8b8/0x1308
> [   77.390087] sp : ffff800087327a60
> [   77.390317] x29: ffff800087327a60 x28: 1fffe0002040b329 x27:
> 1fffe0002040b32f
> [   77.390817] x26: ffff000103c4e900 x25: ffff000102059900 x24:
> ffff000104670000
> [   77.391314] x23: ffff0000d2195000 x22: 00000000002ce20c x21:
> ffff0000ced4fcc8
> [   77.391787] x20: ffff0000ced4fc00 x19: ffff000103c4e900 x18:
> 0000000000000000
> [   77.392209] x17: ffff8000814b0c34 x16: ffff8000814affac x15:
> ffff8000814ac4a8
> [   77.392633] x14: ffff80008069327c x13: ffff800080018c9c x12:
> ffff600020789d26
> [   77.393055] x11: 1fffe00020789d25 x10: ffff600020789d25 x9 :
> dfff800000000000
> [   77.393479] x8 : 00009fffdf8762db x7 : ffff000103c4e92b x6 :
> 0000000000000001
> [   77.393904] x5 : ffff000103c4e928 x4 : ffff600020789d26 x3 :
> 1fffe0001a432a7a
> [   77.394334] x2 : 1fffe00019da9f9a x1 : 0000000000000000 x0 :
> 0000000000000000
> [   77.394761] Call trace:
> [   77.394913]  io_put_task_remote+0x164/0x1a8
> [   77.395168]  __io_submit_flush_completions+0x8b8/0x1308
> [   77.395481]  io_fallback_req_func+0x138/0x1e8
> [   77.395742]  process_one_work+0x538/0x1048
> [   77.395992]  worker_thread+0x760/0xbd4
> [   77.396221]  kthread+0x2dc/0x368
> [   77.396417]  ret_from_fork+0x10/0x20
> [   77.396634] ---[ end trace 0000000000000000 ]---
> [   77.397706] ------------[ cut here ]------------
> 
> which is showing either an imbalance in the task references, or multiple
> completions from the same io_uring request.
> 
> Anyway, I'll pop back in tomrrow, but hopefully the above is somewhat
> useful at least. I'd suspect the __ublk_rq_task_work() abort check for
> current != ubq->ubq_daemon and what happens off that.

We can enable refcounting for all requests, then it should trigger
on double free. i.e. adding io_req_set_refcount(req) somewhere in
io_init_req().

-- 
Pavel Begunkov

