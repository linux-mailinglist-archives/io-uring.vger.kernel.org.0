Return-Path: <io-uring+bounces-2878-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A05295ABF2
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 05:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC25F1C20F68
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 03:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00722225D7;
	Thu, 22 Aug 2024 03:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VAJGvgPd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92779208B8;
	Thu, 22 Aug 2024 03:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297715; cv=none; b=a11qK8Jpq1nWLDALKQEpPcssHIyp2Lt0wjfL5x20U0M+XEvuQ2SNsYrhTopsRgU4gdhwPZTCh4v3vw2DXSYtn+MzLlp7ay4kaD9AQRCY8MDaJQFdor1Hmbq9YPhsv/TLGDUVYtbbv0IaZwHUueAxf8E3GZi/fEt2inbLGNwS9Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297715; c=relaxed/simple;
	bh=gQjNb/+gsnYpywolBMVCQUTPQsmVN9O3Aro+D4HFAgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NrsrKEherIzvTZfm+TNjEjCEZqPDJdajKD35B++5NdKQv70muHH6V0sTP26i12F82p7s7agtNx/tCM5FfcPDR/3ZiNCi2QrMj/JK18ZvMJGGZJK3Ba7LcfvIoY0udWhlcmzm9PNUkP0EpBdRMQkya2TquzYlTs3YOALQCWVE6EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VAJGvgPd; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-428e0d18666so1601545e9.3;
        Wed, 21 Aug 2024 20:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724297711; x=1724902511; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VKqQw6BKVa7HtlTJ+qr4cNksRZXuSC+VRvuqmjacWSg=;
        b=VAJGvgPdYqHGIWhlphOOm5YtTElyaNoVgMOqrZKXp2BmyU4ytKYsfl30LY8aVqMGEX
         MhtH+1lMfQIDGASEkQvcetmqWiYVxTOLbm3oNogMe84N/EpDfk1qUVzVfGicXxLmuk/I
         9GKlFxzMnjNBGSbF/vqrwzXKC4vqI0cGtb7p+6iClMoAmTBi4WQS9JkVTSKl46IbcY25
         4SdUOI7cztuFZbjofueNc1rbuKiyD5zOxzZ+xxPlCl2I70YTs8FtJDHJXa8Eqesgidoq
         K+Kq6vuMMItPLlMRLn66sVYLFXl4EF8IPrk1fgvuVfa/jjvXLyVy3UCm0+jOPtd9LV8m
         JAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724297711; x=1724902511;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VKqQw6BKVa7HtlTJ+qr4cNksRZXuSC+VRvuqmjacWSg=;
        b=PD4adj2XpvVvxNBvLTbm8ZWzDoxkD7xQss/Z1fAFbyv0VtVz0Yw3v9rLyQkMakoA+F
         blrEylwaFa3UY1K8yG6crmzUTXPl9RyOnn01gRSnbivQlmT8bKLsdBcxTa8teF6YX8Iy
         au+bpUTTk5Xs/hMnVsAyDOkvopY1sMJKpWFSdB0gEfabH0wmr3RrHNnDxGG5048ysSIQ
         dVLXxNJRYH1WpP0fyxgImaM/Y+OjzEXWHS94kAAkw+ovdQtpnnoP7SBZPYw3+mxbwAgj
         Z1MvZrscVqqVeJ1EwPU/RJGHpz141x0tBT3CLJDS14hAvv/SDDtq4oVHTLzjX05bXKXh
         qkOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaTaK62akjBbYzq3l/kJxB9MG9iUbQsteoVvhlJ8HDaTNDLzsb05CBe3Ci5fpmH3YRd6lKsr9Gu2MrPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YysOBOoRmk/fywV1OwZmnTOXnNa8RNVW7KBh3Lmm6ke4U1lJNBr
	N5rtKUIdjUT4PwuWYHj8Yi/I8Uk39DM63Xlfsg8et+/W82gflDLTUULHLA==
X-Google-Smtp-Source: AGHT+IFm/REv959ii5LNYQl4zLzlA3XNJMBnAPvwjyqYLWiVYIKUTvbHtqwnT4Vp+bvAxDfdaq/8dQ==
X-Received: by 2002:a05:600c:358d:b0:428:f41:d467 with SMTP id 5b1f17b1804b1-42abd11d47fmr32186195e9.10.1724297710573;
        Wed, 21 Aug 2024 20:35:10 -0700 (PDT)
Received: from [192.168.42.184] ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abefc627asm46499665e9.34.2024.08.21.20.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2024 20:35:10 -0700 (PDT)
Message-ID: <290dbd08-e743-4e4b-9272-542e51a151bb@gmail.com>
Date: Thu, 22 Aug 2024 04:35:35 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] test/send-zerocopy: test fix datagrams over
 UDP limit
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Conrad Meyer <conradmeyer@meta.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org
References: <285eca872bd46640ed209c0b09628f53744cb3ab.1724110909.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <285eca872bd46640ed209c0b09628f53744cb3ab.1724110909.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/24 04:30, Pavel Begunkov wrote:
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Please ignore, was resent by accident. Apologies for the noise


> ---
>   test/send-zerocopy.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
> index 8796974..597ecf1 100644
> --- a/test/send-zerocopy.c
> +++ b/test/send-zerocopy.c
> @@ -646,7 +646,8 @@ static int test_inet_send(struct io_uring *ring)
>   
>   				if (!buffers_iov[buf_index].iov_base)
>   					continue;
> -				if (!tcp && len > 4 * page_sz)
> +				/* UDP IPv4 max datagram size is under 64K */
> +				if (!tcp && len > (1U << 15))
>   					continue;
>   
>   				conf.buf_index = buf_index;

-- 
Pavel Begunkov

