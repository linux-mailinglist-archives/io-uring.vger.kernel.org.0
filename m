Return-Path: <io-uring+bounces-997-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C90CF87D740
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 00:13:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EF6A282AAB
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887FE59B6C;
	Fri, 15 Mar 2024 23:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="c2Z3ntbn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED195A0F2
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 23:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710544418; cv=none; b=Kbh9txUgT4dnKuyar/WdMAqn8efBrLtNv63ii9uaTzaIsJ3nJ6JtlXZ2g+MQT243F0NDX444bHwPdyPAktMj3ClAuZHPvFeUlVgsphFd4qe4EC2s6OTqAAnaVvboHppkHeQ7pn/46HXPajY1Zxj78y8JQYhG0F/xNn7BgdXYB2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710544418; c=relaxed/simple;
	bh=tpMjBXwSSuQmobbL7+xuRt6iKBMLkgG6AOoLK1hR5/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kyPCribKmtRvnl4ju6RSpYcG7+JbgPXAht6JMe4CRz80Gwe2zFs28prEJwkFhSahdl7UwU5k5iPwKfaRoRUY2KMmJfsSl5dUBKQTr4XAd9cfNQT1OBsvjkfkc7o67oYJM1zy6xM4i7YBIV8DGFSCsmeM1GbHtm8Xt0nyQP26nOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=c2Z3ntbn; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dd8ee2441dso5234375ad.1
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 16:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710544415; x=1711149215; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NcEWbJDtOYkeCRXFqgqEqEDpZ0LR9+4eqggYU6QodD8=;
        b=c2Z3ntbnoNQh1vUw4lQJVHj/9fDwoQoRWKCYirAUKElOXmg9yfVsmvfN0cGLVb/8uk
         96wEaO0lR9BE7RtQ60D3aiFe3gV0fCzVvgIVWYq9MOjz2KvIbx45k9uzwFb5yGNfOdVS
         TSTlrXn91kmG8krJ11ok9tNaUk8V8bipYd287MI6Nfiq3avz0pZfEvD0Qwnl6g+UiuRV
         336Vv589SlzzTz5R/7A/ZPYYp0NQIHeXj8w5iMshmIBS0R8Up+J1eep2VLC4yRRLLJk0
         +n0F4wSQNSjpRb/tNLKCkgytuiQt7hF0CNL3KTJ2rsV5TnXmxNPaW2mlSDX8Sg/egmvy
         Ntig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710544415; x=1711149215;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NcEWbJDtOYkeCRXFqgqEqEDpZ0LR9+4eqggYU6QodD8=;
        b=trfCuCrT/MBKacr+1M1fJgD4dyoSz/nHeP3ITbATv9oMibZUO+9l2BGqcr/36QssIC
         gUgzJK0a/Wq+4RYnzv1MxlHxz8vIF5eXq03cJ9iJbsRJRpB7Ey2iTWDRL/wlrrhBfmJK
         SZKn97kD/UzsAePmpCU3ukjPUqiRdywT4wajJV3bWEtR+BU19WNPOVSAalcigJZbwgQN
         Vp5yPZaMVwpdKFtqTLhzZB8ue7y0PUqyRJ7NCMPVltmvy8Uce2WCHfzPUYzBhRxXpWdX
         Nx2+LaSrMchFKL6DL3ozcjTP0Sie196z0Q3c3+aG4NnqNUfQkWMRwTp6e6EVFUVXPbIs
         wGEw==
X-Forwarded-Encrypted: i=1; AJvYcCVE6FgMI4xKszqUUlT0n2sz4VDyQuD+zNOneNCi4b+0BtNyBAGQFDqEn0CamrYkgFALeXFicu0GyFIIKq/lXfXv5R7MJX8Ub8U=
X-Gm-Message-State: AOJu0Yy7goARKJDrvO1dOPaEU3g8pb65LvpBoyTX1iiJe5/oVyidnImi
	7ylhNowE2b85KNByHyKyGOfM8S4qth5ljN1nCChhGELbAj/cDQnzQlnc9nhmWNw=
X-Google-Smtp-Source: AGHT+IG+yrvcxwIAQzJ5S6AsueX1Nv2C93nYrr8zd9o1XWou1Cz/HkgUgpRnl4urftkQxyxZu8mP9A==
X-Received: by 2002:a17:903:186:b0:1dd:6f1a:2106 with SMTP id z6-20020a170903018600b001dd6f1a2106mr7019371plg.0.1710544415565;
        Fri, 15 Mar 2024 16:13:35 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id f7-20020a17090274c700b001dd6da21e30sm4401310plt.231.2024.03.15.16.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 16:13:34 -0700 (PDT)
Message-ID: <c6753d20-d5b1-4bba-ba83-5db5bd24a766@kernel.dk>
Date: Fri, 15 Mar 2024 17:13:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: ensure async prep handlers always
 initialize ->done_io
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <472ec1d4-f928-4a52-8a93-7ccc1af4f362@kernel.dk>
 <0ec91000-43f8-477e-9b61-f0a2f531e7d5@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0ec91000-43f8-477e-9b61-f0a2f531e7d5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 5:09 PM, Pavel Begunkov wrote:
> On 3/15/24 22:48, Jens Axboe wrote:
>> If we get a request with IOSQE_ASYNC set, then we first run the prep
>> async handlers. But if we then fail setting it up and want to post
>> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
>> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
>> potential errors, but we need to cover the async setup too.
> 
> You can hit io_req_defer_failed() { opdef->fail(); }
> off of an early submission failure path where def->prep has
> not yet been called, I don't think the patch will fix the
> problem.
> 
> ->fail() handlers are fragile, maybe we should skip them
> if def->prep() wasn't called. Not even compile tested:

Yeah they are a mess honestly. Maybe we're better off just flagging it
like in your below patch, and avoid needing opcode handling for this.
Was going to suggest having a PREP_DONE flag, but it's better to have a
FAIL_EARLY and avoid needing to fiddle with it in the normal path.

-- 
Jens Axboe


