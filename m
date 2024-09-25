Return-Path: <io-uring+bounces-3303-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C9586985E53
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 15:32:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7589B1F21B4A
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 13:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0630917C985;
	Wed, 25 Sep 2024 12:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jL0mtyGi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FE117BEB9;
	Wed, 25 Sep 2024 12:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266283; cv=none; b=QKXi+/QzBPLkoSdrQb4V37t92lQ8PZqIim97mlhiX8zH8oGTREwT1F5FwJooVQSWOvhkVVCkwUrpw5NDklDnA+wdU9ZobsPTm4maQX6jZxrQH27BzrPIET6qycAWs8yKvhfMk7dvmjNQuZIUK38sYuilE7d9bVEOBaAxA48Fczw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266283; c=relaxed/simple;
	bh=PUVNBgnIa4l40mnGlrwfTKt8522hvAy93E98nVKVo+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eBsjfPBkc7ycemBJlJdVhRiQ03yrq7SoDm9na4f1z0dWHrHfk08SU/qwffUDd6/CCkX4+7YMKNRS7qussDYfaoOjlGTnIhlYYXP9fHjCaXjejEevUO2a6b3u1dIqU1CWmCw0L/nxpUs8FvusBKY3PktysYSrdG7eg/0rVkW/FDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jL0mtyGi; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8d2b24b7a8so168497766b.1;
        Wed, 25 Sep 2024 05:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727266280; x=1727871080; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9hW9bK7WjApbQpCc3LHU+3cowizY2PJ/6QHhNHuy6fc=;
        b=jL0mtyGi2XFkn6bGEM5szVkMJZvCdFfN4CgKM47AbTw3o6fSFtabs45ZCjRo3FQ7ZU
         odEjWU4YTgMfUWfgLwR44zkiI+DDEcOzTfS+/z+MfLFTccb+7R4EW6YHhWLpYf3zeKQT
         QA5C77oMfY1fgHf5csYumSJYWTXzbDZz3DymTzc4KL5Lbem90ut+aK21t8Hl1lY8apeE
         F2F8DgSuNVJc/1Ld4Pfl4sjVo6uxOcjsbuLpsASv8cUPA7qCJ8OpZbbl56C56frlYDZ7
         kWX2+AiXGt8aoCY4jxDKduG0VTFAj0Vb/733p/QYG2o3vLP4lC3Dueha5D6Sz7appHK1
         cZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727266280; x=1727871080;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hW9bK7WjApbQpCc3LHU+3cowizY2PJ/6QHhNHuy6fc=;
        b=tnuGJQruKZwEvA/B7gYL4hCKhZQcwoSEkXTcxX+nIybRdkt2zsP3YPgoD8422FQAEm
         G1marr1rY5fOtAahYQ8TESwwuN0Xq5ZseWSwZSBj+/92Wp6PF19akjC6be5gnGu11QVg
         nMieYFPWRLXw2LR30wZ6bklr7/NIDNb11By8PGofAKFkQxRtWjsMs79Fe86HWD0noUXP
         7bk8+bHogM/upzezrOcxj7ejpmpw5Ga1Yq575x2MuiklTvMFoFe5Acp6gENL1qOYT/oT
         iOA8eJ9bnoH2gEGQS2+WUGQDHdBAor60IydBZ/Rgfb462qbGIjP9GlBpDJbKfvX/M49F
         9jSg==
X-Forwarded-Encrypted: i=1; AJvYcCVKLHf9MwOuWPvESdvEIrU5SmBQT8jXCj5Q4UB1ojFt8c0cPx1DYa9lRQgVgHcZQZ3hxBrZ4uHi2+iyQyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMX1X/h2xEuH2GAjFSKil6zGoRAIR/FRVPAfdToLxawIgU0pZ2
	NbMlmNXlvg4CeuyNpo4NuTmGovROdcv2FHc1wJZ+4PHd8Tjn165VLekfSqIZ
X-Google-Smtp-Source: AGHT+IEU0urojDpL0fOG84+kksHaHBDz7bnrNhZwKyqJc5xvZWmVZf7CkpnJW2UZ5LAl1YzmDFS+lw==
X-Received: by 2002:a17:907:a09:b0:a8d:4c83:d85d with SMTP id a640c23a62f3a-a92c4811c13mr729896266b.12.1727266280235;
        Wed, 25 Sep 2024 05:11:20 -0700 (PDT)
Received: from [192.168.92.221] ([85.255.235.163])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93930f82dcsm205313366b.177.2024.09.25.05.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2024 05:11:19 -0700 (PDT)
Message-ID: <293e5757-4160-4734-931c-9830df7c2f88@gmail.com>
Date: Wed, 25 Sep 2024 13:12:00 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8] io_uring: releasing CPU resources when polling
To: hexue <xue01.he@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240918021010.12894-1-xue01.he@samsung.com>
 <CGME20240925082937epcas5p1baa4bb786ea874400d7b18553cd57625@epcas5p1.samsung.com>
 <20240925082932.3329096-1-xue01.he@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240925082932.3329096-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/24 09:29, hexue wrote:
> On 24/08/12 1:59AM, hexue wrote:
>> This patch add a new hybrid poll at io_uring level, it also set a signal
>> "IORING_SETUP_HY_POLL" to application, aim to provide a interface for users
>> to enable use new hybrid polling flexibly.
> 
> Hi, just a gentle ping, is there still in merge window? or any comment for
> this patch?

I don't have a strong opinion on the feature, but the open question
we should get some decision on is whether it's really well applicable to
a good enough set of apps / workloads, if it'll even be useful in the
future and/or for other vendors, and if the merit outweighs extra
8 bytes + 1 flag per io_kiocb and the overhead of 1-2 static key'able
checks in hot paths.

-- 
Pavel Begunkov

