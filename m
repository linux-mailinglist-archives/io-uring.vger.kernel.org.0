Return-Path: <io-uring+bounces-3469-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B1A99547D
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 18:33:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 790011F26C94
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 16:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E1A1E0DB5;
	Tue,  8 Oct 2024 16:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cp/BY/QH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCC976048;
	Tue,  8 Oct 2024 16:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728405229; cv=none; b=rCZRferkMV2NYpDQVeUxulas7SOE1VJ1u8p5rDEDjoFMDxV06SeJFXqACu7zhfL8UZiQMSKdnZtISrOtAXSa4eDzfUsaQ3SfF0WepvHvNKkvMtd2J9cnQ4xgjtvvzEIuDz84A8AyjpNLFcxL+ViOVg6XeJvfYZEqOiO4mdazWzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728405229; c=relaxed/simple;
	bh=HaCCKGVCspDPuWDenE/CxPmIHuHZibcsQH1P1AXxp+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HTYangUIUxJvyRkpwYMj8OCeDU9kFUUiK5IqheCyODN1akLG8hyICRLsjafjov4VDGZ0l7nXFilnNPPj3iG+fZaDCNYFjjtRPbRRPizeTmQKzJ01hzJJxoJg7RU2HDUx1kXpPYzpkEOWtK+LLrMg92HMQHdYQtgW9jJ28kNTIlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cp/BY/QH; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9943897c07so453709166b.3;
        Tue, 08 Oct 2024 09:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728405226; x=1729010026; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ciScLLQION6Ld0WM//antVVq9lYrBYBZHTjbYYGeVi0=;
        b=cp/BY/QHjzfnul1TuJuk7URDGxL4MqnJNLHaG2vjJZj0l5/bexEB8Eco/7YYcZ77mx
         93rZJpcJip6sEsuxTvYQL7rqz7TqdqsjV+8KO+EN74K0ywvpIzynbfRrjO/M3YH1Ux7I
         bKD8zGJ7+HpYEMk7/moAzwl3vEn5Ud/1BqWAxmCNf6ji9iBSSRiaiD+f8XkbtnysnHBC
         xGcP7oxZ2BqZmYDn6r3pnMlb3b5OP8YDLN/zP5dUtdrPN361t6WqHFcypTMgtp8XIXAk
         Jhf7p4B+6qIJIMRk0tlpLP5owKMMpVcNNMHcd7t2A/K62i098uuBEDxgMof50y6JdjMg
         T0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728405226; x=1729010026;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ciScLLQION6Ld0WM//antVVq9lYrBYBZHTjbYYGeVi0=;
        b=iI+WMFcLYlfD29dr+OS4XxPgvfDki/8ZxXvsjl2czmfcGmEyJGu7ZxcpJ/tj/Hrrvx
         OXjQVJXY91p54JT/Es5fGFYNsLnhtHpdwcvgivWGfP7Lz0P+wG46Ksr/qNFNUcQYSazq
         Ciw52Yk/M41GmGlnvrGIsaTFkTL2JTgFgWqk8kySw1v7Q1mQnAz9PbRQXFBkiEhrTBT+
         CUl+jkF20qCjbRdEVINvrzeVvp2xiQ2ebrrb3SvlwJu5g+C1v5KudcN9orzyYQSuQ3v+
         AKyXGkxU4BCnawUvIQJUXQYHUrczfFFlTQbeCcRNkk3i+ZgB4FyQwvr7pF4hlyWjqbNG
         kZlg==
X-Forwarded-Encrypted: i=1; AJvYcCXkIgGTvWDJJWgzwXwl4StjHXTlTOPCMghKpHmaQvxrpRYoqzzeSBJMg0jlN3Xjfqs4Wb5w6zM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZRJmMdHwH/y3SjoXTpIF9TjlgcchVAJp3lLdVHT6jc+ga9m3r
	U+gmFvGDunOkhdIPa3e62Gt0Twmpto6wq3wqzLMb47vcYOVyHbQz
X-Google-Smtp-Source: AGHT+IFqBvXN9X3gbbtjeb6cgCLKWRjmiczIGLm6hLNraxfX1gOChstOs+0hcyCBYvQzBSXwONxsjg==
X-Received: by 2002:a17:907:36c4:b0:a8d:1303:2283 with SMTP id a640c23a62f3a-a991bd7a123mr1716274266b.30.1728405225602;
        Tue, 08 Oct 2024 09:33:45 -0700 (PDT)
Received: from [192.168.42.249] ([148.252.145.180])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a994b0bd738sm371234766b.51.2024.10.08.09.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 09:33:45 -0700 (PDT)
Message-ID: <ade753dd-caab-4151-af30-39de9080f69b@gmail.com>
Date: Tue, 8 Oct 2024 17:34:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/15] net: generalise net_iov chunk owners
To: Stanislav Fomichev <stfomichev@gmail.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-4-dw@davidwei.uk> <ZwVT8AnAq_uERzvB@mini-arch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZwVT8AnAq_uERzvB@mini-arch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/24 16:46, Stanislav Fomichev wrote:
> On 10/07, David Wei wrote:
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Currently net_iov stores a pointer to struct dmabuf_genpool_chunk_owner,
>> which serves as a useful abstraction to share data and provide a
>> context. However, it's too devmem specific, and we want to reuse it for
>> other memory providers, and for that we need to decouple net_iov from
>> devmem. Make net_iov to point to a new base structure called
>> net_iov_area, which dmabuf_genpool_chunk_owner extends.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   include/net/netmem.h | 21 ++++++++++++++++++++-
>>   net/core/devmem.c    | 25 +++++++++++++------------
>>   net/core/devmem.h    | 25 +++++++++----------------
>>   3 files changed, 42 insertions(+), 29 deletions(-)
>>
>> diff --git a/include/net/netmem.h b/include/net/netmem.h
>> index 8a6e20be4b9d..3795ded30d2c 100644
>> --- a/include/net/netmem.h
>> +++ b/include/net/netmem.h
>> @@ -24,11 +24,20 @@ struct net_iov {
>>   	unsigned long __unused_padding;
>>   	unsigned long pp_magic;
>>   	struct page_pool *pp;
>> -	struct dmabuf_genpool_chunk_owner *owner;
>> +	struct net_iov_area *owner;
> 
> Any reason not to use dmabuf_genpool_chunk_owner as is (or rename it
> to net_iov_area to generalize) with the fields that you don't need
> set to 0/NULL? container_of makes everything harder to follow :-(

It can be that, but then io_uring would have a (null) pointer to
struct net_devmem_dmabuf_binding it knows nothing about and other
fields devmem might add in the future. Also, it reduces the
temptation for the common code to make assumptions about the origin
of the area / pp memory provider. IOW, I think it's cleaner
when separated like in this patch.

-- 
Pavel Begunkov

