Return-Path: <io-uring+bounces-1542-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 488888A463C
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 02:07:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEE761F21224
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 00:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33E7193;
	Mon, 15 Apr 2024 00:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RUryBFl/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246BB632;
	Mon, 15 Apr 2024 00:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713139659; cv=none; b=qNfW1feUvafM+dpD2Upf2oJ9gGG7y6hLKWSBeHbCkXrwA2MiGxuUPDO/Uq1jZeor43Cnn16wWKrkhn24FgC4smEsNFWBKquOAaBRSkHoiv8jw/P85T+Bdu+PwEH2bBoEehbbMNBokpFPuzWNFKwDFuz+oXg9WAhhFiXu9/iQcjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713139659; c=relaxed/simple;
	bh=Mbs8SxUCN6ksuIMCWRHIsPhtrZvLxKb0GRV8AHjDBDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m3pVOcRBpWKy/Ox52QxFDb2qaX3FVEW73xrMrOzkEfeWAFFsG0bAkwygfkHf8H084ByiwxNvh5Efjl1JwCnBBw4/Sg3jiLX01kV57L/yyfZZfP+65AvG3O3eAZtHRSWBmCFBZCmunEGVkxE+D5Wh7B+RCSGL7pYqPQkdTtz3N44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RUryBFl/; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-518bad5f598so1050068e87.2;
        Sun, 14 Apr 2024 17:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713139656; x=1713744456; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jnGK0XnUkumyjskU+9LPJnYMLGW1Wf3VSgO3SupSOik=;
        b=RUryBFl/Yo5uURo5iJfbgfnMum/+NqfJ0vMXqiJTKm4vbKvH88yyNzmYRa8VavGPPe
         kR9CUbyn98YUo9Tg6xaAgZTwDTA6YYuTKmOhmdfNY8XJZDhjvAnXlvyy3JEWp1JBYziE
         /2noXhsH/3PPGOwd3OY5dPBRXsWJBHKvBAuVgp93M+K5V0/IZb6TM8aXZ2l58ilnJGch
         oquEMl9tbbS/3VEE2GhZjnLGAN3BsyYZ6Krqh4FhbzE1xJ7P8HWClU0R9yHJ8O+BM6QM
         9FCuypIRDJFiDviLsmxBXMEeqJAAxX7IhxkUM6rXwi2Drj/zjhYZH4bAXVafMLSIDNF3
         fXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713139656; x=1713744456;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jnGK0XnUkumyjskU+9LPJnYMLGW1Wf3VSgO3SupSOik=;
        b=djiiJyDdIVZeNWYsrUp2yh9l3dmvIG5e2/H2gPL30uZRJeYEBemRzO6S7dVhpPINHs
         A98baNvKz4rheQlxyXlL8BEJjJ03bs1Cy0VgkHmanjwjFpBX9YU/NUVmy9WP39LUTYIa
         hMaJYqodRDNxGFD+quya4kRVKLNDy5mVH+wsRH045tn4OAszxGWEiZq6SHYsWWuTg81A
         YrQuTXoDMs2b7I9h9F6/RnE1drzh97wTVJlrOEVjnLX75s9uIOG59szEjJ6UaUtv7uwx
         w1vxnrLReDMbUYyCyKAG3LeDPr8RjgbErjZWJCtGX3heSU8ufOTT1OlXt9h1e5yLFz7N
         YlTg==
X-Forwarded-Encrypted: i=1; AJvYcCWM5+Yd8b7u3QJTuTleYZv0TfVqX9o/GDKDLTRSWepps9jJ8RdVdtJ5RXH5gtOuQnnPLa+AJXBtLCsEkGSodh/Fktf78JAg80AlUk+wybZ8INIol0fRsgST10kT75JHjcI=
X-Gm-Message-State: AOJu0YwdeO5jiuK8Hsm6gISTE5VRyc+r41Jzz5GzfE2RD1yb1INyIT8h
	dFqI6XJ/huwycJNsQazvqvFcCFqc3R76gozCuHGeOS5QWW/3RGtT
X-Google-Smtp-Source: AGHT+IHoYNiUHthxkjY8UfooAy3/UuyjhN/wfs8gcQ13EZWGYJE06Bckj2dsnx2NBBNwhn7F1UfFXg==
X-Received: by 2002:ac2:5b47:0:b0:518:17ad:a6e0 with SMTP id i7-20020ac25b47000000b0051817ada6e0mr5161387lfp.51.1713139656006;
        Sun, 14 Apr 2024 17:07:36 -0700 (PDT)
Received: from [192.168.42.114] ([85.255.232.172])
        by smtp.gmail.com with ESMTPSA id c12-20020a5d4ccc000000b00343f662327bsm10425886wrt.77.2024.04.14.17.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Apr 2024 17:07:35 -0700 (PDT)
Message-ID: <8b329b39-f601-436b-8a17-6873b6e73f91@gmail.com>
Date: Mon, 15 Apr 2024 01:07:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/6] net: extend ubuf_info callback to ops structure
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
 Eric Dumazet <edumazet@google.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <62a4e09968a9a0f73780876dc6fb0f784bee5fae.1712923998.git.asml.silence@gmail.com>
 <661c0d589f493_3e773229421@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <661c0d589f493_3e773229421@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/24 18:07, Willem de Bruijn wrote:
> Pavel Begunkov wrote:
>> We'll need to associate additional callbacks with ubuf_info, introduce
>> a structure holding ubuf_info callbacks. Apart from a more smarter
>> io_uring notification management introduced in next patches, it can be
>> used to generalise msg_zerocopy_put_abort() and also store
>> ->sg_from_iter, which is currently passed in struct msghdr.
> 
> This adds an extra indirection for all other ubuf implementations.
> Can that be avoided?

It could be fitted directly into ubuf_info, but that doesn't feel
right. It should be hot, so does it even matter? On the bright side,
with the patch I'll also ->sg_from_iter from msghdr into it, so it
doesn't have to be in the generic path.

I think it's the right approach, but if you have a strong opinion
I can fit it as a new field in ubuf_info.

-- 
Pavel Begunkov

