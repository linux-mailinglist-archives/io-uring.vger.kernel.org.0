Return-Path: <io-uring+bounces-12602-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eIsvE0MYr2kiNwIAu9opvQ
	(envelope-from <io-uring+bounces-12602-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 19:58:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C1923F042
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 19:58:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6400A30166E9
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 18:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF913B894F;
	Mon,  9 Mar 2026 18:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fd/JccAz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DE32D592F
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 18:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773082629; cv=none; b=GI4cLLyGAbQGj8VWXiG0ypoFNugY1lpTEI0xIXwTSZpftmfe2X74eg7P4gJ6beSY/ehuV2YaHyWaPyQtuLIni8Bopg1NTqDb4NUk6igQ1aE+l8CewCJ3xN4ZLbmdGOSBLCEwdsUKjSkGfDY7FC4PVsxFTYC7WVlSvDe5b6/d2EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773082629; c=relaxed/simple;
	bh=ddkXI/1t8bGdXtV6N3V1Ke4AGMHLvso6jOkqNXtmz9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J3L2bQP4gC+50wSgWm5ggKY8zACXFQEACaCbW7dHfuE3KwyIixEri0ya0Vl0iCWn7GyOpuSJXRej82MSDdqLCfoI32yrRQUuDWzSM/aQjFzTxoOk/o02tml9PFZY5JI4Fg/fEnpCdJefRF1upvrj6PlifHms54AvP8r/leI/xR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fd/JccAz; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-439b9cf8cb5so7598510f8f.0
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 11:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773082627; x=1773687427; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zr2kU2xjz3QlwCs/71EPwY3SNY9NsXePOLuC3luJdGQ=;
        b=Fd/JccAz/cQA5SvFs4TrjrKmTYHUr59j8dT+Znn1ZAJ5E5uSYRNj6NCINb4EJHBmFR
         Pjc0M2tmfIDq/nEDOdh1KxffLcWfbmpfjBCJY6hisLoW956LvrMLOtax6EzuVcjVu4nV
         nI9pDC6co5VPmQQEEhktr0+z6isuSZuMFQc7J4J6B/7xsr5XcPCAmvOTTTWsBoFQi6G+
         C+Vns5fIzlDGr0IQoOI1dWyxxzDd6tlclFYh8U8dEfRtWN8lEp1zBaPM54Tn9T1ieDRg
         hR6h0uyaJRaexcJMlnia2MWRpbL265/QV/RYAEwfJ5GHmq1ty4pmfBlKGYWl6K5YkcIO
         NBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773082627; x=1773687427;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zr2kU2xjz3QlwCs/71EPwY3SNY9NsXePOLuC3luJdGQ=;
        b=iftuxFYqDJl9X1AWJ0wj8yp+ucBYBPenkvezrLI8HRuAFC3mKP9AHmikaxLmMQKYef
         7eyMnJa/bcn7CBybWZFlWVamPAIpNhyArxQwKJfz7SaoeR8xyUhyjtxzIkNcCzfwsLo6
         xbHSF5Q9IpdLjl6aL929jVcCkOfkxUCFIW2QwGrtuxXJbVLWVDFvPr55o3eziENBoDdj
         oQjlSesGGlOXuupGRyGWEr7F6A2jUafI6KrxXELbZ8Mfz1ljIvgm2CDWpZVjSAcph3RZ
         n3Mxno9b0WFMYE9d58aliH4CjdU0R6eXzJr2LbdAuMIATod4eCXksvvtu98PSwfHJTl8
         x1cQ==
X-Forwarded-Encrypted: i=1; AJvYcCVERDWk9yW0YBhit63cxImBz3ctUj3dmCE+6ZVGb2mmw0QiDC5gPP+aGFJ/KZ7K96w3mh6IvxLAxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YznZM9FaLsvKkMhYdNff2J6raMVFJMP5nl/w9uJQIo0TYKL4LIc
	ssa1CG3AV4hq42zctonGq/VHPbovj30U86UwebB6/534cuyQ3A1mho/sVUDJSg==
X-Gm-Gg: ATEYQzzR37X2BTVvPEO0uwGbExL4+mmouXN2FdjKyy256qq3KUpmR4j+0rXycyfTDUR
	MxJiF1auk+sRGgwBWSD2pbJLkTV49yOUwIzHj+HHJa/mCN710FGfdjKvUhH7/OIJb6axgp4fmnB
	644eLCqaVbkX5UyYVREQxYnxirmSGo5FHVyoj9lF/BZC8BzVAq+SSIPCLIjgjX8DmTjwncbSK0s
	K8igW/M0Bv0XyKLDuFyg2UIZKP3wUDuWnDTVIW2tbxAhZYcSTsg46t/8AGYg5q91a8iFAuVZY7J
	LG+AZXCI8Epvmwk+QH5jVdf5htv/rmpm8kWoUVq2n6dP/eJCYaz4Fi7V5wgYTMmaqEwMguYlph2
	AgLGb+Ixffmy34cSfCF1bc2CnzebKxpJS+s2mPVWmiGA2l0o+Rv7vzlEc5TUX2LBxo/lYR52LMn
	vyffr7Is5qgeh/8VduWyHLHxXAi26532tRR2aMhrxnPlDLFzcn+SOEDzXwVgdmB6CJuBszUNDHH
	4qRlaIo9+h5f5//w8WdNEa7LolZIsNAA1j8oEsYhQNB65bkYpAYakHLvt8IfZTkKgg9IKUgNLCT
	FA==
X-Received: by 2002:a05:6000:1a87:b0:439:befa:91cb with SMTP id ffacd0b85a97d-439da890301mr21113122f8f.45.1773082626447;
        Mon, 09 Mar 2026 11:57:06 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae2bdf8sm30093082f8f.25.2026.03.09.11.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 11:57:05 -0700 (PDT)
Message-ID: <b2dec323-e512-4570-a273-724c7c94a12a@gmail.com>
Date: Mon, 9 Mar 2026 18:57:04 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring/register.c: fix NULL pointer dereference in
 io_register_resize_rings
To: Jens Axboe <axboe@kernel.dk>,
 Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Hao-Yu Yang <naup96721@gmail.com>, security@kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAHk-=wi-24g2yzRTHwJ-kD1RqK0TvuPBr0VzvuQVVzR83ddgsw@mail.gmail.com>
 <42AD516A-B078-40A5-94EE-80739B9883E7@kernel.dk>
 <453563bb-8dda-471a-901a-30ba9ff3f9c8@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <453563bb-8dda-471a-901a-30ba9ff3f9c8@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 95C1923F042
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-12602-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:email,kernel.dk:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/9/26 18:34, Jens Axboe wrote:
> On 3/9/26 10:29 AM, Jens Axboe wrote:
>> On Mar 9, 2026, at 10:05?AM, Linus Torvalds <torvalds@linuxfoundation.org> wrote:
>>>
>>> ?On Mon, 9 Mar 2026 at 06:11, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> You probably want something ala:
>>>>
>>>> mutex_lock(&ctx->mmap_lock);
>>>> spin_lock(&ctx->completion_lock();
>>>> + local_irq_disable();
>>>
>>> How could that ever work?
>>>
>>> Irqs will happily continue on other CPUs, so disabling interrupts is
>>> complete nonsense as far as I can tell - whether done with
>>> spin_lock_irq() *or* with local_irq_disable()/.
>>>
>>> So basically, touching ctx->rings from irq context in this section is
>>> simply not an option - or the rings pointer just needs to be updated
>>> atomically so that it doesn't matter.
>>>
>>> I assume this was tested in qemu on a single-core setup, so that
>>> fundamental mistake was hidden by an irrelevant configuration.
>>>
>>> Where is the actual oops - for some inexplicable reason that had been
>>> edited out, and it only had the call trace leading up toit? Based on
>>> the incomplete information and the faulting address of 0x24, I'm
>>> *guessing* that it is
>>>
>>>         if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
>>>                 atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
>>>
>>> in io_req_normal_work_add(), but that may be complete garbage.
>>>
>>> So the actual fix may be to just make damn sure that
>>> IORING_SETUP_TASKRUN_FLAG is *not* set when the rings are resized.
>>>
>>> But for all I know, (a) I may be looking at entirely the wrong place
>>> and (b) there might be millions of other places that want to access
>>> ctx->rings, so the above may be the rantings of a crazy old man.
>>
>> Nah you?re totally right. I?m operating in few hours of sleep and on a
>> plane. I?ll take a closer look later. The flag mask protecting it is a
>> good idea, another one could be just a specific irq safe resize lock
>> would be better here.
> 
> How about something like this? I don't particularly like using ->flags
> for this, as these are otherwise static after the ring has been set up.
> Hence it'd be better to to just use a separate value for this,
> ->in_resize, and use smp_load_acquire/release. The write side can be as
> expensive as we want it to be, as it's not a hot path at all. And the
> acquire read should light weight enough here.
> 
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 3e4a82a6f817..428eb5b2c624 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -394,6 +394,7 @@ struct io_ring_ctx {
>   		atomic_t		cq_wait_nr;
>   		atomic_t		cq_timeouts;
>   		struct wait_queue_head	cq_wait;
> +		int			in_resize;
>   	} ____cacheline_aligned_in_smp;
>   
>   	/* timeouts */
> diff --git a/io_uring/register.c b/io_uring/register.c
> index 3378014e51fb..048a1dcd9df1 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -575,6 +575,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>   	 * ctx->mmap_lock as well. Likewise, hold the completion lock over the
>   	 * duration of the actual swap.
>   	 */
> +	smp_store_release(&ctx->in_resize, 1);
>   	mutex_lock(&ctx->mmap_lock);
>   	spin_lock(&ctx->completion_lock);
>   	o.rings = ctx->rings;
> @@ -647,6 +648,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
>   	if (ctx->sq_data)
>   		io_sq_thread_unpark(ctx->sq_data);
>   
> +	smp_store_release(&ctx->in_resize, 0);
>   	return ret;
>   }
>   
> diff --git a/io_uring/tw.c b/io_uring/tw.c
> index 1ee2b8ab07c8..c66ffa787ec7 100644
> --- a/io_uring/tw.c
> +++ b/io_uring/tw.c
> @@ -152,6 +152,13 @@ void tctx_task_work(struct callback_head *cb)
>   	WARN_ON_ONCE(ret);
>   }
>   
> +static void io_mark_taskrun(struct io_ring_ctx *ctx)
> +{
> +	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG &&
> +	    !smp_load_acquire(&ctx->in_resize))
> +		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
> +}

That's not going to work, same raciness, but you can protect the
pointer with rcu + rcu sync on resize. Tips:

1) sq_flags might get out of sync at the end. Either say that
users should never try to resize with inflight reqs, or just
hand set all flags, e.g. SQ_WAKE can be set unconditionally

2) For a fix, it'll likely be cleaner to keep ->rings as is
and introduce a second pointer (rcu protected).

-- 
Pavel Begunkov


