Return-Path: <io-uring+bounces-8151-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78C37AC903A
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:32:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F6A4188437D
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:29:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5939B8BFF;
	Fri, 30 May 2025 13:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YcXD2wfR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833A33FE4
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 13:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748611731; cv=none; b=I0TVBF2ILFhEph6RnCNh+D45/t0M9wS3UnVkxQRGdRkicwrEx6u9NkcQJTur6FolGsMzVM57cCJAbbVeQBoD9PpxlD5gKv27w5KlX0Nkws1FBRCQDhI9yelWwdIAFx7iRlAmMZj6YcLKStS3b3OaEu3qjWJvbJSFscxpe5Cv4Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748611731; c=relaxed/simple;
	bh=DuHqxHmJu2UPpyrpbljWsUD3UikJ4poLuZM9479oISQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZB66aeDTcESynpbTipnDmaUYggwUKP8MYFULN9l7ok/kGrwNtwubUsi9HzjP3OsVagLS/JublOJutiESyhs26BlaYTiWRgV1Auyv4ggLr4aqVIt64Ki1gjjd2zQbE2cm3btyv+zinVEXc7QiCkolpXXLuhv2WzcEVtOpq9Y5u90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YcXD2wfR; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3dca299003cso17933455ab.3
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 06:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748611728; x=1749216528; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iDQpGA6LDnxDDAA4468RDmY1KSzdTYgOqPmLvBIRWzQ=;
        b=YcXD2wfR7kamEoMCRCZg/1YUvE4+dnka+qktD9NwtFt8FLIIUDYb45WzXqEiGodcVI
         aNCbeObvIM3F77Ltia8DaqnQL7jn3yfqkvyiSMKE0WkSF1IAbW5s163FAoS7p6fqNpTy
         EnCfFcpRUwIERD0rkVN7rqVaOKO+d41sQifwyLb8kJ8juaWGz5usxXpUzP/FRYBVRI/I
         LtOvBcSyrkdO5uNogcZ6JZbYb9nkLJoa+TPS+45kDFRmmIfN59uDfuJVkrVotBZEnhDj
         sdycV3g4undl0ul+z3lq0MCnmIIg6pRPR1I5WXSAssMgjeEoSsMdBtZPg27wNP1rLCFG
         sHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748611728; x=1749216528;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iDQpGA6LDnxDDAA4468RDmY1KSzdTYgOqPmLvBIRWzQ=;
        b=iNasSBHg/wyMUEarDYXpOoLAQdQdsywUhBv6kQtiEzPZtPmf60XyZyUOjs8UdeBDsd
         70BSEirsy23DR/VZaNpW0s4bt9Qeb9jhWBh+s7Zm62pNAx/Pl2GzVX7kanT5FxsXSVyy
         oGBo3XeJivZFZgIQb2AkqpZJr1oDHOUxQ2FD5r5Vg973868xO+SndbLh72wh+DhvuLjA
         oLaZDdgZrFM/Zrswblurg1qB8OAagwtwcvRKVIvuWUKN8YFeB3VvzG06CRgHkBY246hU
         giWVYCAg8lOqu2KRXC06SbYZy5ZxrY/qouNetSoG8XLF4ajh3omU0NJPQ8rH2h3jgYbB
         CtZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUF3g7gvK52RExpzW+k8I8DP41LiuDdtb9WRd8/Od9H+AAd448MEZutAWvuB0rpfEjLXF1x2DuVxg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxPqaXbXAPRNYeMOaXM70y0gN7AB/cshP/ChR87uMaMpDZEDhb
	/3JQdL4fmMzUErCmQVowaS7Rh7bi12C1NvVq4KzjN1GQXkh3eLND9fzs4MJq7XxFlCVan/7HZJv
	5+mi/
X-Gm-Gg: ASbGncteoFMBewIPf/lLUVaI45uWExOr+pptPfUidjgO0bvsoqLZ1tP6nygYuivGvpq
	h+69c4cc+a+rFcS+E+viQ2/blXOvZffc14O8zjZjYo18kdrdC969qKOf2O/1fporTH3qnFCoif6
	Duwafat7P7So9BEEzHXzniFwCV5mYnrlgX4e+kC2pJIhI4cV4EV8eAeqn+4SUlEe1mwsT+aSgSH
	2W87RqSkMMsTzZ9WmavhVNP8fFE137dC2EhaX3E+m8h9T02ey7+M+BGI9kl84pejlckKlR6Hr/l
	C04E3/h9ibr1ZnoS3/66hHY36IHg6hUeNeR8a4jskHIGEfI=
X-Google-Smtp-Source: AGHT+IHbMHpQe9P76Ij0EVQ+2mxFyQ/6j7qizD4jO1tK51SL6fmns+Jw8uV/nJpn58+oeFSFwXpNCQ==
X-Received: by 2002:a05:6e02:194b:b0:3d8:1b25:cc2 with SMTP id e9e14a558f8ab-3dd99bd694cmr43923295ab.8.1748611728494;
        Fri, 30 May 2025 06:28:48 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd935a6991sm7443685ab.60.2025.05.30.06.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 06:28:47 -0700 (PDT)
Message-ID: <cf2e4b4b-c229-408d-ac86-ab259a87e90e@kernel.dk>
Date: Fri, 30 May 2025 07:28:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 6:51 AM, Pavel Begunkov wrote:
> diff --git a/init/Kconfig b/init/Kconfig
> index 63f5974b9fa6..9e8a5b810804 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1774,6 +1774,17 @@ config GCOV_PROFILE_URING
>  	  the io_uring subsystem, hence this should only be enabled for
>  	  specific test purposes.
>  
> +config IO_URING_MOCK_FILE
> +	tristate "Enable io_uring mock files (Experimental)" if EXPERT
> +	default n
> +	depends on IO_URING && KASAN
> +	help
> +	  Enable mock files for io_uring subststem testing. The ABI might
> +	  still change, so it's still experimental and should only be enabled
> +	  for specific test purposes.
> +
> +	  If unsure, say N.

As mentioned in the other email, I don't think we should include KASAN
here.

> +struct io_uring_mock_create {
> +	__u32		out_fd;
> +	__u32		flags;
> +	__u64		__resv[15];
> +};

Do we want to have a type here for this? Eg regular file, pipe, socket,
etc?

-- 
Jens Axboe

