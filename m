Return-Path: <io-uring+bounces-5393-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C44BF9EA752
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 05:49:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 838F3288BA3
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8BFF168BE;
	Tue, 10 Dec 2024 04:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TsfFXL4n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B2579FD;
	Tue, 10 Dec 2024 04:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806192; cv=none; b=Sdf510ReYEXjwvDBbjE+WgnnFxlpaIO4JQ6qM6e9Zj7QlOuCdiqGszcMUcW3K+L574diUU9/rpsSfHN9pVlqv+voR/e9sKDHBdNcABRSP7X0B0pSSe1E2JwtjBbfx7nUepps+CxYXMQgsZjARC21qKkqrNAcbyIXBtyqgB+xCQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806192; c=relaxed/simple;
	bh=6nEWeQAeyMiZD24G516Y/lc+ymSXSnZHEG/uO2/zZeg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WnOTgA/qGMIfOpZERsJXXHYiJG48Faf3vcIVdBr+YzM6CMqSNOgp/w8ikOX7sOehKKX3AId8xoDAT0DCgKjEzq4tIOzIUqAd7iXT0RjwrKSbGXyRhq+92Va7zUFdtg45FCinvA3X45jbn4muvof9RJar+J836uxVfVgymQkopTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TsfFXL4n; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3863494591bso1349412f8f.1;
        Mon, 09 Dec 2024 20:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733806189; x=1734410989; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hu+E1d6FVD8TmkXkZ+JdeZuo4py52+CscSEktFlyu6Q=;
        b=TsfFXL4nNHQG5uzIT2Lr92HQRbujciOjmT50jRO6BsXCKTOWg7efJNMSlwLWqtSDyV
         qIlBbQS1Z8KUdhPaRfAoX6f8cfthHfCyiZELDFYF//n2gEciinjlO6vnAwvsNMLswV3f
         UD6aTr+kXV3rsuZSeV42Nb9mYxsZ3VaSOJIubj4DWQhbkU3JZp1ZGozaVfCsWbpRMCs1
         AyE9mMHq2+rPUcuUa8zptUbosd7c2YrRGEMGdMF+TWwW/lj2kE3zYhin61xe68C3gioW
         AYWxy8OWCrAVukFqUB0C4FyMEsEkLhzhrqCDZ/3Q9r6MudBMfq6isHDeIIhVVUe0pnNJ
         sk8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733806189; x=1734410989;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hu+E1d6FVD8TmkXkZ+JdeZuo4py52+CscSEktFlyu6Q=;
        b=O70oPQn1dxNA5tKv9tgbDZcr4g7rHhUGR4ABXBKZVtIpq25YVKcpIRGnMPI2wjrZyC
         0t/17ggXehjV7r9faPateDBNsnlMyVQ/YBEc5dg2yrXnFnJgvclCzoBfLnSWT0mIm3zX
         +DgQRcpE2SxUqsy/2C8koBYpaTxWMNcVJME+3m/AAPopVhN3m8RLmyKUTlgaSg9UMOtW
         mU72vw/SqzUE8OG0FOwFUiYo5WekMnUMO+IaaiBnLDJlD/u4v+M34nc9DuY06OPojvPW
         nmozxYDI3Dr0gG1ydkacQur2Ag1sxsirYdoS1uEjdjYURZvZJ8eTaoztWxiqC+YV09pz
         W8oQ==
X-Forwarded-Encrypted: i=1; AJvYcCUq733kbS3nebB+zE2CjPiA375fN5AocCk6PkjJxln7copXDyqZKfMXALc2Va8QYz4flD8t2hU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaUlF3bvxoJTv7tzOTbmQFZIGAOCMyrWReDyh6iQ3ZluXcnuFy
	5UHfXliDqAL/4DYZ6yTKCORTnfD1OoG+8Glpk/Lp1L3ICyKqOuUm
X-Gm-Gg: ASbGncsOIQc9ZQPrPDVGALn5xzwC0dnBauV8PH3+LzH3mbZIh0+aCVMZCoPTvALsqom
	aszPKQc3hCZwFnfdM96xXjdyJ6WS2Y6ImaDXbXqVmYGjOhOEcjcbG78fEmfHnY2erq1j5Zygy07
	8kXozJE0hSk2RfmB4rVz3axIomKkhh9jkeR2ymQN07wVY6F+CP1CFz71LxV6LLTFHj2LmijWgNk
	kHvHHG0eZnML1QkMx0OSr1hV9N6FNG/BLdGy5vFefSiV7IAwinNDkl8btkoD/k=
X-Google-Smtp-Source: AGHT+IFIw2w0JFuGvd1xfKCVx4eU3Kt9sjdDpvZP4uintKlNPZOnwH7y58Pn+4B/jZwUa0qMRBN3RA==
X-Received: by 2002:a05:6000:4604:b0:385:e17a:ce6f with SMTP id ffacd0b85a97d-386453dbd0cmr2525862f8f.24.1733806189176;
        Mon, 09 Dec 2024 20:49:49 -0800 (PST)
Received: from [192.168.42.90] ([85.255.235.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3861ecf3cd1sm14715389f8f.11.2024.12.09.20.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 20:49:48 -0800 (PST)
Message-ID: <3572bf15-333c-4db2-a714-edef2ce09f26@gmail.com>
Date: Tue, 10 Dec 2024 04:50:40 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 11/17] io_uring/zcrx: implement zerocopy
 receive pp memory provider
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-12-dw@davidwei.uk>
 <20241209200156.3aaa5e24@kernel.org>
 <aa20a0fd-75fb-4859-bd0e-74d0098daae8@gmail.com>
Content-Language: en-US
In-Reply-To: <aa20a0fd-75fb-4859-bd0e-74d0098daae8@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/10/24 04:45, Pavel Begunkov wrote:
> On 12/10/24 04:01, Jakub Kicinski wrote:
>> On Wed,  4 Dec 2024 09:21:50 -0800 David Wei wrote:
>>> Then, either the buffer is dropped and returns back to the page pool
>>> into the ->freelist via io_pp_zc_release_netmem, in which case the page
>>> pool will match hold_cnt for us with ->pages_state_release_cnt. Or more
>>> likely the buffer will go through the network/protocol stacks and end up
>>> in the corresponding socket's receive queue. From there the user can get
>>> it via an new io_uring request implemented in following patches. As
>>> mentioned above, before giving a buffer to the user we bump the refcount
>>> by IO_ZC_RX_UREF.
>>>
>>> Once the user is done with the buffer processing, it must return it back
>>> via the refill queue, from where our ->alloc_netmems implementation can
>>> grab it, check references, put IO_ZC_RX_UREF, and recycle the buffer if
>>> there are no more users left. As we place such buffers right back into
>>> the page pools fast cache and they didn't go through the normal pp
>>> release path, they are still considered "allocated" and no pp hold_cnt
>>> is required. For the same reason we dma sync buffers for the device
>>> in io_zc_add_pp_cache().
>>
>> Can you say more about the IO_ZC_RX_UREF bias? net_iov is not the page
>> struct, we can add more fields. In fact we have 8B of padding in it
>> that can be allocated without growing the struct. So why play with
> 
> I guess we can, though it's growing it for everyone not just
> io_uring considering how indexing works, i.e. no embedding into
> a larger struct.
> 
>> biases? You can add a 32b atomic counter for how many refs have been
>> handed out to the user.
> 
> This set does it in a stupid way, but the bias allows to coalesce
> operations with it into a single atomic. Regardless, it can be
> placed separately, though we still need a good way to optimise
> counting. Take a look at my reply with questions in the v7 thread,
> I outlined what can work quite well in terms of performance but
> needs a clear api for that from net/

FWIW, I tried it and placed user refs into a separate array.
Without optimisations it'll be additional atomics + cache
bouncing, which is not great, but if we can somehow reuse the
frag ref as in replies to v7, that might work even better than
with the bias. Devmem might reuse that as well.

-- 
Pavel Begunkov


