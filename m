Return-Path: <io-uring+bounces-7684-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CFA4A9991D
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 22:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 404D892107C
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 20:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166D713D2B2;
	Wed, 23 Apr 2025 20:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rJ9vy3Sr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D4E139566
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 20:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745438555; cv=none; b=kVUUrqcdsHDBstHdsEpVtG/yj3Ih2yfpfe5FGxkin6g4mx/t9yvsunlXVVTXlF+JNFyWD2/aSkfBoPzkqybf4Nk5KuRvUN0MHhwJiseSTaZp+UO0jCi9mu4CJwQsLuBhZqiMLnKP/E08vLJ96KDkmaa9lGt8QB/F6+GI0wZfwNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745438555; c=relaxed/simple;
	bh=jDnv7rZ6QieCrVGTnb+TW4twzvT/0cVEhikZMrp5j5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QA68g7EJ2jHeHZZro0I3EMc+Q4I3QS0xIkfidOtkbg55aACAHkw6qjj9b+rPuIvjMGJXGkrr6Rs7sJCwEw1iYw/1EBGb9Q7JIk8VhaMvK4HotHbxuSxY+FsPUCyVbiMh1CVWtGVPHTbcjfHn5IyBUkKmOJY4uFcmzHjH52fpork=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rJ9vy3Sr; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d6d6d82633so1081595ab.0
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 13:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745438551; x=1746043351; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jRljmbUbpUCTeUNbmg+21yt3Z+JZoUMg4zy8t4qbjkQ=;
        b=rJ9vy3SrXq6T1RD+P1xKCq8+g5rVE19OOeKKuPfjZg7g7LAQJ0W1DD6sIWho1JJzyL
         oQDSXDx/NSDzvZ2lA0qL44xcGM36bN39FTxYk6vJFkon6wUseFkilvR3/Dp6NgIwbCBS
         5QiJ9/3Yg7fb8ETXM8ra7MwmBnZBdlokrKnY4jO9ANky3b8vTI09xIyQ1FFD4XPaerT+
         gjYBQAtGbUFxgd40kSfNmhXohn72N/l7Imk3YmDFkbApUEmxvur+X1u46h0/Gk/NM9DO
         Af3JBdOuQTShsgXXw+ocUFudYZj7QS6p3gb4zik06ODdH5Is1pR36RVP/cYtLxIRvrAv
         RC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745438551; x=1746043351;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jRljmbUbpUCTeUNbmg+21yt3Z+JZoUMg4zy8t4qbjkQ=;
        b=kXxQoHVNz5dGbhuvm93ggs2W+oE71tvhSHq9vLj9QNSCIG/OmHotlq2asJ+fM1dDM3
         teS8+FuTOoKw0JJuyaZgcJqTPU6fc384N7lFh0sMbhLCze76/ZYthf9iWaFtygAZfL8o
         KQkYnQTlEdTOAiMo+EO/+X9LLfrT2Zj0y9qCp5UCYvtbUl7UUjMdAG2dxfr5zUrG/pmb
         kvCN94163WEclNRfrBaFIU39zAkgXFWl1FOnT28m9D3vV3dvVbnzxO2bSJRNA2JEOsN8
         mHih4MgFnCfrLK+SzuenUInLLR+QX2bkBEXPrNuVmmJYRBgxgjisyn91hhOFGf8vWL8Z
         Uscg==
X-Gm-Message-State: AOJu0YxlOcHJlAufKoWXC5RBK2ZRSHbGR0HC6G8gDYeUMhjhl3ug+KzG
	8jmyBnzF5NLsfbbShgdfKWC248XhhywT2fd8YUtVGRple/sgTcI2CEKfaf2ySoE=
X-Gm-Gg: ASbGnctmyr32vZTHHGeFXro+meJ5bVVZjwu2YD/W31tACEI1jRv+nxovePtMGUs8bMZ
	SU6DoAw852bdtOhc6Ho9vjx/8CzlxJkWPnhkghxOxNqHzhWEy1geWw8BYRsU9No23AxeCKgO+LD
	UcWs6aJewsbDDUOhXyrgtp2rEYH9kx6/y2v7ZmrBPhtKsIx9iQXP/+euJMQNrqwAJFnUO9b2hGk
	hLOG6Ygf7uB0BxPMJrumJNQHW0kIZU4v/2GgMsPPMdRKmx09RLoG4oFuHY+0QdPzhWmmDWC9Znq
	vMbfSyYg63W/+bQ8UeIi3Mj71GafT8iJB2oA
X-Google-Smtp-Source: AGHT+IGOyxuRh6cEYMTc5BPN8f30n+XMkGgoz5IxZnpwHxZJEELRKxNtbr4t2DWdfDaY1GdybDOFdQ==
X-Received: by 2002:a05:6e02:ee7:b0:3d8:1e96:1e2 with SMTP id e9e14a558f8ab-3d92eaf324emr8989065ab.20.1745438551156;
        Wed, 23 Apr 2025 13:02:31 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d92758f9f2sm5169225ab.7.2025.04.23.13.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 13:02:30 -0700 (PDT)
Message-ID: <8380162d-98a1-4871-a0a2-608aed035c66@kernel.dk>
Date: Wed, 23 Apr 2025 14:02:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 3/3] test/fixed-seg: Support non 512 LBA format
 devices.
To: Anuj gupta <anuj1072538@gmail.com>, Nitesh Shetty <nj.shetty@samsung.com>
Cc: io-uring@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com
References: <CGME20250423133646epcas5p2e67808b13c6c85444b8a9f28995fe70b@epcas5p2.samsung.com>
 <20250423132752.15622-1-nj.shetty@samsung.com>
 <20250423132752.15622-4-nj.shetty@samsung.com>
 <CACzX3AtPziqFXmFvysyfCSLuZhGzppxs7k1WbHgrQweSn7V_zw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACzX3AtPziqFXmFvysyfCSLuZhGzppxs7k1WbHgrQweSn7V_zw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/23/25 1:05 PM, Anuj gupta wrote:
>> +       ioctl(fd, BLKSSZGET, &vec_off);
> 
> nit: vec_off might be better named as block_size or lba_size to better
> reflect its use

Agree, and would be nice to have an error check on ioctl as
well, just to be prudent.

I'll apply this series as-is, as it's mostly just nits.

-- 
Jens Axboe


