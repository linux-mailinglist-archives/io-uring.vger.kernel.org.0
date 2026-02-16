Return-Path: <io-uring+bounces-12255-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GL6FHO09k2kg2wEAu9opvQ
	(envelope-from <io-uring+bounces-12255-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:55:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8649F145D3D
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A017B300119F
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CBEE31B812;
	Mon, 16 Feb 2026 15:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2YYsQ0Qh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98E92745C
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 15:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771257320; cv=none; b=KHM1FglDJYTkV/bdCu0VglaLqUPh8yu0fmhViUcivCk2AcJHmdQQqxhu790SvQ5/YJQ6ea5NO9Bd5m1FEEX6TohRvpixLL8QTZjMx7+NneEcbWaq+cHhfvkq0g9fGRBzzaMleG1sc/3vHykcA/6BX5fxOf64olak5V7KRdkI8+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771257320; c=relaxed/simple;
	bh=pJazBfy0HROFwJfy8V59SUzf6KMOy2Bb3DlfWqf0yqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dubdxSYDEIhOcxAEm7zr7+2TMRQi/ma8olZahbE+kTTwzHvpR44uHi36dJ/2LT/Jid9LCeDVwQdliWc0tsQXNHMu5i8nFCjn23iWkVAh0EdbH/p2tT0dtVaa1cZZzT+d9QyGKe+XgUC5Fb/v5/8yulblBgBRxNI6ZxjydpcXLLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2YYsQ0Qh; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6729292dcd7so1208680eaf.0
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 07:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771257317; x=1771862117; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f2CvC6B55vnbiUCo2DPbVbUOP2fY68BuD7IbCW0o+Sk=;
        b=2YYsQ0QhQYNb7rEoxIPL6H21Z73yopjNV+9a38t8t18lOreFMenqMa3HVezSI6geGr
         Yp2T9osl8x/tpwgFNeyZE1deHUFCjU1SxMUbLNsDWYjxdQYz4SPqxFHClWOrKbnCFvv4
         5yIGz5q0SFXJ8NBJlowmJr9N525ByieByuHWaM1Rj1oSE3302snG3mIuTYc3oHCFmy4e
         GKzP5YCWJ+IiXFs6W9SW6CXszNbBI8LBi5h/5N6lUKWdQiv4JobwSLtz38dwuzaxd17E
         13EwQ3Q5w09L9bLg3t6QTe4keVmxtqn2dG0qYd9hFVq7ak13jPfRC3VCnxw4WoE99gq/
         NNQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771257317; x=1771862117;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f2CvC6B55vnbiUCo2DPbVbUOP2fY68BuD7IbCW0o+Sk=;
        b=vXRC3CLOKEz/BhcBDWvCSw8Ed1IDhwu+tyMaM9WfWr8/a6rUzmV0NBiFO6bCjubea1
         NoNHTwxe0m0vaZ4eVVxOk92MTmZMDbDhCy9g9DrMdS56IE2psGIWi12W2PikmE/6lYN7
         +nsomiscGficSLeSkp+k0diMkuLfyBUVSZBTQux/mlRG9rvjHWbCl5xNf3vAOF8H+aE9
         MtmrxwjkjHFKGEIHRNit9vISgAp7891od2ecnb21s6wnbLa3+aR/D5VYvsuv1gUo/jCX
         b1xuws7vJLXiUSJJJU6xVWi2/C98IHGv+zjYhHXUYeVfbL1x9LbZ9mTX+94ktnyBBYNQ
         f49w==
X-Forwarded-Encrypted: i=1; AJvYcCXBk10OO0Egm4pwgV/+N0vrWar8sSQ/x3H8qXxjC2T833SmwMEuWhRo/0asqTFCy+yB6Fweuc9e5w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzoxNuirkUtuMYLL7jKbcm1OtuBTa0rEqFAL2+m5MVqy+ISZ2ki
	5GTd4HqnbkJ3nxnwsZf7C2nKOh5r6zORbSDLOU02ubWK2QEHw/efW8l6fOZ0MDIX8L8=
X-Gm-Gg: AZuq6aIFw1xdZQXjfKMXtBgwZieF54KiyBXpRzhN33tbJ1XAF66miWMXz+zfMIMcoDY
	Y+xxk0h5F2UTWOBZbIDops8YdqmWC9S+/3ZhjAid+UGSyg0Pj9Tl9WN+A2qY2AUrJ7gDwTyBTkJ
	XYGbhOpK5CuUvndEzfPWuVZvsh+Dr+kyRhtsvTM4wS+PPeK9Py96to7PPSUmHfNSSaRou3pqR2K
	ERmnuDG8vhyv2myqqcpwhf+2FJIgGcupLrVDnup09/e+EUH0tx4IYJl5kqDP60ELZ3ri+Znv5m3
	HAGSaf1Q0bLOpFH01Rfeg+JOQIW6v5ydR6zxTcsA+1rlUX4sb3VVesvP4ECkJKYi2RUqvnbtOOp
	SMarA7FomibOOsoy44naOurCmV1k60KnZJiTIZiz7oUM52SKZCeGb9rt5rDeRgQDp/t7geLmaB6
	nVpH0TlqVYpO9kTbgOMNJcc3Ehex93AINNhuncra1PkKWlFAeSkl8kL/GBOh7zVeASi8nDfTzbh
	FiFNfB3WqeEk+1ZuAQq
X-Received: by 2002:a4a:d550:0:b0:678:afd1:9fb6 with SMTP id 006d021491bc7-678afd1a48emr3268123eaf.69.1771257317374;
        Mon, 16 Feb 2026 07:55:17 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67832657b04sm5716810eaf.16.2026.02.16.07.55.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 07:55:16 -0800 (PST)
Message-ID: <fc217246-2397-4ae4-8354-7ed0c498d23c@kernel.dk>
Date: Mon, 16 Feb 2026 08:55:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zctx: separate notification user_data
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Dylan Yudaken <dyudaken@gmail.com>
References: <d099d8d0d7526e4eb59f5ffd0e890888a46b21f7.1771242479.git.asml.silence@gmail.com>
 <025de231-a6d2-4fa8-91e5-f4ab81d16e7f@kernel.dk>
 <5fa237b6-420d-413a-b7b5-9f85d9f1e8ba@gmail.com>
 <64ab6b3e-3746-4076-9c0b-b2edc2de92d1@kernel.dk>
 <69a2d3ce-5c77-44f9-99be-1b558cf4c4ca@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <69a2d3ce-5c77-44f9-99be-1b558cf4c4ca@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12255-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 8649F145D3D
X-Rspamd-Action: no action

On 2/16/26 8:53 AM, Pavel Begunkov wrote:
> On 2/16/26 15:52, Jens Axboe wrote:
>> On 2/16/26 8:48 AM, Pavel Begunkov wrote:
>>> On 2/16/26 15:10, Jens Axboe wrote:
>>>> On 2/16/26 4:48 AM, Pavel Begunkov wrote:
>>>>> People previously asked for the notification CQE to have a different
>>>>> user_data value from the main request completion. It's useful to
>>>>> separate buffer and request handling logic and avoid separately
>>>>> refcounting the request.
>>>>>
>>>>> Let the user pass the notification user_data in sqe->addr3. If zero,
>>>>> it'll inherit sqe->user_data as before. It doesn't change the rules for
>>>>> when the user can expect a notification CQE, and it should still check
>>>>> the IORING_CQE_F_MORE flag.
>>>>
>>>> This should use and sqe->ioprio flag to manage it, otherwise you're
>>>> excluding 0. Which may not be important in and of itself, but the
>>>> flag approach is expected way to do this.
>>>
>>> What's the benefit? It's not unreasonable to exclude zero, it won't
>>> limit any use cases, and it's not new either (i.e. buffer tags).
>>> On the other hand, the user will now have to modify two fields
>>> instead of one, which is cleaner. And you're taking one extra bit
>>> out of 16bit ->ioprio, which is not critical if it's all going to
>>> be flags, but it wouldn't be an outrageous idea to take 8 bits
>>> out of it for some index, for example.
>>
>> The benefit is that it's weird to exclude a given user_data value, just
>> so it can get used as both a key and a flag. IMHO much cleaner to have a
>> flag for it which explicitly says "use the user_data I provide". Also
>> easier to explain in docs, set this flag and then the value in X will be
>> the user_data for the completion.
> 
> Ok, I'll respin, let's go with wasting bits for nothing.

It's not like they are a scarce resource, and if we need more than 16
bits to modify send/recv behavior, then arguably we have bigger
problems.

-- 
Jens Axboe

