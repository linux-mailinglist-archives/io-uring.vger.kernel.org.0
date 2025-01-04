Return-Path: <io-uring+bounces-5673-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF583A016C0
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 21:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 788E03A3BAD
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 20:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAFC4146A9B;
	Sat,  4 Jan 2025 20:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LIqJO6Md"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196E128377
	for <io-uring@vger.kernel.org>; Sat,  4 Jan 2025 20:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736023438; cv=none; b=TK3qfV2fbTgF0ndFIoVAjfHvY/9gpKwvURwnn7oinCejXo9nqqFX+r1D001c8iDVd3ZBZS7EeCWqk5rml1jlbCheHMg45+Ic75kUvV7zbsagXRcOSW+ZVwyUMpUM51sVDEpVJcxKa9+XhiCq7ZSq8FEGveivA1dU8vLerygOSqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736023438; c=relaxed/simple;
	bh=uUVgWR021eUJHNxKyAbKoFmgzjkSoghAi7nQ06Uo2jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ji4fcB28YTnTEKUNbUw/geFMf0ncHBO/nkVTgIQF2gGHZr/KfIEc/JGhGWKbiwIFySlU7bivJJ8CH+WQIYM+cTfnE4zTSkJxGdUtnoWiStCZT91DqmgyWhgsQqL449uHAoXahsJlSpXpFWr5IKmUW3AFTQAquM+eVnmTmOwid2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LIqJO6Md; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso1451744666b.1
        for <io-uring@vger.kernel.org>; Sat, 04 Jan 2025 12:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736023435; x=1736628235; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N+eRY6W7g6OMng7DLhedZBfrWRV0fETCogCIiTPoQd4=;
        b=LIqJO6MdS0vjNT35RG89fuB1aGpgE2hKtCnpJ5use6MbmDtJ8VRlQNrbm6FQygcupl
         ieIbQTbocbHp9T5/mf8/ymkmaEOBaQXn+xZlEfB26Wko0TBdJt3V6hThqBz1Fq//S50f
         o5lYp/dFYe7mrnocNF4LbSSVP5aMVCGK6VpEk+yChKhHLLAj/HteCtJdI3iUgGg99N3o
         UK8mEVvEB04wwUQZTPTef8fboToj4PI/L9zY8S0+9FOKuyc2d6b8s0wiWUqA9ngzcxip
         bKlDAJMHMv0lWQNpJArA/HNfJdtMGywPh2c+dr9C8sv5A4Un09s1ivkHL4crECaljxkC
         6axw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736023435; x=1736628235;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N+eRY6W7g6OMng7DLhedZBfrWRV0fETCogCIiTPoQd4=;
        b=c7CQNnt4styEY1psYSJUzKReihNbC0mMJ001eAH9GJjwykjyyldEi2am3w0S3NnoXM
         gP3J0Q/6fsn5Vro0Du+iVpIioe3gJ+LV2LZkbyOIP6e43guGjJM4+H2TWaap/Lqy4GQU
         1GcsezWbhaFqG0KT3VeqoZGhtB/nNPS+cleSkgjWq6iOXPQFGuQ/32nNsqdws+bW3anr
         hHTJg3rrJv3mRaR4fLk/BI6/nap/oCfg2xjDA1pbI4Bqd2E8rqWT2DkTSwC+Kh4GGaEx
         v6czYz7MN+LgnBTPjxOC5w98NxeLY8QbbiRnG16Tfwk0veEKdfV+O0hzy/uDWcDfiqDM
         2t5g==
X-Forwarded-Encrypted: i=1; AJvYcCVadiZuQdiQPNHPsCnN1FxYXCfTx9aZxhooUl2kkNhVGzy/ymvTGEIeEwl8M9067cR61toJnlyXXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YymHji39kwTn3i0NNWqE1dV5TAkxn7WFAZmYNkz57RjS3dP+brJ
	qNjf38TWHRmzGRNGgSvhXY1L/XkNVZgQw4w0unaMdzxvTezgBHQ5
X-Gm-Gg: ASbGncs+67pUfg06InrZN3pD68NByKlk8b3czpqwl+Ynq+/1xw03O92UmRlBxeDa9/y
	c5+Qk52RtppmyIQiQ5FGvDBnHxQfeDK3rPBo5I6Ui8E7bdYCEwzW938mtXMBfq849eOLOlREGef
	5mSotkZ1Lj4rxXmY1ZcItP03pP2VywbDKB7RoTcOzBo8zZL9+bzd5lI6W1pOYsFNQeRz9ei8jA7
	aI4bKqMPz5TYqWsb2PTZSzBcuDfq2DwPyK5hjguv+UOR+eASabXiOsh50f1mf5MjA==
X-Google-Smtp-Source: AGHT+IGdFWLX00yWicco0IQoNV6cGIWgsx8yJAwpT+zZPHj8BxNodHD0lw5xgmf5rQtWN9EaoiJ6PA==
X-Received: by 2002:a17:907:944d:b0:aa6:84d4:8021 with SMTP id a640c23a62f3a-aac34a07e84mr4643466066b.61.1736023435109;
        Sat, 04 Jan 2025 12:43:55 -0800 (PST)
Received: from [192.168.8.100] ([148.252.144.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e8951ebsm2035200366b.71.2025.01.04.12.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jan 2025 12:43:54 -0800 (PST)
Message-ID: <c9b2283b-b1ad-4d7e-8042-98fa9908d9df@gmail.com>
Date: Sat, 4 Jan 2025 20:44:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/timeout: fix multishot updates
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Christian Mazakas <christian.mazakas@gmail.com>
References: <e6516c3304eb654ec234cfa65c88a9579861e597.1736015288.git.asml.silence@gmail.com>
 <e37db82f-6ed0-42f1-bbe1-052c64c4dcd3@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e37db82f-6ed0-42f1-bbe1-052c64c4dcd3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/25 18:39, Jens Axboe wrote:
> On 1/4/25 11:29 AM, Pavel Begunkov wrote:
>> After update only the first shot of a multishot timeout request adheres
>> to the new timeout value while all subsequent retries continue to use
>> the old value. Don't forget to update the timeout stored in struct
>> io_timeout_data.
> 
> Nice find!
> 
> Do we have a test case that can go into liburing for this too?

Christian has a patch, I assume he's going to send it

https://github.com/axboe/liburing/issues/1316
https://github.com/axboe/liburing/commit/3a5919aef666bdf0202c76918dbb85f1a6db9a32

-- 
Pavel Begunkov


