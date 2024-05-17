Return-Path: <io-uring+bounces-1926-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 734038C8EB1
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 01:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2DC21F2219D
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 23:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 655821DFF3;
	Fri, 17 May 2024 23:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zW6Y4HnP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCD3EED3
	for <io-uring@vger.kernel.org>; Fri, 17 May 2024 23:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715989883; cv=none; b=oEoF4xxPmUjlD1lX/tvZBq/yEGiCiCfg5i3BF0bDdc6V4Ds+LFodNDGSzvxeIQB0zXI+XMEeRWtAy98+LU9W5VyqLhI/ttqMNPKb45JiKIeMqVmNEZgEcDjo3cInZeNuJ43CB094hIRBXKXY6Yf8p2DA5XvFSwPs3YK6FU/z9Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715989883; c=relaxed/simple;
	bh=ER0cQ9BaW/3nNuseWuKlnAsU8XW/NZOo/nHFL3SpdBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sd5RVPuOg7Iq2Brq2mnnnbBSnU2nbb6YI498MwA33gbAeELAbyexo912I4nTRab6WWuB0gPKuQABjijFVESIQB+fSwAN8++PBZZkqfFcClYKYrKBclzNJo+v+Zv3XMmc1IXOy/OTMtyTT4iz/T94QO9RXCOdqU0cRpZW/K/b27Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zW6Y4HnP; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1eecc7131a5so2413165ad.1
        for <io-uring@vger.kernel.org>; Fri, 17 May 2024 16:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715989880; x=1716594680; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jTycHRdI7/Kg99okVNdkr8YjEg0B/9Sq6xZ2EXCYe/U=;
        b=zW6Y4HnPPAOWT/mjAhX21W+X0TH+jW3o3LcWY7SSu+h2TJUQJ2OidouWQikAaStTWS
         +ta2dz8uyT9MK2vOmeDJBEd8dQbqXvjmDvw7BVnREhjs7A+yUR1SA8DHoTxLmSei3Vok
         MLAKcdJHTsIzB8P/yPrpcidBw9Zex49imxBTymI/+r0bb6FJWnefM69DwkrUkPXJbyZZ
         1A4+t7df8i0DUK0AApzaxCX9v5vUdnQ9x15HYzeULvOwxhKi8B+udV/+aSNPZFy7elQa
         dkGOwg/6f8X5JxBk/vqen89dKObfMfGQUTqQJveL1Zr0ywoG5G/IKPWwyYKJSTATLORl
         TaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715989880; x=1716594680;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jTycHRdI7/Kg99okVNdkr8YjEg0B/9Sq6xZ2EXCYe/U=;
        b=S2bXyJA/RnKvtWIx3pE5URKeNk+hJRVkV0/cpmaqP4QvGtARY2E/gbkhmwI+wBbY+H
         Zb233bvCdAktOhaErR4Ex/GEfwe5E7DzFDGDCTtv5kzISeDB48iVQKkWKUVvr9zy/lAv
         jk4NGgv91q4dTNqdpIIs8BW17nU12xf0fYftJmTge0Z46o2F6ekqkjsKmTwcHF1ypJVW
         ZJSzL4PkI1m7E2yBb6eoW3uLfOM7IVfVvnWvi7orSl3J11GhJSQ3fRfFblDRTl30kxcm
         X4M9hwOLiNRb9TLcNCDmSVlACS+Ok/Vd/EgEPStLZ1urpUNZeGrjJDXGrdW55keNFWY0
         rjYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmffxNNDVyh66mGRqJ3LzNof+Zdo+jXVCDvk0itk9Cwsgi9U+qEniFmlRxj5VO/KB+Tz/F/oEq4IxQOf/cmWOS6v16VBhFf6I=
X-Gm-Message-State: AOJu0YxNVaDvlDLGTdHvB8/6sGFrMc+6hwKmFeT51Or3tfyZkaisq+i1
	VzxIiC0E46YXNPfIAX1vwxRRRob08C2Nehp8AkGS91EFxW21rFmU50cuR5GXkbL4CUVv2c/1jlv
	8
X-Google-Smtp-Source: AGHT+IGyrSjeGbWScjCHCe3eRi7QBCJ/mW0Pbra8PdWLPZxODWlEaJCq+L/zoiT+FihvCE3i6YoTAA==
X-Received: by 2002:a17:902:ce81:b0:1e2:b3d:8c67 with SMTP id d9443c01a7336-1ef441b826fmr261159855ad.6.1715989879685;
        Fri, 17 May 2024 16:51:19 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c25698csm166594365ad.305.2024.05.17.16.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 May 2024 16:51:18 -0700 (PDT)
Message-ID: <7a8e62ec-8bd8-4710-b4b7-5f2f530f5688@kernel.dk>
Date: Fri, 17 May 2024 17:51:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Announcement] io_uring Discord chat
To: Mathieu Masson <mathieu.kernel@proton.me>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org
References: <8734qguv98.fsf@mailhost.krisman.be>
 <f7367e15-150f-4fbb-b026-73d9407fd863@kernel.dk> <ZkfZIgwD3OgPSJ8d@cave.home>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZkfZIgwD3OgPSJ8d@cave.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/24 4:24 PM, Mathieu Masson wrote:
> On 17 mai 13:09, Jens Axboe wrote:
>> On 5/17/24 12:51 PM, Gabriel Krisman Bertazi wrote:
>>> Following our LSFMM conversation, I've created a Discord chat for topics
>>> that could benefit from a more informal, live discussion space than the
>>> mailing list might offer.  The idea is to keep this new channel alive for a
>>> while and see if it does indeed benefit the broader io_uring audience.
>>>
>>> The following is an open invite link:
>>>
>>>  https://discord.gg/8EwbZ6gkfX
>>
>> Great initiative!
>>
>>> Which might be revoked in the future.  If it no longer works, drop me an
>>> email for a new one.
>>>
>>> Once we have some key people around, I intend to add an invite code to
>>> the liburing internal documentation.
>>
>> Is it public - and if not, can it be? Ideally I'd love to have something
>> that's just open public (and realtime) discussion, ideally searchable
>> from your favorite search engine. As the latter seems
>> difficult/impossible, we should at least have it be directly joinable
>> without an invite link. Or maybe this is not how discord works at all,
>> and you need the invite link? If so, as long as anyone can join, then
>> that's totally fine too I guess.
>>
> 
> Not to start any form of chat platform war, but the rust-for-linux community has
> been using Zulip for a while now. At some point they made the full message
> history live accessible without an account :
> 
> https://rust-for-linux.zulipchat.com/

Not a war at all, the only ones I could think of were discord and slack.
So really appreciate the input!

> It is even search-able apparently, which is quite appreciable as an
> outsider who just wants to follow a bit in a more informal way than
> the ML.

Yep, this is exactly why I brought that up both here and in person,
being searchable is really key imho. It allows people to find past
discussions by searching for similar keywords.

-- 
Jens Axboe


