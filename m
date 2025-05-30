Return-Path: <io-uring+bounces-8140-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F5EAC8D7B
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:20:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 851DC16ABA0
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 12:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF9121C9EE;
	Fri, 30 May 2025 12:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="izatgfd7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F1D2DCBE3
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 12:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748607650; cv=none; b=C5XHWmeU/yd+jGw6FZSLKzOlDe5XVXGlI1FloTGl8JeVHYdVpi2JGMvk8bc+kaOtt79d3T1BOyLASm68nvZ8GUERF5OB5pDCct+PRQ4Pg/w4b8WAOFfTqtJSr2CSyl21uJm1WW4mOyW2jLYSofjPEENhBMfdACPOz0OB96Qq+kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748607650; c=relaxed/simple;
	bh=NUSWpgLoo0+tzqXfBLuOCsqYBEll1jz6vXByUEPvfgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qBLY0LNxQpKSEjczBZayvYt2jNAiE5q/0+hms8fiMVnLMxLQC+cpjphVfJzLoy9zvjst38QovEJcwh4pnP5UZfLHUUdWeeby+AhlZdIbW9LWgd3Dh+GkeitFMIkXe5LXL7Bz3YsQcdfAb4cfgUaud6LOOTrVOxgAx6Ilxbgh+s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=izatgfd7; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ad5273c1fd7so406707166b.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 05:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748607647; x=1749212447; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=se5/jo2ojUZV4aNB0pKWhNrn5tuBhF6oxNdQAh26f6E=;
        b=izatgfd7nwtpdbKwK4agEPu/GTW1xHby6JvTrR8c0pTu9436X4iIQCXvfmnade2tdJ
         Ln9U2JLXfxMVZH6Evk1anVstNO8axS5K3q61huoz9YdWej41ekRk/gy2zq4JmOB8jImN
         S6m5cxuA8Y8MpMeIRsjVdlLfXN1o5aH/P4yY9jBLYEEZ+DfbSqIgUdWgoBp5fB5lPbdX
         d56QLjNVUxT85H1DV8i4W51B3iswNL1beHzlZAif+uKypzCL+43qVu1JgQunzzyy8xR9
         hsW5y4h9jF7K5UMkFYZzU7peP6q4/FB44uINgs+i82Na4KTClY46qzrNBsiSH1Vmz605
         NHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748607647; x=1749212447;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=se5/jo2ojUZV4aNB0pKWhNrn5tuBhF6oxNdQAh26f6E=;
        b=KeS89CoL6cwpPcg2hJfcUqHK74KIjTP7VpzJo+m3cTWN+h8aw2PXyUsK1mMwMgjp2L
         GiwSRklzepNgKSdUfmTyPwa2p7sLUua9qjuHbEywGj+M1j/GLJu/tuWzJZZTHuYA3dcs
         N25oMKWpUZSYhsPtTRRMvcUTJIn61lffUPyp9llk8OFcvmVoayi58B/NIwCLeOqdAweH
         aew1Bb86IPkGx3B0DP3ytAo7dGeCm0XR1F3y8b1OryQagrq4aHdlhbi1qDYvSBlWkFdb
         Gv5xCaEY8aiQMFMKueVh9WL8vbMjL/GBYS5TA1++QC+rITv4GaqkZAdYDU9INK7q9X1y
         6V1A==
X-Forwarded-Encrypted: i=1; AJvYcCXF9bzQ41JtUCjS48h9ThSYuMRQqdj6oXIsTxMVWqynu97/6h+V4aIUsp2iB1CyO7gRfLNDb5cyDA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCES2kWTUx1+CWphPc+OYWPYxQEHthpFvbJdCzMP6a16RoA5gB
	++ofyYH69QgAc/eO2XRtnvEAEb0GHvyKFq7RRJKPwGcX242hgkUufTS/Esz81g==
X-Gm-Gg: ASbGnctAVz/hEph/XTi2V7DJmn90/sfo3INwraz1c3m/nso9Z2rO+2rATvK31UAaDRG
	HRpr2IyZ5IuGexVPG5MQC5Eo7I2nZ9LEeqDTR/KBdq8LIjBhx5WhEO4mDUU+K5Y6VEd+cZOPeSg
	r77uRFZ/Ux6u5S8wJRHcaGWApBqF19mFhSMK5v5zzN7qiAUXzBXXlwiI2Wz9fw0tosdLIBclk0N
	TGFCiTAk6NjZZNdi9UeeaczPeUgFnctvFTW3ykc/Pn7jWFVy98GKs5lvveT/1NujEmzAxA5X6Ow
	dVgl1s8weuW77jHUMgNaQSm2bm5C5vK1e429MnIqBrS94MKvvtuQajpzO8z8D9gf
X-Google-Smtp-Source: AGHT+IGkAXDt3+P0+2oydRdsGrsLChQ3VBhP9yMkqrtD50WjzOqkxdksTzcJ23sZvx8kquPMuXWEYQ==
X-Received: by 2002:a17:907:7203:b0:ad5:8594:652e with SMTP id a640c23a62f3a-adb36ba4b75mr166832266b.35.1748607646953;
        Fri, 30 May 2025 05:20:46 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::15c? ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad6ab06sm319042866b.171.2025.05.30.05.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 05:20:46 -0700 (PDT)
Message-ID: <d367cb31-32eb-4d69-8d71-03ea8c18e11b@gmail.com>
Date: Fri, 30 May 2025 13:21:59 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] io_uring/mock: add basic infra for test mock files
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1748594274.git.asml.silence@gmail.com>
 <5e09d2749eec4dead0f86aa18ae757551d9b2334.1748594274.git.asml.silence@gmail.com>
 <f3941c74-5afa-43fe-93c1-f605b4cbeb82@kernel.dk>
 <7518de34-8473-4fa0-9a3f-42769de4c03a@gmail.com>
 <fdb9c49e-b8b6-42cc-8a6e-010d0906dbed@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fdb9c49e-b8b6-42cc-8a6e-010d0906dbed@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 12:48, Jens Axboe wrote:
> On 5/30/25 5:45 AM, Pavel Begunkov wrote:
>> On 5/30/25 12:31, Jens Axboe wrote:
>>> On 5/30/25 2:38 AM, Pavel Begunkov wrote:
>>>> io_uring commands provide an ioctl style interface for files to
>>>> implement file specific operations. io_uring provides many features and
>>>> advanced api to commands, and it's getting hard to test as it requires
>>>> specific files/devices.
>>>>
>>>> Add basic infrastucture for creating special mock files that will be
>>>> implementing the cmd api and using various io_uring features we want to
>>>> test. It'll also be useful to test some more obscure read/write/polling
>>>> edge cases in the future.
>>>
>>> Do we want to have the creation of a mock file be a privileged
>>> operation?
>>
>> It doesn't do anything that would warrant that, maybe just yet.
>> Do you mean from the security perspective? i.e. making sure a
>> user can't exploit it if there is anything to be exploited.
>> I'd really hope nobody would compile this thing for non-test
>> kernels. Maybe I should make it dependent on lockdep to enforce
>> it.
> 
> People do all sorts of weird stuff. I know it doesn't do anything
> that warrants making it root only, but at least as root only, any
> side effects will be limited to that. I think that'd be better than
> making it forcibly depend on something unrelated (but debug'y) like
> lockdep.

I don't hate the CAP_ADMIN idea, I'll add it, but making it
dependent on something incompatible with production kernels is
the only way to ensure it's used in the intended way.

-- 
Pavel Begunkov


