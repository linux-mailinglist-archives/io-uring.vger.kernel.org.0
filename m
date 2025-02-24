Return-Path: <io-uring+bounces-6658-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7AE7A41EAA
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:19:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAABA188AF87
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 12:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47AF5219316;
	Mon, 24 Feb 2025 12:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AcTrKJ+9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6337F219318
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 12:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399331; cv=none; b=aNSGgVVBQWaiyYkuaz3GulLgSrIzJu+B7femBsyvvwQrflg8oNwhXY4cQntSLcVg1Rpp7X761pL0ZCkS6Hp7ysMHBl5dNYY1Tghe620B2cppXudhJOOmX8uPlXKVcVWzxAaH8oHGmgjrcdc8s+ozSeAoJLkPZe60vd6am9QOixs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399331; c=relaxed/simple;
	bh=+ru8CihhvB8uPQLxi+TyI4p84AIrtgS6p7QL8Wl2s7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eORBdVTZYgE6tl8GhO2Zyeq20VlVoDurIoh/v8k6cei7IYheq74l8kZiqTJhNxDroQmlLeicz40CXXySyOwkDxfyb1DQv2CK4N2+HVJynODzEERBDO0b8a8vXOGEV7aNruOhscGL2lr7MvLdgAAsuKwIXCiBsnDsTskzXJ/7TWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AcTrKJ+9; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5ded1395213so7264074a12.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740399327; x=1741004127; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5m8FXYhOSH6sKI+eZGwK2k4LHcvK7Uu+THm0xU9DNIY=;
        b=AcTrKJ+9QcrIuOA2kYM4tUWsxrhlXtVlSFe7AwRxDRtwt1CLO+JVCb5UC4fcWoGBw1
         vHXf/PTdfao79Fc7OyznTnL+mJn9yQt8zn61s9aEOFFP+51jGJm9uJWTb4kW4g0XiTei
         QV9cHIScTvcSbpOlnjwuQIJldCPqZ7iGoBY7avns/uPeCPUbUzLIq2vyBFFg9Fvejh6j
         WCuj9eAa62ytQzcEQWCGJOGq1aKUl9YV8JksY3OkCFNvgpoLdLknfISR4HaD6CMQgMgE
         UD891dk+xC5Td+MD0SPzRuz2ceNNIlw/kgKQXUzsdLItimZlYzot1PywcrJKJwTZQ2tE
         FTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740399327; x=1741004127;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5m8FXYhOSH6sKI+eZGwK2k4LHcvK7Uu+THm0xU9DNIY=;
        b=cuCZS2gk5hXac6PseyasL2YdnzolWMIFtUHdWND6rmLT7I8o0KC+qW6U+i9vKFmApE
         y69y5VrfKCpU3m84/H53uPbzpio2mnia6fvq1Frea8DtkxBK2W1of9qRKEHAZ2pNNT/2
         PJBWMcrvekiz2m143Jk7KXXAFw3cOzmSYoXVDcQRtly1/W2LOvng7DCiBpWKdZw2vBPX
         oXrCfH9z1QFY8IqrSNMRsAz7vgVLWonmoJShgQHbKyIiyM56HK3d+z9+2cR99LuW+D8e
         knnMnB2faPUYQPli8pbD+dTPwhxV/9hWJfCHLVGDhbzGzuA81pfwg6mI6Zm+KVRajLsh
         ssTg==
X-Gm-Message-State: AOJu0Yz3Pv+uYXXdmEWPILtqZ+US00gdOs50qy+UOs1JvxoBbrRtH4+4
	kuY+IZwVOgV7fj/0merQZNQnLoP+72zKL/lDPq6LPxrpH2EIK3hTWPQXYA==
X-Gm-Gg: ASbGnctmDH+6Ps5QfvTUUsowo5K3J8h3MzUrzkONIVpGpNM0Gs7RU2ep5wsTYiWJpew
	RHqC1ByC2RPrDP7A5wZ6MvKwWGaEh0vkIDWQ2S7yxFrRiRLcx3FTGq48umh0zSOUYPQmuHMwMvr
	tSZcaXlB7UPv30lOnhp6wz9xVGL8oqzP9tNIE8RvyvKD+DRNiile4/F+CD6L4rB2+s//2IDDQJF
	+XpP4WOWNJdINfiyNSKQEor3CaAGN6dQqru58Y9cR5H181YU0K1uXF8WlpTVvZQ179XXedUXIyY
	HBwfjnHPdSmCJo4IcAJLwnvF0EQEEB404MMZWjmwc884cyB/SbZno7qhTcI=
X-Google-Smtp-Source: AGHT+IEKagmYEbhs84tF5qkmNXhqhb7lh65tTgG6pOLpkQ0ZihgEaUTneYLTpfzW1tsGFzxMI46hTg==
X-Received: by 2002:a05:6402:5246:b0:5e0:4c2d:b81c with SMTP id 4fb4d7f45d1cf-5e0b7243e21mr10846057a12.31.1740399327170;
        Mon, 24 Feb 2025 04:15:27 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece2867a1sm18210171a12.66.2025.02.24.04.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 04:15:26 -0800 (PST)
Message-ID: <483edbcc-8c54-406a-9e25-f4e33165bdff@gmail.com>
Date: Mon, 24 Feb 2025 12:16:28 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: compile out compat param passing
To: Anuj gupta <anuj1072538@gmail.com>
Cc: io-uring@vger.kernel.org
References: <f03a112031e9d25f10bca0a3d0b7e4406fc3618e.1740332075.git.asml.silence@gmail.com>
 <CACzX3As3UyR3AuQBt=48DSjbzvAQoG18u_O_j0PCNpZWHL-=pQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACzX3As3UyR3AuQBt=48DSjbzvAQoG18u_O_j0PCNpZWHL-=pQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 02:56, Anuj gupta wrote:
>>   #ifdef CONFIG_COMPAT
>> -       if (req->ctx->compat)
>> +       if (io_is_compat(req->ctx))
>>                  return io_iov_compat_buffer_select_prep(rw);
>>   #endif
> 
> Should the #ifdef CONFIG_COMPAT be removed here since io_is_compat() already
> accounts for it?

We can if same is done for io_iov_compat_buffer_select_prep() and
we can prove it doesn't use anything compiled out for !COMPAT (which
seems so).

  
>> @@ -120,7 +120,7 @@ static int __io_import_iovec(int ddir, struct io_kiocb *req,
>>                  nr_segs = 1;
>>          }
>>          ret = __import_iovec(ddir, buf, sqe_len, nr_segs, &iov, &io->iter,
>> -                               req->ctx->compat);
>> +                               io_is_compat(req->ctx));
> 
> Should we also update other places that use ctx->compat (e.g., rsrc.c, net.c,
> uring_cmd.c) to use the new io_is_compat() helper for consistency?

That would be a wider messier change split in multiple patches, which
I was thinking to avoid. This patch is a good first step, and once
merged future changes can be made independently.

Let me see what I can do, but I don't want touching rsrc.c for now
to avoid unnecessary changes. And then more can be done to get more
code out of ifdef and let the compiler optimise it out.

-- 
Pavel Begunkov


