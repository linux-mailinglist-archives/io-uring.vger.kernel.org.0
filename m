Return-Path: <io-uring+bounces-7815-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F4EBAA75FD
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 17:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73D5C9E1A4F
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 15:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FEFD2566C4;
	Fri,  2 May 2025 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eP5p2JR9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF15A2571C7
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 15:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746199620; cv=none; b=KuqzQfRt5tL4MkzMNOeWulyUl49IAmNth7dJGU4dlRFaOrTj4axnT2QcGeSEJaoYG80Ty2zbEgO8ZEi1PTPxdqR+ZHlNUxQkhw32zY/8BTBtBp3n7rT3nFB1+REXgtqAKKoXH9sInwqpPiz4eP2b1L40CNhlPlJpuKvHjWtkMUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746199620; c=relaxed/simple;
	bh=Kdq7gi0ZCBQCkbBZzK2QwuXhuki9/7JCklqHBoez0oA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RGGJ/PvBUzgtKlLd01p3AZZF2S+jWIuA7b1wXWLs7ZYcEBUQRHD+BECbKDnah51vl/P9SiZMFNaZWvS+of+nFO6AyO0cSzImazZhfz2e7soMlmJt1DjQkk0YQZ0QfEURC9NTBgdnPONSKPPPobjF7W1ebUNne/2UkNQ1UWSrF7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eP5p2JR9; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d7f4cb7636so7560165ab.3
        for <io-uring@vger.kernel.org>; Fri, 02 May 2025 08:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746199618; x=1746804418; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jeFjlL+kddrolH/e7Qr5/wxYG3GQEPBIKZWG4/PguMo=;
        b=eP5p2JR96jgCx/hpjsFmjQgOYeCsO5Tz00KDwrAqc4qxDXXb1I7FiwHp1qttmpVYpL
         TRK/1ynbC+roU0ELic6BQ2BnZuk/FvkNWGIeinSsnYKDHT1v0XXeJRRKl5OipgcS86FL
         DWmH9dtAbBR1IjSCwBkNewP3X2oU5JTNPeghdhcwxudvZ9p1rHXFiI+HtU7/8KVtHOM0
         s3RLGy5361FJCmgkDrRnGZqBZtOx+9PN/nIYNugxDRwLQ4kVJxfNiKdVR+mXjfoPosyW
         WtSBR0Kl7y8A/63QI+mbOeBxNVmWej37n/q7wK61MHUgG6PgTHW1350JARHUrw/DqQIA
         MvHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746199618; x=1746804418;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jeFjlL+kddrolH/e7Qr5/wxYG3GQEPBIKZWG4/PguMo=;
        b=GEsZR1bq/gDdZd42KWcYHXjNGD5btltzvolby9LtiUNV65/lr+SlhZU9wqT5bM2BGJ
         2WMat77mj9lzxvFaK1aic+FeAQJvaBDDjUzQPUE5BP0vJGI4ZoOAB+9stEp/0TEIIIkf
         dZGJ1oIxD7jP97dprEXN/w1VAssSQU0Zr676qyc3gFbIuVi9Hd1nd8HkXmeRv8T1X5Nk
         xbcGy+1pdMZm76KsusXFhxwWVuC8ysyN52zblkApKDUka1dsGbUb1fwc6x8k1weio4Lu
         9Hoyyoeel1fVyatlNTTeW6Al6QupCkVUrJyVyElf2gms3su7aVLkkToaGKI3wK6BXsFt
         oLnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVH6rEmNZH6EhYDypb4MrvNgNGJU6TeY6dRNW5Gx7/wlmhIVdjKXm1Z8dpgoAPu2xl44oH+ELsHLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwuMjnIfIJp5Nok7REertgDgEfel0D7UheEqswnARiHaboiTb+x
	X8hTM+pKIfTsSt+ARyl/NoJmYgjSb2NKTHKqsHeWfzNj2FswOoLg5cGJM1R6nwQ=
X-Gm-Gg: ASbGncsPsnnARJLXbnJjd7oWuwn8kzr9ZJ2RuVeJdAK4NhmpgpUiW+XZzHVHU5gp6YO
	JWBzcHjsXdEZxJPPjofUO7Tj8RV5SOqJHF8h9pdOOvIQNS3FoeSScZSlzXf1932QWRkru5NGHM3
	BOgoSPhxZV+5I7BeEwN63II6HcRTXfRt1m6SGPDhLpXagO4xwn8c4+XCQwzxNXgauHNb9y6q/u6
	UBlVfBj1PF9MjnFkKH8C3Hk0zn86ELkQi6r49c/I3JEJB0g3456U+aXjqj9naCOh8O3es0/1ray
	+IC3h3m4yMK8iG6vX/A0pCOOaEJh6qv0P7xn
X-Google-Smtp-Source: AGHT+IEmae3CkAHQ3Ni1P3nyzhhte6tWDrZxA2fHBJr1+WAVBS84NUbYbZSSS0Zgnl1bbmGM6Fbgtw==
X-Received: by 2002:a05:6e02:1c0f:b0:3d8:1b0b:c92b with SMTP id e9e14a558f8ab-3d97c15ca0cmr36623565ab.2.1746199617679;
        Fri, 02 May 2025 08:26:57 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88aa59046sm423215173.80.2025.05.02.08.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 08:26:57 -0700 (PDT)
Message-ID: <8e5b61c4-e23e-4d19-bc5c-eb473612c6ff@kernel.dk>
Date: Fri, 2 May 2025 09:26:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 3/4] examples/send-zc: optionally fill data with
 a pattern
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1746125619.git.asml.silence@gmail.com>
 <bafcd4da1148fdff2890c6ee186bfb516f434a65.1746125619.git.asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <bafcd4da1148fdff2890c6ee186bfb516f434a65.1746125619.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> @@ -582,12 +588,19 @@ static void parse_opts(int argc, char **argv)
>  		case 'R':
>  			cfg_rx = 1;
>  			break;
> +		case 'v':
> +			cfg_verify = true;
> +			break;
>  		case 'y':
>  			cfg_rx_poll = 1;
>  			break;
>  		}
>  	}
>  
> +	available_buffer_len = cfg_payload_len;
> +	if (cfg_verify)
> +		available_buffer_len += 26;
> +

This variable is nowhere to be found?

-- 
Jens Axboe

