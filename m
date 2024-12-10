Return-Path: <io-uring+bounces-5411-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC5B9EB72E
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 17:54:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E5BA282A75
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 16:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3810233159;
	Tue, 10 Dec 2024 16:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="sp2wlh1+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B4B231C91
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 16:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733849633; cv=none; b=sSe6T3p6sdaPMEEyWNCavah+zEVP2LmQPOBwhUa4+7703UsUTBgRblbIetwsLY04TNNrTsmMLc4ReeATKPRgfM2LZMCUmT1g9gmuxGOZTEzhuJ6ubjKhBWB/6jZdh27zvAQrR27IHq31NmjqXyjiEu87lBi1auG9xzBG/HYE6hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733849633; c=relaxed/simple;
	bh=wYPAes464Dj1y9SQACu3q4HX4MCF+mm+9hhGLO/HRBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JDP2vQ6yqAubM/GHNDNaF9wkTnfVvIE1GYAilXPpI7TxfNVZ/YKOmuAlwyf0WnxD+pbauabfeXDTxdge0nGXg5rPvlNn+Gu0S7z10LedEGOJL5uGVWEDW/uaOQMTgdBDnQToMA/2xszVUdz2bsiIODRdovFg1/yjDBOMBWH0n/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=sp2wlh1+; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ee86a1a92dso4220443a91.1
        for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 08:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733849632; x=1734454432; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4xLQK3sBXluSw2kUrvl0E9jKpohZ+Wpp/ckniyFefNs=;
        b=sp2wlh1+NnFjHVNUIak931ldE9l7YS+MnMDaTZZG/NFIXoXqaQhbDybcwQEdp6yf0L
         g/HLaQSiDXex5p2e5+z1vXusonwiE87MeNuleX775OMrjqn3JeY7VzJoR9waehx6giKL
         VH+z7A/5dtovB1Pg40H0h/CH8Leu1R5e5Uxv0f8p3tC4oNd4lLRa5bROOxpMyrAgICPV
         v0P2DPH3XFvjFTkIVaq1td9fiC1U6xuO1CuTsj2UYpgdeEztKcrXwIeeD/mYBm+Q9Psn
         +jMr5/B5oyUB1Lqda8oFLFWvUWRFAKaqY3gpSEnB5cgu1mJrFUIjUTszyS454suHscBB
         YGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733849632; x=1734454432;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4xLQK3sBXluSw2kUrvl0E9jKpohZ+Wpp/ckniyFefNs=;
        b=emCJE53z6mM+OW7iGnTRy9CXm/2vSHE6G7jp+HIF4rMacy5FrD3sgwOUQDa/ri5pMG
         7cUvsesMUDjpdJbT+vQxl/mjYe7RuY+fxW6hkaRXJtEgQikvpS3zL4SbTYrz+LAYIFaj
         7um2EKewhtXHW6HewZg+CHIFYolDuMD3wDBKZ6EWNIU5Xnsy1im6OGETG8IH+nGTUmDK
         jEnEqWcvLnXM1rDkMsCd6KSOLcgBvQRIInamZaJZbXPRzjaUN3b3DRxAYAP/t72AHPyn
         KPTZ9LT1v1y7oS7upc2xG3kldvpL9ZLZh0eYgGijIySW0kj7fTmFpIvNfRDjJZHAWBOc
         43lA==
X-Gm-Message-State: AOJu0YynqaweWjce0BG/xAyeYauQ1uODsZkfUAuf74Av2UF2oLphkepT
	RPV6BL6m3IwuJcq2AhELfHTAfBakRDBpXBRJr8VMFm/K+lLLC26PTzX9nF9Gt5U=
X-Gm-Gg: ASbGncvol6J/m05pRGHDcd0g9OKsp1Qphofbe8No41oilGZyEySl481mGvQlqvtlljq
	V0H/cO1eEUFEu/FVxyptqWMWKtC/I+RhScrIGcyz1kfkeNMkgTN0SJ7RnmoJT6zHdu1n533X/a9
	lbYgBpxx5jzSa4OS2oAP7I6kMJHE5g3jGuJaptK4lj9k1YS0goL60GUoN1HEgNY/+U/Uy9WerxW
	MMBCzsruG4LGxrSRqB5dkq6FGoo5O/VaozPuJrVFTFOFMuzsY2HMc82cY8MZJb0Yw91qhZq/2ZW
	mbLaN+SSoAB3tno=
X-Google-Smtp-Source: AGHT+IGWtX922Y1+q4FOGSeAie94K0z49xgUM1aXfUKUHFURDEp13KZ78l+eCYAq+f1E0VpHxikH1A==
X-Received: by 2002:a17:90b:4f4e:b0:2ee:eb5b:6e06 with SMTP id 98e67ed59e1d1-2efcf26f285mr7223693a91.36.1733849631859;
        Tue, 10 Dec 2024 08:53:51 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::6:fd3a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef45ff7852sm10006503a91.35.2024.12.10.08.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2024 08:53:51 -0800 (PST)
Message-ID: <3d3e952b-73d7-4c63-8d0e-cb972bd3daeb@davidwei.uk>
Date: Tue, 10 Dec 2024 08:53:49 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 16/17] net: add documentation for io_uring
 zcrx
Content-Language: en-GB
To: Mina Almasry <almasrymina@google.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-17-dw@davidwei.uk>
 <CAHS8izP3mo=BYNxKawetg5vNxgRhtUOU2qykJxkWpvua8HQU6g@mail.gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <CAHS8izP3mo=BYNxKawetg5vNxgRhtUOU2qykJxkWpvua8HQU6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024-12-09 09:51, Mina Almasry wrote:
> On Wed, Dec 4, 2024 at 9:23 AM David Wei <dw@davidwei.uk> wrote:
>>
>> Add documentation for io_uring zero copy Rx that explains requirements
>> and the user API.
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>  Documentation/networking/iou-zcrx.rst | 201 ++++++++++++++++++++++++++
>>  1 file changed, 201 insertions(+)
>>  create mode 100644 Documentation/networking/iou-zcrx.rst
>>
>> diff --git a/Documentation/networking/iou-zcrx.rst b/Documentation/networking/iou-zcrx.rst
>> new file mode 100644
>> index 000000000000..0a3af8c08c7e
>> --- /dev/null
...
>> +Usage
>> +=====
>> +
>> +Setup NIC
>> +---------
>> +
>> +Must be done out of band for now.
> 
> I would remove any 'for now' instances in the docs. Uapis are going to
> be maintained as-is for posterity. Even if you in the future add new
> APIs which auto-configure headersplit/flow steering/rss, I'm guessing
> the current API would live on for backward compatibility reasons.

The UAPI will be extended in a way that does not affect backwards
compatibility e.g. extending io_uring_zcrx_ifq_reg. Such that any of the
following will work:

1. Configure NIC using ethtool
2. Call io_uring_register_ifq()

1. Configure NIC using new io_uring UAPI
2. Call io_uring_register_ifq()

1. Configure NIC by setting new fields in io_uring_zcrx_ifq_reg
2. Call io_uring_register_ifq()

Therefore the "for now" is intended.

> 
>> +
>> +Ensure there are enough queues::
> 
> Was not clear to me what are enough queues. Technically you only need
> 2 queues, right? (one for iozcrx and one for normal traffic).

I'll change it to "ensure there are at least two queues".

