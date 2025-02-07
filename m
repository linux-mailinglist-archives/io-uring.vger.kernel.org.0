Return-Path: <io-uring+bounces-6292-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 656C9A2C24C
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 13:15:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E1B71889F5F
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 12:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ABFF1DE4CC;
	Fri,  7 Feb 2025 12:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PcuQdfvD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BEC16A95B;
	Fri,  7 Feb 2025 12:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738930515; cv=none; b=I7tV4T67FDQjO/6uetKdnBtYDm+6vK97BiEYwemjQUm16cFbmBN4CtO3ZqNZd4QLjTXf/WTQ/XzzAk7ylzNS/J9R/LI2Tiz0oIC65R49LRsw251Oda0sI+BySe7OKf6bMEQUQyEnxubDOjY31B+1OZWtVf85JeTRG5Ge+2htGq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738930515; c=relaxed/simple;
	bh=tGhScGYBJrnZdbX6Wxh5ilwPYt1oNcFXzleti5BL9yU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=idmTh/k5fptDH89g2piWI7JNDTr5NixsUJ75S8iDaTQ99EkIwqU9HKcH4xgsgm4ZXpD+HBdUVvxCdvccgp05D+uKa/D7PgeRHeozAZdB6Jg+U7yPdW89k0fYbUo43llPX9E4+akyhbPcXFH4GtRjDP2aDkTRZDwNL8nDdjo2AqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PcuQdfvD; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ab7800d3939so226364966b.2;
        Fri, 07 Feb 2025 04:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738930512; x=1739535312; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aUn6vhCpOWMavmFfq7khokcJ+LYITUxGZDh3AG4vU3k=;
        b=PcuQdfvDAsZx+FYPUU+860pr9Q/47nooOtg0Zu1z7McbzR1nFbpG06pzSOFAAlh8Ja
         lrGVgKfv2uCKYflR53Gu4zHhU8Y0s5CijD76bQ7AUUuEcy8RrUvrm+0G8MdmW9l6cQHj
         7znZbIzJRN6gh6eIQYK9sVt1RYYQcavGR7qiTW6Bef5FauDQ/izEAEUuYlM1qNW9y4mL
         WUjTrKMZ31hhw3DiwGHQBOM3NU/dLjgMAdz/ObGb9+MGTs9LAQ+RcH87c+cDYSLtgIZs
         2jWGUmqJIzVM+Grfj2kHuQNV1m5fHc5m2699S9jX4gST7I/dxPpAIcKgsZVxytmILrgW
         uiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738930512; x=1739535312;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aUn6vhCpOWMavmFfq7khokcJ+LYITUxGZDh3AG4vU3k=;
        b=KQUKmiY5MzLEFETIS+MIvCEh91W5E2xbzueyfu0vtCABYNDnOXIfGxmKlBGs+YQJRR
         UeTLoYp+UkI3IdyqQI72pcx3fCxSqyqSQceQje/PYEsVoUL2R+5DD6xYwDEiZBASdXzJ
         9FgLFvd+0cUOHuiD2DC/1qPNje2dBlsNEnar+Xk9n4KZzOfRw1bQwjuKdfDIvSBVnEkv
         zu5y5DZ2W01xSXVECxpqSDTNfPAjkSUbqC3FuaOHbzzPuo4zlnToAIk8nYobLxWBfygB
         RZ5E4n54j1VToPJQuM7TC07DZQy1ELa1INq270a5+1evSNXqj8AyUquq/o4nHhCcqYtP
         UwoA==
X-Forwarded-Encrypted: i=1; AJvYcCWcn753b9/3278KNsROYEea3Xr9cyalNHuel4+xnXOMXdyPbk1f9pmUXxKJtuo4iSoM0AAwLhT03w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8rLiiJFV82Z1VAlwDmyZQVLlKlK4Uc9+RaWeaNzz/Dxk0P3nm
	DUBkHbNlhw0xFXRnmnPu2ZWxD3vf3m173nBr1s3bKtleHofmmgPk
X-Gm-Gg: ASbGncuk2t/YSKhpfufVOC+lD3cFMgkbuUlGqp1FGtAGY362rTuCYCpn/YixylcFwMI
	sLCbkNoP1AWxNvlCgbEsgJJfojuLlTB4xCgKNKgQaDPzzIzuaUSaYBMU9cYG3zSaOloyeaX7SI9
	slsuIMZzRMNfwvrhQOHzedHQsXgStrkcbPr2gJM75Im0mv4BZ4JVU/SDCBmtbmpSgjHWsFBmnly
	WoUkHmRM68aCbb2c+P2q4o5ozBXdG8K6rw/ZwA2CM23LKg3b2kytchzripvxnEMua3FkQwvzkQx
	Yr5FhhNpnCqWB1U4ZKdjKpJcwjd8XWccrY6xrPV6ATLLOQe4
X-Google-Smtp-Source: AGHT+IH4QMsURtNStgmxhm0YK0d/EhID9SH5mjFz61TrpqK5uQPmm1YvQjv0lhd3yT66VD35iCt8QQ==
X-Received: by 2002:a17:907:b02:b0:ab7:94a9:5bdb with SMTP id a640c23a62f3a-ab794a984dfmr31546766b.38.1738930511747;
        Fri, 07 Feb 2025 04:15:11 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:8e12])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7732e706fsm256452366b.88.2025.02.07.04.15.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 04:15:10 -0800 (PST)
Message-ID: <42382d54-4789-42dc-af17-79071af48849@gmail.com>
Date: Fri, 7 Feb 2025 12:15:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] io_uring/poll: add IO_POLL_FINISH_FLAG
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org
References: <20250204194814.393112-1-axboe@kernel.dk>
 <20250204194814.393112-9-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250204194814.393112-9-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/25 19:46, Jens Axboe wrote:
> Use the same value as the retry, doesn't need to be unique, just
> available if the poll owning mechanism user wishes to use it for
> something other than a retry condition.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/poll.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/io_uring/poll.h b/io_uring/poll.h
> index 2f416cd3be13..97d14b2b2751 100644
> --- a/io_uring/poll.h
> +++ b/io_uring/poll.h
> @@ -23,6 +23,7 @@ struct async_poll {
>   
>   #define IO_POLL_CANCEL_FLAG	BIT(31)
>   #define IO_POLL_RETRY_FLAG	BIT(30)
> +#define IO_POLL_FINISH_FLAG	IO_POLL_RETRY_FLAG

The patches use io_poll_get_ownership(), which already might set
the flag and with a different meaning put into it.

>   #define IO_POLL_REF_MASK	GENMASK(29, 0)
>   
>   bool io_poll_get_ownership_slowpath(struct io_kiocb *req);

-- 
Pavel Begunkov


