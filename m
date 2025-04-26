Return-Path: <io-uring+bounces-7738-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A840DA9D67E
	for <lists+io-uring@lfdr.de>; Sat, 26 Apr 2025 02:00:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 186A29E7CE0
	for <lists+io-uring@lfdr.de>; Sat, 26 Apr 2025 00:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C11BA55;
	Sat, 26 Apr 2025 00:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JH4OhHbD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE59728EA
	for <io-uring@vger.kernel.org>; Sat, 26 Apr 2025 00:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745625636; cv=none; b=RjYVZDwadjC3rluOITipUy3iD0UdS2NP8VwPILF5y5iwOxl0IX7C6gfFzEiDkkPWiNuuSNzHWlsYL0CK8orljTsqExuu8v4EGOJtQxIyTNvVokddTa1srQrXrInJWe2GBls3eO2ToywN3Jxc7nECXmQfceio5TQHRbbo8ED3XJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745625636; c=relaxed/simple;
	bh=qnHlhlLFPZtAcMnKgVVbfAYSuj4vu1+LpSCyZE4Z43Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=n64TzZgmL8RzXumX8U43DM/CAb+qkhGISy7cNpAHdMS81q/JXS6Kxik6bDGT2lhTtgiM6faj9wQhW17WruL297jGmq8+9VV9eGtpaeKgXNDtvmblZ9yG5nSNzHjV9CApeyWHtkAl6RVMEYCfQVQ2qWks3Ucq1sNoQ3wz1nlJEQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JH4OhHbD; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9ebdfso3657673a12.3
        for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 17:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745625633; x=1746230433; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zeIXTXJd3Prz6X35PKEVAjILeLmP6A5S61VBpFiInVM=;
        b=JH4OhHbDbKSzMRtiORzu0WX/7UJcA65iG4YEGEX5ap5bQs8SA0MsWEIQ0HlWjwYVL4
         JtVxzMK2yJVeSAYw+zmTGSBVXsySBw/6mVoIMnAkj4ROkYcLGT1QFNY1k54Iij2B0Wa1
         FIlUJclfXqTopjeYf/9qdktMc2zN0wZXD266hp0l+4ZcVUBdDz4Hsj4u3VuZjlbSEXc3
         sOnyrEFL0+GVTclXRtzbgK8Eex2Dl1juG4R2XOFXlE1kL+XmnWY32Ye+iThHFVcTJgzS
         AY/9C3Ya2x+yMaH1tvl41r7xZOsCkxkvGvD+GqNpKKRnSqcqAoTRIF6MlqmlJzL7sMrD
         WukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745625633; x=1746230433;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zeIXTXJd3Prz6X35PKEVAjILeLmP6A5S61VBpFiInVM=;
        b=uYxAO2kGSHztCe4iCkqrHdzIxWFelcPS9yZPZdZpcNtd3auo+wuzorA398uLYyPauG
         YkIbZGewzvbGfHJtcJEbUxmkexBoptNchGFBxt4sEOksrDKnXWMBGg0mLxXV2amklAEA
         vSIGEBHxN2MzLYJQct/tYrkY0nXKBtLRo6EB45AvSSItlJ2RSdqceZ3m8+ADvAqHRQYy
         576DjfogV5k+UhsIxutsZHo9Jz2wZyWuPIysRj5tiYD/RskU4NsapE7XElgPZjP+zrWq
         PzG/c11PLj5s41rFEXeBXhYril46FiH0w6Wf20yVEAdSbbDvJVyr9W6fb2jSqdmLKLki
         eUyw==
X-Forwarded-Encrypted: i=1; AJvYcCW+VN2LfEBJy+KvcmbzrfcpsWqYshAzOfn8o34F1Qz3fGA8kjH3xkTd5iTG6YswJ8maiHtmNu/Q7w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7A4olQDvT7K+gDfbPuZXZYyi4UabbymgCSmMoKG0/sZLCGvtf
	QXtEHykSEhP5CeBXdmp2uw8sC0X54xgIgDpflYk75F5a/Uux1T4QOXCnBg==
X-Gm-Gg: ASbGnctVGtMUDgIw/2TJmlBiLrKzoGwgP8kFR9Amfmqqr8q330wQQoR+pKJ1w9gYskM
	pwGqR2ZVpHneZjHfTJ35O7T45NVELiPJqqLmvwUGKauurSiggu2YT2sEmpOet65JetzD9eAp/S5
	kmFDs2Eh5+uJJyme2DE0+XvD25FrpjcnPH/1cBBOHE+QONVGx72ScRp6BP8QHMkuzIesW8GVWuT
	ezzaixHq0WU7+coRQ87ydK+BgJkTPSV1JURWdG0kd1aF1AlN0SYF0qnVM3IEKdV46GEpmPfgcIx
	142+3FN2n8wYM9Ts7041/RJiSaUHYNdTV3hzbem6dUpXohHYfYg=
X-Google-Smtp-Source: AGHT+IGnI5nNkaRjFNvj8TYlO4Ow4N8CaMUHOo8aIBMcCWXo0U5xDzvHPmTVwGt/17St9F9iF1nBuQ==
X-Received: by 2002:a05:6402:3583:b0:5e1:8604:9a2d with SMTP id 4fb4d7f45d1cf-5f739596817mr863074a12.4.1745625632809;
        Fri, 25 Apr 2025 17:00:32 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.146.255])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7016f5db6sm1975859a12.44.2025.04.25.17.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 17:00:31 -0700 (PDT)
Message-ID: <11376d87-e8d4-4d34-ad4a-e7374b1ea25c@gmail.com>
Date: Sat, 26 Apr 2025 01:01:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] preparation for zcrx with huge pages
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <cover.1745328503.git.asml.silence@gmail.com>
 <b8bcb087-21c8-4304-812c-ecaaf2b2c643@gmail.com>
 <a803071f-01c9-4e2a-8a1a-d110b031b32b@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a803071f-01c9-4e2a-8a1a-d110b031b32b@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/25/25 16:42, David Wei wrote:
> On 2025-04-25 07:01, Pavel Begunkov wrote:
>> On 4/22/25 15:44, Pavel Begunkov wrote:
>>> Add barebone support for huge pages for zcrx, with the only real
>>> effect is shrinking the page array. However, it's a prerequisite
>>> for other huge page optimisations, like improved dma mappings and
>>> large page pool allocation sizes.
>>
>> I'm going to resend the series later with more changes.
>>
> 
> Thanks Pavel, sorry for the lack of responses this week. I will look at
> the v2.

No worries at all! Thanks

-- 
Pavel Begunkov


