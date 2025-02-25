Return-Path: <io-uring+bounces-6745-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 962B6A441D0
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 15:08:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 093D63A24CF
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 14:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3CA62641CA;
	Tue, 25 Feb 2025 14:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IhO6ERgZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074882686A8;
	Tue, 25 Feb 2025 14:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740492281; cv=none; b=G8afHqZlU+wxrv7RmmJ2a2uNTGGLPI0xGcoI6gyLnxg1Kd/YtY4FH+AvyiwWryB7/NnrO7tcSqAaClK/h589i1zxWgeBFPyPgQMLTDbyxMs8eSkphOIBIzfl0dTRiXeqzcxjMoCQX2pB2577VbqhQN2EM32/bNYQtF3Yzdk1fjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740492281; c=relaxed/simple;
	bh=dMcMgjn9WKV4E4owFt5XjSCqrNrGpz51wHngIocPq+4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=lHmI7mmKwM1SrzIIS+zqqlRH91YHrt3WkpmdNTm1TXgNTGgigWBY3wXYbtKZaR6m81X4L/Dq4SjlAvb2XO13fVbtL8slaCQuxJVFYYJvB4VBe5sxrQw7AU8+FmseaxKfEqFpjyC72FLuOgo5JDb+Dqkxvlubt7sGNM5dbXFwf0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IhO6ERgZ; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ab7430e27b2so884905066b.3;
        Tue, 25 Feb 2025 06:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740492278; x=1741097078; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JhSlHTDLPsrmk6edAzeid/d6Z5e4ah3176T9IRYjow8=;
        b=IhO6ERgZJXSPxpwzlq8aKQ4BKTvHqBwjgv0zRyRcz8Gbzhq6TFync8QmhqWNDw72Um
         tGjtUreCF+kOxofd7Et1OQP4Soqj08q/rz6KJ7xxi8jnfFs3lEP4Y1dTDQqQpsHVdF8l
         JfjN316pHem67l6QNX0VUlkoFzhD9TqRJu/PCglJu+8JZnjJGdRVlEiOTocgjaLdjp/g
         4VyN+7iW5nwylr6DtmpME1SKVwGntvl97CQiHx1pq1c5w9zHpX0cIy4AMcaLQpRNHVob
         TYXBIVEflW4rRO/UAknwuzao4y+JnqQi0gLhRQmTm16vM5Dl5RQs2ngnDsYE5LEuf2LG
         gfXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740492278; x=1741097078;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JhSlHTDLPsrmk6edAzeid/d6Z5e4ah3176T9IRYjow8=;
        b=EV7gZQ7hiTb69/71fd6mhS6aVpjh6HXhTEpVk9MCgtePGJngFmdIF4GAbvatElSgbg
         +bcUKxRc/W1qqJU6VKU5WqHnkPz7ZsZ2i4uj1kQLQAfOG961VIPHFHm3eDadENQdZb5g
         eHfPe3Z22Hd1SkhpEdKERYUuQDM8Le3L4iwVhNhvGIMn6eXeXiKMFqiLu3iHLuoUuH6J
         iWAW3pYIYEtg9TMmTHjmjd3HcVlOS1VHkzAMRbeMYJBzvAgx5o2hXEp3/+1BhGwED3mG
         c4m4XHjpE4ubwfQMfvkWnwJqbUp4ziAwQk6AGOUYSocztqcY98RFlS9+ciR/3qpSTEB9
         csEg==
X-Forwarded-Encrypted: i=1; AJvYcCXdMk3EePfc8JZGnIjpq69zRfwviO+3X1lB0U6SbVjd+jyb+V0wXiG8Wn1/S48nnQ2Wdw4vt/zWfQ==@vger.kernel.org, AJvYcCXyRRHsS2qGWEW3IoZQp9VeJQ6nlmPPepFIeiUMd3I7X9MKLVqp+B8BJw5Vdl4JNFW/ynhNQdZWAJ5hbJE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+nz3V3RZui+t3FMvNwEVwaDHDrcrOyQJkppdwXMbv8Iu04tCR
	va7cKxa+xgNU4FI+suRfxIjG0d6XMyrOT50qOTHqPEg/Yb0BoyKhPVkOnw==
X-Gm-Gg: ASbGncslFZ3rPlbTw8V1sd5i5cbnA1OBJ6sGaQmRmNnhKgX2Jae4fMdu5EQ8nZfVlcg
	/bgQT0MVC2lMuMFpQrtde1ygyN3sLyjAFpZiP6jTuIkz3QaKV4gTyFeApCAYFj3EEIIWtUglQ1C
	uMDRq3+ZzdDHRJ8kHKNy2Y7jxyC3kfGZiE++5khb6az5Z+bryJzJ96XucqjfNle4IZEuyQ1ilF6
	+y9UmHgULVVTsOP8eX20q1xUX+uHkuawmlgs0MsO/vBLPrqmD0M64Qov6SIY26Twvy21yU3LS5m
	UMZrCZbxioPMhHVw0HTcUZ5k9XNsBU0U66I+42mPNc8lexCklkRu7qpLp2w=
X-Google-Smtp-Source: AGHT+IHmawjBFqRcosy+Nq25Nm/XKWHigFPRoueYAbJSNLD1NsznHKE1eGXKNroqiN8HGwhTJnrwbw==
X-Received: by 2002:a17:907:784b:b0:ab7:e278:2955 with SMTP id a640c23a62f3a-abc0de11d23mr1436860766b.38.1740492278018;
        Tue, 25 Feb 2025 06:04:38 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cdb131sm145901266b.7.2025.02.25.06.04.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 06:04:37 -0800 (PST)
Message-ID: <88492310-5a24-476b-b36b-d56e6f36b5b8@gmail.com>
Date: Tue, 25 Feb 2025 14:05:37 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 07/11] io_uring: add support for kernel registered bvecs
From: Pavel Begunkov <asml.silence@gmail.com>
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-8-kbusch@meta.com>
 <67cf1bf2-9338-4d02-a1ad-db25d3eaed3f@gmail.com>
Content-Language: en-US
In-Reply-To: <67cf1bf2-9338-4d02-a1ad-db25d3eaed3f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/25/25 14:00, Pavel Begunkov wrote:
> On 2/24/25 21:31, Keith Busch wrote:
>> From: Keith Busch <kbusch@kernel.org>
...
>> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
>> index f0e9080599646..64bf35667cf9c 100644
>> --- a/io_uring/rsrc.h
>> +++ b/io_uring/rsrc.h
>> @@ -20,6 +20,11 @@ struct io_rsrc_node {
>>       };
>>   };
>> +enum {
>> +    IO_IMU_READABLE        = 1 << 0,
>> +    IO_IMU_WRITEABLE    = 1 << 1,
> 
> 1 << READ, 1 << WRITE
> 
> And let's add BUILD_BUG_ON that they fit into u8.

Apart from that and Ming's comments that patch looks good to me.

-- 
Pavel Begunkov


