Return-Path: <io-uring+bounces-12015-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +EoQNOy3gGl3AgMAu9opvQ
	(envelope-from <io-uring+bounces-12015-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 15:42:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 331DFCD840
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 15:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C0C7E300F9CB
	for <lists+io-uring@lfdr.de>; Mon,  2 Feb 2026 14:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B8F1F5825;
	Mon,  2 Feb 2026 14:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="APRKdzu6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C591EBA19
	for <io-uring@vger.kernel.org>; Mon,  2 Feb 2026 14:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770042866; cv=none; b=nixe8w5rpuxbmfONyebbBcVtLhA2Q/G10PeKx+FWXcS9YuPMpzXrjsutfuZzwwLrGJ61UeC+rvDT4AihIBxd15eiNdyL8Eqoq4tKloaf3RWKgKK54ONew20ls2t3mNuqfVoZmD/P+V+M5NhXp39cn12/jfNUNhLD2IgINfxf6n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770042866; c=relaxed/simple;
	bh=U9f6lN3lEiNFo5dDkqpFaTJ4GWLvwQ9EJk9E6ZprYD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dZvuig0vyLyYJ1DGcQlUjo3RAASr3YQwZBBR4b2t+nWUPQZPH01XErqfksVDpFnjTQRX2NCKFl9K7pFFph4UzHkawzOu6a0hetGrWyRNieh6QwU5hfJ4YpZLzeUCOoC/WUJw5bV9HaLetzDmoWAmK2ggN8jftgG36oXBsonxJXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=APRKdzu6; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-45c9fdf2a06so3086003b6e.2
        for <io-uring@vger.kernel.org>; Mon, 02 Feb 2026 06:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770042862; x=1770647662; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rEpZFSBYqwbJS4DeyzeYZz+QE0lrvN7gNdYGjxP8Jmw=;
        b=APRKdzu6pHCekLklK8sNRRhByR6WOEUBQkMlAX8JW6Gjh8MJb18U6lgjcae0S6AFjM
         n80Ef1fYRsd3PFibgU8ogb40x1DbFnlxJ5V7/qqrAbmOUpk0zbcIY6cJHgcyJxT66p2X
         6sxVtlCr89ampdB9skAnzgcrwEIEvTxNfwEV5UVw8CL7bHrxbNTaS0yDHjg3NujygmvK
         k843wlXftEVnzCbIS7BRG1pzneQAaYpArYnlkuMk0NXvVI46rdVKi+tigsigmWvbsH95
         xGmouhhgo9A80FWopV+H1um8C4gl0xRAqh6No6ZLfYsU2aXVSzvBFotan2sYE5ARDv9T
         hQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770042862; x=1770647662;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rEpZFSBYqwbJS4DeyzeYZz+QE0lrvN7gNdYGjxP8Jmw=;
        b=Ql0xFy2E72xzdDhA6yskJyMR3L4edqSJdXHsRBKzasqVA9BaiiGP4xjQhXRQ4HMivB
         eAqbf9iZ7SZ3n/YimNFNadK7toy3cFfoJgZwHnOofQuRrU3hmD5etGcnezsyRPzQyPoC
         S5+VO4u2ooWtbGsc72721fDvc+lTd/eW0xUBR3KKkUbSCg3UEufAxYVvwcRj8EbXZqVh
         4xyG05mlL07MV19mVx8xTySOlTK3qXDtpO1CSju/mDcrRbuEVjU6iz2ZCaaVOwOLtLRx
         2URww+bYnQXPM2K5fg17NI9qUsVYn61+Yf11/beUr8JgKMvzL957hqOwzpmawKd+7hIR
         Ugzg==
X-Gm-Message-State: AOJu0YyFcvQ67HyMnao/bN+XCX7JRl7MrBUDuMMpqaO4lAlQQaw9CxTQ
	yHTJaI5zjkUO4bOzZJ89YJa88Xg4CGD1WBtnImqklEfnYgPWt+fgm+nDKS3G8uBgiog=
X-Gm-Gg: AZuq6aKF1liWERRw7OueHJFCqBhkdrCDPg2BkbVo6IUt6WPnUzJ6mRdhnrR9JM013YR
	dJVHzAaqjHUmN6JUDarB67aGRoxQwhkyVP6XuEOlnlalK+lSY7nKmSNyttJMwPJhTTTiEEvwRmN
	6omkQUc1FpT1CGn+AnC/B0s4uejlZXapX2NCX0VbIX17QhrX6M0FZJlzZz3YCw/8Gx9O4jHVwjw
	BvkJAZYLPQbc7IXLclNP2MEIWqCpBUuq7D3c6JPi8grHL+nrRDnmJYnZCttppqBnj3lW+If//jU
	cbq+oRov/ecSScywwyrVdwh9U/1m/pgt7qPsrOmK92AzRK8oNeAsBK7EOlGs4/tGb4u31gbLegT
	h9EUZ3Kc22hT0Z3Ibdc0CCd4vKOzPfuHlprBq7ZUKDT0MT3yAIlwKmy4MvX8y9DVmhQ9+BE2oWk
	BiSuRB13OmfrwwwHCw2DSGWqWEAdXJaUGsrUi9eiE5J7u7T/whpyeTMlmERUR3zSBVgCQe89Nc9
	ZPRoBns
X-Received: by 2002:a05:6808:11c5:b0:450:7df:e90b with SMTP id 5614622812f47-45f34d19f40mr4776909b6e.52.1770042862407;
        Mon, 02 Feb 2026 06:34:22 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4095751ea47sm11310436fac.15.2026.02.02.06.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 06:34:21 -0800 (PST)
Message-ID: <01839e70-5a71-4969-ad5f-2495754250e1@kernel.dk>
Date: Mon, 2 Feb 2026 07:34:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Introduce IORING_OP_MMAP
To: "David Hildenbrand (arm)" <david@kernel.org>,
 Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org
References: <20260129221138.897715-1-krisman@suse.de>
 <62d5954b-8ad5-4674-986b-c1168771429b@kernel.org>
 <f6098b6a-6283-486b-8167-b77c8d2e7880@kernel.dk>
 <6a351a3a-861a-4b93-8d8a-c0f5b87c258f@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6a351a3a-861a-4b93-8d8a-c0f5b87c258f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12015-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 331DFCD840
X-Rspamd-Action: no action

On 2/2/26 2:02 AM, David Hildenbrand (arm) wrote:
> On 2/1/26 19:16, Jens Axboe wrote:
>> On 2/1/26 10:46 AM, David Hildenbrand (arm) wrote:
>>> On 1/29/26 23:11, Gabriel Krisman Bertazi wrote:
>>>> Hi,
>>>>
>>>> There's been a few requests over time for supporting mmap(2) over
>>>> io_uring. The reasoning are twofold: 1) serving as base for batching
>>>> multiple mappings in a single operation 2) supporting mmap of fixed
>>>> files.
>>>>
>>>> Since mmap can operate on either anonymous memory and file descriptors,
>>>> patch 1 adds support for optional fds in io_uring commands.  Patch 2
>>>> implements the mmap operation itself.
>>>>
>>>> Note this patchset doesn't do any kind of smarter batching in MM.  While
>>>> we can potentially do some interesting optimizations already, like
>>>> holding the MM write lock instead of reacquiring it for each mapping, I
>>>> wanted to focus on the API discussion first.  This is left as future
>>>> work.
>>>>
>>>> liburing support, including testcases, will be sent shortly to the list,
>>>> but can also be found at:
>>>
>>> Just a general question: why do we unlock each syscall individually,
>>> and not in some intelligent way, all syscalls at once? :)
>>
>> The hard part isn't enabling all syscalls at once, that could be
>> trivially done with an IORING_OP_SYSCALL and the SQE carries arg0..argN.
>> And for any nonblocking/simple syscall, that would Just Work. 
> 
> Right, that's what I had in mind.
> 
>> The
>> challenge is for syscalls that block - the whole point of io_uring is
>> that you should be able to do nonblock issues with sane retries. The
>> futex series I did some time back is a good example of that - you modify
>> the existing syscall to expose the waitqueue mechanism, which you can
>> then use to wait in an async way, and get a callback when some action
>> needs to be taken.
>>
>> If you just allow blocking, then you're blocking the entire io_uring
>> issue pipeline. Which was exactly my main complaint on this patchset,
>> see the review reply to patch 2.
> 
> Makes sense. I was wondering whether that could be optimized
> internally in the stream of IORING_OP_SYSCALL.
> 
> But likely that would make it more tricky to optimize.

Are we talking generically, or mmap/munmap/mremap? You could trivially
make IORING_OP_SYSCALL available and use it for everything, it'd just
require a basically all of those to be offloaded to io-wq internally in
io_uring. And that's not a great approach. The fast path for io_uring is
running the opcode inline, which means that by the time the syscall
returns, you have also posted the completion. If the operation can't
complete inline, then the next best thing is to have it be triggered
when it can complete, and then retry and post the completion. Think of
reading from a pipe - if the data is there, the read is done inside
io_uring_enter() when the read is attempted, and we're done. If no data
is available, the operation is queued. When data becomes available, a
retry is triggered, data is read, and a completion is posted.

For an old school kind of syscall "do this thing, and just block the
task until it's done" doesn't work that way at all. Running those in
io_uring would necessitate punting the operation to io-wq, which are
helper userspace threads for io_uring. As there's no way of knowing
whether syscallN will complete fast inline or block for 2 seconds,
io_uring has no other option than to offload it to io-wq. If it's a 2
second operation, that's fine, you won't see any difference in the
application, other than it can now do syscallN async in an efficient
way. If syscallN would've completed inline in 1 usec, then offloading to
io-wq is suddenly a big performance problem.

> The patch set says "serving as base for batching
> multiple mappings in a single operation", and I was wondering, why one wouldn't just also batch with mremap/munmap/ etc. in the future.
> 
> (BUT I am also skeptical whether holding the mmap lock in write mode
> longer instead of repeatedly grabbing it, allowing other operations
> that need it in read mode etc to make progress, is actually
> preferrable)

That's always a trade off - if the frequency is high, then a certain
level of batching makes sense. The good news is that you get to control
that, you can just batch more or less.

Outside of mmap locking frequencies, I suspect potentially nicer wins
might be around TLB flush reductions for this family of operations.

-- 
Jens Axboe

