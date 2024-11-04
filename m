Return-Path: <io-uring+bounces-4444-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D129BC05B
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 22:53:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AFD51C21E3A
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 21:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67FC41D54C0;
	Mon,  4 Nov 2024 21:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZP4aPUaf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43361925B0;
	Mon,  4 Nov 2024 21:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730757194; cv=none; b=g21zAp4BzT7rD0pqOfJow6u/GCE8pfm2TwYJLRwb/ImzcR3bPJoecFWNBysWokNSk1kHEstxtxW4CK2WTNc/YS1xCwhZTAmD4k8g0MTqp4zRAfyySkEkIivzflCnrmbqkhQ0mKIPg4RDJEFikHuidLWtxSbto4gsMyMZRHNlVus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730757194; c=relaxed/simple;
	bh=zpIg2pQNsbuAnJL6oQqe4c4LcnxxW5W87e5WWs43z6c=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=KwLNA4kUuGHyHbkNttAdcmehTGPMasFZe/3dQw/a95X/J+OIXsyqkMrtQiKiKfk4jXIXXblAL8iSgwo8/YMO20wNEVEIEWbdsVb1ZCzddtDfypKlvgDxd3FbgECCnvNoYMbQIfaYzafZvDSPm1YfF6wMMxf8OTjhQOg5iXV0/38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZP4aPUaf; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a7aa086b077so604077066b.0;
        Mon, 04 Nov 2024 13:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730757191; x=1731361991; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=soUXAJoKTID6twtUMLFXg5Ys9zkVQe+u0MKGLNcWV3U=;
        b=ZP4aPUafCDbdQCMc2MuVtypfuNN8UaI3QKSSLHHLlQFqRuE9Ul5MPWZNPRRH4DM8A2
         p6Y4Zf8YgFTwJUoq6fTLts8Ul0SzU1AjbS1MooqUjNKn+g+TUYx7Uf5WVv74FEJvD0eB
         4Epr7gR/4kPC8wFqaS5zMice+vmOpQgTMBlPSVD40gi9I2eTfDtPeKNj5z9nXYjg3IeV
         SPYxIRkZVcthiPewqihhY0R4jIA5NLCkQRliUPBDK8L457QVeF5YZkEXbiwBlZ1t5+JY
         1xcXVmAqfa7CZggVqnWKAf+F7lz/FtMnRaAbpEXD86vksua4swc4nPLS+8MDDV5xRUu5
         xNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730757191; x=1731361991;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=soUXAJoKTID6twtUMLFXg5Ys9zkVQe+u0MKGLNcWV3U=;
        b=rFN8Pv+Rr8OOBgBRR/h96Wzjn5bqYV3uaO4w8sX9zJhRq7MdYaliUR21SDjGwhPW1f
         wq9sNlB6G11V/iglr3tanXmtOg6AyPGTdiPzTfuYk7qiPa5TjBbqKwuf4jRjSD+IksE9
         NIdAzIdaAyfgGLsF8TFZueDH1dvJdWFIArhlUTlM4dE0qOtk8akRUSLV0lmHE3xHfnzT
         2SmHxCKIhUtHBuehQX1RRlAvw/WCQIrfgiw498GnzQxVPoX9B0XAd5EV7dHuP+Fb60hO
         WQXQfwkjrB9USO5uYUcI0HYcqxhvGoVArZmovWtrwEHIazbMYLcgOD7ud5HvtX/mC++2
         oNOw==
X-Forwarded-Encrypted: i=1; AJvYcCUnGkY156dwkgCKncMCKkaFfSnYgRTCc6rdyrJzh7eZZuW13QP3umI9u5rtGjj3X5YOTmmU61zp@vger.kernel.org, AJvYcCWnxOKJCe+Cqb7C0QwSBN0wyx7O5WfWIBHlZMzuTkOyyFBrzwyWauselwaNGbl+SFc5VTVJa2cS1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUQZV2WV3zhZf16nLoQzpIRncKLeSltq6FQbKqiHSh2OcLqfZ0
	v/xcz8JwWlX8n1b5YDywBTJ21kxqb57poCV7bKLaNhg9IYzc1OJQ
X-Google-Smtp-Source: AGHT+IFyoSSPBiGp8n/J5skMJX4yyS5l8A8F6WM50XVMWO9ql2JYyZR8eR/whBFQM8OlkpFsOq/xsQ==
X-Received: by 2002:a17:907:728d:b0:a9a:cc8a:b281 with SMTP id a640c23a62f3a-a9e3a573cfbmr1918600266b.3.1730757190600;
        Mon, 04 Nov 2024 13:53:10 -0800 (PST)
Received: from [192.168.42.103] ([148.252.145.116])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb16d66aesm35496766b.55.2024.11.04.13.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 13:53:10 -0800 (PST)
Message-ID: <66032cb0-c68a-475d-85b3-3d6cda2c733d@gmail.com>
Date: Mon, 4 Nov 2024 21:53:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
From: Pavel Begunkov <asml.silence@gmail.com>
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-12-dw@davidwei.uk>
 <CAHS8izNbNCAmecRDCL_rRjMU0Spnqo_BY5pyG1EhF2rZFx+y0A@mail.gmail.com>
 <af9a249a-1577-40fd-b1ba-be3737e86b18@gmail.com>
 <CAHS8izPEmbepTYsjjsxX_Dt-0Lz1HviuCyPM857-0q4GPdn4Rg@mail.gmail.com>
 <8837c96b-f764-4ba7-ae9b-40299f8c266c@gmail.com>
Content-Language: en-US
In-Reply-To: <8837c96b-f764-4ba7-ae9b-40299f8c266c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/4/24 21:14, Pavel Begunkov wrote:
> On 11/4/24 19:54, Mina Almasry wrote:
>> On Fri, Nov 1, 2024 at 2:09 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>> If you've tested the generic code paths to be performance deficient
>> and your recycling is indeed better, you could improve the page_pool
>> to pull netmems when it needs to like you're doing here, but in a
>> generic way that applies to the page allocator and other providers.
>> Not a one-off implementation that only applies to your provider.
> 
> If I read it right, you're saying you need to improve devmem TCP
> instead of doing an io_uring API, just like you indirectly declared
> in the very beginning a couple of weeks ago. Again, if you're
> against having an io_uring user API in general or against some
> particular aspects of the API, then please state it clearly. If not,
> I can leave the idea to you to entertain once it's merged.

On top of it, that wouldn't make sense for the normal page pool path,
it already pushes pages via a ring (ptr_ring + caches) from one
context to another. The difference is that buffers with these zero
copy interfaces make an extra stop in the user space, from where
we directly push into the page pool, just like you can directly push
via ptr_ring when you're already in the kernel, even though it
requires more logic to handle untrusted user space.

It only makes for zero copy providers, and I do remember you was
suggested to take the same approach, I think it was Stan, but since
it didn't materialise I assume it's not of interest to devmem TCP.

-- 
Pavel Begunkov

