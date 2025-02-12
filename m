Return-Path: <io-uring+bounces-6360-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B544FA32914
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 15:49:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 673BC3A8012
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 14:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509C021129B;
	Wed, 12 Feb 2025 14:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0fRCARd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C712210184;
	Wed, 12 Feb 2025 14:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739371699; cv=none; b=pw0ndCMpWQuNCtIFplVwuZFZI0hKZZp58QJrb+nW6KN25+3eE7FM7/Cg69K2Hro/wzzQ81XGxgj3gy9bYf/ksGE6+TkDETrq0Cl4dvEK5E6LJsSw5sCfFUxbkscZH3nmkgGEdBokCteCV+bo7BtpWbNLU9TrzJoCImqbiqCXeiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739371699; c=relaxed/simple;
	bh=tuQJK0sbEGkLj9SIylMNIS0Iy7Xw7xD+JRvfxiHLQ2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RqK88t0McWiVoMaFXV9bSl37bblF87lA1hrJ0nLm3yQ6eArd0WZztpHrBHzv4PgKZjt7HhwDwmfPLgUiJJI1njXgnK/5DV2FggePml5H7Vgdlrjv9G8YSk/OgTJTLVYfD3rPwj0eSDl8PMcjtfmpJ1L29BG4iQ+9/r/jcKuc/Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K0fRCARd; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-439585a0544so5913555e9.1;
        Wed, 12 Feb 2025 06:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739371696; x=1739976496; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y2x8j3HGyrFHdvcdJF68UR/CeuVosH6bjR10oLMz5Lw=;
        b=K0fRCARdy9Haq3TsKIGO0m6UQLQB94P+xwsBraMdAQDgtxdjlTK3Jr3jiiftYn2+Nc
         5ZDwVTCTNqi9wkfRW/t39yV2KDWnzUxGdpdLMM1T86w9Ypxm+W35yCFKqyA0Lr4ZWUR2
         xkMMxdTtyvzip51uauHcLVdggEA3twV/IE/w71Y2gYsgY0pCeqgzaIrwZ4gCfwd3OKIJ
         mxwHW2E2tlQ283lDSaqRxbharkLbM/qVbCaRSzXZU73DkmBERtpsFztIau5iY00xP6HD
         HKSyTnsUxm+MMqKMczKKGLh7BrFZKLmbHqfs7ArQmh2t3FNqpCPjyKZuVA4FZFyQxCz3
         dRkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739371696; x=1739976496;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2x8j3HGyrFHdvcdJF68UR/CeuVosH6bjR10oLMz5Lw=;
        b=LCbaYJNJcWiafn3bwKn2gI2NsIinDMDUA9ZhOy5Mo2Fu/VZanxoB2hFufGTzoEjCIM
         xQAODYsB1DZi9t67ZIZrQAP7QZppIZACm3LRG2EeF5e3F87DieCILXDLsRi8Av4g075A
         vU1scji0VVf9vyM9M0QDIVkpJvfAiiRtS7QF/YRhqb2QOVRdOel2IvinjOptouvCglJZ
         QS9OoCtKPX/DGVfAb8JEh/tBTymxQK4NE+2gphFQ6xGGBsSDWm6vWddfh6F8NY9xZnZf
         JuPAoB2D59OW7baL0nsz4dyX4DJGrJzeH5B8qTmdeyTrKY5dAtR10FzqWO7YY8OSKGpB
         eS6g==
X-Forwarded-Encrypted: i=1; AJvYcCV7H/NdEySYcqd6VeoDGTHuuVEEiE8ts/NdfrjV3jBy4mvChyXFy/BzCi4L6nwjIa/gOlAmteFgVteLGcI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBUDnN0r0cBVorRuw6lU57xAwxBaznWsg5OM1GS4q4z4XPDQB0
	Ksi+9xHFRETzoTEPCax7J97r467LO1b5ErXYgj8JW/4b34whT/jVxPcgCQ==
X-Gm-Gg: ASbGncvM5lX2CTSyBFV9rnRufDJzRg1R4wGqx/gkTh6gaQOeXdhcXOA824o3KWZPxYa
	T8TfR/oBRD68bRVYHNGFmnrp/R+82sSx1YwsTQaRKd+j9uw+/aEQPNgMcdiwUlHedrviJUylvZx
	qZe7YsTLQAQAcH3ZIHno0s2tEAPyu5kx6wkl4+CYYc5nO3nySQtAbV46p7dW6w4gCkcOg2NycrW
	TRtZ17nERdwC0pISDyqpi34nJ3/fkPRFwW8+y+sDxFHzmXgI8FulqAWeqqP1PZrW/mfRwUJh1cv
	QDHaGxVvOTpZXdTQxpU+qEdx
X-Google-Smtp-Source: AGHT+IHB/e/9gTceb+jimwydd9oU8n69LAwAWB0KLThc/ueR6akTjaedWGBwPVwdwZPr1uWMwy4BXw==
X-Received: by 2002:a05:600c:8709:b0:439:4b9a:a9fb with SMTP id 5b1f17b1804b1-43959a997e9mr32423585e9.30.1739371695691;
        Wed, 12 Feb 2025 06:48:15 -0800 (PST)
Received: from [192.168.8.100] ([148.252.128.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a04cd74sm22598315e9.8.2025.02.12.06.48.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 06:48:15 -0800 (PST)
Message-ID: <b478f8fd-d43b-429c-aa6c-1b94951421ab@gmail.com>
Date: Wed, 12 Feb 2025 14:49:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: pass struct io_tw_state by value
To: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250211214539.3378714-1-csander@purestorage.com>
 <8c21acb0-aee5-4628-a267-a4edc85616c4@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8c21acb0-aee5-4628-a267-a4edc85616c4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/12/25 14:33, Jens Axboe wrote:
> On 2/11/25 2:45 PM, Caleb Sander Mateos wrote:
>> 8e5b3b89ecaf ("io_uring: remove struct io_tw_state::locked") removed the
>> only field of io_tw_state but kept it as a task work callback argument
>> to "forc[e] users not to invoke them carelessly out of a wrong context".
>> Passing the struct io_tw_state * argument adds a few instructions to all
>> callers that can't inline the functions and see the argument is unused.
>>
>> So pass struct io_tw_state by value instead. Since it's a 0-sized value,
>> it can be passed without any instructions needed to initialize it.
>>
>> Also add a comment to struct io_tw_state to explain its purpose.
> 
> This is nice, reduces the code generated. It'll conflict with the
> fix that Pavel posted, but I can just mangle this one once I get
> the 6.15 branch rebased on top of -rc3. No need to send a v2.

Hold on this one, we're better to adjust the patch, I'll
follow up later today.

-- 
Pavel Begunkov


