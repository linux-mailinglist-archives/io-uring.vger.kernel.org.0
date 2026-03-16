Return-Path: <io-uring+bounces-12710-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YBbCK32NuGlxfwEAu9opvQ
	(envelope-from <io-uring+bounces-12710-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 00:08:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5ED32A1D67
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 00:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AE3C9300A666
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025AA374182;
	Mon, 16 Mar 2026 23:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dTrjI/Sc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9836D372EE8
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 23:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773702518; cv=none; b=BZlH3r1aVrBeR+PuM7ozneEuC3WPGRPMxyTTFrMhcBVPVVTdJePBwz2Bv5qC3Z6Qoo07cwvPr+crmbyEFF40Ayc2MV4XxrtrJkD7Ckm3/v3vfPL3ZXXU9EMo32aASL1wW6iFL67Qg2LffiN8gq3YgeMYs+O1R1u2kkchw1CI8NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773702518; c=relaxed/simple;
	bh=z0ENevxeedDZ/BV4vFdSJ6KPo4A4cWUOqvDmONkeYww=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XydGo/Q7LrDQRpVRIxSgGXJhINnY2jrP2PhyVjXFq2fJd9zYevB/mbcREQMPsv6Y+rg5ursGoSnM2Zflh9LIG0GEVnXgLCMSI+2AW277A0J4kneXQ+mSjkK7bht9rpJ9qqnZSQzantBAojloruvxGC4DxG8jd6CbDl4fHNIBvyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dTrjI/Sc; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4852ff06541so57330315e9.2
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 16:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773702516; x=1774307316; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zbf96soQ6yqzSUOGsWgUuKsjYZ2S8jdwCeQ+K/1xSno=;
        b=dTrjI/ScjHAmey+Kgx2yGRh8fySwVeZ6+EGKklDvbbT+7CyjaKQjFgD10eU7eXn1yw
         QMLXHd0pm/T+UN1potv+grJr8q/1Az4gjinTFjvyBq8xSJqhSMnUDTkPFBTeaDFP3aK1
         HFZKAmfzvPi8q9urtnZX+eM5dmIrMOOfa7O4IK67x4/EtDdZWGh5B/44t7m9BUPSsVTH
         +BKySBsZ/62sNduougwqdjhNI2/6Z1b7pc0fPsgo/0qAOHiAqrJy1j5qvQzgy3HYOG7a
         IU8iSNuY3Eziw7GDSr5Fjiikh6EOJjK6fZ7Z58MT1Frr2iF6Y6YSlnb+E+gtCOc0pITz
         j3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773702516; x=1774307316;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zbf96soQ6yqzSUOGsWgUuKsjYZ2S8jdwCeQ+K/1xSno=;
        b=H/LxxzhcgdLdcfQPI5JExWSzKLD5WLUiNhFKxDgdGs6xoz0Bo12+GesyKRI7mViqcn
         dzxw6samNAuBj77PhJlV8WeSS88zd8sCWShAJ2GJpKF157g1ntfWAPaS7jvrOtHi/+5c
         6qPemd3h+KL/2taJRxUAwc3Ma8V0vz86lvLvL998qVrs/hIJKmeSFHosY/W7buthGnMV
         Dc9vTTtLmHTxyl9Q7z4t6An/lUAJTIBEHuPw+cFl2ncKqsVXW1e0CV5UKnh8o6aHCLi0
         UXf7udNuCAdm/C+53Xtkl81axvlT2im9inTa0DGO1zrxWTarU7PZqStv05MGpZF8gqvv
         yxGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVq6SuSUjAqe0BgeRXDmtpvrogZpk6K9y5pwKkse67i/4iKcwQxroqfoQiJLbAjmq2i1NIcl7cDlQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9mSilWX3+u8nIIiYUzMu00QGl+d0B/Nsl82suNUHBVFVFuTKv
	rlKzu2vnZW0f6J4TP2B5SmPQ3GT8pY9i0RMFlfh0NzVFcDCfLm/7yqfdYlLM2g==
X-Gm-Gg: ATEYQzyCmEAOycqBYIPoEsM4arWPtKdz2BZCa/j4GNkWVlEKttdNzkRWGSXL/So1ixU
	NcZkAIQ433omQfhAQsollIRC7dtAZZZE4wJViu0laoX17rHg9U5CfdnHQXYjI68V/qpVEK6Pi1s
	B+OnmNbEZCckXuxN5LM9WtgosC62BVLYzwMC7ralg//jE/6FehLZK7vcXmiIBi2EXX3Zy8IRVCR
	gG5Zl6BhaATH9rNj/rYeoxxmwzmT9vLGAlmn0Vc2pEFAKdW8GpWYLGORZ/PCFZ2IRahKMSJlWm4
	9CF3Ykt1KsALO9mrR3DwTAXGHfushCArDv7WyjnkBeI1mFMeZ9RY5riQe62UNJd3z1SQOk1Rg/i
	nD/CP8y6sKFN96rQuxna99qdquQs1PC8flwTFMvSvvCNTcXpL2W13DNt6IqWTAuWQYYqGijMro1
	a32fC+mrI7xLQibufsmjnAvaFbjyf/XFYwipIs1fCMVGIrX0rcppZqQGuBLLBfIC/dXXNGpEgUo
	CaJKvKsU0eXDpJ/dg4kdC1iWq0AGcmFU5eFDkmTuue/Ah8MQkJqzoYwObN3tmaQVS7EnGxAsvWb
X-Received: by 2002:a05:6000:3104:b0:43b:4440:9c28 with SMTP id ffacd0b85a97d-43b44409c87mr9178131f8f.0.1773702515884;
        Mon, 16 Mar 2026 16:08:35 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b3a09e453sm23849884f8f.0.2026.03.16.16.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 16:08:35 -0700 (PDT)
Message-ID: <2cd52ebc-57d2-4407-a3d5-a46f57b90600@gmail.com>
Date: Mon, 16 Mar 2026 23:08:28 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: fix multishot recv missing EOF on wakeup
 race
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <8688cc4e-8619-4392-8d5c-93c554d70c34@kernel.dk>
 <2e2d6e81-bf95-47bf-9c70-1b2f8b63cfbc@gmail.com>
 <876c9e94-0782-4561-8ae3-0cfed18ee375@kernel.dk>
 <3b6769f8-4b44-47ee-a308-6f7e23304c8a@gmail.com>
 <c1499122-9444-4ef9-908a-84e290d450d2@gmail.com>
 <6c0f631e-5015-4578-954a-07a1ca726b34@kernel.dk>
 <0fce925b-9148-4f83-92cb-19d164a7ea32@kernel.dk>
 <d8df1979-5534-4703-9e68-17b152d6595e@gmail.com>
 <be88cb1c-9e08-49dd-9671-1d3887918935@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <be88cb1c-9e08-49dd-9671-1d3887918935@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12710-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B5ED32A1D67
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 22:31, Jens Axboe wrote:
> On 3/16/26 4:24 PM, Pavel Begunkov wrote:
>> On 3/16/26 18:40, Jens Axboe wrote:
>>> On 3/16/26 9:16 AM, Jens Axboe wrote:
>>>> On 3/16/26 8:44 AM, Pavel Begunkov wrote:
>>>>> On 3/16/26 14:40, Pavel Begunkov wrote:
>>>>>> On 3/16/26 14:28, Jens Axboe wrote:
>>>>>>> On 3/16/26 8:17 AM, Pavel Begunkov wrote:
>>>>>>>> On 3/15/26 16:19, Jens Axboe wrote:
>>>>>>>>> When a socket send and shutdown() happen back-to-back, both fire
>>>>>>>>> wake-ups before the receiver's task_work has a chance to run. The first
>>>>>>>>> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
>>>>>>>>> When io_poll_check_events() runs, it calls io_poll_issue() which does a
>>>>>>>>> recv that reads the data and returns IOU_RETRY. The loop then drains all
>>>>>>>>> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
>>>>>>>>> the first event was consumed. Since the shutdown is a persistent state
>>>>>>>>> change, no further wakeups will happen, and the multishot recv can hang
>>>>>>>>> forever.
>>>>>>>>>
>>>>>>>>> Fix this by only draining a single poll ref after io_poll_issue()
>>>>>>>>> returns IOU_RETRY for the APOLL_MULTISHOT path. If additional wakes
>>>>>>>>> raced in (poll_refs was > 1), the loop iterates again, vfs_poll()
>>>>>>>>> discovers the remaining state.
>>>>>>>>
>>>>>>>> How often will iterate with no effect for normal execution (i.e.
>>>>>>>> no shutdown)? And how costly it'll be? Why not handle HUP instead?
>>>>>>>
>>>>>>> That is my worry too. I spent a bit of time on it this morning to figure
>>>>>>> out why this is a new issue, and traced it down to 6.16..6.17, and this
>>>>>>> commit in particular:
>>>>>>>
>>>>>>> commit df30285b3670bf52e1e5512e4d4482bec5e93c16
>>>>>>> Author: Kuniyuki Iwashima <kuniyu@google.com>
>>>>>>> Date:   Wed Jul 2 22:35:18 2025 +0000
>>>>>>>
>>>>>>>        af_unix: Introduce SO_INQ.
>>>>>>>
>>>>>>> which is then not the first time I've had to fix fallout from that
>>>>>>> commit. Need to dig a bit deeper. That said, I do also worry a bit about
>>>>>>> missing events. Yes if both poll triggers are of the same type, eg
>>>>>>> POLLIN, then we don't need to iterate again. IN + HUP is problematic, as
>>>>>>> would anything else where you'd need separate handling for the trigger.
>>>>>>
>>>>>> Thinking more, I don't think the patch is correct either. Seems you
>>>>>> expect the last recv to return 0, but let's say you have 2 refs and
>>>>>> 8K in the rx queue. The first recv call gets 4K b/c some allocation
>>>>>> fails. The 2nd recv call returns another 4K, and now you're in the
>>>>>> same situation as before.
>>>>>>
>>>>>> You're trying to rely on a too specific behaviour. HUP handling should
>>>>>> be better.
>>>>>
>>>>> Some variation on, if HUP'ed, it spins until the opcode give up.
>>>>
>>>> Took a quick look, and we don't even get a HUP, the hangup side
>>>> ends up with a 0 mask. Which is less than useful... I'll keep
>>>> digging.
>>>
>>> How about something like this? Will only retry if hup was seen, and
>>> there are multiple refs. Avoids re-iterating for eg multiple POLLIN
>>> wakes, which should be the common hot path if v & IO_POLL_REF_MASK != 1.
>>> Keeps it local too.
>>
>> HUP handling is just a hack, it'd be best to avoid complicating
> 
> It is, that's why I wasn't a huge fan of gating on that in the first
> place!
> 
>> the pool loop logic for that (and those continue do).
>>
>> io_poll_loop_retry() {
>>      ...
>>      atomic_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
>> }
>> if (req->cqe.res & (POLLHUP | POLLRDHUP))
>>      io_poll_loop_retry();
>>
>>
>> Can we isolate it like this? Nobody should care about extra
>> atomics for this case.
> 
> It's not the extra atomic, I agree it doesn't matter for this non-hot
> case. It's more that setting the retry flag isn't enough, you need to
> have it do another loop at that point. And if you just set that, then
> it'll drop all refs and happily return and wait for the next poll
> trigger that won't happen past HUP.

It was actually supposed to force it into another iteration, but
I see what you're saying. I'll take a look at this part tomorrow

> It's not impossible we can make this work, but I don't see a great way
> of doing it without messing with the loop like I did :/. Or checking
> ->poll_refs again, and at that point the separate variable is better
> imho.
-- 
Pavel Begunkov


