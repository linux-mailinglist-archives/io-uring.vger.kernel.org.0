Return-Path: <io-uring+bounces-12708-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wAHdOBaDuGltfAEAu9opvQ
	(envelope-from <io-uring+bounces-12708-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:24:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C3B52A16E5
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CD5D3302FFED
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 22:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEB2368941;
	Mon, 16 Mar 2026 22:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aTS39kej"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E019D37269B
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 22:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773699859; cv=none; b=bVUUA8mpKaUKLyrVy8oWx18f/oV9Pp7juvZy7iGav62cDTMYSvBNQKO8mycibg8YojjRqRvahcxOr7VLoHFRsmsCydLB33mokPdjuAtA/m/nS4XsAfgpp1902BOB0HKzmIwrKOYBQ+EAD2EOLljiJqJNOjmiqpgZ6kYlhUdgUOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773699859; c=relaxed/simple;
	bh=U0GMFSMJoMfRzRtygFkLe4iQ6lmgRj9QW6uDHpzIuUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MfR9DjBuATrC/nHRmHZz9d6muZ/VF19ufdEC8qrTAUCh9M8JmYe/trHGU1DnIRTQ9yNLzY6C3lQRtFJecNja7CMchP4q0qkJ7rZkojdSLwv7yC0ImGFsC4VGKcYBXh9NFc35dM/7ZLdb98rRE7ZhWDlpPoV/McpDydu60rdb7hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aTS39kej; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4852f8ac7e9so61210575e9.1
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 15:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773699855; x=1774304655; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BZBQqmd5l13DwE4T0pJdwIFGqKO8umWW8EpmBh1etfI=;
        b=aTS39kejvL76ERLVd2C8J1d2jWvQqKlN41MnK7lDHC+d1nBhRgF6QXEDWlW9tyvvlW
         /dAu1KFSDrB1CUYJ9LzDatUGkABNabYdrY6oaxZce+QdaPvGsZLk4TWHvWYmGwrEbpi+
         OkspoO6z3gNtHb8u+KnWIsQ9lELHHXXV522pkY/9XXZE9eGFKzplbVBcOy/QnJcpYC8c
         CFReMcN/UcbpCxBPEhB2DktBqKyJkTadgGC4fjtS4De7fzmljYXXHgHKJkZJPVG3Q3iE
         3SMJNokqCRoyOKIQrX5pYrOHvH3g1Pt6PDa7ZsRdiInpJdMZGqME+R4GytNhPfpbkaCd
         l5bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773699855; x=1774304655;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BZBQqmd5l13DwE4T0pJdwIFGqKO8umWW8EpmBh1etfI=;
        b=g+OHpXwwnay0lFRQHclj648Q/07AKdt1VM8qu9WMVpxZfNRQ00XitUe2RgX+SqAV+y
         HvsNGP6rjqqKUQcpQwGSVF2ePqbWBqiv/BhO81WFlUJDLsLeFnBFOw+JHM5T6jd19cjU
         DPPE5miK2KgLaTgAu9iGk+md2TAQQeE0/w52uAHFblZ0B/BUpSgNSuwsUNSC2xdeTKtX
         dUT2nvHtRejvMQqWN9s3gWJBwEtETa9Ce47NZZq/q/WHLAL/SDqpN9oF/RLwia+BUKQw
         7AfmbuHfJiyCskj8pVNu4infq2/Rnyfh0W0qbkrmiVwugKLmTpT6n44/EJNTzyipeTL7
         mHSQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4hB6GBwwV7nXnEhQLu9Eh4pDAlyxIekVZgzdM9cXpxPbIfV7F2o1LW11MBC191mxuv2Anuuvs1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWbJymiOQ8BfN7dqojDVTMdFH/yFfCwHHDbwzXYWu+kH4SaMI2
	MgqRLWc2bdZgy41ILrT41/Ne7jqRDaDC9691y7a9z/TmmPBSnKwbTVu8
X-Gm-Gg: ATEYQzwwfSLzgqrhALmvE3cGafR1ogLajwQs5jTpUhL1bGmv9XECNhlzPbzX2IByUhy
	SWVgTkBLOMvTNqwc4rXPzAhww54aRPOeAX2T46JD+F/UcyVycPgOO/XaeKn2eBRhSzLcIzwRrWx
	G6HylL8jCHKefB13ueJgB2wsjoUo2KJUoZmgRUHEEV9gxHfVtdWXpVcVfMTi0bzEP869iuvZboQ
	OymIk0/vpBxX0rV+IGOAEFYnVN77XUQpZFJUl0u+pBsukte3I4XINy51LFaW16ZCaKgWRdCUUfE
	kJOQP3CGI6TVhCRdTpR5T/FVtND9VCiqTQ1l1WlpL5R02RxaIGnZRq2GWiDjQiR8ylkbEZtTeXV
	zrpWJgsYq6DyS1u6gMKx6gaauoiR+W78t/TTcAYkVoM+MZDIMN1yqwGIP9SH12WbmdN5SqSMvOm
	qqMRF1gjiHxEPEx2zBEXNCLz47DQxbEk8isgDCQXwhqSSPeqO3HyPg8gGlG5WJiMjxixR0daxLQ
	u+hbC6CQT8fBHZ79AGZ73oaGsbIav9+UnGaoUKuDaxi+do9lCQ5BkMD83pgtRK0/SPIl0aJpAM2
X-Received: by 2002:a05:600c:1e8c:b0:485:3e00:9440 with SMTP id 5b1f17b1804b1-4855670c296mr239590405e9.24.1773699854960;
        Mon, 16 Mar 2026 15:24:14 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43a0b2db487sm28993844f8f.28.2026.03.16.15.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 15:24:14 -0700 (PDT)
Message-ID: <d8df1979-5534-4703-9e68-17b152d6595e@gmail.com>
Date: Mon, 16 Mar 2026 22:24:06 +0000
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0fce925b-9148-4f83-92cb-19d164a7ea32@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12708-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: 8C3B52A16E5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 18:40, Jens Axboe wrote:
> On 3/16/26 9:16 AM, Jens Axboe wrote:
>> On 3/16/26 8:44 AM, Pavel Begunkov wrote:
>>> On 3/16/26 14:40, Pavel Begunkov wrote:
>>>> On 3/16/26 14:28, Jens Axboe wrote:
>>>>> On 3/16/26 8:17 AM, Pavel Begunkov wrote:
>>>>>> On 3/15/26 16:19, Jens Axboe wrote:
>>>>>>> When a socket send and shutdown() happen back-to-back, both fire
>>>>>>> wake-ups before the receiver's task_work has a chance to run. The first
>>>>>>> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
>>>>>>> When io_poll_check_events() runs, it calls io_poll_issue() which does a
>>>>>>> recv that reads the data and returns IOU_RETRY. The loop then drains all
>>>>>>> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
>>>>>>> the first event was consumed. Since the shutdown is a persistent state
>>>>>>> change, no further wakeups will happen, and the multishot recv can hang
>>>>>>> forever.
>>>>>>>
>>>>>>> Fix this by only draining a single poll ref after io_poll_issue()
>>>>>>> returns IOU_RETRY for the APOLL_MULTISHOT path. If additional wakes
>>>>>>> raced in (poll_refs was > 1), the loop iterates again, vfs_poll()
>>>>>>> discovers the remaining state.
>>>>>>
>>>>>> How often will iterate with no effect for normal execution (i.e.
>>>>>> no shutdown)? And how costly it'll be? Why not handle HUP instead?
>>>>>
>>>>> That is my worry too. I spent a bit of time on it this morning to figure
>>>>> out why this is a new issue, and traced it down to 6.16..6.17, and this
>>>>> commit in particular:
>>>>>
>>>>> commit df30285b3670bf52e1e5512e4d4482bec5e93c16
>>>>> Author: Kuniyuki Iwashima <kuniyu@google.com>
>>>>> Date:   Wed Jul 2 22:35:18 2025 +0000
>>>>>
>>>>>       af_unix: Introduce SO_INQ.
>>>>>
>>>>> which is then not the first time I've had to fix fallout from that
>>>>> commit. Need to dig a bit deeper. That said, I do also worry a bit about
>>>>> missing events. Yes if both poll triggers are of the same type, eg
>>>>> POLLIN, then we don't need to iterate again. IN + HUP is problematic, as
>>>>> would anything else where you'd need separate handling for the trigger.
>>>>
>>>> Thinking more, I don't think the patch is correct either. Seems you
>>>> expect the last recv to return 0, but let's say you have 2 refs and
>>>> 8K in the rx queue. The first recv call gets 4K b/c some allocation
>>>> fails. The 2nd recv call returns another 4K, and now you're in the
>>>> same situation as before.
>>>>
>>>> You're trying to rely on a too specific behaviour. HUP handling should
>>>> be better.
>>>
>>> Some variation on, if HUP'ed, it spins until the opcode give up.
>>
>> Took a quick look, and we don't even get a HUP, the hangup side
>> ends up with a 0 mask. Which is less than useful... I'll keep
>> digging.
> 
> How about something like this? Will only retry if hup was seen, and
> there are multiple refs. Avoids re-iterating for eg multiple POLLIN
> wakes, which should be the common hot path if v & IO_POLL_REF_MASK != 1.
> Keeps it local too.

HUP handling is just a hack, it'd be best to avoid complicating
the pool loop logic for that (and those continue do).

io_poll_loop_retry() {
	...
	atomic_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
}
if (req->cqe.res & (POLLHUP | POLLRDHUP))
	io_poll_loop_retry();


Can we isolate it like this? Nobody should care about extra
atomics for this case.


> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index b671b84657d9..bd79a04a2c59 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -228,6 +228,16 @@ static inline void io_poll_execute(struct io_kiocb *req, int res)
>   		__io_poll_execute(req, res);
>   }
>   
> +static inline bool io_poll_loop_retry(struct io_kiocb *req, int v)
> +{
> +	if (req->opcode == IORING_OP_POLL_ADD)
> +		return false;
> +	/* multiple refs and HUP, ensure we loop once more */
> +	if (v != 1 && req->cqe.res & (POLLHUP | POLLRDHUP))

v != 1 looks suspicious, at this stage it's hard to trace what
io_recv_finish() is really doing, but better to drop the check.
  
req->cqe.res should already be in a register, makes more sense
to gate on that first.

-- 
Pavel Begunkov


