Return-Path: <io-uring+bounces-4930-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2939D4F9A
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 16:22:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8642628255B
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057411CD1EE;
	Thu, 21 Nov 2024 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MHCUJFQp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF9913AD3F
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 15:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732202542; cv=none; b=L1Bod2paMfsi8ufrhQ/cx2tmMeLTfIupiGkkPhFtP3evt5XhvNaLvN9zUux3suAWQpUPSzLlpoqpCKpcGP6rRkuQg3HcDD7FlmTUxNmLU3txyAt2Pzx8OW2+9P1htJJVVUAWaV0cpIiOo8yx96lRu3VlAlp1fo4HKimI2LW61JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732202542; c=relaxed/simple;
	bh=9pZI0RZLEWzk52QzIzoaPFn33NbgksceCKo4lIt5v8M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ujQGaot87bJe720cGPjOqJLpLbr8qNNDXf7WujqEALKMw1bmOF/kwAgWKq0PG2e0ErObZOcTQ1OK++C0K+ughznzvxZNgxZzGl6UvCRZw0F5vSJkGZ2TB3JvrYN4ZKqwBUsVEizVynlFU745mb3Q5a8dQ0lCWT7N5lAEJ0a1/XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MHCUJFQp; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-295eb32566dso674866fac.1
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 07:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732202539; x=1732807339; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYgRFm4PC/v4em6u5FRv3S3j+FK2txghrQcggHIt/dk=;
        b=MHCUJFQpRA84Tj4BSPa/qCBNErXIdTjQbv6LPrFck+nGbTRUJsOSs+dKtKAfULY6Gp
         eM71mZy28znUUFq7+HS8J5miEoC0nKsU5Mb4NDaNHhn1OTYC5kO+Me2H+jYXx4NKzhCk
         cm6AuUHyS9dVCcKedzFK/IA8L0UdRps1AYoruXtZPAEec+St2VB+79LshWnFozupdPSI
         l3BY8xlmGsHr397j/UMu029IIPgSFN03szlNMuFt+xoWqttRbKfq9mMdgbgeEDJrQV0H
         U6+iPRoq44ufWlO9y53QdpAViKcm33K8cd9Sa5/UgYcH6wGRwBXv6Qonb+zklzud6ZOH
         P3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732202539; x=1732807339;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EYgRFm4PC/v4em6u5FRv3S3j+FK2txghrQcggHIt/dk=;
        b=X5KovKXrKj11GUEBLlb0V2MDtoRiGQOTbfeqJ3MLoaPQ4VukgouWCgx17Al4Gbuo9e
         wKCv+BNCRjJtxRcC65yaIc4WeCaJ3wbI0IC32QpmPmmYToRtJU+5PLlOv10Ex/QcKG1r
         a2WeB23fgn9Irtxo3QKVYI1CrAyg8JIWVIntb6Tj+RhLhX8NR6k5de+TAGXmfy0uy/HI
         h19IYvJ6nWE42vGhjqZktla05ZeguncGaFFx9Z+76nx5dCvexwdxh2Vb80oNOjvuzcrg
         OkpnUl7CB+Q5y0D5UOH6lvXYBbgUy3le40aVypqdp0dcAwRnp85wJRe8IT0W1WKy4e1Z
         oR8A==
X-Forwarded-Encrypted: i=1; AJvYcCVZo4z6Ruer8xNS90p9pzBd1jvCaQHeuCn37BYLt2sT+dfqmCs2pGqfLiEyaB2WdjSUtkLrS1CLSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxarqQJSrOXVyfvkCdnDbfAGBTPlwjmwWoquPfSh0/RA+CZlk6u
	g8bZsjYMlO8TY7KTy9uEx8t8+haJmSKO41wWKhybJFZ6V883LORTg/rQCcY/80uV0kByBWe/GIC
	A5Lo=
X-Gm-Gg: ASbGncudpPRFDMqQBuh6Q/c1uvYs5HYYxOLxcwkUMmVJJi6XTOktPFU25vXobD3hU67
	IZ+FCchGRJHI0i68yXEEIBsqmK0p9IOX0+xRgIG3YRUp+uw6Jz5VxwKscVj41ZD3JISNjwHu42g
	zYRx45CzCT0VSBCXva4i26i4UaN2wDIhX7oW4LU+z4sddy7Ef+rF5HR+Hk9aNMQJeu6Tum09rOT
	lyR4co6ilZj/fSWKXgXEh5ZUsJDKTrt0pO8GL1PkRCPBQ==
X-Google-Smtp-Source: AGHT+IEU7DxYncmVVjWUHLfeylZZg4rlp4uc5Q5fWZpMjY9Y/XXrpzLKAF9qKPczQalkulXudPUd3Q==
X-Received: by 2002:a05:6870:1706:b0:296:827c:9073 with SMTP id 586e51a60fabf-296d9eb1feemr8587716fac.26.1732202539131;
        Thu, 21 Nov 2024 07:22:19 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-296518bb670sm4835354fac.12.2024.11.21.07.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 07:22:17 -0800 (PST)
Message-ID: <3e6a574c-27ae-47f4-a3e3-2be2c385f89b@kernel.dk>
Date: Thu, 21 Nov 2024 08:22:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
 <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
 <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
 <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
 <9859667c-0fbf-4aa5-9779-dae91a9c128b@kernel.dk>
Content-Language: en-US
In-Reply-To: <9859667c-0fbf-4aa5-9779-dae91a9c128b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/24 8:15 AM, Jens Axboe wrote:
> I'd rather entertain NOT using llists for this in the first place, as it
> gets rid of the reversing which is the main cost here. That won't change
> the need for a retry list necessarily, as I think we'd be better off
> with a lockless retry list still. But at least it'd get rid of the
> reversing. Let me see if I can dig out that patch... Totally orthogonal
> to this topic, obviously.

It's here:

https://lore.kernel.org/io-uring/20240326184615.458820-3-axboe@kernel.dk/

I did improve it further but never posted it again, fwiw.

-- 
Jens Axboe

