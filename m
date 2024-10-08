Return-Path: <io-uring+bounces-3470-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A066995499
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 18:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 617C328267F
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 16:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0562F1E0DBF;
	Tue,  8 Oct 2024 16:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bGfbdkFQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B46C1EA73;
	Tue,  8 Oct 2024 16:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728405512; cv=none; b=Q7XLnxI5K6edlxiG6JaCPhp3OEsrBtLFiCW8pPgVJdM3nEZiNSzuP98R1XxvJ+JwoawYeEk1brSF/WFP27i6jxD7MlkLpnZrgOj3LiWIyg6m9ybCXZpguIkpGuy0PZIOUO0RRZW/FWYkdyUAmXlCMeEFfWemLQeZCBsdNk8Yz58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728405512; c=relaxed/simple;
	bh=APiEZvSQ4+74Mpl2ZriW5Q0ddg+dm9Lx96hQVKYHiyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=buCF43gzRfn6zScu5fhaarrC6lR5QreDNY/JhCeBKWzzSN9FF/rIovJbCRz05cXsXltEAQwSTQE6J66QduW7YAJ+JmtwLZkrcBdt2zar9xiP1KA9Nmdi7W7LVAALCAPxUKTd2913+MITl2m3dmCfyAfCGR4uLgqB2tavOSu63gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bGfbdkFQ; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53997328633so7794399e87.3;
        Tue, 08 Oct 2024 09:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728405509; x=1729010309; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=etnZixNFm1ZgckVO36UeCfgwjCkfr82ej68XX+uqH54=;
        b=bGfbdkFQhAKL/VKRRL2pMhZ7byZpQamrHiCbFYuM79tLwsKJOzmCIzxAnLV4l6WXhg
         +8k8La+/mAbURXHkwIrvDf5HnMdLD1qke85NSn2Qvyboeeobk6Z10BuHv8Gf86kTlluQ
         nUHP+NpIMXdpm7Rze7IDqAnf5hGK84MErzshZUzciYzt0aZlHb6PUXa3YZFmrGPkM7g4
         YJLF/L18BSX7Sc4MF6PKGz8e4JK5oVcDT0EZ79P6eDu+jZZVvwTBwwIQp8U5WCFoVH7k
         S6NkZrv+JbTuvap5DvYO48381rDUYLmqmMbH2uwiFom5J6A0LMQObCHo/nxCEI+XhniU
         Antw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728405509; x=1729010309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=etnZixNFm1ZgckVO36UeCfgwjCkfr82ej68XX+uqH54=;
        b=q304aO4YaYPC8FtLsEyHarODy8G+ckgOF7dyBv8sjIdnx79r/ELKpr9i3wpwjEy5xc
         4BS1/xyqVK1ndpvugb2Aiby+daQOL/lkrOwpYtgQytzyeZvEZ89D1DLUHbZehU0EuBpb
         izf+hcxFD4hW6XqI6bhmB8StU3a42TEOtdwNpdhNB/VqeTnJcNGwqWHDq7XhaX+8EqBf
         Y4ryGPI6uaz8dw+6WoyHjZiTsGhKDYboVcUNMMTryooL846PITpzG4Eh2/ofMQ+3qfOq
         ngdOUGslN+lc7gZnxtooPftR3hMh5HueOXdK/MxoATugFrRFmVjs+p/2kUKzmjUZ41Na
         HQkg==
X-Forwarded-Encrypted: i=1; AJvYcCUtCfk9XyVs3AalwPcYiBdZ7EEL9CVzM/BS7YzI3mUDd5OAkjdhJTuoD3sEq/lAUVwQbJIyRRo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxUbXYhraCX2knz3+KQE6UwufFSHjYN0SF0okOqlYcQfK0lsTn
	xjX81d2M2kBf6eSYXkWFNT8Cds9+7gd2/O0SDQdTp8CYvwEJfw+K
X-Google-Smtp-Source: AGHT+IHLn1svCzhEnQKtzvBkpo+TV8x7FbWOyFNdKrm/0JQkIN/YKTlDtLo0eYZMNUCLbfV4ccdMIg==
X-Received: by 2002:a05:6512:234a:b0:539:9fbb:4331 with SMTP id 2adb3069b0e04-539ab9e6f3cmr11835705e87.54.1728405509196;
        Tue, 08 Oct 2024 09:38:29 -0700 (PDT)
Received: from [192.168.42.249] ([148.252.145.180])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9953d48594sm300862666b.176.2024.10.08.09.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 09:38:28 -0700 (PDT)
Message-ID: <f50b9631-808c-4925-b77b-0f8cf4b4c8f1@gmail.com>
Date: Tue, 8 Oct 2024 17:39:05 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 13/15] io_uring/zcrx: add copy fallback
To: Stanislav Fomichev <stfomichev@gmail.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-14-dw@davidwei.uk> <ZwVWrAeKsVj5gbXY@mini-arch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZwVWrAeKsVj5gbXY@mini-arch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/24 16:58, Stanislav Fomichev wrote:
> On 10/07, David Wei wrote:
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> There are scenarios in which the zerocopy path might get a normal
>> in-kernel buffer, it could be a mis-steered packet or simply the linear
>> part of an skb. Another use case is to allow the driver to allocate
>> kernel pages when it's out of zc buffers, which makes it more resilient
>> to spikes in load and allow the user to choose the balance between the
>> amount of memory provided and performance.
> 
> Tangential: should there be some clear way for the users to discover that
> (some counter of some entry on cq about copy fallback)?
> 
> Or the expectation is that somebody will run bpftrace to diagnose
> (supposedly) poor ZC performance when it falls back to copy?

We had some notification for testing before, but that's left out
of the series to follow up patches to keep it simple. We can post
a special CQE to notify the user about that from time to time, which
should be just fine as it's a slow path.

-- 
Pavel Begunkov

