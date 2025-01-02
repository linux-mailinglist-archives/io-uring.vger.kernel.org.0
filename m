Return-Path: <io-uring+bounces-5651-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98ED79FFB74
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 17:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCB8C18836A0
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 16:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C15A210940;
	Thu,  2 Jan 2025 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PX5ERbMl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F1B40BF2;
	Thu,  2 Jan 2025 16:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735834817; cv=none; b=YrhtisxEEqW80SDZFX+6tDQYUuuhFM/GzwuqTIcVC/ZOzksHaU/LLf1PZhZE6C8p67mNBNQqKYUXQgUQ73Nr3l2hMeCfuZrMx84miaD9923pXHQ2s6H61vOBHM7/GLWL96yqClW3ZmA1nqL3RpnrN8DYXSJyF5Y3MVRD4wbFFmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735834817; c=relaxed/simple;
	bh=M9o99EOnGxVVJht1Qcq5uaKHR4p+4Vn4cnJ+IisksAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l2Xfub2mjp9iLcqlRE5rLUz5VqDRCcHBmEncz0ugeGamoysMdK9NQjQ0YAUbkFSBivRt9kZ4npgAgl8sLVQ778PYuH+dwRiisCylKGvQZPW1YQE2fSgST79Wr10iaO5WNzg9BCpB9k3klVnvU1lcAm9TlMAvYwSD9lzx1ytp+08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PX5ERbMl; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d7e3f1fdafso23558083a12.0;
        Thu, 02 Jan 2025 08:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735834814; x=1736439614; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4wGUo1ci/uq47xKePQAyM4u7LMWJ0jiFc37jZhu3its=;
        b=PX5ERbMllaJf9uRfzNpvEcEHFxu6xDRBhc/OoraHa1J/VknZFu3DaCbgpxsnN1WkJX
         dNFRyaM2egGfADheUReYqx4DX/jqhhRhr6a4d35KTtLnHT2XXZoyMynIHJB7tCYSz5EN
         YSzG1U0XzoUtuI96Fqwg+7u7U7XBIBefhdJU5qVs5leM0WgYQ5XIggWTueoegTUN2hrj
         vSRc7dwW+RohInkLWW+V8CyW8NBV21p1GgMHKqh+vKc4GfcywDCE02C8FaIZUb6mQfk1
         TbzjwpMgu/IPooERShj7Y9eeOny7bQ1HSAeOO+0F2FDOPCGhTuyTyRGzNFGe703gg3uS
         Ur2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735834814; x=1736439614;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4wGUo1ci/uq47xKePQAyM4u7LMWJ0jiFc37jZhu3its=;
        b=rT0x3/lz1G0KO7V4RK2TgpO4pCpZpxhr6p63bLKok5l7t+FltBlUcLz7Je4no0UxR7
         sRyXiYni81oTglUQIsm4MTirei5r0rlTgAXLisY1gS3IUElXm/bJJGMMFDaLO+741K+e
         WXEXtdiwgHGqxh1T7I2uizJAJ2MAx49zjlaHTntadScPE4DulVYQceaH0uODMEK/NM6s
         XU1kU6/d6NcEFgAmOZKMFZ025ySs4llPTp+C1a0hWdLCfe1evmaEp5OD5m5mV4UUE1FT
         E3C3djchcuEoofv8P1DjaUAz+xzYjM4OKigVtbZD//8cUYct2ieHyMTutDIx/ZGR/6Jg
         zmEw==
X-Forwarded-Encrypted: i=1; AJvYcCUhEaHU/PzFulLMU03IR1SDLC5xPt1Uwvtt9pPTC+ekcBwOhm+vwKBDVL9+5QHHcXNTYDE30r8r9Q==@vger.kernel.org, AJvYcCWXAe/om+d+QdK32DxPabhInNL6nIC6DIw1eyTqg0i6wY+tPXcHbCe6N0nAGrUYASKd+95Esrk3@vger.kernel.org
X-Gm-Message-State: AOJu0YwdpDLzhcyrkXSLnmSZ4UBpXh7AtamKtGj3aVP9SDoHP+k1PogO
	6CxqeA17r8Ezi4TbcbHcJ4g0rKFmP9m/UvyfMdIVt3XeBlxkJldy
X-Gm-Gg: ASbGncu5tDmd6ktRW/igFoJMBVOjhTYKwAkJJbC2ct+e24wFKWLpPmrAC9vqSghlsti
	91VQvV0icteOUo1JYNAu83asCPwP2CKqbTy9ATxdvj8wJiCM+tzthsHtAWtq0e3v7hcaM/Ge1zT
	b3AlPyUURRecu61lh9dNM+ewuHCrh+GwMVCI1/5xqNHq4olSyhQf8GXJBP6wL9VvtldxeK+zbgY
	KoAwznGdCE3Si/G0h+UAtswqmWsW01V4JeOCHjWpGUU5f0uzRNoJeZtJOVLepHhnSqg
X-Google-Smtp-Source: AGHT+IHRgl3XT9Jt05Q4RMyztzQGeE/HCL1+JANGK5+8zf6d8Ay2wJzDkvfrDvnT7Z1gDUrrF/Tf7w==
X-Received: by 2002:a05:6402:388d:b0:5d4:5e4:1555 with SMTP id 4fb4d7f45d1cf-5d81ddec777mr41302129a12.19.1735834813957;
        Thu, 02 Jan 2025 08:20:13 -0800 (PST)
Received: from [192.168.42.201] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80701c8c2sm18268829a12.84.2025.01.02.08.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2025 08:20:13 -0800 (PST)
Message-ID: <bcf5a9e8-5014-44cc-85a0-2974e3039cb6@gmail.com>
Date: Thu, 2 Jan 2025 16:21:07 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 08/20] net: expose
 page_pool_{set,clear}_pp_info
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241218003748.796939-1-dw@davidwei.uk>
 <20241218003748.796939-9-dw@davidwei.uk> <20241220143158.11585b2d@kernel.org>
 <99969285-e3f9-4ec8-8caf-f29ae75eb814@gmail.com>
 <20241220182304.59753594@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241220182304.59753594@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/21/24 02:23, Jakub Kicinski wrote:
> On Sat, 21 Dec 2024 01:07:44 +0000 Pavel Begunkov wrote:
>>>> Memory providers need to set page pool to its net_iovs on allocation, so
>>>> expose page_pool_{set,clear}_pp_info to providers outside net/.
>>>
>>> I'd really rather not expose such low level functions in a header
>>> included by every single user of the page pool API.
>>
>> Are you fine if it's exposed in a new header file?
> 
> I guess.
> 
> I'm uncomfortable with the "outside net/" phrasing of the commit
> message. Nothing outside net should used this stuff. Next we'll have
> a four letter subsystem abusing it and claiming that it's in a header
> so it's a public.

By net/ I purely meant the folder, even though it also dictates
the available API. io_uring is outside, having some glue API
between them is the only way I can think of, even if it looks
different from the current series.

Since there are strong opinions would make sense to shove it into
a new file and name helpers more appropriately, like net_mp_*.
  
> Maybe we should have a conversation about whether io_uring/zcrx.c
> is considered part of networking, whether all patches will get cross
> posted and need to get acks from both sides etc. Save ourselves
> unpleasant misunderstandings.

That would be terribly inefficient. Net is already quite busy,
would be a shame spamming it even more with io_uring patches that
are not being particularly interesting to networking. Even the
patchwork tooling won't work too well unless patches are sync'ed
with both trees.

IMHO it sounds saner finalising the API and cross posting when it
needs to be changed.

-- 
Pavel Begunkov


