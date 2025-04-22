Return-Path: <io-uring+bounces-7603-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C8A7A960CF
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 10:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EABE18967AE
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 08:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691B71EDA2F;
	Tue, 22 Apr 2025 08:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NA+VTaMG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90322F3E;
	Tue, 22 Apr 2025 08:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745309792; cv=none; b=dHcXZE+G5MWfBGWfcIXcqWtGUmhuz5OI4kXN5pvWRVn6f3h/+VX2zavO/4COdwCjF3pFcGPRApItzphy/tLDlD4P/5oqWY8go83dhlLj5MHTuolk6pCQKpUa3h95Skr9t1Y20q7GdQjr+srg6+4hGksb6VDY9Zx27vQDTlPRJho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745309792; c=relaxed/simple;
	bh=IxR9R4dznHC7A3UhAAi8NByT8Ge6lacYIRr4lsdjXE0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OWMzOz7hEA5laGuiV4IF7y48uC/o9n+5VuONFx/tbw0mvDpk4ZcM96Yfi2K0lzogGFanMRnrBqmU1iKTx1xCf3lDsnjr5N7z9/u9pWaIr2sw539fItMYWr2dDf4p1hWEWJ7cHzJKMAsrWqOY5QLJMTN8CaLPkscWXmLkj5py/wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NA+VTaMG; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ac339f53df9so828304166b.1;
        Tue, 22 Apr 2025 01:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745309789; x=1745914589; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cOlwuce44vKtv1OuDBF9isVVZKdS5EgivWfm0t2JhLQ=;
        b=NA+VTaMG5Jd5S6hrAveld3neuGsqIXH/L8IQqWYkNHxVuDghVQekrvl/3qEJojJbrZ
         XI5m/gGP8j6eKOSG6DFR19G5zKPoHaxWu8be6OT9tMZmjD4BYLDkcN3gb8GhPDDXHuP5
         lZ8IoqWyl9wCMJYVi1oPKiU/ZNd3J2j2HyWziXSxhnSU0JaLgmTu+lHrbPFnnUYv38qM
         JoGh7u1W37TaqcywpU66pyb/dApCB5gc5KlFAZB5KPml14sSib+K9rG7CuKXKEZENdbL
         lp4JW5hz1bm4BrOukiu4VsrKwynJdumNgySHPpmlDU7j4tM02fASaNMFCIO0Rx6oUGmp
         KcTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745309789; x=1745914589;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cOlwuce44vKtv1OuDBF9isVVZKdS5EgivWfm0t2JhLQ=;
        b=GlkNBoOMf1eZi46VsEq1+11Ju7yltK7Lj6oCG+0ctnC17ZBOSmzIrQMrBchGnrA7sk
         lv0jkVYM9y7EoxF9HtGXOcJQHcuQJP2G6XdqjWmuJumOL4TpokSxx1H4a1Zz8rbeDt4v
         AvdFCQOtT8bJHwOiEKd+8wbLQtUGd3ypQwPh5YL60zCCiKn2NO0sbyhkMIYiN3Cn5PUv
         Pkk4R0ZeTSLMBa60VkpVYWfHpesywm7LzcVOFoEeoqwY+r/YnRW/qUu+Rt1lvZmfOQek
         zupT7NPQM6LXj0xxnswzMhW4SIRfVzSLDRgsp4lXUTB/rOQu9DT2dYQ/bUixKwwA1gGO
         aOxA==
X-Forwarded-Encrypted: i=1; AJvYcCV7ySgTppYCT1s/9mo7lwv7A654rXDrFcVVcEi4k94VC02f7scUUPhl2Ex/yl8XkTAtapRI@vger.kernel.org, AJvYcCVJE+ZeFwSSi7uASHkkMkxF79kLb/PAn4IVnL4Qx4TNX3mcHdIu4BvBub1M3l2Fqebc0qpqIGPQbiav@vger.kernel.org, AJvYcCVivvua8bq+MOaFmJqyF0Ht5ndA9dQ1x1ija//9eGIPNgD3S1hVaftIvqOUC9DKMgsYjuldUemAZNdmNP+rMTBr@vger.kernel.org, AJvYcCVroBig5FWPglu9lbLgg3SbM+Tl0xte7cT6v2hXqs7FJjznoGJ0beFLSZ/exW/cJi/csXdeG0uQSXEYkIyM@vger.kernel.org, AJvYcCWH3Iz6v/EmZuE1nGWFTbsmmeklluFubRdE0JdjuJWADxohQKQKqabLhhtRDhwz2g4/1CIWujH4@vger.kernel.org, AJvYcCX0Q1ok3Y3PwEJT8/KFc0u5ZEHyteMAr9/h8sbvuwT/Z1OdwgnFSBgvKKhl4gnEVbP1qe/B1Asfkw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywtir3K1vLec5Steeamrmr0/q2eMM009bbMD5ASLgwUbtaia389
	b7Ryes+DxxOkgjKnLgmvXh7JAGjwXmjo4CBV5tb3M3gkIeWa/xke
X-Gm-Gg: ASbGncvAbXPaUzb+R9CWOK7VYjHczqcEChuD1fFvRL1klzHAqDdtIy5/imtpfmQSO06
	z1wGw2iDSoGmfHdhIBsC1C9CS/9/s3dZxqcWJbNXDbbUW8/gjo76JWjXnM9K2YtbpmltdZffnUl
	I8jZDLMCUnWLIB/B3hzpHyrXn30q4lPj7PA3pobucm3KsodCMRnHeHg2fmTiuEx9aDku9tIZzii
	X6t8J+MZY6MpP4B8mTtYuj8vFKn2BbpD9CIx1va9+UDwrI1/fUMs06pL+LzSqZ8uQiHK3NDyOdQ
	tixvJXD7uX8/SObDlTK5J7fUTfL6GvSUZB0abzgP1nig4xTo5lHoRA==
X-Google-Smtp-Source: AGHT+IEoDhdUk4JqptbNDk1DSYTZqleRkQiE6D7lLk3MmjHoZyxA8pbW4BbGT1g4lHeJT+lVTudacg==
X-Received: by 2002:a17:907:7f88:b0:acb:5f9a:72f4 with SMTP id a640c23a62f3a-acb74b8368dmr1158109666b.30.1745309788661;
        Tue, 22 Apr 2025 01:16:28 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::158? ([2620:10d:c092:600::1:558d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb8cca2323sm471150066b.181.2025.04.22.01.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 01:16:27 -0700 (PDT)
Message-ID: <f7a96367-1bb0-4ed2-8fbf-af7558fccc20@gmail.com>
Date: Tue, 22 Apr 2025 09:17:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 1/9] netmem: add niov->type attribute to
 distinguish different net_iov types
To: Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 io-uring@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Donald Hunter <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Jeroen de Borst <jeroendb@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn
 <willemb@google.com>, Jens Axboe <axboe@kernel.dk>,
 David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>,
 sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>,
 Victor Nogueira <victor@mojatatu.com>, Pedro Tammela
 <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
References: <20250417231540.2780723-1-almasrymina@google.com>
 <20250417231540.2780723-2-almasrymina@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250417231540.2780723-2-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/25 00:15, Mina Almasry wrote:
> Later patches in the series adds TX net_iovs where there is no pp
> associated, so we can't rely on niov->pp->mp_ops to tell what is the
> type of the net_iov.

That's fine, but that needs a NULL pp check in io_uring as well,
specifically in io_zcrx_recv_frag().

You can also move it to struct net_iov_area and check niov->owner->type
instead. It's a safer choice than aliasing with struct page, there is
no cost as you're loading ->owner anyway (e.g. for
net_iov_virtual_addr()), and it's better in terms of normalisation /
not unnecessary duplicating it, assuming we'll never have niovs of
different types bound to the same struct net_iov_area.

-- 
Pavel Begunkov


