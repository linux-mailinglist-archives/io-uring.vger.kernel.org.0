Return-Path: <io-uring+bounces-2534-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 691C4938629
	for <lists+io-uring@lfdr.de>; Sun, 21 Jul 2024 23:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A8ED1C20865
	for <lists+io-uring@lfdr.de>; Sun, 21 Jul 2024 21:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B2AD268;
	Sun, 21 Jul 2024 21:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NEAfOnoW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990812C95
	for <io-uring@vger.kernel.org>; Sun, 21 Jul 2024 21:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721596695; cv=none; b=YEimyRhulO0/KTLdCWt9nHShBdbZUmHWnGNwa2cnYl8duzBekoCrGuu0mhq17HYyjkT/Fzswd7AwEnynn0cyFcM21pWdTnK9avKhzv4cG525XxZ5YuTqaHZccGcGA/Qy3LlF90j4QfLZdGQ3L7Qy7lntMqiPuTs98xuqIKYQPrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721596695; c=relaxed/simple;
	bh=e+e3HRZtoCI+nGXLKXFiFX9ACGfVj7C3cIoKrhi+WW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y3nnCcws2bqN5V3nF1Gd4ghQTb8Cgyi7tXJBwdyjW7INJE6RjNzwhctEIqMA4HUdPDlnxKrVuk035zMal49Iglselo3MBQmEWBhzNLPC3riPC4tIv66BH8mzqT2lTY18RkUbu1FnAdraXQmcgmVSBMKLI/+HVx0I53bvROfoq6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NEAfOnoW; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70d22b6dab0so14188b3a.1
        for <io-uring@vger.kernel.org>; Sun, 21 Jul 2024 14:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721596691; x=1722201491; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YBgq9T8G9Op5CIBpx/HxQD4hvWIKYcpOgdbZ3F4s4Q4=;
        b=NEAfOnoWgyN682SpiLTsF4Rb25cFDWBTpufrmBqK9T+Jrf2fbcAkEAid41XWdwIKWS
         UETPY0fy0aNuD30yZyhVwnTpRBkuxX9ceUfnTXKijJdefKIeoxFZKBnOVaFaLlqnn8LM
         5XBHrp6r2rnh+DpQSx/+euR4GMSlaiY+4TDex3YgmmWhmsvILH5TNQ55clr1kfP3k5P6
         XHmWID5XVIdH4NPeZfUcLhdqH5rn4wpp1/R9jZe7/OIL5gZKGLcWo6gAMrg9JQ7Xqobs
         3c6R5viAul2H4KdeLq2hpqPpc/Krax1gVD/TCsZPCrRuGTZkl0mO0+VytA/u2z1aeWKv
         GpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721596691; x=1722201491;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YBgq9T8G9Op5CIBpx/HxQD4hvWIKYcpOgdbZ3F4s4Q4=;
        b=uc3a/l5qumnNv2Wu2fwQrEwIAu8n82y9u06djcQhD+xQyOzf3T2PsZPJdT/Ge2Vxb3
         d9UZHSZo9PkSIOL+GmHdIVg9FupM4scY+p2Jnq5G0zgkXc5oDtEjbvNjOwf9WAzVoGMh
         oQKWqBVcSskZbMdcd9WzteBy3vWAz0aRqpVQc/qudEiKBTw6EPJwxrausU6rYV0GYzaz
         fnv5/uIaL61GAwE1QTq3R7RdBL0iNUveaEI2oG3NUlc/HmwqQLI3/wauTSZqMUNgQPd1
         MW3BSQjGnqeg8JBh4MQtqWi/SaM7njSO0xnsX1/V4YbPJ0/MS7hXg9zMUQuVoejGk6G0
         2+1w==
X-Gm-Message-State: AOJu0YwLSBSAs6zC0SSBgukYMt9TaqBTJh0Pbqagv/03UkmV0YAUF24e
	ZmD9Xh54s2uuTbYLPCMfx8YneejW0gAdhh5RXPh8h5VVaKBDSMSDIwsSe3hwNzo=
X-Google-Smtp-Source: AGHT+IE9rImpCXdNMh0i7lQcT8v3ZtZ+Y2qk0Ux8wcmBF7b4ZyP7ZdOnLVOu3Zm7dFnFGEqyQtzEAA==
X-Received: by 2002:a05:6a00:8718:b0:70d:1048:d4eb with SMTP id d2e1a72fcca58-70d1048d676mr3183026b3a.3.1721596691575;
        Sun, 21 Jul 2024 14:18:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a0a3c3e34asm2523538a12.8.2024.07.21.14.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jul 2024 14:18:10 -0700 (PDT)
Message-ID: <403f0652-8f2d-400e-9f18-99b0b4085670@kernel.dk>
Date: Sun, 21 Jul 2024 15:18:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/5] liburing: Add helper to prepare
 IORING_OP_BIND command
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240604000417.16137-1-krisman@suse.de>
 <20240604000417.16137-2-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240604000417.16137-2-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/3/24 6:04 PM, Gabriel Krisman Bertazi wrote:
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

Finally got around to these, as the kernel support has landed...

> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index 0a02364..818e27c 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -669,6 +669,13 @@ IOURINGINLINE void io_uring_prep_connect(struct io_uring_sqe *sqe, int fd,
>  	io_uring_prep_rw(IORING_OP_CONNECT, sqe, fd, addr, 0, addrlen);
>  }
>  
> +IOURINGINLINE void io_uring_prep_bind(struct io_uring_sqe *sqe, int fd,
> +				      struct sockaddr *addr,
> +				      socklen_t addrlen)
> +{
> +	io_uring_prep_rw(IORING_OP_BIND, sqe, fd, addr, 0, addrlen);
> +}

This needs an ffi and liburing-ffi.map entry as well. Ditto for the next
patch.

-- 
Jens Axboe



