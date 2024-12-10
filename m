Return-Path: <io-uring+bounces-5389-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F9E9EA712
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 05:10:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38094288A00
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA8822489F;
	Tue, 10 Dec 2024 04:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VB3Qcj3+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE48B13635E;
	Tue, 10 Dec 2024 04:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733803842; cv=none; b=AO3CLy7tbNdT29I+eW8tdXC6cICckV7xf7Y6CaWhnSMo9WLp49lzaAXkN83n81mX5JGjgS8USoWcvoWxVu+hR8hqRrznsRNXPEZh9lE77kiUmyZQB8QMWzlynLkFl1pCsMuBykO8mFEht4Qgk/rRzm9IaMlajoha5Ai83nNphtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733803842; c=relaxed/simple;
	bh=t/PmcYDnBMqBQKctltRFjQpiUYJsCmoRC4ECgxOEfHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EDS9RWZS3ArlrLK0ZT5FE+V21bAxhFmlQ/mQ2VgN9IHU1jURkbkIdBfvof7DzgPxWQDvCxSYW50hWeGQDwUj1Dg7xfXqrTxNs9gqpy1pMv6ABVjgT3Mzvv9K10VlUhAo4gBPCPkj4mU8i843qdAP+EpEUX4KjQ4KoMyMXti8W80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VB3Qcj3+; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-434b3e32e9dso55689665e9.2;
        Mon, 09 Dec 2024 20:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733803839; x=1734408639; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6GwwAvNkiVn22SGPZCFlNonL6ljUKJrRHzaRDKU+3zo=;
        b=VB3Qcj3+ccjEyXi1bkhUbTrXzeCl/OAmwXh2wgD8M0t9aj0m9mDmK7vgarRKCmXdjq
         keG6aN7y2oosTbwSsWC24s5WD/MrmF4Wyto9+Xz1D7RnQHvUSmkz2Wf3sJPLPl7r75B3
         xzoix+/dG03mWatKdPaKCTxRNSfnb6zuoCPxHoGAQfyTmwzPd1LQ1C7Y7+SPhBqz0FYX
         MW6cuZMxzduCjw+QR8WIeUSjKr92y3JYsysrj7PY+Dm51M3DPCLaq6Omb88TzKTzJ5qR
         YwQUjFGtFNuv9+gvjZp3zmlbIinDYXSqQuLRBiRxNy+oYiMDa9TSuS40UiJUsd59cXw8
         GGmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733803839; x=1734408639;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6GwwAvNkiVn22SGPZCFlNonL6ljUKJrRHzaRDKU+3zo=;
        b=B/wUwWc5zlKML/Ns/fFoSmQWRLqFAUbPaMhorMQ3BLxE2UawX8DO2BAWaCQA4qjq4Q
         o3y+0tGTws7pErIgAVQn09SHk48uQ6s5lC/goEwORYKTrEjnoxkSPDenLzlBDWrg9KSk
         7dx4NtZLeXCAARht/ofMHcuNLotgdNulYb/BS4KGd/Qz1MpvzY389aAKwW/5h4gMV9jZ
         ZLhmkEBG2F5ZfjZ3Zgp7z/ym8B67d54nImQ6fsQWm1th8ooWx3hkLbvOhYxokUPu6K5U
         oFLQ5KVCJbcrUnlMnG/r5+1NSNALTvuP8zCbNOdmWk1lvlSY6VuNLOaMJ1oaGq2YkwI/
         MfrA==
X-Forwarded-Encrypted: i=1; AJvYcCWC7qi0K6ruNZ971anM8wxq6o4/Zs5yT5AI9ujVqhhHHvlJJUBH1kulzPUOR/QcPTvmdyGEo+w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmFBgNSxKGTMuP9DRZ8FClD8L7qQmh9ayTyMeTbc5BGOB5h0tn
	pcGyuHVogW+cwLMmWgqMPiMppLP4RjjFQw3GW+hyLGGR1yFxsyC+
X-Gm-Gg: ASbGncvcqqc7J4AW+Ip2yChIVxJHI2vW0AURTZtLPlETl0HdmaXvgLiyQa+JiRv1Q24
	y9Hh5XOO+Dz/jwpq1RVocXqQR+RDRU75UTVKzssmQyljuQOtv3cQjC4jWgO2By05Rxhk7+rBfEe
	uR2SWu0uey3YTStUUUqUURWJVHsa/HVt4O3QVgQ7X6XwrsFOMb4yqQ08xdrTDcYpJ4Gu01ab33p
	vef0igacoz5dK4Gh6l84kaytSuIWDR8Dnp+2EZPPIMd5vz3kXsoSvtd3h2iRe8=
X-Google-Smtp-Source: AGHT+IFtODhIbJug8TyKcapcGw4+YyAnXd8yOc+w5ASrEk7FQ6i+CzfbIBl1t8Biki5GufuBt5Nhzw==
X-Received: by 2002:a05:6000:402c:b0:385:e1a8:e28e with SMTP id ffacd0b85a97d-3862b34477fmr11974206f8f.10.1733803839161;
        Mon, 09 Dec 2024 20:10:39 -0800 (PST)
Received: from [192.168.42.90] ([85.255.235.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3861f4a85f2sm14652517f8f.29.2024.12.09.20.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 20:10:38 -0800 (PST)
Message-ID: <601572a4-f5a8-4dec-a07d-0c035c4fbb79@gmail.com>
Date: Tue, 10 Dec 2024 04:11:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 08/17] net: add helper executing custom
 callback from napi
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-9-dw@davidwei.uk>
 <20241209194447.26eaffd5@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241209194447.26eaffd5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/10/24 03:44, Jakub Kicinski wrote:
> On Wed,  4 Dec 2024 09:21:47 -0800 David Wei wrote:
>> It's useful to have napi private bits and pieces like page pool's fast
>> allocating cache, so that the hot allocation path doesn't have to do any
>> additional synchronisation. In case of io_uring memory provider
>> introduced in following patches, we keep the consumer end of the
>> io_uring's refill queue private to napi as it's a hot path.
>>
>> However, from time to time we need to synchronise with the napi, for
>> example to add more user memory or allocate fallback buffers. Add a
>> helper function napi_execute that allows to run a custom callback from
>> under napi context so that it can access and modify napi protected
>> parts of io_uring. It works similar to busy polling and stops napi from
>> running in the meantime, so it's supposed to be a slow control path.
> 
> Let's leave this out, please. I seriously doubt this works reliably
> and the bar for adding complexity to NAPI is fairly high. A commit
> which doesn't even quote any perf numbers will certainly not clear it.

I reworked it and got rid of the patch, though I don't see why
performance here would matter. It's a very slow path if all
paths failed, batching inside wasn't done right on the io_uring
for simplicity, but that was certainly planned a follow up.

-- 
Pavel Begunkov


