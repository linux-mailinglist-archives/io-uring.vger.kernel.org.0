Return-Path: <io-uring+bounces-5354-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C041F9EA0ED
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 22:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56E541668B3
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 21:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4800919D093;
	Mon,  9 Dec 2024 21:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EX99a9N2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC5C19B5BE
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 21:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733778830; cv=none; b=h7vE0NXBl1MxpmwRapfHizIoO/PGkfmyMSAGlwwMHqmu5yJi6sE0RihfvEkwE0K9P0LOBKrGrLQfPXtOg6AyEDQQSqFrKnnGeMLlAkKo5Kd8KdmZ8ZRq2GL02xs8gw9U8LnJP5Y/0ImSyIX1PWPK/o57dddbnzmUwpI8FVjOlt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733778830; c=relaxed/simple;
	bh=NHf4zQZ1guLHSVFEyaYqwJHGnh4DR//biRYgCiS5f34=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=q4HxbZaYjodxnDxjdPveXpVR1C3ufqD4aNTnigWmj63SrDadID9Z72r2ZtpPHoEnMlZJAhaplnUCzCgD4HGRydJu6+XCIP5o7NrpkPtBTkCm9wAqdKhjA9956NgefsLWNWjPgBYkaFaThXMUrPsqwfD/iBa3dCYYkk+d74VQedM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EX99a9N2; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-435004228c0so6950725e9.0
        for <io-uring@vger.kernel.org>; Mon, 09 Dec 2024 13:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733778827; x=1734383627; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pjppuwRNGRfKc20bu5r5ntnx3dVlzentUmiO0zMtJ+g=;
        b=EX99a9N2CYZyC6KB+vQL7nPsXFQAsIHK8D9KNo2KXoWRDlswrF0N3CEJPNEjRGNPXz
         5k/1vYJNiqCBePkVTvnZWJ+RKM3L6NQsrVsIJSJ48KPGhMr8V3R8TbSJaNWYxVHma75x
         PHgeG7HBTyf/3TZYDxoaZaoFQ0zL8C5U64zbmUe7fBrOuwa/+26kLABiOIIGNNhI/En3
         ABrccl6a1KBABnecOjwlXvnmiufQCcKni6FFlPpm4Hht55kcj98vOrhOJiJ8ggDjSvI6
         /choKnlcppR8h/+GjMP2SuJswL7YfVLHLsBj7fG1X+T44vWyqqOgaFFjUF8S4r5WRIEH
         RU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733778827; x=1734383627;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pjppuwRNGRfKc20bu5r5ntnx3dVlzentUmiO0zMtJ+g=;
        b=eCfeKTtH26yxrNhhn+bhYMzeXGMzfHdBxwXB8cnayqtc+xulImNvE2jwUsxmAzspzD
         TO7uGGskbdLuXwvicIiZLaQJh1Ldzy0zjvh8KXfbhsmH6IvTQavLik1+LmAC3X5q9jGG
         4ASYvwT1IRawhPJJDTYKDZCD+iSwcAi5XHKv6MrasqknlMKs77YWOL7gJXYtsui5rJ49
         yKOnlB2y2RDCXecHA8K67/LLLs4bWI47GaYd9BkBYQKjQNnOX89127UZLnqHnx9tBGUJ
         OncRImLoBHadEycQwGf/Eqm/gGZ9B0/00KE13RMsWn+Ndh3V5V7Z/oAEzLsRZSW8AB3T
         k0pQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6ZDqjV35mxFbnO0U5eR6eB0hVa72uOucqfFPB4yxBZ93n/FKnp7Xv7h6q674mI6I204jaysyTkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxcAIv4fY2oOHd/rXJnKSCDTgjiuL8SSdHkkoatbJqywAwu2TCy
	U2BqtHvczxbwNva4S0tGiPgkyk04qpCzxq4YvSZYqvvVzQnJ/5n3
X-Gm-Gg: ASbGnctZniabM8DI/w3rUOj+Khov8lmhlZucI07WqqF1xhOhl+QoI60jO+pQYoSl9Mb
	MftLNx4GSKI33WrXj95C+qNOsMyBrLRzNOBZ7LEzFVKlAEms2qlmv5wXo18lu9foxNjwefmN4F8
	OFqVJLwZSE8kiU/GBRXSFurp7IeygfEUBVCfhJ7xxk+sOBn3UgDJTwb/pX+/k4k//tkTLYiuQLP
	/NwglGPGgRP2BrpFNIJ8rE0RQwdXGUAdZ9QrxYF76d5dPz6BJzhiTywH5bRZwY=
X-Google-Smtp-Source: AGHT+IFWc65/sUgE6zxRJMTAbK7UQ/a7JiX+sI43xLCr9YLpH3nk61rzPOMS18QEGUdfDnTy9Bx+NA==
X-Received: by 2002:a05:600c:3b04:b0:434:a706:c0fb with SMTP id 5b1f17b1804b1-434fff3dcfbmr28133325e9.10.1733778826433;
        Mon, 09 Dec 2024 13:13:46 -0800 (PST)
Received: from [192.168.42.90] ([85.255.235.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434e83f3958sm104544125e9.25.2024.12.09.13.13.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 13:13:46 -0800 (PST)
Message-ID: <99c548cd-b384-475d-b16d-07bfb7ba4a80@gmail.com>
Date: Mon, 9 Dec 2024 21:14:40 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 0/4] test kernel allocated regions
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <cover.1731987026.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1731987026.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 23:39, Pavel Begunkov wrote:
> Patch 1 excersices one additional failure path for user provided regions,
> and the rest test kernel allocated regions.

This set should still be good to go, I've been testing with it
all along.


> Pavel Begunkov (4):
>    tests/reg-wait: test registering RO memory
>    test/reg-wait: basic test + probing of kernel regions
>    test/reg-wait: add allocation abstraction
>    test/reg-wait: test kernel allocated regions
> 
>   test/reg-wait.c | 181 +++++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 147 insertions(+), 34 deletions(-)
> 

-- 
Pavel Begunkov


