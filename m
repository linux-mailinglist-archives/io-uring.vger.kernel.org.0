Return-Path: <io-uring+bounces-9893-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4177BBCC24
	for <lists+io-uring@lfdr.de>; Sun, 05 Oct 2025 22:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 883F83AD90B
	for <lists+io-uring@lfdr.de>; Sun,  5 Oct 2025 20:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0021DF248;
	Sun,  5 Oct 2025 20:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Og9Je7Rf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382E086348
	for <io-uring@vger.kernel.org>; Sun,  5 Oct 2025 20:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759697773; cv=none; b=PVSYZJYpIFK3DsA4bHfy+f013ol6Xz05HUCUrpfrpx4xPc7ETzVzjVAc46g1wF+i3mKJ60mR9oMz9gKOa5FZg5ubVs5rZCo2RRRpT57X9OQlDc+cllNNki1tlLdgB6ygOEtj64x40dymHE3yRslZsDvcsWa/+vhXLrhMy6f65p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759697773; c=relaxed/simple;
	bh=B+qhONeuPlM1lF1BCqN081ZYOajPHqCZyapmYRfko+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eEDftqfY+kw2hyZzjxtORokun2wwqmiAhHMsmbl6jnGoWWaVJHZDqfswnU7jDoXfnQ0vD3+Sc1DI/KQfuW2SDQsXnwZGw5/cT1QeBmuxmiMYxHcx6VBotkKf/ietSxqJ81PeIW3jAcA/cgnbphMy9zmioNX++K4ICbN75p1c1+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Og9Je7Rf; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-92c781fd73aso353535739f.1
        for <io-uring@vger.kernel.org>; Sun, 05 Oct 2025 13:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759697767; x=1760302567; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GTAqtttZUouq+BnnUgYy9PyhS7hCJSZv/3ujMVxhgHU=;
        b=Og9Je7RfqmoT+5QTiXnLXjswoQmIXVcI6D9qgpCEnrCrAQBv941BGeC+V9I5VLtdXT
         Uii9eteQEi52FGnBO4qwznZsdT11RGR6kM7yZ47nH/e9aIVnMJ1ajXIN6rjaxSp5zXKE
         IvMKUYzZQlc92UOGZ+bELs4y7O1+QWTK6650Tz/yZoAFcdunbS4uD+uDAyVvC6o5tOC5
         oJ6acoVpE8kkfnzn+JlBJBmetQfKoI1ckO4VfPP0ssyvq8y9mrrpiBsCEIgSu4cbkp10
         2WEAffJdNCXjn/yeCnm3oTI0s/AOaADoZRHK5cd2JMmOdPTJmYX2zWEITvVOckeqkIJ+
         gvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759697767; x=1760302567;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GTAqtttZUouq+BnnUgYy9PyhS7hCJSZv/3ujMVxhgHU=;
        b=mludC4ggeiUBeTAi/iPEHTE6AQ+VMsdexQlZ+9IhJ5bQY7qi6KwfIvmDbsvzEl/PW0
         nTVTWW58nJSF6FmPkCDRg3XAxS+2NBO/zW2NdEhUhAjdSLTyGQ05T2WejPMNwgVKsPY8
         kNWyZOceoilic44nA55/Ln0wv4+Hlw+2L+wDyuHWCHLRFxmAAn0g+ArbAomllxpGfNU5
         lTQrmh3zZHL5qUKg83zI5iA1xmUlPOc13KauV/YJ5d16BFGKZz/XiuNX5fQqevIrwaNq
         oiT8mngJsGHmIlMvzHa7qhv1h/TKMUubWeO9/LbeRnGaxQwJTXm7x8qLSFan1bY+/YFl
         0wNA==
X-Forwarded-Encrypted: i=1; AJvYcCUvHYuavKVgMtrc8RlGEOQk4ukUVkpDkAFgyr8iKNV1EAqORjz0vs1drF44J3kwfL4RCC3CGV0kEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLHcj86EjQ1Ab8+la+xILzU//d8xvydwcgNZtOb1YFX5AbGj+O
	Jad4hLxvrZOPtepPgTpyg4Y3zOZ46In/AN7xGxFAS7VSz5m0S+VxGYiyYTXi3b1gU/GxNWIJ6wp
	G+QYozn4=
X-Gm-Gg: ASbGncsFCdVwt4IHBbyAHjIc0vyLYWG3R6UrIOKWoL/qFbtHEUIYeRIvm+useTHyeCH
	RUEq2K58GiBnH6o9YX3G86UKmSSJrWbySwHFCT65ZNpcjRzqLYP1KvqZkJSeEvCNaJG+vv8uxxi
	xyxBxKKzBoPo8ivV0U1NMj3gKsbcYEAybv8r4fMVw1M4dehnN/VUtUlw03K5CXey1ZXgQcH3wzV
	YZMO/pEw48/uq+jaNaI8qc3cx+Xh+ohMKy6q1Utu0LxfeeD2KT4fWcjW0xBRIJ3/30DXyxta9pU
	DCmJl568ytoP5OlDu5qGEosXuoiMA5v+u6gxQQrPzUSoDGo+JrGMT1CLxDzc6qc2CfhqysN3Ey/
	6zF/0zFVCwDjz+3arnGRK01SKZWcHrZbfLRx8smJMWtITtB4Sv3OuCOQ=
X-Google-Smtp-Source: AGHT+IFpGLnbKh3EsGD5lUczNeVdSiO/P71VUf2g8EuelMbO8e9q8bdas/6K4tFkor2NV3rFB/t9bA==
X-Received: by 2002:a05:6602:640e:b0:896:db58:683 with SMTP id ca18e2360f4ac-93b96915542mr1411402139f.2.1759697766841;
        Sun, 05 Oct 2025 13:56:06 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ec5f51fsm4067437173.70.2025.10.05.13.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Oct 2025 13:56:06 -0700 (PDT)
Message-ID: <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
Date: Sun, 5 Oct 2025 14:56:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CQE repeats the first item?
To: Jacob Thompson <jacobT@beta.pyu.ca>, io-uring@vger.kernel.org
References: <20251005202115.78998140681@vultr155>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251005202115.78998140681@vultr155>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/5/25 2:21 PM, Jacob Thompson wrote:
> I'm doing something wrong and I wanted to know if anyone knows what I
> did wrong from the description I'm using syscalls to call
> io_uring_setup and io_uring_enter. I managed to submit 1 item without
> an issue but any more gets me the first item over and over again. In
> my test I did a memset -1 on cqes and sqes, I memset 0 the first ten
> sqes with different user_data (0x1234 + i), and I used the opcode
> IORING_OP_NOP. I called "io_uring_enter(fd, 10, 0,
> IORING_ENTER_SQ_WAKEUP, 0)" and looked at the cq. Item 11 has the
> user_data as '18446744073709551615' which is correct, but the first 10
> all has user_data be 0x1234 which is weird AF since only one item has
> that user_data and I submited 10 I considered maybe the debugger was
> giving me incorrect values so I tried printing the user data in a
> loop, I have no idea why the first one repeats 10 times. I only called
> enter once
> 
> Id is 4660
> Id is 4660
> Id is 4660
> Id is 4660
> Id is 4660
> Id is 4660
> Id is 4660
> Id is 4660
> Id is 4660
> Id is 4660
> Id is 18446744073709551615

You're presumably not updating your side of the CQ ring correctly, see
what liburing does when you call io_uring_cqe_seen(). If that's not it,
then you're probably mishandling something else and an example would be
useful as otherwise I'd just be guessing. There's really not much to go
from in this report.

-- 
Jens Axboe

