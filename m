Return-Path: <io-uring+bounces-3511-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10CDC997508
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 20:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1C0C1F21B4B
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09D71E0E18;
	Wed,  9 Oct 2024 18:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mQDNY9dt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377241E0DC4
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 18:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728499344; cv=none; b=cHRvR5XB8aPMj9R03R6y9+PtOAkjpTLmd4SBL7Djsg9D+dMryp/IRK+Hr+1+INXWg0AYhwcZo5EckbbzVcCkmXMT5bAWO0/r6fNilPj0Cf08gs312eGVOwF+qFZR8FhcBiheyNYcXnzp836ZUPeuKFV5HUECAB1SivudFAuBzMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728499344; c=relaxed/simple;
	bh=iw1VxzQijyh+GNCnrOiYKbbY4qh+4b83s/YVER+nJwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=erc9eLKWWnzHG9OxwMV68OQ0tWebQgb2VSASVuD4xYtY2/d3wFd5cVO3qemsm0FKZQDWFL7PW/0yKjRgUii0dUfzCimAbpyF5sF+NI31JLesvcprOAC8Tw/JFS0g0+OX1NpeXULDkCIR/SUI8AH8WQ8K6SHjzv9r3akHcVhtFtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mQDNY9dt; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-83541f580b6so5890639f.0
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 11:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728499342; x=1729104142; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LCBBaZNbPfdtslV0wSzKS6qNnvHBIaYk2tefcqrD2iM=;
        b=mQDNY9dtWBpbobL6nuMRo+021b85HvttSKqvbRB4NSOzEAbqaSvyg3XG67ocV8mNMQ
         0xly9C+pE4xCDRSkDcBC924BJ12opKf0ze+EW8mhRPcUcUI5OPKqBl61wMoFubo+IeYE
         vil8Pyu1ClTa9RQaHRvVQgYcl9dgufwTrJmXN1lOhZV/RsR0Oj81N0iU0ovcD/flY9xg
         kqcRqEjefK4qssCrHuHRPhX90fY5nKhUds7I49LY6rqQpnx3iz4AX67S1/TOMzZcP2hM
         5ERmCWpPsb4DXUK+qYIJFl2s4jbMbDtdywrWZzro+L+PI1bxgDc3uhsi/L30JWSd7YuM
         QUlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728499342; x=1729104142;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LCBBaZNbPfdtslV0wSzKS6qNnvHBIaYk2tefcqrD2iM=;
        b=o2y3pCSokEiIbJEMjri7MQUfFNkaZg4j+Mr5RSFhbNoaUkxFE4ix8HlAj6o9DT/8BZ
         8rJc6q5wlmcZFWdLEVdVzsVR8xEljBUbVHlyyYi2dKDDPO/SFpVvXYOdgwg1s78zD+wc
         dxuUZzsnD2GmZJFEaIoVzbJ8Sc6miLmjusBSWNnJh9vqGRyUtlQrnCNInjXCL6SjyOAa
         HSkqzcb9mRV4KBw7qEROVbdpqGDzDgxcAf7tGC4bmM1+PH7NO8UzKxjaWHIMOd3eKD7l
         LU0h/CN9u9uMSiiG5i1T7tH7s4GAoy6XPsMSg2BQNaDt4elt7Vqps86xJ+z2a3MAwbq1
         +jlw==
X-Forwarded-Encrypted: i=1; AJvYcCWoxJNQeQZXPYI3Pn4MklYg3R5i3oBzaYtqRblanbdHy2BX7RHaw7WUtrlrkI7V8kEx0boyg32IeQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+8YXCga4XWtpvgGoAXZJ6+qST6PCERtcS91SXW2uDI7sHF8ZH
	D8WZ3nWcn7fN0NrYUJadnCiqtEnGByLyFEr/2HvFpyo4Rp8C616bl/elKoBPkUU=
X-Google-Smtp-Source: AGHT+IHRvn0ibzcLpE6hCtG+/h2iFN2CIZXBUlB6M1Bv8hM9rRgI/r9W8BRSlmewSB1bP5l0fNltcQ==
X-Received: by 2002:a05:6602:2c10:b0:82a:48c5:4d04 with SMTP id ca18e2360f4ac-8353d48003fmr486185439f.6.1728499342217;
        Wed, 09 Oct 2024 11:42:22 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-835447fe98csm25568139f.27.2024.10.09.11.42.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 11:42:21 -0700 (PDT)
Message-ID: <53f1284c-6298-4b55-b7e8-9d480148ec5b@kernel.dk>
Date: Wed, 9 Oct 2024 12:42:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 14/15] io_uring/zcrx: set pp memory provider for an rx
 queue
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-15-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241007221603.1703699-15-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/7/24 4:16 PM, David Wei wrote:
> From: David Wei <davidhwei@meta.com>
> 
> Set the page pool memory provider for the rx queue configured for zero copy to
> io_uring. Then the rx queue is reset using netdev_rx_queue_restart() and netdev
> core + page pool will take care of filling the rx queue from the io_uring zero
> copy memory provider.
> 
> For now, there is only one ifq so its destruction happens implicitly during
> io_uring cleanup.

Bit wide...

> @@ -237,15 +309,20 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>  	reg.offsets.tail = offsetof(struct io_uring, tail);
>  
>  	if (copy_to_user(arg, &reg, sizeof(reg))) {
> +		io_close_zc_rxq(ifq);
>  		ret = -EFAULT;
>  		goto err;
>  	}
>  	if (copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
> +		io_close_zc_rxq(ifq);
>  		ret = -EFAULT;
>  		goto err;
>  	}
>  	ctx->ifq = ifq;
>  	return 0;

Not added in this patch, but since I was looking at rtnl lock coverage,
it's OK to potentially fault while holding this lock? I'm assuming it
is, as I can't imagine any faulting needing to grab it. Not even from
nbd ;-)

Looks fine to me.

-- 
Jens Axboe

