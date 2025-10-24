Return-Path: <io-uring+bounces-10200-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 437AFC07508
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 18:30:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 69B0658216B
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 16:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F70320382;
	Fri, 24 Oct 2025 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="s6EO4x4j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C87324B19
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 16:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761323189; cv=none; b=NSew2sVi5v2doxaZeOCiMiNBWYkiVpn4emyoI/J9tLsxzdDSe4qdsGqNgFCoLmqtxw8B0Xauey9eiscPiGu2byJczGGg+PE8nf1nRyo+Oej/IPICYKniwoU7Vy3QaS57wBxiTDLdNm1tMVUOur0r+jmWcR//Nc4LvXVtdw2rE+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761323189; c=relaxed/simple;
	bh=ecInPHC0wUQfdAj1+Aml3TmylK9rw1fgXDqTWyPeUAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s0H/HHXXyf+v/QoBjK6q9S/zw1zo0OE4aW9OzmQTK+QRkUPMZb7Vxzxji4BKjcVZxtWe6dRPl49Im/uwhmy0gAeZcKG+crvUMiEpy7N5sCNTeEmUM0olWK8p3hgCTK+KGA1eNJG+L5rWxxJMIMrwrRp6p+IKQUJMae6EDjOxNg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=s6EO4x4j; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7a2738daea2so2003012b3a.0
        for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 09:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761323187; x=1761927987; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WQNmBJKrgqnV2GDalafHB8yTsnhVI8fnPtxF6o45OcM=;
        b=s6EO4x4jQ8zrAph8eLb7FS7IyCb88Fhua6JYN4fjdDsRoL/74/2Ia/sVoyC2Afa0BV
         p1ij28Vkm7hk/+TEjKUTAbCAf0wNEgwI0hvpIwmLOiC2o1LkOQHmphHLjdxY7Su/OVZk
         5YsySZMOmmNo59wKRzlR1xfmTg6jg/f0h+wFo9APdGmIzBIMO3+VYc8riEZjJG0WFNiE
         wo24sMwZOZ8bv0A2UCHT1RUq6OmALLqFT7JJ1vDaXogVJ78I74BG38l13nlTLpv0oE1W
         6ngeDR/+jwdrAm5Pf0QMqDdNhhIDiLvOunXGkJZ/Q7F9Qgc0fWo+CdW4MeCn21Zmjl5T
         jQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761323187; x=1761927987;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WQNmBJKrgqnV2GDalafHB8yTsnhVI8fnPtxF6o45OcM=;
        b=H7v4pdp69b+rvVYOlzGLbPmqUwpcUKphZKIJWrhPy69tFQHvA+1WbWbDCkjkLV/W9a
         5nFmbYHPtUYzlyT8gl3uy8bBnrZQNNSOcrQNr2QBdKsy9nfTN17eTZZ9rwROG12FhQWA
         9gybFn6MebxZyRVn7lh1wS36C9NywIZdZSCX1Sg76MrYRo+h+pbnGPjrqFMRdDa7Y48F
         BUnMiH1RZge4mwxgEsy1Yz9h/F+7B/jRUIW4K5aQ2uP1I6D67ODePtqvKaIBXTksCxzZ
         xrB6HG9Y2znENYLq0l8iDY0yr+Kh8zcdJ0PB57v96JsgrNXyEIB4gNKWE8x4ucIGM/D1
         4Ypg==
X-Forwarded-Encrypted: i=1; AJvYcCW4e7lwASdvNtFjjun//Ic8SA2ZVsSAkVAndHpBcICBzN+Ik11qw91Fp37M/ikkQrKSNfi+lEeWcg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyTpRyncWvDQN+WR/PtjztLW3ftZCqf5CRcEaW7ufz07Wopz1c1
	8dNeoZB81yS3fNU3x6n49FKsnipzwt0GGQR8eD+Zzp35nDbmyMHG8WFP9QwXiEsa7jY=
X-Gm-Gg: ASbGnctwq9RG2NaituLynb4D8jcS64BcgNjJ2KIiAqxoB2P+vOQ4f6qpLUypyaEYb37
	NY+msaZV4zcCG/Pmr6yaIgyVe5UG19huJM4nGN9pJy7HFDFNoppSz1d5O/0NXsOAGk8JDsFZz6E
	+pqU0N0gK4Oy+bHIPYEjcshUC9rLdaV7qqDgVZIKgAhp0LX5fWZUxV8txwysrXcbbsQ7Y+7HzNM
	BrndmPRcCKdccv7fwyEAskju5/adY+/OLeAqn+71d7fUk0D+k1PrY0/vhd0qio1FgtbaZRZd+xM
	S5iMDuPhE0gq+OiXk6eGkA3UyBF+tV6gxGLmga6CAv4Hxd43LsX/iBhom5Moc4Q+PtNq3M77nkN
	ZBeErrVyMXGv3NKkkMu3UKCv80WDRIAQfEJCP0T2rv6P0TTdg8grexw/3GbOrTzadQbHrGrNibE
	jLL04m8rIQ4LrlXFdK01XjFSddq6AC2vbh7Hj2GC40XXXXJz1/bcA=
X-Google-Smtp-Source: AGHT+IG25uKtkX2XgtWt9a+YmK+QRuGxwozTTl2DG8wGGJSWmTDiGBrI2+2T8ffa1LMhQHK4QCenbg==
X-Received: by 2002:a05:6a00:21ca:b0:781:16de:cc15 with SMTP id d2e1a72fcca58-7a220a98d8bmr37441588b3a.15.1761323187026;
        Fri, 24 Oct 2025 09:26:27 -0700 (PDT)
Received: from [172.23.28.72] ([104.220.226.147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274b8b27fsm6498782b3a.48.2025.10.24.09.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 09:26:26 -0700 (PDT)
Message-ID: <faa65705-0901-47c1-a5b4-b54192e2e2f9@davidwei.uk>
Date: Fri, 24 Oct 2025 09:26:26 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring zcrx: allow sharing of ifqs with other
 instances
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20251023213922.3451751-1-dw@davidwei.uk>
 <e3c4b0c5-72e1-4a2d-a9bf-2e57b1e191ae@kernel.dk>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <e3c4b0c5-72e1-4a2d-a9bf-2e57b1e191ae@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-10-24 06:01, Jens Axboe wrote:
> On 10/23/25 3:39 PM, David Wei wrote:
[...]
> 
> I think this would be a lot easier to review, if you split out a few
> things. Like:

You got it, I'll split it up in v2. Sorry I was recently traumatised
that I was splitting up a patchset into useless patches, so that's why I
sent this as one.

