Return-Path: <io-uring+bounces-8489-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A96EAE8F62
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 22:23:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80A934A7D05
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 20:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B464E262FED;
	Wed, 25 Jun 2025 20:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MeEtD7OE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F571206F27
	for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 20:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750883006; cv=none; b=eL5XHWTsD0Egk1YvgMPfREhsPJjslDAKDsgm4B4IE86yM7r4FiXQru0DiXaIg+I6mWjRW178rkE5MwPbxw8KQLq0TSoOs9cPf9Oacj9zVvSagFgnDuy7TAHGEsmrlt/gxG1hQDaXziMZRJkwqK2SVgFOG7qUPkEdUt78wuga748=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750883006; c=relaxed/simple;
	bh=mkzjnSKLiG1B++ISb3WM/Ubvaow5w/J89x5uEvqg5Vo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WFIrWKsbeXAopWnyU6Horj7ca3MoL4i7kBDanuLkdGplfsqLu9UX57zewGvCBC+1BifbXWVeofLafzvvw2Ugj2Mp9nOgkJbam2rp1KIZKZlEBytkmwb313QKHrPFys96XOyNa/flknU3M5DGgapllh/LDAuE+SA+T2qoIIWHR7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MeEtD7OE; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ae0c571f137so74017966b.0
        for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 13:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750883003; x=1751487803; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TQx+5ZH8wUi+ZkyX3lPWaQxxpuBagzFLreP2Otm6RyE=;
        b=MeEtD7OEM4mDZDfeu7+qv2soRXI5iNUfcQk+ICe4h/8URjb0X2lzY+zrmC8OxhOU/B
         GnFsWyMeWqhS9GlIs5cTpdM3NYINfF6JLTsPjG6NUMCuno0h7Bzx2xp1jJ80ypxW8Ko0
         1J08/dAZiKpBeOLJ2TYT3bNikWRo78s/9pYR6ljkfy68jw0uanGvUeJ8CFnOQmtPv8dD
         UVDprQFLR3XMR8Xn2FsD+EmU/948Aryel7MUdOUwxetYDHHWs6O5+yyfMnMA/Gw22FKA
         +ernGmaRgL24rCyXGxTOkLlQFqTmxSH4CBT9+XzY1WJTfgo+yvw3I1e7HUDNTiSWag7Y
         e2EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750883003; x=1751487803;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TQx+5ZH8wUi+ZkyX3lPWaQxxpuBagzFLreP2Otm6RyE=;
        b=hOpXlodQtHlO74iDeoKjZS2ncF7cx4WnFzQVPq0rCCeGWVGZ4xtI79U0RxUH2OwMVf
         fnMKnfHPpWLn2oy9n6ogCvZB3hFiMjPQsx4VKjquYcS17fxlb3TAhSdrVhYzaU53Zx4+
         +d4tV5ttsqYvHHcgV8AKrsfaVWlpFEHfP1FzHXwxa96GoYoYHWcvZJHpxC8Vsz6/09i1
         JSjXam6jlfnnjpeyMkg8ZtM1j6odVECQ9sKXVkr4dJC1fyYUwBGOkXLJx7sq+Q3p4Vtb
         tAyOqG1q8UfWUkbfv6tPB97X4+FyakortP32yoY2b2tG7JMKoJaxYa9zy0wpBtNk5sc6
         Y/MA==
X-Forwarded-Encrypted: i=1; AJvYcCUhijGUI0y9lKi7qJnNaOTXfYMbYKKnmh/2OFBpM+cFktAYKDq3+94sZrcGwEkSjl+125ix70SUCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yym2+SWatJLhmkqA90tXCjUUskl82kYCC8sM4O0MmtYEKQhwIGn
	WnF65BL4CqybImyy7cji02M+a57VhydD75xNWDVYHLaVaums40CfNmUI
X-Gm-Gg: ASbGncvdf16yAIzsOGsEbQjfpnmrpMM5SXtQMHYfmt0XpB6Z3gdXTR/Ufo+RA124z5H
	XyGhVjEftoSNU6sAOZ5detowaI+vSKQb9mpRNniRwIOF9s+HGT5fSTmVj/ZQT8c+6rSmgCjwH+o
	ALDE6NDlGY2V8KuMUY2xeNrXbHQyBisYbDfPSKjFmIpLLO+Rkv9aHrnNmFiB1VZDxc78UVR4ckx
	FMEB3Btekdbynbt4bB5FQ9yGdVcUXhCY1oeR1VlT8AsyNyTKB8Jz3Hgz/B37YV4fkMw5XnQBsDx
	z1DcRPD0HlGVbBxdypeExe61wyuAPIWZbEnU2DrCuS1yA+Cfgv0WNkVQVSkODY1C4jiygnBd
X-Google-Smtp-Source: AGHT+IFc7vW8rVWj1wYhQ+eTRQVzK7Ke3qGEvWclY7mO49KmcY4FR6Spg1W4upIphuJ8Wzw5yZmpsA==
X-Received: by 2002:a17:906:dc90:b0:ad5:34cf:d23f with SMTP id a640c23a62f3a-ae0d0b7fe86mr146249366b.21.1750883002984;
        Wed, 25 Jun 2025 13:23:22 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae0c870a75dsm124616566b.39.2025.06.25.13.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 13:23:22 -0700 (PDT)
Message-ID: <adfde1ba-68fa-4bcc-a657-86e0d311bdd2@gmail.com>
Date: Wed, 25 Jun 2025 21:24:47 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] io_uring mm related abuses
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>
References: <cover.1750771718.git.asml.silence@gmail.com>
 <d0929e59-ffe1-4de8-ad3b-2f81d6f24f3b@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d0929e59-ffe1-4de8-ad3b-2f81d6f24f3b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 03:52, Jens Axboe wrote:
> On 6/24/25 7:40 AM, Pavel Begunkov wrote:
>> Patch 1 uses unpin_user_folio instead of the page variant.
>> Patches 2-3 make sure io_uring doesn't make any assumptions
>> about user pointer alignments.
>>
>> v2: change patch 1 tags
>>      use folio_page_idx()
>>
>> Pavel Begunkov (3):
>>    io_uring/rsrc: fix folio unpinning
>>    io_uring/rsrc: don't rely on user vaddr alignment
>>    io_uring: don't assume uaddr alignment in io_vec_fill_bvec
>>
>>   io_uring/rsrc.c | 27 ++++++++++++++++++++-------
>>   io_uring/rsrc.h |  1 +
>>   2 files changed, 21 insertions(+), 7 deletions(-)
> 
> Hand applied, as this is against an older tree. Please check patch 1
> in the current tree. Thanks!

Turned to be for-next from a couple of days ago. Patch 1
looks the same, should be fine.

-- 
Pavel Begunkov


