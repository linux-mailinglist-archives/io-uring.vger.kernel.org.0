Return-Path: <io-uring+bounces-5649-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D9C49FFB26
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 16:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4849E18834C9
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 15:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 197051A8419;
	Thu,  2 Jan 2025 15:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IY8em29k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519471A4F21;
	Thu,  2 Jan 2025 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735833076; cv=none; b=SZOVcpPVyY0gdeWzyHzUtgF6z4VdNzuDRk6DlsyHElJluX+nPQswwn+mErza6pBij5jtDjuP0ZEM7eyZPE+2+JZ+pY4kpaJsEfyTuoVc6RKKIo71DCAGF6D1I5yTWWxN+kq1d4ao6AR26iYCnQO/98H8hzWqgfnzX95RHiWCVZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735833076; c=relaxed/simple;
	bh=4/6V49JRnDk7qZKEliSb58XJbbuyntCVOMdpEIp0qJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PBDHZTOrxiKptKqd/1VkD16nSn9z8hoHNTXsl5HuMC4TvyI7EqbAVhhwG22/bAt4+AHDkn32PofMHwUtPuPWcwmWS+Cc9Awle7v1ZLRWH5GW0Fy4+wLjYgn+O0TVDbxalnyMYm+u3HUxlZaz/R6J6SmFaE5fF5UOrbMBDqizIiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IY8em29k; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d3d0205bd5so17003564a12.3;
        Thu, 02 Jan 2025 07:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735833072; x=1736437872; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bx135fJjyjVgK9hkfzgEFuM9fJK7cYqbqkL1EB2ekRs=;
        b=IY8em29kegm0bhe9p2k4C3eDnGBTXNgSjFrhGdBNSrX0F7ay+C8gbRBnEgnf4/TKqo
         c4e04dmz8hcv11DQHXCHlO1qPb9rZByd28Mjr0TXxAq2DmKoeuTrdY8KFzTI81OLMx++
         EembKNP4f3G2kBT9Zc6M2oJkOmkXn0uzmVjUFR2hF9O8IEigDzK3/6VaIC//kyUfPpHF
         WhTkanVgJ3r5fL6MsbQsJD5yTYFBsCgbS+bVELHsj4DJdaDrgq6ZlbsHPa6vHBihQ9k2
         Nc9YIwOmDKM22genI6SBQc91XT6Pb7hWvzvpOL2Dw1PoSYNOE2V1UCF5uANabdBYwex8
         EQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735833072; x=1736437872;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bx135fJjyjVgK9hkfzgEFuM9fJK7cYqbqkL1EB2ekRs=;
        b=JZdNWRdFfzo9ejhuSBJ9xXOpjujurbV57jGB2sJwsJi/Ywlc6G7LHD68JAS5uaiWEO
         RrVDiPT1IdgLA7TbAcJDJ+dFqRNaY35b/O7cQLqFHz8f6ySpp1MpKeIMNSkNMH2wwrGf
         kfEu1IKujr1NGN6vyJRVq0mQsxysz8XeH80D5yQSHAzbI40ayEcANDb2TJFEoJjg7x6w
         7KkKSxPrTWuMEHgSJfbZidijJs0CQ6CrDnJfaF+UbbxIFdiwGymfOHYnbLA4fnxyehOx
         dZQU4Zeii880euUZTBaBmXBYGybcN2UqzTrgwWGX76KfAaoJw9iXzLYf5K/4dDa8C5OH
         erXQ==
X-Forwarded-Encrypted: i=1; AJvYcCV01V2jC/v7uWf8T/A678uoSMPbmAUJ2e1DbVjFaVemH63slU/8Q3gDT93PdqJJxlVv0Iwwdf4n2w==@vger.kernel.org, AJvYcCX+zfBt6R473nZeKndqMUlRh8AS0eWKmhiKh7qfy41metlGi67s/KlPm0JTUxK0qTGCvlxDnIqf@vger.kernel.org
X-Gm-Message-State: AOJu0YxlUiXSjOZ+vwmWercQtqdXbCZ7u475NKfdrmndPLy3N2QaPZCG
	iVMUVJuWMhAX7fhR/Ls3nwrZeDxJxHEMWEPDV132ftpdqbBfD+ZEbNZQVg==
X-Gm-Gg: ASbGnct59HKCnnINCvkDgG4Z70j91ac5pI2MccDr2TDThAFkphR4LR+s4VgODUtwfez
	s0oNGzlu+kvlRokFvRGR29OKiikgek18cJIe7M8roZrG7GTJmcK4shmkdfacx+7xgXNaEj2Hs4U
	EbaVLIbxs9euqw9oop3y4N+hWwo5jC09lYbrtro9NJPckqiialJeXj71Dn3FrBIuudeKy7S+kfs
	fAXBIte9IqeAxOq6CAoYDWaesRmMaHV3Hp38BycBnIf8oVl5Q4bB0OUqtC4qUJ0ZzJ6
X-Google-Smtp-Source: AGHT+IE6s5+nnJQCZ8j52PwmLU2wroCxhQ+GNqezbfGCdc1AFnfy7IZR/4BPaH25AIHdNGIBng/oGw==
X-Received: by 2002:a05:6402:2814:b0:5d0:b7c5:c3fc with SMTP id 4fb4d7f45d1cf-5d81dd5e8e2mr48514016a12.3.1735833072142;
        Thu, 02 Jan 2025 07:51:12 -0800 (PST)
Received: from [192.168.42.201] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80675a3ebsm18435262a12.7.2025.01.02.07.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2025 07:51:11 -0800 (PST)
Message-ID: <c9d83a4a-8942-49dd-aaf8-962770f820f7@gmail.com>
Date: Thu, 2 Jan 2025 15:52:06 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 03/20] net: generalise net_iov chunk owners
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
 <20241218003748.796939-4-dw@davidwei.uk> <20241220141436.65513ff7@kernel.org>
 <5d308d1b-4c9d-430e-b116-e669bd778b30@gmail.com>
 <20241220181709.3e48c266@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241220181709.3e48c266@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/21/24 02:17, Jakub Kicinski wrote:
> On Sat, 21 Dec 2024 00:50:37 +0000 Pavel Begunkov wrote:
>>> Is there a good reason why dma addr is not part of net_iov_area?
>>> net_iov_area is one chunk of continuous address space.
>>> Instead of looping over pages in io_zcrx_map_area we could map
>>> the whole thing in one go.
>>
>> It's not physically contiguous. The registration API takes
>> contig user addresses, but that's not a hard requirement
>> either.
> 
> Okay, I was thrown off by the base_virtual being in the common struct.
> But it appears you don't use that?

Right, but io_uring can make use of it, it just needs better types,
which is why I left it there to follow up later.
  
> AFAIR for devmem each area is physically contiguous if the region is
> not it gets split into areas.

Seems so, it's split into areas / chunk owners by following the
sg list layout.

-- 
Pavel Begunkov


