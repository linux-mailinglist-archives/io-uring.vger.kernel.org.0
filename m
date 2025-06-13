Return-Path: <io-uring+bounces-8333-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 75FF5AD946A
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 20:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74C05189E30E
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 18:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD1E22DA17;
	Fri, 13 Jun 2025 18:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nk7/MD7e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B7C1FAC50;
	Fri, 13 Jun 2025 18:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749839315; cv=none; b=SlPr3rPjFSy/SJC19zNS3moCXKltGERgKTNCBRp+lTtjxDuHBWM05MGlrmivUHDYt1J7wSNA1n2zfvX9dljK2BTqX+/U85dtYb+lddRoGIzKjUo5VSur5P7e3iMb7a5kBus90KfOHqK34QaENlsgUT4PblIomdEX6pqw+Ef3xEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749839315; c=relaxed/simple;
	bh=H0EWrCkCm+Z1Bh38qSbfn8OZw+LoNO+9vpbCCy5S/rU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/0B9o9Ur+J3MMbkziLuiKwjFBgLNoFsqyNcPMnbfaByOGDGaAH9042d80BPu25i/U56cXzpfnpd48YdZeNBBVHVaLP4cCnykggpTFSHcpegvO3l/3HV2NuDSASZwHLMuwcM3dkuwVF1u6fZIAWMM49E8mOHCBzzTc3oirtRn4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nk7/MD7e; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ade5b8aab41so504889866b.0;
        Fri, 13 Jun 2025 11:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749839312; x=1750444112; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ABo3/5s3nE38Mc0qKpEhlNoUQW1paZLZV3J0Lx+s+oc=;
        b=Nk7/MD7ekV4telYde1HUSoWaptUgtTBRZ477IZDQ3eFXFAmYJZWUesBTgtAPFfe0KY
         EZsW+b7jLzt03nUJtqyaNACGe3i/gucFG1Hhtdaz01w9zh6HK2/ZaalCNd+HuDxo2Jrq
         ZuU6COd1ysZXPvbYWN+ydNW6CpII/1t8P00L4gFldI5ORCKw481dg7IONy6uLgMbGpC4
         d1cZ8KeHB0Xipk+LznxjJBecyoc9U4VNk4vOZBOU+M4zqDzyc5XUqeRRqbrpHQjkTZZL
         lOAkqYT7VYhhwfH2hr8CPyXG4kS4isQcxQgdteia3bhAs+bhhiKShwWdTAeqO+nUuwwc
         N82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749839312; x=1750444112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ABo3/5s3nE38Mc0qKpEhlNoUQW1paZLZV3J0Lx+s+oc=;
        b=cGLi8ndW0pNzwqbUmJACzexJYIiuXnCNu18sYvViz0UxdBnuevU+qmimQv9Kwnzjue
         kxO4uaRiGNy3d1UCfuD5BvDeDQdVGqB6NL4vL/aQMSxC8w/h2YE6/T03i5E65yeHxpZr
         LVVxvk84e4Hg0SLMq/rXql3saCjzA6MqNZQWE6WUF51N29W+5x3WFipYUXITTtrt4poG
         S5nsWscuQFRHfZJNBelu4wU+6vHfyxstbBteFhuKPy1R4JUVNhjSnvKCixvJQ3ddoX9K
         eWFHfdayE9Kb9eYChEKkhoLfKNnCKQiLYxfb+dbgw3nkXiaNi3mPDiQqrmXXRsbFh8mM
         f5+g==
X-Forwarded-Encrypted: i=1; AJvYcCXbE2a4cILE7PZt7NDV8jZ9j4HKJyAHMTNTLir29hefSzOXyd32UzYvwyVjHi8ABaeX7+iNNRrNag==@vger.kernel.org
X-Gm-Message-State: AOJu0YxRQDIGOW8AxmRMk3BQruYv+QZ7EVRVeMEYCGrN6ITViwFqibtB
	RB9jScOzIrbwvjrAGvbUNDUAzBDtRqfg77V+eAFxjkMYcpd1scLHJfc8
X-Gm-Gg: ASbGncuRtdLy5qXJiiZgqYUhXByifr5LtFYyPznoDX0UjImKXRS4zrMGL2JH8RttmFl
	VQbRxQOYJ3xJ5jGvwmYRZ2BQtqG1Mb7e3AHOKdHU4WkpiFYgNEe+w/WUuywOz2I+80BaIlW+0+3
	bfIRNhhwd/6JIbYjmYw/3sYImlQ3rYo4xwzbCpD8wF18UmlAmjq01y/CaDRgyZfl2dmJhkF7LeA
	HgkSMOr8YMf2oU+32TWzxGjwmS8mjIjLcuaPhJE9Z1hDG1BBJjoZJjKzKTSgrhnQFWKWxSpWsNT
	RwaLysflROvFaI5YcY6oXDxUZyPabhh1I9l207PWu84noIPin7usPDCjYnM84B0xfS4M8g==
X-Google-Smtp-Source: AGHT+IFSbbmQjA/wTgKiY2wwGctGwrXD281fyT12WAj/U8xRaxsVfPc2UIH7zEZtrSLTR21pTiOfew==
X-Received: by 2002:a17:907:72c2:b0:ade:4339:9367 with SMTP id a640c23a62f3a-adfad34accdmr21847066b.26.1749839311308;
        Fri, 13 Jun 2025 11:28:31 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8929371sm165673766b.117.2025.06.13.11.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 11:28:30 -0700 (PDT)
Message-ID: <70880c86-34e7-410b-b15e-79f7a039df8d@gmail.com>
Date: Fri, 13 Jun 2025 19:29:51 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] io_uring/netcmd: add tx timestamping cmd support
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1749657325.git.asml.silence@gmail.com>
 <1e9c0e393d6d207ba438da3ad5bf7e4125b28cb7.1749657325.git.asml.silence@gmail.com>
 <684b482a1a03f_cb2792944c@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <684b482a1a03f_cb2792944c@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/25 22:35, Willem de Bruijn wrote:
> Pavel Begunkov wrote:
>> Add a new socket command which returns tx time stamps to the user. It
>> provide an alternative to the existing error queue recvmsg interface.
>> The command works in a polled multishot mode, which means io_uring will
>> poll the socket and keep posting timestamps until the request is
>> cancelled or fails in any other way (e.g. with no space in the CQ). It
>> reuses the net infra and grabs timestamps from the socket's error queue.
>>
>> The command requires IORING_SETUP_CQE32. All non-final CQEs (marked with
>> IORING_CQE_F_MORE) have cqe->res set to the tskey, and the upper 16 bits
>> of cqe->flags keep tstype (i.e. offset by IORING_CQE_BUFFER_SHIFT). The
>> timevalue is store in the upper part of the extended CQE. The final
>> completion won't have IORING_CQR_F_MORE and will have cqe->res storing
>> 0/error.
>>
>> Suggested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/uapi/linux/io_uring.h |  9 ++++
>>   io_uring/cmd_net.c            | 82 +++++++++++++++++++++++++++++++++++
>>   2 files changed, 91 insertions(+)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index cfd17e382082..5c89e6f6d624 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -968,6 +968,15 @@ enum io_uring_socket_op {
>>   	SOCKET_URING_OP_SIOCOUTQ,
>>   	SOCKET_URING_OP_GETSOCKOPT,
>>   	SOCKET_URING_OP_SETSOCKOPT,
>> +	SOCKET_URING_OP_TX_TIMESTAMP,
>> +};
>> +
>> +#define IORING_CQE_F_TIMESTAMP_HW	((__u32)1 << IORING_CQE_BUFFER_SHIFT)
>> +#define IORING_TIMESTAMP_TSTYPE_SHIFT	(IORING_CQE_BUFFER_SHIFT + 1)
>> +
> 
> Perhaps instead of these shifts define an actual struct, e.g.,
> io_uring_cqe_tstamp.

That wouldn't be pretty since there is a generic io_uring field in
there, it needs to be casted between types, explained to the user
that it's aliased, and you still need to pack the type somehow.

> One question is the number of bits to reserve for the tstype.
> Currently only 2 are needed. But that can grow. The current
> approach conveniently leaves that open.
> 
> Alternatively, perhaps make the dependency between the shifts more
> obvious:
> 
> +#define IORING_TIMESTAMP_HW_SHIFT	IORING_CQE_BUFFER_SHIFT
> +#define IORING_TIMESTAMP_TYPE_SHIFT	(IORING_CQE_BUFFER_SHIFT + 1)
> 
> +#define IORING_CQE_F_TSTAMP_HW		((__u32)1 << IORING_TIMESTAMP_HW_SHIFT);

Let's do that

-- 
Pavel Begunkov


