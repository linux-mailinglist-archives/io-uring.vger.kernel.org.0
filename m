Return-Path: <io-uring+bounces-9601-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 43580B46332
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 21:08:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A35E2BA2FFB
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 19:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F98D27877D;
	Fri,  5 Sep 2025 19:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GmAZhFgj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AC22798E3
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 19:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757099251; cv=none; b=XJhg+/QfEusKncgEU8y2xe+s2Y9h9N7rE+YAeXX+iV1WfQdN3AM8S/NlEC97hDwRVDNJ6YokngUtbKhXw8qcJalQpq8klW5/lur2E9CPRzEVt1OBc5AZyVKgsXD0X64tFPw+8kzz3CPH6JZKor/oQCYAS4S4Djds75H/8yqmH60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757099251; c=relaxed/simple;
	bh=vlr48yjk2puCT7uOaqK3TIiyqr5+WEUX/j47wSb86CU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=H+sw4rpFhce1YFLqchzpV1wAx22A8NineXuCM2Bv5ZScbw8/rndawOwDIkAAXTS9lhAjKd49tREYSS5qxfHhtePSdKzXZ+F43gtDwXW7JHaUUhQVMF/vBeeXCzL3cmHk4qcYKFqm1TA6vvhrRGmwYc08Fow7FLmZplunIrNoNcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GmAZhFgj; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e98a18faa25so2334384276.2
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 12:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757099248; x=1757704048; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/uT4lkvGe+y46mKowMKKO7TyZfguuQ/FdpoqEpw5I3k=;
        b=GmAZhFgjy5OW8WRnWZ/duLDmuFrzQ3fCaOd/zBrz08Hce5w3tSmN1ZptomdpoOtCpp
         PWxp33baQ3CafLwKA7xF7L7iXCzn9I3MWdtFxaLZ8MzBxiCa4SoYCx7ghgJ8T/ndZIa6
         p4d+W8HfiWNRu0WQAOe77Ca+RWHKGAOE4M8Rp0x5HaT8Y39eEg/WX5cEbyln1uP0V9v0
         G7c1+wKIEPQHBTKIf+XciLfYGxaQdeyNOTnnumtKi4yoZHQPwfEhaxUVbbTOkG05pQdC
         dHmuJdZd49zU411tMMyuXyzepLzKvacV0eKislt1TrMQWFa6VWyo/g46t2HUdphIhEsZ
         jEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099248; x=1757704048;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/uT4lkvGe+y46mKowMKKO7TyZfguuQ/FdpoqEpw5I3k=;
        b=Btj3/API9g2WM7UdngwNJbRaH37JYUdNJ1whisI9IO7Bp6vbkyrldN76F9tvDfpV+p
         QrD7eDwZGOcBojS52nj3ODdmCA7X62cVKTct5cWgjoqmuh+QHDd1GYwSbUpHo0J0FOnI
         tfyeSDQzTUSQdtDXNyJxuVaI8gdS4hsUlDfBcC6+EFh/MhFgBqwAvYy93ZyhHDRuhnta
         CcofJjpplbzIWREYBpx/7OPD3KMk2aeD6tHUw83tcvDPSbBzRadNDFVZ3DkhQQ/PvIsd
         ssQiCnXXrVIdWN4wsaGtO69UPSgVDLFVBRScGe3Z5Xp+iDA5Mrx96BoZYtACNA/wKKnc
         KJaw==
X-Gm-Message-State: AOJu0Yxvg/+Ep7QZeUlytj27BwdSBZYB2VZ/FfIZXRABA3W6wOl0iPIL
	Qc6VpCqeffa9gl4rwcjabeC5BiW+9NpShTPAoQgYjPYha/DzwHnSqS4FQ2PH6ynrPvs=
X-Gm-Gg: ASbGnctdn+mfIiXcCES9glhX/lTsjXdM1iy7+3ZBf+fiXnifHVH6aGHoz++BSNWRAVs
	2+yUM6HoUnUo7Lh9oP42YTq1DQUa9tGb2KVy5T5zCIBf3dW5cCLz8cg1/8NbeusT7NyvoK1YdZX
	GjPwqDCAAplFsY/GbuKnkUerZ+paBQBwW8KHSIPAslf8ToLr8QjkcfKEzYK0a8BUkTCvvNdWSxs
	ri0RFyqXvdLgdDJNIHkWoc9ZvFdpqmXmUeRRAYl3jImJ6+M29gA5DFlw+EUigJjBflk7/aXLSCQ
	5s45vdmWnoWjX6eIOARnHvB34dnBb56eqd41nHbnQm/L6naLeZdVV3TzyhPaeolbPDwNRK1a5Hw
	LsRgUOV8eeiQq4+/EVlU=
X-Google-Smtp-Source: AGHT+IHRaFtjoK5bo9szmroiEQrbnORGl1E5zP1Dql8mRsC2FHxr2c2Me/4PQx9Sja95+qCmVuLMHw==
X-Received: by 2002:a05:6902:4a82:b0:e97:d52:c5d0 with SMTP id 3f1490d57ef6-e98a575c25dmr21468168276.2.1757099247507;
        Fri, 05 Sep 2025 12:07:27 -0700 (PDT)
Received: from [172.17.0.109] ([50.168.186.2])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9bbe19ae4asm3353020276.32.2025.09.05.12.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 12:07:26 -0700 (PDT)
Message-ID: <67393fa5-d103-48a0-b62b-0f9197bfdc99@kernel.dk>
Date: Fri, 5 Sep 2025 13:07:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 Konstantin Ryabitsev <konstantin@linuxfoundation.org>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
Content-Language: en-US
In-Reply-To: <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/5/25 1:04 PM, Jens Axboe wrote:
> On 9/5/25 11:24 AM, Linus Torvalds wrote:
>> On Fri, 5 Sept 2025 at 04:18, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> Just a single fix for an issue with the resource node rewrite that
>>> happened a few releases ago. Please pull!
>>
>> I've pulled this, but the commentary is strange, and the patch makes
>> no sense to me, so I unpulled it again.
>>
>> Yes, it changes things from kvmalloc_array() to kvcalloc(). Fine.
>>
>> And yes, kvcalloc() clearly clears the resulting allocation. Also fine.
>>
>> But even in the old version, it used __GFP_ZERO.
>>
>> In fact, afaik the *ONLY* difference between kvcalloc() and
>> kvmalloc_array() array is that kvcalloc() adds the __GFP_ZERO to the
>> flags argument:
>>
>>    #define kvcalloc_node_noprof(_n,_s,_f,_node)  \
>>       kvmalloc_array_node_noprof(_n,_s,(_f)|__GFP_ZERO,_node)
>>
>> so afaik, this doesn't actually fix anything at all.
> 
> Agree, I think I was too hasty in queueing that up. I overlooked that we
> already had __GFP_ZERO in there. On the road this week and tending to
> these kinds of duties in between, my bad. Caleb??
> 
>> And dammit, this commit has that promising "Link:" argument that I
>> hoped would explain why this pointless commit exists, but AS ALWAYS
>> that link only wasted my time by pointing to the same damn information
>> that was already there.
> 
> [snip long rant on Link: tags]
> 
> I just always add these, because discussion might happen after the fact.
> For example, someone might run into an issue from an added patch, and
> reply to the list. That does happen.
> 
> IMHO it's better to have a Link and it _potentially_ being useful than
> not to have it and then need to search around for it. Searching is MUCH
> worse than the disappointment of a Link that tells you nothing that
> isn't in the commit already, and it wastes a lot more time.
> 
> And if you're applying a series of patches, then it'll take you to the
> cover letter. Which is useful. All without needing to go search on lore.
> You could argue that you could turn any applied series into a merge and
> add the cover letter there, or link it at least, but lots of things
> don't end up in a merge commit before you pull it.
> 
> What is the hurt here, really, other than you being disappointed there's
> nothing extra in the link?
> 
> I, and everybody else, can surely start making judgement calls on when
> to add the Link or not. But that seems error prone, and might indeed
> miss useful cases because a bug report comes in AFTER the fact.
> 
> In any case, if it really bothers you that much, then just make it
> policy. Historically I suppose policy has very much been formed by Linus
> rants in replies, which then gets picked up by LWN and others and then
> it becomes part of "Linux kernel lore" of this is what Linus expects.
> But I bet you that LWN would pick up a Linus email on the topic that
> isn't a reply, which said that you've observed Link: tag being used
> frivilously and why you find that annoying. And THAT would save you a
> lot more time rather than need to rant about it multiple times.

Oh, and I totally forgot the relevant tag this time:

Link: https://media.tenor.com/74lPb8mSRQMAAAAM/abe-simpson-abe-simpson-cloud.gif

;-)

-- 
Jens Axboe


