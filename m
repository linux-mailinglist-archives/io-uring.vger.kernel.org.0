Return-Path: <io-uring+bounces-5412-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DED19EB736
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 17:54:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7406167AB0
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 16:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB342343BB;
	Tue, 10 Dec 2024 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="JPdf85vb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074FC1BD9CB
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733849657; cv=none; b=tqyYnc0R8TOxK/NHFL7ZGk/nixgUyLbkN5sogHOIlO1YTkaV86bNkkweHcztYhymo1t77vMCltid7d5k86rhmPYQR41AGxCNX/xzaRp5HRy9ox9udy75sICT8mA9E1E0M5d57tWEpYiDa+elQtUItSanLk3IKa88moMX/vkASC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733849657; c=relaxed/simple;
	bh=bqxl1CIIYKwmPZtxdkAyjqzAJBVDP0ffV4559BZ6DJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gv32OV/NshgFpLtrKMOBtjRGMOIVPbThvyUKAtzQ9XTfdY5J+6QzGuWvJFjk3/P6+TRLJB73diAvE9mZpwSSGQFFAtZluKiWMQYb5CJP1bZ0Zig8DhNvFftf5Ad8ojGvELrn0Imnp7mniwbC6/TpyjxMwzdZTD7OAydM2F1MY3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=JPdf85vb; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2e56750bb0dso4228998a91.0
        for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 08:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733849655; x=1734454455; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3tlCM28/gCfiNIykDUL+CIjEYNxB0b/4lwLtIZm92Rs=;
        b=JPdf85vbZ/+ml6X3fEj9LVyhxkjpUskMXd7ENqnAEqB+S7Z22eMnUIrh/2WxXogzKt
         qGvj7Hr5ZKQhvFnMnF8v7/hoXttVknCypOVEDVfpnuBRBBLIVsUb1mfGa4M3+c/L4G6X
         f9CMP7J0twuCcZsOowyweL2OJD+SCU9lzMqpH6CxVHDiQRP06wfhM5o8tMmLhVNixtA9
         f7FK9xAUjKdxPFmoELauaInoyuM4Pe5xqGM+VfGFvMwZFoK/2yrHH4Zib5uQ5IwdM4j/
         +d+/STzi05qBMvct31c2GXGZdrPKGOQCqzrb9ElWJYHEcfFHbrhDqxIEWFgxAVB0ex1o
         S1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733849655; x=1734454455;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3tlCM28/gCfiNIykDUL+CIjEYNxB0b/4lwLtIZm92Rs=;
        b=v233A4Mw+Kvwc1c2wFDmvXppy+xmJvPH/OaBM0me2+ZEnRvxwFZwisZ4tDUk4cZNwY
         RbAt5pMDT0w9gEhr0v7+Rc+F8bnS5IYfyH3QLOAt9rFdBv+eTIO31De4ekywPn39LOTj
         xLiSVeDzQNzzTgVREz9Z2fNGXOFLXR+/5XIZFwafp5eMmBNUUQbnCYFzn2nlgAfW4cOb
         yKTkdPvk6Vsy9KIYhnJtKBWVD6D5X8bJAxJN3X9MGRAWhjYxHZaK+V8xyDnswSeugFMB
         /bFD2ot4seL+DKDCIaKzJfNXpdMKjIUzgldkcn2/AWcvNPGFL0urBJSbW0wvFbpqSRvz
         DFTw==
X-Gm-Message-State: AOJu0Yw1L7M6k0PtvnC65yZTxfmxbcNyzpIjrDkAO4AJiwvexdPdU0Gj
	M1j49h0qpBNJh0t2cUhuTL8Dn1Zq2SGeyVDr/0AaUvqwBQ2px+YDucwjMraGRIE=
X-Gm-Gg: ASbGncv4/1EdjDkTH2s+DNTKr/PjpgeMYfy65ZQInDrWCNhtxrLKKJcXmYWniAOruM7
	jGygS7qR1Hy7jan3bva24CYhLLHdN9WOBtjWZllQAezxh3OKq0bdc0gtNTRZ8Y3XjNoBVXlYTkR
	bXP9DvdsqGmxMWeerDNGy22SWlZ2X9KbCaFv/m84rQGoE424koQFIy0Mhn7/gScSKNX6ASuuJmi
	qlfHFR40GN1/mXDUVdqVWeXDsc/+6zxhxDblZUkILDZRAv2svQwbaR65afRzt9FLx1Watv7c0D+
	a3MPA5l1AJM7PEY=
X-Google-Smtp-Source: AGHT+IEbGnJeu1ItNoEhpSTmBcJSLUfbZfKsGkLOt7zfegiklcE5jIueF9W/ww1RAn2axD/UyuawHw==
X-Received: by 2002:a17:90b:2790:b0:2ee:bbd8:2b7e with SMTP id 98e67ed59e1d1-2efcf1384a3mr9656295a91.12.1733849655329;
        Tue, 10 Dec 2024 08:54:15 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::6:fd3a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2161fd39ddcsm70445245ad.86.2024.12.10.08.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2024 08:54:14 -0800 (PST)
Message-ID: <c635218a-eab6-48af-bc07-0abe7d3606d7@davidwei.uk>
Date: Tue, 10 Dec 2024 08:54:12 -0800
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
 <CAHS8izO29gnvrqtj2jA9m1mNQK2UC9yCHd=Gtn+fA1Mv0+Vthw@mail.gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <CAHS8izO29gnvrqtj2jA9m1mNQK2UC9yCHd=Gtn+fA1Mv0+Vthw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024-12-09 09:52, Mina Almasry wrote:
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
> 
> I think you need a link to Documentation/networking/index.rst to point
> to your new docs.
> 
> ....
> 
>> +Testing
>> +=======
>> +
>> +See ``tools/testing/selftests/net/iou-zcrx.c``
> 
> Link is wrong I think. The path in this series is
> tools/testing/selftests/drivers/net/hw/iou-zcrx.c.
> 

Thanks, will fix both.

