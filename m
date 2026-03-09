Return-Path: <io-uring+bounces-12604-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2EqmBKgcr2lzOAIAu9opvQ
	(envelope-from <io-uring+bounces-12604-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 20:16:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E8023F8AD
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 20:16:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 03C963008D1A
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 19:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5050F35836E;
	Mon,  9 Mar 2026 19:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BNCwSG9V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D982EC0AE
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 19:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773083806; cv=none; b=SaTuDcY7pERJPjVreURlWG4EXcswufMULWpmFGfMDWrYSrsE9R2qWQio1NS07aPkOxxaZEv0CCRoZWiQX79Ibsvq+HoBr1VoZCMMY4Uj5psvd5WdaA5z29dG/TF+dbCDGR9SI5gV5XRuobZBFxmiG1f4vIT0e15bnWs0ercA2Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773083806; c=relaxed/simple;
	bh=gm5ZHiTykznc54cozrKRNHsw3xW2CI54z05XzFree8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pM2ieXA7tS8SKJMx+d2TglWXw6LeaXMNr8aXVqpOraghg4HwJ/G70wt0CdTFl7fWUsAB5AaI8ZrswPdjhIhYGbxQzhGdWPDp/4XK42+vJGH9GeLykhFpcjcssS2l/UV8KH5SBQbX+YgiVk3ndRpnqSztnDbIa+ZmmqsqqIsekEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BNCwSG9V; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d751ef36ccso479670a34.0
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 12:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773083802; x=1773688602; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Po2pGLbEgwLu432KuCwukwC/OtGf7G7P9umGDhDAyDs=;
        b=BNCwSG9VcCSCCg4s/58uvzpxmrIrAl+wxFygUu753oR6opOUKgNRPp9pUXMl1nHsVh
         ZIDjCcX8WqubHMbnmwUw3k8IagMHy/P91qngi9uLC8nkYpzhnG9EfL8PH3JK6+fT33xq
         T0EIxjFO7ikU638GK2IIPCr0wnnnyRXegQWsCtZE7RUYlM3YbwPMd6gILNoT1PntuHkN
         WnUE7x5GguPge8w8NZlYu4CW6TqUHkrD/MeCXrjyUitLa+wDE7moSjAG5kZgUC4lixzn
         zRwms8JHa2D6kjn0jAzd8arXD4RnAcvwUUhC1CymBqNzwbCWs/mVsN6SWpGU+H1iDWfn
         yU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773083802; x=1773688602;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Po2pGLbEgwLu432KuCwukwC/OtGf7G7P9umGDhDAyDs=;
        b=drjpP+4X3y4V6ZOwjusw5g7Cbmfu4/sUSB/oB9NUAfsHBDTEsXWVMgyrIV6to1PNwn
         DhdDJOEtVwk2m2VNMJ0ZfiVTjXlFhZrwbtPHgHRcGjOz75+Yt76DNVJ5CBIJ+VJBJtZ/
         SpaXsIbYAaeg/Z8m//tHWcFQQk0ZgvS2+cuQY78pvsdcWKY3K5jbZ7SD8KpngLaQE844
         6GPCb00ormsFzTuHbYBmjXZ93F901jsvlmBrhcn2F6AOjCK0HIQw00xNLTpnh7c9Q9Js
         aIASzoTFO7N7lEOpXSvsYozXxty17nNFGOlkexCXN/dQys8ta2N/k0ef1h5xRdVb1+wK
         rOWg==
X-Forwarded-Encrypted: i=1; AJvYcCUEs73UFvL2YxGC1QhMyI0vVN4uSbjS/Dy2V9rQJVLpwQ7YiaQ72BrG49lS9Ery1I5bav8yhpQ9oA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9eQxTYW5tn8Q/EqqxTei//Ct93wmiMoNv9MXeqGqi9fPs+MS2
	8/srzk5Ha8/F8qpphmclJuEcs/hNDFf4qExzpLMPvurNDCDu5Iq62Gui6hpEmZlEwnw=
X-Gm-Gg: ATEYQzw4fi0KVSdeZyZkFV6GspqnCHjxPuTyCuzuEE4JyjnDtB1H247lin2zflwPFwx
	JLOQ7hhVNCB4SFybUYhHNrS9ZfgiGV5wg7fFBk6Cc6J2nhFcMk7omWK3fWGyhPHcMJPOg0Mif7P
	ukXm7Vm3oTazjJUlw01iXvyceYvy+BrwCIMSegkW6W9BonPU7r3XZxHnccq2OeZnbP4IXRf4TD/
	UIbSG074Bh6YGlLFNEReuH/kEyznAXKMOQU8tdOtSX1r31XjhauIe3NfIoqPfWcK1giS/KXBg0a
	alOCqMjwstfggAGu7STs44ej4Upr3A71zrlx6p9bf3sRFh3YtRjtNVw586b4SzXBitUYoOx2erv
	I27nfIgfx4rQDefTH110i7ccMamC9UlFgb7CZERSsKK8NEBL+gILfHQQjfLRau4EdU0vYFuir9n
	6ia2dP35clSiW/3HoLeAQsb3qVq26CyYY8s1R98BICAJ2KIXDoFGJ6rSGPK7fllNXOILg7PqMnl
	xgIrYfYYw==
X-Received: by 2002:a05:6830:6ad9:b0:7d7:59db:fc5b with SMTP id 46e09a7af769-7d759dc04cbmr428579a34.19.1773083801737;
        Mon, 09 Mar 2026 12:16:41 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7423ff0c0sm3747562a34.27.2026.03.09.12.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 12:16:40 -0700 (PDT)
Message-ID: <031212ee-bd05-46dd-ab2e-2be5859f3880@kernel.dk>
Date: Mon, 9 Mar 2026 13:16:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring/register.c: fix NULL pointer dereference in
 io_register_resize_rings
To: Pavel Begunkov <asml.silence@gmail.com>,
 Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Hao-Yu Yang <naup96721@gmail.com>, security@kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAHk-=wi-24g2yzRTHwJ-kD1RqK0TvuPBr0VzvuQVVzR83ddgsw@mail.gmail.com>
 <42AD516A-B078-40A5-94EE-80739B9883E7@kernel.dk>
 <453563bb-8dda-471a-901a-30ba9ff3f9c8@kernel.dk>
 <b2dec323-e512-4570-a273-724c7c94a12a@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b2dec323-e512-4570-a273-724c7c94a12a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 19E8023F8AD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12604-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,linuxfoundation.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/9/26 12:57 PM, Pavel Begunkov wrote:
> On 3/9/26 18:34, Jens Axboe wrote:
>> On 3/9/26 10:29 AM, Jens Axboe wrote:
>>> On Mar 9, 2026, at 10:05?AM, Linus Torvalds <torvalds@linuxfoundation.org> wrote:
>>>>
>>>> ?On Mon, 9 Mar 2026 at 06:11, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> You probably want something ala:
>>>>>
>>>>> mutex_lock(&ctx->mmap_lock);
>>>>> spin_lock(&ctx->completion_lock();
>>>>> + local_irq_disable();
>>>>
>>>> How could that ever work?
>>>>
>>>> Irqs will happily continue on other CPUs, so disabling interrupts is
>>>> complete nonsense as far as I can tell - whether done with
>>>> spin_lock_irq() *or* with local_irq_disable()/.
>>>>
>>>> So basically, touching ctx->rings from irq context in this section is
>>>> simply not an option - or the rings pointer just needs to be updated
>>>> atomically so that it doesn't matter.
>>>>
>>>> I assume this was tested in qemu on a single-core setup, so that
>>>> fundamental mistake was hidden by an irrelevant configuration.
>>>>
>>>> Where is the actual oops - for some inexplicable reason that had been
>>>> edited out, and it only had the call trace leading up toit? Based on
>>>> the incomplete information and the faulting address of 0x24, I'm
>>>> *guessing* that it is
>>>>
>>>>         if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
>>>>                 atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
>>>>
>>>> in io_req_normal_work_add(), but that may be complete garbage.
>>>>
>>>> So the actual fix may be to just make damn sure that
>>>> IORING_SETUP_TASKRUN_FLAG is *not* set when the rings are resized.
>>>>
>>>> But for all I know, (a) I may be looking at entirely the wrong place
>>>> and (b) there might be millions of other places that want to access
>>>> ctx->rings, so the above may be the rantings of a crazy old man.
>>>
>>> Nah you?re totally right. I?m operating in few hours of sleep and on a
>>> plane. I?ll take a closer look later. The flag mask protecting it is a
>>> good idea, another one could be just a specific irq safe resize lock
>>> would be better here.
>>
>> How about something like this? I don't particularly like using ->flags
>> for this, as these are otherwise static after the ring has been set up.
>> Hence it'd be better to to just use a separate value for this,
>> ->in_resize, and use smp_load_acquire/release. The write side can be as
>> expensive as we want it to be, as it's not a hot path at all. And the
>> acquire read should light weight enough here.
>>
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 3e4a82a6f817..428eb5b2c624 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -394,6 +394,7 @@ struct io_ring_ctx {
>>           atomic_t        cq_wait_nr;
>>           atomic_t        cq_timeouts;
>>           struct wait_queue_head    cq_wait;
>> +        int            in_resize;
>>       } ____cacheline_aligned_in_smp;
>>         /* timeouts */
>> diff --git a/io_uring/register.c b/io_uring/register.c
>> index 3378014e51fb..048a1dcd9df1 100644
>> --- a/io_uring/register.c
>> +++ b/io_uring/register.c
>> @@ -575,6 +575,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>>        * ctx->mmap_lock as well. Likewise, hold the completion lock over the
>>        * duration of the actual swap.
>>        */
>> +    smp_store_release(&ctx->in_resize, 1);
>>       mutex_lock(&ctx->mmap_lock);
>>       spin_lock(&ctx->completion_lock);
>>       o.rings = ctx->rings;
>> @@ -647,6 +648,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>>       if (ctx->sq_data)
>>           io_sq_thread_unpark(ctx->sq_data);
>>   +    smp_store_release(&ctx->in_resize, 0);
>>       return ret;
>>   }
>>   diff --git a/io_uring/tw.c b/io_uring/tw.c
>> index 1ee2b8ab07c8..c66ffa787ec7 100644
>> --- a/io_uring/tw.c
>> +++ b/io_uring/tw.c
>> @@ -152,6 +152,13 @@ void tctx_task_work(struct callback_head *cb)
>>       WARN_ON_ONCE(ret);
>>   }
>>   +static void io_mark_taskrun(struct io_ring_ctx *ctx)
>> +{
>> +    if (ctx->flags & IORING_SETUP_TASKRUN_FLAG &&
>> +        !smp_load_acquire(&ctx->in_resize))
>> +        atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
>> +}
> 
> That's not going to work, same raciness, but you can protect the
> pointer with rcu + rcu sync on resize. Tips:
> 
> 1) sq_flags might get out of sync at the end. Either say that
> users should never try to resize with inflight reqs, or just
> hand set all flags, e.g. SQ_WAKE can be set unconditionally
> 
> 2) For a fix, it'll likely be cleaner to keep ->rings as is
> and introduce a second pointer (rcu protected).

Yeah you are right, it's not enough, it just shrinks the gap but it's
still there. rcu sync on resize is probably the best way. I'll take
another look tomorrow after some sleep.

-- 
Jens Axboe


