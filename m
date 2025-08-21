Return-Path: <io-uring+bounces-9167-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 89691B2FDE5
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 17:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B33FB17B4FF
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 15:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 831A0219313;
	Thu, 21 Aug 2025 15:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GRx8+zWo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33E0224B04;
	Thu, 21 Aug 2025 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755788597; cv=none; b=hJM9YLpyifMg9dZW4yiso1ZKvi5Sx8AvlM64ZQwQcE4Iy9dyr3Y7IwElOYXLKxTAHS8is8/Sjhgrd5uGD+mqAF1ff8OVuLLl95La8em3eFbwNMKBMzc4mQq4J7/JKT2O6mC48h21s9foTq+oWvBJINQ9fYuZRcAdgjxHupCjiIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755788597; c=relaxed/simple;
	bh=eG8tMdZ6ez6OY79lh4rWCVb57KYN1p1yvtLR6obd3Xc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A6SzfFdEOFNmRKcUM+iPIRaH3Ok4HCJSguAWCGVZOL7kdN5hqnaGgmMh15ocTBW7FhPB60pncgzbbxaCsWfR0G6PTDtjG52TfENYszON9h54yAmutKOQHVjuGpvnzun4lvKD2Y5uMDx4dOkghGz69rOyAxZiQIBYMl4VjMeTtc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GRx8+zWo; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afcb7347e09so189150466b.0;
        Thu, 21 Aug 2025 08:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755788594; x=1756393394; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NlYkbxi7DFW6oY2NRpdpDsqyhyO6hkcK+DM6dtjAz2U=;
        b=GRx8+zWoxb9FZHfWOAFlJe4QYmjgAXXvEwE6iGxn0KXWeq4MNw//fEvili1V36mVgV
         iymMPbUu1TPHi7wnhSzmgweMtdM6a/UvR1uI7f0KK5+2UodoVQ9YfGZprrRgTYbtZT3S
         puvBhIbJCim8zzNwYXl7Oe7CY9tkjlzpIlqmhKN6HRl3RCjwuQUn48tN7Iu0181EoZdN
         QIAFD9Lapq6NNZgkcNwObriOE9VWviMnUlrTq2vOTY7HGUjgu0pZLYEIa6mIefZjq5KM
         ShTjX41flqr0+QxY6eGn3VPErhpFYo0/fQRJ04CsiQCvRyjW4ikA085Ff/mlFx4GDapJ
         /YrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755788594; x=1756393394;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NlYkbxi7DFW6oY2NRpdpDsqyhyO6hkcK+DM6dtjAz2U=;
        b=TA0EP9SefNFOxYAaCbb2WujeFPBRZybBHEHlytEtQYLMPXcVCTft6trPhq4hfstJPV
         3i57qNA2nsJ6/knwa3Iam5ER+r7kXoKI+E25BTIzKyd7jrgD4EHE5XnUHkLI0Sb2lxkT
         /s3wmJdZhercWbeflblF2FvfXICI0G4Dvw1zsgZUCI5Owq5qGoeINL4xH8Qwc/QlXa3e
         62txXXj1sdMhUU8lAtUMF34s8aAO4hCtOnm8UuCfmG85+jA4KM4uV6TDxZjSUFL70YKJ
         XCxiYbLdoes/WXwcEgAU1ZANBglOFrbs2dA4bfC3REBqCG52WpmFtNZQ+yRpysZi7bJn
         FJWA==
X-Forwarded-Encrypted: i=1; AJvYcCVpRZGOappg9ZuqrCHjrD5/8M2LM9pNV56Vv6IPwNvDvLeLmknfHtWTu/RNTvr703NLIPh2mS79Lg==@vger.kernel.org, AJvYcCW6NWVogKqQL/2BTdXkdBvyATisg+g9aWcWTeFlyDZInIOZOBnd1wjp5ms6Y1EFgcThb6TAu3dG4Y6HQMxp@vger.kernel.org
X-Gm-Message-State: AOJu0YxBtDonyRk7ZHlAVy7WxtE+rVLfqB/WmHWDFheqBHliukHBWce0
	67Z0KgYRzlOEVm0DDXznPmd+feKvLhSkWCvarP79ukQmL6sMjtnZ5FHq
X-Gm-Gg: ASbGncue6CBYxfmDtrcSdzAcahYgxtt29qBbJqrjMNjUv20k+sCwANhkNKrtkgp77dP
	x1vcTrDX82wjkjRPH6reFQ+WasXS3UdSbP9w8ytSCECMyiR+XB7RgIzjl7G7uREFlsctNnD8Z85
	wzUa9q3CFm1iwLjGbktNsL0Bvb8D5sGNw0B0maqk0cVsYmZ77mkVu75DB+sgDNsJt2J8zoN327x
	1XNeAHBGQIVCAtBxOJIcAqDuff8mCk/AK6qzlhJHIVytrqv68Bgzq6gO0IWqMRIWIbq0/w4x/Qb
	eJh9CD7PShxnXtvH2oIZR5BgZCEU7rRR0TPf3n0kZ4sr4JVQWrR48ot6FlW9yNWhuiGlxKQe/ih
	m1VUA5xCzlca9r4cWB/eR2icjI//IgzmW
X-Google-Smtp-Source: AGHT+IFDyzgm5SmuBDn9kus3exbU+SN8MuIf0hWHhWlqlJvBcwpLtZS48R/L1NwfWLBBp8JbB/tm1Q==
X-Received: by 2002:a17:906:4794:b0:af9:c31c:eeca with SMTP id a640c23a62f3a-afe07c232f0mr252067766b.48.1755788593498;
        Thu, 21 Aug 2025 08:03:13 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.113])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afded307138sm406142966b.45.2025.08.21.08.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 08:03:12 -0700 (PDT)
Message-ID: <52a6f5d6-ce59-45a8-9271-5c6248d5b90d@gmail.com>
Date: Thu, 21 Aug 2025 16:04:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 00/23][pull request] Queue configs and large
 buffer providers
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, almasrymina@google.com, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <cover.1755499375.git.asml.silence@gmail.com>
 <20250819193126.2a4af62b@kernel.org>
 <fb85866c-3890-41d2-9d5c-27549c4b7aa3@gmail.com>
 <20250820183711.6586c1c6@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250820183711.6586c1c6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/25 02:37, Jakub Kicinski wrote:
> On Wed, 20 Aug 2025 14:39:51 +0100 Pavel Begunkov wrote:
>> On 8/20/25 03:31, Jakub Kicinski wrote:
>>> On Mon, 18 Aug 2025 14:57:16 +0100 Pavel Begunkov wrote:
>>>> Jakub Kicinski (20):
>>>
>>> I think we need to revisit how we operate.
>>> When we started the ZC work w/ io-uring I suggested a permanent shared
>>> branch. That's perhaps an overkill. What I did not expect is that you
>>> will not even CC netdev@ on changes to io_uring/zcrx.*
>>>
>>> I don't mean to assert any sort of ownership of that code, but you're
>>> not meeting basic collaboration standards for the kernel. This needs
>>> to change first.
>>
>> You're throwing quite allegations. Basic collaboration standards don't
>> include spamming people with unrelated changes via an already busy list.
>> I cc'ed netdev on patches that meaningfully change how it interacts
>> (incl indirectly) with netdev and/or might be of interest, which is
>> beyond of the usual standard expected of a project using infrastructure
>> provided by a subsystem.
> 
> To me iouring is a fancy syscall layer. It's good at its job, sure,
> but saying that netdev provides infrastructure to a syscall layer is
> laughable.

?

>> There are pieces that don't touch netdev, like
>> how io_uring pins pages, accounts memory, sets up rings, etc. In the
>> very same way generic io_uring patches are not normally posted to
>> netdev, and netdev patches are not redirected to mm because there
>> are kmalloc calls, even though, it's not even the standard used here.
> 
> I'm asking you to CC netdev, and people who work on ZC like Mina.
> Normal reaction to someone asking to be CCed on patches is "Sure."
> I don't understand what you're afraid of.

Normal reaction is to ask to CC and not attempt to slander as you
just did. That's not appreciated. All that cherry topped with a
signal that you're not going to take my work until I learn how to
read your mind.

https://lore.kernel.org/all/bcf5a9e8-5014-44cc-85a0-2974e3039cb6@gmail.com/

When you brought this topic before, I fully outlined what I believe
would be a good workflow, and since there was no answer, I've been
sticking to it. And let me note, you didn't directly and clearly
ask to CC netdev. And I'm pretty sure, ignoring messages and
smearing is not in the spirit of the "basic collaboration standards",
whatever those are.

>> If you have some way you want to work, I'd appreciate a clear
>> indication of that, because that message you mentioned was answered
>> and I've never heard any objection, or anything else really.
> 
> It honestly didn't cross my mind that you'd only CC netdev on patches
> which touch code under net/. I'd have let you know sooner but it's hard

If you refer to the directory, that's clearly not true.

> to reply to messages one doesn't see. I found out that there's whole
> bunch of ZC work that landed in iouring from talking to David Wei.

The linked thread above indicates the opposite. 	

-- 
Pavel Begunkov


