Return-Path: <io-uring+bounces-4303-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 063A89B92FE
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 15:21:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3822D1C21604
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 14:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297BC1A3031;
	Fri,  1 Nov 2024 14:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fNyq87Yd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0355D24B34
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 14:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730470878; cv=none; b=iEMXDfq/FJMOJCYi/edK3K6cCCGZGFgUZVhxQhBJOsNqxPfMYCnKxcbhlQJ8exutFrqERLBoSgk5HB3oOBpfMDDTanMSGSnAdzgA1Xym3yxz0XMeMM72ychpD018nYgWvauqV4OyeQ7KYyRSuDAlB5rwykGwvWFJttf7VzMF7Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730470878; c=relaxed/simple;
	bh=V03RrQ/eRcpUIaeIBEsO5TzVHd9uvJAoii2FS5VSLug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c8dBLmy/ZZwzo5mkhctrlhXbHxDXI7RFoEYY09ZhrUJkgQvd7kFYUP2LZz/7QCxjyyo14DrFCKK25IwSMxAUElTqxONP+xtwYruWGeD/fow4Cmh8YL4IKvd8KKA+EEMk2i6jcL15bAD8mfNpv2ndBZmXQmnHulyAla7C0aehnb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fNyq87Yd; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2e2e050b1c3so2336703a91.0
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 07:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730470875; x=1731075675; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w+BfSGB0i3a8RGUOICAgluAkdQExBqXBgbYULqUlYcY=;
        b=fNyq87Ydg+lMplTvdwhsIxYIA6Uov9ieiW3b85iaA5HKPCyro+VmDffDrTdaUttEpx
         xCw30yyPmplPvDOrXOuXmL0yFlI1/SIAh2A14qjEwJn2bdZZ2tw74Gtg+JAHGpMqwji2
         qxvpI3O5XDowonPhTvmuGLtACUx1Oy6wopcNTUikUG9//nAMefbCKAn0fHi9wWvoVxlz
         qjYTgoXXgdUUj4kK/RPghf9+koKGfSbh2S/3AwDoiRK697T+OlYpc7ZNFHpLRDBjXUHE
         mu+tF8ojc4NqqsI9VukzKEXk22p8f3uHb/FVYoJj1DI3ztBhX7qWg+e13hU8gc+POHwY
         Nc2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730470875; x=1731075675;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w+BfSGB0i3a8RGUOICAgluAkdQExBqXBgbYULqUlYcY=;
        b=X2/3KXMc7xGPXaBXbLfR60ZELOozMMpbioIp8OtXx/ZArMW3nktGtz9zMGBummfrCf
         N9eTxOzDyVsHSt9mjuKjYYjA8zrIu53JxGzo5pZ6S9/JW9Fv2n2nej8UdRC+6jnHjyY5
         TpC8V5UFFjyFdOj7jylDfnoimNH5+1ToepsZ61xkHlNP5N67L5LpKp8C7XJOvK5Ujler
         dn3COIKqQKB1o8Ndu/FQS851ZcEW2SO8/M+gOS73S3xUHKz1icUrmrPfHl6TIjmSDRh/
         rufvKJeOlmK/g/8e0czvVr10KtV6TAKbRTZKmG8KUpxkFjVz9iS+5XTLJFRfJWGOSyRr
         204w==
X-Gm-Message-State: AOJu0YymyBsY0i8UhO6IEZFUkejUi8fvHKSEurL8homzdWmFrjaoI8LJ
	vRlwWSqBQssz7nvhFywadCLI3ZAwWBFPmzIkXBjnP/MVgYauAHr1GbR4YVbj5CM=
X-Google-Smtp-Source: AGHT+IG3H1DBKYaRJALZwquhYLqr27wLRwQoVK3Kt480RwCo6CMxKoST8WWEb/7Rw26bJiGe7gYmhQ==
X-Received: by 2002:a17:90b:1a8f:b0:2da:82d4:c63c with SMTP id 98e67ed59e1d1-2e94bcb6255mr5858519a91.4.1730470875185;
        Fri, 01 Nov 2024 07:21:15 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e93db17b0dsm2708590a91.42.2024.11.01.07.21.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 07:21:14 -0700 (PDT)
Message-ID: <1610add8-f9b4-44ae-89ae-f01e2c5620d5@kernel.dk>
Date: Fri, 1 Nov 2024 08:21:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/1] io_uring: releasing CPU resources when polling
To: hexue <xue01.he@samsung.com>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20241101092007epcas5p29e0c6a6c7a732642cba600bb1c1faff0@epcas5p2.samsung.com>
 <20241101091957.564220-1-xue01.he@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241101091957.564220-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/1/24 3:19 AM, hexue wrote:
> changes since v7:
> - rebase code on for-6.12/io_uring

Though not sure why you'd base it on a branch that's long dead,
for-6.13/io_uring is the appropriate branch. for-6.12/io_uring was
things queued up for 6.12, it went extinct as soon as the merge window
opened for 6.12 and it got queued up. Not a big deal as it can get hand
applied, but new features should always get based on the branch for the
next kernel, not the previous one.

-- 
Jens Axboe

