Return-Path: <io-uring+bounces-7437-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EA51A82624
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 15:21:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D93D3B6ECC
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 13:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36EA525F7B0;
	Wed,  9 Apr 2025 13:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CBBiQQvU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF954C80
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 13:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744204558; cv=none; b=E1ATggNPMhfjV4jq/bx2Pxu0ktWi5y86HQo9sZW+5jtWJw7JsRGGIg/r7t/Y6NhJ06BSVlqQZ4PHIGk0mi2H1/JlcsJeVclnbcwj1UBuz4X7PXtOn0wKdY8ld9+u+PAcaXDoqvExWKMTcI9ujBGMin0XVp9dHdjdWQx+uuRSvNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744204558; c=relaxed/simple;
	bh=D7SSH0CPN8p1TOBjOexC+NqVqmTNtY6VQ7H7mPazf+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Xnp89tIliWsvB05+TjRH3IlfW6+slmpL+k1mXJZHIvrgW/9hoQqXxwlh5ukUrz4ilrJVx5OK+JqS7gIdeJTP9jPteDA9z+rrT6cJkRL/933kzRnsiy7H6mOnLTaFMrTteaDbXotV0QLVz6D9Wc/4dAEuqxIt5Wff0qZ6xWmYSmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CBBiQQvU; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d58908c43fso19607025ab.0
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 06:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744204553; x=1744809353; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WFQAs1JnbteDqQ+S6J8sY8hWqT2l1wzgIEgGULs/AV0=;
        b=CBBiQQvUUAu7dPlzbauINdiCyNcFx24QOov/iMRN/7k6SAE92t6Qfa/gFVsjgV7jlA
         xqW1gkKtMec4byD4FGmmV/V5vorU1udRVxbdgZdrNiXNqmO29X9PWXl3bbgqSrGGaZWc
         9Wkppk1m6m/XS4qUunBTS8cAUfCOJluGe42EcErk42Xu+FCpxbOxUh3hqbGVtL0gSYoC
         rTFm7HYFa8BwuBMug2/kdzMypd6nbtPOhOZTh+uGTu50g/N/kShFE4XGNJ23S+F5ijcn
         e6h+TSxIO6NwiKrI73XSi3uNifRXTMl1W8FbPaWAO5kIJxJyw4fWbdNTROn6VG026hF8
         tQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744204553; x=1744809353;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WFQAs1JnbteDqQ+S6J8sY8hWqT2l1wzgIEgGULs/AV0=;
        b=qMZIBZmNQNuTPF5YcQBzfPEn6PByFo40BpWriOqz+R5K1ubsZby3pilu9JxhfIA5r+
         DPGUXNeJI9QowRpLwvyS4nqqUSRtYrhlszV7oO0BXo8uQIecKAfrBhnRkc7Iyd+8lIws
         sNCdKK+2iw9DvUZJecgwehugCaaNaDuMq+jOwoKYt5V3yuCkem1yMI1XLfY4wovDdO0C
         3V5LtVGMsUkmfkHjUJEpu37jtM7DILO8gn7hy0FzKm5D6JiQLV3ReJMI98z+lvVTDd7z
         7Fc2sl5MjD4QNf99DEmRr6VGpMMPoCgA3vGMsSIsnoQOTWzfPQa2wTX6fi/mxN3LMvsd
         KP9A==
X-Forwarded-Encrypted: i=1; AJvYcCWlU5QGwVLhAzziKU+FGBrt4Y+tfXJSTFissa9PSO7F8g7lplJi1vvsZqMYub56KP93E0JNkE7VWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxL2lXJDQ0l4hFCf6PbKl/Bu9wghBcY+162ysJHPdQGnhxwgYK2
	j6xpiwBBHmdYxDMGj9xPhm2ucKJdfDSMGnYI6HIGLGAL2QOze96ar4dioGKbG3k=
X-Gm-Gg: ASbGnctbqLlAdQkkx+Y1umHTIA7FTGLFvnkmRdA74NCZ9C3PqFAH8Eta4C2xtjeKamM
	mN092KGJyYdt1WskdteumgPm/+x4+eCZxObUnN9F7UTJFeORMnIEuLiLmCN9/JxkUV6fgHxKCdO
	4SgdEbucGkj44g2Iz8gcJAFsk50BIrSpD6cxJpR9tcEju9CxUKQtLBJVwUOFIM8atwlfjRmyeB7
	tW3SwG2W6TF4574nIm1Za4eJy1KgXtfFZDx9tRWdBg7MSomcRLupvdM1wVmPpXbdv8+kSRz4W2q
	j7v6FT2N9X1iyj3XPUYStNVLaK/FgxIwjRFG
X-Google-Smtp-Source: AGHT+IH2/NGkLJfLvlOXjbRmIKBmLgYom3MEXUaHD+EcjA3QcNTIpJtvlmJ12G+rXEnKSoFzXaWEKg==
X-Received: by 2002:a05:6e02:3783:b0:3d4:3ab3:daf0 with SMTP id e9e14a558f8ab-3d776c9d0dbmr26767995ab.7.1744204553305;
        Wed, 09 Apr 2025 06:15:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d7dba8535fsm2542745ab.25.2025.04.09.06.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 06:15:52 -0700 (PDT)
Message-ID: <0f372fae-2274-48f4-9f10-98e9e8cbe2ca@kernel.dk>
Date: Wed, 9 Apr 2025 07:15:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: consider ring dead once the ref is marked
 dying
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20250321193134.738973-1-axboe@kernel.dk>
 <20250321193134.738973-4-axboe@kernel.dk>
 <c84461d9-3394-4bbf-88d5-38a4a2f6dccd@gmail.com>
 <27a391b1-80a1-43ae-9550-73f48c1b8fea@kernel.dk>
 <07b0ced0-cbf6-44a6-add0-e0cb1854cde2@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <07b0ced0-cbf6-44a6-add0-e0cb1854cde2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/9/25 3:15 AM, Pavel Begunkov wrote:
> On 4/8/25 20:22, Jens Axboe wrote:
>> (getting back to this post the merge window)
>>
>> On 3/21/25 3:22 PM, Pavel Begunkov wrote:
>>> On 3/21/25 19:24, Jens Axboe wrote:
>>>> Don't gate this on the task exiting flag. It's generally not a good idea
>>>
>>> Do you refer to tw add and the PF_EXITING logic inside? We can't gate
>>> it solely on dying refs as it's not sync'ed (and the patch doesn't).
>>> And task is dying is not same as ring is closed. E.g. a task can
>>> exit(2) but leave the ring intact to other tasks.
>>
>> It's not gated solely on dying refs, it's an addition.
> 
> Right, which is why the commit message stating "don't gate on the
> task exiting flag" and leaving it gated on the task exiting flag
> is confusing.

Ah yes, the commit message is garbage... I'll send out a new revision.

-- 
Jens Axboe

