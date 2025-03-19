Return-Path: <io-uring+bounces-7118-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F0CA682F0
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 02:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 215A8177C68
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 01:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C763822489A;
	Wed, 19 Mar 2025 01:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KIP3PtJK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8AB21CC52
	for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 01:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742349259; cv=none; b=ndHOjBKfafoVIV9oAL4WSmtfpd/ySZf2Hh6VO/LNPSXPjIBvdGSQ+FTRU8+oART2X7EVdICV+b+gSV6MaZTUDMKm2oGibwXC5rj87i06VGoVGMY1PoX21fyxwFM2t4FvkCGiUvpTsUnPCvlGrFwcpj0yzLhGrX6eSbIF7KAKvTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742349259; c=relaxed/simple;
	bh=S0I+o3dJNl4dI1SYQgNCxzRUOFzGe53HekfOJwkA+10=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RVPRiKM27s93YLqC5AMOF/ng4AKJFnRPhU01hWH4WYU15POJYI6q9XhmU6xQ7/uBOii9LQsz3Rim43mhGOwRjbypSqcRodW+W7YBLdXcbqMCdwnCvYkTAVmoYSCMueEQmJjFpnNzNPGUWZcq4gIoTBdetE8YqQfjyvm6YLFqvAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KIP3PtJK; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d4436ba324so42382795ab.2
        for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 18:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742349254; x=1742954054; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x1r0zK4HroPhvzD9O7lqBpwZ+ftLiHQ9pdXlD5ODuYM=;
        b=KIP3PtJKos4GKtjXtbcu2S5632eswUQKuo1kfgmOG++Ub4Gbm+Lg+jXIDwWU+pEuZ2
         EZiZnHq1zawDTWiMysw9gOZKx4KxMRwsPpGxMRPMZFmlHtoGDoTngMZhVMg2IrZL1At9
         Z+LLjdVQ18HGTlYa4QzedjsZddwG0FOVd8v1QOfFzFsr2U/dmIsOLNc6QCcR7A3m5HqE
         ak+yq8cVQw37foBVdjrS2tZG1pHNg7qWtKgCMM9G+HtXxstxA34MtGUd5cmXyHQ48cDj
         b6dE7zAbBVInTw3O7KUBpaYzKfr4B75HS79qcxR8eVcTEcpTEP4nbKHsXObis8qy0ofo
         1kjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742349254; x=1742954054;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x1r0zK4HroPhvzD9O7lqBpwZ+ftLiHQ9pdXlD5ODuYM=;
        b=Gb/KgNHb9Th+DCV471KwlsOY0EJ8AoyvHMduWu7XNc5iqArDeNQbZMPYo6z7Wd34l1
         sVvRJuSwCWCc93jrVPclIYy65NJYHuS37ltnOTRDd5svLgGWhoAZzNWUEFU7oyCtmVvf
         72g1S6ZO1NBXfd7NqTew6uX7KOZwvmDKbxB1Qa6d4hptBfC6FNqxLFvGc0zwlNRyGBQG
         PHKPOjrMAF/ZpUNBbht3klx9vE2otfCoBm6NCG9hSZDIO0sBcj8fnhsLDyl/N0YtuTwi
         8PlhSTJvr6Kx9t/76aBtfzyaupgnmvJCkBd83zmYaKsqIUfBS9w8T+/Dw3QbJufwmJTO
         dBHg==
X-Forwarded-Encrypted: i=1; AJvYcCXTZJ47NRvKjJ0iLtWy1RpUFQHFhLQFtclzob2lD7ff0mDA4J59tZgfhVrSAopsQhKOAAU7/CuGIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5Sq3zeKWxfHY4NfOizuenJxHXQcQWITv4VJ84yoS+lTTBTg0Z
	SBDgRj6/dDwlzIJCbsxSMbr3zSdFK5mrKji6Tj1kneKl6b9T2bwxw1o6EjvEtOs=
X-Gm-Gg: ASbGncvNaihbVBhkEjiS2pdqmsa2nzhG4oRmk/Tj0JKNhpnnoPhn7ku8WzH3IYU2fWv
	4xZYXr8UuxkpcneleducdG+6LGMVCYp3wVnBixkh3IjQqn9yehk9socVDP3lXN+B3UHrFTEgGC2
	is6RkHk/D6c15teVMPQFxUaiBkKamZ9a1pbUQS7CxKE782x2keQRueXtQMi/Ovg3/lxGKJLrOhw
	MbI4nvZ5S+eofyz6OBNVPZ5O3XDHmi08QZHGlQm93ufWIOplzDV1sFlKIVHb6SS/B7eS3Kxz2QB
	eS9/giM+M20WBAEWEGGU9EyiRGch1/21uLV/W9+kcQ==
X-Google-Smtp-Source: AGHT+IFXhdf0OGD0+cwneEJLBjMV9HDRr2BirtIJH8rswmn/mJB8FOruifahs+WmvEIC586C8SDG8g==
X-Received: by 2002:a05:6e02:2589:b0:3d3:fdb8:1796 with SMTP id e9e14a558f8ab-3d586b1b1d2mr10951875ab.2.1742349254101;
        Tue, 18 Mar 2025 18:54:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f263829ea0sm2981658173.132.2025.03.18.18.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 18:54:13 -0700 (PDT)
Message-ID: <2fc90b4a-a84b-4823-9eb3-5e330fb17b4b@kernel.dk>
Date: Tue, 18 Mar 2025 19:54:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: enable toggle of iowait usage when waiting
 on CQEs
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <f548f142-d6f3-46d8-9c58-6cf595c968fb@kernel.dk>
 <c8e9602a-a510-4e7a-b4e9-1234e7e17ca9@gmail.com>
 <37fcb9fb-a396-477e-9fe5-ab530c5c26b5@kernel.dk>
 <42d8e234-21b0-49d9-b048-421f4d4a30b6@gmail.com>
 <5be69fe9-4de4-49d6-a457-9720e50c92d9@kernel.dk>
 <807d665f-2b3c-418b-b13f-2c757fc0c762@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <807d665f-2b3c-418b-b13f-2c757fc0c762@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/18/25 2:07 PM, Pavel Begunkov wrote:
> On 3/18/25 18:36, Jens Axboe wrote:
>> On 3/18/25 12:39 AM, Pavel Begunkov wrote:
>>> On 3/17/25 14:07, Jens Axboe wrote:
>>>> On 3/16/25 12:57 AM, Pavel Begunkov wrote:
>>>>> On 3/14/25 18:48, Jens Axboe wrote:
>>>>>> By default, io_uring marks a waiting task as being in iowait, if it's
>>>>>> sleeping waiting on events and there are pending requests. This isn't
>>>>>> necessarily always useful, and may be confusing on non-storage setups
>>>>>> where iowait isn't expected. It can also cause extra power usage, by
>>>>>
>>>>> I think this passage hints on controlling iowait stats, and in my opinion
>>>>> we shouldn't conflate stats and optimisations. Global iowait stats
>>>>> is there to stay, but ideally we want to never account io_uring as iowait.
>>>>> That's while there were talks about removing optimisation toggle at all
>>>>> (and do it as internal cpufreq magic, I suppose).
>>>>>
>>>>> How about posing it as an optimisation option only and that iowait stat
>>>>> is a side effect that can change. Explicitly spelling that in the commit
>>>>> message and in a comment on top of the flag in an attempt to avoid the
>>>>> uapi regression trap. We'd also need it in the option's man when it's
>>>>> written. And I'd also add "hint" to the flag name, like
>>>>> IORING_ENTER_HINT_NO_IOWAIT, as we might need to nop it if anything
>>>>> changes on the cpufreq side.
>>>>
>>>> Having potentially the control of both would be useful, the stat
>>>
>>> It's not the right place to control the stat accounting though,
>>> apps don't care about iowait, it's usually monitored by a different
>>> entity / person from outside the app, so responsibilities don't
>>> match. It's fine if you fully control the stack, but just imagine
>>
>> Sometimes those are one and the same thing, though - there's just the
>> one application running. That's not uncommon in data centers.
> 
> Yep, but that's only a subset, and for others the very fact of the
> feature existence creates a mess, which might be fine or not.

But at least with an opt-out flag, if you don't care, you never need to
worry about it.

>>> a bunch of apps using different frameworks with io_uring inside
>>> that make different choices about it. The final iowait reading
>>> would be just a mess. With this patch at least we can say it's
>>> an unfortunate side effect.
>>> If we can separately control the accounting, a sysctl knob would
>>> probably be better, i.e. to be set globally from outside of an
>>> app, but I don't think we care enough to add extra logic / overhead
>>> for handling it.
>>
>> That's not a bad idea, maybe we just do that for starters? We can always
> 
> Do we really want it though? What are you trying to achieve, fixing
> the iowait stat problem or providing an optimisation option? Because
> as I see it, what's good for one is bad for the other, unfortunately.
> A sysctl is not a great option as an optimisation, because with that
> all apps in the system has either to be storage or net to be optimal
> in relation to iowait / power consumption. That one you won't even
> be able to use in a good number of server setups while getting
> optimal power consumption, even if you own the entire stack.
> 
> It sounds to me like the best option is to choose which one we want
> to solve at the moment. Global / sysctl option for the stat, but I'm
> not sure it's that important atm, people complain less nowadays
> as well. Enter flag goes fine for the iowait optimisation, but
> messes with the stat. IMHO, that should be fine if we're clear
> about it and that the stat part of it can change. That's what
> I'd suggest doing.
> 
> The third option is to try to solve them both, but seems your
> patches got buried in a discussion, and working it around at
> io_uring side doesn't sound pretty, like two flags you
> mentioned.

I'm not digging into that again. Once those guys figure out what they
want, we can address it on our side.

> Another option is to just have v2 and tell that the optimisation
> and the accounting is the same, having some mess on the stat
> side, and deal with the consequences when the in-kernel semantics
> changes.

After thinking about it a bit more, I do think v2 is the best approach.
And the name is probably fine, IORING_ENTER_NO_IOWAIT. If we at some
point end up having the ability to control boost and stats separately,
we could add IORING_ENTER_IOWAIT_BOOST or something. That'll allow you
to control both separately.

What do you think? I do want to get this sorted for 6.15, I feel like
we've been ignoring or stalling on this issue for way too long.

-- 
Jens Axboe

