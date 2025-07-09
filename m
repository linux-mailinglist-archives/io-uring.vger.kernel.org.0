Return-Path: <io-uring+bounces-8632-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8139AFEAA4
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 15:49:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 905F7481AC7
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 13:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 071802DFA39;
	Wed,  9 Jul 2025 13:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e44AM8vZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB452DCF5B;
	Wed,  9 Jul 2025 13:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752068945; cv=none; b=oahORcSBQ8asRSsBjPPDSj7kEK6Kb+yRg6xL4l7v81fyxCrfhUFXCyXK0T3ruz0RL0Jg9wPVrgHoLbsweJWKcDozp4uK503qHfLIIry3Z/5W6IokYFIguOYNacGHvqUPcP95yhRkU2wSb5S0UEfLXrYGYBDV0fRuyFoYMTj+5qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752068945; c=relaxed/simple;
	bh=d60WP6pubxI4wztZMJX26s9D12yMKyxg6mc078wlQIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=buoyN0jHHQKXqKs3/x6r4I9w3HtBjz9TG6ecwswi5cS/TPJsoS7XXRo/WTBzVyeHlwK/98/6UWEftoIlVyV0Z2qV2i8S0ZqMNN3fWX5hipqY8OkwzmV/0nqjGwRYxdT2HU+xpBPW9ZtmaOA9APPTHdR1DfeJ9blLiYSzmWJXtxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e44AM8vZ; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ae3be3eabd8so219750166b.1;
        Wed, 09 Jul 2025 06:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752068942; x=1752673742; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7tPZ2snfZJMpsUBAg/+z6Smy+g9cPqG2rxkyRsXfVc4=;
        b=e44AM8vZvAzEQJXmAdebRGlpTfVJSMtlp85UgJp1/LI1OU+mpYaF/yZ+ju0DBV7Wkl
         jX4Mvz+i6Ksl3CXjFY30sw/G/hGCC0wCX7Jef4X5BnSwMNFmIiUmN93ADxt5G60qbzxU
         4LWPX8yL1XxWWntmbJRE0oHSvTmWbKcych1bDoS4Bk2jGMa6zuHmOpEGJAj3Bp0N/Tj9
         J5LBpczW3ZlE+eCfoGolNrD1RISvzeBEN97zkihYRUTfJExvEfvs4xa2DbbPu4jxLiTS
         hI0X+lGBzUgwteKUxzFOhs8gkG3DgDXAzlnsP7qwgjHFsa7AxYkbUtqYhabCPPbzanKJ
         5ung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752068942; x=1752673742;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7tPZ2snfZJMpsUBAg/+z6Smy+g9cPqG2rxkyRsXfVc4=;
        b=u4T5QJc1iWkLkDd59B0YCMJbpbyvI3oPTptIkPHaWbOXLQiKqWp99CAm5jB38F9kS9
         V8dPjWeyhFs5ejiQULLrZ1Eyz87KVoO34AgDUCdG8zj0MmaKbePxWQKpsU0/HEQYXzyo
         Q/PgNMspEjM7A9vOlcW99UiGSVtoMjL/dK7d7TzemukzAhLBZttMgDddSwcL/RVsxmd7
         5VR7xfGqPOSZ7Bjnz38CjsTbViMwOXfVksU0zRS4L+xVy425NWxP1VQSHRbHCD43M0wv
         Oi5ZI3GJM8PBxNaWa6VccfUiZiwYbe+rQken3iUA/EQi6uCA8zcIids8Tzas7Xjw7QAd
         6E7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUepg/e4EJ4uP6MQ2WJbFh8kbqarz+ViSiLH+fHIRqXy0YPNWbfX9cFldwiP1lxPrmuukX/xgaN@vger.kernel.org, AJvYcCWi8ISsSOYsDWb6tDErPPnpbydGezDtcFox7uNK/B/29eJvPcOc0CCMUG0p5MVOY7fYGU8f24Uu4w==@vger.kernel.org, AJvYcCWvsAoJiVdB6WK1Ex/x52xvOokjBPDADLQ2yiknexFTz6pTFaKD5nBxoAz0qgsXS8mPFBwL9smErgf9Mvg9@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc19Angtd668f/J+tJO8EE75dpQ+SPTBeqO5fCFdhomNfzUU1j
	/sqM2ma1dZCjWL3/fF5Uh5b2CV3yPf4qz9ykutBVx7VNEM6CQEhIFdYcmrLObg==
X-Gm-Gg: ASbGncvj6HkhmfeEZIjnvc244upWqYJ5afiIh7mKG22aiFc9Nuq6qU485pIBN/4G309
	26sGRSXtVeOxMP4aNKe/rfjfXoXUsftTYcH5aFQbxFafeAv/9KnlK366La2wmqhn2w/D2RlLie0
	TXclNpEWRyeutcf074oC9U0MFdJxv4gvjuSf7Rkzb2l9uDsawzyqyMr4YTc2F/d2a2FWlKtrl+1
	KTN6I13tcBn/JzlnSxkTp5yaynJWWCu7G58fpjXiXrYTN47X2ifdftKmkzTLXpuwItLnmg7FBXp
	5cWpgV79P53KBDEz+i3Y6M+eMtfG/X+9mg7GejYkNUPj59GrLtdnFfGQwrvhJJvJyTbAWnN00v4
	=
X-Google-Smtp-Source: AGHT+IF31JR2looeKB7ac3iqDu1s74r171lLgGcy1Nj4GskaS7HfgrExrdlbN4zWs9o6Zi51j02V/A==
X-Received: by 2002:a17:906:eecd:b0:ae6:dd93:2cac with SMTP id a640c23a62f3a-ae6dd932d17mr65632466b.7.1752068942242;
        Wed, 09 Jul 2025 06:49:02 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1ac? ([2620:10d:c092:600::1:e3ec])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6abfd8bsm1103765266b.81.2025.07.09.06.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jul 2025 06:49:01 -0700 (PDT)
Message-ID: <020a278f-2fae-4242-b55a-7b4faab37e55@gmail.com>
Date: Wed, 9 Jul 2025 14:50:24 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net: Allow non parent devices to be used for ZC DMA
To: Dragos Tatulea <dtatulea@nvidia.com>, almasrymina@google.com,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Simona Vetter <simona.vetter@ffwll.ch>, Willem de Bruijn
 <willemb@google.com>, Kaiyuan Zhang <kaiyuanz@google.com>
Cc: cratiu@nvidia.com, parav@nvidia.com, Tariq Toukan <tariqt@nvidia.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250709124059.516095-2-dtatulea@nvidia.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250709124059.516095-2-dtatulea@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/25 13:40, Dragos Tatulea wrote:
> For zerocopy (io_uring, devmem), there is an assumption that the
> parent device can do DMA. However that is not always the case:
> ScalableFunction devices have the DMA device in the grandparent.
> 
> This patch adds a helper for getting the DMA device for a netdev from
> its parent or grandparent if necessary. The NULL case is handled in the
> callers.
> 
> devmem and io_uring are updated accordingly to use this helper instead
> of directly using the parent.
> 
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Fixes: 170aafe35cb9 ("netdev: support binding dma-buf to netdevice")
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
> Changes in v1:
> - Upgraded from RFC status.
> - Dropped driver specific bits for generic solution.
> - Implemented single patch as a fix as requested in RFC.
> - Handling of multi-PF netdevs will be handled in a subsequent patch
>    series.
> 
> RFC: https://lore.kernel.org/all/20250702172433.1738947-2-dtatulea@nvidia.com/
I can't say anything about the walking to grand parent part, but
the rest looks good.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


