Return-Path: <io-uring+bounces-5384-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A9649EA6D9
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 111B01677C9
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 03:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768521D7E4E;
	Tue, 10 Dec 2024 03:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OKfiaiSW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB40669D2B;
	Tue, 10 Dec 2024 03:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733803032; cv=none; b=EVjY6+xj+t2uXJdh8pD3Y+zjgJJcW2WdB9AielPd3IeX2g/DKBwJdU5mMjMN9xy0HydvZrxJPTkbrGUyYl+HbuD2t/AHqAj5EyI6TQH4YUxPDXWBNs3tQ3lj4aCvBw+ffnPTv79060eBcFWroWeOG1aM8vTQ3dFvBNGC62pFUcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733803032; c=relaxed/simple;
	bh=XwFBiJI/B3ofjqxjcxluggbRnrUYiTYfeGuHvB0RxcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BfSmIEN7xi/Wkx3bz3JG7hKXuDHAyys3fAjK9sMdFQKvfrVUhmCagW7iTHD0Li3vTRyyGfU+8csQzQuAFYihOlqgszJx/KimFh3GRq3pdRWpqJs8MW3913hK/oBC5V7A+Ymp6rtmQiDdTcfLcLpz/GEv+AvB3Fi9bO8hR0zpcJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OKfiaiSW; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-434b3e32e9dso55621375e9.2;
        Mon, 09 Dec 2024 19:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733803029; x=1734407829; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0s4rgSC2froeQwhPxmRPNJU5fYcMStlnDojvCGwA680=;
        b=OKfiaiSWXMJoyaM7mAP7nZ3qqKzbVhLLlImxKVszgcsD1uFh/tmUJuBtlxGEsrbAEl
         V1JgU345XdVbi4Ede6ma/cWs8+V5johsSXdYx67+BA/J+LEVMFahL9gUkVHsCSPVW1vA
         lkhBIvDGtytqPUoAr45l0s8ng/JdSqOfNKel5POqL7fFxDQeBQ4c+tKeJpL5qvi9MBSp
         dQkxNYrUSP11UFHzlvFa182reWeHtJck90VaUrahArs+xrjMhEsgMELkHrCnArxoen72
         3poROGzu30CUu3tYBIplTsYUqAzEsaaevYefI/m8PKtsV7Ef4smbbhpiTU+iAXlcqZaN
         y/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733803029; x=1734407829;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0s4rgSC2froeQwhPxmRPNJU5fYcMStlnDojvCGwA680=;
        b=jTf8giWcRCnSG2JQOwEGbOtcJ6ixdH2fHRlXhsp9S5JEFsJdYkuScA03R/jEOq7grx
         8umoUukrpbgaN+HKRY2tinFiOOnXD2AQCu03fWmz+RL4wfludhm2cmqkR2jY/53jp8N6
         yco2uqhOMbaeD0XaVF1NvFw/RImgWjyXjXYqjo025aa2G2ify1CMwk4R/+V10OBqdVzz
         aiXYZNL3dDMxOYIMCm6+KEwbTNNwZSeNYRBVc5+xvGqrdfVOAenIpmxzMB0DxHQ3Hl3H
         27hV78uek28NZXmI+BN1PzBlBiK5fCQu6hEJfOZz6z7puivn2s5WKkhOfXQN3xgzj3DI
         2AVA==
X-Forwarded-Encrypted: i=1; AJvYcCX0os/YPEyJdbd2/cdehJwx3BHvsHLmwoZhP/AVESTL4xY9PQpxI+0lfmdo8yZiUQWikjpdX0o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK5q/h+nvpU+rUMFl+ZCT8xBx5fwnjLZi0LZeR/VbL1aZCIfUi
	jPN5n+WWUl5qINU3Kx0MO31R+930IyQUlgTefoWewLSi/JWBkFbU
X-Gm-Gg: ASbGncu64lW43qcGEvop4v47RCqUh4HkdavN4PHzBT7B4pHgq6k1mPmE3MtNqxpq5Ua
	TKoVefRDNEhv3hSONB5TPEJkU7+GJdYGAP386oLK5FFV/5nnr/RIgt+lbz2cQx+oe9/Pg+VSWFW
	6DCJOCFoeM7phaO2fz7A9vCpLYlki3kCG+0e1RugDMcDxsHVj8aseYHZI3W2WBbL7dt8Az6H9RS
	EO3vLfIQqX7ZrnHtzlyUC2IlitHN+HubN0zvOAnv5vDr2TEE8DzMY7GKPxjkAA=
X-Google-Smtp-Source: AGHT+IE/xV5SRe/9GNmH+L0PsgPpn8sDhKzcK/Hxfx+PhyeVMROf8sdh8fbCPm8fQttFkgqjZbf9zg==
X-Received: by 2002:a05:6000:481e:b0:385:f638:c68a with SMTP id ffacd0b85a97d-3862b387138mr10494521f8f.30.1733803028702;
        Mon, 09 Dec 2024 19:57:08 -0800 (PST)
Received: from [192.168.42.90] ([85.255.235.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-386219098d3sm15116981f8f.70.2024.12.09.19.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 19:57:08 -0800 (PST)
Message-ID: <9eea9b2f-3687-42e7-ade6-a99772390f98@gmail.com>
Date: Tue, 10 Dec 2024 03:58:00 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 06/17] net: page pool: add helper creating
 area from pages
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-7-dw@davidwei.uk>
 <20241209192959.42425232@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241209192959.42425232@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/10/24 03:29, Jakub Kicinski wrote:
> On Wed,  4 Dec 2024 09:21:45 -0800 David Wei wrote:
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Add a helper that takes an array of pages and initialises passed in
>> memory provider's area with them, where each net_iov takes one page.
>> It's also responsible for setting up dma mappings.
>>
>> We keep it in page_pool.c not to leak netmem details to outside
>> providers like io_uring, which don't have access to netmem_priv.h
>> and other private helpers.
> 
> User space will likely give us hugepages. Feels a bit wasteful to map
> and manage them 4k at a time. But okay, we can optimize this later.

I killed the api and moved bits of it out of net/. If multiple pools
are expected, dma mapping and pp assigning need to happen at different
points in time, and having such api doesn't make sense.

-- 
Pavel Begunkov


