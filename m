Return-Path: <io-uring+bounces-9100-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 199A3B2DE1D
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 15:42:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 792193BA82F
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 13:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CC672E426B;
	Wed, 20 Aug 2025 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kfRIqEa4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61687246787;
	Wed, 20 Aug 2025 13:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755697126; cv=none; b=V2MVhzL3BdcNusWxECGjCS8aJ0RKIwXDCSYf3yP3BflFfuAGyY2wT3x/MZKX5hCYkz5o7AM6EPF+g0GWFuN7h4UV5zjxPl7Ei8uph4WIavdWjw4V4n9Psos5FIKqk/jKRuLp+9fMzgY51nfLzi6ANSlIuSJv9gMYcGh3ps6KauM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755697126; c=relaxed/simple;
	bh=CsI4RjI3cQ1Yb060kCDcQBEjcZPg5lYbY/6QwHlCdxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tM8sbhakrin47KtWPQTTmTxLUtCYY5Dd91EIhADNfXDqb2lVxeRBKY3mNUxd7dIGg2zy+Hy+kMVzGWGjkbOCumzP29nzHxkU5glfD2ap7+8bcVpw2tE4p34FZMQMxYwCdG54BJR1bSdl7V8rB5nLamdH6sfFLEoB651wRXrw988=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kfRIqEa4; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b9e415a68fso5476434f8f.2;
        Wed, 20 Aug 2025 06:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755697121; x=1756301921; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BnszY7qdLJPaLDhbOf5AahqefmZN6BjfGVR11anVoas=;
        b=kfRIqEa467FKmqRFz9pd5TBLW2BMUdm+cxWQ6hfOGnc/kC6n+0zp46bqUMl5Es8a2a
         pL3MorBSxI6vnS2Z28wp1Am1RAwy9Q8A7ADL4KxDJVir7knpF4IvC7s23JmZzBj2YWIt
         2MhPnYwo7nwqW6N5l5UicuYnL1Z3mV3qJSSCv0eqsVqyJOlxMFim+vhomNZj2OoissJS
         wNmTzbH4WTzCuwD+Aq6y1f5JiaWpAM7KdVnhL2Ppd2557vOJNdel3mgEAO7qHQCxIUk+
         GLoGhgQeva2gmeo2qkBG0phicPE8N68AAwVD4mICSnD4gB+r6fE95w1vRKUBIcXLipFz
         5ynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755697121; x=1756301921;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BnszY7qdLJPaLDhbOf5AahqefmZN6BjfGVR11anVoas=;
        b=nxupB6MoscMMQG1rZLrmF3XqvlVohfbzh+hi5oxfMvCmQM2hN59qPOucbxcuxv/j9N
         G+ZdepmKAHbzx590yJPxT1eWSwqkTsbUpbr2l9my8UhQHuezZPPrMA9SysDVRhS/4pju
         qp5ktOJZYICipHbQ8c+YNz3HgctcNB/UolKcUxOnfO8ttgxEaoqsMApql4yss4188bXt
         t0Jq6VJ1qRSdAAd0FpjkTsdL2ayumDczjH+XIqXOzVqrAXDMXYslhmxTccaWccMEHj4R
         lU4rjIwhXNe0DZ82TH5hyukT4aTD9gIhQBe1cyxijn8CZVnoobKDqgCMGQji3ZydEizR
         L0dg==
X-Forwarded-Encrypted: i=1; AJvYcCW0mo0OBklvq2uemoh6zSjCFv0NCgy1zhu49r6Q8X3QJDOrHcterW1IIJEq+Jnf5O+kq+dpXeEkrg==@vger.kernel.org, AJvYcCWgk7V5JfrqQTKaV0FOt6VMrZbWjWf+gyKvNZNLpGDqXSAuUh50YpNhu21wonaOn6SUFjB/PMSOBgBkuiKN@vger.kernel.org
X-Gm-Message-State: AOJu0YyV8PM94WGycW/3CdCDXOArsCNQwsQ8jtFQteZCL8AiIMJedBav
	Mbcd3EEcLaL9Q17T7NQ13qqlUjZK8t2eCfgLUnJQ4mUxEU/yF0unFjvN
X-Gm-Gg: ASbGnctUoc6B0JO+4TAYTjWkpv8INtG8+hQDhRWLo1Ik8UCaw0Lcg3/eEPbZZYuAPn0
	CZIWFT83SHj2EcdHIvqn0i7uh0Rzlf/J8V2Ebk2VLgmgx3jibiDBkvxTmp7ngvVB99aFnkjSi9e
	ItbddrpOuglCQf+a5WSK1BwiWEtNsk2Q2bP6qWl9D7dY2j2EHCQtLyEj5NglD+7XEKCMrTv5YHr
	4lxFoMyZ4no32//C7mgOLp6usEYFELNZ/6ZR8xqKX5rioskl6Aldes/cVIbU9OyOU0hcwYYUBRm
	ZLJsVQbATpEFcb62qBzA8CI/pD6R91ORjAfYZZ0qIjO4dL5qMy3OZP4ZaFf31xw4lrp7hgD6EvT
	gsXDIQwbXJJKSl+/Ae/0tteeuG9HBSS7h+2mTvtH0R86aFOT2pbjOk8k=
X-Google-Smtp-Source: AGHT+IGwjO1/Hhvi0RBOBXEAD7D44EX50p2Cyzh5mwqFRLIy6PGXowsI2dZ2cPUfLqoWpDaxPu5fLg==
X-Received: by 2002:a05:6000:2012:b0:3b7:76e8:ba1e with SMTP id ffacd0b85a97d-3c32c24986cmr2398670f8f.11.1755697121369;
        Wed, 20 Aug 2025 06:38:41 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5f7e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c07496f432sm7700133f8f.6.2025.08.20.06.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 06:38:40 -0700 (PDT)
Message-ID: <fb85866c-3890-41d2-9d5c-27549c4b7aa3@gmail.com>
Date: Wed, 20 Aug 2025 14:39:51 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 00/23][pull request] Queue configs and large
 buffer providers
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, almasrymina@google.com, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <cover.1755499375.git.asml.silence@gmail.com>
 <20250819193126.2a4af62b@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250819193126.2a4af62b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/25 03:31, Jakub Kicinski wrote:
> On Mon, 18 Aug 2025 14:57:16 +0100 Pavel Begunkov wrote:
>> Jakub Kicinski (20):
> 
> I think we need to revisit how we operate.
> When we started the ZC work w/ io-uring I suggested a permanent shared
> branch. That's perhaps an overkill. What I did not expect is that you
> will not even CC netdev@ on changes to io_uring/zcrx.*
> 
> I don't mean to assert any sort of ownership of that code, but you're
> not meeting basic collaboration standards for the kernel. This needs
> to change first.

You're throwing quite allegations. Basic collaboration standards don't
include spamming people with unrelated changes via an already busy list.
I cc'ed netdev on patches that meaningfully change how it interacts
(incl indirectly) with netdev and/or might be of interest, which is
beyond of the usual standard expected of a project using infrastructure
provided by a subsystem. There are pieces that don't touch netdev, like
how io_uring pins pages, accounts memory, sets up rings, etc. In the
very same way generic io_uring patches are not normally posted to
netdev, and netdev patches are not redirected to mm because there
are kmalloc calls, even though, it's not even the standard used here.

If you have some way you want to work, I'd appreciate a clear
indication of that, because that message you mentioned was answered
and I've never heard any objection, or anything else really.

-- 
Pavel Begunkov


