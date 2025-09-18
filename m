Return-Path: <io-uring+bounces-9831-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FC80B83E79
	for <lists+io-uring@lfdr.de>; Thu, 18 Sep 2025 11:49:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 024304A2CD4
	for <lists+io-uring@lfdr.de>; Thu, 18 Sep 2025 09:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DAB1F4717;
	Thu, 18 Sep 2025 09:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GiBsaqek"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D30E274B37
	for <io-uring@vger.kernel.org>; Thu, 18 Sep 2025 09:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758188967; cv=none; b=c/tzTZec47iGIW47LR9KI8x4oaOddDrn+6QmO42xQ0ZZtwKGsjv1FJGjo9u0VTw/avTWh3S+cwwTJpsifhdeVLxrHLSJbTJLOZFgldOcc/Zbc/HNgKmpuKdWcCw12k/+CLfzh0iETAdc9KsAm3djSNg2958hp1jKXmY75O8xMBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758188967; c=relaxed/simple;
	bh=m9cXbMCPeggzRRBaNkdVn568LVzID+Htz4uWJHuIxWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Mmpu/gOmZIepXI9wgQ5cdjBsUo0AJGy9dNOJAs+vOdi4ET7OwR7VoQ6KhH6yW0pUlI5Q1UaCb2qirr0AgmH9Dsn7t/vlzk8j8jvLTkaWuNww4i71qR9E7FxDlGsF5qnLiow4MNwoKr/Q9PviwG15dxTwJoismFMdC9YwiujbvLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GiBsaqek; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45f29d2357aso4949655e9.2
        for <io-uring@vger.kernel.org>; Thu, 18 Sep 2025 02:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758188964; x=1758793764; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=en63RdzkodfpXQxvX4tvxYYssNjnpRwL646woZnUhH4=;
        b=GiBsaqekswzNh5bZ7HLLgw/Obvac7PVDSNhQhtshlllmT6VNuOdLzHpbN3diman8w9
         DHV378QaE3BxzIldl/nmjP/y5sM9m9KzLeruZz419S0xmcRO/XgFezUhgODFEKsj7RmA
         Pw94LFnwRBJqKEZghPetxb49dF9rE6mrJTqyJSPXePibgQ/FdUaDIf7s0/n+UXDQkaWi
         npntJGX7S1ovt6ajxP7OY6PabozvhrBMAF+fHYq+D1ssGqrs8ryvGexnwLy9H05M0Pu2
         QCYLYnyYyX2rGFSd9Zndhyf3LI8UinbbDSnkDj3FDjQ6dlzvB/Dv22KMwNtm2e5v+Ee2
         HXTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758188964; x=1758793764;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=en63RdzkodfpXQxvX4tvxYYssNjnpRwL646woZnUhH4=;
        b=jYKHljxrWpo69iVLfiVxhbj0Z+igLbPOeeJ65w6wtgN1vj7Qvu8H5aoxAa/01t0IbG
         GyFva1g95xzRb0FKN2cPOtj/T41dnQyakk9rSLhd4eSnLZYgOPLcW+mp16/uFz4iraVe
         4K+odQUPAZelPtvjX+FtPrucj5Ni6zXPGvBLhNiHMe32iP7q8zzYr10f7PFkc7u3fkfD
         KSWfMfAqvsy3Arv4ulQZymVt0T9DcSrrFSOAqQL19Deu1HuITAurY2xYAQ9i1tpj65jj
         lir4OtfN3gd9vOVmL4l5K6fBEuAfsUXu7AgDOB65GvzWJfsB8E4HSY5uuuZqZFj0j1Am
         MlsA==
X-Forwarded-Encrypted: i=1; AJvYcCVcuatKmm6VQ7Wu0sz5Ght/lEsv+1X4FjPyEGOvRzauq57+ZChm2O/4QeGr3mm/aIV4puttXRN8qQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxM3E6jhASoRObts+JaBHh5yd3eEz2nbVexZP6T53HvKY0oG1GR
	8ElXBiqzucCN4WDV/t7kP80ny3TslXkL+Ct03fwrx5MkF9RY3YQ6oqHPhJUAoA==
X-Gm-Gg: ASbGncs8FjGMb8MUij9eOVv6t9ZyIi8MU2hvwV1iV1dK8sK7M75+nE6bQCf7wqo25KN
	3Fc/J+84B2JWtMcU5z2acs8KniTAWbrG9NDYXvAM6nil6YKOZJAKtWH+ez6Bow3e6cbPfeBkl8w
	0pvrRS/0UGj0kRyUdH6pgQoMwKZpAjpihXKACLt1/4GE/EmcNGDlScRjlkF6qfYXI8jFbvYHHrH
	G+rv+D/6g9dCwHJ2jDtnIiHlF3mmj3Lx4P1NHsHySKbjZ/m1CHu75b/Pq5JoDRV4O9IhVg6OhwX
	/0R1aghCRvZMyPJqrCt2tcjJ98wT9YnovA+Wt8OiH39fVJDMs/X1eoCyw5NUh/snjXtEvFhYTy4
	1jnw4ur3Fs9aloxQaYGeftOHGn6O/YrmT+C9tm2S+1+g3ndKBNoCsaueAZdRTc+mAq52XE0Kubw
	==
X-Google-Smtp-Source: AGHT+IHqa9eYgfRuE7DD+wr9DjUGHadatCryTXl952BjI5kbRa8Q5HbiwF7Nv7pPkPz79ozq63MJBg==
X-Received: by 2002:a05:600c:46c6:b0:45f:31d8:4977 with SMTP id 5b1f17b1804b1-4620683f20bmr59176345e9.30.1758188964111;
        Thu, 18 Sep 2025 02:49:24 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5265])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee074106f4sm2927923f8f.25.2025.09.18.02.49.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 02:49:23 -0700 (PDT)
Message-ID: <28ad25c5-94d3-4e30-a04b-2514e825d806@gmail.com>
Date: Thu, 18 Sep 2025 10:50:55 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] io_uring/query: check for loops in in_query()
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <2a4811de-1e35-428d-8784-a162c0e4ea8f@kernel.dk>
 <a686490e-03f0-4f21-a8d6-47451562682a@gmail.com>
 <6e347e14-9549-4025-bc99-d184f8244446@gmail.com>
 <3acf3cdc-8ace-42e6-a8a8-974442d98092@kernel.dk>
 <437ebe86-3183-470a-b5d3-1d5ff8557e01@gmail.com>
 <da6a8cb0-d726-48ea-8f10-2e5852e5acd3@kernel.dk>
 <2ff474cc-f388-4ec3-a17d-23bf720b46bb@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2ff474cc-f388-4ec3-a17d-23bf720b46bb@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/25 19:35, Jens Axboe wrote:
> On 9/16/25 12:33 PM, Jens Axboe wrote:
>> On 9/16/25 9:05 AM, Pavel Begunkov wrote:
>>> I'd rather delay non fatal signals and even more so task work
>>> processing, it can't ever be reliable in general case otherwise
>>> and would always need to be executed in a loop. And the execution
>>> should be brief, likely shorter than non-interruptible sections
>>> of many syscalls. In this sense capping at 1000 can be a better
>>> choice.
>>
>> Let's just cap it at 1000, at least that's a more reasonable number. I
>> don't think there's a perfect way to solve this problem, outside of
>> being able to detect loops, but at least 1000 can be documented as the
>> max limit. Not that anyone would ever get anywhere near that...
> 
> Forgot to mention, but I'm assuming you'll send a v2 of the patch?

I assumed you'd want to squash something into your patch, but
I can send it out properly.

-- 
Pavel Begunkov


