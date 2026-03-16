Return-Path: <io-uring+bounces-12697-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CMnbL5khuGmdZQEAu9opvQ
	(envelope-from <io-uring+bounces-12697-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 16:28:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C69929C591
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 16:28:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 34AEC30AD65D
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 15:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D493A0B03;
	Mon, 16 Mar 2026 15:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lg6WTI0I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78637290DBB
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 15:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773674191; cv=none; b=MrbfP9SYW14oNZE69es4xRnTKEblTKklgd+rorvX2qgXC1BisGWYd1Cg+ejVk6Jb+BGuQKY5yHvZT77+DySNlAWzY4NFK1V/h7ci0XWUR+lxIXIlfzZ1Crchba9vQKB64SedYku1sbT6U3ruD69kfVulavFpMvgbxfP5fsbZ6ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773674191; c=relaxed/simple;
	bh=Xi/WuyvnnD1ejSzfQkMh4qSZO8N0HNbONJz0nyR8jY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jM0umILW3rS/jl+y7nXbrWVjFU0v+3efLsnOtJDuYhZZKCn2uf1Lf5aj6Hid0U42aHkeAxSxcRSZUK9rJDDp4kRvSuU898zJ5mMnOnLJwblGF63ew2xNCG8xN7ULfrEt91qvJIZh4q0r4KUMKCcMAR+lBMEyiVCGIPPdeD9mals=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lg6WTI0I; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-40f1a1f77a6so2731321fac.2
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 08:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773674188; x=1774278988; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ujJnNQhXEoX8ThLKydZvCYuP6utHqIcdBrnxUPZy/WI=;
        b=lg6WTI0IDN8EgK+Ya10+a6gNs73DV2A0lRFe6lX10siL60TNdvPMlnSg+QQz4qmgIJ
         y0jA6KVJ7Q3w6rb7f4/PmYjt8XbEhQCy3KJhwA0kimKzXor26WnIDRcXff5R7to7mvYN
         scwvF1SPHB1728hmvdyYSugZhT91AYz+nT49Rdzb93ROA1FM9pVLQYRsYfSiwKRkmMQQ
         beu9xpBOI0UDK7H4koZ5PkQYjZSAQW4qsNTVZKaf7Tf9rhf+FWd8MMqXdBJ68kvikS8B
         Y0qvUBdVHBKtrMCxfjk6vK5lLXp5kNzQ3gB7lSlOqzZdO2MOH9zEWmV0xfnLJ/KE5I5h
         Z1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773674188; x=1774278988;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ujJnNQhXEoX8ThLKydZvCYuP6utHqIcdBrnxUPZy/WI=;
        b=jD4KuaWGhoBf9mPz1Bs+0q+hfkpjBd46Vurn4HL9hVJNj52hfLp5C9DgrlEk4ADoXm
         QnB+Iw8HxZ6pHXbXptRPQSIc8S3d+cISgyIYoEmOtefUz2S6yugXUBPcqvvb6Akc4jIN
         6YKGEdi6qCxsR0w56CJZ3juOTG3l21VN51f7VP0jwccPIp9s+cuWz5O8Nni0680IolBQ
         dBjyLJsHuj8sVRo+xNQeCBwqN1Xlgt2I+/9KQbrYA4iJirT2PBLQsuv9lZ3AMBBP+PBt
         FF9nZOE4E5sF5DrddQ9ShVsxr/RJCfvr8xaH/YquQpe+TwUuI+LME9zr3VV8fEz01L9v
         6HeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIjE2+Kwn/2jXJ1QUmHFtWxG2R4DJ7jRnyopO7w/yM5L4YsupLio6ALjCh2rgUL4T7ldz2lqaaPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfQkTvX4B7NtUhRMuEoI9yPD8I+VFT5XBVJiCioqA0cOvG+eBY
	NTzo1NF1vDJU3aDiZf12yGUoklU2zJ3KmZrmZEIX1+T+z1MNYzymz4Q7VsowFqp/mTk=
X-Gm-Gg: ATEYQzzMkq4L6/TLKod5lalfSqiGYqBfO6xwbzNIPqjRHRj9dq0q3i27uw1RA+SgAY4
	fNgiSKfqlGmrYlpd28r98tQdl6VSpGnRh1n6EEDnyukM1+GzRIMPODKuVcxZB4H30lncEToPJ/N
	F7Z01FEwXq5ArO45YjoJ/N3dnvSIZHrMFJB+oDvvQPHmoUYzMIzrzzY+K1CV5katXhU6BvvgDYg
	Zx1mPRybnlhKWn0O7aOeEZdjmsb9tTDDQBdJulp4MhWOIDww1kncWIs34B8rGImZ5IcKTzBZ7nE
	g24MVs6oQqtPseErs/ceHEgTfCAT/uAhmBjP/JPXpNcwVGDmmDUe6lZfG2AohSMqJg4b16MEYZq
	7KBVkKHQcAck6O+p91KQl1wtydlp9LrZcEAtPrijjU/szfh26usch1GyLaHd0f02D6inbCAo0X5
	RX90fPo0SHc/H9sZPuslizDLVJOnkflSvGeX9HOKWEz+bIyuHWKSSHEsjw5VLjXh05pkZiJgzE9
	y0dh1k/qQ==
X-Received: by 2002:a05:6820:98f:b0:662:b70c:a414 with SMTP id 006d021491bc7-67bda98ce05mr9821734eaf.14.1773674188191;
        Mon, 16 Mar 2026 08:16:28 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bc8efa80esm10292853eaf.2.2026.03.16.08.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 08:16:27 -0700 (PDT)
Message-ID: <6c0f631e-5015-4578-954a-07a1ca726b34@kernel.dk>
Date: Mon, 16 Mar 2026 09:16:26 -0600
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
Cc: francis <francis@brosseau.dev>
References: <8688cc4e-8619-4392-8d5c-93c554d70c34@kernel.dk>
 <2e2d6e81-bf95-47bf-9c70-1b2f8b63cfbc@gmail.com>
 <876c9e94-0782-4561-8ae3-0cfed18ee375@kernel.dk>
 <3b6769f8-4b44-47ee-a308-6f7e23304c8a@gmail.com>
 <c1499122-9444-4ef9-908a-84e290d450d2@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c1499122-9444-4ef9-908a-84e290d450d2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12697-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3C69929C591
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 8:44 AM, Pavel Begunkov wrote:
> On 3/16/26 14:40, Pavel Begunkov wrote:
>> On 3/16/26 14:28, Jens Axboe wrote:
>>> On 3/16/26 8:17 AM, Pavel Begunkov wrote:
>>>> On 3/15/26 16:19, Jens Axboe wrote:
>>>>> When a socket send and shutdown() happen back-to-back, both fire
>>>>> wake-ups before the receiver's task_work has a chance to run. The first
>>>>> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
>>>>> When io_poll_check_events() runs, it calls io_poll_issue() which does a
>>>>> recv that reads the data and returns IOU_RETRY. The loop then drains all
>>>>> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
>>>>> the first event was consumed. Since the shutdown is a persistent state
>>>>> change, no further wakeups will happen, and the multishot recv can hang
>>>>> forever.
>>>>>
>>>>> Fix this by only draining a single poll ref after io_poll_issue()
>>>>> returns IOU_RETRY for the APOLL_MULTISHOT path. If additional wakes
>>>>> raced in (poll_refs was > 1), the loop iterates again, vfs_poll()
>>>>> discovers the remaining state.
>>>>
>>>> How often will iterate with no effect for normal execution (i.e.
>>>> no shutdown)? And how costly it'll be? Why not handle HUP instead?
>>>
>>> That is my worry too. I spent a bit of time on it this morning to figure
>>> out why this is a new issue, and traced it down to 6.16..6.17, and this
>>> commit in particular:
>>>
>>> commit df30285b3670bf52e1e5512e4d4482bec5e93c16
>>> Author: Kuniyuki Iwashima <kuniyu@google.com>
>>> Date:   Wed Jul 2 22:35:18 2025 +0000
>>>
>>>      af_unix: Introduce SO_INQ.
>>>
>>> which is then not the first time I've had to fix fallout from that
>>> commit. Need to dig a bit deeper. That said, I do also worry a bit about
>>> missing events. Yes if both poll triggers are of the same type, eg
>>> POLLIN, then we don't need to iterate again. IN + HUP is problematic, as
>>> would anything else where you'd need separate handling for the trigger.
>>
>> Thinking more, I don't think the patch is correct either. Seems you
>> expect the last recv to return 0, but let's say you have 2 refs and
>> 8K in the rx queue. The first recv call gets 4K b/c some allocation
>> fails. The 2nd recv call returns another 4K, and now you're in the
>> same situation as before.
>>
>> You're trying to rely on a too specific behaviour. HUP handling should
>> be better.
> 
> Some variation on, if HUP'ed, it spins until the opcode give up.

Took a quick look, and we don't even get a HUP, the hangup side
ends up with a 0 mask. Which is less than useful... I'll keep
digging.

-- 
Jens Axboe


