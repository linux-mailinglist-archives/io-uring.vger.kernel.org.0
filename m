Return-Path: <io-uring+bounces-8870-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 174F7B17FB8
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 11:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C26D7A68A6
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 09:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE7713A3ED;
	Fri,  1 Aug 2025 09:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4GMG3Ov"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639B122FF2E;
	Fri,  1 Aug 2025 09:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754042220; cv=none; b=KquuoKc2HTZEp9QusJ/mzC4mIZRt+6CDuc6Q4reeCf9qafyIrGEpeeiDhfSrpxtzyAGluhdVggYRTdMOC3tsSMg5cSc8qU7JRY3kVH9diLfqWtl535XB04NiyZqUkOM4nXpV1kbWSNjE/OICe/d1Yx0Yu3Onsz0ElYuYVgrFPyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754042220; c=relaxed/simple;
	bh=dldMrvsOlLM5YtWx5/DV8qGIDKuYuWPadjpZaaqq7T0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X1eWQ2bm/XpRGnnMuJXc3QrYW1KbSHVBLVgEiyiMyXLZTfWRZ9Nsfh4aJH2q2IPTtmSLR99z0UtAX/lWhA2OoJGyZFok0bluytpV29J7gRrFuwzpBl8C6HvClSJWjc6+IYkRuMSjayRVrvu4VOYvJrhoMptAFVtwCsDEnylBgcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m4GMG3Ov; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4589968e001so11263525e9.0;
        Fri, 01 Aug 2025 02:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754042216; x=1754647016; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9sytV4kGxdXtPAfOZwZYtnL8NksirHMU7P3kU9UjZoI=;
        b=m4GMG3OvQrGPr8in8tbf61USm9mA1ZHPKbAYsMV/aCps8Ri8cU5v16Y9EgLxB7g7em
         Tg4vF6t2nxB0gCeG+EGhuEc1gpHVBaFp7HQg2kWx0zVC/2+qG8N1EwSV6+WQEEfH34od
         HP8mgqagiZTD6Rd0BVz3Li3LP8r2BdqYibpSJBiffp1+FikCzeUiI0laToD8Uw1JUjB6
         rpGf7Xx/hd2V1EovfD1CzV8WwVhaZptt5EIn6UQnJuh4DtnyKc0E0W5dsGz/7X86DaZE
         4TX58tXCDvQYNQFuaFKfByodNEd1E4KQNnGBUyW5oR2tKWcZovGGq4lM1Wl5xO8lDTWr
         hKfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754042216; x=1754647016;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9sytV4kGxdXtPAfOZwZYtnL8NksirHMU7P3kU9UjZoI=;
        b=cVlVi51fOKJphSva11DHcGqey6kvVC8R5XnH5kcsInO8MMc0bwdJpVhG1BbgjX8BP0
         qpnwJ3ElPM7tQW1YbhFvn4GB0qpSTtYmQs2T98NkzSsO/oGACpPUmEE3yfKl3bAqM7Tk
         daZHxHqUDUaA18FpF8/JUjAh9s2hdlqTPPZjwj6Q7GY/q4+tbj6BUsfsgWDMPBDUykSE
         GnPfmLJOdKSjFQNnFL/tPuVFPxOtle3iO+6kXQYvMJGlLr/Z2EzfeXEL4c1gl8IyjC2h
         h/vRjyhQVVI8aH3/3W0x+jMdnljJh52I26dciQKGSdZu/HKKkuERAUwlrSOr4WHZV7fG
         3udw==
X-Forwarded-Encrypted: i=1; AJvYcCXafcpA55qkQqQBQe4ob76caHF1eyXft4MY75nRnEMTawN+I7yu6zd7NTiTpXyy+pOQVQSH8/52@vger.kernel.org, AJvYcCXpENcmhutioJfeGJlzqLn326XTNdaECPX6pvuvg9455DLV3mxlRVfxjP/egGxyTewsnZdMoq7ufQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPiRhyoykTil6gKLPuFg9USGBF9rjSCTC7+IH8w0kwmrZ9LjsQ
	PsAwz1U9hZBkyn0c4hKnQy/6DnJX9UIrtNThjZ+DWVXDAxXgs+9Gv2k/
X-Gm-Gg: ASbGnctsFUUYqZgV2xWEZk6k38AEJ1zn+QkwJP+0gwywyT9DfIM2oy1dOdbut7idMCH
	+QwIvyc4jCOvcLarUqwdCtwcVtDZH1okdbTcUe/d30IftRe9miYaYMHevSmC2NhQmxYiYbYGorC
	dGT4jGAFoyvpwFatZq4eH8Ez0qfo0EnD/0J3uwKyiAOe7C2Cus85sAz0/vwMV1AXa5yPPsbyGUM
	6xB09oVPHKdacwqm5IrBtQDySem2kJi8x6LRMhpSoo/ZcNBBzXup+dPgmLX1tgr5FYZVZyQjIuy
	IAniXbrtn74be9Ee5+SaUaJQBdVfEc8kVeFWn5bKH+2LrpIXOicjRXIjixgIm0vHTv/axolACWr
	3FrCRyJtWlgmDB0Kt9NqrELIYXY3/ikNNFCPkqfUGugkZHw==
X-Google-Smtp-Source: AGHT+IEegDd6fTMr8rhJZCVCUFbH/Fuop2PugSzuUykZ1JgEv20/JrrIj91vlHdckv5RtQ1CUJ97AQ==
X-Received: by 2002:a05:6000:2282:b0:3b7:8b5e:831d with SMTP id ffacd0b85a97d-3b794fed0b3mr7154194f8f.17.1754042216385;
        Fri, 01 Aug 2025 02:56:56 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:9c1e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589ee57a04sm60265585e9.24.2025.08.01.02.56.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 02:56:55 -0700 (PDT)
Message-ID: <91714511-c012-4253-b7c8-be854c015668@gmail.com>
Date: Fri, 1 Aug 2025 10:58:22 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
To: Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, dw@davidwei.uk, michael.chan@broadcom.com,
 dtatulea@nvidia.com, ap420073@gmail.com
References: <cover.1753694913.git.asml.silence@gmail.com>
 <aIevvoYj7BcURD3F@mini-arch> <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com>
 <aIfb1Zd3CSAM14nX@mini-arch> <0dbb74c0-fcd6-498f-8e1e-3a222985d443@gmail.com>
 <aIf0bXkt4bvA-0lC@mini-arch> <52597d29-6de4-4292-b3f0-743266a8dcff@gmail.com>
 <aIj3wEHU251DXu18@mini-arch> <46fabfb5-ee39-43a2-986e-30df2e4d13ab@gmail.com>
 <aIo_RMVBBWOJ7anV@mini-arch>
 <CAHS8izPYahW_GkPogatiVF-eZFRGV-zqH3MA=VNBjw4jfgCzug@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPYahW_GkPogatiVF-eZFRGV-zqH3MA=VNBjw4jfgCzug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/31/25 20:34, Mina Almasry wrote:
> On Wed, Jul 30, 2025 at 8:50 AM Stanislav Fomichev <stfomichev@gmail.com> wrote:
...>> For devmem (and same for iou?), we want an option to derive (2) from (1):
>> page pools with larger chunks need to generate larger rx entries.
> 
> To be honest I'm not following. #1 and #2 seem the same to me.
> rx-buf-len is just the size of each rx buffer posted to the NIC.
> 
> With pp_params.order = 0 (most common configuration today), rx-buf-len
> == 4K. Regardless of MTU. With pp_params.order=1, I'm guessing 8K
> then, again regardless of MTU.
> 
> I think if the user has not configured rx-buf-len, the driver is
> probably free to pick whatever it wants and that can be a derivative
> of the MTU.
> 
> When the rx-buf-len is configured by the user, I assume the driver
> puts aside all MTU-related heuristics (if it has them) and uses
> whatever the userspace specified.
> 
> Note that the memory provider may reject the request. For example
> iouring and pages providers can only do page-order allocations. Devmem
> can in theory do any byte-aligned allocation, since gen_pool doesn't
> have a restriction AFAIR.

It's trivial to add sub-page and/or non-pow2 allocations to zcrx,
but the size needs to be uniform and decided on at registration.

-- 
Pavel Begunkov


