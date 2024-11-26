Return-Path: <io-uring+bounces-5057-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61CFE9D9A66
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 16:26:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6CA616576C
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 15:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 640761D61A1;
	Tue, 26 Nov 2024 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RmpqcV/9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4A71D47DC;
	Tue, 26 Nov 2024 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732634762; cv=none; b=VGsxSq9+rmRTQSVRZnSLac8jrS1cpa6JVvUtwGVCc5yhvYh9i2WYNX2sMuhW2YwDiit4KdQUnp4xHk3J71p4SLAdgcMwurhM6MFgMyjbXa1wuTtdjZnzp23BiTbVqI6Tnezrhw6QeHXk9wdSLd3u/pModj+OysVcRTHS7CTm4Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732634762; c=relaxed/simple;
	bh=75qY2RlPICpYt+qpGsSQ2PTwM6sFL9hl/+SmNj1wTXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cyHB5xmBx9HIhxu+qdspxWN6EOoZawRlKtElqG8OM6sUq7BhFjwjrnidkn4F08fi+ESJTIFGi2VgdYNuyYviODhgsWfXkPk+3uHL8olKs+XnU/ztlasyCeigdkLcNLTAMCrlLh76zt8ZcGVpWrHyTsIhOx39IkcqDqGvqbDA4Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RmpqcV/9; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a9a0ef5179dso818130766b.1;
        Tue, 26 Nov 2024 07:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732634759; x=1733239559; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j7p42/YIlccA+0/0TWeEQofMRxicEop0Giua8rEzfi4=;
        b=RmpqcV/9lFJvp681DjbMolTNaJdErryLr2uAHZfRma0yzAnnk7wAwIF+Y0OYhkYPMK
         QS/fGNhkT++av5l5KRaaE435gX7QVDX8Aji7fxsL1lNhREbs27Xo8VjUld0cuacUFPgP
         2WAsUZlwyy44baDu9b6fcFjmMPlvhs7E5LsMhZBax9jDoyNHkUbH/LFLu1w83VU72JCz
         Y9KOBi5FPYpa+89w79VrMk1XYuntlj3/ybtGDJH05Hzw0VuccTi77AqaFjtZrKISlrRT
         Ue3xEWJu0Z2SDNP4cuVd2+sdoCadYmW2PpXDulESPtGemQp1Xq/67PAqurEtm6LkHSx0
         D4Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732634759; x=1733239559;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j7p42/YIlccA+0/0TWeEQofMRxicEop0Giua8rEzfi4=;
        b=etPi3spd0ZKdzV0HSXYlYv8mCFPpODBvXBb+L1eq+itOOL4JhP78sa7axwuoRRvscz
         O4630cnYAXXuEKHwU0sQe24H+CGhlDLoLs5NizDAbBPZElpoLnc9HZKPGKXVbfMi4/pA
         Hwb5l3UjlMY1fTotJgqmOKNjeSifKJhT7Ni6ImK+j+2aD5O35E/WNXubNRmeluRaFRab
         NGoGFPpGIktUVcOkYyPA55pTqjY8+SsZv/bGB7LN1GFyTuJ/tTm4dntRE7rnMAlJn69W
         GAewX7sPboqgT3AiBoi5mDIZHBblxL8uvbuBx2BwhzXoy4EJR6GakH6P5Yhyx7Yssnq8
         5HLw==
X-Forwarded-Encrypted: i=1; AJvYcCVs0uvjOfyg5/Z8CwGy99EtGRePo/ZxzqNoblZf++yK6VR+2A2CSrf8FNm04sTQ5hEgvDZ2Rngoag==@vger.kernel.org, AJvYcCW6TkVxzNGavErdrnBtqOvrPek7gfyVKS+I0a48AbxF3fqMbCP2WwFgCYzxH1DxPwcRRmroJwgY@vger.kernel.org
X-Gm-Message-State: AOJu0YyOcLoHyKoPv76YsHo72NPjz5pDLyCtBkCW9oM3icetGvoWw/lT
	vrwaA6eTj4ASuZkRSVrN14MRz9Th1At3iBM7LP4FximFv83wHQH8
X-Gm-Gg: ASbGncv9Jyfd6o7DLvvpQVCqRrNpf1S4ZlBryYFPUA3uy3d+LJO6XWBsYCyJBJIvvvL
	L7EA0evbM8Wpv4jrd7UXhV9g+d9ooWy5YBSlhfcOO0u58+HvOZim+qkWLa0bQbbZwVNfc8ypsbc
	9rF0INWiDbD6k5X7Foks/Uz5UU8Dop4VQbp52r79Fti1VymNnw3gHtV1d2bn+8g4ET+79Ek7rMn
	Q0Dass5yEBBpbxBFc4a0joeMz7vivDEJyboPNYV9q3UW+t4Th2yH3oxiS6C
X-Google-Smtp-Source: AGHT+IF1hl9Vor9A8CgFjDoq9ZySNHePMq79OdoiLBgMI4XJFtnGmiMTDzc52jbC9izaXAejYb6yTA==
X-Received: by 2002:a17:906:3155:b0:a9a:230b:fb5e with SMTP id a640c23a62f3a-aa509966471mr1418230366b.4.1732634758942;
        Tue, 26 Nov 2024 07:25:58 -0800 (PST)
Received: from [192.168.42.58] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b2efbf1sm604120066b.44.2024.11.26.07.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2024 07:25:58 -0800 (PST)
Message-ID: <6e687570-c7b7-4c22-a601-d7ea6d620afe@gmail.com>
Date: Tue, 26 Nov 2024 15:26:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-12-dw@davidwei.uk>
 <CAHS8izNbNCAmecRDCL_rRjMU0Spnqo_BY5pyG1EhF2rZFx+y0A@mail.gmail.com>
 <af9a249a-1577-40fd-b1ba-be3737e86b18@gmail.com>
 <CAHS8izPEmbepTYsjjsxX_Dt-0Lz1HviuCyPM857-0q4GPdn4Rg@mail.gmail.com>
 <9ed60db4-234c-4565-93d6-4dac6b4e4e15@davidwei.uk>
 <CAHS8izND0V4LbTYrk2bZNkSuDDvm2gejAB07f=JYtCBKvSXROQ@mail.gmail.com>
 <20241115151428.6f1e1aba@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241115151428.6f1e1aba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/24 23:14, Jakub Kicinski wrote:
> On Thu, 14 Nov 2024 12:56:14 -0800 Mina Almasry wrote:
>> But I've been bringing this up a lot in the past (and offering
>> alternatives that don't introduce this overloading) and I think this
>> conversation has run its course. I'm unsure about this approach and
>> this could use another pair of eyes. Jakub, sorry to bother you but
>> you probably are the one that reviewed the whole net_iov stuff most
>> closely. Any chance you would take a look and provide direction here?
>> Maybe my concern is overblown...
> 
> Sorry I haven't read this code very closely (still!?) really hoping
> for next version to come during the merge window when time is more
> abundant :S
> 
>  From scanning the quoted context I gather you're asking about using
> the elevated ->pp_ref_count for user-owned pages? If yes - I also
> find that part.. borderline incorrect. The page pool stats will show
> these pages as allocated which normally means held by the driver or
> the stack. Pages given to the user should effectively leave the pool.

It can't just drop all net_iov refs here, otherwise the buffer might
be returned back to page pool and reused while the user still reading
the data. We can't even be smart in the release callback as it might
never get there and be reallocated purely via alloc.cache. And either
way, tunneling all buffers into ->release_netmem would be horrible
for performance, and it'd probably even need a check in
page_pool_recycle_in_cache().

Fixing it for devmem TCP (which also holds a net_iov ref while it's
given to user, so we're not unique here) sounds even harder as
they're stashed in a socket xarray page pool knows nothing about,
so it might need some extra counting on top?

This set has a problem with page_pool_alloc_frag*() helpers, so
we'd either need to explicitly chip away some bits from ->pp_ref_count
or move user counting out of net_iov and double the cost of one
of the main sources of overhead, and then being very inventive
optimising it in the future, but that won't solve the "should
leave the pool" problem.

If it's just stats printing, it should be quite easy to fix
for the current set, ala some kind of "mask out bits responsible
for user refs". And I don't immediately have an idea of how to
address it for devmem TCP.

Also note, that if sth happens with io_uring or such, those
"user" refs are going to be dropped by the kernel off a page
pool callback, so it's not about leaking buffers.

> So I'm guessing this is some optimization.
> Same for patch 8.

This one will need some more explanation, otherwise it'd be a guess
game. What is incorrect? The overall approach or some implementation
aspect? It's also worth to note that it's a private queue, stopping
the napi attached to it shouldn't interfere with other queues and
users in the system, that's it assuming steering configured right.

> But let me not get sucked into this before we wrap up the net-next PR..

-- 
Pavel Begunkov

