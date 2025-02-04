Return-Path: <io-uring+bounces-6251-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3FB9A2719E
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 13:15:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B0D0161BF2
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 12:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4599F20C471;
	Tue,  4 Feb 2025 12:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KbF/TES6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646FB20A5D0;
	Tue,  4 Feb 2025 12:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738670864; cv=none; b=kxprdvENDA8M85MnrLdVKc26VQJuwwydE9UFoDm/WFXczOlBq2J5G/sFD3WJO7Nocq7vNaTR4N/P9uudsSnfFyNhnPJj6vX7hTfIpyul42R+WK9u1QBtO567poqSO5L28Te6k3sjh9u4C7Ke9240tgfESzRwB7J81ycRIkm1tEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738670864; c=relaxed/simple;
	bh=XHis7drr2Yzfqgz5XMMDP/yqTuxfSR/vKodVkQLlAeY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ZnJcG7Nk8+YUSdfUKcEW4syUvvWOXTQglgJ9kQ1MnLwtK/6h6UNKwy8JCcLQZdsO6FucXDmDqE+szcT1GcRE+7EJ9NJ0tGI4BTGEHLfEjBeOr7SRP+7tJkzYo54mTAMITzLiF079B0xBwb+f1er+2LJIudr1q/pYn3w6s0f1MYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KbF/TES6; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5dcc38c7c6bso1311704a12.1;
        Tue, 04 Feb 2025 04:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738670860; x=1739275660; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zC0h+Malv/IZQBMhiFPoJ8mi0B/DboCa78AGsumItOY=;
        b=KbF/TES6RpXS/i+CbMbET7kCi8FQR31Yo60ZoWAva3lYqp8zmd66BpRSALTN+uRhWY
         0eHhn+Ixqp7FI6Ra6CO6yKcTiyQmiMk0rt8Msv0wVe8OUIcRaVED2c2yGiKHD/2DpL65
         e/DIxnJ3v9DInLzXuukr0rK0EVa5bcEdQG8Oz5hij5SCz41n7MNuL0DVIxR+G41z/uCt
         r4lEHh4TwDPP40vCQs3libNMmAv9kooW+5iLDS0DIKiu4gXdb+PLyFOiKedahppT2sfs
         aCseF5xRs7bcV29OK1xmiXomj0GMASlf5doFr1XLgdecrNfklvzRlbYengcqiatVZ8qz
         UwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738670860; x=1739275660;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zC0h+Malv/IZQBMhiFPoJ8mi0B/DboCa78AGsumItOY=;
        b=OVcROqzwCUdO4DwuILzwkyNF30Jy1STaRku38nKrVTNDiYHMk0A+VVhiPJrSj/IVfZ
         sO35Sg0vBcdkkERXuEJqi1PBKqqAvO1aOhoZsq3F/fbXwovUwyfua7ZB7kxBNMNnbV3y
         MV3akWGCefUV61+o5xwUNjDnnx6gzKEcnoRYUIdKYyVXTolzmARcTJ9W0PchfXBbIkHc
         Aphoc9PjiU0dH6a7X0IMpmMNlxuCImTqVXDRUMdUu0BNe9ch0OeyYfGzMnp8zyz/eA1o
         swnNMjuOWWKAAmngpvgRd3wFia/pGzNLsajtKEobyfFerP8uixiUTKopoCulWr/cm6ND
         wutA==
X-Forwarded-Encrypted: i=1; AJvYcCVJX7YEfBsHvtgrbCbjClgQc2n2Wt2LqjXzoWtOFJBuPiAotjBGG1fHglf5axg2VC67GDodazKnUg==@vger.kernel.org, AJvYcCW/DQ4xTXI7JjTKfOXtKEE5TZ1f+TS3U08giCCK9forQHJzZK9/5oGZMfqK3qYnxGs+pZA0moQOjvKICKq1@vger.kernel.org
X-Gm-Message-State: AOJu0YyWn2pNKYK5RBYshACed4+QBN0NkVbZxyRzRDb0K0eRQy/DZ5We
	0EIUPBrrPawdWq/LN9KxXAOH5DsCTUrfy5pkIbcnwFJ06ktdFYJbfO0YAQ==
X-Gm-Gg: ASbGncucr7pUot5F3Nrex1k7LpnVg4IgY+BdI4ZdIrDh6NOES1tCrOA5kueqWZpA+S9
	ilE7MbMlKyP1JsrN6Ua+6AgvDJ0YWYLds98aLooV1PNTVr9chaNZweiK0m/0E3imo5KGVlQyW9C
	aKK6zKZhXuu/XZJTjZ4l5kkTRLy8q85LXEAyXhN2rZzhy47Q3UIVmXX+jRIsJIXqjB/PjYcLKQN
	FQ3xzB7vioa8pGKyYvM0yfK1iTWzMAcFqNY9hX3su7Z7HE9tlXb1bGejSPGtXiUnRcvyhrWS+NA
	ExTOd3LyjzBZD9DJzfCRBKDiX//A8ImyDTJ/51Uy4kxa+Vbp
X-Google-Smtp-Source: AGHT+IFJHBjd0ggnYbSHfFQ3UWkg86cW/0gBU02f6WgJB9dDut/kOwWlRCyj5ZfGv28xA+70YgwqqA==
X-Received: by 2002:a17:907:9728:b0:aa6:8bb4:503b with SMTP id a640c23a62f3a-ab6cfe12dfcmr2732454966b.55.1738670860384;
        Tue, 04 Feb 2025 04:07:40 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:f9be])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e47a7b1asm910914666b.31.2025.02.04.04.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 04:07:39 -0800 (PST)
Message-ID: <fcf5df70-d709-4bec-b4ce-aa833d1d4da2@gmail.com>
Date: Tue, 4 Feb 2025 12:07:49 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] io_uring: cache io_kiocb->flags in variable
From: Pavel Begunkov <asml.silence@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-8-max.kellermann@ionos.com>
 <a7733b94-c7c0-4e95-975d-e45562d54f3f@gmail.com>
Content-Language: en-US
In-Reply-To: <a7733b94-c7c0-4e95-975d-e45562d54f3f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/25 19:11, Pavel Begunkov wrote:
> On 1/28/25 13:39, Max Kellermann wrote:
>> This eliminates several redundant reads, some of which probably cannot
>> be optimized away by the compiler.
> 
> Let's not, it hurts readability with no clear benefits. In most cases
> the compiler will be able to optimise it just where it matters, and
> in cold paths we're comparing the overhead of reading a cached variable
> with taking locks and doing indirect calls, and even then it'd likely
> need to be saved onto the stack and loaded back.
> 
> The only place where it might be worth it is io_issue_sqe(), and
> even then I'd doubt it.

Jens, I'd suggest to drop it out of the tree, for the reasons above.

-- 
Pavel Begunkov


