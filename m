Return-Path: <io-uring+bounces-10359-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE0FC3135F
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 14:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A7E744F73D4
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 13:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51AEA3203AA;
	Tue,  4 Nov 2025 13:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iLs1+YSm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979DE2D29AC
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 13:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762262383; cv=none; b=TGu83I55y+zl69XfNHuM9jZvThGfIaTLu9DHtbEvYiyrKzdVkTiCJmDkTR8yF151BkFnVbhd+JfSaiBq6w8d/WvLgEFE98TezhdOQsx8UN7Z7PGO+J4LlDoJDTqO4Wt3brfLdZVRnrRB1CGfO2GtboJfpEurI5B/xCz+5y/kbtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762262383; c=relaxed/simple;
	bh=h9hk75rxVl7d0Zh2++Rd24Sz7+AJRBhDgJpdTCPn/9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hNZMVn5wed7EzplYU3dDYzcQLifaruP3/TtFEGpKoyIaWKijNeEejSaOb6EzUTnUFmYRgHlPepg48zvjZSQ0BPiRIOP2JxTXvXkWI4luCZifCPCF05PpUWpZALQB0UJ9S0tcUyHB/hh7U5ANV5e8ckBuThzcosDU2Mx86KAQRC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iLs1+YSm; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4775638d819so3227275e9.1
        for <io-uring@vger.kernel.org>; Tue, 04 Nov 2025 05:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762262380; x=1762867180; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cWOHovOvm9zqFX95kWhz8f8ZSaWj90AXODW0xg1GYJo=;
        b=iLs1+YSmBqcvgTkLGGPA/F2VB/0aYTAJDGykD/kQgjSOxOgDSHQPQYycZuDiiTyydV
         QWsv1N3rhJXUDF67wAOBLc45m0tmUuCoIyCpIA0aeQtXfAlQhZRqkS3ejXTYQUbGEheJ
         9a4V+RVrkF05Joe4uUSbXV1BSSC47Iz81IlWqyTTWmYHHXpKZltH0Y6DtOZFSHpjHlmy
         qN7OtS29XgWHttdd3w+wTAB9fLin+tT9jouf9ku6vAbPcYL0BFZt+dz8mzoaH2E27V9H
         5lI8fWl108Qa2jgVvbja1ZOwwkKG6Ho95UEmeZFKoEE1VvXTBjW12EMuwf6TzUb+ElJV
         hohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762262380; x=1762867180;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cWOHovOvm9zqFX95kWhz8f8ZSaWj90AXODW0xg1GYJo=;
        b=GwVpYPXSa0LNeHRt0KxWCOTHZrNV37XcCdnYPodqb1Ezc7BmMcnnnfsGh7RJxH7smy
         JGTM6qtJm9wdurYkbeFxjpUi4jp+1itAt0+x2ZLdAdNk5QqKjG1o1HfkZ8cnjz2+aI8A
         xkQ0aMuXGh6Mwf/6PQG6UzlQLwye1eIgrgxTBeNCZc8wprP32tIZmVkFZqgIXz/75OnS
         apavJPJNxg/l9gyuMI6u7jHKif+nl2xFVlQoqWVs9xlJZ4s2GJNovr3HCiZm9d5bDxaP
         nc/a8xHlwRAb+3+b6Leb0joDIsg93f+DECGrwyGkRg3uYZMuY3nPbp/pLuRi+lQKY+bm
         migw==
X-Forwarded-Encrypted: i=1; AJvYcCXY3XuNLk2V4fzocEf/38s+pT9eAtpG/cAek5Lpn1RjPBwHFZ6n/Ln5c96KVGT9xlJ2rk1rC0VmAg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxVFBh5R4QzNc5D9S4PEjRHuQZ4jtAN+/ssK8ALAIZx5tKXiJXH
	AJ7dFc26qHY9yR70CsML/5sGKftSKF8esNj4skoRJbn07EVXw8Zm7Nar
X-Gm-Gg: ASbGncu+r8hRmYK1tY44TmgSb6GcO4iB5WtqF9fc7k2Cm2gjBNM1MsieJQhGjMUfLaK
	p71RXJxLYt/4ZwpK7gW3chYRRy/Sha7MtkTXsFfSRtF1j5wbioJCh/OmtCVPsjQBt1CPGbTbw0s
	4Wm/tSNzGBreIcXFiaPtpnuu/KgL4z0Cb0lO1NTd2hQKvgnxVknbPPLWmRNP+j+rxdcybjYtl97
	2paHEiEUvijJlYcL4MRQfuW0rX0YQknlWZMWfrZhdoPkmn3czKkTnmzcJ4gzxRwq6tkBAeLFpUG
	OkZbSriU64r1aOahh4jFVo623tJ4CnjqVgzX3fOQo3RNT2q7+pBbTag7N6nkV1IwkXr4RliR2L2
	CAJVRRANM6z+zxeh/RGdz8pa2ylz/dr2CHn+a3pco4ocAixPao7sMIqLMqFEnIITw+eqJsV8Jxj
	K4cP09rh7VGcB37H2k4GykB4nx9A7T1Igi3KqrfEVIRaBMTp2BZ7k=
X-Google-Smtp-Source: AGHT+IHY8BjfLUPxtJgLBAwz+rsEl/G+IGO6c30HiqIKn2EWKt9/FnBvS1WTFD1OB0TOWNUZhf4QTg==
X-Received: by 2002:a05:600c:1d9d:b0:46f:b42e:e366 with SMTP id 5b1f17b1804b1-477308cb9e0mr139708735e9.40.1762262379521;
        Tue, 04 Nov 2025 05:19:39 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c2ff714sm212287655e9.8.2025.11.04.05.19.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 05:19:38 -0800 (PST)
Message-ID: <bec690dd-8163-487a-8db5-0252bccde635@gmail.com>
Date: Tue, 4 Nov 2025 13:19:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/12] io_uring/zcrx: remove sync refill uapi
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251103234110.127790-1-dw@davidwei.uk>
 <20251103234110.127790-2-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251103234110.127790-2-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/25 23:40, David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> There is a better way to handle the problem IORING_REGISTER_ZCRX_REFILL
> solves. Disable it for now and remove relevant uapi, it'll be reworked
> for next release.

You don't need to carry the first two patches. I sent it out properly,
and once it's propagated to for-6.19, this set would need to be
rebased on top.

In the meantime, can you send 3-9 separately? They solve a real
problem, and it'll be easier to merge the rest after as well.

-- 
Pavel Begunkov


