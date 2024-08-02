Return-Path: <io-uring+bounces-2644-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70BD2946085
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 17:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 141FCB2371D
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 15:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C50C175D37;
	Fri,  2 Aug 2024 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fCJcFko0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E230A175D36
	for <io-uring@vger.kernel.org>; Fri,  2 Aug 2024 15:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722612594; cv=none; b=daJd2y3ZbzD7+cVivlGYUNfa2oRBtLdNLEV77iLuQLaL5Nm7ycuRb6vGUILjpcHb9LS32kxozt/ODkVeHnth5/XxWr12HIcD2OZ7Ac4lOMMskDCWmG4aVYupnhQenUfTJDq2/dbAgeFCLDMIJMNcxXa594r9FQ1NkisdXQrkJvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722612594; c=relaxed/simple;
	bh=7nQyc+bXrfH4y7Wzlxvafv3cwiT3k6fT2tG+6S7y2h8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=abXpnzWjB8sdGvO/79D/mx+rxu/82SdYxHIdyV0qwCVVnIMqPjCIFaesBv+gyzsod+KYkBqrVogsLjuRv2q4TV7JKsphjI1WXr63MwueHgL2gTxNt11JuIsbrkNfqpaBLgBezryToeE0cugR5SzbX5V3JK6xHe44W7LLXulgx88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fCJcFko0; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5a108354819so11918353a12.0
        for <io-uring@vger.kernel.org>; Fri, 02 Aug 2024 08:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722612591; x=1723217391; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XBQk6DbXDqNgj6bhpcaKFcmuQ/eujDaq3jcztHQOTmY=;
        b=fCJcFko0rgHbx8I3AW8L38/U899455CfWpdvNx5xwSKXg1kGrVFz8ciBcuQyuRgqvv
         bTo0iZ5Bt9c2Htu3j+dVXOuxQN7Hg4ZD4TevVvySe9izpYXUMV1LUE9WJAWuZoNstpfb
         CyRJgugWJEmztkeEWmE7yWOTD+uHJ1QLMU16eFt/uW/FALT0plNTyvLGxIiPDDf8mhHa
         oO6CaXTktN2S9pes9ZM1Kj5WNw0Y43mba6uSdLu5yWLMzCF1arvfxFyObJGExULXQv1/
         bDPDM6T0mgyGFf/ZwTURWNW1rlqe8zvphs6NezxUU9kMzxU4EbJIM9KQZV8EPoW77OL9
         8sBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722612591; x=1723217391;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XBQk6DbXDqNgj6bhpcaKFcmuQ/eujDaq3jcztHQOTmY=;
        b=mkwjylqtuMSeih/8Bbru3ny575rPgT2Qtb4olT7OJyDr+8xy31USTYZgVO1DB3a9Ur
         /3VA94l7KJR81H0FnrxBtmKLCZEcOpyrM6rLggkaRkUoEEbmkIwhODhPW/ib8xKWQi7+
         3PC+PpQ1o4Xnm511L4/Wg6eI7uFIPTRezd2ZClGN6gsiB2uR1Abn+cK3nqGnCtmBoedQ
         0U4akbc8tZ0h0KhnQ7inwW3nqj0QOI/pKr41kdAVblnSjp8tcLAhuNB8tc1g1KeHb/YX
         Z/R3gDe5x4cGMug2q19dl5c9W+5Aqlxo2q+zuwSm37fBoimseZXKLiaAH0yhBAg8jt8G
         UO4A==
X-Forwarded-Encrypted: i=1; AJvYcCUAAjXz4ZuMcFZC6lL0OHDvM1mJeWnnvce5qjQr2Xq7BD5eoQif0yutFSvbiRhjCpMjfbN6+Ip6/kULLYNCvpGEIQ40OmlTci0=
X-Gm-Message-State: AOJu0YyFX7vO4VU4Ws1e6HvZtWzsFG3lpMH/fUDvlm7dwS1Mccax4FFi
	qJxlTdi7EN+Jn2liQvy/61Okd8eLIhl8VLlWFOL7x0jbOm4gTliO1VD9AA==
X-Google-Smtp-Source: AGHT+IGdEUj+57IEt74LcBn7PIztW4FO3vQWwpb5ICq7x73LxZEaAAJ8BMLx4IoVouKp46B+KXtAlQ==
X-Received: by 2002:a50:fe8d:0:b0:5a3:b866:eae0 with SMTP id 4fb4d7f45d1cf-5b7f59e04ebmr2876587a12.32.1722612590803;
        Fri, 02 Aug 2024 08:29:50 -0700 (PDT)
Received: from [192.168.42.144] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5b83bd4566csm1244048a12.85.2024.08.02.08.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Aug 2024 08:29:50 -0700 (PDT)
Message-ID: <97ac390b-7d7c-46ed-aa62-1c3201f98793@gmail.com>
Date: Fri, 2 Aug 2024 16:30:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: do the sqpoll napi busy poll outside the
 submission block
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <cover.1722374370.git.olivier@trillion01.com>
 <382791dc97d208d88ee31e5ebb5b661a0453fb79.1722374371.git.olivier@trillion01.com>
 <eba4f346-ede3-4d1e-b33d-f07227982355@gmail.com>
 <88b3d7be16b7e4fe788730347dd1b902a75423f0.camel@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <88b3d7be16b7e4fe788730347dd1b902a75423f0.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/2/24 15:22, Olivier Langlois wrote:
> On Fri, 2024-08-02 at 12:14 +0100, Pavel Begunkov wrote:
>>
>> io_do_sqpoll_napi() returns 1 as long as there are napis in the list,
>> iow even if there is no activity it'll spin almost forever (60s is
>> forever) bypassing sq_thread_idle.
>>
>> Let's not update sqt_spin here, if the user wants it to poll for
>> longer it can pass a larger SQPOLL idle timeout value.
>>
>>
>>
> fair enough...
> 
> in that case, maybe the man page SQPOLL idle timeout description should
> include the mention that if NAPI busy loop is used, the idle timeout
> should be at least as large as gro_flush_timeout to meet NAPI
> requirement to not generate interrupts as described in

Would be great to have, I agree. We might also need to start
a tips and tricks document, not like many people are looking at
documentation.


> Documentation/networking/napi.rst
> section "Software IRQ coalescing"
> 
> I have discovered this fact the hard way by having spent days to figure
> out how to do busy poll the right way.
> 
> this simple mention could save the trouble to many new users of the
> feature.
> 
> I'll rework the patch and send a new version in the few days.

Awesome, thanks

-- 
Pavel Begunkov

