Return-Path: <io-uring+bounces-12388-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4L4oH1+AnGmLIgQAu9opvQ
	(envelope-from <io-uring+bounces-12388-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 17:29:19 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6429179C97
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 17:29:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 18CC030200E8
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 16:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C18E30FC1D;
	Mon, 23 Feb 2026 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ljno1fDh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB95930E0FB
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 16:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771863989; cv=none; b=GLEEyEmCBKF628bHnrRnV06Nxz8Gbe4otuG5IMx1vGc8u9YF3XpwJSY7XKqoPQGb1KbF9vUqId3s5n9ZCpbswmiBm8wsWdGeOagH3w2DhVFyuQQ1VMuYZrWZLqh0HCUaXOK/nL2GaBGH9BQbNZK1Mj3IbnEUonbfNyovdu6zJ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771863989; c=relaxed/simple;
	bh=lIGmXa8myVtUxsOqfYxqVtmc4Q2dqXBBcBxArxi9V7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tRlwqWZP/5aleNrAeGuLUvtb48I5SCjlOp1RUW046AF6dKUpThBLICktND3Gb8NFLbCjO/wvTRPe0cVyBmBxhXs5Jb0WnENVHW34WHxUdk5i0inAknOwMtIx9K6OAVm9WbCaB45tt96MDsNJI8oQTJBeffByqqwjDXbrgovIrM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ljno1fDh; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4834826e5a0so56585795e9.2
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 08:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771863986; x=1772468786; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rqe7eP2/t2WLWow5bcQFLzacPy8f6F76CKBflwV7ZMs=;
        b=ljno1fDht8S0v6YCBP+ONKsEb1s/7D0fUKv1irj4DxfiYaph8zuw2tkkq9z+pd9AL3
         +4a880wWeWsOq4m2fvxx5rMOrR71jG8G/+ZKo2nt3pyGe+OMqW1e4qTq5w0cJ2JcL59e
         fI73Uvdj/Z65/G8z/uxOayUGHtmhdMxeVOQmAL9DX/v3YI9d9LFgTzX/mX//nRSzn/vW
         7hhDHi0x+jq1LsTPZdrCFU7jV1nCeMtj9+mIYPk/aoefDPkBtGwjsxA5dS2F0j0nhUar
         KOYlcR1QguspTHCsKUUclp8eRGyD+leQ7bhNeoo55S5QbHhc6xc5YiDLqNuy++VSR1Tu
         xtSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771863986; x=1772468786;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rqe7eP2/t2WLWow5bcQFLzacPy8f6F76CKBflwV7ZMs=;
        b=MnrXxJzCnYGUUDpUmyBf8R/ntjfwfFd9p6cFEqFM1SYKRa0RjgsJr0fva6FbMayRwn
         5j66GubU8NMdcjkAdRVJv7JZ2dcbTt2Q6aA4DPLCi5Tms1AqKIkU4cLdaU1khr75/rzA
         E4y6Fh/DM9JoIbCJCLBm3GMFZO4nNYQQy1Z0RsSmViWAY76VV6RF6I1VHt6Ko31/Ta9H
         m7JxSEs8+CAoQOdkgL6BzMGvu5kEq9mtXpNYtg94cuESYbc9pZdCigGYzHPPja6saiaB
         tT41tJqU+xfARdlPaEa7tTHpduYFV8mJ0alQOyR3YXGHI1uVYDL7NM70ak9brgyy2da5
         dVJg==
X-Forwarded-Encrypted: i=1; AJvYcCWbNAVxXzLr2Bn9bThuWSJZmCTZwhQXSL7vVEbyW0B1KXU1n+S0/x0uY0eOKQB9Et7PKqayedoqaQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxNaMC9ScARofpNUKtwNKncGzi8EUwNKSFWHLSRZuYkI2IJ2QZK
	X7FOYPo965bA/7rGXviexvXhqALT80jKDWB4qJ30ESEvjcBfmItyrf2e
X-Gm-Gg: AZuq6aKKZCl6YYdZ3SZ8BRo6dq9z7diKBmHtj4rY2HE26bAzz5Ti0fHpeseJowI4glb
	8L6pFpj7dHa/no0QqVQraWbQ1TUMrGUY1O71TVsXVzmaOEEQLrlvnzDYe5g5LJzHBfOr4z/Xh2H
	9clK/mIrvEzgQlpmVZPl/F8P58S+mzzGjLnJPwIObsvcjg52lVMpi8fgxVRZ2tA6AQQCPAhNPZZ
	7v/TTc9RN6wxaxJUwndw6lT3mcMNMZYXBXEo7n/RvQd/YYj38qFnoqZW7S3ReXUoPFdjsYRfIPQ
	rMn3VwmQqFQjg4yUoIQFdVRlcRHYtA2fjOSeboLDmgykYrQupCMUC/Ur+o9FBCQGJ6KctZ8HdQF
	T+z7HOG2eUP6dT6dtFVtjRCsSWH5QGDCqgASynPz/aJZ85CeKDqpdv6fVoiHe9TmEkOg8hOTb0h
	4uliEKFapgv7n+DgbhOpi+ZluT5XhVLrNIFK7hsfyDHHq8GA+natIQtAMERGmHVmo6NK4EAD8C1
	d+Hv7yepCrx9W2vlqi/lgWyTsw8rtj4PSkzMPJTk8Mkdr1yDROTXhjjZiKeudlbo0UpkbGAzF6V
	cw==
X-Received: by 2002:a05:600c:4e45:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-483a95e957bmr187456755e9.16.1771863986095;
        Mon, 23 Feb 2026 08:26:26 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a429e49csm142919405e9.4.2026.02.23.08.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 08:26:25 -0800 (PST)
Message-ID: <ed7b85d0-38d0-413c-a28a-f3b0d1a72a13@gmail.com>
Date: Mon, 23 Feb 2026 16:26:20 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/5] selftests/io_uring: add a bpf io_uring selftest
To: Ming Lei <tom.leiming@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 io-uring <io-uring@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
 Jens Axboe <axboe@kernel.dk>
References: <cover.1771327059.git.asml.silence@gmail.com>
 <7cc147a959ac068c55dae4f540e38e9e4ab121e0.1771327059.git.asml.silence@gmail.com>
 <CAADnVQK0RaOA9ZYZdYyQxOzLde9MR8HpMM0SexcW59A9u7X2Jw@mail.gmail.com>
 <84e2f3ad-28f0-4e9a-804f-2647cba9b30f@gmail.com>
 <CAADnVQLSEoZ0V1m5j3ggX0o0gzVKyiDHL=J6F0wRXB8qk-MCGA@mail.gmail.com>
 <591a7f0e-7b78-42f1-9486-163249f5e306@gmail.com>
 <CACVXFVPx5AcC9y9xVPCaahDeumNGm4TSkkfhsJ8w+wmW52JQ4w@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACVXFVPx5AcC9y9xVPCaahDeumNGm4TSkkfhsJ8w+wmW52JQ4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12388-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A6429179C97
X-Rspamd-Action: no action

On 2/23/26 15:23, Ming Lei wrote:
> On Sat, Feb 21, 2026 at 6:35 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 2/20/26 17:45, Alexei Starovoitov wrote:
>>> On Fri, Feb 20, 2026 at 3:41 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> I had such examples, but selftests is not the best place for that.
>>>> It can use abstractions, and I want to make them reusable instead
>>>> of people copy-pasting from selftests.
>>>
>>> Sure, but please still post them as extra patches so it's easier
>>> to see what's the end result.
>>>
>>> Also please reply to that thread:
>>> https://lore.kernel.org/bpf/CALTww28QMg=YXqKWpWLZrLO+xiqOe3LGyput8dx68-dnQsxg=g@mail.gmail.com/
>>>
>>> It's not clear to me whether your io_uring+bpf setup will work
>>> for Xiao's use case.
>>> I don't think we need 2 ways of doing it.
>>
>> We discussed this with Ming on the list before, that's one of the use
>> cases I target as well, there is no reason why it shouldn't work. The
>> difference is that this approach gives a flexible framework for
>> extensibility and covers a good bunch of other needs, which is exactly
>> the reason I moved from a BPF opcode approach, while Ming's proposal is
>> more specific but argued to be a way easier to plug into ublk servers.
>> If you ask me, we need a solution that covers a broader spectrum of
>> use cases, but I guess it all can be argued in either way.
> 
> One big drawback of  Pavel's approach is that it needs a totally
> different userspace
> implementation for using BPF, which is just hard to use in existing
> io_uring applications.

Not really, it depends on how you write it. If you need to rewrite CQ
handling in BPF, e.g. parsing CQEs and stopping at interesting completions
to calculate checksums / etc. with BPF, then I get it, it's more involved.
It could be useful for other reasons as well, but that's beside the point.
But you can do that without ever touching CQ/SQ in BPF, for example,
execute all your BPF work at the beginning of a syscall and indicate
about this work via user-BPF shared memory.

The downside is breaking links in two if you use those, but perhaps
you remember my opinion on io_uring links, with the amount of uAPI
side effects and locking complexity it adds to io_uring while not
being too flexible, I'd rather replace them with something more
generic, like this BPF struct_ops.

In either case, I need it for a broader set of issues. It should
work for things like checksumming / other manipulations of
internally installed registered buffers, but even without it,
there are enough use cases to justify that.

> But BPF opcode approach is seamless with existing io_uring applications, because
> it simply uses existing io_uring interface.
-- 
Pavel Begunkov


