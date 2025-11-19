Return-Path: <io-uring+bounces-10665-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DAB16C70BA4
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 20:02:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F27B44E05F1
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 19:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CACD6314B7A;
	Wed, 19 Nov 2025 19:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OqyiI1T9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F46313281
	for <io-uring@vger.kernel.org>; Wed, 19 Nov 2025 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763578850; cv=none; b=PGptNNViQxx4IPND5J88+eRezZJyDTJhEKwFdc43Yhsaj83Bg4juUnJ6DT4q15iDDArWozg4+2PG8EDG2hGWHPn8f3+0b5pwf1PDQwpZiZZTvBb9WdqduIb84rDNQaMTVP8ZcuelFFV2Xi8CGPgmFEYl/MscX8nScCzOvVL7sxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763578850; c=relaxed/simple;
	bh=yf4LyyvVlWQlF+UYEilqMI+US78Bu+F8MQVkqeVDQxo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WSaM/4fql4nLo786jO4f9x91EEYXBBQgqt8sHgBbxohKPFFKp3Xjg/lHYk3TVWtPrU2DF4+x7724b10RS5Mug0207cxsPxYH3L1Z3SHO/17ILSyA/qbzFPPIQAxJjQUX4k2yQaf5Vp/KHiSb+fgWB+jFTAg94tpUV4qwT5tjQKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OqyiI1T9; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477a219db05so678685e9.2
        for <io-uring@vger.kernel.org>; Wed, 19 Nov 2025 11:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763578843; x=1764183643; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qFwRgnhOH4KcFWEMp/9tsUsQL7kS/IiEkrujwfXANQs=;
        b=OqyiI1T92cAv1Dr0koyEKJXXs94hQ+CGoww9ZuHP78u9Wl2zd8OKmpGAYcoPR3EpJ2
         2XmNYz+1ylIMXRdAT/Y1QzfFdQ71U0q3z4HCOXIOjkWFwYgYTmAow/CnfPGJzQTMUSCK
         NJBncs9T4LKjjd/x5koB9vyFcD7eIQPxJIuJd5zLpQn2o0RhaQCtScoiYloPJuDCjpwZ
         oG+cosZc2rtpQm1NRXY8L08JJwOQA9VLMm0D76FTlvamSZVuN6sMjra967ge0WMLzBKO
         HTBwIk5FdW5j71MiLdNKA7qMlpDMKSXLlaqe2CmRCRelBCwcl2oUI+89jlQzW/9HHW5Y
         lT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763578843; x=1764183643;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qFwRgnhOH4KcFWEMp/9tsUsQL7kS/IiEkrujwfXANQs=;
        b=A890qqUkakRYY+czgO2r5NefNtpkjWffSqKa6+tK9nMD1NWVZQQ0G26O8ZR6fO8fsD
         jBpzue/GH2rgHi6QuTkCZTzJEnLAvU+k8mUtg01YUpUhddxBeZvL6AgNvZ7otJMBoMK+
         AQbrA9+rIt7FK2xD2N8beo10jVeTLpYoqHPIBa7waMeVN9L804MSJX66Wgra+xf6zzUd
         4kHnkPF8qHHYTJbGtgK9QtDytK3+4SsFVNvFStdNTQ0pVMNqxlMXO8FD3Zr81X08fZKB
         ui93IuPNODSH+NKbnqbdVerfEP6zYE/cvRXvfePfg+DDXULjdrzm7ivXc0viaFYweuZh
         QKDg==
X-Gm-Message-State: AOJu0YwCsUE/w5manqinJYcl/rgbIEzQqcP5JgW1u7xmDDQYgULR2q7L
	d82T09IZYl8C77Qy36xWCSsp31GiV4MFgs6hBllESZUcHghmlJL52JMc
X-Gm-Gg: ASbGnctiW47MfzM0dK+9xaT8ZrlUIP8ih94bzzsHSUlOYbTbgclpb6E9UTzGtaPRxqY
	WJ0xkwnwN/bkNcC5Im25j8ud+hU2nvgrr4e6dDYccvtenvQWlmbkXXWtaPopQiLGryhoPPHLHj6
	xATeWYwz3+xXUHJBCnr2bwiYiNkud2b4HrsRUN7LN0cMbMTK+dTNUsz2RGuYdyowdz/l2V2Ay/f
	W/s2V1qf8Byx385I+pO/1bxX9AyniTrSI2JxHo2xVq7cFhvNNcpQKq2ugIosKw3weaO0CXGjQ97
	OBjXIo24RyUED8iHb/gFIm0kh6wiLdUwIzJUNLeoYI9TMFfUYvErxTA4yAvWhVK2tMP7oJ67e9V
	APBkjpP6gWXXQEokriMvbIAIneHy21bpmxnc/Fd0ADv6N6CTHoRWO6CElQj1O2mtf3AZP1iIrO3
	xsZJpRaEHpry/PGYo2YWxY9iD0adQrHAwWv2vvyrPjKrhCECDtrPNamuFOSRxZpGvcsi2Xuesku
	Qy0wi/T1QA=
X-Google-Smtp-Source: AGHT+IGCe0gTeePeQC4mLZ4ePm5f0zDzhQlwMZyB9V0M/207bFFEDqn8Z39MIC1pmnaZNnQI+Ifdig==
X-Received: by 2002:a05:600c:450f:b0:477:7768:8da4 with SMTP id 5b1f17b1804b1-477b8671900mr3444735e9.7.1763578842970;
        Wed, 19 Nov 2025 11:00:42 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b106b10asm63098875e9.10.2025.11.19.11.00.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 11:00:42 -0800 (PST)
Message-ID: <82fe6ace-2cfe-4351-b7b4-895e9c29cced@gmail.com>
Date: Wed, 19 Nov 2025 19:00:41 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v3 10/10] selftests/io_uring: add bpf io_uring selftests
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
 Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>
References: <cover.1763031077.git.asml.silence@gmail.com>
 <6143e4393c645c539fc34dc37eeb6d682ad073b9.1763031077.git.asml.silence@gmail.com>
 <aRcp5Gi41i-g64ov@fedora>
Content-Language: en-US
In-Reply-To: <aRcp5Gi41i-g64ov@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/25 13:08, Ming Lei wrote:
> On Thu, Nov 13, 2025 at 11:59:47AM +0000, Pavel Begunkov wrote:
...
>> +	bpf_printk("queue nop request, data %lu\n", (unsigned long)reqs_to_run);
>> +	sqe = &sqes[sq_hdr->tail & (SQ_ENTRIES - 1)];
>> +	sqe->user_data = reqs_to_run;
>> +	sq_hdr->tail++;
> 
> Looks this way turns io_uring_enter() into pthread-unsafe, does it need to
> be documented?

Assuming you mean parallel io_uring_enter() calls modifying the SQ,
it's not different from how it currently is. If you're sharing an
io_uring, threads need to sync the use of SQ/CQ.

-- 
Pavel Begunkov


