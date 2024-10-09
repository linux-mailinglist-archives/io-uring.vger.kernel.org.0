Return-Path: <io-uring+bounces-3516-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE33F99756A
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:07:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F2B5283786
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 19:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63A071E1A0F;
	Wed,  9 Oct 2024 19:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1TUDAJcn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008971E132A
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 19:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500808; cv=none; b=s1zfinWY6Qqct5S0DEYzIbsdwtDGdJIDpdgiivXFrWvLDFFk8IHTKp96IUN2AeHgWCwn453BGt9Lsw5FTs6YBgq72WJug/O8GD3ifoKnooe3TRtADwZI84GqQLge+F/VxQJNRL4GxR2SM3oSPUQgZ+k9OFDGdmIsHkT/RiyzhBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500808; c=relaxed/simple;
	bh=TWPHmTteV+8CLu95Czs+Wen8d48/1qX18PTbo5/IOrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DOz/J3FwAMSi6RL9T+IN/X5H+lMa56Ze3FpDKprfqgbfh9TmSj/q6vv1bY5Tghfb9ThMniBkIM5UtpyhU8cg+0mnVEwmVFvxXPPpEi/22q2qYCmCyOHSlxznZLF5o0xSAKKeXQP77WhvCwlTzl6gvGJKIVZHCkS/6Pa3wv3lc4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1TUDAJcn; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8323b555a6aso6862139f.3
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 12:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728500806; x=1729105606; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NZ+1TU6Hn18Yr6C5PDKDDm0DzxzRtkTb3oFfJhlrSv4=;
        b=1TUDAJcnlRFF+5UC1S8X9zuFUQERxXc2k2z9WkwuexYrGZ+AOAsLntELOssbqdusFF
         qGxwyhBgXM/ZjqM+1/83gr1Vl+EUpJwgZT6ChT7ByjEbUvKienEunjEkiVztGNJi8U2M
         aGf35vKq43HxCa6IP6Me0beL/Osh2J+Xxl3VafAsMbmh2luVIMN7II35npDu7prO5Rt6
         Rk7AqxHM/Fnj/wU2iW/OEdBPhVBfDaP26yvkWjWkzPRd2BV2z/0ytpiYeudSC1IEK5Ue
         BgXJiTg4fPUElT/jLXNS2S03Zx7HV6dI6Iuq+ybQcGxGSTg1xagA4Lt6JODG+D6fJpb8
         fcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728500806; x=1729105606;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NZ+1TU6Hn18Yr6C5PDKDDm0DzxzRtkTb3oFfJhlrSv4=;
        b=fXAZfm9zKd/mxIoLPp7/UqEdw5P+K1R3DdjYmNIXgDAuKPeIIQpRFzbhPbmBhX2Ol7
         yoAgk1+mrAT63fjQlIGZv/HbnmuMrY9KdijJBgIMPmMKLPda49CA77Y/szYYbD0OHKlY
         ZMnJ1xAJURCjs/XHKMh7t77xign9dZmeVQHuzBVbLnqMtjQpgED8q13LzI941IDgGoD7
         ApJBqm87tnelSbbXoZ/ywlqA2/BhTCiA7naXDZgt/DrdbbwKWlffIWpnpkj9ysSgbSwU
         ZFULol4wYUuNozTdtmKX4//zZp/Pv0yUDeOOrlvUsbzUKE8/h/ikc9vCz1sHX7SJOS/W
         4Rfw==
X-Forwarded-Encrypted: i=1; AJvYcCXHnVC0W0EstfS0klk5Ire1jb1JtL8fGEtuxV+3UGWqn6YzUdAoPuoecVF5mhhbn0+7B/oslQFFyg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3UVcHLHzDDB6Xr+Z3q+BIxIFhQWxKTFh9xWs+Wxx64wZWR/Zq
	C/a9ZdNdFnc5xgiux0gSX0joftE/Q4Zn6zSSc8mOiK6H8ysaVPnExXTll3ZFJak=
X-Google-Smtp-Source: AGHT+IEQmNtioOg9OQotq14FazK/wzqtlwK17ewKys4oogWi3XMGD2y5zpO7tXpwP/h+Wk3HjdLuow==
X-Received: by 2002:a05:6602:27c2:b0:82c:ed57:ebd9 with SMTP id ca18e2360f4ac-8353d4f9c9amr496855939f.10.1728500806051;
        Wed, 09 Oct 2024 12:06:46 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db81d551b9sm1658548173.34.2024.10.09.12.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 12:06:45 -0700 (PDT)
Message-ID: <8ead850d-3374-43e0-a7b0-c9cd031596ed@kernel.dk>
Date: Wed, 9 Oct 2024 13:06:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 10/15] io_uring/zcrx: add io_zcrx_area
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-11-dw@davidwei.uk>
 <f3b7b9c3-3cde-423f-b8a7-28cead30204e@kernel.dk>
 <22c7cad9-72d1-46da-9f69-31b7837b9de8@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <22c7cad9-72d1-46da-9f69-31b7837b9de8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 1:05 PM, Pavel Begunkov wrote:
> On 10/9/24 19:02, Jens Axboe wrote:
>> On 10/7/24 4:15 PM, David Wei wrote:
> ...
>>> +struct io_zcrx_area {
>>> +    struct net_iov_area    nia;
>>> +    struct io_zcrx_ifq    *ifq;
>>> +
>>> +    u16            area_id;
>>> +    struct page        **pages;
>>> +
>>> +    /* freelist */
>>> +    spinlock_t        freelist_lock ____cacheline_aligned_in_smp;
>>> +    u32            free_count;
>>> +    u32            *freelist;
>>> +};
>>
>> I'm wondering if this really needs an aligned lock? Since it's only a
>> single structure, probably not a big deal. But unless there's evidence
>> to the contrary, might not be a bad idea to just kill that.
> 
> napi and IORING_OP_RECV_ZC can run on different CPUs, I wouldn't
> want the fields before the lock being contended by the lock
> because of cache line sharing, would especially hurt until it's
> warmed up well. Not really profiled, but not like we need to
> care about space here.

Right, as mentioned it's just a single struct, so doesn't matter that
much. I guess my testing all ran with same cpu for napi + rx, so would
not have seen it regardless. We can keep it as-is.

-- 
Jens Axboe

