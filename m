Return-Path: <io-uring+bounces-5878-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B7FA127AB
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 16:38:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D62631667F3
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 15:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D9A1448E3;
	Wed, 15 Jan 2025 15:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JysviCOY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AE620326
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 15:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736955531; cv=none; b=Z+wpwjfahnHLTM//4p0wf3HY4dSjrUEDeL+o2KGvL1/YqId+DL0x9YiyJcz+67kLRVRVtpFx7jDr/6tul1ABDSAE9Q1IhBA7G5TGr8BHqks9Mr9JcPkDiZ8I9Ea15gk5LhjDG5ytFGh9bVCkB5gBVq2sRWvW9e83+vJrESZkQQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736955531; c=relaxed/simple;
	bh=L7n9aTXc7KXXI7Kiq1+l+K/qjNj6jwv9RjIOESNjsME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XE3XfUhyfFse1xkuhavDMWsTavKE7OXrXcqSMORTlzv19WqSH55dMGym4I+L46gtgw+0HrvKJTdCioLMe6PT4K+Nza+RE7IxaTiFyz6mVURQP5zQcYQTv6hKafGg95jk5TgpboMzV4YfDHG1JDq38XUSbgMKlILtZ9k6E5N+o/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JysviCOY; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d932eac638so13212168a12.1
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 07:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736955528; x=1737560328; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6YZxLeGn3GpBlD9P1IzEb/3SRfb//VOSl0/WHYWErS0=;
        b=JysviCOYHcld43iNsB1usBngGTkxiQ7nI0apfR4OU5PJkyKVJrKLiSIl7N6lJqeHhB
         kNYzn6IKzSdz+vtr/yvtWM5nj6Se/8oXK/tE2qxJ6+Xqe5vDgdD3i32QBiLeEoceyGeM
         doR1g7/Ntr+GqiSVhdPyC3SwYIugb6bi8YoG29IqGr3EkXqnEsKmmGTSHtCC3le3g91x
         3WpzwY2utAzsyH/CxzCbxtbFC56QaF+yMTbikMsIrNJG+z8pCZYV7Z6OoQSjuUOSP3RG
         fKye7yy6TxHKPiDyv1msjW8UCIoleLKZDFdClWJupQpVK3J3YozPWVszgux0sARk29gA
         YJxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736955528; x=1737560328;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6YZxLeGn3GpBlD9P1IzEb/3SRfb//VOSl0/WHYWErS0=;
        b=KZQzLsNa/DogN6plL9yI/ktcMrsvkVQD161sMYR/HV5tKPZDUpxjeb+sv0Cu30bWYz
         DgInMvfUDuI1b20y9GA6EhcQKjJZzItPjYi8Mi3SJZkaJgz08XV5EcQ5gLzodbXmIqri
         ek7uGJcL2EUnu4utRRPyPSyAKrRNpsZ5wiv2SDROEKwRJKvjC0Lp0MZzKof6SD2JdOAt
         CHVBc3eSARPSXX0ntmzMVPSR9D72602CH+2RlF1GfRjK+Z40YUiRjvwOj4lw/84YbUR4
         h1b5YGvbKZ2G2KVLOuRrB4yrTx+mescWyhk12Peyf1Ffm7dciVFLx3uenGkSrfIYd97J
         Me5w==
X-Gm-Message-State: AOJu0YzylA/aM7zBT9HI6MLLbs+nM7fqsKL1mrrrh07qCpJdTVJm5LMF
	GFz5386zmoKn8wrHxK8FNFMVnOBnp1r3MnY5GRJdxSwMMxGOV2ec9Wedu0/A
X-Gm-Gg: ASbGncsjnZeaB5MEYUFtyahOfmcxxGiKFxSOxZ72bQMBpSJ1c6GuPcxROUsLyUV+Aux
	wOMbLQtk7M9VZC/H4yoWP+ctduHWNqqgANosOYPVTeRR+9zlVdJh+qn/K/eXmmasEWwey4OA+Nb
	V8MzuNgnselNfKqdpbemhvtFqtdCin+922XD6VhNkS7dahTcH+k8WaJG914dw4s8HpCfcUOVUbJ
	Xxx1mfAAuWbIQDKrA0whU30yoaMVI/OBGB94SaMQUbAWHShnMkMPk9wAqPeRVi8DikgjYJP4pqQ
	dT4+XfAztxDNeg==
X-Google-Smtp-Source: AGHT+IHfr+dMUa9HtZN9/Ijja8L94fFEfP3CvUvrhkpx4DewlV22SmVNCNMym3R9cp6I1CFCOr0WgA==
X-Received: by 2002:a05:6402:2355:b0:5d9:a55:4307 with SMTP id 4fb4d7f45d1cf-5d972e4eeabmr27846311a12.22.1736955528350;
        Wed, 15 Jan 2025 07:38:48 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:66c0])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d9900c4326sm7367218a12.23.2025.01.15.07.38.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 07:38:47 -0800 (PST)
Message-ID: <80b4c6a1-31c4-43c2-a0e0-7db9f8f048ee@gmail.com>
Date: Wed, 15 Jan 2025 15:39:35 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Factor out a function to parse restrictions
To: Josh Triplett <josh@joshtriplett.org>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
References: <9bac2b4d1b9b9ab41c55ea3816021be847f354df.1736932318.git.josh@joshtriplett.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9bac2b4d1b9b9ab41c55ea3816021be847f354df.1736932318.git.josh@joshtriplett.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/25 09:14, Josh Triplett wrote:
> Preparation for subsequent work on inherited restrictions.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>   io_uring/register.c | 64 +++++++++++++++++++++++----------------------
>   1 file changed, 33 insertions(+), 31 deletions(-)

lgtm

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


