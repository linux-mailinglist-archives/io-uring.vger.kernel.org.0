Return-Path: <io-uring+bounces-3535-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 45CD89977BE
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 23:45:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F1D61F23EE4
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911F9192D7C;
	Wed,  9 Oct 2024 21:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bwUe+eoo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75AE1E32A4;
	Wed,  9 Oct 2024 21:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728510308; cv=none; b=boNBmQHYR/cVnXhI1VQoxxX+/Bb0UmRccawR48mkn+xhkNIRh0gLTqgCCpmC2StOKOdl0qAdCkpJUtD0PQfL/JwyHs9mc91sM6BG0bBtIitoZ23vRjv0qY66Li8Y2AMfZrnC6yaSCrbWvGiiRD4OJhIofDsnPHWjZ28SMK2aW0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728510308; c=relaxed/simple;
	bh=AFRL93ZlC+gmCSH3PrEnnvkfkbILUzYzxtUb1HC7v5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D4Us6MbP+lFGNIfhaJyRW8m2wwO6w9wSqrocqj6wYdCJJLoYUsKQ++/wBUzW8DrfR6Ea1zJSa0yEgb9fjkMWPshVTwpcerLlI6ET3MhVQTs4bCspOBlxTzgBcMOG8OXsGsdWXryxHXH0TDI6CDkxdpKnUkaEDYxcmCMmInPx0ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bwUe+eoo; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-42cb57f8b41so2770575e9.0;
        Wed, 09 Oct 2024 14:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728510305; x=1729115105; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B5uc8I1q8Mecsq6gXTDyyTsvEpj1SHV6KmDkEPC8bz0=;
        b=bwUe+eoodwSCp+2HCfkC8bvtE60lDp/9Yt9YnGvb1zs5zG849UsNkbkG9JOYWRjEHd
         BAzubPpYRSBS5RYPm27YBbhtrJRtMsHZlK4LNW5Y08cnBD+qJjp/qcVbdxKb5OikMf+P
         M5F6y28hy9q3oGJ11YUi4BgRGY5XBARe/unY6WSLOWUORN/LyDCsHrAd89s35WjMc6dy
         SiFXRgbA/OTOLV8PbApB5iwCZ69y2FbgNxLGGraeospk0LQGBxMajLVcDbkseeuE5Bq3
         60ZaV9AgGn1urNh5xmY52bDeiS0zjVkDgvqh3zCdl1q+7mGEnD6b8opi5TV5fL6Av7tF
         72zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728510305; x=1729115105;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B5uc8I1q8Mecsq6gXTDyyTsvEpj1SHV6KmDkEPC8bz0=;
        b=ZHrIO0UPgsXF8n9tcfKYA7L+0pAIk5k+zwus0gOb+r40DCH7EkQq2fjoju8OLitNYF
         ZtLVnaxVz5uzerLHXwhlh6hQyghw0+22QoB0gf6gJHPaAFHDlicNnM2VWcy+eYyRi7k9
         Ghkmig9x13KOROLreUEhByUJUAm9C9CZjV4pqHALlUh+rvvl6h1rEN43W1IiDD7Wf0bR
         3N4rp4K3r+T24B75qP94C/dBMiHaPNla1jrkFs34ac1rnMZzt6Dxw752SYcEcHQgVWeX
         KJDi9jvWFetWkvUs2Jcrc7HkMZqi4unZXlxnP6lK2oaQuYYWyDssER8dEBQQk1RLYS6S
         IvFg==
X-Forwarded-Encrypted: i=1; AJvYcCW7l2twSLTRdMfz8MVv0AkspBRjw0lhLw7n6nzFwxh6B3hpE7Vw5pqkjBMOPGdas3RUPk7Rld4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7BvDXzA3laKodPz8mZnBYNen0o1y1sHTixzaGw4iNNzBP2ul4
	q9l+1vh4URbGLbOoVmmOlqKIXlNhw6fz3kInsi+7vYlwE8gq+YlVq4zXrA==
X-Google-Smtp-Source: AGHT+IFcKxTKnzY3E1Yh+YR4ALTzkPqaUnCWtr9oIRFoR5s8MngKn8tO5sZHtBQovhQ0l/bdx++3jw==
X-Received: by 2002:a05:600c:1f07:b0:42c:b995:20db with SMTP id 5b1f17b1804b1-430ccf04332mr43684315e9.5.1728510304729;
        Wed, 09 Oct 2024 14:45:04 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-430ccf51834sm31092775e9.26.2024.10.09.14.45.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 14:45:04 -0700 (PDT)
Message-ID: <c16651d1-5ab3-4233-841b-7a9681f80b0c@gmail.com>
Date: Wed, 9 Oct 2024 22:45:39 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 05/15] net: prepare for non devmem TCP memory providers
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-6-dw@davidwei.uk>
 <CAHS8izOqNBpoOTXPU9bJJAs9L2QRmEg_tva3sM2HgiyWd=ME0g@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izOqNBpoOTXPU9bJJAs9L2QRmEg_tva3sM2HgiyWd=ME0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/9/24 21:56, Mina Almasry wrote:
> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> There is a good bunch of places in generic paths assuming that the only
>> page pool memory provider is devmem TCP. As we want to reuse the net_iov
>> and provider infrastructure, we need to patch it up and explicitly check
>> the provider type when we branch into devmem TCP code.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   net/core/devmem.c         |  4 ++--
>>   net/core/page_pool_user.c | 15 +++++++++------
>>   net/ipv4/tcp.c            |  6 ++++++
>>   3 files changed, 17 insertions(+), 8 deletions(-)
>>
>> diff --git a/net/core/devmem.c b/net/core/devmem.c
>> index 83d13eb441b6..b0733cf42505 100644
>> --- a/net/core/devmem.c
>> +++ b/net/core/devmem.c
>> @@ -314,10 +314,10 @@ void dev_dmabuf_uninstall(struct net_device *dev)
>>          unsigned int i;
>>
>>          for (i = 0; i < dev->real_num_rx_queues; i++) {
>> -               binding = dev->_rx[i].mp_params.mp_priv;
>> -               if (!binding)
>> +               if (dev->_rx[i].mp_params.mp_ops != &dmabuf_devmem_ops)
>>                          continue;
>>
> 
> Sorry if I missed it (and please ignore me if I did), but
> dmabuf_devmem_ops are maybe not defined yet?

You exported it in devmem.h

> I'm also wondering how to find all the annyoing places where we need
> to check this. Looks like maybe a grep for net_devmem_dmabuf_binding
> is the way to go? I need to check whether these are all the places we
> need the check but so far looks fine.

I whac-a-mole'd them the best I can following recent devmem TCP
changes. Would be great if you take a look and might remember
some more places to check. And thanks for the review!

-- 
Pavel Begunkov

