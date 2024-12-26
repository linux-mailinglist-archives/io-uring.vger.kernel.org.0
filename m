Return-Path: <io-uring+bounces-5607-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 675789FCC03
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 17:56:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 07AFF18824DD
	for <lists+io-uring@lfdr.de>; Thu, 26 Dec 2024 16:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6F91369AE;
	Thu, 26 Dec 2024 16:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vb0OBDMG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08EE3EA83;
	Thu, 26 Dec 2024 16:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735232180; cv=none; b=ekrTkpOgnMvVi6DcC/zsG2nvhS86WPy9iiQv9+b3m1UVK30KGqXXoe0ZR0BrQSuHNKuxs0T2c+SiZ5IviHxWoT3o3sZcQx0ry5X4B4DSZDdzuGRhec0jSxDbpPjp4IVJRo/xLA7lYXeH4qHEowvQREjS/saDny7HkeCzaNdiTbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735232180; c=relaxed/simple;
	bh=Wn+SM1PCWl4KDvtSfiVHfDay3hbu16k8+gTEbMN7SXc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gk9Ywl6PHRUp+vY/k1vsuWXKASH+wNHUJxUGk15sKwUIHXMqSJTcuun82jRoBk1WtDKX6zqcf5TCGqcQcmoA3rrDpzjhmY5rtiM1Wqpf01I9Kivd5CC+FLNtgE6hEe260KFg2m4XdF3d+e0N4jjtyb5/jpCSGQAiCkVIopPb/P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vb0OBDMG; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5d7e527becaso10377455a12.3;
        Thu, 26 Dec 2024 08:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735232177; x=1735836977; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YH7uEN9ztieXz7OTfhHoXrUv7O5OyWowjr7LGPNs6ak=;
        b=Vb0OBDMGMd+KacnYKOZ5qmN/Pza9nZszqKGQLNJSROmAFOtiloJTZyfsMy44X56/+d
         8BU49DRQncHdaa6OU3Axj0IqRtz8OA43LEdwXbWe5EtTU11Mn53t1Nh2046gH4OFzMm8
         B/ZmWCQrczCdzk5TP12RT/ZVh6wxM6sztKzCdAO8KKyecFGRdRcb/UGLPqVvKq8ymIkO
         c3O4bpi0k1MW+LedHzk3rnnD0ZIhhFb6D7p/PIikHLWwLSNJRtaYK3yabIYEiqUXG4rD
         LmefJ6Nq64v8YSVHOGi6FZNL83zEpnTYzJudFSVBJ25weAnclkc/mc2UNla4BjoyvGW7
         lGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735232177; x=1735836977;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YH7uEN9ztieXz7OTfhHoXrUv7O5OyWowjr7LGPNs6ak=;
        b=oc52IB8T5D8tbYKVI8sSVqY2NaBXdsHrNulsiborFH0obEeXfhLNjYOKtJWDhP7Qwc
         HBGULkrPJe7aFKXaHqiyE10/+RAhyWh6zoHf6u7wvgY98z3lIt4IWBlVG+ZEv9TS3qv9
         DnZelQQUx2Gf83Ou+rpR2p3DEnbkc8yXY88ncivov4u06jh6h0WZcE4wlnesYgtbSMpQ
         Tc4hQQHThxxfI+IlOU20AERNKziAljsDeGeWuyBvlLrra9eLHULmombp8/PGP+0tjjVz
         3nKGLmI1KzHp38oj5MvbOZYO/I10pyEe+CpqrSnSz9anZkwAIGIeVamB0S0tVxFt7KjV
         yd3w==
X-Forwarded-Encrypted: i=1; AJvYcCW6IM8Inve5TwyVUpRaEI4O3DDkooLhWW8yKAn9l2lkSBOUJY+7llmFVamYAR3XcxCao1SbiYyfFg==@vger.kernel.org, AJvYcCXTYh4p23Z3qQPenboyzxxHNsuNZrSDkFeWl19WfkI8R+y207at4FLq0dh2ANYy9cEk+SJvPXdOlnVNAM2d@vger.kernel.org
X-Gm-Message-State: AOJu0YwZzJNuSjYIt5iASFu3I1zSVZlp/hVKmVnIcaOToWRekV+0rOV/
	NbeJiCM/sUZ2bsGasrD1VgV1Mn48BZE+w4uZtLZEqcnKLUD6iZ8F
X-Gm-Gg: ASbGncsAgdUKEKM4aw1Ibg3sLVNz6sLtNUyDFh1iMSdcHV2438g0vcSb9vrm6S8XUE9
	xnOdGOIj12jSvjRDobM0x1PQBzzJ40n0UsyS7i7OY2CLfca//QBubjeQrk1kVXuPXzMrMMPQ9kP
	wO9hHVZ69XiuUXKsxzcEAWj11Xk0dKfx5dBPorbb7p09T1iwxh7CjMuFr/UZiLgI5eVInOP3MwB
	T/DA/3zDf2CLMkKlRkK6T5DbPjpB5xfd6d9FrMhreeS1azhLI9y5Me9/iTdaeQe2Q==
X-Google-Smtp-Source: AGHT+IF0Bz+2Ktc7Nq2pnVs8GQ5Ak8X/yEgTB5ND+0RrcvzdesYruV0xofMM2C6l4MLEzLt6IegWaw==
X-Received: by 2002:a05:6402:2749:b0:5d0:ed92:cdf6 with SMTP id 4fb4d7f45d1cf-5d81ddc1b64mr52513069a12.19.1735232177003;
        Thu, 26 Dec 2024 08:56:17 -0800 (PST)
Received: from [192.168.42.17] ([85.255.234.252])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80675a6d0sm9384689a12.14.2024.12.26.08.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2024 08:56:16 -0800 (PST)
Message-ID: <d4d4da73-5d00-4476-9fd2-bee4e64b1304@gmail.com>
Date: Thu, 26 Dec 2024 16:57:08 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: slab-use-after-free Read in try_to_wake_up
To: Kun Hu <huk23@m.fudan.edu.cn>, Waiman Long <llong@redhat.com>,
 axboe@kernel.dk
Cc: peterz@infradead.org, mingo@redhat.com, will@kernel.org,
 boqun.feng@gmail.com, linux-kernel@vger.kernel.org,
 "jjtan24@m.fudan.edu.cn" <jjtan24@m.fudan.edu.cn>, io-uring@vger.kernel.org
References: <1CF89E16-3A37-494F-831C-5CA24BCEEE50@m.fudan.edu.cn>
 <abe46bc0-d4a7-4076-bed8-c48e0267ebed@redhat.com>
 <7556DAC6-20C1-4FCA-A9C8-633E36281341@m.fudan.edu.cn>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7556DAC6-20C1-4FCA-A9C8-633E36281341@m.fudan.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/26/24 03:43, Kun Hu wrote:
>> This is not caused by a locking bug. The freed structure is a task_struct which is passed by io_sq_thread() to try_to_wake_up(). So the culprit is probably in the io_uring code. cc'ing the io_uring developers for further review.
> 
> Thanks. This also seems to involve sqpoll.c and io_uring.c. I'm sending an email to both Pavel Begunkov and Jens Axboe, with a cc to io_uring.

Kun Hu, can you try out the patch I sent? It should likely be
it, but I couldn't reproduce without hand tailoring the kernel
code with sleeping and such.

-- 
Pavel Begunkov


