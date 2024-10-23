Return-Path: <io-uring+bounces-3941-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F25B49ACD6C
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DB951F2478F
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 14:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A9CA1C760A;
	Wed, 23 Oct 2024 14:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PUU3mIP6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3701C75E6;
	Wed, 23 Oct 2024 14:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729694062; cv=none; b=awYwtEovgsy2YfC/ZZt+odpCxbgRHUiWmpF1CpUSH1QW/iPtTAmIBVbTUg+sXBLN/fcamT+rovY2gHo+CN5Dn1BFDmKyCqbVgbtCoFlGzIjYVN7HnpdhcLk7S6g3BxPKzg4QbcXxw636rebzT2bJHyJz0MXVPQF9q4IH71So4BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729694062; c=relaxed/simple;
	bh=845TFphQ2gJiHgmIyDRpM83se8Q0trST6dSfs+lNT8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lkYV8auk5Cb/2kIkEB7HhXmTxS8X/McSTLRYkHDJx1CwT+38QlLdMKCukUtZLWDkoVV1yQg7JhYyoZaaX1cFJuDjii+trIV4x8WuTV1kFHMjY1zuQ7PJei7xPviJc0qLY/GOMaowVi7VbDNPXx6OR/ZKnh/EMl8e79IiUFncZ48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PUU3mIP6; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a99cc265e0aso1025772866b.3;
        Wed, 23 Oct 2024 07:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729694058; x=1730298858; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q4kJampXEx3nv7rxbRRPQLyxusFtEFCb6+hV0uyGoRA=;
        b=PUU3mIP6tVJSy7V2TuYQEw5JcbJfhaQ0w1IxpUQxA/ibGIWO+4BS6vzFGI27+5bodr
         Mjux9iXOVSEDyl1QzumW3jhM3ferEYKzBPj9ogM/U7Gu8WzIU8HIjhR+X1hI61TPbbnI
         KagdoKQjI7LienNO2jXh8WvkqHb7E6pjvVZTDuGQ4oucWM3M1MSm7X5bgUlI/FBvz4LQ
         eLFMLYaayVMmRe+cVS2dXrqoRYSVyFMOYavbL0FAUEMfExrbPXH3FTIBztaYeLfpf7/M
         TZGujLwPzEVPfiu54WA3/4Dlqc8IitdOAbLXilIFDv3Lo/BLF5UUe03wcJ05oovMCj2G
         OcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729694058; x=1730298858;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4kJampXEx3nv7rxbRRPQLyxusFtEFCb6+hV0uyGoRA=;
        b=n/NbSm3TYAVOw7BEpKEFHhnP5TWr1yJzwe4W29CqRqQlb2EJ9BrbMtNONVByCzSE+E
         u8uR/7AdxYbs718RxiKPcLtVu2IEtbNbeq9q18sVE0RMep9SbdS36gOL9xc/08W/k6aO
         qIj+ZbrUGUUlAypmVgW8hvNPAVkPMpaCyR4/VOoXdTCQwM4VkMtlHOUv/TTnZ8L4f555
         MhSB8fMzojExm9j4K+PPx1rOG+SnWnzBbsuYlwOE48oc69QPPMXRRjSuqA6GaMZi1yGP
         +MkQ392EqxgEdUV7vfxn7ighYoGFMF2yumGXeJ4DYHhekaqDbzAA5CHEvhFROrVjDh8l
         KJbA==
X-Forwarded-Encrypted: i=1; AJvYcCVSmHuXiWjpIIs2qsEqMeIRAz5+Ir1bCG4xtjFvKVUBSurrA16TJBQNpgFTYFrOlthLKiyjbn/0C4q6jQ==@vger.kernel.org, AJvYcCXysfJAvLYtqtQAaGE0o1xkMLdPH0wJ/0vI8zEapTaAcml3bPyjTeOGsjsidtrlh+okLkPdjdno@vger.kernel.org
X-Gm-Message-State: AOJu0YxcxzLRYn9G0eMMelR8rsyAjMjWpIhmMAY6XcZaWI15n/ICp2Zq
	PkQWjIicFspvj/ldTBXiVnaOP++JIMn0ILrbE5xw+yYY5j0M7P3IRqrp6g==
X-Google-Smtp-Source: AGHT+IHpnzei1u28XJ/Cb4x4LM2CIq79av1YBmoRQwGIYPDEwnobftY+MUQkzpScEWtj5S2LMvBtDQ==
X-Received: by 2002:a17:907:960b:b0:a9a:e2b:1711 with SMTP id a640c23a62f3a-a9abf5288bdmr329808366b.0.1729694057334;
        Wed, 23 Oct 2024 07:34:17 -0700 (PDT)
Received: from [192.168.8.113] ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91573645sm479309066b.182.2024.10.23.07.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2024 07:34:17 -0700 (PDT)
Message-ID: <264c8f95-2a69-4d49-8af6-d035fa890ef1@gmail.com>
Date: Wed, 23 Oct 2024 15:34:53 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/15] net: generalise net_iov chunk owners
To: Christoph Hellwig <hch@infradead.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-3-dw@davidwei.uk> <ZxijxiqNGONin3IY@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZxijxiqNGONin3IY@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/24 08:20, Christoph Hellwig wrote:
> On Wed, Oct 16, 2024 at 11:52:39AM -0700, David Wei wrote:
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Currently net_iov stores a pointer to struct dmabuf_genpool_chunk_owner,
>> which serves as a useful abstraction to share data and provide a
>> context. However, it's too devmem specific, and we want to reuse it for
>> other memory providers, and for that we need to decouple net_iov from
>> devmem. Make net_iov to point to a new base structure called
>> net_iov_area, which dmabuf_genpool_chunk_owner extends.
> 
> We've been there before.  Instead of reinventing your own memory
> provider please enhance dmabufs for your use case.  We don't really
> need to build memory buffer abstraction over memory buffer abstraction.

It doesn't care much what kind of memory it is, nor it's important
for internals how it's imported, it's user addresses -> pages for
user convenience sake. All the net_iov setup code is in the page pool
core code. What it does, however, is implementing the user API, so
There is no relevance with dmabufs.

-- 
Pavel Begunkov

