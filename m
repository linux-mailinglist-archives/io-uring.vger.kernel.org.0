Return-Path: <io-uring+bounces-12709-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SDVDNd2FuGltfAEAu9opvQ
	(envelope-from <io-uring+bounces-12709-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:36:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C78302A1916
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:36:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C58123072B62
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 22:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D87322C88;
	Mon, 16 Mar 2026 22:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ggQ4mSF/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF03146D5A
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 22:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773700287; cv=none; b=rnPPKIOUKsj+R7PN62n0vjGdK9rfLRuK7XVDEjkaT6Z8VDNmpbEJLUzaXXoWSDQtG89TkJIgI4Fu27be8B8xzijY53Q3qMTOHoHE6/wbpyKV6D7ryqX/LsQ+UlNmAkH4l3oIY/5lBo8iePzyjmh4ECFEjUW1ovAUeBqrpZrqORA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773700287; c=relaxed/simple;
	bh=Vc1qYl6oeBMQwRQToPJBQ6ulbMZVSgHY1gBrJge6z0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JgMYE0JoW526fen7Sx6Eia+cwL2swDaH959Vg51XcCXrLYfoQG2Z+woVqhkWe2X4CLH64oPXpgBXuabsenJilh0wlLQaRcTq4amT7Mr85Qbd4N28kYRCrrLry/Nrvi93wej26wppRMGAeePwp80BDOmyJWu4x+k8NebYfFjEndY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ggQ4mSF/; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-467161c4b89so3190159b6e.3
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 15:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773700283; x=1774305083; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4km4Wsdruj2C9G+vqBhg4Kuuz8/RRMAQSSApYpxsgzo=;
        b=ggQ4mSF/gQ7yppIZ8M05DxAQJXvZ4CgYki91X0IQJU4U9D2GdzgXkrfwkenFuRIpck
         y/dEOwI483b6zU2E+4fA4lOKg99t0ExO7I9ghRxbtfCCS5q6sth4nW8tUoZ3SuBLkuTA
         lw321vt6TDVAxIQMPnDa954MOuhIkZxu3LVv/O1aABwuYWKPgk5Y6MJEJzL/FBoOVyxe
         mRpG/qqcn1QJeLfC3qU7K/uqiKdXK+HmRoNw66OqHRyYiVtZT73vcsJy6zCr+GxcbC1v
         iFL+nYR665D+wVZXLLMiSIdoSJe6wbdmTQdXu7zmPWzS/9YGogEvYMBVs26XaLldEJQG
         jftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773700283; x=1774305083;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4km4Wsdruj2C9G+vqBhg4Kuuz8/RRMAQSSApYpxsgzo=;
        b=MFVDxp6ac64BlBzYNpmpFGUBawHyHTKD5XYnhHrcgg5md8Xh+Y0fnJ7ej0nVmi+5I1
         UwMFJ8s0RPxQagzZUatYOv/xtwAGsLHRbScJCnFD8ueLmO1BMybUntCHZSashx1EbmdD
         tJIbhHwSVT5FdIsQeRa8wHoUroXKxBQBYnzyoHmnqQAo2gv/NA8GGH7ye8dI2DemXRN5
         G2BC59C92RnFtBDVbPpRDRKH6ZIFC8q1WOCSmOnLqUyUybfPCmhQjt1iAM+FWk/fsG8v
         yAl8JEdR8njAUFSm35FKkM9KZClXUzD4PNgwk+HgSoVbs6Ijh6RyNKcWe8iUbvfVjs2x
         nS3A==
X-Forwarded-Encrypted: i=1; AJvYcCVTJnJ3o1MOFswtKrjUry21qWRBkJcd8DcLm7DXmx7T9MXGuuuVbJtTDkHzNn6jRM27FDumBuqG5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPeI+QujgjWjYjuDTTv+zVGZ0veIDAgoKJ7iWUSKVVoS4EDEBN
	ntDWjXaLE9D7WbpnfXng23Ckg/T+6cnJCMdCWBO8t//BMkkWeV5CrfYltHgsImI38bE=
X-Gm-Gg: ATEYQzwg1pj7jZiVCV0OKAkgpmjGgOaswuQAgKC0zbcSNISz75D9vTiVk84lG5IXR7I
	x6wRD6G75uonGuHupnp79H3aP+F1tXpntnKC/TWbE7Ct9G8+nocJ+gdm8ZP6ndiQ8s8YidspakU
	hM6D9S+kjR3aOJexINh6xcVVCC/YrMvW+7XNgEg0s1NNazwAGfZr7mnC2GmMdbWsSYuPqbw+ezF
	8cnCFv9WAE9XJLn+PRvzfDGOj0EkoB99Ya4sbCVMHl8KYDo/msxvYwJxR7DIDq9l5Rl6MNqDQBD
	VmJ2Fv96cZpKagw+7H4Ax7vd+oLwUIAL5ue4a2Nrer+cQUZ+IPikRSzDEzu10m8NwWH/YGNPEsC
	tJgxKJ7lR7WqAJtLb9yEnyQ6aR0SkrfohO9FvefEX1SBi5DzygIXeCtCik0/FqaPVxj5LCdKhcN
	NTF8M2YjiNZ7ePAUbjxVeENpAfRaLarWiV2ELokiU04PyYMupiCDEoK5dwI1J9H+BsjVT2JqC9w
	Q1Wx4I785NNMPkINmDS
X-Received: by 2002:a05:6808:23d6:b0:464:1d9f:f9f3 with SMTP id 5614622812f47-46757172753mr8088957b6e.26.1773700283226;
        Mon, 16 Mar 2026 15:31:23 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e1fb6efsm19185217fac.3.2026.03.16.15.31.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 15:31:22 -0700 (PDT)
Message-ID: <be88cb1c-9e08-49dd-9671-1d3887918935@kernel.dk>
Date: Mon, 16 Mar 2026 16:31:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: fix multishot recv missing EOF on wakeup
 race
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <8688cc4e-8619-4392-8d5c-93c554d70c34@kernel.dk>
 <2e2d6e81-bf95-47bf-9c70-1b2f8b63cfbc@gmail.com>
 <876c9e94-0782-4561-8ae3-0cfed18ee375@kernel.dk>
 <3b6769f8-4b44-47ee-a308-6f7e23304c8a@gmail.com>
 <c1499122-9444-4ef9-908a-84e290d450d2@gmail.com>
 <6c0f631e-5015-4578-954a-07a1ca726b34@kernel.dk>
 <0fce925b-9148-4f83-92cb-19d164a7ea32@kernel.dk>
 <d8df1979-5534-4703-9e68-17b152d6595e@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d8df1979-5534-4703-9e68-17b152d6595e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-12709-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: C78302A1916
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 4:24 PM, Pavel Begunkov wrote:
> On 3/16/26 18:40, Jens Axboe wrote:
>> On 3/16/26 9:16 AM, Jens Axboe wrote:
>>> On 3/16/26 8:44 AM, Pavel Begunkov wrote:
>>>> On 3/16/26 14:40, Pavel Begunkov wrote:
>>>>> On 3/16/26 14:28, Jens Axboe wrote:
>>>>>> On 3/16/26 8:17 AM, Pavel Begunkov wrote:
>>>>>>> On 3/15/26 16:19, Jens Axboe wrote:
>>>>>>>> When a socket send and shutdown() happen back-to-back, both fire
>>>>>>>> wake-ups before the receiver's task_work has a chance to run. The first
>>>>>>>> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
>>>>>>>> When io_poll_check_events() runs, it calls io_poll_issue() which does a
>>>>>>>> recv that reads the data and returns IOU_RETRY. The loop then drains all
>>>>>>>> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
>>>>>>>> the first event was consumed. Since the shutdown is a persistent state
>>>>>>>> change, no further wakeups will happen, and the multishot recv can hang
>>>>>>>> forever.
>>>>>>>>
>>>>>>>> Fix this by only draining a single poll ref after io_poll_issue()
>>>>>>>> returns IOU_RETRY for the APOLL_MULTISHOT path. If additional wakes
>>>>>>>> raced in (poll_refs was > 1), the loop iterates again, vfs_poll()
>>>>>>>> discovers the remaining state.
>>>>>>>
>>>>>>> How often will iterate with no effect for normal execution (i.e.
>>>>>>> no shutdown)? And how costly it'll be? Why not handle HUP instead?
>>>>>>
>>>>>> That is my worry too. I spent a bit of time on it this morning to figure
>>>>>> out why this is a new issue, and traced it down to 6.16..6.17, and this
>>>>>> commit in particular:
>>>>>>
>>>>>> commit df30285b3670bf52e1e5512e4d4482bec5e93c16
>>>>>> Author: Kuniyuki Iwashima <kuniyu@google.com>
>>>>>> Date:   Wed Jul 2 22:35:18 2025 +0000
>>>>>>
>>>>>>       af_unix: Introduce SO_INQ.
>>>>>>
>>>>>> which is then not the first time I've had to fix fallout from that
>>>>>> commit. Need to dig a bit deeper. That said, I do also worry a bit about
>>>>>> missing events. Yes if both poll triggers are of the same type, eg
>>>>>> POLLIN, then we don't need to iterate again. IN + HUP is problematic, as
>>>>>> would anything else where you'd need separate handling for the trigger.
>>>>>
>>>>> Thinking more, I don't think the patch is correct either. Seems you
>>>>> expect the last recv to return 0, but let's say you have 2 refs and
>>>>> 8K in the rx queue. The first recv call gets 4K b/c some allocation
>>>>> fails. The 2nd recv call returns another 4K, and now you're in the
>>>>> same situation as before.
>>>>>
>>>>> You're trying to rely on a too specific behaviour. HUP handling should
>>>>> be better.
>>>>
>>>> Some variation on, if HUP'ed, it spins until the opcode give up.
>>>
>>> Took a quick look, and we don't even get a HUP, the hangup side
>>> ends up with a 0 mask. Which is less than useful... I'll keep
>>> digging.
>>
>> How about something like this? Will only retry if hup was seen, and
>> there are multiple refs. Avoids re-iterating for eg multiple POLLIN
>> wakes, which should be the common hot path if v & IO_POLL_REF_MASK != 1.
>> Keeps it local too.
> 
> HUP handling is just a hack, it'd be best to avoid complicating

It is, that's why I wasn't a huge fan of gating on that in the first
place!

> the pool loop logic for that (and those continue do).
> 
> io_poll_loop_retry() {
>     ...
>     atomic_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
> }
> if (req->cqe.res & (POLLHUP | POLLRDHUP))
>     io_poll_loop_retry();
> 
> 
> Can we isolate it like this? Nobody should care about extra
> atomics for this case.

It's not the extra atomic, I agree it doesn't matter for this non-hot
case. It's more that setting the retry flag isn't enough, you need to
have it do another loop at that point. And if you just set that, then
it'll drop all refs and happily return and wait for the next poll
trigger that won't happen past HUP.

It's not impossible we can make this work, but I don't see a great way
of doing it without messing with the loop like I did :/. Or checking
->poll_refs again, and at that point the separate variable is better
imho.

>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>> index b671b84657d9..bd79a04a2c59 100644
>> --- a/io_uring/poll.c
>> +++ b/io_uring/poll.c
>> @@ -228,6 +228,16 @@ static inline void io_poll_execute(struct io_kiocb *req, int res)
>>           __io_poll_execute(req, res);
>>   }
>>   +static inline bool io_poll_loop_retry(struct io_kiocb *req, int v)
>> +{
>> +    if (req->opcode == IORING_OP_POLL_ADD)
>> +        return false;
>> +    /* multiple refs and HUP, ensure we loop once more */
>> +    if (v != 1 && req->cqe.res & (POLLHUP | POLLRDHUP))
> 
> v != 1 looks suspicious, at this stage it's hard to trace what
> io_recv_finish() is really doing, but better to drop the check.
>  
> req->cqe.res should already be in a register, makes more sense
> to gate on that first.

Yeah that's probably fine, I mainly wanted to avoid hitting any of this
unless we had more than one event queued. ->cqe.res should be in a
register, but 'v' I strongly suspect 'v' will be too as it's used
throughout too.

-- 
Jens Axboe

