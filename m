Return-Path: <io-uring+bounces-3605-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD3BE99AB2D
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 20:45:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0307B1C21CED
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 18:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D921CF5FD;
	Fri, 11 Oct 2024 18:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="RRklVcYr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743A01C9EA4
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 18:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728672283; cv=none; b=X0AjKhbcirxxhMiN438o31kIqac1LR6JFTs/Doto+ws7G0mfZx2lc6/yznK5tkvBubMbK5nDzouDz7gdW8+w6V438DfMTzMVGwlx3D1ycAWCfF+RgwrpH40g3T/NVfqpwQ+cLDmT8TZltnD7UldwQEqouaCdXeiL/+ZtbTqOFbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728672283; c=relaxed/simple;
	bh=+CrjRFmuRBhakr4lGSUJwfVpywUbknE5IX8tnyZ1I64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=di6icxhGI6h7/lXLO9JA2hzoYWVph35tPHAhdNqn9t0SdD0mvk3Pz6G+kUyIQEnrTt2Jov21xCUwHo/cQO79ftI2WLWjKxOqzLzrV5NzIdRwvJlsFRj6XSJum6hpcvt0fcuNXcAeDroTv/jRbKOfr4VndPzhZSZOtFX5jzW7yHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=RRklVcYr; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20cb7088cbcso3110625ad.0
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 11:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728672280; x=1729277080; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JXJkaI14eGa0xZB9hgsghdQZjRzdnP97+WPOm8D2LtA=;
        b=RRklVcYrD4BoTsQIjyF2EHmH7gBCFUon8Q6mnu4kzrgQ+NoDj8hjvS/JTxr/HsGTDP
         optMz2hhGjZcuaq9pcJ64aa/nDbRbEKI9p2zUOoDuOgEZSQpJUPjUvXsKbIs1+QyXfBE
         CXbcK/o/zadmm8UmObeU1UyeRmHqGftjs4doPTsllx0ZJQZzVOkBm3G9Xr/0OChjIJAQ
         zVppii+X/T4tUoUBypfbfctToyGIlXlaxTNdy/wj6lqAMlQdraq1pMogwCl6zQRrmoLA
         xA7LmQtxzZI6EJrFgt5z7gYDwIjViXP6zOcREHdn6sEe3M76RxkaeHdUQqYDFuOiRhFx
         Abaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728672280; x=1729277080;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JXJkaI14eGa0xZB9hgsghdQZjRzdnP97+WPOm8D2LtA=;
        b=ThiMp7tLchr9IzVJQxq9IC4FnkwgljntXcKhM2h4BCFyAQH8jMYVz2Wqh0KT6OdETx
         lwL1ma5uN8gxF72aeFEXlmpxAIrrm9X+P4uJ6m/dUzY63l13BDLJfsIPVqYlL2LlPBS7
         MsPx5PA7F/liy0JP76mNNkWTihjlpMK/Ay1fQmkJTEp3ORpjujCOgrRC2kmMfLpK9txo
         OKpkkIU/K+XFBQYnhArK7LbvZSOn1a4pX/jvbF/HwBmP/2/4f9gwDh60XRYLGRCSr33m
         qmdDz4ZCiNNo7VmroJxG1xy80L3htVsZnFXkla4ZzJSK/7eh+U9yiL50O8lm4ZaJ2wsV
         ntEQ==
X-Gm-Message-State: AOJu0Ywu14t7nwwgnBug5F98xyZw1/awetlarxKMPPHExqtnXso+BQ/+
	TCGz3oXfGA6K4UujlFqcWWt/mcKYuFyzhi6OqSMddA9hgnWcWEFI9KPcgqrgNOo=
X-Google-Smtp-Source: AGHT+IESg0X/mbRRf8DMPNZmcIB4i+1z+3SJHm0Fz37PItVLeEBmfLD87NQcIQZeMDevsGSg2nDlEw==
X-Received: by 2002:a17:902:e801:b0:20c:9821:6997 with SMTP id d9443c01a7336-20ca142a39amr37682845ad.8.1728672279750;
        Fri, 11 Oct 2024 11:44:39 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::7:4e3c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c0e791esm26312445ad.132.2024.10.11.11.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 11:44:39 -0700 (PDT)
Message-ID: <b2aa16ac-a5fe-4bab-a047-8f38086f4d43@davidwei.uk>
Date: Fri, 11 Oct 2024 11:44:37 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/15] net: generalise net_iov chunk owners
Content-Language: en-GB
To: Stanislav Fomichev <stfomichev@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-4-dw@davidwei.uk> <ZwVT8AnAq_uERzvB@mini-arch>
 <ade753dd-caab-4151-af30-39de9080f69b@gmail.com> <ZwavJuVI-6d9ZSuh@mini-arch>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <ZwavJuVI-6d9ZSuh@mini-arch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-10-09 09:28, Stanislav Fomichev wrote:
> On 10/08, Pavel Begunkov wrote:
>> On 10/8/24 16:46, Stanislav Fomichev wrote:
>>> On 10/07, David Wei wrote:
>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>>
>>>> Currently net_iov stores a pointer to struct dmabuf_genpool_chunk_owner,
>>>> which serves as a useful abstraction to share data and provide a
>>>> context. However, it's too devmem specific, and we want to reuse it for
>>>> other memory providers, and for that we need to decouple net_iov from
>>>> devmem. Make net_iov to point to a new base structure called
>>>> net_iov_area, which dmabuf_genpool_chunk_owner extends.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>>> ---
>>>>   include/net/netmem.h | 21 ++++++++++++++++++++-
>>>>   net/core/devmem.c    | 25 +++++++++++++------------
>>>>   net/core/devmem.h    | 25 +++++++++----------------
>>>>   3 files changed, 42 insertions(+), 29 deletions(-)
>>>>
>>>> diff --git a/include/net/netmem.h b/include/net/netmem.h
>>>> index 8a6e20be4b9d..3795ded30d2c 100644
>>>> --- a/include/net/netmem.h
>>>> +++ b/include/net/netmem.h
>>>> @@ -24,11 +24,20 @@ struct net_iov {
>>>>   	unsigned long __unused_padding;
>>>>   	unsigned long pp_magic;
>>>>   	struct page_pool *pp;
>>>> -	struct dmabuf_genpool_chunk_owner *owner;
>>>> +	struct net_iov_area *owner;
>>>
>>> Any reason not to use dmabuf_genpool_chunk_owner as is (or rename it
>>> to net_iov_area to generalize) with the fields that you don't need
>>> set to 0/NULL? container_of makes everything harder to follow :-(
>>
>> It can be that, but then io_uring would have a (null) pointer to
>> struct net_devmem_dmabuf_binding it knows nothing about and other
>> fields devmem might add in the future. Also, it reduces the
>> temptation for the common code to make assumptions about the origin
>> of the area / pp memory provider. IOW, I think it's cleaner
>> when separated like in this patch.
> 
> Ack, let's see whether other people find any issues with this approach.
> For me, it makes the devmem parts harder to read, so my preference
> is on dropping this patch and keeping owner=null on your side.

I don't mind at this point which approach to take right now. I would
prefer keeping dmabuf_genpool_chunk_owner today even if it results in a
nullptr in io_uring's case. Once there are more memory providers in the
future, I think it'll be clearer what sort of abstraction we might need
here.

