Return-Path: <io-uring+bounces-12292-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OFMYG6NplGlFDgIAu9opvQ
	(envelope-from <io-uring+bounces-12292-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 14:14:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7DCF14C73D
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 14:14:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 50D403020ECE
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 13:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CCF635FF5B;
	Tue, 17 Feb 2026 13:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ACfDFMUP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF173612DC
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 13:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771334045; cv=none; b=uZ2zSQi3Z3a572Q2MNt2jCwHBb14RW+6ZG3g0sRbXS5PU7WzJoSh3mDQd7QyH2sVTwEQPvs4q3KKdZWuiPkOIDzOIP8Xk8Kkiwl9fcH1wngbbuPDLGtJ8053TGmQGxkXDipiVVzfS5Y563pREbF0s6DR3LDcHJYca8ZvPbRcYwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771334045; c=relaxed/simple;
	bh=KgdImVWaXCqHS7IFf+UtC6bOQ8fO+oFr0mCM3o/JL3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jQA8FPfRqRICHkQeRTIoM+L/L1WiwK5irdRI58dCKHDRW8cy+KTwufsx8VqaHOnRkSSDIzZSU2ZwCQUikj4diprHMRCUrWMcXifFST5EXB/23gpxoTsMn8KXkifb8eCZx2lXwCY3LOdYlPXpQVQBHNK9d6TTp+YJSz8TjrqneBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ACfDFMUP; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-40974bf7781so3768381fac.0
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 05:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771334042; x=1771938842; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+hvRTCg0bG7pjf0n0vlP3LHvxQEYZFAerxPCqp6C9Yg=;
        b=ACfDFMUPMD77feB/ZsadPSA0wGjNWW8fvFsI1wpraQeGV/OrnLZQ3Hx6QmnpTGDiyG
         gnmC/nK3PipMfi5AlBXmbbgossQTnpiDz6I7vc9fGU3xAdeO4vfP2VdG0QXzknlqZDuN
         a5L8ayh0Tfobpoczrywejn9StIX5ziSt9MohUKSMfXxAphOv6S9Ohw8bFbi92zMvZCzq
         NN4hm1mL9+3RekbdMVHENocinQIIN+mt03sKBoXsWPR8CIxXSiK5JQ8uYAkWLyblD07p
         8U2xYdoo9Krxmzeyn7uOMUiflhonBrumrTWhs7P0YDzKo01atd2VuBSFHzbVfVT2jQHy
         hmDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771334042; x=1771938842;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+hvRTCg0bG7pjf0n0vlP3LHvxQEYZFAerxPCqp6C9Yg=;
        b=FhJnq57TxApnEiiGmEk/FVjzhyBK6OcpgiLSmS5mdhTR+ByOgxI5H5BjVAS41iU0u6
         C8VrxPoDeBKl0n2JjfFIKLUdFDlwL0VJF3kwnEyvmPej6P2r0/1u+9ZqC1BQpczAgpBp
         x+dnJUKM8NThx2bS0VSjEWppbdvdlVDpEmni/GAcvbkGi4whwVHWvBIFk/O2pNpjqOVz
         VTXMVOAI/nH+OI20Gn9yMORtrxO1XhK5+hNkG9IIve0Izj6SAueTk1iaSFOyfzI+Akpn
         GIYzq236ddNR3ZxOZmT1v+R5shDtEkXrRmh0jOwzBAOcuZC7Gtmd8lvphI/sidfvcYmh
         Ejgw==
X-Forwarded-Encrypted: i=1; AJvYcCUhiED84gpEj1BopifZ1v68ProyLqm5mQHzYiO35qHQTL/FyjvuViMAL2R2j/pNZzIc/hHDfpPREg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCj6ZxuYw0zRH/8cZZHcWEhMmzvPO0SL1jWmrCbVi/qMZFKzsi
	5iwsEwT/GfRMooCqHxPWkEcMuINSULHMhKxmncFk/vI93F88b5W+Xi9rOx5AyECpOWd5H2tY1R9
	Qfdpo
X-Gm-Gg: AZuq6aKGDratWgylK5jZdbAhz/crQMWg1NvFkq8cmaY3IkmQ+8kP6VLLUXad9nlfxZ4
	EXc26XCJbMrdPF/WjjJIoQ0L3Wy4SOIuJeV0G+WOfg+sk9a7CNZBFTs9so3xUTrfjLCwKqORmp8
	JitSYsZ3Y8is7Y3CFN+RYkSLBdg8O+N088hkqU6EgSWO3oWACyLbz178Oqz77lIhFH6tWThEK/0
	8Zux3gVp83powCgXOeN/qkPW+ruNbZo7wBnffq50QlTJSHgOANpzbIrEUiM5n9qQJL+j0/TjRYs
	35/hXMmZyiLKfiyR7IWqA90pul0Z6j0/cXe+AlPSEESMz1qjGRswUqZLLP6cLCYCX7TkgBjekU8
	ivuWP55bZw7pCC/OAx4pm1nxpz3YEtf/xuQL6jqoX6wj3VX3Qf0frggX60tTqgX3Tc7D9b6voKL
	bB4dDJNUUBjqnTTREMeIXVJtsV0ydE0nXoFMAFkEju7zJMDyhBNiZZaLab4bS3ia3W4AXecsiRt
	OQZo807EQ==
X-Received: by 2002:a05:6870:a103:b0:409:5e6d:2716 with SMTP id 586e51a60fabf-40f0871a263mr6446066fac.5.1771334042340;
        Tue, 17 Feb 2026 05:14:02 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf103ac3sm17272166fac.11.2026.02.17.05.14.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 05:14:01 -0800 (PST)
Message-ID: <de0e155e-05c3-4e6e-9de4-067ac94c01cf@kernel.dk>
Date: Tue, 17 Feb 2026 06:14:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.1 v6 0/5] BPF controlled io_uring
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1770836401.git.asml.silence@gmail.com>
 <d56b5f70-382e-4017-81f4-c9ae7a6c1b56@gmail.com>
 <ab4c6ffd-d7d2-45fc-bbd5-b6663d5c41e2@kernel.dk>
 <1985145e-7181-40c6-821d-239f62410618@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1985145e-7181-40c6-821d-239f62410618@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12292-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: D7DCF14C73D
X-Rspamd-Action: no action

On 2/17/26 4:29 AM, Pavel Begunkov wrote:
> On 2/16/26 15:18, Jens Axboe wrote:
>> On 2/16/26 7:23 AM, Pavel Begunkov wrote:
>>> On 2/11/26 19:04, Pavel Begunkov wrote:
>>>> This series introduces a way to override the standard io_uring_enter
>>>> syscall execution with an extendible event loop, which can be controlled
>>>> by BPF via new io_uring struct_ops or from within the kernel.
>>>
>>> Let me know if there are any concerns or comments. There are some
>>> parts that I'll need to add like timeouts for waiting, but those
>>> will be natural extensions, and this feels like a good base to
>>> move forward in general.
>>
>> I don't have any complaints on it, but would be good to hear from the
>> BPF folks.
> 
> I assumed Alexei has nothing against it in general since he didn't
> mention, and his last review was quite straightforward, I just applied
> all changes. But I'm not sure if he wants to take a another look.
> 
> I'll send out v8 to silence smatch, and let's see if BPF folks have
> time for it.

Let's plan on queueing it up once the 7.1 branches are started. In the
mean time, can we have some liburing side test / examples so people can
play with it and understand how to use it?

-- 
Jens Axboe

