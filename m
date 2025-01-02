Return-Path: <io-uring+bounces-5650-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D419FFB2D
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 16:53:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36CDB3A2644
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 15:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B63171A4F21;
	Thu,  2 Jan 2025 15:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZaS75PDz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09D0189B8D;
	Thu,  2 Jan 2025 15:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735833221; cv=none; b=Sgz83Awc7LcugyeT9/9lfye6KVOBGYf2TiuMLPZuPZd4HzlY4QHBnz9dYaaeHNg1GtPn4+EmtbVffjcywkoKIssykRTgOqtiiDkyo7xZvLngONweV0pr4AhGJNtNESQjGTyeALs6+r4oO2Pup1jC1eDlBJ6LR0qJ0QtQ6uiaMIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735833221; c=relaxed/simple;
	bh=4bW3Hs1kl8owelWIk3KD/ZOeoeSitiV6sBEKxMuPnys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pLQHP1byzM6f6Xy/41I+Rs9AkmbUcflGEtJtjYiYKdZJVQTsvisXIAptRj6IfOS6szM+8J7+VR6G6+CVhBztR6pInlro7UKpiE0Ln47GjPZMGOYI26RSaRdcfTzvJMsnuFacKmZ66Ms9WBSa1VI0yzMm80OKaxt19QZIDQWwsT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZaS75PDz; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso179757266b.3;
        Thu, 02 Jan 2025 07:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735833218; x=1736438018; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rrPOTO/QeXBP8E7EdYRGi7iZOWqbSgEVztnQmjBKmmA=;
        b=ZaS75PDzaP6Hj1vR85+ibxiLzpyFoceanu10vrs/km21Vc/dASS1IQTVo0xG5cLqdl
         NIyY7yPO1+0jy2YbcyYfnECajeHSKaXXSlpegiFxPynhhaQtogEmHcOeE4TLIexyY9ZA
         QdTtXFz7nmHPtRiEutf2vhPTPI7W2GKNkfeEzRpiz7vhrTaUio3lDbQmBum4yhwkTFJf
         D5mxydxjIxsQW10qv5T+/R9ILpJ0SzWyv4JNQwWfYHxFTuXDAiX8K73LTYXvor7FbIO2
         Q6j5cz4BD9vYhnMi88DSjXoiCQV059JON+Q5+AJUz1VZWEReasxwzmL5j5Vw729JPTHB
         +Rbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735833218; x=1736438018;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rrPOTO/QeXBP8E7EdYRGi7iZOWqbSgEVztnQmjBKmmA=;
        b=X9A4R4mtFGORfRdaIqjMXMyQqQ0KIR8JYMMNJMlFZJXfrqqe0Nc/fQSjObKHpmFt6Z
         jViiF54F/J0eDsec/aiaDfvXJxqWMjJDkkgaj6EEIYq16MUYYu1b7WRL2GkVgPLAOufc
         b4ZO1kbWsrs2Yiih8uIujfyuPNerufNLQiWRyNm9gvbgk7CIa0ub4zYUs1YZCB6on5Rh
         NQQmiVXHwCN8AWZ3kEQj1FKEfCm+SaY4SRgkDwRaV/EXTMSeRSVrfa7liH8wEvv2wRhC
         9zTtJm3JSPJs02uCkyLz0SQoU2K8w6mS+uwkiVsq3ICFe8zxjNfOkekWHwYtxMp7Iy3B
         saQA==
X-Forwarded-Encrypted: i=1; AJvYcCWgy1M1ffABLb1nszD4n2EGkgRMx4DaYrP8IRNCTbi7NdRHlN3YswaHqZ5klLNfbYp8PSIgg9TW@vger.kernel.org, AJvYcCX/5WXnsQQMnvsijUAzgAss+j1x+t1Gh2JmSSGbqpXB14tcq+4IkAJvVrLOmxu/YaeCYhglG3KFag==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHPPh+PZRg/W0HmPiq21UCFVtV+R+cDDVe7yCS/YT6ru9QtPMv
	FfX4UYBG6jCAiyP8AzO2rB1vvUz5h7OPKxk/QjpK9c3DGcCgONc+
X-Gm-Gg: ASbGncupKQ4REf/3xcq3ySRZ09Mu9/17O4q7eRL0uYXmlFtzYBygHNzY1FEJRYDefcq
	sms6HkJhokTaomOVItilG1cgpLZOhSYWOzz517Dww+brWC97pr+iTe4yv/e0hketGWarkNunqdj
	FH1IHUwCC6chKK9UCQdUPEFsjTSc0JPUzqky9smjrLQXgdVH9wdid/xP1mAW0BKAC75dexUQrpP
	UORHHGfuQtkHv61bHko6bCZMbh/aNQQBjMncrqsKasU1hkJkf02adrnDOb/mdTQ3EDE
X-Google-Smtp-Source: AGHT+IGASDqM4UAhCOprInoPw233sev4vAgxtns86XCl4E+Hkq8QA0WJEYcNfETSsECKrDC56bCEKA==
X-Received: by 2002:a17:907:c082:b0:aae:93aa:9ac7 with SMTP id a640c23a62f3a-aae93aa9bcemr3082825966b.50.1735833217982;
        Thu, 02 Jan 2025 07:53:37 -0800 (PST)
Received: from [192.168.42.201] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e830d9dsm1784738466b.5.2025.01.02.07.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2025 07:53:37 -0800 (PST)
Message-ID: <72b271d4-c2c0-4d54-81a0-13d0c5640e50@gmail.com>
Date: Thu, 2 Jan 2025 15:54:32 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 04/20] net: page_pool: create hooks for custom
 page providers
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241218003748.796939-1-dw@davidwei.uk>
 <20241218003748.796939-5-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241218003748.796939-5-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/18/24 00:37, David Wei wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> The page providers which try to reuse the same pages will
> need to hold onto the ref, even if page gets released from
> the pool - as in releasing the page from the pp just transfers
> the "ownership" reference from pp to the provider, and provider
> will wait for other references to be gone before feeding this
> page back into the pool.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

My apologies, seems it lost a note that it's a derivative patch
with changes not explicitly confirmed by the author.

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

-- 
Pavel Begunkov


