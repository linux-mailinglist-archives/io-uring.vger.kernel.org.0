Return-Path: <io-uring+bounces-3538-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB112997824
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 00:02:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CAA2283A5B
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 22:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3112D1C9B99;
	Wed,  9 Oct 2024 22:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EsYEPVit"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787BF178CCA;
	Wed,  9 Oct 2024 22:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728511344; cv=none; b=JRnB0frcIlh24bohZsc0Qrt7Kky3GwFU+Eac+9cTdBHg1vTl62MAM1W1C6PSFZwbKN+TBdeclh8OutuIwapHw4/4KB4SLhIF68dRkYfZdLTA5QRGN7R6V1yN+ilpPnlq59JDXH8KSQzi4qbNcE3TC0x2l6/NZ5WV1DMklcRbujE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728511344; c=relaxed/simple;
	bh=rPgPR3x31qcbYYVY2S9sneWFcefaJGtG8YvA2BhXMuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=stYPNai4Xw1E2ydYW1K/VDcba+6Kx+LbSCgfz/077xtdG1QF+At8JA4UVFFL/S/bOvox8RBpTPUKbWK0YZIpnbWO0uouweYdflU0WJVqNwpAKmDpbRpgze2mVI53jgTzXoTnM1/McSI4TGmHSlVLxLiioEXmMk7wg1grxzg6ZUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EsYEPVit; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43111cff9d3so1754385e9.1;
        Wed, 09 Oct 2024 15:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728511341; x=1729116141; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yIllhnHIKy4ca7g1wAWI258JFvJheBIJzSpM1TBluho=;
        b=EsYEPVitIkjctSJFZMV2g4terL8xzC00R9DyvEV+pWPtyidxbL/JOiYi3Jg89+1j6o
         p10VckSNR/2FgmRD0JbbOtkxbffb0JX2LgDQrFoBU9bPXgQy3dvE/ObJCCWISp/npOXs
         XXMLV4CbkoEby2ljPcPNZ52V+mQFUDbw9sLwkyK0oskXzVhxPix8CYy6W1hLKF/pN5k4
         JINmFczlwN8mYnwNcsosyLM2JmBUMcMCoiprWVurBlbA3/z7bmKAuHITRxn8uUewuksc
         63DkhpYkrZkpFqbv0a67AEyvAB2//NuByY06Gd2JhUSusY+AoTHdwX2upKwM9bfvzerX
         5Kkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728511341; x=1729116141;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yIllhnHIKy4ca7g1wAWI258JFvJheBIJzSpM1TBluho=;
        b=YWAu5r6W02MUp5avbp51whyXRMRW0bWkNIk6Qd24AkCcaQSQ1NKvv70GtVoSu06s4u
         HcVJjDsa213l9hy2Sx5NoAP00jDv9N16a4iensfU2/IJLDUd9JFhCK3upJ+iaHw8b7yP
         umikOiEfek+iI5bqdBKCF0asohEueTcAR5p3M2Z7Q4zqtTELQUbvdXtKs9obyEM/fshV
         /xwysu28Pw4fIhNIW66I8/9QRs7T4Ia2WQR1M+nexvhfTjcJVkcUWCSoPrXVA7qSOMLf
         NX7GpUHxxRLCPrjQAYkNjy6wMtk+OTSCKrlAfz86UaZVyH5uFv13hWrL4P+rTSESsTAY
         V44g==
X-Forwarded-Encrypted: i=1; AJvYcCX6Yv9eL+QrSKQULP+MzCRoBBCxzY+AREd2cFr/vXftcDyPQ9F5iRwuRgODumkxJ5Qm/gIiWIg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy29ngEFELF2cJy85DmXDu867RepN2Z0SAwVi/cQfcWyNPByL8U
	L9vY45dGNKBJZHczXPDf+DJCt9ZAC8X8R6Wa0sqpp70ftctwJSFrcynWqg==
X-Google-Smtp-Source: AGHT+IFxCGNuuf1aFmxKS0jf9iQVkrzGNCVMOXC7A3wo/DgxDhG+H+Lxsy3YnVEU/TJMmGY2CnqsNw==
X-Received: by 2002:a05:600c:47d7:b0:431:12d0:746b with SMTP id 5b1f17b1804b1-43112d0755emr19947465e9.35.1728511340677;
        Wed, 09 Oct 2024 15:02:20 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43096601152sm31603555e9.0.2024.10.09.15.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 15:02:20 -0700 (PDT)
Message-ID: <1dc75eee-e9f1-432c-aa89-d68e2c667eb5@gmail.com>
Date: Wed, 9 Oct 2024 23:02:55 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/15] net: page_pool: create hooks for custom page
 providers
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-5-dw@davidwei.uk>
 <CAHS8izM0+6c-xymAPYU3MCjq7T+ruUj0ZdxrAK7VE5yoxbGGvQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izM0+6c-xymAPYU3MCjq7T+ruUj0ZdxrAK7VE5yoxbGGvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/9/24 21:49, Mina Almasry wrote:
> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Jakub Kicinski <kuba@kernel.org>
>>
>> The page providers which try to reuse the same pages will
>> need to hold onto the ref, even if page gets released from
>> the pool - as in releasing the page from the pp just transfers
>> the "ownership" reference from pp to the provider, and provider
>> will wait for other references to be gone before feeding this
>> page back into the pool.
>>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> [Pavel] Rebased, renamed callback, +converted devmem
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: David Wei <dw@davidwei.uk>
> 
> Likely needs a Cc: Christoph Hellwig <hch@lst.de>, given previous
> feedback to this patch?

I wouldn't bother, I don't believe it's done in good faith.

> But that's going to run into the same feedback again. You don't want
> to do this without the ops again?

Well, the guy sprinkles nacks as confetti, it's getting hard
to take it seriously. It's a net change, I'll leave it to the
net maintainers to judge.

-- 
Pavel Begunkov

