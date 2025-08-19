Return-Path: <io-uring+bounces-9072-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B5E7B2C8C3
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 17:52:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEABD5E724E
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 15:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5AF62874F9;
	Tue, 19 Aug 2025 15:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="COLaVVU3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011B7286D56;
	Tue, 19 Aug 2025 15:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755618741; cv=none; b=Xh1mNkco/czTYfAfi3pLDG6xtFWFaM4QVVLdYxmOT3ey931iXCxtKh3Djjz51XxACyAyyRvJQb6auYRhJEtEbuHyfguEfaZvm1xo6ZRJq6d6l6KBJOpzEyipKLifP1P5IJMDnGoFnGcPrJLmV8GzXRsjxy/VsUH5Ljv17r+mmtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755618741; c=relaxed/simple;
	bh=FZ6ONxM10TBkVaTkIIHrp/g1pZCz0R9cPldnSU9JFKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BIrYBV6+7hr4CHFbfV5MfTlMr+0uxJ9Ufng2dgyZjyaWxd20aUBedSAmZeDGA9DiCOSjKBAhal7e9EibZGY9TTUXEP010SplHbbgKjR9ox4EhwTiZks4YwCecsItqD8kWy7GMM20YbOpp/h2H5b7bIEPLKMey2BObobvdjRfsKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=COLaVVU3; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a1b05a49cso40367475e9.1;
        Tue, 19 Aug 2025 08:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755618737; x=1756223537; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d5R0ks+OjiSdgzwM6SEj8dSRliEc/cMm/YDVCMdpdGY=;
        b=COLaVVU3vKQ2EogJhLB6HVER6EBtjdH/qYqgOqYzxlFh5au0FXc/YQyGucmmGalv8k
         7wb67AmJVuKAmJMbpqj3wUOdINhQyYPKPzt0nADn71rqAXBIuTg8IqCZvDzCDoX8OJ1/
         JvBoohVLFiYhe1rBhtmKaK4rq4MIzlN0/iacKXVDKx1nn/NVQTKZlyTF6use5zh4akkb
         d9vEIx39EKDRxI13PWjADrkIv3q0frGpoNdEcbCMiEDkKeOfzsrQjuxRl86v9KXbGchs
         TFjf3Nrte7H43Lkt6BQ+bg8vHHtscj64okQstXmoiN/XFJ+vtJGv8coe8MAFinXrPcjr
         nLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755618737; x=1756223537;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d5R0ks+OjiSdgzwM6SEj8dSRliEc/cMm/YDVCMdpdGY=;
        b=Ao64YSgGTuV75t2Tr5rB0g+eoyv6Ii2A48g+V4pOKmkm2hyXFA1oaTvBeZz/f0TlIZ
         +YarKOoNeVz+c/Mpg7CbYIQ+1tzW3dZrKivrq8+ZrcwPx9RLT1jzZJ8f2/wbbd5y6l6m
         1LYcKyVeUu8ACl5YGn7MluNpymWafXxEJE0lWk+1ATRWk9o7Ho+sMYAaT3PcTrBEm2UI
         q3JzMk9gYEwyF0cj3oUX+SEAHpGyuYaH9Hzu+wtz+dBGUhVmETk32/PVAjh8TUiU8WLG
         eUJDMbKvOIpQGvYUmyY633/jLUn58psctoVwNKW+dLlxgbZwkU/TbKhjbbEqv3ZiZpDd
         KEEw==
X-Forwarded-Encrypted: i=1; AJvYcCUgNaXL+ggzkV0ZhjSelrZWGEg7Uf0A6FLPN241Alhc5JDUnqb8EjdN6NOTH6SgILAp9TjZS3bUlA==@vger.kernel.org, AJvYcCWlKw0VW5Mcv8SGmyiRAj0XC4HnR6qoX0ao8CSGt8hLeeFAc6Lb8kfzurZwdwxDT98TwDs72oUwzSwDutXC@vger.kernel.org, AJvYcCX8954AJ+CpoM7D7MsGQnZ3mNas7+zzyqwh3ZHvzl54yPXqqV/1IO/na81NJ/ZiQqe6epEoBS0m@vger.kernel.org
X-Gm-Message-State: AOJu0YzRgY3cHw6TUKrrVfTzoYEtGdOdVlBR4Hh5CiAB+PgVn2SW+IIX
	srM1cInFq5lHFjpe5UBxsaMEr9qsKEixhgRYIF2GoXnMbcAXLnv+zuPX
X-Gm-Gg: ASbGncu4Nnq/2qWdaYLGjHZs64/Cf+F1prWOi8wZxPDWY1Vcsu/aw7TfBtFfTohrUqU
	ftNLvQP8dfW1du0/NmrauWu4dfFCPMmc+EqpOenpKkOkFiDFf7JuxSo4kl8alVL0vJu6zbfGFiy
	8LqR36VX7qzEpYxjO1YcoNX6dT2wmVbw2E7skABlSRJE/lk/z5RhyNEEgXYeDE6ozp+3rmT3+QY
	eN2nXhpvEWUvYy8C4RKRcBkdiCJ49ErsV4C9+TrbSDJjNgeFGNkBKDMQrJKEPTPsnLc5NAf6mS+
	8LThrGhrM5athhC0tV83dkvcwLAq2IuZl0d1UmTxEJW6mjRgPtyNgTlryMMFcsIhlPdJB/8BvgG
	BgsPb0Ax/m1m4kzTxsBHXmfO50SFnzA==
X-Google-Smtp-Source: AGHT+IGPmmE3RSNAnlIVLv4jGY44RvVhf3k/oor4sUQfnDTFX4U7+XH6OQm2UwvV1/rWv9MaJPvUbQ==
X-Received: by 2002:a05:600c:4f16:b0:43c:fcbc:9680 with SMTP id 5b1f17b1804b1-45b46792ed0mr10472305e9.25.1755618736880;
        Tue, 19 Aug 2025 08:52:16 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c78b410sm228816015e9.24.2025.08.19.08.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 08:52:16 -0700 (PDT)
Message-ID: <ea6fe300-7c38-4e78-99fb-e4569f341f4c@gmail.com>
Date: Tue, 19 Aug 2025 16:53:28 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 01/23] net: page_pool: sanitise allocation
 order
To: Mina Almasry <almasrymina@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>,
 Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org,
 davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <cover.1755499375.git.asml.silence@gmail.com>
 <9b6b42be0d7fb60b12203fe4f0f762e882f0d798.1755499376.git.asml.silence@gmail.com>
 <CAHS8izO76s61JY8SMwDar=76Ech0B_xprzc1KgSDEjaAvbdDfA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izO76s61JY8SMwDar=76Ech0B_xprzc1KgSDEjaAvbdDfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/19/25 00:33, Mina Almasry wrote:
> On Mon, Aug 18, 2025 at 6:56 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> We're going to give more control over rx buffer sizes to user space, and
>> since we can't always rely on driver validation, let's sanitise it in
>> page_pool_init() as well. Note that we only need to reject over
>> MAX_PAGE_ORDER allocations for normal page pools, as current memory
>> providers don't need to use the buddy allocator and must check the order
>> on init.
>>
>> Suggested-by: Stanislav Fomichev <stfomichev@gmail.com>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Reviewed-by: Mina Almasry <almasrymina@google.com>
> 
> I think I noticed an unrelated bug in this code and we need this fix?

Good catch

> 
> ```
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 343a6cac21e3..ba70569bd4b0 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -287,8 +287,10 @@ static int page_pool_init(struct page_pool *pool,
>          }
> 
>          if (pool->mp_ops) {
> -               if (!pool->dma_map || !pool->dma_sync)
> -                       return -EOPNOTSUPP;
> +               if (!pool->dma_map || !pool->dma_sync) {
> +                       err = -EOPNOTSUPP;
> +                       goto free_ptr_ring;
> +               }
> 
>                  if (WARN_ON(!is_kernel_rodata((unsigned long)pool->mp_ops))) {
>                          err = -EFAULT;
> ```


-- 
Pavel Begunkov


