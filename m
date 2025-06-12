Return-Path: <io-uring+bounces-8326-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 697D9AD7528
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 17:06:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 449CB188B97C
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 15:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6751271A71;
	Thu, 12 Jun 2025 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RbamuhLK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E15247DF9;
	Thu, 12 Jun 2025 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749740414; cv=none; b=Q+gjqAi8YhNhF9xBTh564IdTFgewFFRZ3J10oj8p4X3XgfMN6EXmMy9/VxuHiTXUhxMuLW7hhiUO/6hnVDvgOGUOzylIT25u3usvBLFm0cLB/KGwZZCKg6Y8N/viadPYf2FRE2lzNzrjN96e8G52qdQSaN/ysvIHqHW1yK7JJFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749740414; c=relaxed/simple;
	bh=5VlIKgbSy5GB6SxxQBqsifgY63O0Kw5GLOVhVQ5xTek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YO4e2mpyeU+7f5Zb0SIERSVwikKJg6CYorGCfHGpQFS5uPMDZkxnKxvipbBcUWF1Y+bRdHDE4hWAZLfLw9iigIC77X8tkJoafocrjjUJFcZ54gdPcGOTiaTD3wcWQDqcJEg9CCSNNueGum+kODSB+1bxkAE9s7e0FESkC4rk140=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RbamuhLK; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-450ce3a2dd5so9649645e9.3;
        Thu, 12 Jun 2025 08:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749740411; x=1750345211; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bX8rdRz60ZO5mcSPzYvYgSD/zrnwyciQ4eJbRltE4zQ=;
        b=RbamuhLKvhWQ1laIJAJ+2ft9iSW8KuU1LNrsG6bh0H1W1Oyw+jIx4359dkxHQSHhqq
         6OcXLoDMOcdc9bNkquZajBTkfXfORz0CSZrg99j9t0sktrDzC1lLCf9M0milw8i3UatZ
         I0wwhLube9ZEGH93D+2iT6zjQjNI/P/e/0aKNRhcoqNBDfgSvM47CmjaNOm1fXQqIK0a
         e+/PXrgBH5iXtzwdVXu3sL5fa6ShQQoS+Y2bIr+3e/wpfnAE+I72yMwbyy0I0W9dDCe1
         zGDFnpRIhGKJ+y1o64oh7PhwbVA4fu8d9Bzs/FutlJltylxTyg864YkUujjr/VmmOcHE
         OLtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749740411; x=1750345211;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bX8rdRz60ZO5mcSPzYvYgSD/zrnwyciQ4eJbRltE4zQ=;
        b=fQq/vXFHCMF4E78Wsa0evUoJErOB0wglrngR+U4uUu/mDQ61YsSfv+/D5ESOqRVcgc
         XX3gNaPCN8/ZfKCxVHnpdk0GgPqeHtCmbuKET/A46IuVpysSyLTH4/KHSp63817e+9Lt
         wIHiWRBKVTUgJ/5IlhbhL/Eqq63w4k94SSDStY22NxU/855Yr+jUMkUHXgtwQhQQlpvI
         8SoS4Tsm5nChF2Kl+dt4IJm9/tZsPJqhI37vQkhwVE5TwWHNK6CKvg6ZTII2OL1aW+ew
         FVc2W8NTD798vRXBO5d32WJWd7XPMeop+3/FJc2sLtxkcXxiBDhveQoM0WRdH2JnV674
         EeVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEvqTkx9fj0tSUQdDTR6d9HdvZrmk8mfdmdofbAFYeQ5+ZhYVEZlifQNrPrecbWFGfMIf3SWcRTA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxtM98Wo5TOVu5d2QVjYt9xhlDG6pANA8TQELkJg7RDKJt5240q
	R9VqoHdM44JYa/ywVjs3IN442DqN6pRJGzE0l9ImLZxKB84IWYcDAQA4
X-Gm-Gg: ASbGncvCYQblM7IiHYdP9GAept5Yo3dliBuWvzSv2JwZksbEhmAHa59RnBbPMYiD6gs
	krnn8YCD1fnx4zb/UAUgaGlAvqqTSRZM6NYWMl8SjZOipaZOOP2cc5tagvPuhmkxsiDVTuKrD8W
	U6D+W6xWYh32jNg57Mq3pOYZC3DTN2Bt9s/WK+bKeK+s1AAUzqVjyBjROzc1EKYAjmQeY76QN8E
	7Qk6hLd6JeeXDIepIYW4/MEdM0ZGAKdWX2PSSFR3L2+Ryc4VwdddQUKw8OMtsAtQm1qI3NDys6D
	4ZJumg6wBPly9xeAtBeK3EiUZ3o3A+3Z8gAxz28qPeU7vl/XzPjcOzzlH/yCQcfdaj3aXaow
X-Google-Smtp-Source: AGHT+IHsx46UnIsZwgZnn+Gsy+DhiVznUfB5EvHdnXgDgY/J2UalTaL+Y/ZMQNflfacVSN2aobTTNQ==
X-Received: by 2002:a05:600c:4e4a:b0:442:e9ec:4654 with SMTP id 5b1f17b1804b1-4532d2d0a9cmr32809925e9.8.1749740410885;
        Thu, 12 Jun 2025 08:00:10 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.140.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a56199b17esm2231537f8f.38.2025.06.12.08.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 08:00:10 -0700 (PDT)
Message-ID: <278de6eb-bed0-4c76-9330-78d297b3315b@gmail.com>
Date: Thu, 12 Jun 2025 16:01:33 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] io_uring/netcmd: add tx timestamping cmd support
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1749657325.git.asml.silence@gmail.com>
 <1e9c0e393d6d207ba438da3ad5bf7e4125b28cb7.1749657325.git.asml.silence@gmail.com>
 <2106a3b7-8536-47af-8c55-b95d30cc8739@kernel.dk>
 <7bfe8094-17d7-47d0-bb13-eec0621d813d@gmail.com>
 <ae60dd48-9e21-4a9d-a8d8-d98a2e8e6c8f@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ae60dd48-9e21-4a9d-a8d8-d98a2e8e6c8f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/25 15:31, Jens Axboe wrote:
> On 6/12/25 8:26 AM, Pavel Begunkov wrote:
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>> index cfd17e382082..5c89e6f6d624 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -968,6 +968,15 @@ enum io_uring_socket_op {
>>>>        SOCKET_URING_OP_SIOCOUTQ,
>>>>        SOCKET_URING_OP_GETSOCKOPT,
>>>>        SOCKET_URING_OP_SETSOCKOPT,
>>>> +    SOCKET_URING_OP_TX_TIMESTAMP,
>>>> +};
>>>> +
>>>> +#define IORING_CQE_F_TIMESTAMP_HW    ((__u32)1 << IORING_CQE_BUFFER_SHIFT)
>>>> +#define IORING_TIMESTAMP_TSTYPE_SHIFT    (IORING_CQE_BUFFER_SHIFT + 1)
>>>
>>> Don't completely follow this, would at the very least need a comment.
>>> Whether it's a HW or SW timestamp is flagged in the upper 16 bits, just
>>> like a provided buffer ID. But since we don't use buffer IDs here, then
>>> it's up for grabs. Do we have other commands that use the upper flags
>>> space for command private flags?
>>
>> Probably not, but the place is better than the lower half, which
>> has common flags like F_MORE, especially since the patch is already
>> using it to store the type.
> 
> Just pondering whether it should be formalized, but probably no point as
> each opcode should be free to use the space as it wants.

Right, that's what I insisted on long time ago, all fields except
user_data are opcode specific, even if some flags are reused for
user's convenience. There is no need to covert the upper half of
flags for provided buffers when the majority of opcodes doesn't
care about the feature.

>>> The above makes sense, but then what is IORING_TIMESTAMP_TSTYPE_SHIFT?
>>
>> It's a shift for where the timestamp type is stored, HW vs SW is
>> not a timestamp type. I don't get the question.
> 
> Please add a spec like comment on top of it explaining the usage of the
> upper bits in the flags field, then. I try to keep the io_uring.h uapi
> header pretty well commented and documented.

Ok

-- 
Pavel Begunkov


