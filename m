Return-Path: <io-uring+bounces-3534-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E1C7997794
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 23:34:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 282791F236FD
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 589181E260B;
	Wed,  9 Oct 2024 21:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SdIMn1+v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFCF1E2319;
	Wed,  9 Oct 2024 21:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728509652; cv=none; b=q7ZgNoDBw8uZfdrmGU0x68mmSrwHjo8NDSc28zD8bC5Xw4zLCYjUGzwY79lHGwiVc8OzcePHB0bSNkih+JaYLZRdRJCuFdyrMZomz1Fj3bZdhgGxwS6k9NBZXgYs6kQp3fedltzTH43oBx5UdgRYF7EDWT92TephmGyeZEP3HL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728509652; c=relaxed/simple;
	bh=lHfKgnCtm/CCHpxI9WFuei35vewby6gj7khdhc87O8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jaFDz1YcprO/0mDzlFAe1GIJtJWR2R8ClD+ptHDxn3t/4j5dvSfQGMiic4/g8fQu+c8OGDrJij5mX9X7hhk4c/cDjOMMzjZkH/8wdEM3LVZyR34aPdLgtpi6rhnOiKzH6QlbPpJQq74LrK9g1HuDqMnWQXrpqsLhevZOmvhwD3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SdIMn1+v; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a99388e3009so33234266b.3;
        Wed, 09 Oct 2024 14:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728509649; x=1729114449; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T+z46ZWj1YUnv5d1G/xe9Is0nKn9y9cGETjwYzve/YQ=;
        b=SdIMn1+vKXz3F/C6wzVtmzD7S9xKOs5MCJ1FVr26icktoio8XwASfxy3af+L8Pv16y
         uBibFI3uP8smoEMA6GdPR0xbHo461GcmAyQsY0R9L95deCKna20L0mXiBerLzqNegi17
         dIgymdvZnNpQbuepmABREVJkAJaEK2dpkp588sMOjyfRAAV/O8R2eeA+zWMPXdDdNOpI
         qlDa8pb25CAu68pTpR827zznlWFostBCg1IGELIvvKUy2rzn2j7Qdfjykh+lmBgTFCvI
         KwgaCgPg21ciBUp0EIKZT0Kx2VAfczIHUCQXnxsW5QUIYguLsdTcF/LkHLf5+WHnMCx6
         qsaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728509649; x=1729114449;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T+z46ZWj1YUnv5d1G/xe9Is0nKn9y9cGETjwYzve/YQ=;
        b=fAb1T1FU6VV06XTI1Q/42TFFA1b7onRpBk96yLgi4Prk7sk5WcDWmY22rivVMZLqPM
         608k6m7fdlYRypG/SBeQpDQMNFed2/KMWrLCZF7zMz6gC+H1ZyUwSx/96nvBoA+qlPPB
         IuoFCOwHohX3dpuChJIc7XJXycr6z2JYrG8u3qyaBeffDOjUU+zKnlgEDyupPPn+R194
         l5QauDx8ZGFVDGuJ4TYOhHIFXvLAqg9Dz8PBpoM5E3oFC5YVC8GAEG2iz3qArj0Kop70
         2D/drIWe2YlSrn/PG3o4+NGY9jGjbefz2NJ471YbUDkslzlP4p8FOlUF8GhJt00GKjbq
         Ll2g==
X-Forwarded-Encrypted: i=1; AJvYcCXJH1byvFy7NcV/d8891/aNZIcmDmqzprFyiv2i1YcXOTHidO0wEk3eDzEr6kCywpVntq8665E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUN18WCA6mqWUv/GP8mZ6rB1Xv+OkAqHnFPAdDhXQ41nvmQAn6
	eM5V3IrPl+P3l42nCybeNC13JjvimW4S5fdUKhq8NSure92ecS2J
X-Google-Smtp-Source: AGHT+IGWEDjkYTJf8+aIVyyykOxzdRRrinVbbIT3S5WYsZu1ZuogVFE58coK6jceTZONZ87anShLvA==
X-Received: by 2002:a17:907:1ca3:b0:a99:762f:b296 with SMTP id a640c23a62f3a-a998d331720mr336335466b.59.1728509648631;
        Wed, 09 Oct 2024 14:34:08 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.145.180])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9952bd2b24sm489933466b.163.2024.10.09.14.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 14:34:08 -0700 (PDT)
Message-ID: <6e14c383-6cbc-4eb5-9580-74fba17ec36e@gmail.com>
Date: Wed, 9 Oct 2024 22:34:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 07/15] net: page pool: add helper creating area from
 pages
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-8-dw@davidwei.uk>
 <CAHS8izPuRgGPz9Fg8NcsJzUaX5+8zSvT33XEp=LqdKMdm=KzbA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPuRgGPz9Fg8NcsJzUaX5+8zSvT33XEp=LqdKMdm=KzbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/9/24 22:11, Mina Almasry wrote:
> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Add a helper that takes an array of pages and initialises passed in
>> memory provider's area with them, where each net_iov takes one page.
>> It's also responsible for setting up dma mappings.
>>
>> We keep it in page_pool.c not to leak netmem details to outside
>> providers like io_uring, which don't have access to netmem_priv.h
>> and other private helpers.
>>
> 
> Initial feeling is that this belongs somewhere in the provider. The
> functions added here don't seem generically useful to the page pool to
> be honest.
> 
> The challenge seems to be netmem/net_iov dependencies. The only thing
> I see you're calling is net_iov_to_netmem() and friends. Are these the
> issue? I think these are in netmem.h actually. Consider including that
> in the provider implementation, if it makes sense to you.

io_uring would need bits from netmem_priv.h and page_pool_priv.h,
and Jakub was pushing hard for the devmem patches to hide all of it
under net/core/. It's a last week change, I believe Jakub doesn't
want any of those leaked outside, in which case net/ needs to
provide a helper.

-- 
Pavel Begunkov

