Return-Path: <io-uring+bounces-9848-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB6DDB89CA2
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 16:04:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F7E4568210
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 14:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D572505AF;
	Fri, 19 Sep 2025 14:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XvO0N4uG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4025E254848
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 14:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758290692; cv=none; b=UPVi2vPkgl6e8zVOg5bKL/HTkml8YPmSW36YVVzkpSdCPdzuJO9IGmwKADoWsMnkn/DFi7NJ+dd0Pxs2PCS9nb3m4N3K29xLk1uT4HWlXj4vxd/wk+QotjSktYTd5OpHbUhai99y62c+kg3PJu+oW9NvrIhaJSPRAFVFMBeguRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758290692; c=relaxed/simple;
	bh=C8PZTGi/IL1oxDviavme/UhiUHa8/oRKQ63q4eQ2djo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=g9Vrh2l04GHLXQ1wwU/ga42gGJN7Yga5no7EOhWuJuhHbuk6s0/icn/suotm160uTV+itfGqeWa9f3YodYfqD+T6azuzHos1c80mrvR/uDSl1k66X2X7t5CuBYma+f18rCdIUlXMAF1dSACFCblI7QPMX24G7umxibPU73Lq2kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XvO0N4uG; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4619eb182c8so20361375e9.1
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 07:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758290689; x=1758895489; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lpC8icc1PITWTIE8TYkvKZZVwSmAjSabiOcnJRDan+c=;
        b=XvO0N4uGfUHI+CPv1qs6lFloG6TtlXeIpDUN9DUNDT3aX4lL+Y4PT+NAJC94it7YRZ
         oAUeXRPeBWDuw0riEF5Y+9rmKZbGsP2/Wvbe1YxfdiYhL2mYl9Un7c8XT/CQ+EhG8dJH
         C/3vQxbOFJfwwVJ6JLYhkx3gKaxgsAr5ExHlpwIW78PLTpofjDaTaP7bY2y0TL3XWMCX
         takivMpWksEQwyYAHEKMDNaMAQcNmH2oZsQZ3Mdu+GV7ft2yXQ5+rtzduAQqIMkp++TJ
         sh6ww2C2mOoJDgMegWzcntnqbXylixBpK2yQ5juGozm02SFzikFCYt7NnIGDHy91J84m
         32ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758290689; x=1758895489;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lpC8icc1PITWTIE8TYkvKZZVwSmAjSabiOcnJRDan+c=;
        b=MzcAkG/cRFpmDLPN7+1QRKHfG2z0cQnceglhkv54HVem0P10UbW1bpRcSQSabWOF/G
         SrX2ab7phlrjO6L3cg5cuIE0/IOe2btIOTcO4wWrzBzlk3PSRycCnBtlgMhQ7MfnE+J6
         MH197HJKhsAt1GWA/viFTHr67KoNkzOjWye+FGapage7nr6+oFFJghZA5SO3lcL0CgpI
         +PLkNcn+V3sbqPjyBvkEF19akomSeo3jEGdlPNWMIkAoLLdMk3FS373gq4eA0rqJw5IN
         /mYSwqVU5Z0VihyhGPiSV886dedL9mi2TR89HqVLnSTTrBXm6HVrjfNpaSrwFtcBk25+
         8RSA==
X-Forwarded-Encrypted: i=1; AJvYcCU/1kuSgfHBvDcvYqGlPUAkUivs8QOKwR+k9JybnbcDMlJ2u/3UHocfbK9Trq9C5zXKSDKKUGLemQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxRWw2kikmvrWVFMBuqd8UQvqqlWiO65/xxWGtIIn3mtDyx3nJb
	KjOPnP28bPT+yZQvB7sVb6mOW5RXEa2/6Jxd+FC92z5SqOo9bqEt1NzFna9VDA==
X-Gm-Gg: ASbGncvBjQAoCumZk9ENhl3o8taRTZDj5+rmSMvXhjFi9vutxkJs+f6MdWDxP8P+Vnr
	yJ90/Oa4h7kj62aQ0/8+7tEPLTDTLPsriGgs/6b8CwFatXQDANyLgad9kinMKOGKJqsFdRIo84M
	uHHtq3fPyPhI8YQTDC99B1NM0d68kfIh/2MbPvWYxUpNGuhI0hL6lB/D5fEs35oxkIZj+qckO7t
	h1qW1rfqpjLRWZjo8uhhdxWzrEtxHGniGhX5V/PkGCCJxiBT6xFuSh/jriDlKwssx04OdMpA5TE
	MgCsjO1sUa+Kl0qIAC6M8sx5aaUR8vMVO40a+QfX7uFfw4H2xyJP8/Fpwliv+A19jK3iuKT8qSv
	3q5ROJvjMbiZ/ouM9ylR2uBMMhOQ2PZfNUHeMXSD+cEilSIQtQWrFQExrxAwTdGxCwqZb12EWOA
	==
X-Google-Smtp-Source: AGHT+IG+Tj5W92NdWije3mPfpaVge0hAviYJMSyQA0pQOVoJiSSMBQoeNIdA2hBW3oJDw6dpEiuZkw==
X-Received: by 2002:a05:600c:1991:b0:45d:e135:6bb2 with SMTP id 5b1f17b1804b1-467ea00464dmr27166615e9.21.1758290689313;
        Fri, 19 Sep 2025 07:04:49 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613f3c69d5sm128189055e9.24.2025.09.19.07.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 07:04:47 -0700 (PDT)
Message-ID: <23a67fd6-0179-4578-82ef-cf796bea4346@gmail.com>
Date: Fri, 19 Sep 2025 15:06:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/msg_ring: kill alloc_cache for io_kiocb
 allocations
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <0ee30a2f-4e36-4c0a-8e84-7da568da08d3@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0ee30a2f-4e36-4c0a-8e84-7da568da08d3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/25 21:04, Jens Axboe wrote:
> A recent commit:
> 
> fc582cd26e88 ("io_uring/msg_ring: ensure io_kiocb freeing is deferred for RCU")
> 
> fixed an issue with not deferring freeing of io_kiocb structs that

I didn't care to mention before, but that patch was doing nothing
meaningful, adding a second RCU grace period rarely solves anything.
If you're curious what the problem most likely is, see

commit 569f5308e54352a12181cc0185f848024c5443e8
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Wed Aug 9 13:22:16 2023 +0100

     io_uring: fix false positive KASAN warnings

-- 
Pavel Begunkov


