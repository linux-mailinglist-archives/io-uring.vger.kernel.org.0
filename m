Return-Path: <io-uring+bounces-6680-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F18E8A42772
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 17:08:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DE18188B1D6
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 16:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D51261575;
	Mon, 24 Feb 2025 16:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QluamRV4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D7C260A2F;
	Mon, 24 Feb 2025 16:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740413187; cv=none; b=JHv7s2rV2sk4fkuBltCQBH6RXF/UMBK6j9P5RG9+IdQMKmSymHRC8GtmI7B4rQ3/yQF6o2Z/KiUGLLzZkFA4TUPDe3fOHAhDBShtEbpds3HAantqykCPNSrp8b7EB5V7SkAG9Hd49Swm9YJSKmxkzwjhqCnstz4LbCuB3DxOZtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740413187; c=relaxed/simple;
	bh=hn2GItTCSbefNTcILUqmrK0WUi0Y5xp8BAXpMWN4sRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J5Hof0BVZqXgB+4Yhi+ILfq0xsVIYbiHYgU/1O+w8j8F91/XgmyRl/ocHu3I5dRoDyc5CZ8J1ZH8J5e7m8/d39ymW52bWvEbj4J9/cwGmelzeIw0iooxGoGPxbmgA+GbU74BdhsfFRUyroPTUU0MCx1lQp5Gs7OgVTCTgrtqjiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QluamRV4; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-72722d2717aso1235050a34.2;
        Mon, 24 Feb 2025 08:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740413185; x=1741017985; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A+v75veikEqjUToerkHNWQgY+17ObWVQx/28Sr6yLy8=;
        b=QluamRV4hKZoPpc3EnuQFw6HzfnmsP3dQ/c8P2RT4n1A+rZo5CxVqaKlI7R8VWlmeg
         Uo49h2e20/RBttzJlYsXHkt9ZKSSgrFYGfstm79MXBWlx/qRHPD5SWnlEGT08Hy6Jcev
         9ry1LvOK82In6tlW46C8rud3TYqyiTUvG6BOPd4Aw0DVbK2nqRlfEWXUuJTJTg5uw4SE
         IQi8vnEHe4bfaKiKwR8wKLFnL2B1/LvfghTQZY4GBFKnBwwb2woBhaE9fRW79la7nPcO
         Yfj8QpJ+KkcBwxCzXU4C0aI9uBTz+vPScmKU9RJpYVKTStlJuZdY7oJwta9NJHKPQSIB
         RysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740413185; x=1741017985;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A+v75veikEqjUToerkHNWQgY+17ObWVQx/28Sr6yLy8=;
        b=v8+IxSSD6KMXS0II5zefnmRbt8lALC/hmvQ3I2vi1MOY7ESwkr7kPQDxOuh3kDCkLj
         HltMXwsY0e4/cV3HhT9cITrqSOoeTN3BCD7GlSfg35JY9umkYURIC48CO116Tnj34wrT
         2c18/zIA2E9Cxep56jc06XOSNd1xlRIMUm6DCRNXX6didUMiz1X6scAOPCWY8TeNWyVW
         E2mwg7Kev/g0cxlUK/005dYBeFyCuGeq/uvybK//oFbgKX65u1eOCV+ARGg3yqm8xMmW
         dpOe8AhBV6IrBKm0+TfIOvhxFKMhYU/d7LU28NZB5Q2EF472NL3R6SX6x09UhsrmNQPz
         bhzQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/W6Pgr5I/+wSrR/QQTj1O0gMw2vi6+wbTzV9GoygoG75WTQGpbwGVK3pvsjzDRW39p8OM+SI/QztkLlUmhQ==@vger.kernel.org, AJvYcCVjqtc+kho84b9Kr9fAhI4ZNBD2Dwn7aMOoXEnQ2DaIw1EeTRY2Y1qO/1qGvejX+QueuYUq7+LIAdOMcE2d@vger.kernel.org, AJvYcCXS4fTsUVI7bIUEaIN7ZksG5K6Bw1jbDkf1+ojF5d4ig5oeWnmEPfPHEIvu+dIliQXCoQiKkhNFyw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzwS02b8mTzvnDrmy0u8TGeUjmGkOx6K1dmJSeQezv1q8CJcNq2
	GDVpgLkahKWZG88FMC5wGeTsOoFPtL4KLPjFi8a029W6PH1WZ0jydjQch/LDz7g=
X-Gm-Gg: ASbGnctPRCssgAuzU5W4tlIGVqifh46RvQowkgyKYGY48jCigKFEW9ui0lET1SXOAxK
	2IBGLQ5X5JdQWz1RYXfeAoTTQ5QShVS0zwQTrjYvgDsDbuRYNvfr20xreDhEhkj/OlCjhnZfq3J
	wkX6HPs/8q9ygNsPiGTHLJkxHPzOrUGc/6jAkRHDlaBbMNXTExpfO0q70DxmZdWZoRjCYocjnxu
	zA1pz7uPYHQS2VlBhb56ZfatVYdUieyTRUTtj0bO0ywUBwoL+teMrhzOXkoAl3XC1mG+uv48sWD
	s/nQrr5OPi2dy691wZ8scQw5HoM/lJcGlhWPQIOZBGZlR+Xjxu0uyDSRCq33PyDJ5zpsswFxO+x
	bq7ubUJ4oBb5/CQ==
X-Google-Smtp-Source: AGHT+IHVRHpjiMtIlbK0jNEIyLVuWSPhJVxhMvPRiCadwpmq+CIakKL3TutajtIwg9wK6MhYPu93fA==
X-Received: by 2002:a05:6830:2108:b0:727:4494:3d62 with SMTP id 46e09a7af769-7274c17ee7bmr10702521a34.2.1740413185356;
        Mon, 24 Feb 2025 08:06:25 -0800 (PST)
Received: from ?IPV6:2603:8080:1b00:3d:6189:2749:3932:810b? ([2603:8080:1b00:3d:6189:2749:3932:810b])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7273233206fsm3077434a34.57.2025.02.24.08.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 08:06:23 -0800 (PST)
Message-ID: <8e0597b9-d8a9-4d11-8209-ab0f41e94799@gmail.com>
Date: Mon, 24 Feb 2025 10:06:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: Bernd Schubert <bernd@bsbernd.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
 <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
 <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com>
 <CAOQ4uxiSkLwPL3YLqmYHMqBStGFm7xxVLjD2+NwyyyzFpj3hFQ@mail.gmail.com>
 <2d9f56ae-7344-4f82-b5da-61522543ef4f@bsbernd.com>
 <CAOQ4uxjhi_0f4y5DgrQr+H01j4N7d4VRv3vNidfNYy-cP8TS4g@mail.gmail.com>
 <CAJfpegv=3=rfxPDTP3HhWDcVJZrb_+ti7zyMrABYvX1w668XqQ@mail.gmail.com>
Content-Language: en-US
From: Moinak Bhattacharyya <moinakb001@gmail.com>
In-Reply-To: <CAJfpegv=3=rfxPDTP3HhWDcVJZrb_+ti7zyMrABYvX1w668XqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/24/25 6:08 AM, Miklos Szeredi wrote:

> Right, this would be the least complex solution.   We could also add
> an ioctl(FUSE_DEV_IOC_LOOKUP_REPLY), which would work with the
> non-uring API.

Thia would require a major version tick as we can't mantain back compat, 
unless I'm mistaken? If this is the track we want to take, I'm happy to 
send out another patchset with such a change. Would also need more 
extensive hooking into core FUSE request code.

