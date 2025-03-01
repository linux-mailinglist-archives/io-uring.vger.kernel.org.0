Return-Path: <io-uring+bounces-6885-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71CACA4A7E4
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:14:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BB6C1885226
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F5522066;
	Sat,  1 Mar 2025 02:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FbIWx0xM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183E12E630
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795264; cv=none; b=GwkxfcrKoNspe8iBEk+i2tC7xqtkyYB4WSV6kBpQx0+fXzMsdG7Hoag3qXrODbrxfxipO8GzRUkDctI64EWNxVscQQRtAf4V6956ksSi2P2PGTS3krdgUBRVqEtgC2JwkpwWbwS4GAJlBXQkfGzQ3scrVfAdFcSiUDaG3IYTIOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795264; c=relaxed/simple;
	bh=fyuJ7EPcecKBKCGrdIqsjCTfY9tsDJwG/SxsOoPOjUQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=qO9WKb1LP9KGfXJlTUPDemqGUxOFIrvQWpsmQGC+DhOSl37AbscHh+yXd3LnJHlX/nmSCK0Z9ZSAv4WX1a6ouUnwJfNluNBsMyoEU9R+v+ljkbBRLNCwMYrWpD7yQjnGFSs9tRwMJA3p2/fD4I2FsgwGKLSyVJaOyW68umJC0dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FbIWx0xM; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e4ad1d67bdso4181496a12.2
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740795261; x=1741400061; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Xo9kkNvgjbBp8wQlj/RRpuVBUT/nhcZ/6GZXLn5m/mU=;
        b=FbIWx0xMhihV1E7SMzXx/QDVu+zuQxEbHf/9ybmc98UApErU3CxC0Mv8Oqn4XQMHHX
         /gTlBOEhlFRwzqVbbqV76hEd8efDUwqM5au7JUfd2wEbucrC7c7zsFOZMIJlAu2ekijs
         k+YluQkTrXr5oG492sP7xUIaVXi5sVdYLFxLo93/nouhGZ7KoRP9qsQRBZ2uRbxRzt6N
         pp3SVsC7Tt66ktoJzlX8XH4+4mOSpLy02In4KUSrstrIPCKu7qW1v4eSqdr9WoPeZti7
         TpjwhDmEU1LxS8w4xeZ7n4KB6iTeMTDCM3AIlYNK3ff76t9yfytnfOcmPUaUSsPPWQPW
         hv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795261; x=1741400061;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xo9kkNvgjbBp8wQlj/RRpuVBUT/nhcZ/6GZXLn5m/mU=;
        b=tAJk3swClywuAXJqqJClA1m9AERHsEUB0SegNchlteoeaWHQWzEzuM5WiQWkJ2UhxF
         P7kY6kF8jap8iYiKpyrNfr7ormymssp3rN2SSalxVQba/bK5912bmXrNbtd1d4ZKbkX6
         nd9P/tpoPp057HzHy7W/pwP5GJzip82cCRENzw7w/HHNzm22rmNRrwV+f4jrm3YezfeF
         +A1gNoR+XIF00Da0ORYDFQazO66v6tGQ93zocNaXhKiTrsnIAPZ5wNYP0d57tw1Qi7If
         JzMln7hDPDHwOqgDo1M7+alx0kF7P7edNSlpsOlWtf+feWQ97bx9O7UQIcBcMvFy7z/M
         oXBg==
X-Gm-Message-State: AOJu0YwTtqEkh/h31IIamWqsi2LriY+vw7qX9bnh/ja9Q6oXpGCAIXs3
	Y1F6nf5WzIGNJpnjK8ckO+CThYmmXWxLq0m1XsHfdBGx4TusY24Ujy9+Uw==
X-Gm-Gg: ASbGncviLEEq+6MBctY1eKGk5cukZpY4bU7rl9z8leQZ3wL+6sWTc5RUVJ2DXBPv7Qd
	rv6fmEAK0u/0r8tkxy5/0i0xtwSdM1KWCvwjDwN+p9vjB6nOcIHiOVNFhyW7t+jiopIyGjtSHBW
	WLsV0pM3hFq1BEQE/Cc4JPlGBFS9aWP/sWmI8/K35UOwavs7SteTHBtllrOIGcg1K+czJgveRNM
	wiJAQAL4Ih3wZjY4Pornabi7JZ5aERUHGoXjnFoX2mu4t+ZOtB8xzmX3tFR1kHGNFck0Ouittcr
	H4bfMDw608B9mOYo+1kLdqegCgAVpR/h+CmwNam9OsmPaQPXEaAG94w=
X-Google-Smtp-Source: AGHT+IHUIXNKvNtrOmoAciuYaBKphqDMzaaW82EcubpFz1qSa4nE0Dr/4FAyuMO7K5UsjnUr5SpFKw==
X-Received: by 2002:a17:907:7d8c:b0:ab7:9a7:688e with SMTP id a640c23a62f3a-abf265a30b1mr519083866b.45.1740795261171;
        Fri, 28 Feb 2025 18:14:21 -0800 (PST)
Received: from [192.168.8.100] ([148.252.144.117])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf46a3ac00sm103087366b.25.2025.02.28.18.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 18:14:19 -0800 (PST)
Message-ID: <e84d5e50-617b-421e-bed6-628cacc28cf9@gmail.com>
Date: Sat, 1 Mar 2025 02:15:26 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/nop: use io_find_buf_node()
From: Pavel Begunkov <asml.silence@gmail.com>
To: Caleb Sander Mateos <csander@purestorage.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
References: <20250301001610.678223-1-csander@purestorage.com>
 <20250301001610.678223-2-csander@purestorage.com>
 <d4271290-2abb-49ee-a99a-bc8bb6dde558@gmail.com>
Content-Language: en-US
In-Reply-To: <d4271290-2abb-49ee-a99a-bc8bb6dde558@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/25 01:41, Pavel Begunkov wrote:
> On 3/1/25 00:16, Caleb Sander Mateos wrote:
>> Call io_find_buf_node() to avoid duplicating it in io_nop().
> 
> IORING_NOP_FIXED_BUFFER interface looks odd, instead of pretending
> to use a buffer, it basically pokes directly into internal infra,
> it's not something userspace should be able to do.
> 
> Jens, did use it anywhere? It's new, I'd rather kill it or align with
> how requests consume buffers, i.e. addr+len, and then do
> io_import_reg_buf() instead. That'd break the api though, but would
> anyone care?

3rd option is to ignore the flag and let the req succeed.

-- 
Pavel Begunkov


