Return-Path: <io-uring+bounces-8442-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF2B8AE2017
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 18:29:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53E303A7FE7
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 16:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7797023817C;
	Fri, 20 Jun 2025 16:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fyDrxvzi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33BD1A76DE;
	Fri, 20 Jun 2025 16:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750436955; cv=none; b=Ts7Y98lSZ3hcOL7UdxpI8FIIJcEZhClSO59msiIW+fv6rBu0AJilffKlefrmI/u/7WAfeg9PXJyCHRFpYYp1R8BgzYFIgpS2Y4WgpraCIhBBUSYVvuSkTn2wZMXbXhHykUuVH7wBTntx4Tj3yOiP0Sb/8GMyaihB0Tl4yZpyTsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750436955; c=relaxed/simple;
	bh=FaEwLMxOxkNOS4mWb1NSNpJeZ1LJPSHVY6vmH3CROL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RnkPYkQYw5uv2sKRABu6YlcWUCjQK9HIiJJe0IUQpABpVwIVQOEOECFbFTpyMUHAmMOMAjjS47ry2Nobfww2JbOP/qrMlmCLFQ+9kvRVxRAKwY3NAZ+1UHDrshOxaKh8UDHwS4dFjs+nFj0VQeqdH8GwPuNNrM8/npD9mstJDvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fyDrxvzi; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6084dfb4cd5so6163499a12.0;
        Fri, 20 Jun 2025 09:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750436952; x=1751041752; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ORFyl44K+/tBNDdcw5/Tesv6FoPT5hM2jRTBnEfp7dg=;
        b=fyDrxvziUyVVwe2sHJTiAeZPgiKbQGmLVZR2oiHUjXOCqrFk6mHeqJtH9CFJShHa1a
         Qel0C4SsrV1YFReMWVWVtEdoO67E5E9SH+NSD2WWoefNvICNNmFN4G0IRQRZ3o7h0C8E
         99u0soGEosAHsXVDngixOhUb+bwJxTvKBTt8u03ZaEYAREsHusD6ufgMO7JQCwJaXAad
         eW/M3ZddNhfW/n4hDW1Mokhh1LbXfXBkU8w/EoJc3mwZYwcmQSUnFI9xY5PUpBCot+MN
         Y2pIr0cUxQbABLh2wZxyTNZy8KIneQ0ByEpKMTJ0nYi7yhSZywHuf6VQz0+HK3HVY1gG
         cacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750436952; x=1751041752;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ORFyl44K+/tBNDdcw5/Tesv6FoPT5hM2jRTBnEfp7dg=;
        b=CzGdNoLOIgE1DOGmicEOql851ACsJX95Be/E0G8rHuvvMAm2/+ekp3Bbnr93exencK
         I1t8llWtv2CTv7N6oRyTdTSkkNvL3vJ7v3gKaUoAQX0HTyYKbn9Ukp3TGM5zF2zwVToC
         w5pDzGI+748MDsZt4QTwy5B3X+zgoEO091jLdAS9aSLcASYbF2LVlVizYFzkee/ycQP+
         si2g6vRSrCjg7wLVx9xRAm4B2bQ5wZ/SCm/+mFYDNFNeiOVNsBflaU9e7a4PNe5rkFxW
         lO+bkrfnkop9/ULZvrgnAVQQgK/JkM0Z4q36Yi/65JQLjot6zy/0qOGWW9R1iLuwYIil
         FjjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlc3g7NUpCm8O77+2MjY52jjVFX/BFkUIrPQx0uGQOCrlsHkRgJEce0Rw12gHxl/txaNURig0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMsgMEJa8xGyUlc9ADz20Iri8eH33h7o+IxLc0yt68MSivuzWs
	Ssdsql0c9UpKxCj1Ko1Fwn+rXfSaXM8kqXxvT8kTrpR771ctH8hinpmB
X-Gm-Gg: ASbGnct8PvaoTy5mdr5W6HPnzigX9D6w+5qPMB7upfXc4qmttJRbq6V4iuRLx3sDAXZ
	frHEcZ2D1E4lZpFKxDRzDvqFY7dRegjbqeB5mwgUn2NSlOO/0ygVx/dtsin14vfXZHXw+tKRKeK
	Y3eebCb2ABQYygRbv+UCoyuw2Wa+nJBoJ0el1G/wYOSGHPy4brPQAHgV0+O/XYgI6hL8/K+eaLG
	Rgd5UVPpNPeTzgVtEjU7uA+b6ix5+kp1l/xB89kJW8kX+Xe13YP5mJVirPLTuHazjPDAnI05Yod
	wlyXWqY+ixSOpg5LK3JT4B2ANry/PMr2TZ+Y/czoFKnaU5SMxXmV6QMyLks7h1v3eml1Vup2deh
	+IUA=
X-Google-Smtp-Source: AGHT+IFuL/B95V3XAklPOSAks3Ad2FR+It/0d/aCJm9mcVI0h7GLYxL5G+STOpDquga5G9HhF2xJ8w==
X-Received: by 2002:a17:907:fd15:b0:ad8:91e4:a92b with SMTP id a640c23a62f3a-ae05b03900emr299933566b.30.1750436951809;
        Fri, 20 Jun 2025 09:29:11 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.237.0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae053e801c1sm190238766b.17.2025.06.20.09.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jun 2025 09:29:11 -0700 (PDT)
Message-ID: <adc06936-b8e0-4ae4-bcb9-578b38a0e789@gmail.com>
Date: Fri, 20 Jun 2025 17:30:35 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] io_uring cmd for tx timestamps
To: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>,
 netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <efd53c47-4be9-4a91-aef1-7f0cb8bae750@kernel.dk>
 <20250617152923.01c274a1@kernel.org>
 <520fa72f-1105-42f6-a16f-050873be8742@kernel.dk>
 <20250617154103.519b5b9d@kernel.org>
 <1fb789b2-2251-42ed-b3c2-4a5f31bca020@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1fb789b2-2251-42ed-b3c2-4a5f31bca020@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/20/25 15:31, Jens Axboe wrote:
> On 6/17/25 4:41 PM, Jakub Kicinski wrote:
>> On Tue, 17 Jun 2025 16:33:20 -0600 Jens Axboe wrote:
>>>>> Sounds like we're good to queue this up for 6.17?
>>>>
>>>> I think so. Can I apply patch 1 off v6.16-rc1 and merge it in to
>>>> net-next? Hash will be 2410251cde0bac9f6, you can pull that across.
>>>> LMK if that works.
>>>
>>> Can we put it in a separate branch and merge it into both? Otherwise
>>> my branch will get a bunch of unrelated commits, and pulling an
>>> unnamed sha is pretty iffy.
>>
>> Like this?
>>
>>   https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git timestamp-for-jens
> 
> Branch seems to be gone?

Anything against just taking the hash from net-next, turning into
a branch and then merging that? E.g.

https://github.com/isilence/linux.git io_uring-tx-timestamp-net-helpers

-- 
Pavel Begunkov


