Return-Path: <io-uring+bounces-9797-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B921DB58563
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 21:36:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CF6616F09D
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 19:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C742B281369;
	Mon, 15 Sep 2025 19:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XwzDcp8p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46710320F
	for <io-uring@vger.kernel.org>; Mon, 15 Sep 2025 19:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757964994; cv=none; b=RuaTXd4jIbDOPdUSqyEd+AyhT6ph5WwH7VvKDNNajm2p9VFskhezoG8umm6Cd1DhrgAhx8hS3kkYMzLg7b+y0ND2X6mTlL3TKINGflbF2cc9zjV5Os53YxxQ1wyJ2jwf60e0Myd6loMMRL9db7eGHxbV8RLIrPXOxrkEXVEieBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757964994; c=relaxed/simple;
	bh=uEAC5p+AjUNa10foDlmnZ/iJXlzmcT/Zp18GyN1xzQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qxTju4B4amIqTgZoFxk5kGBw9Uv5+DUyDtcjqLVFKyQEMp3Ri0w5z1+bEaWv+/Io6DAK8unyVnaFpodK5AuwxZkA0VS3pI1f3LF9WufaYR1r01/3uvmucKpsA6g/G6xKpX7wz4UsDXaO8z3x0LY7k7uyip+7jhFR2dBNoYZ9cSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XwzDcp8p; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-4240d243340so6063815ab.2
        for <io-uring@vger.kernel.org>; Mon, 15 Sep 2025 12:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757964991; x=1758569791; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/QRhMXbwN6ZOtvgpddJaVy3QSoQt+zsOVvdVieAZwxg=;
        b=XwzDcp8pXiwXK+G7p1rIal7nBp0ZsMVgd1uOBSdOo+IY7lhbwEHGgQvF/dvDAey8ed
         l/fuzHlfd8iFFAME6wZ7xjIdaXZcZ8tih4BQ2e78fqT44a+70Cj/piU9xTxOqzMFpo/I
         gW+RkI9Y/bMizSQvggvMnmtVVMCMNCDbXGsFXdJqHhaCE0+JrWTrtr/ZWbVvf8L77WL9
         hnSZphFz8WcFyhFOUh8byfMZKLg8jRh1B9wqURvbzJM0mcc6ToXl69TvJgzRrosYqV8C
         4feT7Mx/KuSEet/h1TTtSLQjP4JPGVEboyvZia26xjInOQ3/BtWyV5mtj8AqYIZaWjMp
         0DPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757964991; x=1758569791;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/QRhMXbwN6ZOtvgpddJaVy3QSoQt+zsOVvdVieAZwxg=;
        b=w5CeaqEOLV1h0CjYTVvdFmmknuci35+0o+oBIzkLPB5BKZtoLxHObOWqwjP2NfhoRS
         ykYs6dvgPqTFhKzqA8vvBrfx3CjjHqRy1OHeAR7EzE8/H0k7gN6+oaSQtYqTxQlSdmCE
         uzuonjq4ug1riXb9ZHI/ip/f62Wtq55Sz/DCawIrPuxpq+7HyyOrQb1Eu/iR45nHkxDf
         hFOdZM2q6o8u5id9CUKbSmuFq5onCeuUVrebvFjT4NRzxPPBw5rur7SacCCSvFBoAxan
         MXmgvC4v87trsxRQZbyi41dIjq3oexNazeJpIEfRsnt+fiqmhkEl4sNU2IRN/J6bkVzt
         Xpdg==
X-Forwarded-Encrypted: i=1; AJvYcCW2u802BJmliIopqcAy9m3cxPIAGRuZJBWsWgh2ACyEeycD8QVPawKGlL5WEblkJQtdR9di3b/ZlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxVgUe/DubSVWgGKJnPZAEdylfzWjHjgApkjHXgz6+SAWyVrO97
	LYCSOkrXSmr/dXLrlMZ7lqU5KgiXI5+aWk6GH2ajIBxfKCEgjVLebhaDwArKRwJyvmU=
X-Gm-Gg: ASbGncsb0vgqTVEkq1hIiezyP7s5aTWVoAsyEbL5Kbnuq/KrLM3HxCg8ueOLLMBvgVz
	Zni1UKIDxtSUuaEBmZTG0p0tOrH4QpjcHLUznEjVf7nTepgNmyi2qUY5JEldl7HqMNM2ZVo0/dE
	5VsBssTWjR+3pVXJ5YKi0dnJsUdW3sZd32KQHXQknyM/mifLkh1EWoF+GKcleNgpu43oadnBMyD
	iYRYCDtMXgOcwIpgjKY/5pkloTWYDVla6vBbjT1WBWHMIVf/AFH44FGRCF4MAiVuJWh0XS8ULWF
	mGGPMuD8cbw9MTE85HXim2NdgJ3l2YZnDI9TlWN6K3Ye3/g+pn4tManlsqjM1Tl/5PEXZF/Z6zL
	g68fBtTt3C6La4UiDtaBItfuOyq5T0Q==
X-Google-Smtp-Source: AGHT+IFEYX/oPDGLIujkgUjpKHkd+AJzUSAlzQhNdyXjqsuLxj3O8GToO+/Ue90TwQzp6EYj8c6BCw==
X-Received: by 2002:a05:6e02:18cd:b0:424:71:32e5 with SMTP id e9e14a558f8ab-42400713e12mr52694585ab.31.1757964991321;
        Mon, 15 Sep 2025 12:36:31 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5191117917bsm1281543173.10.2025.09.15.12.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 12:36:30 -0700 (PDT)
Message-ID: <a58fee04-db3d-4c53-ae27-2e39b53e5e84@kernel.dk>
Date: Mon, 15 Sep 2025 13:36:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] io_uring/zcrx: fix ifq->if_rxq is -1, get
 dma_dev is NULL
To: Feng zhou <zhoufeng.zf@bytedance.com>, asml.silence@gmail.com,
 almasrymina@google.com, kuba@kernel.org, edumazet@google.com,
 pabeni@redhat.com, horms@kernel.org, saeedm@nvidia.com, tariqt@nvidia.co,
 mbloch@nvidia.com, leon@kernel.org, andrew+netdev@lunn.ch,
 dtatulea@nvidia.com
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangzhenze@bytedance.com,
 wangdongdong.6@bytedance.com
References: <20250912140133.97741-1-zhoufeng.zf@bytedance.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250912140133.97741-1-zhoufeng.zf@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/12/25 8:01 AM, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> ifq->if_rxq has not been assigned, is -1, the correct value is
> in reg.if_rxq.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


