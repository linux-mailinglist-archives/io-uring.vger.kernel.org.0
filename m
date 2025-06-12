Return-Path: <io-uring+bounces-8324-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 079F5AD73D4
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 16:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F721189247C
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 14:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF1771F16B;
	Thu, 12 Jun 2025 14:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zd2e2tcu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50EC14658D;
	Thu, 12 Jun 2025 14:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749738285; cv=none; b=ciG1m+ficOrqDcBM1fndu9u2BxJTOTK5ZSMZykif1oa7LEvs0GtKt7W2I9WDCyDY1+9/san/va3iDToBNMScvjtyeFGlnB7numNYJsKHt8qwnEpMEdiqZgFcGlq8qz6aIfQkUEUjgeUmpa/88x05fPjLjT+QH4gzGomufleTqX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749738285; c=relaxed/simple;
	bh=a5Go237JGJhkg9cW40xT5owEjtImI6HiJOHTuqYUg44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IRoLHf36p1QQLJJk91WDZxpiuvUBhfN4IIOpOwA+Mrlo1HNXYSQMH7Gi4LBcj+UzaKbtWS5h8GQTMbdRnmX152X1MmkCOZWBNOyTjQsnIXJuVTSvJxbokr525vEyx60RKJZT7yFEie6+hi4qjsht8jzTK/4vzbuZwVTb4gSzT+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zd2e2tcu; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-442f4a3a4d6so5839645e9.0;
        Thu, 12 Jun 2025 07:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749738282; x=1750343082; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q6RPF4+ld+ouU/J4XLLUigKXhgXCWLk6NJomx5m2j7c=;
        b=Zd2e2tcuDuqCTmZJRDB6dK8AbsurJl4FcRzlsv0IL5jhOWx0hsB79pmziHNormhr3u
         JJWWUsENDD15vfO236JSCuh4QOXgQCp30RqVwjm5dWGml5Tq265h1Z0HvAnUcPRQUF4o
         oL7z1lrY7Hm+be/WgpEgIO1SawmTXZeOsyfRvXW/UPI3rigAV7AgJpXMnLnUmLaOLUff
         /OStFIOvu1wm/lNchuFWGX47C6Z7bosAyuXKEpwJ0e+pRJVMGSUuGzSL6+4ZO3vtGJiS
         6JTb5SJf7YBKphCbLA5XAoD4WpjsH8v++HTUCxd21TwPCb32Ecp74WezZFU9t9BgopaV
         jszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749738282; x=1750343082;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q6RPF4+ld+ouU/J4XLLUigKXhgXCWLk6NJomx5m2j7c=;
        b=uI9ttUVp4r27lydDdVwmtHQjii3QjyITjBFdZhOxBehd7oQkPjYZBBLmPgxnpJi9fZ
         Tul2RodOViJCVGbY3aQ+34kRjR7E811Y4KgfRQgancPbjB4YqJ2sG/i4xv2YUJFkgJ4Q
         NWlbTo6tjNTro6uBMLQwZBuALsKna6nGDjMoF/BrAKbt3aqcRckDjxXYD4EGuYYlADdx
         BhnHLQKvJ7zQ/6e3QSJ5K2fmh5C5umo1Zfu0W9GYfKeEjnFDSNPNEQFMUKPd0M18e4Ck
         fpyxoW7Csk2lfNW5/gsAe5sw3PnkX8Aq470gbbIophtC5l3Fx8iC3aU5vAk1EVXyNqnC
         7lWg==
X-Forwarded-Encrypted: i=1; AJvYcCUFLh2BnN39bgfoOeV9ZSQfcEHoVUpDkKuZLnI8GpiglmERArJhjWAz3dkT6zIOZeD1EBxBXY9nPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLHacL7pWKk70EdhU5ih6SUDZQ+yq5dkWwJINxUN/B+w07WJkr
	CXZahp6b5ey27O3afRbi3u+ykab/0uDYaL1Yt16zqaOnpdPvJ7lIeWy5
X-Gm-Gg: ASbGncvjij0SV5ejOlFCaAufLeRWk/IkLZi8CekLXSxhQFGWgaBe/O1SA7W5AhdEyrP
	8cQRKdm5ezODhoga/Q9lmSDdKYaVZQkmOhRLNOWQv9jxnWtFFZOv34yJWEWcJQz+BlnfR6P8xr3
	d6HIIoDcw1XBj3PC07EZMQCY1t5Iziy5QoeKh5MXIDD4anV1lenUjRxyVDqmUvC9KF7QcmCjtv0
	P4pCVrkkTuTkbWJW8qL1g9McwkTnlAQH8gyb2XgvkXTekcGO+a4ywzUqzstRlM9elw2mSV9D7y9
	vgXRhovd4nDvEIeYPakp+LkzBeace5ahOixsjnxjgwG4xLKWABpTh/FPy/G+EmlDQNIz/oza
X-Google-Smtp-Source: AGHT+IEizYAGOeYsl5Zr68Nwfl5H58sy9EptYZCFrycW/KZVkB72PXvoKN50A8/zA7x7MYV/RYSRCw==
X-Received: by 2002:a05:600c:1c90:b0:450:d3a1:95e2 with SMTP id 5b1f17b1804b1-4532dd97734mr29923395e9.9.1749738281781;
        Thu, 12 Jun 2025 07:24:41 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.140.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a56198c9absm2112509f8f.27.2025.06.12.07.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 07:24:41 -0700 (PDT)
Message-ID: <7bfe8094-17d7-47d0-bb13-eec0621d813d@gmail.com>
Date: Thu, 12 Jun 2025 15:26:04 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2106a3b7-8536-47af-8c55-b95d30cc8739@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/25 15:12, Jens Axboe wrote:
> On 6/12/25 3:09 AM, Pavel Begunkov wrote:
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
>                          ^^^^^^^^^^^^^^^^^
> 
> Pointed this out before, but this typo is still there.

Forgot about that one

> 
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
> 
> Don't completely follow this, would at the very least need a comment.
> Whether it's a HW or SW timestamp is flagged in the upper 16 bits, just
> like a provided buffer ID. But since we don't use buffer IDs here, then
> it's up for grabs. Do we have other commands that use the upper flags
> space for command private flags?

Probably not, but the place is better than the lower half, which
has common flags like F_MORE, especially since the patch is already
using it to store the type.

> The above makes sense, but then what is IORING_TIMESTAMP_TSTYPE_SHIFT?

It's a shift for where the timestamp type is stored, HW vs SW is
not a timestamp type. I don't get the question.

-- 
Pavel Begunkov


