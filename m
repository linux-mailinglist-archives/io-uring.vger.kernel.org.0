Return-Path: <io-uring+bounces-5350-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F69E9E9D12
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 18:28:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2B441883F68
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C528154BFC;
	Mon,  9 Dec 2024 17:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVqOsbVD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA101547E9;
	Mon,  9 Dec 2024 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733765283; cv=none; b=V8Oo9lreD+XZQRsox7kXSJfoPtJn8dlpqFwCZ0HkPauZuCP5Lsfd1w4l7TM5gDEzDXZJQCnHOs3cHLpX7l6jeNIs5euWZfXWl6i47bsppXs23cqdqF0TlZ+FLpnfzJ6A1yayRGV2wG5O47ybKLAA4BiAQ18vtxnWNweyDb+LfIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733765283; c=relaxed/simple;
	bh=rQ+gIg4OnL1XhGumZ32Dc1LUBuYPJkBT3ameSxwhfvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tcsxWJ8XM5hm76mOmWk9gDhb2y66NPCj+1jivkPppxFHe88pPqn1jga4m6jGWYiioU0MHOBcMwEMNIwa/rIEpBm6CrEqn7V4yjVAHaHmEFJ6d8GSp0zgjLYNLzSHdQAakPVL4ZDUg461Dz89Dc8EfqrnwWfIyQ9jBDA9xUmHKcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BVqOsbVD; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d3ecae02beso2237150a12.0;
        Mon, 09 Dec 2024 09:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733765280; x=1734370080; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NlgSqwnkTaretACwWz3wRXEVa4cAS47esD0IgePYQOU=;
        b=BVqOsbVDnqeDqJYNyU2JnUnUViLlfi+/JXZfJlvuaoqZediGE3X6UaKZ3aCHoWySm9
         avkWPVCwqbOCoLa7WDZ2vxPzyXuNuKD8E2swbJ2TterXiVB+wp0mWgwH5wHpf2MzxiNL
         DqyAn5n/B6+kj77Fchmmp0IGH3ElvYI3CzyGr188VP33zdw+IY7W7CSnjA7qaXItIO9D
         0GDJogJBjUvHvuQgIDAZG6vgDUrdYIxU/kr3DwD4dH9JoK1zhdlDbrgbxV2fJQgkc+dn
         SlNEQZx9qCRIw0XMsKKfJzsuDiGq6RnN665kVPyWLTSvjLxaIJGpfP36UcCUtdMh9yw3
         Ci2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733765280; x=1734370080;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NlgSqwnkTaretACwWz3wRXEVa4cAS47esD0IgePYQOU=;
        b=kMC/uckNXL4ylui8pFp124nP1iqOIX5tea0EA/m9f9pKqRKarv8hzrlCW+qyR5AJB0
         +nlHRl8dRo/OxhFWALXN6tQu2K6DROd7fGt2j9VDgMF3Wm4yjlflWHc2ws4QexG/hasK
         4BSZzDu68AD6Gs+6bvuibHTMEt0VFZseS9kfGPFho36JhMs1tSMXjRvJy65obOmM+q/D
         5Ybpw9kwiSqGWkGfny2FzxDY+79ujkwrBjNcW6hdfR8R/UR7EjdtH6Gr7tHsqBCmZLS/
         mgfip4z2hYg92bFVJSlRWpLPEOxJBxLzFuCytn6qP8v/VAGIM2A18ldjXt4H/80K1pX7
         ATCg==
X-Forwarded-Encrypted: i=1; AJvYcCWKM1FFuRXY3Eu3vQSkE7Rfr03dKcp9H2woxRCHLq2nwuXZreaCdAItKnY2wEYbiIsVsCo61Sw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWfk1o7bOnFeKAvIpS6a2qC3nBnfK1BeulmUOOjNz0XXa2+UHL
	wL0MutoxOd5WBXU9RRmM7OXvcwVJQypg9jyMCfyPqrF+92u4cBLd
X-Gm-Gg: ASbGnct6arA7jPyIpPRveNHndesP9JDKBPg9Y44bLx/JMnWK8rQyOB69NB3Ee5FvrL7
	GIRfdEHNQqOO6WZl6zACs+YAaAP4g3OxmvrxQdYU7QtPTZ6Y8JbDInvowJBBrieYwPvlYqZ88Sr
	x0ZXIZDZ2qvAd5Baax61Bn9zClj7SWtMiGxtP2Tyu21Q9ue3t1D5Dp+9gXQgLi1G1dgO2313Mwh
	HhgMljIRAAYGwEZ+S3ITpm+SHRChbU/FvuLxu4snANi9bYexst3R1MhD/Tk
X-Google-Smtp-Source: AGHT+IEm1qVfYh8vfMjIA+U3hFJr5O60oJE47O22pw35Wp87fIV7yEGbU/zhZRZQkG8xKdT0nmvGzg==
X-Received: by 2002:a05:6402:321a:b0:5d2:7456:9812 with SMTP id 4fb4d7f45d1cf-5d3be7f0584mr12958963a12.22.1733765279489;
        Mon, 09 Dec 2024 09:27:59 -0800 (PST)
Received: from [192.168.42.75] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d149a48ab4sm6388519a12.27.2024.12.09.09.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 09:27:59 -0800 (PST)
Message-ID: <6fdcd8b4-00d8-4ad7-a9bb-7b208ea54e9d@gmail.com>
Date: Mon, 9 Dec 2024 17:28:54 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 07/17] net: page_pool: introduce
 page_pool_mp_return_in_cache
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-8-dw@davidwei.uk>
 <CAHS8izMYOtU-QoCggE+7h9V+Rtxf-m2rBMHHdJtMxSQku-b1Xw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMYOtU-QoCggE+7h9V+Rtxf-m2rBMHHdJtMxSQku-b1Xw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/9/24 17:15, Mina Almasry wrote:
> On Wed, Dec 4, 2024 at 9:22 AM David Wei <dw@davidwei.uk> wrote:
...
>> +/*
>> + * page_pool_mp_return_in_cache() - return a netmem to the allocation cache.
>> + * @pool:      pool from which pages were allocated
>> + * @netmem:    netmem to return
>> + *
>> + * Return already allocated and accounted netmem to the page pool's allocation
>> + * cache. The function doesn't provide synchronisation and must only be called
>> + * from the napi context.
>> + */
>> +void page_pool_mp_return_in_cache(struct page_pool *pool, netmem_ref netmem)
>> +{
>> +       if (WARN_ON_ONCE(pool->alloc.count >= PP_ALLOC_CACHE_REFILL))
>> +               return;
>> +
> 
> Really the caller needs to check this, and if the caller is checking
> it then this additional check is unnecessarily defensive I would say.
> But not really a big deal. I think I gave this feedback on the
> previous iteration.

I think I already killed it. Nevertheless, that's true, the caller
has to check it, which is why it's a warning.

> Reviewed-by: Mina Almasry <almasrymina@google.com>

-- 
Pavel Begunkov


