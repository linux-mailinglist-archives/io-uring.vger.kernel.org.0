Return-Path: <io-uring+bounces-9312-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E5FBB38803
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 18:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A4805E22D7
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 16:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B09D17B505;
	Wed, 27 Aug 2025 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lMjgasPF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE9428137A
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 16:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756313410; cv=none; b=lrffds+Ezqfl+6JuB4dAr6tqhXVOEhvKzf9Q7sPIErdtGiiiM6HHRMuRAemU3D0PA+yJFWDL/p4NjXrjE9BMiDxk8GdcRiva2voI4xBJYZFWCYO/79ktIexsCtwPRvBY9MVoxpAPbBk2dZoUJ6aDnjcp3Yc9SyF/8m0HwyXATgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756313410; c=relaxed/simple;
	bh=zQ/6eB+AtlfHDYKYVIlVZNxEGLb+yzyiWFh6jLZgDTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IXq92tn5NRlbu6j2l6C9rZJU6EAUf4LeUvUqE9l/DJKcYHEjIgzpZWv4h0+JLvMLOlG/Va5pcWcOSWPibC8QA4Y8cN4DSAQKahHiWEdv4rbQN5s485xVFxBvvlpeO9eW7GHtman7DSMZOKtoA7NXqlOiTOZcWQQI5pIo1lzme78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lMjgasPF; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45b4d8921f2so52265515e9.2
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 09:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756313407; x=1756918207; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q96vOcoD4JTasnUlU3Z4LBe7SBkRea3cCiOBpUziV7I=;
        b=lMjgasPF63Zga+QUOx/cvCumo0xtHcOMZnI9funqpm1NvorsnNN5oKikxeYxzxvhYX
         pYpN/MB7NH2LUi9M/oquVHEncgGca1bvZWQRqOoWNEiUgw3jm7xPK+yCiNiEEXE+irTj
         ACUpzf9m6UeFOhUrpfRdrfbgnziXVweq1L4Z3ZVaFcMm0ya7leQ8zzHlWWTYv5rv2uGb
         z9a3Lo+GpfyIk2HwLxPtrbUyOv4bVGkGFnttlFhk91ViAV3FEtNoGaP0gdal53CwHuhk
         z3+lNvwIXKPvNx9MW6ohabn9uBzYjvO4pJAWZmMpVfSTgeWQG4pFk+W1U6arx8fRDteE
         oGcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756313407; x=1756918207;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q96vOcoD4JTasnUlU3Z4LBe7SBkRea3cCiOBpUziV7I=;
        b=Vy9ZKFifT+Z7vc8zs3LFE/fwzlnsctGDZFWfE3fKQMeU4UM1iZPZtr9amUW3bkZYEu
         bMNgdY9Ceyq5tP9pp4wxjPPoF5vfbW8dWEtq1e7Ulrly2IYZ0ZPTnmBPvE3+ZDg0lzCl
         x8AYOrgnTzVbd88KbmPC3pTzUhZxt2JGWRsu2WALqVbo8to6oeup55oat9S+cdG4XhrB
         FaB7ebOggg698WImL9KL8ilaFMbDTQkmgYp5nNBQJADcs5k2xpv1MQIoKlX0MozAiMFN
         0oi9sqPzcmOu8w+ZvnTYBos88LKhHhzRz09m1LZWYkpyPXmiBQO+ZWJZJSozCG4zeZDO
         +dVw==
X-Forwarded-Encrypted: i=1; AJvYcCXt3tulBXEjeCi7vvpxh5LSJT1/fqMBFt8DAR6B6UzFmb3fi4Kp2yunnbBPaScwHrUQF3aKi832jw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzcWj1i7foPiPIHHUu0wpHTtS56UWPCQXsklbzdH+zVXAULH4Yt
	4Ddt5Jve41n94RdlAadpLkVZj92RjZWVjm+e4gYn0d4LaJUcHHQbslfj
X-Gm-Gg: ASbGnctP/NV/9ix1RUP0OMSzBwfXRdoLxGwAFomunVEOqFlsyD4z6YoGsHQ6aMD+GL/
	9F2smOkWp8Me0gNGg+1mc1pbFpiocOKZlZQNkqfZnz0oMQmwc1HXHZ0iDTjGyYyumm9b8es3RgH
	h5JFfIpvLNaxL6VUbdHm6Xgtc4P/tpVv26kpsY2c6Dx7QYhy74960Nz6aWq7HhskGdqAC/+6BsL
	3AdKAd8A0uTyWrSF/sFvcpRexYliTMAMvvop2WagkkAHLpmdpK4LkTExaa69JTcNk/BRLl6SaU3
	Gwz4sVCh28FR6odvd9YWYMIXw9YjkEh3F9aBzS+Gndy7DBli2GIgOOBaL/kqzO4x+5HoSynkoDm
	u7qSamcZVvLGicqeF9uM2UuTzlwZF+5ym126ZLIsYGm9a6M7yiMx8VstRQhYdFPV2uA==
X-Google-Smtp-Source: AGHT+IFdR4hs8y+aAef3lFTJTgOfrbRqu1Tcn0OdtsISK/uxoK84/mD5yV7rV3A4vPM2CFoOjt+RiA==
X-Received: by 2002:a05:600c:4e87:b0:459:e094:92c2 with SMTP id 5b1f17b1804b1-45b517dd290mr162655915e9.27.1756313406591;
        Wed, 27 Aug 2025 09:50:06 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:ec92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ccf46fe4e7sm2835195f8f.11.2025.08.27.09.50.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 09:50:06 -0700 (PDT)
Message-ID: <5466143d-a9c7-4a8f-9e68-644eba7c98c5@gmail.com>
Date: Wed, 27 Aug 2025 17:51:28 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 0/3] introduce io_uring querying
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1756300192.git.asml.silence@gmail.com>
 <271e1f16-3651-4bb7-a2e1-ef447d37ba8c@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <271e1f16-3651-4bb7-a2e1-ef447d37ba8c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/25 16:35, Jens Axboe wrote:
> On 8/27/25 7:21 AM, Pavel Begunkov wrote:
>> Introduce a versatile interface to query auxilary io_uring parameters.
>> It will be used to close a couple of API gaps, but in this series can
>> only tell what request and register opcodes, features and setup flags
>> are available. It'll replace IORING_REGISTER_PROBE  but with a much
>> more convenient interface. Patch 3 for API description.
>>
>> Can be tested with:
>>
>> https://github.com/isilence/liburing.git io_uring/query-v1
>>
>> Note: RFC as I've got a last minute uapi adjustment I want to try.
> 
> Nice, was actually just dabbling in this yesterday, there are some
> half assed patches here:
> 
> https://git.kernel.dk/cgit/linux/log/?h=io_uring-features

I can add some of it if you need them, e.g. enter_flags sounds
like a good idea, sqe flags is probably as well. Buffers/files
can go into a separate type.

> Your patch I had the identical one of, but moved it to a separate header
> instead for adding more limits.
> 
> But I like your query style better than Yet Another
> struct-with-resv-fields. I think that direction is good for sure.

A single struct with reserved fields won't help with my main use
case either, i.e. rings/SQ/CQ size calculation. That requires a
good bunch of parameters to be passed.

-- 
Pavel Begunkov


