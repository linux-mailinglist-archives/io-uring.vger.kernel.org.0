Return-Path: <io-uring+bounces-12052-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0NAuEnKig2kLqQMAu9opvQ
	(envelope-from <io-uring+bounces-12052-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 20:48:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0BFEC368
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 20:48:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CD319300AC96
	for <lists+io-uring@lfdr.de>; Wed,  4 Feb 2026 19:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 397B134D38A;
	Wed,  4 Feb 2026 19:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Op4sBwfj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14872347FD7
	for <io-uring@vger.kernel.org>; Wed,  4 Feb 2026 19:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770234478; cv=none; b=grt48+jRDIaOporC8juLurOXVsRKR9HX04KQuB8xbbFq3MFLaPChZEp61ox+1155lhvXGYhoBL/8Kck0U+iYVjXkqJAqsZHV4Bf4NW0HYImrsWKXrnuTMpN/ovDMqNpoiPnA4DZs+VQB0c8VE9IwFW0pVmWKZIOQjtEAqEKdCPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770234478; c=relaxed/simple;
	bh=0xO594XaXe2WmMpQhnRX7Ui+iDU/Bx4tIizSQ+9a9+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nOIXZ/7BhROFihEeLY97yBMSWk4ZFzFzWJE5fzyyxboFLAR4HSXfkUUwvk4ESaCsgqG76Fd6wuYCFnT2DM9M+QvhnVK9o3FqaGgj4Di6m5zzFXoDLY/ocbtWO+waBFa6lmO1U1tnqwz9fS8Pe5EHJxoR2MXxVefyrSx0ffuFrRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Op4sBwfj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1C2C4CEF7;
	Wed,  4 Feb 2026 19:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770234477;
	bh=0xO594XaXe2WmMpQhnRX7Ui+iDU/Bx4tIizSQ+9a9+c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Op4sBwfjxeJSObwSJUsesLQYf1WEX8gRyUWEMMu0Ezlbb5FBxa3OB8T7+cpLbRDPA
	 qErmx89dyVuStDSX/o+6RXCy/N6rPnxKjhZGKqcBBY/afZVW3L24hXQ/xJNvlpq+Xa
	 OGT/p1r12ER0xZr3hS1L//GkqlsEBtasapoLv4bGk2h8mePgMQ1lgQTru+Aq9BScuD
	 Cr+AdQcvduzQix2lm2jkxXJ9oxF6MPEJP8Y7ifS+ZFin/aUcbRQJ/YYXw+EEXowuwb
	 mNBCYi2jIN9ZrhwMi08Frze4iWszS+KFclPmF+HpVI2BPTIY7/WLk76WvvwK/OPKZZ
	 TCmPL4QyKmZwQ==
Message-ID: <7faa5721-cd73-4140-9d63-fa5a279dbce3@kernel.org>
Date: Wed, 4 Feb 2026 20:47:52 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Introduce IORING_OP_MMAP
To: Jens Axboe <axboe@kernel.dk>, Gabriel Krisman Bertazi <krisman@suse.de>
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
 <01839e70-5a71-4969-ad5f-2495754250e1@kernel.dk>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <01839e70-5a71-4969-ad5f-2495754250e1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12052-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DE0BFEC368
X-Rspamd-Action: no action

On 2/2/26 15:34, Jens Axboe wrote:
> On 2/2/26 2:02 AM, David Hildenbrand (arm) wrote:
>> On 2/1/26 19:16, Jens Axboe wrote:
>>>
>>> The hard part isn't enabling all syscalls at once, that could be
>>> trivially done with an IORING_OP_SYSCALL and the SQE carries arg0..argN.
>>> And for any nonblocking/simple syscall, that would Just Work.
>>
>> Right, that's what I had in mind.
>>
>>> The
>>> challenge is for syscalls that block - the whole point of io_uring is
>>> that you should be able to do nonblock issues with sane retries. The
>>> futex series I did some time back is a good example of that - you modify
>>> the existing syscall to expose the waitqueue mechanism, which you can
>>> then use to wait in an async way, and get a callback when some action
>>> needs to be taken.
>>>
>>> If you just allow blocking, then you're blocking the entire io_uring
>>> issue pipeline. Which was exactly my main complaint on this patchset,
>>> see the review reply to patch 2.
>>
>> Makes sense. I was wondering whether that could be optimized
>> internally in the stream of IORING_OP_SYSCALL.
>>
>> But likely that would make it more tricky to optimize.
> 
> Are we talking generically, or mmap/munmap/mremap? 

Well, a bit of both :)

munmap() could be a bit challenging as it downgrades the mmap_lock for 
removal of the page tables. So quite a bit of rework would be required 
to batch that over multiple operations I suppose.

> You could trivially
> make IORING_OP_SYSCALL available and use it for everything, it'd just
> require a basically all of those to be offloaded to io-wq internally in
> io_uring. And that's not a great approach. The fast path for io_uring is
> running the opcode inline, which means that by the time the syscall
> returns, you have also posted the completion. If the operation can't
> complete inline, then the next best thing is to have it be triggered
> when it can complete, and then retry and post the completion. Think of
> reading from a pipe - if the data is there, the read is done inside
> io_uring_enter() when the read is attempted, and we're done. If no data
> is available, the operation is queued. When data becomes available, a
> retry is triggered, data is read, and a completion is posted.

Thanks for the explanation.

> 
> For an old school kind of syscall "do this thing, and just block the
> task until it's done" doesn't work that way at all. Running those in
> io_uring would necessitate punting the operation to io-wq, which are
> helper userspace threads for io_uring. As there's no way of knowing
> whether syscallN will complete fast inline or block for 2 seconds,
> io_uring has no other option than to offload it to io-wq. If it's a 2
> second operation, that's fine, you won't see any difference in the
> application, other than it can now do syscallN async in an efficient
> way. If syscallN would've completed inline in 1 usec, then offloading to
> io-wq is suddenly a big performance problem.
> 
>> The patch set says "serving as base for batching
>> multiple mappings in a single operation", and I was wondering, why one wouldn't just also batch with mremap/munmap/ etc. in the future.
>>
>> (BUT I am also skeptical whether holding the mmap lock in write mode
>> longer instead of repeatedly grabbing it, allowing other operations
>> that need it in read mode etc to make progress, is actually
>> preferrable)
> 
> That's always a trade off - if the frequency is high, then a certain
> level of batching makes sense. The good news is that you get to control
> that, you can just batch more or less.
> 
> Outside of mmap locking frequencies, I suspect potentially nicer wins
> might be around TLB flush reductions for this family of operations.

For mremap() and munmap(), yes, just like for MADV_DONTNEED.

mmap() maybe if we do a MAP_FIXED that implies an munmap() IIRC.

But then we are again in "hairy to reasonably batch" territory I think. 
These are all extremely involved operations.


Is there any use case for the patch set at hand, in particular, in an 
un-optimized form?

-- 
Cheers,

David

