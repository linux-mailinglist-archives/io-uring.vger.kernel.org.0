Return-Path: <io-uring+bounces-930-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6615687B32C
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 22:02:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E92EDB248DA
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 21:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 245C04D108;
	Wed, 13 Mar 2024 21:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2ckbse8f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D657812E6C
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 21:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710363737; cv=none; b=KlnoUhKiQlWm8il5PYJOyiQTCguu+Pb7SiS6d6HPQHAPmm7y/U9o6kDL7FXMwrBoEXc+dwRkYeHdIhHuLfPvPWDr0lZ0P9PTqtwNKvkg70Mkb/m04wh6vvRxf2alD6GTNxRw4Ov2Pm6o5Y4cwdfKwTtySD4inMUPUNzeysigZBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710363737; c=relaxed/simple;
	bh=iyz9P4KInbB1O6DlewC4GwQ/rqw5Jko3aM4KU3aUiec=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iUFmUwFpoTH7jH4LvQsC1qH/4zLMmT5ZQAcPMh1gKSrmteGpSN5JMWhGgy7OmKo5D/YsdNUmX78kB70sD1EVzTTNN1eEmSfY071HWasNG1lSYg90a9CDht++9NBci/4WqtWNHinh8zbmzxcdeKsOuQ4mDMHGXt4WX4KWhsKrdSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2ckbse8f; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-36649b5bee6so480325ab.1
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 14:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710363734; x=1710968534; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PeycnzwfBOOn0wt+ZlTpRhuxn0cXVdFxVFyEIxxpJ6w=;
        b=2ckbse8fkhiimkTkZ6ijdHT5ng7YCIZOba4hV+FkjzpCR9WIvNohcGJHMAui/0xbJ8
         eaprW/So+ET2Jof0fLja6MyxZoGqef4ezce9x8rKQCm/fmce1lK4pt0ZS0ewX+c9oxt+
         wSKRtfU0Ky0WgCy8ZObCZLFfLvvrJkgE8XMKUEZBOquPPxvQJSW0jdRWGKi40WbUkTfI
         qJ9OZTu29Bi3JO6OtzoNZyk2+cEAWSwkEHyMV3qYksrojb+bF7NTMKuvsSAMsxbtagu6
         faQOJNKnpdgBFgtfCtzAXzDLuNGgj8U8JUOS3Aoptgk+bHVf/9hCddZGT/5IM3GShPgR
         y3Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710363734; x=1710968534;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PeycnzwfBOOn0wt+ZlTpRhuxn0cXVdFxVFyEIxxpJ6w=;
        b=k+YQRyGv4+cdX75DmhWqID2HgHVF4Vw8coNc/qiAz6bURsgkaOtyLvVMBQy1g1SEdp
         kqhHE9MmkvPLwKx9GbpQMrOBZo1fC9RYc3tnwQNyweiRiKcgX2+/XaH9Fq/LL4qshss1
         NwQGeT1XUhNCLPTp5MmKk8LlUwLX3D4t+XoVSti1sAAsqM2Xvss5MnmpwskvF8acR95y
         SxBsvOmsDMMDUKrM+Rfnoq+5sPZq9tq7NLim1AlJ1ha/VXbRcehJlbkrUm41pqL2GnaO
         qz3Cg/g+gKu+augAcGeil9o92RmtDYA7KG0xx5tomRfnBGkx0Np6B9SuU96672oZDqUF
         PS5g==
X-Forwarded-Encrypted: i=1; AJvYcCVfbBJSQQ0ltpMH1ADgrgeK0Yx1ktIVVaQ6GQf8ZWfZ+5nE+75oVA+0jgbrfr+sDhuU2CdfVDSdfqZNZZszhXF8xbkws355VR4=
X-Gm-Message-State: AOJu0YwS6KDbzeU9B8ZCHiOY4Fqg9UQa9sX4hoT1+thbH08ectBvPaM1
	3TAODi/Sz11lZNLGMTzo8XbyOq7jpHb5tXvRhmwMxcPv49ZwbRJL9ooetpiF61E=
X-Google-Smtp-Source: AGHT+IGjaECkZ/VqaZQzV4aGbvR+fwN6DyY7mwZRLR0Gl0K0vQMPWwC+OOfkNMxPli9givnMxsY9kg==
X-Received: by 2002:a5d:84c7:0:b0:7c8:9e3c:783 with SMTP id z7-20020a5d84c7000000b007c89e3c0783mr173725ior.0.1710363733948;
        Wed, 13 Mar 2024 14:02:13 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k18-20020a02ccd2000000b004767d9bc182sm2967056jaq.139.2024.03.13.14.02.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 14:02:13 -0700 (PDT)
Message-ID: <d494127c-1b98-409d-8ba8-ea262bed62eb@kernel.dk>
Date: Wed, 13 Mar 2024 15:02:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: simplify io_mem_alloc return values
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1710343154.git.asml.silence@gmail.com>
 <ba1f5a30be45eec6cf73cfdbf4b4e1679a03cef8.1710343154.git.asml.silence@gmail.com>
 <af4cc4db-b8f4-445a-9ed8-f2eee203eee3@kernel.dk>
 <c089d416-f5f4-46d4-8e6f-9ea773d44c20@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c089d416-f5f4-46d4-8e6f-9ea773d44c20@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/24 2:43 PM, Pavel Begunkov wrote:
> On 3/13/24 20:50, Jens Axboe wrote:
>> On 3/13/24 9:52 AM, Pavel Begunkov wrote:
>>> io_mem_alloc() returns a pointer on success and a pointer-encoded error
>>> otherwise. However, it can only fail with -ENOMEM, just return NULL on
>>> failure. PTR_ERR is usually pretty error prone.
>>
>> I take that back, this is buggy - the io_rings_map() and friends return
>> an error pointer. So better to keep it consistent. Dropped this one.
> Oh crap, you're right. Did something trigger it? Because tests
> are suspiciously silent, I'd assume it's not really tested,
> e.g. passing misaligned uptr

I was doing a cleanup on top, and noticed it while doing that. None of
the tests triggered it.

-- 
Jens Axboe


