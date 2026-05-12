Return-Path: <io-uring+bounces-13288-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4LnpOqhNA2r63gEAu9opvQ
	(envelope-from <io-uring+bounces-13288-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 17:56:24 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 658D65242B3
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 17:56:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AD2DE301C13B
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 15:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947613C4B93;
	Tue, 12 May 2026 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="fCUd6a+1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A133A59BC
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 15:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778600877; cv=none; b=MtGqK+aPWvi6zLp9HRKlaZiZYvCFxCWyXYYqPN/gGNPRNndHWMw7xLAlhhzTGuEkdVNTpvNdOJFFj4qY2hVyuGQ80GMu3qTzOeX3OX1Jacsmc+bJ9MDKFuerR+f3GR2q5NJLsLjle0jIG6gSqng+lTsS2gT1YJeZJbDopN3i56k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778600877; c=relaxed/simple;
	bh=+fFU7jIK5BFPkMYtAIwxntL9yQQw08VG6EF5OZCivYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DpDLCajvOK8gWiCTKANfeX7h2je7+5LZKh1euBMvAEX9UnpFrCFMWbm8Y3qgWAnJmFUbqrggdf9tM0PtGDc138o4aUxI/qa7oiCbiThQs2xcKbG2moJwBPkYlCEvNkHkBzYAIL2tE8wzjk353QF/hgJJRV09D1pdhohG3LrEz6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=fCUd6a+1; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-479fc1fc048so4104637b6e.1
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 08:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778600875; x=1779205675; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HdFF4dCw+6mO/bxdzEz9RKka+BXsp2V02/j635sy9XI=;
        b=fCUd6a+1dbTlbcXSBux+6ty7YaUaJK2/Z1Q3KqAMmY0eAiqtnrczr6SL6Z7aA0iZF6
         BHT67MdxypV8WhC16B72CE5D3TG0Ashob0PtRyi+h+O//McQTRWR7xc/79PdtTz6FzjU
         p1NuWIOTYXc+ZQhT2J9+Xk3+TKK6uXytEC0PlwkeyeK1HfnHo7UsBThAa2daH8n9QSg5
         lICLum0v2CWN85/U8OnyuDF6xieIG/LY5b8M6RZqAANb2UJ8dhzmsDQP6kdfox+vm7qM
         K4Q9i1WnmJYAyduXxMLUTOw8Q9mPJ+AuQs04KC6UDttq3VqkYNATLdxXWPB/ymg+gArD
         759w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778600875; x=1779205675;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HdFF4dCw+6mO/bxdzEz9RKka+BXsp2V02/j635sy9XI=;
        b=n5ppc2meB1QuJ7oGwdZKdUiAw7Ap96B3bvkTNeeKEq9MEBQ/H6NTFhlmrf3B7Pxscm
         ffHHQvrp7tHAwmYp2fQFFU3FYtQEg3rA89r17MNf9hgSj7COY9sw9A4WizQwQ4aLvGCq
         PhF3aYD96VBKsppVToenGcz1teSiIYFEbBpkeVh5IvOXKKGx1m524SUZ97s4JCAwtQiO
         eZ9ElOx2YxIV6p92k26FamcIJJF3A2wkZqL2nzaUd7aW/VJzVZUN0QGKDAu+ApUPnbCw
         /RKIrCv4RL63q8XXtXMm01vxzliLx76PhnNLysBojU9CbkVdafqhebQ6z+nYoY0/payZ
         feLQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mw5pjwd2gjZtCr2qUzamZrkbNYkaDhxcvaQPXV2W61vNJZJ0aSiRCZ0xi3aHPvNwFa546OzJCXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCehm1fWfAvIBI7fwfTosYwSUJqzSP94JNTKKSq1BADu9XA5pE
	kixeHSTLn9T1vaisBNQpe1i62FtmGPciEfT83VL+c586CbKeEW7FgiPyMOlgt0EyK08=
X-Gm-Gg: Acq92OFtE3y2qLYELkYpgRPUo76GCLyyQGofy3s9ee0ujSDnN/EsGrcxn2df5AfHAhR
	6gxXwmlHAj2CZj/vTPSVEIoS2URuEuFoC6nk9DruPN+9kKJ5Kx3X35FLA6rGjxoDLkyZnMgxku0
	xq4S8LQsimF+esOZmkbNppU4MaQT3TM2yYKXKuCcDialgmeiYQElLDAe1NFcPv0bcUu0C40ofc5
	1tEv0D5FWssSKrbKotTt7qzyKqNDPQxNt7cWqm9u/OEPgAOn4zAPa0YAIbbmvqM6JPzPnq2pZgc
	WHQ/k67wGxcSUBvTsKNFOwsEAPli/5D7MOSSIIq4BUagGmU2INP+Glfys3F1iR9s/7r+ubej4PO
	yVh/CjVFeok/aYfpq8RWijJIXv0DwF43Yh6TCGSIh8Q42Z9jw+hJV1eNr+eRjjIrwwNnscV0hIT
	OpdUxfLMckBlzFM1nEByia85GudMjMCrrHLds7DKRzd6UbgSnl6AkaincXUUGlDtwoOI2IJJpBD
	9Nx+P0TJOJ5cM4vn4U=
X-Received: by 2002:a05:6808:c298:b0:469:fc59:b128 with SMTP id 5614622812f47-4829731fd75mr2139910b6e.25.1778600874805;
        Tue, 12 May 2026 08:47:54 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c76986f9dsm22873454b6e.16.2026.05.12.08.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 08:47:53 -0700 (PDT)
Message-ID: <e12d01e9-8934-4150-bcb3-09ba147fc842@kernel.dk>
Date: Tue, 12 May 2026 09:47:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time namespace
 for IORING_ENTER_ABS_TIMER
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Maoyi Xie <maoyixie.tju@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>, Maoyi Xie <maoyi.xie@ntu.edu.sg>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260511221931.2370053-1-sashal@kernel.org>
 <20260511221931.2370053-13-sashal@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260511221931.2370053-13-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 658D65242B3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,ntu.edu.sg,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13288-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Action: no action

On 5/11/26 4:19 PM, Sasha Levin wrote:
> From: Maoyi Xie <maoyixie.tju@gmail.com>
> 
> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]

If you auto-pick this one, please also do the other one in the
series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense
to do just one of them.

-- 
Jens Axboe


