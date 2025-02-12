Return-Path: <io-uring+bounces-6359-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A9BA3287C
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 15:33:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A34C07A1B60
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 14:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F0620A5D9;
	Wed, 12 Feb 2025 14:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GMzf8MoH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEB127180B
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 14:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739370788; cv=none; b=cLoFQ430EWEi8ZF2IZnzQTmypfolQtEp0D4qkpOy64Etei7Y9mNc5gB4GTGcAK80RCsMkYhPDCx5v/wgg7h/amKj0zsrNwhJmqy/QQcsLMS5gLrrIwLucRVQSZUoB8uuQBIJBqRuuYPIXkECo/w04DLKUqI0aWBCw2vz9Ryeq0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739370788; c=relaxed/simple;
	bh=0f2EQwDDq9734O0OGjNFVVBvocW3pfd47UxppYEdBgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YY/9XbZmJDR9qkUfSMNvX+EqdzVsxKz4mianh6/BOjziVdoIVMOoworwv801AN67f8mWrL4XE8PdWWbAF0ppePOAPTH85dkA5PnGw4D2I9AwelIkGT2u5ha6m0lHycgPbpA44V9QMdZmZXfvWp92JhT2SmWDQmfJ4My2lFu83BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GMzf8MoH; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-8551c57cb8aso101217739f.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 06:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739370785; x=1739975585; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=peoerMowyAdqzi3bBvUB4SpI4jby2jAJ6MDoaKDFOw0=;
        b=GMzf8MoHGnm68DKKzX5k11XwjrNFstJxKL+yEait/2UTPV2qXa09xLQZjlyfwmw6uq
         wkVXuktUUaLGcWzBtJNo0Evn9L2TmwdgZYlX5ofyqW38VHiuULYL3qBgsPRV0fRjwVv9
         4bLHnpEOIH/5+0GSSED82YtLANWgvm7mKE15D8AqhL5elm3DOqpnBcFR7t8m1toNVdMy
         vram3bkdhrwv5D7ByaKVm3eXu/Tai7+fRlHz5nMANaRR3mKSv+aFZ6UYUX9fwwe7NjNG
         Oe0xC9Zx3dKNj7v/gV9Xkue1uI3DQa8SEbzyzLZPy7TgZv2pPySQ9eFl+WsnWYEszCOB
         DNoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739370785; x=1739975585;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=peoerMowyAdqzi3bBvUB4SpI4jby2jAJ6MDoaKDFOw0=;
        b=f5wk8GLJziO5dIcclcBZiLuz6dx+1oqTn6vRMeRlaMmpGzfNqZesc5YS3N0Lck8mSJ
         6vrT4Jujuq+Jak1Gzi1QslxLoUa8QCSgo3EkEgrG5kUOnotGyhu9s3FKNvP0qwRwEst6
         YKVznhoaBr/ynzwNfJZusEfPCL5sn1Jmlj3jaTKX+vc9LEKcUMikLEKfVjgcVSI3nqDS
         zdtrAiFzCCjNHTjjTbnwLEj+7QkVoEkGHzvnWOwdZKm05VVI9+BMr/EiyCBQXS+S6gSR
         nOI4ZFjUgQEnjTh34z77LYTDc928a/FikDiponDmj/yf1WG1reogs6iTLHTogEKZbDx9
         A2Kg==
X-Gm-Message-State: AOJu0YwhEfD6IwnBvQWCIrLNkKnrobnEgpDMbPiRwnvp+EZQLijkZaKn
	hgZbz0PGQyFuQL5wQjhjlufjdASicpzHE8Qcg50egqYzn6P2/jNXAqLLNPkbLqwLiGx95Jk/7LP
	A
X-Gm-Gg: ASbGncspVCufzGtUuVkfRXJDOyBKeSDiOzH4WSFQpYMvmRHegFtA+rM1UbQhUbGJwtG
	8W54+MP+CgRstOFLkCn5pDI+d4EbhfRTw/qNWianPwE7SNP2dupYGbX0lysqFs3onUOGdeadrL9
	suX11Xl5Thagqq/EOExAuT5vii4GL4XGk76c8EF4+pM66z8sMrWO8K9Ht67mXIjGOY2yWNPoNbo
	FKzyqHk2VDWCC69fmWklJ9I/xUPQ38YxozhXIuEBlkjARj8u598WGqRMASIENnNMw975tEbIulj
	D/JGWg2dAPA=
X-Google-Smtp-Source: AGHT+IFQPl2NACyIg7LsMY27jKX3GfJPi4+tUAjlVGjMYjpj1xJhkpqIUrB9sGSVqKkQRZ4CAmmtDQ==
X-Received: by 2002:a05:6602:3419:b0:855:6189:26be with SMTP id ca18e2360f4ac-85561892826mr27903439f.10.1739370785211;
        Wed, 12 Feb 2025 06:33:05 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85525793678sm173159039f.4.2025.02.12.06.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 06:33:04 -0800 (PST)
Message-ID: <8c21acb0-aee5-4628-a267-a4edc85616c4@kernel.dk>
Date: Wed, 12 Feb 2025 07:33:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: pass struct io_tw_state by value
To: Caleb Sander Mateos <csander@purestorage.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250211214539.3378714-1-csander@purestorage.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250211214539.3378714-1-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/11/25 2:45 PM, Caleb Sander Mateos wrote:
> 8e5b3b89ecaf ("io_uring: remove struct io_tw_state::locked") removed the
> only field of io_tw_state but kept it as a task work callback argument
> to "forc[e] users not to invoke them carelessly out of a wrong context".
> Passing the struct io_tw_state * argument adds a few instructions to all
> callers that can't inline the functions and see the argument is unused.
> 
> So pass struct io_tw_state by value instead. Since it's a 0-sized value,
> it can be passed without any instructions needed to initialize it.
> 
> Also add a comment to struct io_tw_state to explain its purpose.

This is nice, reduces the code generated. It'll conflict with the
fix that Pavel posted, but I can just mangle this one once I get
the 6.15 branch rebased on top of -rc3. No need to send a v2.

-- 
Jens Axboe


