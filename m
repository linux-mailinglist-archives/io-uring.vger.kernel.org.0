Return-Path: <io-uring+bounces-9600-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DC9EB46318
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 21:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 479111714B8
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 19:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D469315D50;
	Fri,  5 Sep 2025 19:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xzWjbI+J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5348315D22
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 19:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757099074; cv=none; b=rqoBjDiFXt+kYcNQSS1cq+cqbSJf/t+akNGT+6nTPg6HsJfCK3OBGkveH1p8QCAWtP+d9PxA3rFp/d3ZSrXyRukIzeJr0Fb9FNStSHyW/22Wr2A2fIB5oouJDa6NjbB2CSHPG0qWO47lpiS+EqeYmu0nZCbCz+wVkuMgVm5dWhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757099074; c=relaxed/simple;
	bh=Sn0BXbM07idm8sO438PzPmjUPqXnWU0r7K0IwlqvU2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VcOMJABExx/IbwymUNriykf3rHy4F9cLTsQPg1jhCG/1O6d1LvVHWbyae8i7iY5TL7Hwi1ToNcLiJAp6RgFLBDQZ5pnPSFIYkFV1L/jhHcpIRtyGx4dHmdfZ05bt8SKSV/1Rh/3nSAok8hZkdV6B6x4ngAwwamVPr2HM7cJnWh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xzWjbI+J; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e96e45e47daso2038334276.3
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 12:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757099070; x=1757703870; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XxBCZX8Izl5D+0pOg4L/p29Smjh1ZAemLQvdEG9SfkY=;
        b=xzWjbI+Jazwey4gXQB2ioa/r+aiy5on3kLlycKfd3K6G9U6OgsQHSLp+59QF1qISCw
         /tXZltM+2Sbi+49duXNJCZMm1ReOfGBbNKPxIElvmbuSWhUAhqtRrNWKFl/WMNsyJ3Wg
         nbyUdtgF8wanxYx02cUMJG2WtNk2AfdaMFsMSGhcpZjBl20WEAnb+XqlonMH67+bZvtT
         mL1Sui9I4Et8T3GaMtlrPEGO3CzFIkYzjMncCv2XlHZ0ve+KGp5l6JNuxx/QYvgO4fKV
         MBXQ0k15o4JWycn04MHBvoxo3sjFvYs18SWOyGYXUh9PWg9GDk3u2wLQbQAxOKmIaVuf
         oN+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099070; x=1757703870;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XxBCZX8Izl5D+0pOg4L/p29Smjh1ZAemLQvdEG9SfkY=;
        b=alxKfjmIVmDwQeO3wuh/R7+X1a0yy8WW73Qifz9ddf6Ys1xsZl1Rt82qXO8VPNZji6
         RwsV1cQPx738tQGGLTjer+jlyqt/nIUKbpy5CJ4Uru09X1w6kS/l+7U7tWbK3ilhoRHO
         2olfwjGcyzgxXcpowENmWebtZ/EYu7XnvoJFhZgzSFf8LzgpH+d8XV/FBq6S3xo/Bbn+
         fLV1Q7XvB0OrZSw6tXMuTl3TU+vFdjYIvxr2IZKZrUiCt9cm/mYxg/y+AucNv6dvU2Ns
         h2h0EWXCQYQBTwiw9rkr9PiQdcJqR1uInBbymtaO56NGRR7YCK8p6lZSjiC6jqQBKm/h
         Z0KA==
X-Gm-Message-State: AOJu0YzZkRZI5yxucmpYocFgDHA0/nCn8SvebBIQYKaTCVDX40f7WxKf
	B0Vy3iOPvzKIe5/c426GxIFbpXum0yv0qRUBojx6mC3kbeOInTTJ5A9dUjhjphRpwzk=
X-Gm-Gg: ASbGncvmI4BdStMDd44YZvUcWHCs5f+X0vyXXDIjbTXZZipTo7qYyF+JbNDNQSXyAYV
	6uFc2A8SiqHYeL1MXnSQSf3iFWgMWAN60RVVNby2qhX1HjlYMm8B+UmMVi3M9FzJ5oCb5hEuQoO
	b6+zF4yEG8xz4rV8rrehAD1Y2Mi0WRMPLVlP5LSG0+gZqaVLirX7hMaSKgFJMuHdp8h+1gaE3Cc
	PEuPETJKZNvu8JzCViiY64+9ERicjbS0PnTTCodBLmtyhR1QdcMoMXvb1n9jdZ638ACCNPAeLFb
	JDKo7ZFcYmlHF/XWJIw4yHZxpp4hKJvfAZ1eScALYx4sZ4wLzT3BFBF9iuP804cj8Kb46xVAqLV
	jK3DsKkQdTqC++nfMbF3deglQknBe1w==
X-Google-Smtp-Source: AGHT+IGzubTeOJn31WfH2BTfn46wcrLD+ISMCUoNPouJZ3zCsopnZCIZIAUP7TuFPBZvEWtUnf6ETQ==
X-Received: by 2002:a05:690c:ec8:b0:71f:cefd:dd39 with SMTP id 00721157ae682-722765755a5mr242989747b3.50.1757099069614;
        Fri, 05 Sep 2025 12:04:29 -0700 (PDT)
Received: from [172.17.0.109] ([50.168.186.2])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a85aefcfsm31234077b3.68.2025.09.05.12.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 12:04:29 -0700 (PDT)
Message-ID: <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
Date: Fri, 5 Sep 2025 13:04:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 Konstantin Ryabitsev <konstantin@linuxfoundation.org>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/5/25 11:24 AM, Linus Torvalds wrote:
> On Fri, 5 Sept 2025 at 04:18, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Just a single fix for an issue with the resource node rewrite that
>> happened a few releases ago. Please pull!
> 
> I've pulled this, but the commentary is strange, and the patch makes
> no sense to me, so I unpulled it again.
> 
> Yes, it changes things from kvmalloc_array() to kvcalloc(). Fine.
> 
> And yes, kvcalloc() clearly clears the resulting allocation. Also fine.
> 
> But even in the old version, it used __GFP_ZERO.
> 
> In fact, afaik the *ONLY* difference between kvcalloc() and
> kvmalloc_array() array is that kvcalloc() adds the __GFP_ZERO to the
> flags argument:
> 
>    #define kvcalloc_node_noprof(_n,_s,_f,_node)  \
>       kvmalloc_array_node_noprof(_n,_s,(_f)|__GFP_ZERO,_node)
> 
> so afaik, this doesn't actually fix anything at all.

Agree, I think I was too hasty in queueing that up. I overlooked that we
already had __GFP_ZERO in there. On the road this week and tending to
these kinds of duties in between, my bad. Caleb??

> And dammit, this commit has that promising "Link:" argument that I
> hoped would explain why this pointless commit exists, but AS ALWAYS
> that link only wasted my time by pointing to the same damn information
> that was already there.

[snip long rant on Link: tags]

I just always add these, because discussion might happen after the fact.
For example, someone might run into an issue from an added patch, and
reply to the list. That does happen.

IMHO it's better to have a Link and it _potentially_ being useful than
not to have it and then need to search around for it. Searching is MUCH
worse than the disappointment of a Link that tells you nothing that
isn't in the commit already, and it wastes a lot more time.

And if you're applying a series of patches, then it'll take you to the
cover letter. Which is useful. All without needing to go search on lore.
You could argue that you could turn any applied series into a merge and
add the cover letter there, or link it at least, but lots of things
don't end up in a merge commit before you pull it.

What is the hurt here, really, other than you being disappointed there's
nothing extra in the link?

I, and everybody else, can surely start making judgement calls on when
to add the Link or not. But that seems error prone, and might indeed
miss useful cases because a bug report comes in AFTER the fact.

In any case, if it really bothers you that much, then just make it
policy. Historically I suppose policy has very much been formed by Linus
rants in replies, which then gets picked up by LWN and others and then
it becomes part of "Linux kernel lore" of this is what Linus expects.
But I bet you that LWN would pick up a Linus email on the topic that
isn't a reply, which said that you've observed Link: tag being used
frivilously and why you find that annoying. And THAT would save you a
lot more time rather than need to rant about it multiple times.

-- 
Jens Axboe

