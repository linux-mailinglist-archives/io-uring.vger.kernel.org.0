Return-Path: <io-uring+bounces-11363-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2F10CF4992
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 17:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 517BB3108B31
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 16:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0DC346A1D;
	Mon,  5 Jan 2026 15:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JO9CsB2h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com [209.85.210.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2D63451BD
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 15:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628470; cv=none; b=lXXdx7RwdA3mLD5Vq1HIrF1cMvHquA4iq/HH8bQaqqUwut9gxoIYh0d0O4/t6znlEy1Vd8M2hy/i1uDbvSiAq7BEgyIYrcVqk14UI+B5Pzqxll1HU/uLK27n8mXJ2cZEWVeJBZS564wyKBqv0eRsDpzZ4L657S2+0PtR0VYXTB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628470; c=relaxed/simple;
	bh=1HJwagvnkAOM0Wd/v9DPqRJ9vBMLjISdcccauekAl0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nWRlOACcl4+BrqpN3jALE4jAFitBeNhOa78gYjCfqPA4gOHEAqviN54n3t1Qh4yiUGknb25vkH1b6JuNFdOvMw3WIjXD3Yh6a5h7REtM4dCT9UYWUkYQ8YI1lJH/ZXR2JbgeMp3QUiqcL3KIkkHyT+DZxbngaS8FRghgf6i4rPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JO9CsB2h; arc=none smtp.client-ip=209.85.210.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f68.google.com with SMTP id 46e09a7af769-7c7503c73b4so44541a34.3
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 07:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767628465; x=1768233265; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AF3T3WPIDJh11CSYVBJq34u/KB0hkbvQ8vk1XpgZ8bg=;
        b=JO9CsB2hXyRWJgFTlAXhn94k83KVtqeNKGsyuZ3h8jDe8MoQOBpKx5yUInX+9YRrYH
         zuRVirVaPHR2fxWb1+jMG3cTHIennmD2fsLDSRRH9E4Unbm3FGfKEswhiNDLCgq9+XWU
         0DEXYiyTKssene2iVEAn9nRsiLTe/EviZY/G/gfu8ugs9abFipFKJWQomxmA+WRoSY7o
         QTMrO1OMpcsanHWkkDby88fij9WC1Sjg02lZNHfhxtON2VBJDksBPlbCwS9bK1OUxwbW
         PNS2sEYSHUgKo3+ts24eRrlW67wKZC7uUQwb1fvHaWMQ9Vec7VO125z9AcUQnVS0B+Ws
         Okow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767628465; x=1768233265;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AF3T3WPIDJh11CSYVBJq34u/KB0hkbvQ8vk1XpgZ8bg=;
        b=dkL/jEKIK7uiW5EICZuojvTdjuFi5CLGSKwfOzwXwuKUleJoda4ZVxOz95fJDnSw3/
         qfl2ZS0qDa0uzhXc3971X2mV+1DDqIPkVBfwUCQL0VIEnmfJIqmMP+OmEU17Q3vdCV6X
         rB3EgUoHYDfPA9/H64MTIHlnvj88szjqPIF5mKOiOaGD7N92AtW5nsWttKthHGP351No
         lawxHXiuFDPZjTB+RhC4XbPk3wAxG2JEfX1AR9hbsQi7zwp5Al+ZEEWVZVfyWv9R00Hi
         QCbEaPm//7CLCscGxuJwR2kvewOr30oOACyVGatrfNZyzjZqF0CnK8SzMpF8kF/Orck6
         e7Ug==
X-Gm-Message-State: AOJu0Yyg04ek9qHuTpCZSzTzPrwJlYt8MYmfnYunYxP60AIPB2S1+ikB
	7DoegnC56nVXMDn8+OqHRSMEz8MZKlL05MsXohdgwlPVkhIoTBZtaycxmRXCfYKNzKk=
X-Gm-Gg: AY/fxX4XJMeVaXvSEahe03zFGK7+S4qUmny8Dx3WwFDrXq7BaD4/ucODwcpwIIAlf1e
	rwC0dNHGwq8Z1upMqHnpWl8PMY7GgOPvrrzghwm7ay8vjY2JrJiNFSh4IEjhQZdMEiMTZUus88q
	76uRwjabPigCAhxRN59+2T6ZwWgwGwaZLuCHWq3XkQi39xmtr17KCzvel/GQ71KoJ2rY/o6YZ3B
	EaRBordt5Lyk60DGFa36CGRF20L4EyD+YBYaVXS+X2VKqViVSyvV9MwoTdrJMHFglmEbpCMbO1C
	dyK3yJnoUx5QlQDDdJ22dkae3ro6UTrBmfTV2VCZ0VTumaXrQP+x5KXD+QC4K7uCMjYW/dt2X+8
	smGXdUvD4hzEWh1yS0oEl/BNX1T8JjIJz09P4u5BrTdweYoz7XUXnLzSa6bl8Z4sQD5+Fvvdz6I
	O+LFlqHeyR
X-Google-Smtp-Source: AGHT+IFe1wQ9pwuhtMQczvH0QC23NziuKoExNDhvy3zoPay8PbMG+zDJhoh7JPxLGSqi4KrnubnLKQ==
X-Received: by 2002:a05:6830:34a8:b0:7c7:6063:8e02 with SMTP id 46e09a7af769-7cc668a4ba5mr27619957a34.6.1767628465465;
        Mon, 05 Jan 2026 07:54:25 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce46012a56sm74070a34.28.2026.01.05.07.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jan 2026 07:54:24 -0800 (PST)
Message-ID: <621ecabe-9d60-482f-a02b-accfd3c48966@kernel.dk>
Date: Mon, 5 Jan 2026 08:54:24 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/io-wq: ensure workers are woken when io-wq
 context is exited
To: David Kahurani <k.kahurani@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 Max Kellermann <max.kellermann@ionos.com>
References: <79dbdfd9-636d-426c-8299-7becb588b19b@kernel.dk>
 <01086100-4629-4037-b084-a9534d315d9c@kernel.dk>
 <CAAZOf259y2HOVrCaqMvvegowp9fFgZSx2hqeP=ZfHJ2D9GyUUg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAAZOf259y2HOVrCaqMvvegowp9fFgZSx2hqeP=ZfHJ2D9GyUUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/5/26 8:55 AM, David Kahurani wrote:
> 
> work-queue has a bug but I don't know who to report to.

Ok that's enough of your random and useless emails. Welcome to
the block list. Though that just solves the problem for me,
please just go away and stop responding to list emails all
together or I'll get you blocked from lore as well.

-- 
Jens Axboe


